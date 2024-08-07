#!/usr/bin/python3
# -*- coding: utf-8 -*-
# PORT COM
port = '/dev/ttyAMA0'
speed = '9600'
# VARIABLES CONFIGURATION DRA/SA818
volumelevel = '2'       # volume 2-8
filterpre = '1'   # Filter pre/de-emph
lowpass= '1'
highpass= '1'

# CONFIG GENERALE : 'AT+DMOSETGROUP={},{},{},{},{},{}\r\n'.format(channelspace, txfreq, rxfreq, txcxcss, squelch, rxcxcss)
channelspace = '0'     # 0=12.5kHz, 1=25kHz
txfreq = '431.8500'          # TX frequency
rxfreq = '431.8500'          # RX frequency
squelch = '4'        # SQUELCH 0-8 (0 = open)
txctcss = '0000'        # CTCSS / CDCSS
rxctcss = '0000'        # CTCSS / CDCSS
