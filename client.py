import os
import matlab.engine
from socket import *
from struct import unpack
import sys
# -*- coding: utf-8 -*-
class ClientProtocol:

    def __init__(self):
        self.socket = None
        self.output_dir = '.'


    def connect(self, server_ip, server_port):
        self.socket = socket(AF_INET, SOCK_STREAM)
        self.socket.connect((server_ip, server_port))

    def close(self):
        self.socket.close()
        self.socket = None


    def receiveIQData(self):
        print("Receiving FM data")
        try:
            while True:
                try:
                    bs = self.socket.recv(8)
                    (length,) = unpack('>Q', bs)
                    total_length = int(length)
                    data = b''
                    count = 0
                    while len(data) < length:
                        # doing it in batches is generally better than trying
                        # to do it all in one go, so I believe.
                        to_read = length - len(data)
                        data += self.socket.recv(4096 if to_read > 4096 else to_read)
                        count+=1
                        if(1000 == count):
                            print("25%")
                        elif(5000 == count):
                            print("50%")
                        elif(12000 == count):
                            print("75%")
                finally:
                    self.close()
                print("Writing FM.dat file")
                with open(os.path.join(self.output_dir, 'FM.dat'), 'wb') as fp:
                    fp.write(data)
                print("Done writing FM.dat file")
                break;
        finally:
            print("Done receiving FM data")

import os
import matlab.engine
from socket import *
from struct import unpack
import sys
# -*- coding: utf-8 -*-
class ClientProtocol:

    def __init__(self):
        self.socket = None
        self.output_dir = '.'


    def connect(self, server_ip, server_port):
        self.socket = socket(AF_INET, SOCK_STREAM)
        self.socket.connect((server_ip, server_port))

    def close(self):
        self.socket.close()
        self.socket = None


    def receiveIQData(self):
        print("Receiving FM data")
        try:
            while True:
                try:
                    bs = self.socket.recv(8)
                    (length,) = unpack('>Q', bs)
                    total_length = int(length)
                    data = b''
                    count = 0
                    while len(data) < length:
                        # doing it in batches is generally better than trying
                        # to do it all in one go, so I believe.
                        to_read = length - len(data)
                        data += self.socket.recv(4096 if to_read > 4096 else to_read)
                        count+=1
                        if(1000 == count):
                            print("25%")
                        elif(5000 == count):
                            print("50%")
                        elif(12000 == count):
                            print("75%")
                finally:
                    self.close()
                print("Writing FM.dat file")
                with open(os.path.join(self.output_dir, 'FM.dat'), 'wb') as fp:
                    fp.write(data)
                print("Done writing FM.dat file")
                break;
        finally:
            print("Done receiving FM data")

if __name__ == '__main__':
    cp = ClientProtocol()
    print("Client is connnecting...")
    #Edit this IP to your pynq board's IP on network switch. Found through ifconfig
    cp.connect('192.168.1.26', 12345)
    print("Connected to: '192.168.1.26', 12345")
    #collect IQ data
    cp.receiveIQData()
 
# Opens matlab and runs Final.m script
print("Opening MatLab to process data")
eng = matlab.engine.start_matlab()
eng.Final(nargout=0) 
