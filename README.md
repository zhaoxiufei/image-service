# 图片服务器
---

## 技术栈:OpenResty+(ImagemMagick||GraphicsMagick)+FastDFS
 

 - 安装ImagemMagick或GraphicsMagick(略)
 - 安装FastDFS(略)
 - 安装OpenResty
    
        ./configure --prefix=/opt/openresty/openresty --with-luajit
        make -j2
        make install
 - 将magick文件夹 复制到/opt/openresty/lualib 下
 - 将nginx.conf 覆盖/opt/openresty/nginx/conf 下原有文件
 - 将lua文件夹 复制到/opt/openresty/nginx/conf 下

## 基础配置
    
    lua/image_convert.lua文件
    local fdfs_tracker = '你的fastdfs地址'
    local image_root = '你的临时文件存放处'(注意权限问题)
## 使用说明

  原图
  
  http://localhost/group1/M00/00/0B/wKgFFFxidyGAR_YlAAMWCLrVDyk231.png   
  裁剪
  
  http://localhost/group1/M00/00/0B/wKgFFFxidyGAR_YlAAMWCLrVDyk231.png?s=thumb&a=64x64
  http://localhost/group1/M00/00/0B/wKgFFFxidyGAR_YlAAMWCLrVDyk231.png?s=thumb&a=500x300
  
  拉伸
  http://localhost/group1/M00/00/0B/wKgFFFxidyGAR_YlAAMWCLrVDyk231.png?s=resize&w=800&h=800
  
  旋转
  http://localhost/group1/M00/00/0B/wKgFFFxidyGAR_YlAAMWCLrVDyk231.png?s=rotate&d=90
  
  
## 感谢
   
   https://github.com/leafo/magick
   
   https://github.com/hpxl/nginx-lua-fastdfs-GraphicsMagick
   
