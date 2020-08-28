#!/usr/bin/env bash

#curl -X POST -H "Content-Type: application/json" -d '{  "token": "blalalbal", "challenge": "hello" }' http://185.112.144.126/thebardbot/

#curl -X POST \
	#-H "Content-Type: application/json" \
	#-H "Authorization: Bearer xoxb-292976099616-1326250468341-oiA4nByQhLQlVC7ds6tTUtzf" \
	#-d '{ "text": "Hello <@U96EW6MGT>! Knock, knock.", "channel": "G019P9ULJTU" }' \
	#https://slack.com/api/chat.postMessage

payload=$(cat slack_appmention.json)

curl -X POST \
	-H "Content-Type: application/json" \
	-d "$payload" \
	http://localhost:4000/

#curl -X POST \
	#-H "Content-Type: application/json" \
	#-d '{ "challenge": "hello" }' \
	#http://localhost:4000/
