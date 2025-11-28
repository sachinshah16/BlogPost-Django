import smtplib
from email.message import EmailMessage
import ssl
import os
from dotenv import load_dotenv

# Load environment variables from the .env file
load_dotenv()

def send_email(subject, body):
    """
    Sends an email using Gmail's SMTP server with credentials loaded from 
    environment variables.
    
    Args:
        subject (str): The subject line of the email.
        body (str): The main content of the email.
        recipient (str): The email address of the recipient.
        
    Returns:
        bool: True if the email was sent successfully, False otherwise.
    """
    # 1. Retrieve Credentials from Environment
    EMAIL_ADDRESS = os.getenv('EMAIL_ADDRESS')
    EMAIL_PASSWORD = os.getenv('EMAIL_PASSWORD') # This must be your App Password

    recipient = "123nihcas+django@gmail.com"

    if not EMAIL_ADDRESS or not EMAIL_PASSWORD:
        print("ERROR: Email credentials not found in environment variables.")
        return False

    # 2. Construct the Email Message
    msg = EmailMessage()
    msg['Subject'] = subject
    msg['From'] = EMAIL_ADDRESS
    msg['To'] = recipient
    msg.set_content(body)

    # Define the security context for SSL
    context = ssl.create_default_context() 

    # 3. Connect and Send with Error Handling
    try:
        # Connect to the Gmail SMTP server on port 465 (SMTP over SSL/TLS)
        with smtplib.SMTP_SSL('smtp.gmail.com', 465, context=context) as server:
            # Log in
            server.login(EMAIL_ADDRESS, EMAIL_PASSWORD)
            
            # Send the email
            server.send_message(msg)
            print(f"SUCCESS: Email '{subject}' sent to {recipient}.")
            return True

    except smtplib.SMTPAuthenticationError:
        print("ERROR: Authentication failed. Check your App Password.")
        return False
    except smtplib.SMTPException as e:
        print(f"ERROR: SMTP server error occurred: {e}")
        return False
    except Exception as e:
        print(f"ERROR: An unexpected error occurred: {e}")
        return False

# --- Example Usage ---
if __name__ == '__main__':
    # You would typically get the recipient from a config file or user input
    
    # Define the content to pass to the function
    email_subject = "Automated Report from Python Script"
    email_body = (
        "Hello,\n\n"
        "This is the weekly status report generated automatically.\n"
        "All systems are operational.\n\n"
        "Regards,\n"
        "The Python Bot"
    )

    send_email(email_subject, email_body)