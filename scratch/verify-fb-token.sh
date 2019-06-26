#!/bin/bash

KEY=k
VALUE=v

while getopts "k:v:h" opt;do
  case "${opt}"
    in
    k ) KEY=${OPTARG};echo "KEY";;
    v ) VALUE=${OPTARG};;
    h ) printf '\nUsage: getSatProto [OPTION]\n'
       printf 'Download the satisfaction-protobuf definitions and compile them into javascript.\n'
       printf '  -h        Help\n'
       printf '  -k        Key\n'
       printf '  -v        Value\n'
       printf '\n\n'
       exit 0
       ;;
   \? ) echo "Invalid Option: -$OPTARG" 1>&2
       exit 1;;
  esac
done


echo https://graph.facebook.com/v3.1/$KEY/?access_token=$VALUE
curl https://graph.facebook.com/v3.1/$KEY/?access_token=$VALUE

