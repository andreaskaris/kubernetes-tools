from http.server import BaseHTTPRequestHandler, HTTPServer
import time

sleep_for = 10
start_time = time.time()

class handler(BaseHTTPRequestHandler):
    def do_GET(self):
        while time.time() - start_time < sleep_for:
          time.sleep(1)
        self.send_response(200)
        self.send_header('Content-type','text/html')
        self.end_headers()
        self.wfile.write(bytes("OK!", "utf8"))

print("Starting server")
with HTTPServer(('', 8000), handler) as server:
    server.serve_forever()
