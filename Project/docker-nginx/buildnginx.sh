#!/bin/bash
if sudo docker build -t nginxcont .
then
sudo docker run -d -p 80:80 nginxcont
fi