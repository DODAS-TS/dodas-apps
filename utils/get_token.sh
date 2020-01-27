#!/bin/bash
set -e

exit_msg() {
  echo "Giving up as requested by user..."
  exit 1
}

IAM_DEVICE_CODE_CLIENT_ID=

if [[ -z "${IAM_DEVICE_CODE_CLIENT_ID}" ]]; then
  echo "Please set the IAM_DEVICE_CODE_CLIENT_ID env variable"
  exit 1
fi

IAM_DEVICE_CODE_CLIENT_SECRET=

if [[ -z "${IAM_DEVICE_CODE_CLIENT_SECRET}" ]]; then
  echo "Please set the IAM_DEVICE_CODE_CLIENT_SECRET env variable"
  exit 1
fi

IAM_DEVICE_CODE_ENDPOINT=https://dodas-iam.cloud.cnaf.infn.it/devicecode
## IAM devicecode enpoint is /devicecode, e.g. https://iam.example/devicecode
if [[ -z "${IAM_DEVICE_CODE_ENDPOINT}" ]]; then
  echo "Please set the IAM_DEVICE_CODE_ENDPOINT env variable"
  exit 1
fi

IAM_TOKEN_ENDPOINT=https://dodas-iam.cloud.cnaf.infn.it/token
## IAM token endpoint is /token, e.g. https://iam.example/token
if [[ -z "${IAM_TOKEN_ENDPOINT}" ]]; then
  echo "Please set the IAM_TOKEN_ENDPOINT env variable"
  exit 1
fi

IAM_DEVICE_CODE_CLIENT_SCOPES=${IAM_DEVICE_CODE_CLIENT_SCOPES:-"openid profile email offline_access"}

response=$(mktemp)

if [[ -f /tmp/refresh_token ]] && ! [[ -z /tmp/refresh_token ]]; then
  echo "refresh toke file exist, trying to refresh"

echo "curl -s -f -L \
  -u ${IAM_DEVICE_CODE_CLIENT_ID}:${IAM_DEVICE_CODE_CLIENT_SECRET} \
  -d grant_type=refresh_token \
  -d refresh_token=`cat  /tmp/refresh_token` \
  -d scope='openid profile email offline_access' \
  ${IAM_TOKEN_ENDPOINT} > ${response}
"

  curl -q -L -s \
    -u ${IAM_DEVICE_CODE_CLIENT_ID}:${IAM_DEVICE_CODE_CLIENT_SECRET} \
    -d grant_type=refresh_token \
    -d refresh_token=`cat  /tmp/refresh_token` ${IAM_TOKEN_ENDPOINT} 2>&1 > ${response}

  if [ $? -ne 0 ]; then
    echo "Error contacting IAM"
    cat ${response}
    exit 1
  fi

  error=$(jq -r .error ${response})
  error_description=$(jq -r .error_description ${response})
  if [[ "${error}" != "null" ]]; then
    echo "The IAM returned the following error:"
    echo
    echo ${error} " " ${error_description}
    echo
    continue;
  fi

  access_token=$(jq -r .access_token ${response})

  sed -e "s/token_template/${access_token}/" $HOME/.dodas_go_client_template.yaml > $HOME/.dodas.yaml
  echo
  echo
  echo export TOKEN=${access_token}
  exit 0
fi

echo "curl -q -f -s \
  -u ${IAM_DEVICE_CODE_CLIENT_ID}:${IAM_DEVICE_CODE_CLIENT_SECRET} \
  -d client_id=${IAM_DEVICE_CODE_CLIENT_ID} \
  -d scope=\"${IAM_DEVICE_CODE_CLIENT_SCOPES}\" \
  ${IAM_DEVICE_CODE_ENDPOINT} > ${response} "

curl -q -f -s \
  -u ${IAM_DEVICE_CODE_CLIENT_ID}:${IAM_DEVICE_CODE_CLIENT_SECRET} \
  -d client_id=${IAM_DEVICE_CODE_CLIENT_ID} \
  -d scope="${IAM_DEVICE_CODE_CLIENT_SCOPES}" \
  ${IAM_DEVICE_CODE_ENDPOINT} > ${response}

if [ $? -ne 0 ]; then
  echo "Error contacting IAM"
  cat ${response}
  exit 1
fi

device_code=$(jq -r .device_code ${response})
user_code=$(jq -r .user_code ${response})
verification_uri=$(jq -r .verification_uri ${response})
expires_in=$(jq -r .expires_in ${response})

trap "exit_msg" INT

echo "Please open the following URL in the browser:"
echo

echo ${verification_uri}
echo

echo "and, after having been authenticated, enter the following code when requested:"
echo

echo ${user_code}

echo
echo "Note that the code above expires in ${expires_in} seconds..."
echo "Once you have correctly authenticated and authorized this device, this script can be restarted to obtain a token. "


while true; do

  while true; do
    echo
    echo "Proceed? [Y/N] (CTRL-c to abort)"
    read a
    [[ $a = "y" || $a = "Y" ]] && break
    [[ $a = "n" || $a = "N" ]] && exit 0
  done

  curl -q -L -s \
    -u ${IAM_DEVICE_CODE_CLIENT_ID}:${IAM_DEVICE_CODE_CLIENT_SECRET} \
    -d grant_type=urn:ietf:params:oauth:grant-type:device_code \
    -d device_code=${device_code} ${IAM_TOKEN_ENDPOINT} 2>&1 > ${response}

  if [ $? -ne 0 ]; then
    echo "Error contacting IAM"
    cat ${response}
    exit 1
  fi

  error=$(jq -r .error ${response})
  error_description=$(jq -r .error_description ${response})

  if [[ "${error}" != "null" ]]; then
    echo "The IAM returned the following error:"
    echo
    echo ${error} " " ${error_description}
    echo
    continue;
  fi

  access_token=$(jq -r .access_token ${response})
  refresh_token=$(jq -r .refresh_token ${response})
  scope=$(jq -r .scope ${response})
  expires_in=$(jq -r .expires_in ${response})

  echo $refresh_token > /tmp/refresh_token

  echo
  echo "An access token was issued, with the following scopes:"
  echo
  echo ${scope}
  echo
  echo "which expires in ${expires_in} seconds."
  echo
  echo "The following command will set it in the IAM_ACCESS_TOKEN env variable:"
  echo
  echo "export TOKEN=\"${access_token}\""
  echo
  echo "${response}"

  exit 0

done
