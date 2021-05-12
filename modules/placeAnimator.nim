import stb_image/read as stbi, stb_image/write as stbiw, strformat

type
    Image = object
        width: int
        height: int
        channels: int
        data: seq[uint8]
        pixels: seq[Pixel]  # 2d sequence of RGBA values with [x][y]
    Pixel = tuple
        r: uint8
        g: uint8
        b: uint8
        a: uint8


proc data2Pixels(data: seq[uint8], width, height: int): seq[Pixel] =
    var
        pixels: seq[Pixel]

    for i in countup(0, data.len-1, 4):
        pixels.add((r:data[i], g:data[i+1], b:data[i+2], a:data[i+3]))
    
    return pixels

proc getPixel(img: Image, x, y: int): Pixel =
    if x > img.width or y > img.height:
        var e: ref Exception
        e.msg = "x, y pixel coordinates out of range."
        raise e
    if x < 1 or y < 1:
        var e: ref Exception
        e.msg = "x, y, pixel coordinates 0 or negative. Needs to be more than 0."
        raise e
    return img.pixels[(x-1) + (y-1) * img.height]

proc setPixel(img: var Image, x, y: int, rgba: Pixel): void =
    img.pixels[(x-1) + (y-1) * img.height] = rgba

proc loadImage(fp: string): Image =
    var
        width, height, channels: int
        data: seq[uint8]
    
    data = stbi.load(fp, width, height, channels, stbi.Default)

    Image(width:width, height:height, channels:channels, data:data, pixels: data2Pixels(data, width, height))

var img = loadImage("modules/uncropped_nyan.png")

echo &"Width: {img.width}\nHeight: {img.height}\nChannels: {img.channels}\nData Size: {img.data.len}\nimg: {img.pixels.len}"

echo img.getPixel(480, 291)
var color = (r:255'u8, g:255'u8, b:255'u8, a:255'u8)
img.setPixel(480, 291, color)
echo img.getPixel(480, 291)