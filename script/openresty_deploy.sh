#!/bin/bash

deploy_path="/usr/local/Cellar"
deploy_dir="openresty-build-tools"
deploy_dir=$deploy_path"/"$deploy_dir

echo  -e "\033[32m -- start to install oepnresty -- \033[0m"
git clone https://github.com/kong/openresty-build-tools $deploy_dir
if [ $? -eq 0 ]; then
  echo  -e "\033[32m -- git clone success -- \033[0m"
fi

cd $deploy_dir

./kong-ngx-build -p build \
    --openresty 1.15.8.2 \
    --openssl 1.1.1g \
    --luarocks 3.2.1 \
    --pcre 8.43
    
if [ $? -eq 0 ]; then
  echo  -e "\033[32m -- openresty install success -- \033[0m"
else
  echo  -e "\033[31m -- openresty install failed -- \033[0m"
  exit 1
fi




echo -e "\033[32m backup .bash_profile \033[0m"
cp ~/.bash_profile  ~/.bash_profile_bak

echo -e "\033[32m write into env：.bash_profile \033[0m"

echo "# ==============================openresty env=============================="  >> ~/.bash_profile
echo "export PATH=$deploy_path/openresty-build-tools/build/openresty/bin:$deploy_path/openresty-build-tools/build/openresty/nginx/sbin:$deploy_path/openresty-build-tools/build/luarocks/bin:$PATH"  >> ~/.bash_profile
echo "export OPENSSL_DIR=$deploy_path/openresty-build-tools/build/openssl"  >> ~/.bash_profile
echo "export LUA_PATH='$deploy_path/openresty-build-tools/build/luarocks/share/lua/5.1/?.lua;./?.lua;$deploy_path/openresty-build-tools/build/openresty/luajit/share/luajit-2.1.0-beta3/?.lua;/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua;$deploy_path/openresty-build-tools/build/openresty/luajit/share/lua/5.1/?.lua;$deploy_path/openresty-build-tools/build/openresty/luajit/share/lua/5.1/?/init.lua;/Users/klook/.luarocks/share/lua/5.1/?.lua;/Users/klook/.luarocks/share/lua/5.1/?/init.lua;$deploy_path/openresty-build-tools/build/luarocks/share/lua/5.1/?/init.lua'"  >> ~/.bash_profile
echo "export LUA_CPATH='./?.so;/usr/local/lib/lua/5.1/?.so;$deploy_path/openresty-build-tools/build/openresty/luajit/lib/lua/5.1/?.so;/usr/local/lib/lua/5.1/loadall.so;/Users/klook/.luarocks/lib/lua/5.1/?.so;$deploy_path/openresty-build-tools/build/luarocks/lib/lua/5.1/?.so'" >> ~/.bash_profile


echo -e "\033[32m backup .zshrc \033[0m"
cp ~/.zshrc  ~/.zshrc_bak


echo "# ==============================openresty env=============================="  >> ~/.zshrc
echo "export PATH=$deploy_path/openresty-build-tools/build/openresty/bin:$PATH" >> ~/.zshrc
echo "export PATH=$deploy_path/openresty-build-tools/build/openresty/nginx/sbin:$PATH" >> ~/.zshrc
echo "export PATH=$deploy_path/openresty-build-tools/build/luarocks/bin:$PATH" >> ~/.zshrc
echo "export OPENSSL_DIR=$deploy_path/openresty-build-tools/build/openssl" >> ~/.zshrc
echo "export LUA_PATH='$deploy_path/openresty-build-tools/build/luarocks/share/lua/5.1/?.lua;./?.lua;$deploy_path/openresty-build-tools/build/openresty/luajit/share/luajit-2.1.0-beta3/?.lua;/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua;$deploy_path/openresty-build-tools/build/openresty/luajit/share/lua/5.1/?.lua;$deploy_path/openresty-build-tools/build/openresty/luajit/share/lua/5.1/?/init.lua;/Users/klook/.luarocks/share/lua/5.1/?.lua;/Users/klook/.luarocks/share/lua/5.1/?/init.lua;$deploy_path/openresty-build-tools/build/luarocks/share/lua/5.1/?/init.lua'" >> ~/.zshrc
echo "export LUA_CPATH='./?.so;/usr/local/lib/lua/5.1/?.so;$deploy_path/openresty-build-tools/build/openresty/luajit/lib/lua/5.1/?.so;/usr/local/lib/lua/5.1/loadall.so;/Users/klook/.luarocks/lib/lua/5.1/?.so;$deploy_path/openresty-build-tools/build/luarocks/lib/lua/5.1/?.so'" >> ~/.zshrc


echo -e "\033[32m Complete \033[0m"
echo -e "\033[32m pls source ~/.bash_profile or reopen terminal \033[0m"



