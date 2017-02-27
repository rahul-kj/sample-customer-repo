#!/bin/bash

echo "this is a sample post script"

chmod +x om-cli/om-linux

./om-cli/om-linux -h

chmod +x om-cli/om-linux

ERT_ERRANDS=$(cat <<-EOF
{"errands": [
  {"name": "nfsbrokerpush","post_deploy": false}
]}
EOF
)

echo "Disabling NFS Broker push errand Tests"
CF_GUID=`./om-cli/om-linux -t https://$OPS_MGR_HOST -k -u $OPS_MGR_USR -p $OPS_MGR_PWD curl -p "/api/v0/deployed/products" -x GET | jq '.[] | select(.installation_name | contains("cf-")) | .guid' | tr -d '"'`

./om-cli/om-linux -t https://$OPS_MGR_HOST -k -u $OPS_MGR_USR -p $OPS_MGR_PWD curl -p "/api/v0/staged/products/$CF_GUID/errands" -x PUT -d "$ERT_ERRANDS"
