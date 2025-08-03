local textureFolders = "";
local graphictag = "Snow-";
local textureResources = {
    ["snow"] = {file="snow",ofs={x=0,y=0},top=false},
};
local snowtag = 0;
local snowtagend = 0;
local snowmove = 150;
local snowlimit = 100;
local snowspeedx = {};
local snowspeedy = {};
function onCreate()
    --setProperty("camHUD.alpha",0.8)
end
function onUpdate(elp)
    if snowlimit > 0 then
        --debugPrint(snowtag.."  "..snowlimit)
        if snowtag < snowlimit then
            --debugPrint("fhislak")
            if math.random(1,100) > 80 then
                --debugPrint("saaaaaaaa")
                MakeSpritecode("snow",snowtag)
                setProperty(graphictag.."snow"..snowtag..".x",math.random(0,1980))
                snowscale = math.random(10,100)/100;
                setProperty(graphictag.."snow"..snowtag..".scale.x",snowscale)
                setProperty(graphictag.."snow"..snowtag..".scale.y",snowscale)
                snowspeedx[snowtag] = math.random(5,10)
                snowspeedy[snowtag] = math.random(5,7)
                --setProperty(graphictag.."snow"..snowtag..".color",getColorFromHex("0000FF"))
                snowtag = snowtag+1
            end
        end
        for i = 0,snowtag do
            setProperty(graphictag.."snow"..i..".y",getProperty(graphictag.."snow"..i..".y")+5*snowmove*elp*(snowspeedy[i]/10))
            setProperty(graphictag.."snow"..i..".x",getProperty(graphictag.."snow"..i..".x")-7*snowmove*elp*(snowspeedx[i]/10))
            if getProperty(graphictag.."snow"..i..".y") > 730 then
                setProperty(graphictag.."snow"..i..".x",math.random(0,1980))
                setProperty(graphictag.."snow"..i..".y",getProperty(graphictag.."snow"..i..".y")-750)
                snowscale = math.random(10,100)/100;
                setProperty(graphictag.."snow"..snowtag..".scale.x",snowscale)
                setProperty(graphictag.."snow"..snowtag..".scale.y",snowscale)
                snowspeedx[i] = math.random(5,10)
                snowspeedy[i] = math.random(5,7)
                --removeLuaSprite(graphictag.."snow"..i,true)
                --snowtagend = snowtagend+1
            end
        end
    else
        if math.random(1,100) > 80 then
            --debugPrint("saaaaaaaa")
            MakeSpritecode("snow",snowtag)
            setProperty(graphictag.."snow"..snowtag..".x",math.random(0,1780))
            --setProperty(graphictag.."snow"..snowtag..".color",getColorFromHex("FFFF00"))
            snowtag = snowtag+1
        end
        for i = snowtagend,snowtag do
            setProperty(graphictag.."snow"..i..".y",getProperty(graphictag.."snow"..i..".y")+5*snowmove*elp)
            setProperty(graphictag.."snow"..i..".x",getProperty(graphictag.."snow"..i..".x")-7*snowmove*elp)
            if getProperty(graphictag.."snow"..i..".y") > 730 then
                removeLuaSprite(graphictag.."snow"..i,true)
                snowtagend = snowtagend+1
            end
        end
    end
end

function MakeSpritecode(tag,st)
    makeLuaSprite(graphictag..tag..st,textureResources[tag].file,textureResources[tag].ofs.x,textureResources[tag].ofs.y)
    addLuaSprite(graphictag..tag..st,textureResources[tag].top)
    setObjectCamera(graphictag..tag..st, 'camOther')
    --debugPrint("complete")
end

function onCreate()
   makeLuaSprite('sky', 'snowy/sky', -500, -300);
	setScrollFactor('sky', 1, 1)
	scaleObject('sky', 2, 2)

   makeLuaSprite('city', 'snowy/city', -270, 0);
	setScrollFactor('city', 1, 1)
	scaleObject('city', 1, 1)

   makeLuaSprite('trees', 'snowy/trees', -1100, -300);
	setScrollFactor('trees', 1, 1)
	scaleObject('trees', 1, 1)

   makeLuaSprite('tree', 'snowy/tree', 350, -700);
	setScrollFactor('tree', 1, 1)
	scaleObject('tree', 1, 1)

   makeLuaSprite('stage', 'snowy/stage', -300, 670);
	setScrollFactor('stage', 1, 1)
	scaleObject('stags', 1.4, 1.4) 

   makeLuaSprite('lights1', 'snowy/fglight1', -1100, -400);
	setScrollFactor('lights', 1, 1)
	scaleObject('lights', 1, 1)

   makeLuaSprite('lights2', 'snowy/fglight2', -700, -300);
	setScrollFactor('lights2', 1, 1)
	scaleObject('lights2', 1, 1)

   makeLuaSprite('fg', 'snowy/fg', -900, 600);
	setScrollFactor('fg', 0.9, 0.9)
	scaleObject('fg', 1.3, 1.3)

   addLuaSprite('sky', false);
   addLuaSprite('city', false);
   addLuaSprite('trees', false);
   addLuaSprite('tree', false);
    addLuaSprite('stage', false);
    addLuaSprite('lights1', false);
    addLuaSprite('lights2', false);
    addLuaSprite('fg', true);
end