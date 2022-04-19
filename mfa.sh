#!/bin/bash
if [ "$#" -ne 1 ]; then
  echo "Illegal number of parameters: 'mfa.sh <token_code>'" >&2
  exit 1
fi

TOKEN_CODE=$1
echo using token-code=$TOKEN_CODE and mfa-device=$PROD_MFA_DEVICE

unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN

echo 'validate'
OUTPUT=$(aws sts get-session-token --token-code $TOKEN_CODE --serial-number $PROD_MFA_DEVICE --output text)
# export AWS_ACCESS_KEY_ID=$PROD_ACCESS_KEY AWS_SECRET_ACCESS_KEY=$PROD_SECRET_KEY; 
echo $OUTPUT
export AWS_ACCESS_KEY_ID=$(echo "$OUTPUT" | cut -f2 )
export AWS_SECRET_ACCESS_KEY=$(echo "$OUTPUT" | cut -f4 )
export AWS_SESSION_TOKEN=$(echo "$OUTPUT" | cut -f5)

echo "export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
export AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN" > ~/.awsmfa

. ~/.awsmfa
