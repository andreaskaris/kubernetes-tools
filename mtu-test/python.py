from http.server import BaseHTTPRequestHandler, HTTPServer
from urllib import parse
from random import choice
from string import ascii_lowercase
import logging

class handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type','text/html')
        self.end_headers()

        mtu="100"

        path = self.path
        o = parse.urlparse(path)
        qs = parse.parse_qs(o.query)
        if 'mtu' in qs:
            mtu = qs['mtu'][0]
        string_val = "".join(choice(ascii_lowercase) for i in range(int(mtu)))

        logging.warning("Sending response %s\n" % string_val)
        self.wfile.write(bytes(string_val, "utf8"))

print("Starting server")
with HTTPServer(('', 9888), handler) as server:
    server.serve_forever()
