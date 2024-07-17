extensions=""
namespaces=""

create_cluster_extension(){
  extensionName=$1
  packageName=$2
  installNamespace="perftest-$extensionName"

  extensions+=" $extensionName"
  namespaces+=" $installNamespace"

  ext="
  apiVersion: olm.operatorframework.io/v1alpha1
  kind: ClusterExtension
  metadata:
    name: ${extensionName}
  spec:
    installNamespace: ${installNamespace}
    packageName: ${packageName}
  "

  if kubectl create ns "${installNamespace}"; then
    echo "${ext}" | kubectl apply -f -

    for cond in Resolved Unpacked Installed; do
        if ! kubectl wait clusterextension "${extensionName}" --for=condition="${cond}" --timeout=60s; then
          echo "condition ${cond} for extension ${extensionName} not met"
        fi
    done

    for cond in Deprecated PackageDeprecated ChannelDeprecated; do
        if ! kubectl wait clusterextension "${extensionName}" --for=condition="${cond}=false" --timeout=60s; then
          echo "condition ${cond} for extension ${extensionName} not met"
        fi
    done
  fi
}

pids=""

for i in $(seq 1 1 2); do
  create_cluster_extension "dummy-ext${i}" prometheus &
  pids+=" $!"
done

wait $pids

for e in $extensions; do
  kubectl delete clusterextension "$e"
done

for n in $namespaces; do
  kubectl delete ns "$n"
done