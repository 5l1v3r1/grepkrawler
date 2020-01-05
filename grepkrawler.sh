#!/bin/bash

if [ ! -x "$(command -v hakcrawler)" ]; then
        echo "[-] This script requires hakcrawler. Exiting."
        exit 1
fi

if [ ! -x "$(command -v assetfinder)" ]; then
        echo "[-] This script requires assetfinder. Exiting."
        exit 1
fi

url=$1

if [[ ! -d "$url/recon/hakrawler" ]];then
        mkdir -p $url/recon/hakrawler
fi

if [[ ! -d "$url/recon/hakrawler/recursive" ]];then
        mkdir $url/recon/hakrawler/recursive
fi


assetfinder $url | grep '$url' | hakrawler | tee -a $url/recon/hakrawler/hakrawler_init.txt
cat $url/recon/hakrawler/hakrawler_init.txt | grep "subdomains" | sort -u | tee -a $url/recon/hakrawler/subs.txt
cat $url/recon/hakrawler/hakrawler_init.txt | grep "form]" | sort -u | tee -a $url/recon/hakrawler/forms.txt
cat $url/recon/hakrawler/hakrawler_init.txt | grep "javascript" | sort-u | tee -a $url/recon/hakrawler/js.txt
cat $url/recon/hakrawler/hakrawler_init.txt | grep "robots" | sort -u | tee -a $url/recon/hakrawler/robots.txt
cat $url/recon/hakrawler/hakrawler_init.txt | grep "sitemap" | sort -u | tee -a $url/recon/hakrawler/sitemap.txt
cat $url/recon/hakrawler/hakrawler_init.txt | grep "url]" | sort -u | tee -a $url/recon/hakrawler/urls.txt


#recurisve hakcrawler
assetfinder $url | grep "$url" | hakcrawler | tee -a $url/recon/hakrawler/recursive/recursive_hakrawler.txt
cat $url/recon/hakrawler/recursive/recursive_hakrawler.txt | grep "subdomain" | rev | cut -d '[' -f 1 | rev | cut -c4- | sort -u | tee -a $url/recon/hakrawler/hakrawler_subs
for sub in $(cat $url/recon/hakrawler/recursive/hakrawler_subs);do
        hakrawler -domain $sub | tee -a $url/recon/hakrawler/recursive/$sub.txt
        cat $url/recon/hakrawler/recursive/$sub.txt | grep "subdomain" | rev | cut -d "[" -f 1 | cut -c4- | sort -u | tee -a $url/recon/hakcrawler/recursive/recursive_$sub.txt
        if [[ "$subdomain" == "$url" ]]; then
                hakrawler -domain $subdomain | tee -a $subdomain.txt
                cat $subdomain.txt | grep "subdomains" |sort -u | tee -a $url/recon/hakrawler/recursive/subs.txt
                cat $subdomain.txt | grep "form]" | sort -u | tee -a $url/recon/hakrawler/recursive/forms.txt
                cat $subdomain.txt | grep "javascript" | sort -u | tee -a $url/recon/hakrawler/recursive/js.txt
                cat $subdomain.txt | grep "robots" | sort -u |tee -a $url/recon/hakrawler/recursive/robots.txt
                cat $subdomain.txt | grep "url]" | sort -u |tee -a $url/recon/hakrawler/recursive/robots.txt
        fi
done
