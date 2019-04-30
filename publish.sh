#!/bin/sh
hugo
scp -r public central:/mnt/sda1
echo "Published!"
