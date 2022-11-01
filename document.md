## Prerequisites
## Technologies Used
   1. Docker
   2. Docker-compose
   3. Nginx
   4. Supervisor

Please ensure that these tools above are installed.

## 1. Production Readiness

### Implement a production webserver
## Steps to reproduce

1. Set up a virtual machine on any cloud environment. For this I used an  Ubuntu 22.04 LTS instance using AWS.
2. Terraform was used to provision the instance
3. cd into terraform directory
 run the following commands:
 ```
 terraform init
 terraform plan
 terraform validate
 terraform apply
 ```
Once the server is up and running, ssh into the instance.
sudo chmod +x start.sh
Run the script to get the application working.


### Implementing a reverse proxy to serve traffic.

1. sudo nano /etc/nginx/sites-enabled/nginx.conf to create an nginx conf file for the reverse-proxy.

For the database, creation of the database and user in alresdy in the script.

To enable it in the application,
1. cd into cd devops_challenge/devops_challenge_app/django_celery/
2. edit the settings.py file
3. set debug =False
4. Also set ALLOWED_HOSTS = ['54.156.187.143', 'localhost']
    ALLOWED_HOSTS = ['instance-IP', 'localhost']

REMOVE the  default sqlite database and add the postgres db
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
run a migration
python manage.py makemigrations
python manage.py migrate

To automate the processes, install the supervisor
1. pip install supervisor in the venv
2. echo_supervisord_conf > supervisord.conf
3. create a config file celery.conf

4. run supervisord in the project directory

5. create a file /etc/init.d/supervisord and configure your actual supervisord.conf in which celery is configured in DAEMON_ARGS as follows
`DAEMON_ARGS="-c  "home/ubuntu/challenge-engie/devops_challenge_app/supervisord.conf"`

6. sudo chmod +x /etc/init.d/supervisord
7. sudo update-rc.d supervisord defaults to automatically schedule it
8. sudo service supervisord stop
9. sudo service supervisord start

Running supervisor during startup or booting time using upstart(For Ubuntu users)
/etc/init/supervisor.conf.

```
description "supervisor"
    start on runlevel [2345]
    stop on runlevel [!2345]
    respawn
    chdir /path/to/supervisord
```

sudo service supervisord stop
sudo service supervisord start

## Containerize the application
