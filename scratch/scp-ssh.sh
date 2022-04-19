#!/usr/bin/env bash

IP=`echo "$1"`

if [[ -z $1 ]]; then
  echo "Please provide target environment"
  exit 1
else
  echo $IP
  scp -i ~/.ssh/idt_production_aws_2.pem /tmp/sshd_config ec2-user@${IP}:/home/ec2-user/sshd_config
  ssh -i ~/.ssh/idt_production_aws_2.pem ec2-user@${IP}
fi
