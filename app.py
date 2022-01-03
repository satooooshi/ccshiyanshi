from flask import Flask
app = Flask(__name__)


import socket


pageTemplate = '''
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html; charset=ISO-8859-1"
 http-equiv="content-type">
  <title>Hello</title>
</head>
<body>
Hello, {person}!
</body>
</html>'''

# Function to display hostname and
# IP address
def get_Host_name_IP():
    try:
        host_name = socket.gethostname()
        host_ip = socket.gethostbyname(host_name)
        print("Hostname :  ",host_name)
        print("IP : ",host_ip)
    except:
        print("Unable to get Hostname and IP")

# Driver code
# get_Host_name_IP() #Function call

@app.route('/')
def hello_world():
    print('Hello, SJTU!')
    app.run(debug=True, host='0.0.0.0')
    get_Host_name_IP()
    return 'Hey, we have Flask in a Docker container!\n'+socket.gethostname()+'\n'+socket.gethostbyname(socket.gethostname())+'\n'
