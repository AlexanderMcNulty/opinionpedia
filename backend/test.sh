#!/bin/bash
api=localhost:4000/api
newuser=ammc$RANDOM

echo ===============
echo TESTING PROFILE
echo ===============

echo GET /profile
curl $api/profile
echo

echo GET /profile/1
curl $api/profile/1
echo

echo GET /profile/pdm
curl $api/profile/pdm
echo

echo POST /profile
curl -X POST -H 'Content-Type: application/json' -d '{
        "username": "'"$newuser"'",
        "password": "password",
        "description": "Description for profile ammc",
        "body": "Body for profile ammc"
    }' $api/profile
echo

echo POST /login
token=$(curl -sS -X POST -H 'Content-Type: application/json' -d '{
        "username": "'"$newuser"'",
        "password": "password"
    }' $api/login)
echo $token

echo PUT /profile
curl -X PUT -H 'Content-Type: application/json' -H "Authorization: Bearer $token" -d '{
        "password": "New password"
    }' $api/profile
echo

echo POST /login
token=$(curl -sS -X POST -H 'Content-Type: application/json' -d '{
        "username": "'"$newuser"'",
        "password": "New password"
    }' $api/login)
echo $token

echo
echo ================
echo TESTING QUESTION
echo ================

echo POST /question
curl -X POST -H 'Content-Type: application/json' -H "Authorization: Bearer $token" -d '{
        "prompt": "Prompt for question",
        "description": "Description for question"
    }' $api/question
echo

echo GET /question/1
curl $api/question/1
echo

echo PUT /question/1
curl -X PUT -H 'Content-Type: application/json' -H "Authorization: Bearer $token" -d '{
        "prompt": "New prompt for question",
        "description": "New description for question"
    }' $api/question/1
echo

echo GET /question/1
curl $api/question/1
echo

echo
echo ==============
echo TESTING OPTION
echo ==============

echo GET /option
curl $api/option
echo

echo POST /option
curl -X POST -H 'Content-Type: application/json' -H "Authorization: Bearer $token" -d '{
        "question_id": 1,
        "prompt": "Prompt for option",
        "description": "Description for option"
    }' $api/option
echo

echo GET /option/1
curl $api/option/1
echo

echo PUT /option/1
curl -X PUT -H 'Content-Type: application/json' -H "Authorization: Bearer $token" -d '{
        "prompt": "New prompt for option",
        "description": "New description for option"
    }' $api/option/1
echo

echo GET /option/1
curl $api/option/1
echo

echo GET /option/question/1
curl $api/option/question/1
echo
