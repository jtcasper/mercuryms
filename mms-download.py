import os
import sqlite3
from flask import Flask, request
from twilio.twiml.messaging_response import MessagingResponse

app = Flask(__name__)

@app.route("/mms", methods=['POST'])
def sms_reply():
    """Respond to incoming multimedia messages with a confirmed download text."""
    sender = request.form['From']
    if request.form['NumMedia'] is not None:
        urls = [request.form['MediaUrl' + str(idx)] for idx in range(int(request.form['NumMedia']))]

    conn = sqlite3.connect("mercuryms.sqlite")
    cursor = conn.cursor()
    for url in urls:
        cursor.execute('INSERT INTO MEDIA (PHONE_NUMBER, URI) VALUES (?, ?)', (sender, url))
    conn.commit()
    conn.close()

    resp = MessagingResponse()
    resp.message("Upload received!")
    return str(resp)

if __name__ == '__main__':
    env_port = os.environ.get("MERCURYMS_PORT")
    port = int(env_port) if env_port is not None else 9092
    app.run(host='0.0.0.0', port=port, debug=True)
