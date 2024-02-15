import sys
from http.server import SimpleHTTPRequestHandler, HTTPServer

class CustomHandler(SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header('Access-Control-Allow-Origin', '*')
        super().end_headers()

def run_server(port, url_param):
    handler = CustomHandler
    handler.protocol_version = "HTTP/1.0"

    class MyHandler(handler):
        def do_GET(self):
            super().do_GET()
            self.wfile.write(f'\nURL Parameter: {url_param}'.encode())

    server_address = ('', port)
    httpd = HTTPServer(server_address, MyHandler)

    print(f"Serving on 0.0.0.0:{port}...")
    httpd.serve_forever()

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print("Usage: python server.py <port> <url_param>")
    else:
        port = int(sys.argv[1])
        url_param = sys.argv[2]
        run_server(port, url_param)
