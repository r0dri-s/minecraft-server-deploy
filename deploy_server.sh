#!/bin/bash
#---------------------------------------------------------------------------------------------------------------------------------------
Normal(){
        wget 'https://raw.githubusercontent.com/r0dri-s/minecraft-server-deploy/main/other_stuff/server.properties' -O "$name/server.properties" -q
        echo 'server.properties copied!'
        wget 'https://raw.githubusercontent.com/r0dri-s/minecraft-server-deploy/main/other_stuff/run.sh' -O "$name/run.sh" -q
        echo 'run.sh copied!'
        wget 'https://raw.githubusercontent.com/r0dri-s/minecraft-server-deploy/main/server_files/paper-'$version'.jar' -O "$name/server.jar" -q
        echo 'server.jar copied!'

        read -p 'Do you agree with the EULA? https://aka.ms/MinecraftEULA yes/no ' yn;
        case $yn in
                yes ) echo ok, we will proceed;;
                no ) echo exiting...;
                        rm -r "$name";
                        exit;;
                * ) echo invalid response;
                        exit 1;;
        esac
        wget 'https://raw.githubusercontent.com/r0dri-s/minecraft-server-deploy/main/other_stuff/eula.txt' -O "$name/eula.txt" -q
        echo 'eula.txt copied!'
        wget 'https://raw.githubusercontent.com/r0dri-s/minecraft-server-deploy/main/other_stuff/server-icon.png' -O "$name/server-icon.png" -q
        echo 'server-icon.png copied!'
        sed -i "s/^motd=/motd='$name'/" "$name"/server.properties
        case $sn in
        yes ) sed -i 's/^java -Xmx8192M -jar server.jar -nogui/usr/java-8/jre1.8.0_361/bin/java -Xmx'$ram'M -jar server.jar -nogui/' $name/run.sh;;
        no ) sed -i 's/^java -Xmx8192M -jar server.jar -nogui/java -Xmx'$ram'M -jar server.jar -nogui/' $name/run.sh;;
        esac
        case $online in
        (false) sed -i 's/^online-mode=true/online-mode=false/' "$name"/server.properties;;
        esac
        echo 'Server deployed!'
        }
        #---------------------------------------------------------------------------------------------------------------------------------------
        Forge(){
        mkdir "$name"
        wget 'https://serverjars.com/api/fetchJar/modded/forge/'$version -O "$name"/server.jar -q
        echo 'server.jar copied!'
        Normal
        }
        #---------------------------------------------------------------------------------------------------------------------------------------
        vanilla(){
        mkdir "$name"
        wget "https://serverjars.com/api/fetchJar/vanilla/vanilla/$version" -O "$name"/server.jar -q
        echo 'server.jar copied!'
        Normal        
        }
        #---------------------------------------------------------------------------------------------------------------------------------------
        paper(){
        mkdir "$name"
        wget "https://serverjars.com/api/fetchJar/servers/paper/$version" -O $name/server.jar -q
        echo 'server.jar copied!'
        Normal        
        }
        #---------------------------------------------------------------------------------------------------------------------------------------
        BadJava(){

        read -p 'The version you chose uses java 8 instead of java 17. Do you want to install it?root required' sn
        case $sn in
                [Yy]* ) sudo mkdir /usr/java-8
                        wget 'https://raw.githubusercontent.com/r0dri-s/minecraft-server-deploy/main/other_stuff/jre-8u361-linux-x64.tar.gz' -O '/usr/java-8/$version.tar.gz'
                        tar zxvf /usr/java-8/$version.tar.gz;;
                [Nn]* ) echo 'ok, we will proceed without...'
                        Normal;;
                * ) echo 'Please answer yes or no.';;
        esac
        }
        #---------------------------------------------------------------------------------------------------------------------------------------
        read -p "Enter your server name: " -e name
        read -p 'Enter your server RAM mb: ' -e ram
        read -p 'Select your server type Forge/Vanilla/Paper:' -e type
        read -p 'Enter your servers version [1.19.3]: ' -e version
        read -p 'Select online mode configurationtrue/false: ' -e online
        shopt -s nocasematch
        case "$type" in
        forge) Forge;;
        vanilla) vanilla;;
        paper) paper;;
        (*) echo 'Invalid option!'
        exit
        esac

        version=${version:-1.19.3}

        if [[ "$version" < '1.17.1' ]]; then
        BadJava
        else
        Normal
        fi