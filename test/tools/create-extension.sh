#! /bin/bash

set -o errexit
set -o nounset
set -o pipefail

help="
create-extension.sh is a script creating an ClusterExtension in the connected cluster.
Usage:
  create-extension.sh [NAME] [PACKAGE_NAME] [INSTALL_NAMESPACE] [PACKAGE_VERSION]

Argument Descriptions:
  - NAME is the name that will be used as the name of the created extension.
  - PACKAGE_NAME is the package for the extension.
  - INSTALL_NAMESPACE (optional) defaults to 'default'.
  - PACKAGE_VERSION (optional) default to none.
"

if [[ "$#" -lt 2 ]]; then
  echo "Illegal number of arguments passed"
  echo "${help}"
  exit 1
fi

name=$1
packageName=$2
installNamespace=${3:-default}
packageVersion=${4:-}

echo "${name}" "${packageName}" "${installNamespace}" "${packageVersion:-latest}"

ext="
apiVersion: olm.operatorframework.io/v1alpha1
kind: ClusterExtension
metadata:
  name: ${name}
spec:
  installNamespace: ${installNamespace}
  packageName: ${packageName}
"

[[ -z $packageVersion ]] || ext+="  version: ${packageVersion}"

echo "${ext}" | kubectl apply -f -

for cond in Resolved Unpacked Installed; do
    kubectl wait clusterextension "${name}" --for=condition="${cond}" --timeout=60s
done

for cond in Deprecated PackageDeprecated ChannelDeprecated; do
    kubectl wait clusterextension "${name}" --for=condition="${cond}=false" --timeout=60s
done

