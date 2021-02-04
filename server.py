import os
from socket import *
from struct import pack

class ServerProtocol:

  def __init__(self):
      self.socket = None

  def listen(self, server_ip, server_port):
      self.socket = socket(AF_INET, SOCK_STREAM)
      self.socket.bind((server_ip, server_port))
      self.socket.listen(1)

  def send_image(self, iq_data):
      try:
          while True:
              (connection, addr) = self.socket.accept()
              try:
                  length = pack('>Q', len(iq_data))

                  connection.send(length)
                  connection.sendall(iq_data)
              finally:
                  connection.shutdown(SHUT_WR)
                  connection.close()
                  print("File Transfer Complete")
                  break
      finally:
          self.close()
          return 0
  def close(self):
      self.socket.close()
      self.socket = None
      # could handle a bad ack here, but we'll assume it's fine.

if __name__ == '__main__':
  sp = ServerProtocol()
  cmd = "rtl_sdr -f 88300000 -g 28.4 -s 2500000 -n 25000000 pynqradio.dat"
  os.system(cmd)
  print("Server captured Radio Data")
  print("Server is listening...")
  sp.listen('', 12345)
  iq_data = None

  #with open('pynq1.dat', 'rb') as iq:
  with open('pynqradio.dat', 'rb') as iq:
      iq_data = iq.read()

  assert(len(iq_data))
  sp.send_image(iq_data)
