#!/bin/bash

#Please declare and make readable by the script a textfile with the domains

#Generate domains text file
plesk bin domain --list > /root/domains.txt

fDomainsList=/root/domains.txt
versions=/root/versions.txt

fDomainsList=$1
iPhpVersion=$2
while read -r sDomain ; do
	# check that the domain exists
    if [ $cpanelversion -eq 55 ]
    
    then plesk bin domain -u $sDomain -php_handler_id plesk-php55-cgi -nginx-serve-php false; done
	# run the version change for $sDomain using $iPhpVersion
    
    fi

	# check that the domain exists
    if [ $cpanelversion -eq 56 ]
    
    then plesk bin domain -u $sDomain -php_handler_id plesk-php56-cgi -nginx-serve-php false; done
	# run the version change for $sDomain using $iPhpVersion
    
    fi

    	# check that the domain exists
    if [ $cpanelversion -eq 70 ]
    
    then plesk bin domain -u $sDomain -php_handler_id plesk-php70-cgi -nginx-serve-php false; done
	# run the version change for $sDomain using $iPhpVersion
    
    fi

    	# check that the domain exists
    if [ $cpanelversion -eq 71 ]
    
    then plesk bin domain -u $sDomain -php_handler_id plesk-php71-cgi -nginx-serve-php false; done
	# run the version change for $sDomain using $iPhpVersion
    
    fi

    	# check that the domain exists
    if [ $cpanelversion -eq 72 ]
    
    then plesk bin domain -u $sDomain -php_handler_id plesk-php55-cgi -nginx-serve-php false; done
	# run the version change for $sDomain using $iPhpVersion
    
    fi

done < "$fDomainsList"


#485 domains cloud41
#115 cloud2
#600 domains

#!/bin/bash
#copy php*.txt domains file into root dir and run the script
#54
#cat /root/php54.txt | while read i; do plesk bin domain -u $i -php_handler_id plesk-php54-mod_php -nginx-serve-php false; done

#55
cat /root/php55.txt | while read i; do plesk bin domain -u $i -php_handler_id plesk-php55-cgi -nginx-serve-php false; done

#56
cat /root/php56.txt | while read i; do plesk bin domain -u $i -php_handler_id plesk-php56-cgi -nginx-serve-php false; done

#70
cat /root/php70.txt | while read i; do plesk bin domain -u $i -php_handler_id plesk-php70-cgi -nginx-serve-php false; done

#71
cat /root/php71.txt | while read i; do plesk bin domain -u $i -php_handler_id plesk-php71-cgi -nginx-serve-php false; done

#72
cat /root/php72.txt | while read i; do plesk bin domain -u $i -php_handler_id plesk-php72-cgi -nginx-serve-php false; done

#72inherit
cat /root/php72inherit.txt | while read i; do plesk bin domain -u $i -php_handler_id plesk-php72-cgi -nginx-serve-php false; done

#73
#cat /root/php73.txt | while read i; do plesk bin domain -u $i -php_handler_id plesk-php73-cgi -nginx-serve-php false; done



