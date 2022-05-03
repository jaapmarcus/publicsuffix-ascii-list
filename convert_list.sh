#!/bin/bash 
apt-get update
apt-get install git idn2 -y
git clone https://github.com/publicsuffix/list.git
CHARSET="UTF-8"

while read -r tld; do

if [ -n "$tld" ]; then
    if ! echo "$tld" | grep '//' > /dev/null; then
        echo "$tld"
        out=$(idn2 $tld)
        echo $out >> public_suffix_ascii_list.new.dat 
    fi
fi
if  echo "$tld" | grep 'END ICANN DOMAINS' > /dev/null; then
    echo "STOP"
    break
fi
done < ./list/public_suffix_list.dat

if [ -f "public_suffix_ascii_list.dat" ]; then
    touch public_suffix_ascii_list.dat
fi

if diff public_suffix_ascii_list.dat public_suffix_ascii_list.new.dat; then
    rm  public_suffix_ascii_list.dat
    mv  public_suffix_ascii_list.new.dat public_suffix_ascii_list.dat
    git add public_suffix_ascii_list.dat
    git commit -m "Update Public suffix list"
    git push
fi 

rm public_suffix_ascii_list.new.dat
rm public_suffix_list.dat