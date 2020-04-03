import requests
from flask import Flask, request
from twilio.twiml.messaging_response import MessagingResponse

app = Flask(__name__)

@app.route("/mms", methods=['POST'])
def sms_reply():
    """Respond to incoming multimedia messages with a confirmed download text."""
    if request.form['NumMedia'] is not None:
        urls = [request.form['MediaUrl' + str(idx)] for idx in range(int(request.form['NumMedia']))]
    photos = {url.split("/")[-1]: requests.get(url) for url in urls}
    for identifier, photo in photos.items():
        with open(identifier + '.jpg', 'wb') as f:
            f.write(photo.content)
    resp = MessagingResponse()
    resp.message("Upload received!")
    return str(resp)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=9092, debug=True)
