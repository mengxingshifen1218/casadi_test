#!/usr/bin/env bash

# Fail on first error.
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo -e "\033[40;32m${DIR} \033[0m"

# download Ipopt

sudo apt-get install cppad gfortran 

wget https://www.coin-or.org/download/source/Ipopt/Ipopt-3.12.8.zip -O Ipopt-3.12.8.zip
unzip Ipopt-3.12.8.zip

# Step by step   
pushd Ipopt-3.12.8/ThirdParty/Blas
./get.Blas    
cd ../Lapack
./get.Lapack  
cd ../Mumps  
./get.Mumps  
cd ../Metis  
./get.Metis
cd ../ASL
./get.ASL

cd ..
cd ..

mkdir build  
cd build  
../configure  
make -j4  
make install  

cp -a include/* /usr/include/.  
cp -a lib/* /usr/lib/. 

popd

# Clean up.
cd ..
cd ..
apt-get clean && rm -rf /var/lib/apt/lists/*
rm -rf Ipopt-3.12.8.zip Ipopt-3.12.8

# download casadi
wget https://github.com/casadi/casadi/releases/download/3.5.5/casadi-3.5.5-1.tar.gz
tar -zxvf casadi-3.5.5-1.tar.gz
echo -e "\033[40;32mdownload finish \033[0m"

cd casadi-3.5.5.1
mkdir build && cd build
cmake .. -DWITH_IPOPT=ON -DWITH_EXAMPLES=OFF
make -j4
sudo make install
sudo ldconfig

# Clean up.
sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/*
sudo rm -fr casadi-3.5.5-1.tar.gz casadi-3.5.5.1
