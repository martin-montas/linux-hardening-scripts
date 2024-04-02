#!/usr/bin/python

#   the password should be an special one for 2 factor authentification
#   it shouldn't be the standard one that is usually used. for more info
#   watch this youtube video 
#   link:https://www.youtube.com/watch?v=g_j6ILT-X0k&t=427s

from apscheduler.schedulers.blocking import BlockingScheduler
import subprocess
import os
from email.message import EmailMessage
import smtplib
import ssl

MAIL_SENDER =   '<YOURMAIL>'
MAIL_PASS   =   '<YOUR-PASSWORD>'
MAIL_TO =   '<MAIL_TO_SEND>'

subject = 'subject'

body = '''

    blah...

'''
def get_shell_output():

    # gets the size of the disk with the df utility
    p = subprocess.run('df -H | grep /$ -P',shell=True,capture_output=True,text=True)

    # splits the variables for easy parsing
    out = p.stdout.split()
    out_percent = out[4].replace('%','')

    # makes sure the threshold of the disk is above
    if int(out_percent) >= 50:
        return True

    # if its below the threshold
    else:
        return False

def main():

    SEND_EMAIL = get_shell_output()
    if SEND_EMAIL:
        em = EmailMessage()
        em['From'] = MAIL_SENDER
        em['To'] =  MAIL_TO
        em['Subject'] = subject
        em.set_content(body)
        context  = ssl.create_default_context()

        with smtplib.SMTP_SSL('smtp.gmail.com',465, context=context) as smtp:

            smtp.login(MAIL_SENDER, MAIL_PASS)
            smtp.sendmail(MAIL_SENDER,MAIL_TO,em.as_string())

    else:
        pass



if __name__ == '__main__':
    main()

