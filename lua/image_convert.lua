
local magick = require('magick')
local fastdfs = require('restyfastdfs')

-- http://192.168.5.20/group1/M00/00/0B/wKgFFFxidyGAR_YlAAMWCLrVDyk231.png?s=thumb&a=400x600
-- fastdfs 配置
local fdfs_tracker = '192.168.5.20'

local image_root = '/home/magic/images'
local uri = ngx.var.uri
ngx.log(ngx.INFO, 'uri:[', uri, ']') -- /group1/M00/00/0B/wKgFFFxidyGAR_YlAAMWCLrVDyk231.png
local request_uri = ngx.var.request_uri
ngx.log(ngx.INFO, 'request_uri:[', request_uri, ']') -- /group1/M00/00/0B/wKgFFFxidyGAR_YlAAMWCLrVDyk231.png?s=thumb&a=400x600
local source = image_root .. uri
ngx.log(ngx.INFO, 'source:[', source, ']') -- /home/magic/images/group1/M00/00/0B/wKgFFFxidyGAR_YlAAMWCLrVDyk231.png

-- 最后一个索引位置
function findLast(haystack, needle)
    local i = haystack:match(".*" .. needle .. "()")
    if i == nil then return nil else return i - 1 end
end

-- 写入文件
function writefile(filename, info)
    local wfile = io.open(filename, "w") --写入文件(w覆盖)
    assert(wfile) --打开时验证是否出错
    wfile:write(info) --写入传入的内容
    wfile:close() --调用结束后记得关闭
end

-- 检测路径是否目录
function is_dir(sPath)
    if type(sPath) ~= "string" then return false end
    local response = os.execute("cd " .. sPath)
    if response == 0 then
        return true
    end
    return false
end

-- 检测文件是否存在
function file_exists(name)
    local f = io.open(name, "r")
    if f ~= nil then io.close(f) return true else return false end
end

local image_dir = image_root .. string.sub(uri, 0, findLast(uri, '/')) -- /home/magic/images/group1/M00/00/0B/
ngx.log(ngx.INFO, 'image_dir:[', image_dir, ']')
if not file_exists(source) then
    local file_id = string.sub(uri, 2)
    local fdfs = fastdfs:new()
    fdfs:set_tracker(fdfs_tracker, 22122)
    fdfs:set_timeout(1000)
    fdfs:set_tracker_keepalive(0, 100)
    fdfs:set_storage_keepalive(0, 100)
    local data = fdfs:do_download(file_id)
    if data then
        -- check image dir
        if not is_dir(image_dir) then
            os.execute('mkdir -p ' .. image_dir)
        end
        writefile(source, data)
    end
end

local args = ngx.req.get_uri_args()
local image_service = args['s']
ngx.log(ngx.INFO, 'image service:[', image_service, ']') -- thumb
if image_service == nil then
    -- 获取原图
    -- local file = io.open(original_file);
    -- local source_image = file:read('*all')
    -- file:close()
    ngx.log(ngx.INFO, 'get source image!')
    -- ngx.say(source_image)
    local img = magick.load_image(source)
    ngx.say(img:get_blob())
elseif image_service == 'thumb' then
    -- thumb 裁切（缩放）
    -- args
    local image_action = args['a']
    local image_name
    -- get from cache
    local cache_key = image_root .. ngx.var.request_uri
    ngx.log(ngx.INFO, 'cache_key:', cache_key)
    if file_exists(cache_key) then
        ngx.log(ngx.INFO, image_service, ', cache hit! cache key: ', cache_key)
        image_name = source
    else
        magick.thumb(source, image_action, cache_key)
        image_name = cache_key
    end
    local img = magick.load_image(cache_key)
    ngx.say(img:get_blob())
elseif image_service == 'resize' then
    -- 图片拉伸
    -- args, 目标宽和高
    local width = tonumber(args['w'])
    local height = tonumber(args['h'])

    -- source info
    local img = magick.load_image(source)
    ngx.log(ngx.INFO, 'source width:', img:get_width(), 'source height:', img:get_height());
    ngx.log(ngx.INFO, image_service, ', arg, width:', width, ', height:', height)
    img:resize(width, height)
    ngx.say(img:get_blob())

elseif image_service == 'rotate' then
    -- 图片旋转
    -- args, 旋转度数
    local degrees = tonumber(args['d'])

    local img = magick.load_image(source)
    img:rotate(degrees)
    ngx.say(img:get_blob())
else
    ngx.say('unknow image service!')
end

