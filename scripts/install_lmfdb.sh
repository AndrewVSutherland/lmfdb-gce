#!/usr/bin/env bash

set -e
_user="$(id -u -n)"
_uid="$(id -u)"
echo "User name : $_user"
echo "User name ID (UID) : $_uid"
#uid = 1200
if [ $_uid -ne 1300 ]
then
    echo "Only the user sage with UID = 1300 should be running this script"; exit 1;
fi


mkdir -p /home/lmfdb/logs/beta /home/lmfdb/logs/prod 
git clone --bare https://github.com/LMFDB/lmfdb.git /home/lmfdb/lmfdb.git

#checkout beta
mkdir -p /home/lmfdb/lmfdb-git-beta
pushd /home/lmfdb/lmfdb.git
export GIT_WORK_TREE=/home/lmfdb/lmfdb-git-beta
git checkout beta -f

#checkout prod
mkdir -p /home/lmfdb/lmfdb-git-prod
export GIT_WORK_TREE=/home/lmfdb/lmfdb-git-prod
git checkout prod -f
unset GIT_WORK_TREE
popd

git clone https://github.com/edgarcosta/lmfdb-gce.git /home/lmfdb/lmfdb-gce 
mkdir -p /home/lmfdb/logs/beta /home/lmfdb/logs/prod 
git clone https://github.com/LMFDB/lmfdb.git /home/lmfdb/lmfdb-git-beta
git clone https://github.com/LMFDB/lmfdb.git /home/lmfdb/lmfdb-git-prod

#checkout beta
pushd /home/lmfdb/lmfdb-git-beta
git checkout origin/beta -f
popd
#checkout prod
pushd /home/lmfdb/lmfdb-git-prod
git checkout origin/prod -f
popd


ln -s /home/lmfdb/lmfdb-gce/scripts/post-checkout-beta /home/lmfdb/lmfdb-git-beta/.git/hooks/post-checkout 
ln -s /home/lmfdb/lmfdb-gce/scripts/post-checkout-prod /home/lmfdb/lmfdb-git-prod/.git/hooks/post-checkout 
crontab  /home/lmfdb/lmfdb-gce/scripts/crontab
#linking (re)start and stop scripts
#linking (re)start and stop scripts
ln -s /home/lmfdb/lmfdb-gce/scripts/start-beta /home/lmfdb/start-beta 
ln -s /home/lmfdb/lmfdb-gce/scripts/start-prod /home/lmfdb/start-prod 
ln -s /home/lmfdb/lmfdb-gce/scripts/restart-beta /home/lmfdb/restart-beta 
ln -s /home/lmfdb/lmfdb-gce/scripts/restart-prod /home/lmfdb/restart-prod 

#linking config files
ln -s /home/lmfdb/lmfdb-gce/config/gunicorn-config-beta /home/lmfdb/lmfdb-git-beta 
ln -s /home/lmfdb/lmfdb-gce/config/gunicorn-config-prod /home/lmfdb/lmfdb-git-prod 
ln -s /home/lmfdb/lmfdb-gce/config/mongoclient_lmfdb0.config  /home/lmfdb/lmfdb-git-beta/mongoclient.config 
ln -s /home/lmfdb/lmfdb-gce/config/mongoclient_lmfdb0.config  /home/lmfdb/lmfdb-git-prod/mongoclient.config

# Read Password
echo -n MongoDB Password: 
read -s password
echo $password > /home/lmfdb/lmfdb-git-beta/password
echo $password > /home/lmfdb/lmfdb-git-prod/password

#You should be all set


set +e

