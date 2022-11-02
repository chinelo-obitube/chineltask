locals {
  region = "us-east-1"
  tags = "prod-server"
  ami = "ami-08c40ec9ead489470"
  # user_data = <<-EOT
  # #!/bin/bash
  # sudo apt-get update
  #     sudo apt install -y software-properties-common redis
  #     redis-server
  #     sudo add-apt-repository ppa:deadsnakes/ppa
  #     sudo apt update
  #     sudo apt install -y python3.8
  #     sudo apt-get install -y python3.8-venv
  # sudo apt install python-pip postgresql postgresql-contrib nginx curl
  # sudo apt-get install supervisor
  # sudo apt install python3-dev libpq-dev
  # # start nginx service at start up
  # sudo update-rc.d nginx defaults
  # #pip install psycopg2-binary

  # sudo su postgres <<EOF
  # psql -c "CREATE DATABASE django";
  # psql -c  "CREATE USER djangouser WITH PASSWORD 'password'";
  # psql -c "ALTER ROLE djangouser SET client_encoding TO 'utf8'";
  # psql -c "ALTER ROLE djangouser SET default_transaction_isolation TO 'read committed'";
  # psql -c "ALTER ROLE djangouser SET timezone TO 'UTC'";
  # psql -c "GRANT ALL PRIVILEGES ON DATABASE django TO djangouser";
  # echo "Postgres User djangouser and database django created."
  # EOF

  # git clone  https://github.com/chinelo-obitube/challenge-engie.git
  # cd challenge-engie/devops_challenge_app
  # python3.8 -m venv venv
  # source venv/bin/activate
  #     pip3 install -r requirements.txt
  #     python3 manage.py migrate
  # python manage.py migrate
  # sudo ufw allow 8000
  # #pip install django gunicorn psycopg2
  # python3 manage.py runserver 0.0.0.0:8000 && python -m celery -A django_celery worker 
  # EOT
}
