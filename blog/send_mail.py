import smtplib
from email.message import EmailMessage


def send(message):
    SMTP_PORT = 587
    SMTP_SERVER = 'smtp.gmail.com'
    
    email = EmailMessage()
    
    email['Subject'] = "Test my app"
    email['From'] = "example@gmail.com"
    email['To'] = "sachin@gamil.com"
    
    email.set_content("")
    
    