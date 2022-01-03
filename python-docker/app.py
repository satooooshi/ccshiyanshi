from flask import Flask
app = Flask(__name__)

import socket

@app.route('/')
def hello_world():
    app.run(debug=True, host='0.0.0.0')
    try:
        host_name = socket.gethostname()
        host_ip = socket.gethostbyname(host_name)
    except:
        print("Unable to get Hostname and IP")
    return 'Hello, SJTU! Hostname: '+host_name+' IP: '+host_ip
