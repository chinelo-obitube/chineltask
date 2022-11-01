## 1. Production Readiness

### Implement a production webserver
1. Set up a virtual machine on any cloud environment. For this I used an ec2 instance on AWS
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
2. s

For the database, creation of the database and user in alresdy in the script.

to enable it in the application,
cd into cd devops_challenge/devops_challenge_app/django_celery/
edit the settings.py file
set debug =False
ALLOWED_HOSTS = ['54.156.187.143', 'localhost']
ALLOWED_HOSTS = ['instance-IP', 'localhost']

REMOVE THEe  default sqlite database and add the postgres db
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

to automate the processes
pip install supervisor in the venv
echo_supervisord_conf > supervisord.conf
create a config file celery.conf

run supervisord in the project directory

create a file /etc/init.d/supervisord and configure your actual supervisord.conf in which celery is configured in DAEMON_ARGS as follows
DAEMON_ARGS="-c  "home/ubuntu/challenge-engie/devops_challenge_app/supervisord.conf"

sudo chmod +x /etc/init.d/supervisord
sudo update-rc.d supervisord defaults to automatically schedule it
sudo service supervisord stop
sudo service supervisord start

Running supervisor during startup or booting time using upstart(For Ubuntu users)
/etc/init/supervisor.conf.

description "supervisor"
    start on runlevel [2345]
    stop on runlevel [!2345]
    respawn
    chdir /path/to/supervisord

sudo service supervisord stop
sudo service supervisord start

Containerize the application