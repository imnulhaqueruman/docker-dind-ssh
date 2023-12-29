# Docker:dind 



## Image build
```bash
docker build -f Dockerfile -t demo/docker-dind-ssh


```
# Running on localhost 
```bash
docker run --privileged -d -p 127.0.0.1:7777:22 brthornbury/docker-dind-sshd --storage-driver=overlay

```
# Connect with ssh 
```bash
 ssh -i /dev/null -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 7777 root@127.0.0.1

```
# Try to deploy this in Kubernetes CLUSTERIP 
### Kubernetes deployment file with docker/sock permission
```bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ssh-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ssh
  template:
    metadata:
      labels:
        app: ssh
    spec:
      containers:
        - name: ssh-container
          image: poridhi/poridhi-ssh:v4.0.8beta
          command: ["chmod", "666", "/var/run/docker.sock"]
          ports:
            - containerPort: 22
          securityContext:
            privileged: true
          volumeMounts:
            - name: docker-socket
              mountPath: /var/run/docker.sock
      volumes:
        - name: docker-socket
          hostPath:
            path: /var/run/docker.sock
    
```
### Kubernetes service yaml file 
```bash
apiVersion: v1
kind: Service
metadata:
  name: ssh-service-1
spec:
  selector:
    app: ssh
  ports:
    - protocol: TCP
      port: 22
      targetPort: 22
  type: ClusterIP


```
[ref](https://github.com/brthor/docker-dind-sshd)

