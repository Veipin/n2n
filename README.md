This repository is maintained very sparsely
===========================================

Consider using the version at https://github.com/ntop/n2n
as a lot of improvements from here have been ported to over
there.


This is a development branch of the n2n p2p vpn software.

https://github.com/ntop/n2n

It contains some modifications of the v2 version of n2n, which is the latest stable version
and should be used for productive environments.
All the current development happens in this repository in the new_protocol branch, which is 
intended to be come version v3 of n2n and then merged back into the original svn repository
on ntop.org.

Uses sglib http://sglib.sourceforge.net.

For further information please visit the wiki https://github.com/meyerd/n2n/wiki.


n2n编译：
N2N实现内网穿透： https://blog.51cto.com/11883699/2162071
源码： https://github.com/meyerd/n2n

#yum -y install cmake
#cmake --version
cmake version 2.8.12.2

使用cmake编译，例如cmake .. 表示CMakeLists.txt在当前目录的上一级目录。cmake后会生成很多编译的中间文件以及makefile文件，所以一般建议新建一个新的目录，专门用来编译，例如
cd n2n/n2n_v2
mkdir build
cd build
cmake ..
make

生成 supernode 和 edge 程序

1、如果在redhat6.4_64系统中没有cmake，yum命令无法使用，可将cmake-2.8.10.2.tar.gz复制到系统，使用 ./configure  ; gmake ; gmake install 安装；
2、如果在redhat6.4_64系统中make失败，找不到openssl/aes.h头文件
解决方法：编译openssl-1.1.0e.tar.gz完成后，将头文件文件夹openssl-1.1.0复制到/usr/include/ ，创建软链接 ln -sf openssl-1.1.0 openssl 
		  将libssl.so.1.1、libcrypto.so.1.1文件复制到/usr/lib64 ，创建软链接 ln -sf libcrypto.so.1.1 libcrypto.so ; ln -sf libcrypto.so.1.1 libcrypto.so.11 ; ln -sf libssl.so.1.1 libssl.so ; ln -sf libssl.so.1.1 libssl.so.11
3、在树莓派centos7_32系统中make失败，找不到openssl/aes.h头文件
解决方法：系统自带了/usr/lib/libcrypto.so.1.0.2k库，但是没有头文件，将openssl0.9.8文件夹复制到/usr/include/ ，创建软链接 ln -sf openssl0.9.8/openssl/ openssl ; cd /usr/lib ; ln -sf libcrypto.so.1.0.2k libcrypto.so
	      这样编译成功后edge将链接到/usr/lib/libcrypto.so.10
		  
		  
启动n2n：
1、在公网服务器114.114.114.114启动  
#./supernode -l 10000 -v >/dev/null &
2、在节点服务器1启动
#./edge -d n2n0 -c mynetwork -k keystr -a 10.0.0.1 -l 114.114.114.114:10000 >/dev/null &
   在节点服务器2启动
#./edge -d n2n0 -c mynetwork -k keystr -a 10.0.0.2 -l 114.114.114.114:10000 >/dev/null &
使用 pkill edge 退出vpn

3、在Windows节点启动n2n Gui，配置supernode地址，组名，密码， 重启即可；
点击安装n2nguien.exe，安装目录为 C:\Program Files\n2n Gui\，
使用VS2013编译 \n2n\n2n_v2\win32\DotNet 生成Release\edge.exe， 删除“C:\Program Files\n2n Gui\edge2.exe”文件并将生成的edge.exe改名为edge2.exe复制到这里，后续可以通过n2n Gui启动V2模式，
进程管理器后台可以看到： "C:\Program Files\n2n Gui\edge2.exe" -a 10.0.0.101 -c mynetwork -k keystr -l 114.114.114.114:10000


在 n2n\n2n_v2\build 目录下 edge2.exe为win7系统编译的节点程序； edge 为树莓派centos7_armv7l编译的节点程序； supernode 为183服务器上编译的中心节点程序，redhat6.5_64bit








