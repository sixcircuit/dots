#!/usr/bin/env python3

# no-cache http server
# Inspired by  https://stackoverflow.com/a/25708957/51280
from http.server import SimpleHTTPRequestHandler
import socketserver
import sys
import os

class NoCacheRequestHandler(SimpleHTTPRequestHandler):
   def end_headers(self):
      self.send_my_headers()
      SimpleHTTPRequestHandler.end_headers(self)

   def send_my_headers(self):
      self.send_header("Cache-Control", "no-cache, no-store, must-revalidate")
      self.send_header("Pragma", "no-cache")
      self.send_header("Expires", "0")

# import http.server, ssl
#
# # all in one flie
# openssl req -new -x509 -keyout localhost.pem -out localhost.pem -days 365 -nodes
#
# # no questions
# openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 \
#     -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com" \
#     -keyout www.example.com.key  -out www.example.com.cert
#
# # combine all this
#
# server_address = ('0.0.0.0', 4443)
# # httpd = http.server.HTTPServer(server_address, http.server.SimpleHTTPRequestHandler)
# httpd = http.server.HTTPServer(server_address, NoCacheRequestHandler)
# httpd.socket = ssl.wrap_socket(httpd.socket,
#                                server_side=True,
#                                certfile='localhost.pem',
#                                ssl_version=ssl.PROTOCOL_TLS)
# httpd.serve_forever()

if __name__ == '__main__':
   port = 0
   if len(sys.argv) >= 2:
      port = int(sys.argv[1])
   print("serving at port", port)
   with socketserver.TCPServer(("", port), NoCacheRequestHandler) as httpd:
      actual_port = httpd.server_address[1]
      print("serving at port", actual_port)
      os.system("open http://localhost:" + str(actual_port))
      httpd.serve_forever()

#!/bin/bash
# if [[ -z "$1" ]]; then
#    open "http://localhost:8080" && python3 -m http.server 8080 --bind 0.0.0.0
# else
#    open "http://localhost:${1}" && python3 -m http.server $1 --bind 0.0.0.0
# fi
