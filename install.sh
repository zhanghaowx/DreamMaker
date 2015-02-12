#!/bin/bash

export COMPOSER_JSON="composer.json"

##### get arguments from composer.json #####
export WP_DIR_NAME=`less $COMPOSER_JSON | grep -Po '(?<="webroot-dir": ")[^"]*'`
export WP_VERSION=`less $COMPOSER_JSON | grep -Po '(?<="wordpress": ")[^"]*'`

##### cleanup environment #####
if [ -d "vendor" ]; then
    echo "Removing vendor directory ... "
    rm -r vendor
fi

if [ -d $WP_DIR_NAME ]; then
    echo "Removing old install of word press ... "
    rm -r $WP_DIR_NAME
fi

##### install wordpress ######
if ! type "composer" > /dev/null; then
    echo "Could not find composer, install ... "
    curl -sS https://getcomposer.org/installer | php
    alias composer='php composer.phar'
fi

# run install
echo "Update composer dependencies ... "
composer update
echo "Install Word Press $WP_VERSION ... "
composer install

# check install result
if [ ! -f "$WP_DIR_NAME/wp-config-sample.php" ]; then
    echo "Could not find wp-config-sample.php in $WP_DIR_NAME directory"
    exit 1
fi

##### add lines to wp-config-sample.php #####
echo "Prepare wp-config-sample.php for installing themes ... "
echo "" >> $WP_DIR_NAME/wp-config-sample.php
echo "/***** The followings are automatically generated content *****/" >> $WP_DIR_NAME/wp-config-sample.php
echo "/* Required by Jupiter Theme: Maximum Execution Time */" >> $WP_DIR_NAME/wp-config-sample.php
echo "set_time_limit(60);" >> $WP_DIR_NAME/wp-config-sample.php
echo "define('WP_MEMORY_LIMIT', '96M');" >> $WP_DIR_NAME/wp-config-sample.php
echo "/***** End of automatically generated content *****/" >> $WP_DIR_NAME/wp-config-sample.php
echo "" >> $WP_DIR_NAME/wp-config-sample.php

##### install jupiter theme #####
if [ -z "$ENVATO_USERNAME" ]; then
    read -p 'Enter Envato Username: ' envato_username
    export ENVATO_USERNAME=$envato_username
fi

if [ -z "$ENVATO_API_KEY" ]; then
    read -p 'Enter Envato API Key: ' envato_api_key
    export ENVATO_API_KEY=$envato_api_key
fi

if [ -z "$ENVATO_PURCHASE_CODE" ]; then
    read -p 'Enter Purchase Code for Jupiter Theme: ' envato_purchase_code
    export ENVATO_PURCHASE_CODE=$envato_purchase_code
fi

# main part, here we get the response from the Envato APIs using curl library
echo "Querying download URL for theme packages ... "
response=`curl -s "http://marketplace.envato.com/api/edge/$envato_username/$envato_api_key/download-purchase:$envato_purchase_code.json"`
if [ $? != 0 ]; then
    echo "Fail to get download URL from envota marketplace, abort."
    exit 1
fi

response_error=`echo $response | python -mjson.tool | grep -Po '(?<="error": ")[^"]*'`
if [ "$response_error" != "" ]; then
    echo "Fail to get download URL from envota marketplace, reason: $response_error"
    exit 1
fi

response_url=`echo $response | python -mjson.tool | grep -Po '(?<="download_url": ")[^"]*'`

download_file_dir="download"

if [ ! -d "$download_file_dir" ]; then
    mkdir $download_file_dir
else
    rm -r $download_file_dir/*
fi

download_file_name="jupiter.zip"

echo "Downloading theme package from $response_url ... into direcotry $download_file_dir"
wget $response_url -O $download_file_dir/$download_file_name
if [ $? != 0 ]; then
    echo "Fail to download theme package from envota marketplace, abort."
    exit 1
fi

echo "Extract theme content from package file ... "
unzip $download_file_dir/$download_file_name -d $download_file_dir
if [ $? != 0 ]; then
    echo "Fail to unzip theme package file $download_file_dir/$download_file_name, abort."
    exit 1
fi

unzip $download_file_dir/main/jupiter.zip -d $download_file_dir
if [ $? != 0 ]; then
    echo "Fail to unzip theme package file $download_file_dir/main/jupiter.zip, abort."
    exit 1
fi

##### install jupiter theme #####
cp -r $download_file_dir/jupiter $WP_DIR_NAME/wp-content/themes/jupiter

##### install child theme #####
cp -r theme $WP_DIR_NAME/wp-content/themes/dreammaker

##### finish install #####
echo "======================================================================"
echo "Install Completed!"
echo "Please activate the dream maker theme and required plugins in"
echo "word press admin console right after you run this installation script!"
echo "                                                          by Hao Zhang"
echo "======================================================================"