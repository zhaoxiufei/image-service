# 图片服务器

### 技术栈:OpenResty+(ImagemMagick||GraphicsMagick)+FastDFS\
---
- 安装openresty+lua(略)
- 安装ImagemMagick或GraphicsMagick(略)
- 安装FastDFS(略)
- 将magick文件夹 复制到/opt/openresty/lualib 下
- 将nginx.conf 覆盖/opt/openresty/nginx/conf 下原有文件
- 将lua文件夹 复制到/opt/openresty/nginx/conf 下
### 使用说明

  原图
  http://localhost/group1/M00/00/0B/wKgFFFxidyGAR_YlAAMWCLrVDyk231.png   
  裁剪
  http://localhost/group1/M00/00/0B/wKgFFFxidyGAR_YlAAMWCLrVDyk231.png?s=thumb&a=64x64
  http://localhost/group1/M00/00/0B/wKgFFFxidyGAR_YlAAMWCLrVDyk231.png?s=thumb&a=500x300
  拉伸
  http://localhost/group1/M00/00/0B/wKgFFFxidyGAR_YlAAMWCLrVDyk231.png?s=resize&w=800&h=800
  旋转
  http://localhost/group1/M00/00/0B/wKgFFFxidyGAR_YlAAMWCLrVDyk231.png?s=rotate&d=90
  
  
### 感谢
   
   https://github.com/leafo/magick
   https://github.com/hpxl/nginx-lua-fastdfs-GraphicsMagick
   
