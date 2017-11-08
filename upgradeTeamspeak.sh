#!/bin/bash -       
#title           :upgradeTeamspeak.sh
#description     :This script updates Teamspeak3.
#author          :MarkNBroadhead
#date            :20171108
#version         :1.0    
#usage		       :./upgradeTeamspeak.sh
#notes           :Teamspeak3 must be installed at /usr/local/teamspeak3/.
#bash_version    :4.3.11(1)-release
#==============================================================================
echo "===== MARK's TEAMSPEAK UPDATER ====="

today=`date '+%Y-%m-%d-%H-%M-%S'`;
backup_file=TS3Backup$today.tar.gz
install_directory=/usr/local/teamspeak3/

echo "Downloading new binary"
for dl_url in $(curl -s http://www.teamspeak.com/en/downloads#server | grep -oE 'http.+teamspeak3-server_linux_amd64.+bz2'); do
  echo "downloading from $dl_url"
  wget $dl_url
  if [[ "$?" -eq "0" ]]; then
    echo "Successfully downloaded binary";
    break;
  else
    echo "Error downloading binary from $dl_url";
  fi
done

echo "Stopping Teamspeak server"
/usr/local/teamspeak3/ts3server_startscript.sh stop

echo "Backing up server and database to ~/$backup_file"
tar zcf ~/$backup_file -C /usr/local/ teamspeak3

echo "Deleting old server"
rm -rf /usr/local/teamspeak3/*

echo "Extracting new server files into $install_directory"
tar xjf teamspeak3-server_linux_amd64*.tar.bz2 -C $install_directory --strip-components=1

echo "Restoring database from backup"
tar xf TS3Backup$today.tar.gz -C /usr/local/ teamspeak3/ts3server.sqlitedb

echo "Starting server"
/usr/local/teamspeak3/ts3server_startscript.sh start

echo "Deleting teamspeak download"
rm teamspeak3-server_linux_amd64*.tar.bz2*
