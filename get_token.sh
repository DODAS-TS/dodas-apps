#!/bin/bash

IAM_CLIENT_ID=dodas-demo
IAM_CLIENT_SECRET=dodas-demo
IAM_USER=

IAM_CLIENT_ID=${IAM_CLIENT_ID:-iam-client}
IAM_CLIENT_SECRET=${IAM_CLIENT_SECRET}


echo $IAM_CLIENT_ID

if [[ -z "${IAM_CLIENT_SECRET}" ]]; then
  echo "Please provide a client secret setting the IAM_CLIENT_SECRET env variable."
  exit 1;
fi

if [[ -z ${IAM_USER} ]]; then
  read -p "Username: " IAM_USER
fi

echo -ne "Password:"
read -s IAM_PASSWORD
echo

result=$(curl -s -L \
-d client_id=${IAM_CLIENT_ID} \
-d client_secret=${IAM_CLIENT_SECRET} \
-d grant_type=password \
-d username=${IAM_USER} \
-d password=${IAM_PASSWORD} \
-d scope="openid profile email offline_access" \
${IAM_ENDPOINT:-https://dodas-iam.cloud.cnaf.infn.it/token}) #| tee /tmp/response | jq

if [[ $? != 0 ]]; then
  echo "Error!"
  echo $result
  exit 1
fi

echo $result 

access_token=$(echo $result | jq -r .access_token)

#echo "export TOKEN=\"${access_token}\""
#export TOKEN="${access_token}"

#echo ${access_token} > token
#sed -e "s/token_template/${access_token}/" auth_CNAF_base.dat > auth_CNAF.dat
#sed -e "s/token_template/${access_token}/" auth_XDC_base.dat > auth_XDC.dat
#sed -e "s/token_template/${access_token}/" auth_PG_base.dat > auth_PG.dat
sed -e "s/token_template/${access_token}/" $HOME/.dodas_go_client_template.yaml > $HOME/.dodas.yaml
