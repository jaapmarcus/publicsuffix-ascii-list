#!/bin/bash 
apt-get update
apt-get install git idn2 wget -y
wget https://raw.githubusercontent.com/publicsuffix/list/master/public_suffix_list.dat
export LC_ALL=C
stop=0;
while read -r tld; do

if [ -n "$tld" ]; then
    if ! echo "$tld" | grep '//' > /dev/null; then
        echo $tld LC_ALL= idn2
                
        #echo "$out" >> public_suffix_ascii_list.new.dat 
    fi
fi
if  echo "$tld" | grep 'END ICANN DOMAINS' > /dev/null; then
    echo "STOP"
    break
fi
done < ./public_suffix_list.dat

if [ -f "public_suffix_ascii_list.dat" ]; then
    touch public_suffix_ascii_list.dat
fi

diff -q $dst $new public_suffix_ascii_list.dat public_suffix_ascii_list.new.dat > /dev/null
if [ $? ]; then
    echo "Commit changes"
    rm public_suffix_ascii_list.dat 
    mv public_suffix_ascii_list.new.dat public_suffix_ascii_list.dat
fi 

rm public_suffix_ascii_list.new.dat
rm public_suffix_list.dat