#!/usr/bin/env bash

payload=$(cat slack_appmention.json)

curl -X POST \
	-H "Content-Type: application/json" \
	-d "$payload" \
	http://localhost:4000/

#curl -X POST \
	#-H "Content-Type: application/json" \
	#-d '{ "challenge": "hello" }' \
	#http://localhost:4000/
