#### 证书生成

1. 修改opensls.cnf中${K8S_SERVICE_IP},**SERVICE_IP_RANGE**的第一个IP地址,例如**SERVICE_IP_RANGE**是10.3.0.0/24,则第一个IP就是10.3.0.1
1. 修改openssl.cnf中为${MASTER_HOST},Master节点的地址
1. 在Master节点执行./generate-tls.sh，生成根证书以及master节点需要的证书
1. 将ca.pem, ca-key.pem贴在kubernetes_node_cc.yaml中，部署node节点的k8s进程

