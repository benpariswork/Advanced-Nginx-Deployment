# Nginx Advanced Deployment

## Description

Follow along with a free AWS account as i deploy two simple Nginx HTTP servers to be load balanced and secured by an instance of Nginx plus running Nginx App Protect. I begin this process by initializing two instances of Ubuntu 20.04 in <a href="https://aws.amazon.com/free/compute/lightsail/">AWS Lightsail</a>. Once connected I install <a href="https://nginx.org/en/docs/">Nginx</a> and start the service. Next I initialize another instance of Ubuntu 20.04, intall <a href="https://nginx.org/en/docs/">Nginx</a>, <a href="https://nginx.org/en/docs/">Nginx Plus</a>

## Goals

- [x] Explore Nginx and it's capabilities
- [x] Demonstrate skill neccessary for the IT jobs I am applying for
- [ ] Test deployment options for freelancing knowledge

## Getting Started

### STILL IN PROGRESS

This project is still in progress and will be fully functional soon. Sorry for the delay!

- [x] Initialize Backend instances
- [x] Initialize Load-Balancer instances
- [x] Automate Backend Provisioning
- [x] Automate Load Balancer Provisioning
- [x] Provision Beckend instances
- [x] Provision Load-Balancer instances
- [ ] Configure Backend instances
- [ ] Configure Load-Balancer
- [ ] Implement App Protect and DOS
- [ ] Revise and test for small business deployment.


### Prerequisites

* Create an AWS Free-Tier account <a href="https://aws.amazon.com/free/">here</a>.
* Get a free trial of Nginx Plus <a href="https://aws.amazon.com/free/">here</a>.
    * We will need two files provided in free trial:
        * ```nginx-repo.crt```
        * ```nginx-repo.key```

### Dependencies (we will initialize/install these together)

* Ubuntu 20.04
* Nginx Open Source
* Nginx plus
* Nginx App Protect 

### Initialize Ubuntu server and connect

* Log into the AWS management console and use the search bar to open Lightsail.

![Find Lightsail Screenshot](/img/find-lightsail.png)

* Click the orange button that says ```Create instance```.

![Lightsail Create Instance Screenshot](/img/create-instance.png)

* Select the options ```Linux/Unix```, https://www.cloudflare.com/learning/ssl/how-does-public-key-encryption-work/OS Only```, and ```Ubuntu 20.04 LTS```.

![Lightsail Instance Image Screenshot](/img/instance-image.png)

* This project does not require very much computational power so select the smallest price plan available.

![Lightsail Plan Screenshot](/img/plan.png)

* Scroll down to the SSH section and click ```Create New```.

![Lightsail SSH Screenshot](/img/ssh.png)

* Give your key a name and click ```Generate key pair```.

![Lightsail SSH Create Screenshot](/img/ssh_create.png)

* Download the private SSH key. (more about public/private keys <a href="https://www.cloudflare.com/learning/ssl/how-does-public-key-encryption-work/">here</a>) For the sake of time, I have used the same keypair when creating all three instances. Use unique keypairs for each server for added security.

![Lightsail SSH Download Screenshot](/img/ssh_download.png)

* Give your instance a name, for this project I used ```Ubuntu-HTTP-1```, ```Ubuntu-HTTP-2```, and ```Load-Balancer```.

![Lightsail Name Screenshot](/img/name.png)

* Click the ```Create instance``` button to finish initializing your instance.

![Screenshot](/img/create.png)

* After creating your Ubuntu instance you will see a list of your instances, wait for your instance to say ```Running```.

![Running Screenshot](/img/running.png)

* Open a terminal on your local machine in the Downloads directory, use ```ssh-add``` to add your SSH key to your keychain.

![SSH Add Screenshot](/img/ssh_add.png)

* Connect to one of your HTTP servers using the IPV4 address located on the lightsail home page, enter ```yes``` when promted.

![Connect Screenshot](/img/connect.png)


### Installing and Running Nginx

Now that you have a shell into your server, follow these steps to install and initialize <a href="https://nginx.org/en/docs/">Nginx</a>:

* Run the command: ```curl -o install_nginx.sh https://raw.githubusercontent.com/benpariswork/Nginx-Scripted-Deployment/main/install_nginx.sh```
    * This command downloads the install script to ```./install_nginx.sh```.
    * I wrote this script based on <a href="https://nginx.org/en/docs/">Nginx Docs</a> and with a little help from my friend chat GPT for user input(lazy, I know, but I saved time!).
    * Feel free to read the script after downloading or <a href="https://github.com/benpariswork/Nginx-Scripted-Deployment">here</a>, this is an essential practice in order to avoid running malicous scripts.

* Run the command: ```chmod +x install_nginx.sh```
    * This command will make the script we just installed executable.

* Run the command: ```sudo ./install_nginx.sh```
    * This command will run the install script with superuser privelages.
    * Some of the commands in this script require superuser privelages, the script should return an error if sudo is not used.
    * Please read this script before running, this is a best practice to avoid running malicous code.

* While the script is running, you will be presented with two 'keys' (see example below).
    * This step is in place to avoid downloading corrupt files.
    * Evaluate the two keys, if they are different enter ```n```, if they are the same enter ```y```.
    * If ```n``` is entered the file just downloaded will be considered corrupt and be deleted.
    * If ```y``` is entered then the script will continue with the installation process.

![Fingerprints Screenshot](/img/fingerprints.png) 

* Once the script has finished running, you should see "NGINX is now RUNNING" like below.

![Nginx Running Screenshot](/img/nginx-running.png)

### Differentiate HTTP Endpoints

* Run the command: ```sudo nginx -s quit && sudo ufw disable```
    * This command will disable the server and firewall while we work on configuring them.

* Run the command: ```sudo nano /usr/share/nginx/html/index.html```
    * This command will open an editor for the HTML file being served by <a href="https://nginx.org/en/docs/">Nginx</a>.

* Add something to the title to differentiate endpoints like ```endpoint 1``` seen in the title below.

```HTML
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx endpoint 1!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```

* Press ```CTRL``` and ```O``` (the letter) then ```enter``` in order to save the file.

* Press ```CTRL``` and ```X``` at the same time in order to quit nano.

* Repeat all of the above steps twice so that you have two http servers, do it a third time to make the load balancer but stop at the section "Differentiate HTTP Endpoints and add Firewall Rules"

### Install Nginx Plus and App Protect on Load Balancer

* Before starting this task, make sure you have the files declared in "Prerequisites".

* Connect to your load balancer via SSH, see your <a href="https://aws.amazon.com/free/compute/lightsail/">AWS Lightsail</a> home page for the IP Address.
    * ```ssh ubuntu@IPADDRESS```

* In case you havent, install Nginx Open Source to start with. See the section "Installing and running Nginx"

* Run the command: ```sudo mkdir /etc/ssl/nginx && cd /etc/ssl/nginx```
    * This command will make and change to the directory ```/etc/ssl/nginx```.

* Add your two files recieved for the Nginx plus free trial. I did this using nano and copy and pasting the contents of the files.
    * ```sudo nano nginx-repo.crt```
    * ```sudo nano nginx-repo.key```

* Download the second script for isntalling Nginx Plus, App protect, and DOS. I wrote this script based on <a href="https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-plus/#installing-nginx-plus-on-debian-or-ubuntu">this</a> and <a href="https://docs.nginx.com/nginx-app-protect-dos/deployment-guide/learn-about-deployment/">this</a>
    * Run the command: ```curl -o nginx_plus.sh https://raw.githubusercontent.com/benpariswork/Advanced-Nginx-Deployment/main/nginx-plus.sh```

* Run the command: ```chmod +x nginx_plus.sh```
    * This command will make the script we just installed executable.

* Run the command: ```sudo ./nginx_plus.sh```
    * This command will run the App Protect Dynamic and Dos install script with superuser privelages.
    * Some of the commands in this script require superuser privelages, the script should return an error if sudo is not used.
    * Please read this script before running, this is a best practice to avoid running malicous code.

* This script may take a couple of minutes but keep posted as it will promt you, always answer y.

* Run the command: ```sudo nano /etc/nginx/nginx.conf

* Add the code below in between inside of ```http{ ... }```

```
upstream backend {
    server 172.26.14.79
    server 172.26.12.109
}
```

* Run the command ```sudo nano /etc/nginx/conf.d/default.conf```

* Replace the code within ```location / { ... }``` with 

```
proxy_pass http://backend;
```

### STILL IN PROGRESS

Will be updating soon with final nginx.conf file as well as firewall rules to secure traffic to backend.









