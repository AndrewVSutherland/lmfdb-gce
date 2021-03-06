#!/bin/bash
_user="$(id -u -n)"
_uid="$(id -u)"
echo "User name : $_user"
echo "User name ID (UID) : $_uid"
j=1;
echo "Using $j threads to compile"
set -e
#uid = 1200
if [ $_uid -ne 1200 ]
then
    echo "Only the user sage with UID = 1200 should be installing sage"; exit 1;
fi

if [ -n "$1" ]
then
    echo "Compiling version $1"
else
    echo "Needs at least on argument, the version desired"; exit 1;
fi

echo "Sleeping 5s"
sleep 5s;

version=$1
#sudo apt-get install binutils gcc g++ gfortran make m4 perl tar git libssl-dev
wget http://mirrors.xmission.com/sage/src/sage-${version}.tar.gz -O sage-${version}.tar.gz
tar xf sage-${version}.tar.gz
cd sage-${version} 
#it can get stuck here while building documentation
MAKE="make -j${j}" make 
make test 
make testlong 
./sage -i gap_packages 
./sage -i database_gap 
./sage -i pip 
./sage -b 
wget https://raw.githubusercontent.com/LMFDB/lmfdb/master/requirements.txt 
./sage -pip install -r requirements.txt 
./sage -pip install bcrypt 
./sage -pip install gunicorn pyflakes
./sage -pip install greenlet eventlet gevent 
./sage -b 
cd .. 
chmod a+rX -R sage-${version} 
echo "If you want this to be the new version to be used, don't forget to do:" 
echo "$ rm ~/sage-root && ln -s sage-${version} ~/sage-root" 
set +e

