#/bin/bash
namespace="yarn-cluster-lp"
case $1 in
  start)
    kubectl create -f pv.yaml --namespace=$namespace
    kubectl create -f zk-statefulSet.yaml --namespace=$namespace
  ;;
  stop)
    kubectl delete pvc datadir-zk-0
    kubectl delete pvc datadir-zk-1
    kubectl delete pvc datadir-zk-2
    kubectl delete -f pv.yaml --namespace=$namespace
    kubectl delete -f zk-statefulSet.yaml --namespace=$namespace
  ;;
  restart)
    kubectl delete -f pv.yaml --namespace=$namespace
    kubectl delete -f zk-statefulSet.yaml --namespace=$namespace
    kubectl create -f pv.yaml --namespace=$namespace
    kubectl create -f zk-statefulSet.yaml --namespace=$namespace
  ;;
  *)
  echo "please input start|stop|restart."
esac
