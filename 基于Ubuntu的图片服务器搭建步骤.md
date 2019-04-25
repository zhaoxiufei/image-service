# 	基于Ubuntu的图片服务器搭建步骤

### 安装FastDFS  (请参照官网搭建,本教程不需要使用nginx)

### 安装Imagemagick

```bash
sudo apt install imagemagick
```

### 安装OpenResty

- 下载[OpenResty](https://openresty.org/download/openresty-1.13.6.2.tar.gz)

- 解压安装

  ``` bash
  tar -xvf openresty-1.13.6.2.tar.gz
  cd openresty-1.13.6.2
  ./configure --prefix=/opt/openresty/ --with-luajit
  make -j2 #双核j2 四核j4 以此类推
  make install
  ```

### 安装[magick](https://github.com/leafo/magick)

```bash
apt-get install luajit
apt-get install libmagickwand-dev
apt-get install luarocks
luarocks install magick
```

### 引入lua切图

1. 下载[脚本](https://github.com/zhaoxiufei/image-service)

2. 复制lua文件夹到/opt/openresty/nginx/conf 下

3. 修改image_convert.lua脚本

   ```bash
   vim lua/image_convert.lua
   local fdfs_tracker = '你的fastdfs地址'
   local image_root = '你的临时文件存放处'(注意权限问题)
   local image_404 = 配置404图片地址
   ```

4. 编辑nginx.conf 写入如下内容

   ```bash
   http {
      ... ...
       lua_package_path "/opt/openresty/nginx/conf/lua/?.lua;;";
   		
       server {
       ... ...
   		location /group {
   	    add_header Content-Type text/plain;
   	    #关闭缓存
   	    #lua_code_cache off;
   	    content_by_lua_file conf/lua/image_convert.lua;
   		}
   }
   ```
