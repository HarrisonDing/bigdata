FROM centos:7
apt-get update
apt-get install wget
wget -N -P / https://github.com/Yancey1989/kubernetes-examples/releases/download/1.0/hello
EXPOSE 8080

CMD ["/hello"]
