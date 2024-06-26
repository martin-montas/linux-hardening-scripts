# Remediation is applicable only in certain platforms
if [ ! -f /.dockerenv ] && [ ! -f /run/.containerenv ]; then

# List of log file paths to be inspected for correct permissions
# * Primarily inspect log file paths listed in /etc/rsyslog.conf
RSYSLOG_ETC_CONFIG="/etc/rsyslog.conf"
# * And also the log file paths listed after rsyslog's $IncludeConfig directive
#   (store the result into array for the case there's shell glob used as value of IncludeConfig)
readarray -t OLD_INC < <(grep -e "\$IncludeConfig[[:space:]]\+[^[:space:];]\+" /etc/rsyslog.conf | cut -d ' ' -f 2)
readarray -t RSYSLOG_INCLUDE_CONFIG < <(for INCPATH in "${OLD_INC[@]}"; do eval printf '%s\\n' "${INCPATH}"; done)
readarray -t NEW_INC < <(awk '/)/{f=0} /include\(/{f=1} f{nf=gensub("^(include\\(|\\s*)file=\"(\\S+)\".*","\\2",1); if($0!=nf){print nf}}' /etc/rsyslog.conf)
readarray -t RSYSLOG_INCLUDE < <(for INCPATH in "${NEW_INC[@]}"; do eval printf '%s\\n' "${INCPATH}"; done)

# Declare an array to hold the final list of different log file paths
declare -a LOG_FILE_PATHS

# Array to hold all rsyslog config entries
RSYSLOG_CONFIGS=()
RSYSLOG_CONFIGS=("${RSYSLOG_ETC_CONFIG}" "${RSYSLOG_INCLUDE_CONFIG[@]}" "${RSYSLOG_INCLUDE[@]}")

# Get full list of files to be checked
# RSYSLOG_CONFIGS may contain globs such as
# /etc/rsyslog.d/*.conf /etc/rsyslog.d/*.frule
# So, loop over the entries in RSYSLOG_CONFIGS and use find to get the list of included files.
RSYSLOG_CONFIG_FILES=()
for ENTRY in "${RSYSLOG_CONFIGS[@]}"
do
	# If directory, rsyslog will search for config files in recursively.
	# However, files in hidden sub-directories or hidden files will be ignored.
	if [ -d "${ENTRY}" ]
	then
		readarray -t FINDOUT < <(find "${ENTRY}" -not -path '*/.*' -type f)
		RSYSLOG_CONFIG_FILES+=("${FINDOUT[@]}")
	elif [ -f "${ENTRY}" ]
	then
		RSYSLOG_CONFIG_FILES+=("${ENTRY}")
	else
		echo "Invalid include object: ${ENTRY}"
	fi
done

# Browse each file selected above as containing paths of log files
# ('/etc/rsyslog.conf' and '/etc/rsyslog.d/*.conf' in the default configuration)
for LOG_FILE in "${RSYSLOG_CONFIG_FILES[@]}"
do
	# From each of these files extract just particular log file path(s), thus:
	# * Ignore lines starting with space (' '), comment ('#"), or variable syntax ('$') characters,
	# * Ignore empty lines,
	# * Strip quotes and closing brackets from paths.
	# * Ignore paths that match /dev|/etc.*\.conf, as those are paths, but likely not log files
	# * From the remaining valid rows select only fields constituting a log file path
	# Text file column is understood to represent a log file path if and only if all of the
	# following are met:
	# * it contains at least one slash '/' character,
	# * it is preceded by space
	# * it doesn't contain space (' '), colon (':'), and semicolon (';') characters
	# Search log file for path(s) only in case it exists!
	if [[ -f "${LOG_FILE}" ]]
	then
		NORMALIZED_CONFIG_FILE_LINES=$(sed -e "/^[#|$]/d" "${LOG_FILE}")
		LINES_WITH_PATHS=$(grep '[^/]*\s\+\S*/\S\+$' <<< "${NORMALIZED_CONFIG_FILE_LINES}")
		FILTERED_PATHS=$(awk '{if(NF>=2&&($NF~/^\//||$NF~/^-\//)){sub(/^-\//,"/",$NF);print $NF}}' <<< "${LINES_WITH_PATHS}")
		CLEANED_PATHS=$(sed -e "s/[\"')]//g; /\\/etc.*\.conf/d; /\\/dev\\//d" <<< "${FILTERED_PATHS}")
		MATCHED_ITEMS=$(sed -e "/^$/d" <<< "${CLEANED_PATHS}")
		# Since above sed command might return more than one item (delimited by newline), split
		# the particular matches entries into new array specific for this log file
		readarray -t ARRAY_FOR_LOG_FILE <<< "$MATCHED_ITEMS"
		# Concatenate the two arrays - previous content of $LOG_FILE_PATHS array with
		# items from newly created array for this log file
		LOG_FILE_PATHS+=("${ARRAY_FOR_LOG_FILE[@]}")
		# Delete the temporary array
		unset ARRAY_FOR_LOG_FILE
	fi
done

# Check for RainerScript action log format which might be also multiline so grep regex is a bit
# curly:
# extract possibly multiline action omfile expressions
# extract File="logfile" expression
# match only "logfile" expression
for LOG_FILE in "${RSYSLOG_CONFIG_FILES[@]}"
do
	ACTION_OMFILE_LINES=$(grep -ozP "action\s*\(\s*type\s*=\s*\"omfile\"[^\)]*\)" "${LOG_FILE}")
	OMFILE_LINES=$(echo "${ACTION_OMFILE_LINES}"| grep -aoP "File\s*=\s*\"([/[:alnum:][:punct:]]*)\"\s*\)")
	LOG_FILE_PATHS+=("$(echo "${OMFILE_LINES}"| grep -oE "\"([/[:alnum:][:punct:]]*)\""|tr -d "\"")")
done

# Ensure the correct attribute if file exists
FILE_CMD="chgrp"
for LOG_FILE_PATH in "${LOG_FILE_PATHS[@]}"
do
	# Sanity check - if particular $LOG_FILE_PATH is empty string, skip it from further processing
	if [ -z "$LOG_FILE_PATH" ]
	then
		continue
	fi
	$FILE_CMD "4" "$LOG_FILE_PATH"
done

else
    >&2 echo 'Remediation is not applicable, nothing was done'
fi
