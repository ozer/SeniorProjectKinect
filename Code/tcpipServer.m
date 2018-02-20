clear all; close all; clc;

t = tcpip('0.0.0.0', 30000, 'NetworkRole', 'server');
fopen(t);

data = fread(t,t.BytesAvailable);