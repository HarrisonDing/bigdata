修改openssl.cnf中IP.1为**SERVICE_IP_RANGE**的第一个IP地址,例如**SERVICE_IP_RANGE**是10.3.0.0/24,则第一个IP就是10.3.0.1
修改IP.2的地址为当前Master节点的IP地址.
在Master节点执行./generate-tls.sh 
