#!/bin/bash

roleArn=$(aws sts get-caller-identity --query 'Arn' --output text)
user=${roleArn##*/}

echo "uploading key for the user $user"

ssh_user=$(aws iam upload-ssh-public-key --user-name $user --ssh-public-key-body file://~/.ssh/id_rsa.pub --query 'SSHPublicKey.SSHPublicKeyId' --output text)

cat >.ssh_config <<EOF
Host git-codecommit.*.amazonaws.com
  User ${ssh_user}
  IdentityFile ~/.ssh/id_rsa
EOF
