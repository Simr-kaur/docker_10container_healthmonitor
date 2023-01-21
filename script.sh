#!/bin/bash

clear

i=1
while [ $i -lt 11 ]
do
        read -p "***** Enter name for container $i *****: " container
        docker run -dt --name $container python:latest
        echo "-----------------------------------"
        echo " $container running successfully"
        echo "-----------------------------------"
        v=$(docker container inspect -f '{{.NetworkSettings.IPAddress }}' $container)
        echo " FROM centos"  >> Dockerfile
        echo "HEALTHCHECK --interval=30s CMD ping -c 5 $v" >> Dockerfile
        echo "----------------------------------------------------"
        read -p " Enter the image name you want to build:-> " image
        echo "----------------------------------------------------"
        docker build -t $image .
        echo " ***** $image build successfully ***** "
        echo "-----------------------------------------------"
        read -p "Enter name for healthcheck container: " health
	echo "------------------------------------------------"
        docker run -dt --name $health $image
        echo " $health running successfully "
        truncate -s 0 Dockerfile
        i=`expr $i + 1`
done
