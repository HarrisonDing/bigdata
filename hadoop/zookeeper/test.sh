#/bin/bash
echo "################ hostname ####################"
for i in 0 1 2; do 
  kubectl exec zk-$i -- hostname;
done
echo "################ echo myid ###################"
for i in 0 1 2; do 
  echo "myid zk-$i";
  kubectl exec zk-$i -- cat /var/lib/zookeeper/data/myid;
done
echo "############### hostname -f ###################"
for i in 0 1 2; do
  kubectl exec zk-$i -- hostname -f;
done
echo "############## zoo.cfg #######################"
for i in 0 1 2; do
  echo  "zk-$i zoo.cfg"
  kubectl exec zk-$i -- cat /opt/zookeeper/conf/zoo.cfg
  echo "\n"
done
echo "create /hello world"
kubectl exec zk-0 zkCli.sh create /hello world
echo "create /hello world success"
echo "get /hello "
kubectl exec zk-1 zkCli.sh get /hello 
echo "get /hello  success"

#kubectl delete statefulset zk #delete statefulSet
#kubectl apply -f zk-statefulSet.yaml #apply statefulSet  
