import flippy, vmath, chroma

proc cropImg(fp:string): Image =
    var img = loadImage(fp)
    img


var img = cropImg("uncropped_nyan.png")
echo img