#!/bin/bash
read -p "enter your server's name: " -e name
read -p "enter your server's RAM (mb): " -e ram
mkdir "$name"
wget "https://drive.google.com/u/1/uc?id=18KBLOHFc82uGAPMNAwpDG4DL8CUAa-1z&export=download" -O "$name"/server.properties -q
echo "server.properties copied!"
wget "https://drive.google.com/u/1/uc?id=1cn7z-oxSDnynRH4f32FoBE7LKekgZ75P&export=download" -O "$name"/run.sh -q
echo "run.sh copied!"
wget "https://drive.google.com/u/1/uc?id=1qmWa5_ISk_DOdfj-MWhTfey-_FrkbJEP&export=download" -O "$name"/server.jar -q
echo "server.jar copied!"

read -p "Do you agree with the EULA? (yes/no) " yn
case $yn in 
	yes ) echo ok, we will proceed;;
	no ) echo exiting...;
		rm -r "$name"
		exit;;
	* ) echo invalid response;
		exit 1;;
esac
wget "https://drive.google.com/u/1/uc?id=1pRcBuN9rWEEFkRyvwD1f8HrIyl_CLcoh&export=download" -O "$name"/eula.txt -q
echo "eula.txt copied!"
wget "https://drive.google.com/u/1/uc?id=1J1ETSY52SRBCUhX-ErG3jI4J06zg_Cw3&export=download" -O "$name"/server-icon.png -q
echo "server-icon.png copied!"
sed -i "s/^motd=.*/motd="$name"/" "$name"/server.properties
sed -i "s/^-Xmx8192M/-Xmx"$ram"M/" "$name"/server.properties
echo "Server deployed!"
