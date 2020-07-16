#!/bin/bash
#This script run every 5 minutes
#You will need to provide a rsa local key to connect to a destinated Master DNS server
#Create a domains-old list null fill at first run, remove the following commented line to do it
#Create a /root/.ssh/config file to connect to masterdns 
#Example
#Host masterdns
#    HostName plesk.shservers.com
#    User root
#    Port 2233
#    IdentityFile ~/.ssh/id_rsa

#cat /etc/named.conf | grep zone | awk '{print $2}'  | sed -e 's/^"//' -e 's/"$//' | tail -n +3  > /tmp/domains-old.list
#Modify /etc/named.conf and paste that code outside options and modify to include /etc/named.zones in internal and external view
##acl dns
#acl common-allow-transfer {
#        none;
#};



#sync files to local named.conf
rsync -a -z --delete root@masterdns:/var/named/chroot/etc/named.conf /tmp/named.master.conf
cat /tmp/named.master.conf | tail -n +44  | head -n -3 > /etc/named.zones

#make list to compare domains
cat /tmp/named.master.conf | grep zone | awk '{print $2}'  | sed -e 's/^"//' -e 's/"$//' | tail -n +3  > /tmp/domains.list


#If the file is diff to the old one copy new one with the new domains and delete the deteled domains

#Variables for comparison
oldlist="/tmp/domains-old.list"
newlist="/tmp/domains.list"



if [[ "`cat $oldlist`" != "`cat $newlist`" ]]

then

#sync files to dns slave
rsync -a --files-from=:/tmp/domains.list --exclude "run" --exclude "localhost.rev" --exclude "localhost.rev.saved_by_psa" --exclude "named.root" --exclude "make-localhost" --exclude "PROTO.localhost.rev" root@masterdns:/var/named/chroot/var/ /var/named/ 

#delete the remote deleted zones
diff /tmp/domains.list /tmp/domains-old.list | sed -r "s/^(.{0})(.{2})/\1\/var\/named\//" > /tmp/domains.deleted
#Redir errors format to null
xargs rm < /tmp/domains.deleted 2>/dev/null

#restart PowerDNS
/scripts/restartsrv_pdns

#Delete domains deleted file
rm /tmp/domains.deleted

#Rotate domain list
mv /tmp/domains.list /tmp/domains-old.list

fi



