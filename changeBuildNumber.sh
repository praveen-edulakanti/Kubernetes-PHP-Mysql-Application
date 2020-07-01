#!/bin/bash
sed "s/buildNumber/$1/g" deployment-phpapp.yaml > deployment-phpapp-buildno.yaml