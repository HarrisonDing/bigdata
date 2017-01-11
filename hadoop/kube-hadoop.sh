#/bin/bash
namespace="yarn-cluster-lp"
function error() {
  echo "sh kube-yarn.sh start|stop hdfs|yarn|zk"
  exit -1
}
function hdfs(){
  for file in `ls hdfs/hdfs*.yaml`;
  do
    case $1 in
      start)
        kubectl create -f $file --namespace=$namespace
        echo "kubectl create -f $file --namespace=$namespace"
      ;;
      stop)
        kubectl delete -f $file --namespace=$namespace
        echo "kubectl delete -f $file --namespace=$namespace"
      ;;
      *)
      echo "unkown $op"
      ;;
    esac

  done
}

function yarn(){
  for file in `ls yarn/yarn*.yaml`;
  do
    case $1 in
      start)
        kubectl create -f $file --namespace=$namespace
        echo "kubectl create -f $file --namespace=$namespace"
      ;;
      stop)
        kubectl delete -f $file --namespace=$namespace
        echo "kubectl delete -f $file --namespace=$namespace"
      ;;
      *)
      error
      ;;
    esac

  done
}

function start() {
  kubectl delete configmap hadoop-config --namespace=$namespace
  kubectl create configmap hadoop-config \
        --from-file=artifacts/bootstrap.sh \
        --from-file=artifacts/start-yarn-rm.sh \
        --from-file=artifacts/start-yarn-nm.sh \
        --from-file=artifacts/slaves \
        --from-file=artifacts/core-site.xml \
        --from-file=artifacts/hdfs-site.xml \
        --from-file=artifacts/mapred-site.xml \
        --from-file=artifacts/yarn-site.xml \
        --namespace=$namespace

  case $1 in
    hdfs)
      hdfs "start"
    ;;
    yarn)
      yarn "start"
    ;;
    zk)
      sh zookeeper/zk.sh start
    ;;
    *)
    error
    ;;
  esac
}

function stop() {
  #kubectl delete configmap hadoop-config --namespace=$namespace
  case $1 in
    hdfs)
      hdfs "stop"
    ;;
    yarn)
      yarn "stop"
    ;;
    zk)
      sh zookeeper/zk.sh stop
    ;;
    *)
    error
    ;;
  esac
}

function scale(){
  case $1 in
    hdfs-dn)
      kubectl patch statefulset hdfs-dn -p '{"spec":{"replicas": 3}}' --namespace=$namespace
    ;;
    yarn-nm)
      kubectl patch statefulset yarn-nm -p '{"spec":{"replicas": 3}}' --namespace=$namespace
    ;;
    *)
      error
    ;;
  esac
}

function init(){
  kubectl exec zk-0 zkCli.sh create /rmstore 1
  kubectl exec zk-0 zkCli.sh create /bfdoffline 1
  kubectl exec zk-0 zkCli.sh create /bfdoffline/bfdhadoopcool 1
}

case $1 in
  start)
   start $2
  ;;
  stop)
   stop $2
  ;;
  init)
    init $2
  ;;
  restart)
    stop $2
    start $2
  ;;
  scale)
    scale $2
  ;;
  *)
  error
  ;;
esac
