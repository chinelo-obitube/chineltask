## Prerequisites
## Technologies Used
   1. Docker
   2. Docker-compose
   3. Nginx
   4. Supervisor
   5. Helm
   6. Kubectl
   7. Minikube
   8. Hyperkit
   9. Kubernetes

Please ensure that these tools above are installed.

## 1. Production Readiness

### Implement a production webserver
## Steps to reproduce

1. Set up a virtual machine on any cloud environment. For this I used an  Ubuntu 22.04 LTS instance using AWS.
3. cd into terraform directory
4. run the following commands:
 ```
 terraform init
 terraform plan
 terraform validate
 terraform apply
 ```
5. Ssh into the server to validate that the server is running 
  Clone the repository and set up the environment using the script.
``` sudo chmod +x start.sh ```
 Run the script to get the application working.
 ``` bash start.sh  ```


### Implementing a Reverse proxy to Serve traffic.

1. Create an nginx conf file for the reverse-proxy.
```sudo nano /etc/nginx/sites-enabled/nginx.conf ```.
2. Copy and paste this into the nginx.conf file.
```
upstream backend {
    server localhost:8000;
}
server_tokens               off;
access_log                  /var/log/nginx/devops_challenge_app.access.log;
error_log                   /var/log/nginx/devops_challenge_app.error.log;

server {
  server_name               54.156.187.143;
  listen                    80;
  listen [::]:80;

  location / {
    proxy_pass              http://localhost:8000;

   proxy_set_header        Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```
3. Restart the nginx service.
   ``` sudo systemctl nginx restart ```.

## Connect database to the application.
Note: Database is already created in the start.sh script.

To enable it in the application,
1. Cd into devops_~/django_celery/
2. Edit the settings.py file
3. Set debug =False
4. Set ALLOWED_HOSTS = ['54.156.187.143', 'localhost'] or your instance
       ALLOWED_HOSTS = ['instance-IP', 'localhost']
5. Remove the  default sqlite database and add the postgres db
   ```
   DATABASES = {
    "default": {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'django',
        'USER': 'djangouser',
        'PASSWORD': 'password',
        'HOST': 'localhost',
        'PORT': '',
                }
}
```
### Managed services to handle automatic start/restarts of processes.

To automate the processes, install supervisor
1. pip install supervisor in the venv.
2. echo_supervisord_conf > supervisord.conf.
3. create a config file celery.conf and add the bellow.
```
[program:celeryd]
    command=python -m celery -A django_celery worker
    stdout_logfile=/home/ubuntu/var/logs/celeryd.log
    stderr_logfile=/home/ubuntu/var/logs/celeryd.log
    autostart=true
    autorestart=true
    startsecs=10
    stopwaitsecs=600
```

4.  Run ``` supervisord ``` inside the project directory.
5. Create a file ```/etc/init.d/supervisord``` and configure your actual supervisord.conf in which celery is configured in DAEMON_ARGS as follows
```DAEMON_ARGS="-c  home/ubuntu/devops-challenge/devops_challenge_app/supervisord.conf"
   sudo chmod +x /etc/init.d/supervisord
   sudo update-rc.d supervisord defaults 
   sudo service supervisord stop
   sudo service supervisord start
```
6. To run supervisor during startup or booting time using upstart(For Ubuntu users), create a ```/etc/init/supervisor.conf. ``` file and add the following.
```
description "supervisor"
    start on runlevel [2345]
    stop on runlevel [!2345]
    respawn
    chdir /path/to/supervisord
```
7. Complete the setup
``` sudo service supervisord stop
    sudo service supervisord start
```

## Containerize the application
1. Create a DockerFile inside the devops_challenge_app folder.
2. Create a docker-compose file.
3.  Edit the django_celery/settings.py and change the localhost to redis.
```CELERY_BROKER_URL = "redis://redis:6379"
   CELERY_RESULT_BACKEND = "redis://redis:6379"
```
   Also set debug to False since its prodcution.
4. Execute the command.
``` docker-compose up --build ```
5. Check that the docker containers are up and running.
6. Go to http://localhost:8000 to access the application.


### Kubernetes with minikube
I decided to set up the minikube in a virtual machine to ease the ci/cd process.

1. Start the minikube on your machine and ensure docker is up and running.
``` 
minikube start 
eval $(minikube docker-env)     
``` 
2. Enable addons
``` minikube addons enable ingress ```
3. Confirm minikube is working
  ``` kubectl get pods ```
4. Run ```minikube dashboard ```  and open in a browser.
4. cd into the minikube folder
5. Apply the manifests and ensure pods are working.
6. Expose the deployment, set the type=LoadBalancer and sstart it on the browser.
    ```kubectl expose deployment devops-challenge-web --type=LoadBalancer --port=8000 
       minikube service devops-challenge-web-service ```
7. confirm the application is running at http://127.0.0.1:55292/
8. Scale the deployment to your desired number for high avaialability.
``` kubectl scale --replicas=4 deployment devops-challenge-web
    kubectl scale --replicas=4 deployment devops-challenge-celery
```
9. To monitor the application, add and install prometheus and grafana using helm.
10. Execute the bellow commands to set up prometehus and grafana with kube-prometheus-stack
```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus-grafana prometheus-community/kube-prometheus-stack
```
To configure the ci/cd, a good way is to set up the minikube in a virtual machine and set up the workflow for the ci/cd using github actions.

Install kubectl, minikube, docker inside the instance
and make a change to trigger the pipeline. 





   


