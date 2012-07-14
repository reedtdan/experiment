#!/usr/bin/env python

import socket
import os
import time

server_name = "localhost" 
server_port = 5000

def main():
	client_sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

	while True:
		# Attempt to connect to kinect server.
		try:
			client_sock.connect((server_name, server_port))
			break
		except:
			print 'Could not connect to "%s" on port %d.' % (server_name, server_port)
			print 'Trying again in 2 seconds...'
			time.sleep(1)

	print 'Connected to Kinect. Waiting for messages...'
	# Now we are connected. Listen for messages.
	while 1:
		msg = client_sock.recv(512)
		print 'Received from kinect: %s' % msg
		if msg == 'Click':
			os.popen('./send_keystroke.osa 20');
			print 'Sending 20'
		elif msg == 'Wave':
			os.popen('./send_keystroke.osa 19');
			print 'Sending 19'


if __name__ == "__main__":
	main()
