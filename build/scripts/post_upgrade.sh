#!/usr/bin/env bash

scripts_path=$(cd `dirname $0`; pwd)
source "${scripts_path}"/utils.sh

set -x

source "${scripts_path}"/default_values.sh

bash ${scripts_path}/install_addons.sh || exit 1

kubectl -n kube-system delete deploy yoda-scheduler-extender || true

if [ "$GenerateClusterInfo" == "true" ];then
  gen_clusterinfo || exit 1
  GenerateCAFlag="--generate-ca"
fi

sleep 15
trident_process_init "$ComponentToInstall" "$PlatformCAPath" "$PlatformCAKeyPath" "$GenerateCAFlag" || exit 1

health_check "$SkipHealthCheck" || exit 1