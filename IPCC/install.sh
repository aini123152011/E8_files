echo Welcome to install IPCC .
if uname -r | grep el6.x86_64 ; then 
echo -n "Start install IPCC ? (yes(y)|no(n)): "
read select
case $select in

yes|y)
yum install -y bison bison-devel dos2unix gcc gcc-c++ gettext gnutls-devel httpd kernel libcurl-devel libdbi-dbd-mysql libtool-ltdl-devel libuuid-devel libxml2 libxml2-devel mysql mysql-devel mysql-server mysql-connector-odbc ncurses ncurses-devel unixODBC unixODBC-devel openssl openssl-devel patch perl-DBD-Pg php php-gd php-mysql php-odbc pptp pptp-setup speex speex-devel sqlite sqlite-devel uuid uuid-devel zlib zlib-devel
rpm -ivh --force kernel-2.6.32-431.el6.x86_64.rpm kernel-devel-2.6.32-431.el6.x86_64.rpm kernel-headers-2.6.32-431.el6.x86_64.rpm kernel-firmware-2.6.32-431.el6.noarch.rpm

mkdir -p /voice
if grep voice /etc/fstab ; then echo ok; else echo 'tmpfs /voice tmpfs size=512m 0 0' >> /etc/fstab; fi

cat > /etc/my.cnf << EOF
[client]
port=3306
default-character-set=utf8
[mysqld]
default-character-set=utf8
max_connections=320
interactive_timeout=310000
wait_timeout=31000
query_cache_size=48M
table_cache=320
tmp_table_size=52M
thread_cache_size=8
sort_buffer_size=256K
innodb_thread_concurrency=8
myisam-recover=FORCE
max_allowed_packet=32M
innodb_file_per_table=1
lower_case_table_names=1
EOF

echo '* soft nofile 102400' > /etc/security/limits.conf
echo '* hard nofile 102400' >> /etc/security/limits.conf

sed -i 's/enforcing/disabled/' /etc/selinux/config
chkconfig --level 345 kudzu off
chkconfig --level 345 iscsid off
chkconfig --level 345 ip6tables off
chkconfig --level 345 iptables off
chkconfig --level 345 isdn off
chkconfig --level 345 auditd off
chkconfig --level 345 cpuspeed off
chkconfig --level 345 iscsi off
chkconfig --level 345 portmap off
chkconfig --level 345 nfslock off
chkconfig --level 345 rpcidmapd off
chkconfig --level 345 rpcgssd off
chkconfig --level 345 bluetooth off
chkconfig --level 345 xinetd off
chkconfig --level 345 xfs off
chkconfig --level 345 sendmail off
chkconfig --level 345 postfix off
chkconfig --level 345 gpm off
chkconfig --level 345 anacron off
chkconfig --level 345 atd off
chkconfig --level 345 yum-updatesd off
chkconfig --level 345 httpd on
chkconfig --level 345 mysqld on

tar xzvf ipcc.tgz -C /
chkconfig asterisk on

pptpsetup --create admin --server 42.96.195.103 --username 1001 --password 1001

echo -n "Server Key : "
ip link|grep 'link/ether'|awk '{print $2}'|sort|sed 's/://g'|awk '{printf $0}'
echo
echo -n "Please input license key : "
read license
echo $license > /root/ipcc/etc/asterisk/license.dat

;;

*)
;;
esac

else echo "Stopped install IPCC ,Because not found Centos6.x 64 Bit"; fi
