-- camera 
require "camera"
http = require("socket.http")
require ("ltn12")
local utf8 = require("utf8")

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf('no')

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

-- Cette ligne permet de déboguer pas à pas dans ZeroBraneStudio
if arg[#arg] == "-debug" then require("mobdebug").start() end

largeurEcran = 800
hauteurEcran = 600

LARGEURTILE = 16
HAUTEURTILE = 16

debugmode = false

imgDecor = {}
imgDecor[0] = love.graphics.newImage("ressources/lvldesign/sol.png")
imgDecor[1] = love.graphics.newImage("ressources/lvldesign/mur.png")
imgDecor[2] = love.graphics.newImage("ressources/lvldesign/SafeZoneSansBord.png")
imgDecor[3] = love.graphics.newImage("ressources/lvldesign/spawn.png")
imgDecor[4] = love.graphics.newImage("ressources/lvldesign/spawnfin.png")

imgPrincipal = love.graphics.newImage("ressources/titrePrincipal.png")


-- LANGUAGES
français = false
anglais = false

tradlanguage = ""
tradControls = ""

touchx = 0
touchy = 0

scores = 0

-- Spawn du joueur
spawn = {}
spawn.depart = {}
spawn.depart.sprite = love.graphics.newImage("ressources/lvldesign/spawn.png")

mousex = 0
mousey = 0

-- Spawn de fin
spawn.fin = {} 
spawn.fin.sprite = love.graphics.newImage("ressources/lvldesign/spawnfin.png")


-- Propriété du personnage 
player = {}
player.sprite = love.graphics.newImage("ressources/VaisseauRIGHT.png")
player.x = 0
player.y = 0
player.speed = 81
--player.maxSpeed = 100
player.l = player.sprite:getWidth()
player.h = player.sprite:getHeight()

IA = {}
IA.sprite = love.graphics.newImage("ressources/IA1.png")
IA.id = 0
IA.speed = 100
IA.x = 0
IA.y = 0





-- BONUS 
bonus = {}
bonus.speed = {}
bonus.speed.sprite = love.graphics.newImage("ressources/lvldesign/speed+.png")


-- PIEGE

-- Bouge Vertical
piege = {}
piege.bougeVertical1 = {}
piege.bougeVertical1.sprite = love.graphics.newImage("ressources/lvldesign/piegeBougeVertical.png")
piege.bougeVertical1.speed = 20

piege.bougeVertical1.x = 0
piege.bougeVertical1.y = 0

piege.bougeVertical2 = {}
piege.bougeVertical2.sprite = love.graphics.newImage("ressources/lvldesign/piegeBougeVertical.png")
piege.bougeVertical2.speed = 40

piege.bougeVertical2.x = 0
piege.bougeVertical2.y = 0


piege.bougeHorizontal1 = {}
piege.bougeHorizontal1.sprite = love.graphics.newImage("ressources/lvldesign/piegeBougeHorizontal.png")
piege.bougeHorizontal1.speed = 20

piege.bougeHorizontal1.x = 0
piege.bougeHorizontal1.y = 0

timeBougeVertical = 0

timeBougeHorizontal = 0


balayageVertical = {}
balayageVertical.x = -2
balayageVertical.y = 0
balayageVertical.speed = 70

balayageVertical.active = false
balayageVertical.sens = 0


balayageHorizontal = {}
balayageHorizontal.x = 0
balayageHorizontal.y = -2
balayageHorizontal.speed = 70

balayageHorizontal.active = false
balayageHorizontal.sens = 0






-- Affichage ou pas sur l'ecran

afficheMainMenu = false
afficheMenu = false
afficheOptions = false
afficheSelectVirus = false
afficheClassement = false
afficheFin = false

-- FONT
_fontGame = love.graphics.newFont("fonts/visitor2.ttf",19)
_fontGame1 = love.graphics.newFont("fonts/visitor2.ttf",10)
_fontGameDebut = love.graphics.newFont("fonts/visitor2.ttf",100)


_fontMenu = love.graphics.newFont("fonts/visitor1.ttf",10)



-- POUR LE TACTILE

controls = {}
controls.haut = {}
controls.haut.sprite = love.graphics.newImage("ressources/controls/flechehaut.png")

controls.bas = {}
controls.bas.sprite = love.graphics.newImage("ressources/controls/flechebas.png")

controls.gauche = {}
controls.gauche.sprite = love.graphics.newImage("ressources/controls/flechegauche.png")

controls.droite = {}
controls.droite.sprite = love.graphics.newImage("ressources/controls/flechedroite.png")


controls.haut.x = camera.x
controls.haut.y = camera.y

controls.bas.x = camera.x
controls.bas.y = camera.y

controls.gauche.x = camera.x
controls.gauche.y = camera.y

controls.droite.x = camera.x
controls.droite.y = camera.y

nameVirus = {}
nameVirus.x = 0
nameVirus.y = 0
nameVirus.name = ""

typeControls = ""

toucheEcran = false

-- MENU PRINCIPAL 
menu = {}
menu.principal = {}
menu.principal.x = -70
menu.principal.y = 30

menu.play = {}
menu.play.x = -50
menu.play.y = 40

menu.options = {}
menu.options.x = -50
menu.options.y = 40

menu.leaderboard = {}
menu.leaderboard.x = -50
menu.leaderboard.y = 60

menu.quit = {}
menu.quit.x = -50
menu.quit.y = 80


-- CONTROLS
fleche = false
zqsd = true
wasd = false

-- MENU OPTIONS
menuOptions = {}
menuOptions.principal = {}
menuOptions.x = 0
menuOptions.y = 0

menuOptions.langue = {}
menuOptions.langue.x = 0
menuOptions.langue.y = 0

menuOptions.apply = {}
menuOptions.apply.x = 0
menuOptions.apply.y = 0

menuOptions.controls = {}
menuOptions.controls.x = 0
menuOptions.controls.y = 0

menuOptions.musics = {}
menuOptions.musics.x = 0
menuOptions.musics.y = 0

menuOptions.sounds = {}
menuOptions.sounds.x = 0
menuOptions.sounds.y = 0


-- MENU SELECTION VIRUS
menuSelectVirus = {}
menuSelectVirus.selectyourvirus = {}
menuSelectVirus.selectyourvirus.x = 0
menuSelectVirus.selectyourvirus.y = 0


menuSelectVirus.selectyourvirus.original = {}
menuSelectVirus.selectyourvirus.original.sprite = love.graphics.newImage("ressources/skins/original/down.png")
menuSelectVirus.selectyourvirus.original.x = 0
menuSelectVirus.selectyourvirus.original.y = 0

menuSelectVirus.selectyourvirus.bleu = {}
menuSelectVirus.selectyourvirus.bleu.sprite = love.graphics.newImage("ressources/skins/bleu/down.png")
menuSelectVirus.selectyourvirus.bleu.x = 0
menuSelectVirus.selectyourvirus.bleu.y = 0

menuSelectVirus.selectyourvirus.jaune = {}
menuSelectVirus.selectyourvirus.jaune.sprite = love.graphics.newImage("ressources/skins/jaune/down.png")
menuSelectVirus.selectyourvirus.jaune.x = 0
menuSelectVirus.selectyourvirus.jaune.y = 0

menuSelectVirus.selectyourvirus.rose = {}
menuSelectVirus.selectyourvirus.rose.sprite = love.graphics.newImage("ressources/skins/rose/down.png")
menuSelectVirus.selectyourvirus.rose.x = 0
menuSelectVirus.selectyourvirus.rose.y = 0

menuSelectVirus.selectyourvirus.rouge = {}
menuSelectVirus.selectyourvirus.rouge.sprite = love.graphics.newImage("ressources/skins/rouge/down.png")
menuSelectVirus.selectyourvirus.rouge.x = 0
menuSelectVirus.selectyourvirus.rouge.y = 0

menuSelectVirus.selectyourvirus.originalV = {}
menuSelectVirus.selectyourvirus.originalV.sprite = love.graphics.newImage("ressources/skins/originalV/down.png")
menuSelectVirus.selectyourvirus.originalV.x = 0
menuSelectVirus.selectyourvirus.originalV.y = 0

SelectVirusP = ""

virus = {}
virus.skins = {}

-- ORIGINAL
virus.skins.original = {}
virus.skins.original.start = love.graphics.newImage("ressources/skins/original/right.png")
virus.skins.original.up = love.graphics.newImage("ressources/skins/original/up.png")
virus.skins.original.down = love.graphics.newImage("ressources/skins/original/down.png")
virus.skins.original.right = love.graphics.newImage("ressources/skins/original/right.png")
virus.skins.original.left = love.graphics.newImage("ressources/skins/original/left.png")
virus.skins.original.power = false



-- BLEU
virus.skins.bleu = {}
virus.skins.bleu.start = love.graphics.newImage("ressources/skins/bleu/right.png")
virus.skins.bleu.up = love.graphics.newImage("ressources/skins/bleu/up.png")
virus.skins.bleu.down = love.graphics.newImage("ressources/skins/bleu/down.png")
virus.skins.bleu.right = love.graphics.newImage("ressources/skins/bleu/right.png")
virus.skins.bleu.left = love.graphics.newImage("ressources/skins/bleu/left.png")

-- JAUNE
virus.skins.jaune = {}
virus.skins.jaune.start = love.graphics.newImage("ressources/skins/jaune/right.png")
virus.skins.jaune.up = love.graphics.newImage("ressources/skins/jaune/up.png")
virus.skins.jaune.down = love.graphics.newImage("ressources/skins/jaune/down.png")
virus.skins.jaune.right = love.graphics.newImage("ressources/skins/jaune/right.png")
virus.skins.jaune.left = love.graphics.newImage("ressources/skins/jaune/left.png")
 virus.skins.jaune.power = false
 
-- originalV
virus.skins.originalV = {}
virus.skins.originalV.start = love.graphics.newImage("ressources/skins/originalV/right.png")
virus.skins.originalV.up = love.graphics.newImage("ressources/skins/originalV/up.png")
virus.skins.originalV.down = love.graphics.newImage("ressources/skins/originalV/down.png")
virus.skins.originalV.right = love.graphics.newImage("ressources/skins/originalV/right.png")
virus.skins.originalV.left = love.graphics.newImage("ressources/skins/originalV/left.png")

-- ROUGE
virus.skins.rouge = {}
virus.skins.rouge.start = love.graphics.newImage("ressources/skins/rouge/right.png")
virus.skins.rouge.up = love.graphics.newImage("ressources/skins/rouge/up.png")
virus.skins.rouge.down = love.graphics.newImage("ressources/skins/rouge/down.png")
virus.skins.rouge.right = love.graphics.newImage("ressources/skins/rouge/right.png")
virus.skins.rouge.left = love.graphics.newImage("ressources/skins/rouge/left.png")
virus.skins.rouge.speed = 120

-- ROSE
-- POUVOIR - il a une vie supplementaire
virus.skins.rose = {}
virus.skins.rose.start = love.graphics.newImage("ressources/skins/rose/right.png")
virus.skins.rose.up = love.graphics.newImage("ressources/skins/rose/up.png")
virus.skins.rose.down = love.graphics.newImage("ressources/skins/rose/down.png")
virus.skins.rose.right = love.graphics.newImage("ressources/skins/rose/right.png")
virus.skins.rose.left = love.graphics.newImage("ressources/skins/rose/left.png")



curseurmenu = {}
curseurmenu.sprite = love.graphics.newImage("ressources/controls/cursor.png")
curseurmenu.x = 0
curseurmenu.y = 0

curseurmenu2 = {}
curseurmenu2.sprite = love.graphics.newImage("ressources/controls/cursor2.png")
curseurmenu2.x = 0
curseurmenu2.y = 0

positioncurseur = 1
positionhorizontal = 1
positionhorizontal2 = 1
positionhorizontal3 = 1
positionhorizontalClassement = 1
NomClassement = ""
positioncurseur2 = 1
soundVolumeDisplay = 0
musicVolumeDisplay = 0


playerStart = love.graphics.newImage("ressources/VaisseauUP.png")
playerDOWN = love.graphics.newImage("ressources/VaisseauDOWN.png")
playerUP = love.graphics.newImage("ressources/VaisseauUP.png")
playerRIGHT = love.graphics.newImage("ressources/VaisseauRIGHT.png")
playerLEFT = love.graphics.newImage("ressources/VaisseauLEFT.png")

activereturn = 0

stopTimer = false
yourTime = 0

scanTime = 15

timer = 0



Scan = false
Safe = false

pause = false

keyPause = 0

gameOver = false


timerDebut = 1.5
activeTimer = true

timeaffiche = 0


function ChangeColor(pChaine,pX,pY)
  
  local rx = pX
  local ry = pY
  
  
  
  love.graphics.setColor(255,255,255)
  local i
  local ignore =  0
  for i=1,string.len(pChaine) do
    if ignore == 0 then
      local c = string.sub(pChaine,i,i)
      
      if c == "%" then
        ignore = 1
          local color = string.sub(pChaine,i+1,i+1)
        if color == "1" then
          love.graphics.setColor(255,0,0)
        elseif color == "3" then
          love.graphics.setColor(0,255,255)
        elseif color == "2" then
          love.graphics.setColor(0,255,0)
        elseif color == "0" then
          love.graphics.setColor(255,255,255)
        end
      else
        love.graphics.print(c, rx, ry)
        rx = rx + _fontMenu:getWidth(c)
      end
    else
      ignore = ignore - 1
    end
    
    
  end
  
end

function ChangeInColor(pChaine,pX,pY,pR,pSX)
  
  local rx = pX
  local ry = pY
  local r = pR
  local sx = pSX
  
  love.graphics.setColor(255,255,255)
  local i
  local ignore =  0
  for i=1,string.len(pChaine) do
    if ignore == 0 then
      local c = string.sub(pChaine,i,i)
      
      if c == "%" then
        ignore = 1
          local color = string.sub(pChaine,i+1,i+1)
        if color == "1" then
          love.graphics.setColor(255,0,0)
        elseif color == "3" then
          love.graphics.setColor(0,255,255)
        elseif color == "2" then
          love.graphics.setColor(0,255,0)
        elseif color == "0" then
          love.graphics.setColor(255,255,255)
        end
      else
        love.graphics.print(c, rx, ry, r, sx)
        rx = rx + _fontGame1:getWidth(c)
      end
    else
      ignore = ignore - 1
    end
    
    
  end
  
end

function ChangeInColor2(pChaine,pX,pY,pR,pSX)
  
  local rx = pX
  local ry = pY
  local r = pR
  local sx = pSX
  
  love.graphics.setColor(255,255,255)
  local i
  local ignore =  0
  for i=1,string.len(pChaine) do
    if ignore == 0 then
      local c = string.sub(pChaine,i,i)
      
      if c == "%" then
        ignore = 1
          local color = string.sub(pChaine,i+1,i+1)
        if color == "1" then
          love.graphics.setColor(255,0,0)
        elseif color == "3" then
          love.graphics.setColor(0,255,255)
        elseif color == "2" then
          love.graphics.setColor(0,255,0)
        elseif color == "0" then
          love.graphics.setColor(255,255,255)
        end
      else
        love.graphics.print(c, rx, ry, r, sx)
        rx = rx + _fontGameDebut:getWidth(c)
      end
    else
      ignore = ignore - 1
    end
    
    
  end
  
end



function ResetGame()
  activeTimer = true
  balayageVertical.x = -2
  balayageHorizontal.y = -2
  
  timerDebut = 1.5
  Scan = false
  pause = false
  keyPause = 0
  love.audio.stop(lvl1Music)

  
  player.speed = 81

  scanTime = 15

  timer = 0
 
  
end

function Fin()
  love.audio.play(leaderboardMusic)
  love.audio.play(leaderboardMusic_rose)
  -- Merci a Jimmy Labodudev pour son aide
  if SelectVirusP == "original" then 
    love.audio.stop(leaderboardMusic_rose)
    love.audio.play(leaderboardMusic)
    b, c, h = http.request("http://ver-infect.atspace.cc/getData_original.php")
  end
  if SelectVirusP == "originalV" then
    love.audio.stop(leaderboardMusic_rose)
    love.audio.play(leaderboardMusic)
    b, c, h = http.request("http://ver-infect.atspace.cc/getData_originalV.php")
    love.audio.play(leaderboardMusic)
  end
  if SelectVirusP == "rouge" then
    love.audio.stop(leaderboardMusic_rose)
    love.audio.play(leaderboardMusic)
    b, c, h = http.request("http://ver-infect.atspace.cc/getData_rouge.php")
  end
  if SelectVirusP == "rose" then
    love.audio.play(leaderboardMusic_rose)
    love.audio.stop(leaderboardMusic)
    b, c, h = http.request("http://ver-infect.atspace.cc/getData_rose.php")
  end
  if SelectVirusP == "jaune" then
    love.audio.stop(leaderboardMusic_rose)
    love.audio.play(leaderboardMusic)
    b, c, h = http.request("http://ver-infect.atspace.cc/getData_jaune.php")
  end
  afficheOptions = false
  afficheMainMenu = false
  afficheMenu = true
  afficheSelectVirus = false
  afficheClassement = false
  afficheFin = true
  
  love.audio.stop(lvl1Music)
  
  
  love.graphics.setFont(_fontMenu)
  
  camera.y = 0
  camera.x = 0
  
end

function Leaderboard()
  

      if positionhorizontalClassement == 1 then
        love.audio.play(leaderboardMusic)
        leaderboardMusic:setPitch(1)
        love.audio.pause(leaderboardMusic_rose)
        NomClassement = "Origin"
        b, c, h = http.request("http://ver-infect.atspace.cc/getData_original.php")
          
      elseif positionhorizontalClassement == 2 then
        love.audio.play(leaderboardMusic)
        leaderboardMusic:setPitch(0.5)
        love.audio.pause(leaderboardMusic_rose)
        NomClassement = "Nigiro"
        b, c, h = http.request("http://ver-infect.atspace.cc/getData_originalV.php")
    
      elseif positionhorizontalClassement == 3 then
        love.audio.play(leaderboardMusic)
       
        leaderboardMusic:setPitch(2)
        NomClassement = "Ragel"
        b, c, h = http.request("http://ver-infect.atspace.cc/getData_rouge.php")
    
      elseif positionhorizontalClassement == 4 then
      
        love.audio.play(leaderboardMusic_rose)
        NomClassement = "Noobik"
        b, c, h = http.request("http://ver-infect.atspace.cc/getData_rose.php")
      
      elseif positionhorizontalClassement == 5 then
        love.audio.play(leaderboardMusic)
        leaderboardMusic:setPitch(1.5)
        NomClassement = "TLP"
        b, c, h = http.request("http://ver-infect.atspace.cc/getData_jaune.php")
      
      end
  
  
  afficheOptions = false
  afficheMainMenu = false
  afficheMenu = true
  afficheSelectVirus = false
  afficheClassement = true
  afficheFin = false
  
  love.audio.stop(MenuMusic)

  
  
  menuSelectVirus.selectyourvirus.x = 40
  menuSelectVirus.selectyourvirus.y = 10

  menuSelectVirus.selectyourvirus.original.x = 92
  menuSelectVirus.selectyourvirus.original.y = 50
  
  menuSelectVirus.selectyourvirus.originalV.x = 57
  menuSelectVirus.selectyourvirus.originalV.y = 50
  
  menuSelectVirus.selectyourvirus.jaune.x = 20
  menuSelectVirus.selectyourvirus.jaune.y = 50
  
  menuSelectVirus.selectyourvirus.rouge.x = 127
  menuSelectVirus.selectyourvirus.rouge.y = 50
  
  menuSelectVirus.selectyourvirus.rose.x = 160
  menuSelectVirus.selectyourvirus.rose.y = 50
   
  love.graphics.setFont(_fontMenu)
  
  
end


function SelectVirus()
  
  virusTeleport:setPitch(1)
  deadSound:setPitch(1)
  leaderboardMusic:setPitch(1)
  lvl1Music:setPitch(1)
  
  timeaffiche = 0
  positioncurseur2 = 3
  curseurmenu2.y = 65
    
  
   nameVirus.y = 80

   love.audio.stop(MenuMusic)
   love.audio.play(SelectVirusMusic)
   
  
  afficheOptions = false
  afficheMainMenu = false
  afficheMenu = true
  afficheSelectVirus = true
  afficheClassement = false
  afficheFin = false
  
  menuSelectVirus.selectyourvirus.x = 40
  menuSelectVirus.selectyourvirus.y = 10

  menuSelectVirus.selectyourvirus.original.x = 92
  menuSelectVirus.selectyourvirus.original.y = 50
  
  menuSelectVirus.selectyourvirus.originalV.x = 57
  menuSelectVirus.selectyourvirus.originalV.y = 50
  
  menuSelectVirus.selectyourvirus.jaune.x = 20
  menuSelectVirus.selectyourvirus.jaune.y = 50
  
  menuSelectVirus.selectyourvirus.rouge.x = 127
  menuSelectVirus.selectyourvirus.rouge.y = 50
  
  menuSelectVirus.selectyourvirus.rose.x = 160
  menuSelectVirus.selectyourvirus.rose.y = 50
   
  love.graphics.setFont(_fontMenu)
   

   
  
end


function MainMenu()
  virusTeleport:setPitch(1)
  deadSound:setPitch(1)
  leaderboardMusic:setPitch(1)
  lvl1Music:setPitch(1)
  love.audio.stop(leaderboardMusic)
  love.audio.stop(leaderboardMusic_rose)
  love.audio.stop(SelectVirusMusic)
  love.audio.play(MenuMusic)
  



  menu.principal.x = 1
  menu.principal.y = 10
  
  menu.play.x = 1
  menu.play.y = 40
  
  menu.options.x = -10
  menu.options.y = 60

  menu.leaderboard.x = -20
  menu.leaderboard.y = 80
 
  menu.quit.x = -30
  menu.quit.y = 100

  curseurmenu.x = -20
  
  afficheMainMenu = true
  afficheMenu = true
  afficheOptions = false
  afficheSelectVirus = false
  afficheClassement = false
  afficheFin = false

  camera.y = 0
  camera.x = 0
  
  love.graphics.setFont(_fontMenu)
  
  
end

function OptionsMenu()
  
   
  
  menuOptions.x = 80
  menuOptions.y = 10
  
  menuOptions.langue.x = 20
  menuOptions.langue.y = 35
  
  menuOptions.controls.x = 20
  menuOptions.controls.y = 55

  menuOptions.musics.x = 20
  menuOptions.musics.y = 75

  menuOptions.sounds.x = 20
  menuOptions.sounds.y = 95
  
  menuOptions.apply.x = 20
  menuOptions.apply.y = 115
  
  afficheOptions = true
  afficheMainMenu = false
  afficheMenu = true
  afficheSelectVirus = false
  afficheClassement = false
   
  camera.y = 0
  camera.x = 0
  
  love.graphics.setFont(_fontMenu)
  
   positioncurseur = 1
  
end




function PremierNiveau()
  


love.audio.stop(MenuMusic)
love.audio.stop(SelectVirusMusic)

--randomNumber = love.math.random(1, 3)
randomNumber = 1
print(randomNumber)
  
balayageVertical.x = -2
balayageHorizontal.y = -2

  
lvl1Music:setVolume(musicVolume)




  
 

 
 --love.audio.stop(lvl6Music)

  
  gameOver = false
  afficheMainMenu = false
  afficheMenu = false
  afficheOptions = false
  afficheSelectVirus = false
  afficheClassement = false
  afficheFin = false
  
  
  Niveau = 1
  
  camera.y = 0
  camera.x = 0
  
  timeBougeVertical = 0
  timeBougeHorizontal = 0
  
  lvlActuel = 1
  
  -- Coordonnées du Spawn Depart
  caseDepartX = 11
  caseDepartY = 6
  
  
  -- Coordonnées du Spawn Finish
  --caseFinX = 26
  --caseFinY = 6
  
  
  -- Met en place les spawn 
  spawn.depart.x = caseDepartX*16
  spawn.depart.y = caseDepartY*16
  
  --spawn.fin.x = caseFinX*16
  --spawn.fin.y = caseFinY*16
  
  
  -- Met en place le/les piège(s)
  caseBougeVerticalX = 11
  caseBougeVerticalY = 32
  
  caseBougeVertical2X = 22
  caseBougeVertical2Y = 32
  
  caseBougeHorizontalX = 6
  caseBougeHorizontalY = 29
  
  piege.bougeVertical1.x = caseBougeVerticalX*16
  piege.bougeVertical1.y = caseBougeVerticalY*16
  
  piege.bougeVertical2.x = caseBougeVertical2X*16
  piege.bougeVertical2.y = caseBougeVertical2Y*16
  
  piege.bougeHorizontal1.x = caseBougeHorizontalX*16
  piege.bougeHorizontal1.y = caseBougeHorizontalY*16
  
  -- BONUS 
  
  bonus.speed.x = 29.5*8
  bonus.speed.y = 25.5*8
  



  -- Met en place les coordonnées du joueur au spawn Depart 
  if SelectVirusP == "original" then
    
  imgDecor[1] = love.graphics.newImage("ressources/lvldesign/mur.png")
  love.audio.play(lvl1Music)
  playerStart = virus.skins.original.start
  
  
elseif SelectVirusP == "jaune" then
  
  imgDecor[1] = love.graphics.newImage("ressources/lvldesign/mur.png")
  love.audio.play(lvl1Music)
  playerStart = virus.skins.jaune.start
  virus.skins.jaune.power = true
  leaderboardMusic:setPitch(1.5)
elseif SelectVirusP == "rouge" then
  
  imgDecor[1] = love.graphics.newImage("ressources/lvldesign/mur.png")
  love.audio.play(lvl1Music)
  playerStart = virus.skins.rouge.start
  player.speed = virus.skins.rouge.speed
  virusTeleport:setPitch(2)
  deadSound:setPitch(2)
  leaderboardMusic:setPitch(2)
  lvl1Music:setPitch(2)
  
elseif SelectVirusP == "originalV" then
  
  
  imgDecor[1] = love.graphics.newImage("ressources/lvldesign/mur.png")
  love.audio.play(lvl1Music)
  playerStart = virus.skins.originalV.start
  lvl1Music:setPitch(0.5)
  deadSound:setPitch(0.5)
  virusTeleport:setPitch(0.5)
  leaderboardMusic:setPitch(0.5)
  
elseif SelectVirusP == "rose" then
  imgDecor[1] = love.graphics.newImage("ressources/lvldesign/murrose.png")
  love.audio.play(leaderboardMusic_rose)
  playerStart = virus.skins.rose.start
  leaderboardMusic:setPitch(0.9)
  end
  
  player.x = spawn.depart.x
  player.y = spawn.depart.y
  
  map = {}
  
  map[1]  = { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[2]  = { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[3]  = { 0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[4]  = { 0,0,0,0,1,0,0,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[5]  = { 0,0,0,0,1,0,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[6]  = { 0,0,0,0,1,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[7]  = { 0,0,0,0,1,0,0,1,0,1,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[8]  = { 0,0,0,0,1,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[9]  = { 0,0,0,0,1,0,0,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[10] = { 0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[11] = { 0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[12] = { 0,0,0,0,0,0,0,0,1,1,0,0,1,1,1,1,1,0,0,0,0,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[13] = { 0,0,0,0,0,0,0,0,1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[14] = { 0,0,0,0,0,0,0,0,1,1,0,0,1,1,0,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[15] = { 0,0,0,0,1,1,1,1,1,1,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[16] = { 0,0,0,0,1,1,1,1,1,1,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[17] = { 0,0,0,0,1,1,0,0,0,0,2,2,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[18] = { 0,0,0,0,1,1,0,0,0,0,2,2,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[19] = { 0,0,0,0,1,1,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[20] = { 0,0,0,0,1,1,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[21] = { 0,0,0,0,1,1,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[22] = { 0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[23] = { 0,0,0,0,1,1,1,1,1,1,1,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[24] = { 0,0,0,0,1,1,1,0,1,1,1,1,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[25] = { 0,0,0,0,1,1,1,0,1,1,1,1,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[26] = { 0,1,1,1,1,1,1,0,1,1,1,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[27] = { 0,1,1,1,1,1,1,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[28] = { 0,1,1,2,2,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[29] = { 0,1,1,2,2,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[30] = { 0,1,1,1,1,1,0,0,0,1,1,1,1,0,0,0,0,0,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[31] = { 0,1,1,1,1,1,0,0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[32] = { 0,0,0,0,1,1,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[33] = { 0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,2,2,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[34] = { 0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,1,1,0,0,0,0,0,2,2,2,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[35] = { 0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,1,1,1,0,0,0,2,2,2,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[36] = { 0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[37] = { 0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[38] = { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[39] = { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[40] = { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,0,1,0,0,1,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[41] = { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,1,0,1,0,0,1,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[42] = { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,1,0,1,0,0,1,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[43] = { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,1,0,1,0,0,1,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[44] = { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,4,0,0,1,0,0,1,0,0,0,0,1,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[45] = { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[46] = { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[47] = { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[48] = { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[49] = { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[50] = { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[51] = { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[52] = { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[53] = { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[54] = { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[55] = { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[56] = { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[57] = { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[58] = { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  map[59] = { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }

  
 
  
end




function love.load()

pseudo = ""
love.keyboard.setKeyRepeat(true)
fleche = false
zqsd = true
wasd = false
  
alllanguage = {}
volumeMusics = {}
volumeSounds = {}
controlsSystem = {}
highscoresS = {}
LVL = {}
filedirectory = love.filesystem.getSourceBaseDirectory()

print(filedirectory)



  
 love.filesystem.setIdentity("Ver'InfectData")
 
  if not love.filesystem.exists("saves") then
    love.filesystem.createDirectory("saves")
  end
 
  if not love.filesystem.exists("language.lua") then
    love.filesystem.newFile("language.lua")
    love.filesystem.write("language.lua","language\n=\nenglish")
  end


 if not love.filesystem.exists("controls.lua") then
    love.filesystem.newFile("controls.lua")
    love.filesystem.write("controls.lua","controls\n=\nZQSD")
  end
  
  if not love.filesystem.exists("sound.lua") then
    love.filesystem.newFile("sound.lua")
    love.filesystem.write("sound.lua","soundVolume\n=\n1\n\nmusicVolume\n=\n1")
  end


  for lines in love.filesystem.lines("language.lua") do
    table.insert(alllanguage,lines)
    
  end

  
  language = alllanguage[3]
  
   --love.filesystem.write("language.lua","language\n=\n" ..language)
   
  
  
  for lines in love.filesystem.lines("controls.lua") do
    table.insert(controlsSystem,lines)
    
  end
  
  moveControls = controlsSystem[3]
  
  
  --for lines in love.filesystem.lines("scores.lua") do
   -- table.insert(highscoresS,lines)
    
  --end
  
   --highscoreS = highscoresS[4]
   
  --for lines in love.filesystem.lines("scores.lua") do
   -- table.insert(LVL,lines)
    
  --end
  
   --highLVL = LVL[3]
   
   
  for lines in love.filesystem.lines("sound.lua") do
    table.insert(volumeSounds,lines)
  end
  
  soundVolume = volumeSounds[3]
  print("SoundVolume : "..soundVolume)
  
  for lines in love.filesystem.lines("sound.lua") do
    table.insert(volumeMusics,lines)
  end
  
  musicVolume = volumeMusics[7]
  
  
  
  print("MusicVolume : "..musicVolume)
  
  --print("Meilleur temps : "..highscoreS.." s  dans le niveau "..highLVL)

  
  print("Le jeu est en : "..language)
  print("Type de controles : "..moveControls)



  controls.haut.x = camera.x
  controls.haut.y = camera.y
  
  if language == "french" then
    positionhorizontal = 1 
  elseif language == "english" then
    positionhorizontal = 2
    end
  
if moveControls == "ZQSD" then
    positionhorizontal2 = 1
  elseif moveControls == "WASD" then
    positionhorizontal2 = 2
  elseif moveControls == "ARROW" then
    positionhorizontal2 = 3
    end
  
  Safe = false
  Scan = false 
  
   printx = 0
   printy = 0
   
  deadSound = love.audio.newSource("sounds/dead.wav","static")
  lvlUp = love.audio.newSource("sounds/lvlup2.wav","static")
  takeSpeed = love.audio.newSource("sounds/speed.wav","static")
  input = love.audio.newSource("sounds/input.wav","static")
  puttime = love.audio.newSource("sounds/puttime.wav","static")
  lvl1Music = love.audio.newSource("musics/lvl1.ogg", "stream")
  lvl1Music:setLooping(true)
  
  leaderboardMusic = love.audio.newSource("musics/leaderboard1.wav", "stream")
  leaderboardMusic:setLooping(true)
  
  leaderboardMusic_rose = love.audio.newSource("musics/leaderboard_rose.wav", "stream")
  leaderboardMusic_rose:setLooping(true)
  
  
  MenuMusic = love.audio.newSource("musics/menu.ogg", "stream")
  MenuMusic:setLooping(true)
  
  SelectVirusMusic = love.audio.newSource("musics/selectvirus.ogg", "stream")
  SelectVirusMusic:setLooping(true)
  
  select1 = love.audio.newSource("sounds/select1.wav", "static")
  select2 = love.audio.newSource("sounds/select2.wav","static")
  select3 = love.audio.newSource("sounds/select3.wav","static")
  back = love.audio.newSource("sounds/back.wav","static")
  
  virusTeleport = love.audio.newSource("sounds/teleport.wav", "static")
  

  
 
  
  --lvl6Music = love.audio.newSource("musics/lvl6.ogg")
  --lvl6Music:setLooping(true)
  
  afficheOptions = false
  gameOver = false
  stopTimer = false
  
  timer = 0
  scanTime = 15
  positioncurseur = 1
  
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  --love.graphics.setColor(255,255,255)
  love.window.setTitle("Ver'Infect")
  love.window.setMode(largeurEcran,hauteurEcran, {fullscreen=false, vsync=false, minwidth=800, minheight=600})

  MainMenu()
  --SelectVirus()
  --PremierNiveau()
  --DeuxiemeNiveau()
  --TroisiemeNiveau()
 
  
end


function love.update(dt)
  

 
if tonumber(soundVolume) == 0 then
  
  soundVolume = soundVolume + 0.1
  soundVolume = soundVolume - 0.1
  end

  if tonumber(soundVolume) > 1 then
    
    soundVolume = 1
    
  elseif tonumber(soundVolume) < 0 then
    
    soundVolume = 0
    
  end
  

  

  if tonumber(musicVolume) > 1 then
    
    musicVolume = 1
    
  elseif tonumber(musicVolume) < 0 then
    
    musicVolume = 0
    
  
  end
  

  -- TRADUCTION 
  
  -- Français
  if language == "french" then
    
    if positionhorizontal == 1 then
    
    tradlanguage = "fr"
    
    end
  
    if positionhorizontal == 2 then
      
      tradlanguage = "eng"
  
    end
  
    if positionhorizontal2 == 1 then
    
      tradControls = "ZQSD"
    
    end
  
    if positionhorizontal2 == 2 then
      
      tradControls = "WASD"
  
    end
  
    if positionhorizontal2 == 3 then
      
      tradControls = "FLECHES"
  
    end
  
  
  end

  
  -- Anglais
   if language == "english" then
    
    if positionhorizontal == 1 then
    
    tradlanguage = "fr"
    
    end
  
    if positionhorizontal == 2 then
      
      tradlanguage = "eng"
  
  end
  
  
  if positionhorizontal2 == 1 then
    
      tradControls = "ZQSD"
    
    end
  
    if positionhorizontal2 == 2 then
      
      tradControls = "WASD"
  
    end
  
    if positionhorizontal2 == 3 then
      
      tradControls = "ARROW"
  
    end
  end



    

  

controls.haut.x = camera.x
controls.haut.y = camera.y




  -- TOUCHE PAUSE
  
  if gameOver == false then
  if keyPause == 1 then
    pause = true
  else
    pause = false
    
    end
  
  
  
  if keyPause == 2 then 
    keyPause = 0
  end
 end
 
  
  -- PAUSE
  
  if pause == true then 
    
   
    
    stopTimer = true
  
   if lvlActuel == 1 then
       
       love.audio.pause(lvl1Music)
      
   end
    
    
  end
    
  if pause == false and gameOver == false then
    
    if lvlActuel == 1 then
       
       love.audio.resume(lvl1Music)
      
    end
    
    stopTimer = false
    
  end

if gameOver == true then
  love.audio.stop(lvl1Music)
  if SelectVirusP == "originalV" then
  deadSound:setPitch(0.5)
 end
  
  end

  if afficheMenu == false and afficheMainMenu == false and afficheOptions == false and gameOver == false and afficheSelectVirus == false and afficheClassement == false and afficheFin == false then 
    
    if activeTimer == true then
      
        timerDebut = timerDebut - love.timer.getDelta()
        
    end
    
    if timerDebut < 0 then
      
      activeTimer = false
      timerDebut = timerDebut + 1.5
      
    end  
      
  
    
    -- Pour qu'il aille pas trop loin
    if balayageVertical.x > 700 then
      
      balayageVertical.x = 700
      
    end
    
    
    if balayageVertical.x == 700 and balayageVertical.active == true then
      
      balayageVertical.sens = balayageVertical.sens + 1
      
    end
  
    
    if balayageVertical.x == -2 and balayageVertical.active == true then
      
      balayageVertical.sens = balayageVertical.sens + 1
      print(balayageVertical.sens)
      
    end
    
    if balayageVertical.sens == 3 then
      
      balayageVertical.active = false
      balayageVertical.sens = 0
      
    end
    
    
    
    if balayageHorizontal.y > 1000 then
      
      balayageHorizontal.y = 1000
      
    end
    
    if balayageHorizontal.y == 1000 and balayageHorizontal.active == true then
      
      balayageHorizontal.sens = balayageHorizontal.sens + 1
      
    end
    
      
    if balayageHorizontal.y == -2 and balayageHorizontal.active == true then
      
      balayageHorizontal.sens = balayageHorizontal.sens + 1
      print(balayageHorizontal.sens)
      
    end
    
    if balayageHorizontal.sens == 3 then
      
      balayageHorizontal.active = false
      balayageHorizontal.sens = 0
      
    end
    
    scoresS = yourTime
--if (mousex < 100



  if balayageHorizontal.active == true and balayageHorizontal.sens == 1 then
  balayageHorizontal.y = balayageHorizontal.y + balayageHorizontal.speed * dt
end


  if balayageHorizontal.active == true and balayageHorizontal.sens == 2 then
  balayageHorizontal.y = balayageHorizontal.y - balayageHorizontal.speed * dt
  end


  if balayageVertical.active == true and  balayageVertical.sens == 1 then
  balayageVertical.x = balayageVertical.x + balayageVertical.speed * dt
  end

if balayageVertical.active == true and balayageVertical.sens == 2 then
  balayageVertical.x = balayageVertical.x - balayageVertical.speed * dt
  end

  if Safe == false then
    
    if ((player.x <= balayageVertical.x+1) and (balayageVertical.x <= player.x+16) and (player.y <= balayageVertical.y+1000) and (balayageVertical.y <= player.y+16)) then
      
      if SelectVirusP == "rose" then
        
        gameOver = false
        
      else
        
        love.audio.play(deadSound)
        gameOver = true
      end
      
    end
  
    if ((player.x <= balayageHorizontal.x+1000) and (balayageHorizontal.x <= player.x+16) and (player.y <= balayageHorizontal.y+1) and (balayageHorizontal.y <= player.y+16)) then
      
     if SelectVirusP == "rose" then
        
        gameOver = false
        
      else
        
        love.audio.play(deadSound)
        gameOver = true
      end
      
    end
  
  
  end
  
   --if scoresS > tonumber(highscoreS) then
    
    --highscoreS = scoresS
    
   
    --love.filesystem.write("scores.lua","highscore\n=\n\n" ..highscoreS)
     
    
  --end
  
     --if Niveau > tonumber(highLVL) then
    
    --highLVL = Niveau
    
    --love.filesystem.write("scores.lua","highscore\n=\n\n" ..highscoreS)
  
     
    
 -- end
  
  
  
  
    
    --end

 
  --if ((player.x <= spawn.fin.x+4) and (spawn.fin.x  <= player.x+4) and (player.y <= spawn.fin.y+4) and (spawn.fin.y <= player.y+4)) then
     --love.audio.play(lvlUp)
    --if lvlActuel == 1 then
      
     -- DeuxiemeNiveau()
      
     -- print("Niveau 2")
   -- elseif lvlActuel == 2 then
     -- print("Niveau 3")
     -- TroisiemeNiveau()
    --elseif lvlActuel == 3 then
   -- print("Niveau 4")
     -- QuatriemeNiveau()
   -- elseif lvlActuel == 4 then
    --  print("Niveau 5")
     -- CinquiemeNiveau()
    --end
  
    
 -- end
  
  --if ((player.x <= bonus.speed.x+8) and (bonus.speed.x  <= player.x+8) and (player.y <= bonus.speed.y+8) and (bonus.speed.y <= player.y+8)) then
     
    
    --player.speed = player.speed + 5
    --bonus.speed.x = 0
    --love.audio.play(takeSpeed)
    --table.remove(bonus["speed"])
    --print("Collision avec le bonus <Speed>")
  
    
  --end
  

  -- VERTICAL
  
    if ((player.x <= piege.bougeVertical1.x+9) and (piege.bougeVertical1.x  <= player.x+9) and ((player.y-1.5 <= piege.bougeVertical1.y+1)) and (piege.bougeVertical1.y-1.5 <= player.y+6.5)) then
       
      if SelectVirusP == "rose" then
        
        gameOver = false
        player.x = player.x - 1
      
      else
    
      player.x = player.x - 1
      love.audio.play(deadSound)
      
      gameOver = true
      
      end
     
    end
    
    
    if ((player.x <= piege.bougeVertical1.x+9) and (piege.bougeVertical1.x  <= player.x+9) and ((player.y-8 <= piege.bougeVertical1.y+1)) and (piege.bougeVertical1.y-1.5 <= player.y-8)) then
       
      if SelectVirusP == "rose" then
        
        gameOver = false
        player.x = player.x + 1
      
      else
      
        player.x = player.x + 1
        love.audio.play(deadSound)
        
        gameOver = true
     
      end
    end
    
    if ((player.x <= piege.bougeVertical2.x+9) and (piege.bougeVertical2.x  <= player.x+9) and ((player.y-1.5 <= piege.bougeVertical2.y+1)) and (piege.bougeVertical2.y-1.5 <= player.y+6.5)) then
       
      if SelectVirusP == "rose" then
        
        gameOver = false
       
      
      else
    
        player.x = player.x - 1
        love.audio.play(deadSound)
        
        gameOver = true
     
      end
    end
    
     if ((player.x <= piege.bougeVertical2.x+9) and (piege.bougeVertical2.x  <= player.x+9) and ((player.y-8 <= piege.bougeVertical2.y+1)) and (piege.bougeVertical2.y-1.5 <= player.y-8)) then
       
      if SelectVirusP == "rose" then
        
        gameOver = false
        player.x = player.x + 1
      else
      
        player.x = player.x + 1
        love.audio.play(deadSound)
        
        gameOver = true
     
      end
    end
    
  -- HORIZONTAL
    
      if ((player.x <= piege.bougeHorizontal1.x+16) and (piege.bougeHorizontal1.x  <= player.x+16) and ((player.y-1.5 <= piege.bougeHorizontal1.y+1)) and (piege.bougeHorizontal1.y-1.5 <= player.y+6.5)) then
       
       if SelectVirusP == "rose" then
        
        gameOver = false
       player.y = player.y - 1
      
      else
    
      player.y = player.y - 1
      love.audio.play(deadSound)
      
      gameOver = true
     
      end
    end
    
     if ((player.x <= piege.bougeHorizontal1.x+16) and (piege.bougeHorizontal1.x  <= player.x+16) and ((player.y-8 <= piege.bougeHorizontal1.y+1)) and (piege.bougeHorizontal1.y-1.5 <= player.y-8)) then
       
       if SelectVirusP == "rose" then
        
        gameOver = false
       player.y = player.y + 1
      
      else
    
      player.y = player.y + 1
      love.audio.play(deadSound)
      
      gameOver = true
    end
    end

  -- TIMER



  if stopTimer == false and activeTimer == false then
    
    scanTime = scanTime - love.timer.getDelta()

  timer = timer + love.timer.getDelta()
  yourTime = timer
  
end

  if gameOver == true then
   
    player.speed = 0
    love.graphics.setColor(200,0,0)
    Scan = false
    stopTimer = true
    
  
   love.audio.stop(lvl1Music)
  
  -- love.audio.stop(lvl6Music)
    
    
    
    
  end
  
  

 
  if scanTime < 0.1 then
  
    scanTime = scanTime + 15
    
    print(randomNumber)
    randomNumber = love.math.random(1, 5)
    if randomNumber == 2 then
    
    balayageVertical.active = true
      print(randomNumber)
    end
  
  if randomNumber == 1 then
    
    balayageHorizontal.active = true
      print(randomNumber)
    
    end
  
    if Safe == false and randomNumber == 3 then
    
      if SelectVirusP == "rose" then
        
        gameOver = false
        
      else
      
        gameOver = true
        print(randomNumber)
        love.audio.play(deadSound)
      end
  end
  

    
    end

  if scanTime < 1.5 then
    Scan = true
    love.graphics.setColor(255,255,100)
  
    
  end
  
  if scanTime >= 15 then
    Scan = false
    
    
    end
  

  touches = love.touch.getTouches()
  
  if touchx == 0  or touchy == 0 then
    
    toucheEcran = false
  
  end



  -- TimePiege
  timeBougeVertical = timeBougeVertical + love.timer.getDelta()
  timeBougeHorizontal = timeBougeHorizontal + love.timer.getDelta()
  
  
  if gameOver == false and pause == false then
  -- VERTICAL
  --if timeBougeVertical >= 0 and timeBougeVertical < 1.6 then
  
    --piege.bougeVertical1.y = piege.bougeVertical1.y + piege.bougeVertical1.speed * dt
   
    
  --elseif timeBougeVertical >= 1.6 and timeBougeVertical < 3.2 then
    
    --piege.bougeVertical1.y = piege.bougeVertical1.y - piege.bougeVertical1.speed * dt
    
    --end
  if timeBougeVertical >= 3.2 then
    print("on recommence")
   timeBougeVertical = timeBougeVertical - 3.2
  end
  
  -- HORIZONTAL 
  -- if timeBougeHorizontal >= 0 and timeBougeHorizontal < 1.6 then
  
    --piege.bougeHorizontal1.x = piege.bougeHorizontal1.x + piege.bougeHorizontal1.speed * dt
   
    
  --elseif timeBougeHorizontal >= 1.6 and timeBougeHorizontal < 3.2 then
    
    --piege.bougeHorizontal1.x = piege.bougeHorizontal1.x - piege.bougeHorizontal1.speed * dt
    
  --end
  
  
  if timeBougeHorizontal >= 3.2 then
    --print("on recommence")
   timeBougeHorizontal = timeBougeHorizontal - 3.2
  end
  
  end
    
 

  local ancienX = player.x
  local ancienY = player.y

  if afficheMenu == false and afficheOptions == false then
    
   

  -- La camera focus le personnage (à ameliorer + tard)
  if player.x > love.graphics.getWidth() / 9 then
    camera.x = player.x - love.graphics.getWidth() / 9 
  end
  
   if player.y > love.graphics.getWidth() / 12 then
    camera.y = player.y - love.graphics.getWidth() / 12
  end
else
  camera.x = 0
  camera.y = 0
end


    
  if gameOver == false and pause == false and activeTimer == false then
    
    piege.bougeVertical1.y = piege.bougeVertical1.y + piege.bougeVertical1.speed * dt
    piege.bougeVertical2.y = piege.bougeVertical2.y + piege.bougeVertical2.speed * dt
    piege.bougeHorizontal1.x = piege.bougeHorizontal1.x + piege.bougeHorizontal1.speed * dt
    
    -- Mouvement du personnage 
    
    -- FLECHE
    if moveControls == "ARROW" then
      
    
      if love.keyboard.isDown("right")then
        
        if SelectVirusP == "original" then
  
        playerStart = virus.skins.original.right
        player.x = player.x + player.speed * dt
        
        
        elseif SelectVirusP == "jaune" then
  
        playerStart = virus.skins.jaune.right
        player.x = player.x + player.speed * dt
        
  
        elseif SelectVirusP == "rouge" then
  
        playerStart = virus.skins.rouge.right
        player.x = player.x + player.speed * dt
  
        elseif SelectVirusP == "originalV" then
  
        playerStart = virus.skins.originalV.left
        player.x = player.x - player.speed * dt
        
  
        elseif SelectVirusP == "rose" then
  
        playerStart = virus.skins.rose.right
        player.x = player.x + player.speed * dt
  
        end
        
    
    
      end


      if love.keyboard.isDown("left")then
        
        if SelectVirusP == "original" then
  
        playerStart = virus.skins.original.left
        player.x = player.x - player.speed * dt
  
  
        elseif SelectVirusP == "jaune" then
  
        playerStart = virus.skins.jaune.left
        player.x = player.x - player.speed * dt
        
        
        elseif SelectVirusP == "rouge" then
  
        playerStart = virus.skins.rouge.left
        player.x = player.x - player.speed * dt
        
        
        elseif SelectVirusP == "originalV" then
  
        playerStart = virus.skins.originalV.right
        player.x = player.x + player.speed * dt


        elseif SelectVirusP == "rose" then
  
        playerStart = virus.skins.rose.left
        player.x = player.x - player.speed * dt
      end
    
        
      end

      if love.keyboard.isDown("up")then
        
        if SelectVirusP == "original" then
  
        playerStart = virus.skins.original.up
        player.y = player.y - player.speed * dt
         
  
        elseif SelectVirusP == "jaune" then
  
        playerStart = virus.skins.jaune.up
        player.y = player.y - player.speed * dt
         
  
        elseif SelectVirusP == "rouge" then
  
        playerStart = virus.skins.rouge.up
        player.y = player.y - player.speed * dt
         
  
        elseif SelectVirusP == "originalV" then
  
        playerStart = virus.skins.originalV.down
        player.y = player.y + player.speed * dt
         
  
        elseif SelectVirusP == "rose" then
  
        playerStart = virus.skins.rose.up
        player.y = player.y - player.speed * dt
         
  
        end
        
        
      end

      if love.keyboard.isDown("down")then
        
         if SelectVirusP == "original" then
  
        playerStart = virus.skins.original.down
        player.y = player.y + player.speed * dt
        
  
        elseif SelectVirusP == "jaune" then
  
        playerStart = virus.skins.jaune.down
        player.y = player.y + player.speed * dt
        
  
        elseif SelectVirusP == "rouge" then
  
        playerStart = virus.skins.rouge.down
        player.y = player.y + player.speed * dt
        
  
        elseif SelectVirusP == "originalV" then
  
        playerStart = virus.skins.originalV.up
        player.y = player.y - player.speed * dt
        
  
        elseif SelectVirusP == "rose" then
  
        playerStart = virus.skins.rose.down
        player.y = player.y + player.speed * dt
        
  
        end
        
        
      end
    end
    
    
     -- ZQSD
    if moveControls == "ZQSD" then
    
      
      if love.keyboard.isDown("d")then
        
      if SelectVirusP == "original" then
  
        playerStart = virus.skins.original.right
        player.x = player.x + player.speed * dt
        
  
        elseif SelectVirusP == "jaune" then
  
        playerStart = virus.skins.jaune.right
        player.x = player.x + player.speed * dt
        
  
        elseif SelectVirusP == "rouge" then
  
        playerStart = virus.skins.rouge.right
        player.x = player.x + player.speed * dt
        
  
        elseif SelectVirusP == "originalV" then
  
        playerStart = virus.skins.originalV.left
        player.x = player.x - player.speed * dt
        
  
        elseif SelectVirusP == "rose" then
  
        playerStart = virus.skins.rose.right
        player.x = player.x + player.speed * dt
        
  
      end
      
      
      end


      if love.keyboard.isDown("q")then
        
        if SelectVirusP == "original" then
  
        playerStart = virus.skins.original.left
        player.x = player.x - player.speed * dt
        
  
        elseif SelectVirusP == "jaune" then
  
        playerStart = virus.skins.jaune.left
        player.x = player.x - player.speed * dt
        
        
        elseif SelectVirusP == "rouge" then
  
        playerStart = virus.skins.rouge.left
        player.x = player.x - player.speed * dt
        
  
        elseif SelectVirusP == "originalV" then
  
        playerStart = virus.skins.originalV.right
        player.x = player.x + player.speed * dt
  
        elseif SelectVirusP == "rose" then
  
        playerStart = virus.skins.rose.left
        player.x = player.x - player.speed * dt
        
  
      end
      
        
      end

      if love.keyboard.isDown("z")then
        
        if SelectVirusP == "original" then
  
        playerStart = virus.skins.original.up
        player.y = player.y - player.speed * dt
        
  
        elseif SelectVirusP == "jaune" then
  
        playerStart = virus.skins.jaune.up
        player.y = player.y - player.speed * dt
        
  
        elseif SelectVirusP == "rouge" then
  
        playerStart = virus.skins.rouge.up
        player.y = player.y - player.speed * dt
        
  
        elseif SelectVirusP == "originalV" then
  
        playerStart = virus.skins.originalV.down
        player.y = player.y + player.speed * dt
  
        elseif SelectVirusP == "rose" then
  
        playerStart = virus.skins.rose.up
        player.y = player.y - player.speed * dt
        
  
      end
      
        
        
      end

      if love.keyboard.isDown("s")then
        
        if SelectVirusP == "original" then
  
        playerStart = virus.skins.original.down
        player.y = player.y + player.speed * dt
  
  
        elseif SelectVirusP == "jaune" then
  
        playerStart = virus.skins.jaune.down
        player.y = player.y + player.speed * dt
        
  
        elseif SelectVirusP == "rouge" then
  
        playerStart = virus.skins.rouge.down
        player.y = player.y + player.speed * dt
        
  
        elseif SelectVirusP == "originalV" then
  
        playerStart = virus.skins.originalV.up
        player.y = player.y - player.speed * dt
  
        elseif SelectVirusP == "rose" then
  
        playerStart = virus.skins.rose.down
        player.y = player.y + player.speed * dt
        
  
      end
      
        
      end
    end
    
    
    -- WASD
    if moveControls == "WASD" then
    
      
      if love.keyboard.isDown("d")then
        
      if SelectVirusP == "original" then
  
        playerStart = virus.skins.original.right
        player.x = player.x + player.speed * dt
        
  
        elseif SelectVirusP == "jaune" then
  
        playerStart = virus.skins.jaune.right
        player.x = player.x + player.speed * dt
        
  
        elseif SelectVirusP == "rouge" then
  
        playerStart = virus.skins.rouge.right
        player.x = player.x + player.speed * dt
        
  
        elseif SelectVirusP == "originalV" then
  
        playerStart = virus.skins.originalV.left
        player.x = player.x - player.speed * dt
  
        elseif SelectVirusP == "rose" then
  
        playerStart = virus.skins.rose.right
        player.x = player.x + player.speed * dt
  
      end
      
      
      end


      if love.keyboard.isDown("a")then
        
       if SelectVirusP == "original" then
  
        playerStart = virus.skins.original.left
        player.x = player.x - player.speed * dt
        
  
        elseif SelectVirusP == "jaune" then
  
        playerStart = virus.skins.jaune.left
        player.x = player.x - player.speed * dt
        
  
        elseif SelectVirusP == "rouge" then
  
        playerStart = virus.skins.rouge.left
        player.x = player.x - player.speed * dt
  
  
        elseif SelectVirusP == "originalV" then
  
        playerStart = virus.skins.originalV.right
        player.x = player.x + player.speed * dt
  
  
        elseif SelectVirusP == "rose" then
  
        playerStart = virus.skins.rose.left
        player.x = player.x - player.speed * dt
        
  
      end
      
        
      end

      if love.keyboard.isDown("w")then
        
        if SelectVirusP == "original" then
  
        playerStart = virus.skins.original.up
        player.y = player.y - player.speed * dt
        
  
        elseif SelectVirusP == "jaune" then
  
        playerStart = virus.skins.jaune.up
        player.y = player.y - player.speed * dt
        
  
        elseif SelectVirusP == "rouge" then
  
        playerStart = virus.skins.rouge.up
        player.y = player.y - player.speed * dt
        
  
        elseif SelectVirusP == "originalV" then
  
        playerStart = virus.skins.originalV.down
        player.y = player.y + player.speed * dt
  
        elseif SelectVirusP == "rose" then
  
        playerStart = virus.skins.rose.up
        player.y = player.y - player.speed * dt
        
  
      end
      
        
        
      end

      if love.keyboard.isDown("s")then
        
        if SelectVirusP == "original" then
  
        playerStart = virus.skins.original.down
        player.y = player.y + player.speed * dt
        
  
        elseif SelectVirusP == "jaune" then
  
        playerStart = virus.skins.jaune.down
        player.y = player.y + player.speed * dt
        
  
        elseif SelectVirusP == "rouge" then
  
        playerStart = virus.skins.rouge.down
        player.y = player.y + player.speed * dt
        
  
        elseif SelectVirusP == "originalV" then
  
        playerStart = virus.skins.originalV.up
        player.y = player.y - player.speed * dt
  
  
        elseif SelectVirusP == "rose" then
  
        playerStart = virus.skins.rose.down
        player.y = player.y + player.speed * dt
        
  
      end
      
        
      end
    end
    
    
    
    
 
    
    
    
    --if love.keyboard.isDown("lshift") then
      --player.speed = player.maxSpeed
    --else
      
      --player.speed = 80
      --end
    
    
  end
  

  
  
 
 touchh = love.touch.getTouches()
 
 -- CONTROL UP
 if touchx > 80 and touchx < 140 and touchy > 355 and touchy < 420 then 

  playerStart = playerUP
  player.y = player.y - player.speed * dt
 
end


-- CONTROL DOWN
 if touchx > 80 and touchx < 140 and touchy > 480 and touchy < 545 then 

  playerStart = playerDOWN
  player.y = player.y + player.speed * dt
 
end

-- CONTROL LEFT
 if touchx > 20 and touchx < 80 and touchy > 420 and touchy < 480 then 

  playerStart = playerLEFT
  player.y = player.x - player.speed * dt
 
end


-- CONTROL RIGHT
 if touchx > 140 and touchx < 200 and touchy > 420 and touchy < 480 then 

  playerStart = playerRIGHT
  player.x = player.x + player.speed * dt
 
end



  -- Collisions entre le joueur et le mur (TITLE)
  nColonneCollisionGauche = math.floor((player.x / LARGEURTILE) + 1.9)
  nLigneCollisionBas = math.floor((((player.y-6)+player.h/2) / HAUTEURTILE ) + 1)
  
  nColonneCollisionDroite = math.floor((player.x / LARGEURTILE) + 1.1)
  nLigneCollisionHaut = math.floor((((player.y+5)+player.h/2) / HAUTEURTILE) + 1)
  
  
  -- VERTICAL
  
  nLigneCollisionHautVERTCICAL1 = math.floor((((piege.bougeVertical1.y+7)+16/2) / HAUTEURTILE) + 1)
  nColonneCollisionDroiteVERTICAL1 = math.floor((piege.bougeVertical1.x / LARGEURTILE) + 1.1)
  
  
  nLigneCollisionBasVERTICAL1 = math.floor((((piege.bougeVertical1.y-7)+16/2) / HAUTEURTILE ) + 1)
  nColonneCollisionGaucheVERTCICAL1 = math.floor((piege.bougeVertical1.x / LARGEURTILE) + 1.9)
  
  
  nLigneCollisionHautVERTCICAL2 = math.floor((((piege.bougeVertical2.y+7)+16/2) / HAUTEURTILE) + 1)
  nColonneCollisionDroiteVERTICAL2 = math.floor((piege.bougeVertical2.x / LARGEURTILE) + 1.1)
  
  
  nLigneCollisionBasVERTICAL2 = math.floor((((piege.bougeVertical2.y-7)+16/2) / HAUTEURTILE ) + 1)
  nColonneCollisionGaucheVERTCICAL2 = math.floor((piege.bougeVertical2.x / LARGEURTILE) + 1.9)
  
  
  -- HORIZONTAL
  
  nLigneCollisionHautHORIZONTAL1 = math.floor((((piege.bougeVertical1.y+7)+16/2) / HAUTEURTILE) + 1)
  nColonneCollisionDroiteHORIZONTAL1 = math.floor((piege.bougeHorizontal1.x / LARGEURTILE) + 1)
  
  
  nLigneCollisionBasHORIZONTAL1 = math.floor((((piege.bougeVertical1.y-7)+16/2) / HAUTEURTILE ) + 1)
  nColonneCollisionGaucheHORIZONTAL1 = math.floor((piege.bougeHorizontal1.x / LARGEURTILE) + 1)
  
  -- VERTICAL
   if map[nLigneCollisionHautVERTCICAL1][nColonneCollisionDroiteVERTICAL1] == 1 then
     piege.bougeVertical1.speed = -20
    print("collision Haut du mur")
  end
  
  
  if map[nLigneCollisionBasVERTICAL1][nColonneCollisionGaucheVERTCICAL1] == 1 then
     piege.bougeVertical1.speed = 20
    print("collision bas du mur")
  end
  

  if map[nLigneCollisionHautVERTCICAL2][nColonneCollisionDroiteVERTICAL2] == 1 then
     piege.bougeVertical2.speed = -40
    print("collision Haut du mur")
  end
  
  
  if map[nLigneCollisionBasVERTICAL2][nColonneCollisionGaucheVERTCICAL2] == 1 then
     piege.bougeVertical2.speed = 40
    print("collision bas du mur")
  end
  
  
  --HORIZONTAL
  
  if map[nLigneCollisionHautHORIZONTAL1][nColonneCollisionDroiteHORIZONTAL1] == 1 then
     piege.bougeHorizontal1.speed = -20
    print("collision droite du mur")
  end
  
  
  if map[nLigneCollisionBasHORIZONTAL1][nColonneCollisionGaucheHORIZONTAL1] == 1 then
     piege.bougeHorizontal1.speed = 20
    print("collision gauche du mur")
  end
  
  

  
  if map[nLigneCollisionBas][nColonneCollisionGauche] == 1 then
    
      
    if SelectVirusP == "rose" then
    
       gameOver = false
      player.x = ancienX
      player.y = ancienY
    else
    
      player.x = ancienX
      player.y = ancienY
      
      
      gameOver = true
      
      love.audio.play(deadSound)
      end
      
  end
  
  if map[nLigneCollisionHaut][nColonneCollisionDroite] == 1 then
    
    if SelectVirusP == "rose" then
    
     gameOver = false
      player.x = ancienX
      player.y = ancienY
    else
      player.x = ancienX
      player.y = ancienY
      
      
     gameOver = true
     
    love.audio.play(deadSound)
    end
    
  end

  -- ZONE SAFE
 if map[nLigneCollisionBas][nColonneCollisionGauche] == 2 then
    
    Safe = true
    
    
  else 
    
    Safe = false
  
  end
  
  if map[nLigneCollisionHaut][nColonneCollisionDroite] == 2 then
    
    Safe = true
    
    
  else
    
    Safe = false
    
  end
  
  

  
  
  -- COLLISIONS FIN
  
  if map[nLigneCollisionBas][nColonneCollisionGauche] == 4 then
    love.audio.play(lvlUp)
    Fin()
  end
  
  if map[nLigneCollisionHaut][nColonneCollisionDroite] == 4 then
    love.audio.play(lvlUp) 
    Fin()
  end

  

  -- PIEGES
  
  end


  if afficheMenu == true then
    
  select1:setVolume(soundVolume)
  select2:setVolume(soundVolume)
  select3:setVolume(soundVolume)
  back:setVolume(soundVolume)
  lvlUp:setVolume(soundVolume)
  takeSpeed:setVolume(soundVolume)
  deadSound:setVolume(soundVolume)
  virusTeleport:setVolume(soundVolume)
  input:setVolume(soundVolume)
  puttime:setVolume(soundVolume)
  
  lvl1Music:setVolume(musicVolume)
  leaderboardMusic:setVolume(musicVolume)
  leaderboardMusic_rose:setVolume(musicVolume)
  
  MenuMusic:setVolume(musicVolume)
  SelectVirusMusic:setVolume(musicVolume)

    
      -- FLECHE
    if zqsd == false and wasd == false and fleche == true then
      
      if language == "french" then
        
        typeControls = "FLECHES"
        
      end
      
      if language == "english" then
        
        typeControls = "ARROW"
        
      end
    end
     
    
      -- ZQSD
    if zqsd == true and wasd == false and fleche == false then
      
      if language == "french" then
        
        typeControls = "ZQSD"
        
      end
      
      if language == "english" then
        
        typeControls = "ZQSD"
        
      end
    end
    
      -- WASD
    if zqsd == false and wasd == true and fleche == false then
      
      if language == "french" then
        
        typeControls = "WASD"
        
      end
      
      if language == "english" then
        
        typeControls = "WASD"
        
      end
    end
    -- Transition au debut du menu
    menu.principal.x = menu.principal.x + 200 * dt
    menu.play.x = menu.play.x + 200 * dt
    menu.quit.x = menu.quit.x + 200 * dt
    menu.leaderboard.x = menu.leaderboard.x + 200 * dt
    menu.options.x = menu.options.x + 200 * dt
    curseurmenu.x = curseurmenu.x + 50 * dt
    
    if curseurmenu.x > 0 then
      
      curseurmenu.x = 0
      
      end
    
      if menu.principal.x > 90 then
        
        menu.principal.x = 90
        
      end
      
      if menu.play.x > 20 then
        
        menu.play.x = 20
        
      end
      
      if menu.leaderboard.x > 20 then
        
        menu.leaderboard.x = 20
        
      end
      
      if menu.quit.x > 20 then
        
        menu.quit.x = 20
        
      end
      
      if menu.options.x > 20 then
        
        menu.options.x = 20
        
      end
    
      if afficheMainMenu == true and afficheOptions == false and afficheSelectVirus == false and afficheClassement == false and afficheFin == false then
      
  
      
        if positioncurseur == 1 then
          
          curseurmenu.y = menu.play.y-3
          
          
        elseif positioncurseur == 2 then
          
          curseurmenu.y = menu.options.y-3
          
        elseif positioncurseur == 3 then
          
          curseurmenu.y = menu.leaderboard.y-3
          
        elseif positioncurseur == 4 then
          
          curseurmenu.y = menu.quit.y-3
          
        end
        
        if positioncurseur == 0 then
          
          positioncurseur = 4 
          
        elseif positioncurseur == 5 then
          
          positioncurseur = 1
        
        end
    
      
    
      end
    
      if afficheMainMenu == false and afficheOptions == false and afficheSelectVirus == true and afficheClassement == false and afficheFin == false then
        nameVirus.x =  curseurmenu2.x
        timeaffiche = timeaffiche + love.timer.getDelta()
        
        if positioncurseur2 == 1 then
          
          curseurmenu2.x = menuSelectVirus.selectyourvirus.jaune.x
          nameVirus.name = "VI-TLP"
          
          
        elseif positioncurseur2 == 2 then
          
          curseurmenu2.x = menuSelectVirus.selectyourvirus.originalV.x
          nameVirus.name = "VI-NigirO"
          
        elseif positioncurseur2 == 3 then
          
          curseurmenu2.x = menuSelectVirus.selectyourvirus.original.x
          nameVirus.name = "VI-Origin"
          
        elseif positioncurseur2 == 4 then
          
          curseurmenu2.x = menuSelectVirus.selectyourvirus.rouge.x
          nameVirus.name = "VI-RageL"
          
        elseif positioncurseur2 == 5 then
          
          curseurmenu2.x = menuSelectVirus.selectyourvirus.rose.x
          nameVirus.name = "VI-NooBik"
          
        end
          
          
        
        
        if positioncurseur2 == 0 then
          
           positioncurseur2 = 5
          
        elseif positioncurseur2 == 6 then
          
          positioncurseur2 = 1
        end
        
      end
      
      if afficheMainMenu == false and afficheOptions == false and afficheSelectVirus == false and afficheClassement == true and afficheFin == false then
      
       if positionhorizontalClassement == 1 then
         leaderboardMusic:setPitch(1)
          NomClassement = "Origin"
          
    
      elseif positionhorizontalClassement == 2 then
        leaderboardMusic:setPitch(0.5)
          NomClassement = "Nigiro"
          
    
    elseif positionhorizontalClassement == 3 then
      
        leaderboardMusic:setPitch(2)
          NomClassement = "Ragel"
         
    
      elseif positionhorizontalClassement == 4 then
      
          NomClassement = "Noobik"
         
      
      elseif positionhorizontalClassement == 5 then
        leaderboardMusic:setPitch(1.5)
          NomClassement = "TLP"
          
      
      end
      
      if positionhorizontalClassement == 6 then
        b, c, h = http.request("http://ver-infect.atspace.cc/getData_original.php")
        positionhorizontalClassement = 1
      elseif positionhorizontalClassement == 0 then
        b, c, h = http.request("http://ver-infect.atspace.cc/getData_jaune.php")
        positionhorizontalClassement = 5
        end
      end
  
      if afficheMainMenu == false and afficheOptions == true and afficheSelectVirus == false and afficheClassement == false and afficheFin == false then
        
    
      --if positionhorizontal == 1 then
        
        --language = "french"
        
      --elseif positionhorizontal == 2 then
        
        --language = "english"
      --end
      
      if positionhorizontal == 0 then
        
        positionhorizontal = 2
        
      elseif positionhorizontal == 3 then
        
        positionhorizontal = 1
      end
      
      
      if positionhorizontal2 == 0 then
        
        positionhorizontal2 = 3 
      
      elseif positionhorizontal2 == 4 then
      
        positionhorizontal2 = 1
        
      end
        
        

      if positioncurseur == 1 then
        
        curseurmenu.y = menuOptions.langue.y-3
        
        
      elseif positioncurseur == 2 then
        
        curseurmenu.y = menuOptions.controls.y-3
        
      elseif positioncurseur == 3 then
        
        curseurmenu.y = menuOptions.musics.y-3
        
      elseif positioncurseur == 4 then
        
        curseurmenu.y = menuOptions.sounds.y-3
        
      elseif positioncurseur == 5 then
        
        curseurmenu.y = menuOptions.apply.y-3
        
        end
      
      if positioncurseur == 0 then
        
        positioncurseur = 5 
       
      elseif positioncurseur == 6 then
        
        positioncurseur = 1
      
      end
    
    end
  
  
  
  end
  

end



function love.draw()
    
    
    camera:set()
    
   
    
    if afficheMainMenu == true and afficheMenu == true and afficheOptions == false and afficheSelectVirus == false and afficheClassement == false and afficheFin == false then
      
      
      
      love.graphics.draw(imgPrincipal,-55,-70)
      
      if language == "english" then
      
        ChangeColor("VER-INFECT",menu.principal.x-19,menu.principal.y)
        love.graphics.print("Play",  menu.play.x,  menu.play.y)
        love.graphics.print("Settings",  menu.options.x,  menu.options.y)
        love.graphics.print("Leaderboard",  menu.leaderboard.x,  menu.leaderboard.y)
        love.graphics.print("Quit",  menu.quit.x,  menu.quit.y)
        love.graphics.draw(curseurmenu.sprite, curseurmenu.x, curseurmenu.y)
        love.graphics.print("Version Alpha 0.35", 95,140)
      
      elseif language == "french" then
      
        ChangeColor("VER-INFECT",menu.principal.x-19,menu.principal.y)
        love.graphics.print("Jouer",  menu.play.x,  menu.play.y)
        love.graphics.print("Options",  menu.options.x,  menu.options.y)
        love.graphics.print("Classement",  menu.leaderboard.x,  menu.leaderboard.y)
        love.graphics.print("Quitter",  menu.quit.x,  menu.quit.y)
        love.graphics.draw(curseurmenu.sprite, curseurmenu.x, curseurmenu.y)
        love.graphics.print("Version Alpha 0.35", 95,140)
        
      end
     
    end
    
    
    -- MENU SELECTION
    if afficheSelectVirus == true and afficheMainMenu == false and afficheMenu == true and afficheOptions == false and afficheClassement == false and afficheFin == false then
      
      if language == "english" then
      love.graphics.print("Choose your virus", menuSelectVirus.selectyourvirus.x+10,menuSelectVirus.selectyourvirus.y)
      end
    
      if language == "french" then
      love.graphics.print("Choisissez votre virus", menuSelectVirus.selectyourvirus.x,menuSelectVirus.selectyourvirus.y)
    end
    
      love.graphics.print(nameVirus.name,nameVirus.x-12,nameVirus.y)
    
      love.graphics.draw(menuSelectVirus.selectyourvirus.original.sprite,menuSelectVirus.selectyourvirus.original.x,menuSelectVirus.selectyourvirus.original.y)
      love.graphics.draw(menuSelectVirus.selectyourvirus.originalV.sprite,menuSelectVirus.selectyourvirus.originalV.x,menuSelectVirus.selectyourvirus.originalV.y)
      love.graphics.draw(menuSelectVirus.selectyourvirus.rouge.sprite,menuSelectVirus.selectyourvirus.rouge.x,menuSelectVirus.selectyourvirus.rouge.y)
      love.graphics.draw(menuSelectVirus.selectyourvirus.rose.sprite,menuSelectVirus.selectyourvirus.rose.x,menuSelectVirus.selectyourvirus.rose.y)
      love.graphics.draw(menuSelectVirus.selectyourvirus.jaune.sprite,menuSelectVirus.selectyourvirus.jaune.x,menuSelectVirus.selectyourvirus.jaune.y)
      love.graphics.draw(curseurmenu2.sprite,curseurmenu2.x,curseurmenu2.y)
      
    
  end
  
  -- MENU DU CLASSEMENT
   if afficheOptions == false and afficheMenu == true and afficheMainMenu == false and afficheSelectVirus == false and afficheClassement == true and afficheFin == false then
      if language == "english" then 
        
     ChangeColor("<--[ %2ESC%0 ] ", 2,2)
      ChangeColor("< %2Leaderboard%0 "..NomClassement.." >", 39,10)
      --love.graphics.print("Leaderboard "..NomClassement,50,10)
        
      elseif language == "french" then
        
     ChangeColor("<--[ %2ECHAP%0 ] ", 2,2)
      ChangeColor("< %2Classement%0 "..NomClassement.." >", 39,10)
      --love.graphics.print("Classement "..NomClassement,50,10)
     
        
      end
      
      love.graphics.print(b,10,30)
      
    end
    
    if afficheOptions == false and afficheMenu == true and afficheMainMenu == false and afficheSelectVirus == false and afficheClassement == false and afficheFin == true then
      love.graphics.setColor(255,255,255)
     
      love.graphics.print(b,10,30)
      
      if language == "english" then
        
        love.graphics.setColor(0,255,0)
        love.graphics.printf("Your name : "..pseudo, 10, 125, love.graphics.getWidth())
        love.graphics.setColor(255,255,255)
        love.graphics.print("Your time :   "..string.format("%f",yourTime).."  s", 10, 10)
        
      elseif language == "french" then
        
        love.graphics.setColor(0,255,0)
        love.graphics.printf("Votre pseudo : "..pseudo, 10, 125, love.graphics.getWidth())
        love.graphics.setColor(255,255,255)
        love.graphics.print("Votre temps :   "..string.format("%f",yourTime).."  s", 10, 10)
      end
    
    end
    if afficheOptions == true and afficheMenu == true and afficheMainMenu == false and afficheSelectVirus == false and afficheClassement == false and afficheFin == false then
      
      if language == "english" then
        
      ChangeColor("<--[ %2ESC%0 ] ", 2,2)
      ChangeColor("SETTINGS", menuOptions.x,menuOptions.y)
      ChangeColor("Language : [ %2"..tradlanguage.."%0 ]", menuOptions.langue.x,menuOptions.langue.y)
      ChangeColor("Controls : [ %2"..tradControls.."%0 ]", menuOptions.controls.x,menuOptions.controls.y) 
      ChangeColor("Musics Volume : [ %2"..musicVolume.."%0 ]", menuOptions.musics.x,menuOptions.musics.y) 
      ChangeColor("Sounds Volume : [ %2"..soundVolume.."%0 ]", menuOptions.sounds.x,menuOptions.sounds.y) 
      ChangeColor("%3Apply%0 ", menuOptions.apply.x,menuOptions.apply.y) 
      love.graphics.draw(curseurmenu.sprite, curseurmenu.x, curseurmenu.y)
      
      elseif language == "french" then
      ChangeColor("<--[ %2ECHAP%0 ] ", 2,2)
      love.graphics.print("OPTIONS", menuOptions.x,menuOptions.y)
      ChangeColor("Langue : [ %2"..tradlanguage.."%0 ]", menuOptions.langue.x,menuOptions.langue.y)
      ChangeColor("Controles : [ %2"..tradControls.."%0 ]", menuOptions.controls.x,menuOptions.controls.y) 
      ChangeColor("Volumes des musiques : [ %2"..musicVolume.."%0 ]", menuOptions.musics.x,menuOptions.musics.y) 
      ChangeColor("Volume des bruitages : [ %2"..soundVolume.."%0 ]", menuOptions.sounds.x,menuOptions.sounds.y) 
      ChangeColor("%3Appliquer%0", menuOptions.apply.x,menuOptions.apply.y) 
      love.graphics.draw(curseurmenu.sprite, curseurmenu.x, curseurmenu.y)
      
      
      end
    
    
      
    end
  
    
    
    love.graphics.setBackgroundColor(0,0,0)
    
    local colonne
    local ligne

    if afficheMenu == false then
      
      if activeTimer == false then
        love.graphics.setFont(_fontGame)
      end
      
      
    
    for ligne=0,58 do
      
      for colonne=0,99 do
        -- Merci a Franck et thewrath pour votre aide ;)
        if(ligne*16 >= player.y-170/2 and ligne*16 <= player.y+170/2 and colonne*16 >= player.x-290/2 and colonne*16 <= player.x+290/2) then
          love.graphics.draw(imgDecor[map[ligne+1][colonne+1]],colonne*16,ligne*16)
          
        end
        
      end
      
    end
    
   
    if pause == true and gameOver == false then
      
    
      if language == "english" then
      
      love.graphics.print("PAUSE",camera.x+87, camera.y+55,0,0.5)
      love.graphics.print("Press [E] to resume",camera.x+63, camera.y+85,0,0.5)
      
      end
    
      if language == "french" then
      
      love.graphics.print("PAUSE",camera.x+87, camera.y+55,0,0.5)
      love.graphics.print("Appuie sur [E] pour continuer",camera.x+43, camera.y+85,0,0.5)
      
      end
      
    end
   
  
   
    love.graphics.draw(spawn.depart.sprite, spawn.depart.x, spawn.depart.y)
    love.graphics.draw(spawn.fin.sprite, spawn.fin.x, spawn.fin.y)
    --love.graphics.draw(bonus.speed.sprite, bonus.speed.x , bonus.speed.y)
    
    love.graphics.draw(playerStart, player.x, player.y)
    love.graphics.draw(IA.sprite, IA.x, IA.y)
    
    love.graphics.draw(piege.bougeVertical1.sprite,piege.bougeVertical1.x,piege.bougeVertical1.y)
    love.graphics.draw(piege.bougeVertical2.sprite,piege.bougeVertical2.x,piege.bougeVertical2.y)
    love.graphics.draw(piege.bougeHorizontal1.sprite,piege.bougeHorizontal1.x,piege.bougeHorizontal1.y)
    
    
    
  love.graphics.setColor(255,0,0)
  love.graphics.rectangle("line",balayageVertical.x,balayageVertical.y,1,1000)
  love.graphics.rectangle("line",balayageHorizontal.x,balayageHorizontal.y,1000,1)
  love.graphics.setColor(255,255,255)
  

    -- HUD
    if gameOver == false and activeTimer == false then 
      
      -- ENGLISH
    if language == "english" then
      love.graphics.setColor(0,255,0)
      
      
      --if timer >= tonumber(highscoreS) then
        love.graphics.setColor(0,255,0)
        --love.graphics.print("Time :  "..string.format("%f",timer).." s",camera.x+59, camera.y+5,0,0.5)
        --love.graphics.print("Your Best time : "..string.format("%f",highscoreS).."  s",camera.x+40,camera.y+15,0,0.5)
       -- love.graphics.print("In LVL "..highLVL,camera.x+75,camera.y+25,0,0.5)
        --love.graphics.print("Lvl "..Niveau,camera.x+5, camera.y+140,0,0.5)
      --else
        love.graphics.setColor(255,255,255)
        love.graphics.print("Time :  "..string.format("%f",timer).." s",camera.x+59, camera.y+5,0,0.5)
        love.graphics.setColor(0,255,255)
        --love.graphics.print(" Your best time : "..string.format("%f",highscoreS).."  s",camera.x+40,camera.y+15,0,0.5)
        --love.graphics.print("In LVL "..highLVL,camera.x+75,camera.y+25,0,0.5)
        --love.graphics.print("Lvl "..Niveau,camera.x+5, camera.y+140,0,0.5)
     -- end
      
      love.graphics.setColor(255,255,255)
      
    
      love.graphics.print("Version Alpha 0.35",camera.x+60, camera.y+140,0,0.5)
      love.graphics.print("Scan : "..string.format("%i",scanTime),camera.x+5, camera.y+5,0,0.5)
    end
    
    -- FRENCH
     if language == "french" then
      love.graphics.setColor(0,255,0)
      
      
      --if timer >= tonumber(highscoreS) then
        --love.graphics.setColor(0,255,0)
       -- love.graphics.print("Temps :  "..string.format("%f",timer).." s",camera.x+59, camera.y+5,0,0.5)
        --love.graphics.print("Votre meilleur temps : "..string.format("%f",highscoreS).."  s",camera.x+30,camera.y+15,0,0.5)
        --love.graphics.print("Dans le niveau "..highLVL,camera.x+60,camera.y+25,0,0.5)
        --love.graphics.print("Niveau "..Niveau,camera.x+10, camera.y+140,0,0.5)
      --else
        love.graphics.setColor(255,255,255)
        love.graphics.print("Temps :  "..string.format("%f",timer).." s",camera.x+59, camera.y+5,0,0.5)
        love.graphics.setColor(0,255,255)
        --love.graphics.print("Votre meilleur temps : "..string.format("%f",highscoreS).."  s",camera.x+30,camera.y+15,0,0.5)
        --love.graphics.print("Dans le niveau "..highLVL,camera.x+60,camera.y+25,0,0.5)
        --love.graphics.print("Niveau "..Niveau,camera.x+10, camera.y+140,0,0.5)
      --end
      
      love.graphics.setColor(255,255,255)
  
      
      love.graphics.print("Version Alpha 0.35",camera.x+60, camera.y+140,0,0.5)
      love.graphics.print("Scan : "..string.format("%i",scanTime),camera.x+5, camera.y+5,0,0.5)
    end
  
    --love.graphics.draw(controls.haut.sprite, controls.haut.x+20, controls.haut.y+90)
    --love.graphics.draw(controls.bas.sprite, controls.haut.x+20, controls.haut.y+120)
    --love.graphics.draw(controls.gauche.sprite, controls.haut.x+5, controls.haut.y+105)
    --love.graphics.draw(controls.droite.sprite, controls.haut.x+35, controls.haut.y+105)
    

    
    
    
    if Scan == true and gameOver == false then
      
    
      
      if language == "english" then
      
      love.graphics.print("WARNING",camera.x+83, camera.y+35,0,0.5)
      love.graphics.setColor(255,255,100)
      end
    
    if language == "french" then
      
      love.graphics.print("ATTENTION",camera.x+75, camera.y+35,0,0.5)
      love.graphics.setColor(255,255,100)
      end
    
    end
    
    if Scan == false and gameOver == false then
      
      love.graphics.setColor(255,255,255)
      
      end
    
    end
    
    if gameOver == true and pause == false then
      
      if language == "english" then
        love.graphics.setColor(0,255,255)
        --love.graphics.print("Best time : "..string.format("%f",highscoreS).."  s",camera.x+50,camera.y+15,0,0.5)
       -- love.graphics.print("In LVL : "..highLVL,camera.x+75,camera.y+25,0,0.5)
        love.graphics.setColor(200,0,0)
        love.graphics.setColor(0,255,0)
        love.graphics.print("Your time :   "..string.format("%f",yourTime).."  s",camera.x+50, camera.y+55,0,0.5)
        --ChangeInColor("In LVL %2"..Niveau.."%0",camera.x+82, camera.y+65,0,0.5)
        love.graphics.setColor(200,0,0)
        love.graphics.print("GAME OVER",camera.x+80, camera.y+40,0,0.5)
        ChangeInColor("Press [ %2ENTER %0] to restart",camera.x+35, camera.y+90,0,0.5)
        love.graphics.setColor(200,0,0)
      end
      
      if language == "french" then
        love.graphics.setColor(0,255,255)
       -- love.graphics.print("Meilleur temps : "..string.format("%f",highscoreS).."  s",camera.x+40,camera.y+15,0,0.5)
        --love.graphics.print("Dans le niveau "..highLVL,camera.x+60,camera.y+25,0,0.5)
        love.graphics.setColor(200,0,0)
        love.graphics.setColor(0,255,0)
        love.graphics.print("Votre temps :   "..string.format("%f",yourTime).."  s",camera.x+40, camera.y+55,0,0.5)
       -- ChangeInColor("Dans le Niveau %2"..Niveau.."%0",camera.x+65, camera.y+65,0,0.5)
        love.graphics.setColor(200,0,0)
        love.graphics.print("FIN DE LA PARTIE",camera.x+65, camera.y+40,0,0.5)
        ChangeInColor("Appuie sur [ %2ENTREE %0] pour recommencer",camera.x+12, camera.y+90,0,0.5)
        love.graphics.setColor(200,0,0)
      end
      
      
    end
    
  end
  
  
 
  
  
  if activeTimer == true and afficheMenu == false and afficheOptions == false then
    
    if SelectVirusP == "jaune" then
      if language == "english" then
        love.graphics.setFont(_fontGame)
       ChangeInColor("%2[ SPACE ] %0to teleport",camera.x+50, camera.y+10,0,0.5)
    elseif language == "french" then
      love.graphics.setFont(_fontGame)
      ChangeInColor("%2[ ESPACE ]%0 pour se teleporter",camera.x+36, camera.y+10,0,0.5)
      end
    end
      
      if timerDebut > 1.0 and timerDebut <= 1.5 then
        love.graphics.setFont(_fontGameDebut)
        ChangeInColor2("%23%0",camera.x+87, camera.y+57,0,0.5)
        
      elseif timerDebut > 0.5 and timerDebut <= 1 then
        love.graphics.setFont(_fontGameDebut)
        ChangeInColor2("%22%0",camera.x+87, camera.y+57,0,0.5)
        
      elseif timerDebut > 0 and timerDebut <= 0.5 then
        love.graphics.setFont(_fontGameDebut)
        ChangeInColor2("%21%0",camera.x+91, camera.y+57,0,0.5)
      end
  end
  
   camera:unset()
   
    touches = love.touch.getTouches()
 
    for i, id in ipairs(touches) do
        touchx, touchy = love.touch.getPosition(id)
        love.graphics.circle("fill", touchx, touchy, 20)
        toucheEcran = true
      end
 
    
    
    
end



function love.keypressed(key)
  if key == "backspace" then
        -- get the byte offset to the last UTF-8 character in the string.
        local byteoffset = utf8.offset(pseudo, -1)
 
        if byteoffset then
            -- remove the last UTF-8 character.
            -- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
            pseudo = string.sub(pseudo, 1, byteoffset - 1)
            love.audio.play(back)
        end
    end
    
  if afficheMenu == true then
    
    
    
 

end

-- MENU PRINCIPAL
if afficheMainMenu == true and afficheOptions == false and afficheSelectVirus == false and afficheClassement == false then
  
  if key == "up" then
      
      positioncurseur = positioncurseur - 1
      love.audio.play(select1)
    
    end
  
    if key == "down" then
      
      positioncurseur = positioncurseur + 1
      love.audio.play(select1)
    
    end
  
  
  if positioncurseur == 1 then
    
    if key == "return" then
      
      love.audio.play(select2)
      SelectVirus()
    
    end
  
  end
 
  if positioncurseur == 2 then

    if key == "return" then
      
      love.audio.play(select2)
      OptionsMenu()
    
    end
  end
  
  if positioncurseur == 3 then

    if key == "return" then
      
      love.audio.play(select2)
      Leaderboard()
      
    
    end
  end
 
  if positioncurseur == 4 then

    if key == "return" then
  
      love.audio.play(select2)
      love.event.quit()
      love.filesystem.write("language.lua","language\n=\n" ..language)
      love.filesystem.write("controls.lua","controls\n=\n" ..moveControls)
      love.filesystem.write("sound.lua","soundVolume\n=\n"..soundVolume .."\n\nmusicVolume\n=\n"..musicVolume)
  
    end
  end
 end
 
 
  -- MENU OPTIONS
  if afficheMainMenu == false and afficheOptions == true and afficheSelectVirus == false and afficheClassement == false then
    
    
    
  if key == "up" then
      
      positioncurseur = positioncurseur - 1
      love.audio.play(select1)
    
    end
  
    if key == "down" then
      
      positioncurseur = positioncurseur + 1
      love.audio.play(select1)
    
    end
    
    if key == "escape" then
      
      love.audio.play(back)
      MainMenu()
      positioncurseur = 2
      
      end
  
  
  
    if positioncurseur == 1 then
  
      if key == "right" then
    
        love.audio.play(select3)
        positionhorizontal = positionhorizontal + 1
        --love.filesystem.write("language.lua","language\n=\n" ..language)
      
      end
    
    if key == "left" then
    
        love.audio.play(select3)
        positionhorizontal = positionhorizontal - 1
        --love.filesystem.write("language.lua","language\n=\n" ..language)
      
      end

  end
  
   if positioncurseur == 2 then
  
      if key == "right" then
        
        
        love.audio.play(select3)
        positionhorizontal2 = positionhorizontal2 + 1
        --love.filesystem.write("language.lua","language\n=\n" ..language)
      
      end
    
    if key == "left" then
    
        love.audio.play(select3)
        positionhorizontal2 = positionhorizontal2 - 1
        --love.filesystem.write("language.lua","language\n=\n" ..language)
      
      end

    end
  
  
   if positioncurseur == 3 then
  
      if key == "right" then
        
        
        love.audio.play(select3)
        musicVolume = musicVolume + 0.05
        print(musicVolume)
        
        --love.filesystem.write("language.lua","language\n=\n" ..language)
      
      end
    
    if key == "left" then
    
        love.audio.play(select3)
        musicVolume = musicVolume - 0.05
        print(musicVolume)
        --love.filesystem.write("language.lua","language\n=\n" ..language)
      
      end

  end
  
   if positioncurseur == 4 then
  
      if key == "right" then
        
        
        love.audio.play(select3)
        soundVolume = soundVolume + 0.05
        print(soundVolume)
        
        --love.filesystem.write("language.lua","language\n=\n" ..language)
      
      end
    
    if key == "left" then
    
        love.audio.play(select3)
        soundVolume = soundVolume - 0.05
        print(soundVolume)
        --love.filesystem.write("language.lua","language\n=\n" ..language)
      
      end

    end
  

  if positioncurseur == 5 then

    if key == "return" then
      
      love.audio.play(select2)
      love.filesystem.write("controls.lua","controls\n=\n" ..moveControls)
      love.filesystem.write("sound.lua","soundVolume\n=\n"..soundVolume .."\n\nmusicVolume\n=\n"..musicVolume)
      
      
      if positionhorizontal2 == 1 then
          
          moveControls = "ZQSD"
          
          
        end
        
        if positionhorizontal2 == 2 then
          
          moveControls = "WASD"
          
          
        end
        
        if positionhorizontal2 == 3 then
          
          moveControls = "ARROW"
          
          
        end
      
     
  
        if positionhorizontal == 1 then
          
          language = "french"
          
        end
      
      if positionhorizontal == 2 then
        
        language = "english"
        
      end
      
      love.filesystem.write("controls.lua","controls\n=\n" ..moveControls)
      love.filesystem.write("language.lua","languagee\n=\n" ..language)
      
      print("Le jeu est en "..language)
      print("Controles "..moveControls)
      
      positioncurseur = 2
      
      MainMenu()
      
      
      
  
  end
  
  end
  
 end
 
 -- CLASSEMENT
  if afficheMainMenu == false and afficheOptions == false and afficheSelectVirus == false and afficheClassement == true and afficheFin == false then
     
     if key == "escape" then
      MainMenu()
      love.audio.play(back)
    end
     
     if key == "right" then
       
       positionhorizontalClassement = positionhorizontalClassement + 1
      love.audio.play(select3)
      
      if positionhorizontalClassement == 1 then 
        
        
        love.audio.play(leaderboardMusic)
        b, c, h = http.request("http://ver-infect.atspace.cc/getData_original.php")
         
      elseif positionhorizontalClassement == 2 then
        
        
        love.audio.play(leaderboardMusic)
        b, c, h = http.request("http://ver-infect.atspace.cc/getData_originalV.php")
      
      elseif positionhorizontalClassement == 3 then
        
        love.audio.stop(leaderboardMusic_rose)
        love.audio.play(leaderboardMusic)
        b, c, h = http.request("http://ver-infect.atspace.cc/getData_rouge.php")
      
      elseif positionhorizontalClassement == 4 then
        
        love.audio.play(leaderboardMusic_rose)
        love.audio.stop(leaderboardMusic)
        b, c, h = http.request("http://ver-infect.atspace.cc/getData_rose.php")
      
      elseif positionhorizontalClassement == 5 then
        
        love.audio.stop(leaderboardMusic_rose)
        love.audio.play(leaderboardMusic)
        b, c, h = http.request("http://ver-infect.atspace.cc/getData_jaune.php")
      end
      
    
      
    end
    
    if key == "left" then
      
      positionhorizontalClassement = positionhorizontalClassement - 1
      love.audio.play(select3)
      
      if positionhorizontalClassement == 1 then 
        
        
        love.audio.play(leaderboardMusic)
        b, c, h = http.request("http://ver-infect.atspace.cc/getData_original.php")
         
      elseif positionhorizontalClassement == 2 then
        
        
        love.audio.play(leaderboardMusic)
        b, c, h = http.request("http://ver-infect.atspace.cc/getData_originalV.php")
      
      elseif positionhorizontalClassement == 3 then
        
        love.audio.stop(leaderboardMusic_rose)
        love.audio.play(leaderboardMusic)
        b, c, h = http.request("http://ver-infect.atspace.cc/getData_rouge.php")
      
      elseif positionhorizontalClassement == 4 then
        
        love.audio.play(leaderboardMusic_rose)
        love.audio.stop(leaderboardMusic)
        b, c, h = http.request("http://ver-infect.atspace.cc/getData_rose.php")
      
      elseif positionhorizontalClassement == 5 then
        
        love.audio.stop(leaderboardMusic_rose)
        love.audio.play(leaderboardMusic)
        b, c, h = http.request("http://ver-infect.atspace.cc/getData_jaune.php")
      end
      
      
      
    end
    
  end
  
  if afficheMainMenu == false and afficheOptions == false and afficheSelectVirus == false and afficheClassement == false and afficheFin == true then
     
    if key == "escape" then
      ResetGame()
      PremierNiveau()
      love.audio.play(back)
    end
    
    if key == "return" then
      
    
      if SelectVirusP == "original" then 
      
        response_body = {}
        request_body = "name="..pseudo.."&time="..yourTime
        socket.http.request {

        -- Merci a Jimmy Labodudev pour son aide
        url = "http://ver-infect.atspace.cc/saveData_original.php",
        method = "POST",
        headers = {
    
          ["Content-Length"] = string.len(request_body),
          ["Content-Type"] = "application/x-www-form-urlencoded"
          
            },
          source = ltn12.source.string(request_body),
          sink = ltn12.sink.table(response_body)
      }
      table.foreach(response_body,print)
      positionhorizontalClassement = 1
      
    elseif SelectVirusP == "originalV" then 
      
        response_body = {}
        request_body = "name="..pseudo.."&time="..yourTime
        socket.http.request {

        -- Merci a Jimmy Labodudev pour son aide
        url = "http://ver-infect.atspace.cc/saveData_originalV.php",
        method = "POST",
        headers = {
      
          ["Content-Length"] = string.len(request_body),
          ["Content-Type"] = "application/x-www-form-urlencoded"
            
            },
          source = ltn12.source.string(request_body),
          sink = ltn12.sink.table(response_body)
        }
      table.foreach(response_body,print)
  
  positionhorizontalClassement = 2
    elseif SelectVirusP == "rouge" then 
      
        response_body = {}
        request_body = "name="..pseudo.."&time="..yourTime
        socket.http.request {

        -- Merci a Jimmy Labodudev pour son aide
        url = "http://ver-infect.atspace.cc/saveData_rouge.php",
        method = "POST",
        headers = {
    
          ["Content-Length"] = string.len(request_body),
          ["Content-Type"] = "application/x-www-form-urlencoded"
          
            },
          source = ltn12.source.string(request_body),
          sink = ltn12.sink.table(response_body)
      }
      table.foreach(response_body,print)
      positionhorizontalClassement = 3
    elseif SelectVirusP == "rose" then 
      
        response_body = {}
        request_body = "name="..pseudo.."&time="..yourTime
        socket.http.request {

        -- Merci a Jimmy Labodudev pour son aide
        url = "http://ver-infect.atspace.cc/saveData_rose.php",
        method = "POST",
        headers = {
    
          ["Content-Length"] = string.len(request_body),
          ["Content-Type"] = "application/x-www-form-urlencoded"
          
            },
          source = ltn12.source.string(request_body),
          sink = ltn12.sink.table(response_body)
      }
      table.foreach(response_body,print)
      positionhorizontalClassement = 4
    elseif SelectVirusP == "jaune" then 
      
        response_body = {}
        request_body = "name="..pseudo.."&time="..yourTime
        socket.http.request {

        -- Merci a Jimmy Labodudev pour son aide
        url = "http://ver-infect.atspace.cc/saveData_jaune.php",
        method = "POST",
        headers = {
    
          ["Content-Length"] = string.len(request_body),
          ["Content-Type"] = "application/x-www-form-urlencoded"
          
            },
          source = ltn12.source.string(request_body),
          sink = ltn12.sink.table(response_body)
      }
      table.foreach(response_body,print)
    positionhorizontalClassement = 5
  end
    love.audio.play(puttime)
  
    Leaderboard()
    
    
    end
     
  end
 
 -- SELECT VIRUS
  if afficheMainMenu == false and afficheOptions == false and afficheSelectVirus == true and afficheClassement == false and afficheFin == false then
     
     
     
    if key == "right" then
      love.audio.play(select3)
      positioncurseur2 = positioncurseur2 + 1
    end
      
    if key == "left" then
      love.audio.play(select3)
      positioncurseur2 = positioncurseur2 - 1
    end
     
    if key == "escape" then
       
      MainMenu()
      love.audio.play(back)
     
    end
    
    
    if timeaffiche > 0.0001 then 
    
    if positioncurseur2 == 1 then
      
      if key == "return" then
          
        SelectVirusP = "jaune"
        print(SelectVirusP)
        PremierNiveau()
        ResetGame()
          
        end
      
    end
    
    if positioncurseur2 == 2 then
      
      if key == "return" then
          
        SelectVirusP = "originalV"
        print(SelectVirusP)
        PremierNiveau()
        ResetGame()
        
      end
      
    end
    
    if positioncurseur2 == 3 then
      
      if key == "return" then
          
        SelectVirusP = "original"
        print(SelectVirusP)
        PremierNiveau()
        ResetGame()
        
      end
      
    end
      
    if positioncurseur2 == 4 then
      
      if key == "return" then
          
        SelectVirusP = "rouge"
        print(SelectVirusP)
        PremierNiveau()
        ResetGame()  
        
      end
      
    end
    
    if positioncurseur2 == 5 then
      
      if key == "return" then
          
        SelectVirusP = "rose"
        print(SelectVirusP)
        PremierNiveau()
        ResetGame()
          
      end
      
    end
      
   end

  end
  
  
   if activeTimer == false then
  
    if key == "e" then
      keyPause = keyPause + 1
      end
    end


  if afficheMenu == false then
    if key == "escape" then
      
      love.audio.play(back)
      MainMenu()
      love.audio.stop(lvl1Music)
      
      
      
      end
    
   if key == "return" then
     
     
     ResetGame()
     PremierNiveau()
    
      
     
    
  end
  
  
  if afficheMenu == false and afficheMainMenu == false and afficheOptions == false and gameOver == false and afficheSelectVirus == false and activeTimer == false and afficheClassement == false then 
    
    if moveControls == "ARROW" then
      
      if love.keyboard.isDown("right") then
        if key == "space" then
          if virus.skins.jaune.power == true then
            love.audio.play(virusTeleport)
            player.x = player.x + 34
           
          end
        end
      end
      
      if love.keyboard.isDown("left") then
        if key == "space" then
          if virus.skins.jaune.power == true then
            love.audio.play(virusTeleport)
            player.x = player.x - 34
           
          end
        end
      end
      
      if love.keyboard.isDown("up") then
        if key == "space" then
          if virus.skins.jaune.power == true then
            love.audio.play(virusTeleport)
            player.y = player.y - 34
            
          end
        end
      end
      
      if love.keyboard.isDown("down") then
        if key == "space" then
          if virus.skins.jaune.power == true then
            love.audio.play(virusTeleport)
            player.y = player.y + 34
            
          end
        end
      end
      
    end
    
    
    if moveControls == "ZQSD" then
      
      if love.keyboard.isDown("d") then
        if key == "space" then
          if virus.skins.jaune.power == true then
            love.audio.play(virusTeleport)
            player.x = player.x + 34
           
          end
        end
      end
      
      if love.keyboard.isDown("q") then
        if key == "space" then
          if virus.skins.jaune.power == true then
            love.audio.play(virusTeleport)
            player.x = player.x - 34
           
          end
        end
      end
      
      if love.keyboard.isDown("z") then
        if key == "space" then
          if virus.skins.jaune.power == true then
            love.audio.play(virusTeleport)
            player.y = player.y - 34
           
          end
        end
      end
      
      if love.keyboard.isDown("s") then
        if key == "space" then
          if virus.skins.jaune.power == true then
            love.audio.play(virusTeleport)
            player.y = player.y + 34
          
          end
        end
      end
      
    end
    
    
    if moveControls == "WASD" then
      
      if love.keyboard.isDown("d") then
        if key == "space" then
          if virus.skins.jaune.power == true then
            love.audio.play(virusTeleport)
            player.x = player.x + 34
         
          end
        end
      end
      
      if love.keyboard.isDown("a") then
        if key == "space" then
          if virus.skins.jaune.power == true then
            love.audio.play(virusTeleport)
            player.x = player.x - 34
          
          end
        end
      end
      
      if love.keyboard.isDown("w") then
        if key == "space" then
          if virus.skins.jaune.power == true then
            love.audio.play(virusTeleport)
            player.y = player.y - 34
      
          end
        end
      end
      
      if love.keyboard.isDown("s") then
        if key == "space" then
          if virus.skins.jaune.power == true then
            love.audio.play(virusTeleport)
            player.y = player.y + 34
            
          end
        end
      end
      
    end
  
end


  
  
  
  end
  
  
   
  

    
    
    if key == "s" then
        --[[To open a file or folder, "file://" must be prepended to the path.
        love.system.openURL("file://"..love.filesystem.getSaveDirectory().."/test.bat")
        print(love.filesystem.getSaveDirectory())]]
        
        
    end
    

  
  
  print(key)
  
end


function love.mousepressed(mousex, mousey, button, istouch)
  if gameOver == true then
    
    if button == 1 then
      
      ResetGame()
      PremierNiveau()
      
      end
  
  end
   if button == 1 then -- Versions prior to 0.10.0 use the MouseConstant 'l'
      
     
      
      print("MouseX"..mousex)
      print("MouseY"..mousey)
   end
end


function love.mousereleased(mousex, mousey, button, istouch)
   if button == 1 then -- Versions prior to 0.10.0 use the MouseConstant 'l'
     touchx = 0
     touchy = 0
     
      
     
      
      print("MouseX"..mousex)
      print("MouseY"..mousey)
      print("-")
   end
end


function love.quit()
  

  
  love.filesystem.write("language.lua","language\n=\n" ..language)
  love.filesystem.write("controls.lua","controls\n=\n" ..moveControls)
  --love.filesystem.write("scores.lua","highscore\n=\n"..highLVL.."\n" ..highscoreS)
  love.filesystem.write("sound.lua","soundVolume\n=\n"..soundVolume .."\n\nmusicVolume\n=\n"..musicVolume)
  
 
  
  end

function love.keyreleased(key)
  
 
  
end

function love.textinput(t)
    if afficheFin == true then
    love.audio.play(input)
    pseudo = pseudo .. t
    end
end
  