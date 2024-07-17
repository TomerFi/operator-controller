#! /bin/bash

set -o errexit
set -o nounset
set -o pipefail

help="
create-catalog.sh is a script creating an image-based ClusterCatalog in the connected cluster.
Usage:
  create-catalog.sh [NAME] [IMAGE]

Argument Descriptions:
  - NAME is the name that will be used as the name of the created catalog.
  - IMAGE is the image reference for the catalog.
"

if [[ "$#" -ne 2 ]]; then
  echo "Illegal number of arguments passed"
  echo "${help}"
  exit 1
fi

name=$1
image=$2

echo "${name}" "${image}"

kubectl apply -f - << EOF
kind: ClusterCatalog
apiVersion: catalogd.operatorframework.io/v1alpha1
metadata:
  name: "${name}"
spec:
  source:
    type: image
    image:
      ref: "${image}"
      insecureSkipTLSVerify: true
EOF

kubectl wait clustercatalog "${name}" --for=condition=Unpacked --timeout=60s