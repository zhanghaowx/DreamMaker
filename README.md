# DreamMaker
Build a website on WordPress for wedding planning.

### Version Control
[Composer] is used to manage WordPress core. Here is an instruction on [Using Composer with WordPress].

### Theme
[Jupiter] is used as the base theme of the website
![Jupiter Preview](https://0.s3.envato.com/files/105605442/preview.__large_preview.jpg)

### Deploy
#### Deploy to Digital Ocean
1. Login your account and create a new droplet.
 * Under "Select Image", choose "Applications -> LAMP on 14.04", or similar options if not available.

2. Install git and clone the repository into /var/www
 ```
cd /var/www
sudo apt-get install git
git clone https://github.com/zhanghaowx/DreamMaker.git
 ```

3. Run installation scripts and follow on screen instructions
 ```
export ENVATO_USERNAME=<Your Envato Username>
export ENVATO_API_KEY=<Your Envato API Key>
export ENVATO_PURCHASE_CODE=<Your Purchase Code for Jupiter Theme>
chmod +x install.sh && ./install.sh
 ```
4. Increate max upload filesize for WordPress
 ```
sudo vim /etc/php5/apache2/php.ini
 ```
 find line ~~upload_max_filesize = 2M~~ and replace it with
 ```
 upload_max_filesize = 96M
 ```

5. Follow [How To Set Up Apache Virtual Hosts on Ubuntu 14.04 LTS ](https://www.digitalocean.com/community/tutorials/how-to-set-up-apache-virtual-hosts-on-ubuntu-14-04-lts) to finish websiate setup.

### Environment
Production environment is built upon DigitalOcean Ubuntu 14.04 LAMP Server

[composer]:http://getcomposer.org/
[Using Composer with WordPress]:http://roots.io/using-composer-with-wordpress/
[Jupiter]:http://themeforest.net/item/jupiter-multipurpose-responsive-theme/5177775
