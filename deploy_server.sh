#!/bin/bash
#---------------------------------------------------------------------------------------------------------------------------------------
Normal(){

mkdir "$name"
wget "https://raw.githubusercontent.com/r0dri-s/minecraft-server-deploy/main/other_stuff/server.properties" -O "$name"/server.properties -q
echo "server.properties copied!"
wget "https://raw.githubusercontent.com/r0dri-s/minecraft-server-deploy/main/other_stuff/run.sh" -O "$name"/run.sh -q
echo "run.sh copied!"
wget "https://raw.githubusercontent.com/r0dri-s/minecraft-server-deploy/main/server_files/paper-"$version".jar" -O "$name"/server.jar -q
echo "server.jar copied!"

read -p "Do you agree with the EULA? (https://aka.ms/MinecraftEULA) (yes/no) " yn
case $yn in
        yes ) echo ok, we will proceed;;
        no ) echo exiting...;
                rm -r "$name"
                exit;;
        * ) echo invalid response;
                exit 1;;
esac
wget "https://raw.githubusercontent.com/r0dri-s/minecraft-server-deploy/main/other_stuff/eula.txt" -O "$name"/eula.txt -q
echo "eula.txt copied!"
wget "https://raw.githubusercontent.com/r0dri-s/minecraft-server-deploy/main/other_stuff/server-icon.png" -O "$name"/server-icon.png -q
echo "server-icon.png copied!"
sed -i "s/^motd=.*/motd="$name"/" "$name"/server.properties
case $sn in
        yes ) sed -i "s/^java -Xmx8192M -jar server.jar -nogui/usr/java-8/jre1.8.0_361/bin/java -Xmx"$ram"M -jar server.jar -nogui/" "$name"/run.sh;;
	    no ) sed -i "s/^java -Xmx8192M -jar server.jar -nogui/java -Xmx"$ram"M -jar server.jar -nogui" "$name"/run.sh;
esac
echo "Server deployed!"
}
#---------------------------------------------------------------------------------------------------------------------------------------
Default(){
read -p "enter your server's name: " -e name
read -p "enter your server's RAM (mb): " -e ram
read -p "enter your server's version [1.19.3]: " -e version
version=${version:-1.19.3}

if [[ $version < "1.17.1" ]]; then
  BadJava
else
  Normal
fi
}
#---------------------------------------------------------------------------------------------------------------------------------------
BadJava(){

read -p "The version you chose uses java 8 instead of java 17. Do you want to install it?(root required)" sn
    case $sn in
        [Yy]* ) sudo mkdir /usr/java-8
        wget "https://raw.githubusercontent.com/r0dri-s/minecraft-server-deploy/main/other_stuff/jre-8u361-linux-x64.tar.gz" -O "/usr/java-8/1.tar.gz"
	tar zxvf jre-8u361-linux-x64.tar.gz;;
        [Nn]* ) echo "ok, we will proceed without..."
                Normal;;
        * ) echo "Please answer yes or no.";;
    esac
}
#---------------------------------------------------------------------------------------------------------------------------------------
Custom(){

read -p "enter your server's name: " -e name
read -p "enter your server's RAM (mb): " -e ram
read -p "enter your server's version [1.19.3]: " -e version
version=${version:-1.19.3}

}
#---------------------------------------------------------------------------------------------------------------------------------------
PS3='Please select your type of installation: '
options=("Default" "Custom" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Default")
            Default
            ;;
        "Custom")
            Custom
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option: $REPLY";;
    esac
done