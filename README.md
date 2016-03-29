# WordPress-Bootstrap
Build a website on WordPress.

### Version Control
[Composer] is used to manage WordPress core. Here is an instruction on [Using Composer with WordPress].

### Theme (Optional)
The script supports downloading and install theme from [Envato Market](http://themeforest.net).

### Deploy
#### Deploy to Digital Ocean
1. Login your account and create a new droplet.
 * Under "Select Image", choose "Applications -> LAMP on 14.04", or similar options if not available.

2. Install git and clone the repository into /var/www

 ```bash
cd /var/www
sudo apt-get install git
git clone https://github.com/zhanghaowx/DreamMaker.git
 ```

3. Run installation scripts and follow on screen instructions

 ```bash
# Optional
export ENVATO_USERNAME=<Your Envato Username>
export ENVATO_API_KEY=<Your Envato API Key>
export ENVATO_PURCHASE_CODE=<Your Purchase Code for Jupiter Theme>
chmod +x install.sh && ./install.sh
 ```

4. Increate max upload filesize for WordPress by `sudo vim /etc/php5/apache2/php.ini` and change the following line `upload_max_filesize = 96M`

5. Follow [How To Set Up Apache Virtual Hosts on Ubuntu 14.04 LTS ](https://www.digitalocean.com/community/tutorials/how-to-set-up-apache-virtual-hosts-on-ubuntu-14-04-lts) to finish websiate setup.

### Environment
Production environment is built upon DigitalOcean's **Ubuntu 14.04 LAMP Server**

[Composer]:http://getcomposer.org/
[Using Composer with WordPress]:http://roots.io/using-composer-with-wordpress/
[Jupiter]:http://themeforest.net/item/jupiter-multipurpose-responsive-theme/5177775
