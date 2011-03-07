What is it?
===========

A little script to quickly add vhosts to your local apache configuration for development purposes.

Given a name like "mysite" and a path to the files for the site, it will make the site appear at http://mysite.local.

Usage
=====

	sudo add-vhost mysite ~/path/to/mysite/webroot

Installation
============

Make a directory to contain all the generated vhost config files:
	
	sudo mkdir /etc/apache2/extra/vhosts
	
Add this line to your /etc/apache2/httpd.conf file:
	
	Include /private/etc/apache2/extra/vhosts/*.conf
	
Ensure it's executable:

	chmod 0777 /path/to/add-vhost.rb
	
Link this into your /usr/local/bin like so:

	ln -s /path/to/add-vhost.rb /usr/local/bin/add-vhost
