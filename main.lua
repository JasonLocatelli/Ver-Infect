
-- camera 
require "camera"
http = require("socket.http")
require ("ltn12")
savedirectory = love.filesystem.getSaveDirectory()
--require("Highscores")
local utf8 = require("utf8")
-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf('no')

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

-- Cette ligne permet de déboguer pas à pas dans ZeroBraneStudio
if arg[#arg] == "-debug" then require("mobdebug").start() end

largeurFenetre = 800
hauteurFenetre = 600

LARGEURTILE = 16
HAUTEURTILE = 16

debugmode = false


imgBackground = love.graphics.newImage("ressources/menu/background.png")
-- Liste d'éléments
liste_tirs = {}
liste_towers = {}
liste_sprites = {}
liste_particles_explosion = {}
liste_particles_explosion_boss = {}
liste_boss = {}


enableSecret1 = false
enableSecret2 = false

-- LANGUAGES
français = false
anglais = false

tradlanguage = ""
tradControls = ""

touchx = 0
touchy = 0

scores = 0

secondes = 1
bosslife = 64

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
player.speedP = 1
player.life = 1

player.maxLife = 1
player.blink = false
player.affiche = true
timeBlink = 1

player.l = player.sprite:getWidth()
player.h = player.sprite:getHeight()


IA = {}
IA.sprite = love.graphics.newImage("ressources/IA1.png")
IA.id = 0
IA.speed = 100
IA.x = 0
IA.y = 0

-- TOURELLE 1
tower1 = {}
tower1.sprite = love.graphics.newImage("ressources/towers/simpleTower.png")
tower1.x = 744
tower1.y = 936
tower1.l = tower1.sprite:getWidth()
tower1.h = tower1.sprite:getHeight()
tower1.angle = 0

tower1.endormi = true
tower1.chronotir = 0
table.insert(liste_towers,tower1)

tower1.circle = {}
tower1.circle.sprite = love.graphics.newImage("ressources/towers/zoneDT.png")
tower1.circle.x = tower1.x
tower1.circle.y = tower1.y

-- TOURELLE 2
tower2 = {}
tower2.sprite = love.graphics.newImage("ressources/towers/simpleTower.png")
tower2.x = 824
tower2.y = 840
tower2.l = tower2.sprite:getWidth()
tower2.h = tower2.sprite:getHeight()
tower2.angle = 0

tower2.endormi = true
tower2.chronotir = 0
table.insert(liste_towers,tower2)

tower2.circle = {}
tower2.circle.sprite = love.graphics.newImage("ressources/towers/zoneDT.png")
tower2.circle.x = tower2.x
tower2.circle.y = tower2.y

-- TOURELLE 3
tower3 = {}
tower3.sprite = love.graphics.newImage("ressources/towers/simpleTower.png")
tower3.x = 904
tower3.y = 936
tower3.l = tower3.sprite:getWidth()
tower3.h = tower3.sprite:getHeight()
tower3.angle = 0

tower3.endormi = true
tower3.chronotir = 0
table.insert(liste_towers,tower3)

tower3.circle = {}
tower3.circle.sprite = love.graphics.newImage("ressources/towers/zoneDT.png")
tower3.circle.x = tower3.x
tower3.circle.y = tower3.y

-- TOURELLE 4
tower4 = {}
tower4.sprite = love.graphics.newImage("ressources/towers/simpleTower.png")
tower4.x = 904
tower4.y = 744
tower4.l = tower4.sprite:getWidth()
tower4.h = tower4.sprite:getHeight()
tower4.angle = 0

tower4.endormi = true
tower4.chronotir = 0
table.insert(liste_towers,tower4)

tower4.circle = {}
tower4.circle.sprite = love.graphics.newImage("ressources/towers/zoneDT.png")
tower4.circle.x = tower4.x
tower4.circle.y = tower4.y

-- TOURELLE 5
tower5 = {}
tower5.sprite = love.graphics.newImage("ressources/towers/simpleTower.png")
tower5.x = 744
tower5.y = 744
tower5.l = tower5.sprite:getWidth()
tower5.h = tower5.sprite:getHeight()
tower5.angle = 0

tower5.endormi = true
tower5.chronotir = 0
table.insert(liste_towers,tower5)

tower5.circle = {}
tower5.circle.sprite = love.graphics.newImage("ressources/towers/zoneDT.png")
tower5.circle.x = tower5.x
tower5.circle.y = tower5.y

-- TOURELLE 6
tower6 = {}
tower6.sprite = love.graphics.newImage("ressources/towers/simpleTower.png")
tower6.x = 600
tower6.y = 744
tower6.l = tower6.sprite:getWidth()
tower6.h = tower6.sprite:getHeight()
tower6.angle = 0

tower6.endormi = true
tower6.chronotir = 0
table.insert(liste_towers,tower6)

tower6.circle = {}
tower6.circle.sprite = love.graphics.newImage("ressources/towers/zoneDT.png")
tower6.circle.x = tower6.x
tower6.circle.y = tower6.y


playonce = 1

-- BONUS 
bonus = {}
bonus.speed = {}
bonus.speed.sprite = love.graphics.newImage("ressources/lvldesign/speed+.png")


-- PARTICULES SPRITE 

particle1 = love.graphics.newImage("ressources/particles/particle1.png")


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
balayageVertical.x = 0
balayageVertical.y = 0
balayageVertical.speed = 100


balayageVertical.sens = 0


balayageHorizontal = {}
balayageHorizontal.x = 0
balayageHorizontal.y = 0
balayageHorizontal.speed = 150

balayageHorizontal.active = false
balayageHorizontal.sens = 0

toucheMur = false
toucheTir = false
toucheObject = false


pasInternet = false


-- Affichage ou pas sur l'ecran

afficheMainMenu = false
afficheMenu = false
afficheOptions = false
afficheSelectVirus = false
afficheClassement = false
afficheClassementOffline = false
afficheFin = false
afficheSecret1Debloque = false
afficheSecret2Debloque = false
afficheS = false
afficheCredits = false

animationboss = false
animationTime = 0

blockvirus = false

paternBoss = 0
tempsBoss = 0

bossVulnerable = false

pointCompetence = 0
speed = 1

-- FONT
_fontGame = love.graphics.newFont("fonts/visitor2.ttf",19)
_fontGame1 = love.graphics.newFont("fonts/visitor2.ttf",10)
_fontGameDebut = love.graphics.newFont("fonts/visitor2.ttf",100)


_fontMenu = love.graphics.newFont("fonts/visitor1.ttf",10)
_fontMenu2 = love.graphics.newFont("fonts/visitor1.ttf",20)


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

menu.leaderboardOffline = {}
menu.leaderboardOffline.x = -50
menu.leaderboardOffline.y = 60

menu.quit = {}
menu.quit.x = -50
menu.quit.y = 80

hud = {}
hud.coeur = {}
hud.coeur.sprite = love.graphics.newImage("ressources/hud/coeur_entier.png")


hud.button = {}
hud.button.upgrades = {}
hud.button.upgrades.vitesse = {}
hud.button.upgrades.vitesse.sprite = love.graphics.newImage("ressources/hud/speed_button_select.png")
hud.button.upgrades.vitesse.barre = love.graphics.newImage("ressources/hud/barre.png")

hud.button.upgrades.vie = {}
hud.button.upgrades.vie.sprite = love.graphics.newImage("ressources/hud/life_button.png")

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

menuSelectVirus.selectyourvirus.secret1 = {}
menuSelectVirus.selectyourvirus.secret1.sprite = love.graphics.newImage("ressources/skins/secret/1/down.png")
menuSelectVirus.selectyourvirus.secret1.x = 0
menuSelectVirus.selectyourvirus.secret1.y = 0

credits = {}
credits.developer = {}
credits.developer.x = 0
credits.developer.y = 0

credits.developer.name = {}
credits.developer.name.x = 0
credits.developer.name.y = 0

credits.designer = {}
credits.designer.x = 0
credits.designer.y = 0

credits.designer.name = {}
credits.designer.name.x = 0
credits.designer.name.y = 0

credits.musics = {}
credits.musics.x = 0
credits.musics.y = 0

credits.musics.name = {}
credits.musics.name.x = 0
credits.musics.name.y = 0

credits.specialThanks = {}
credits.specialThanks.x = 0
credits.specialThanks.y = 0

credits.specialThanks.name = {}
credits.specialThanks.name.x = 0
credits.specialThanks.name.y = 0

credits.specialThanks.name2 = {}
credits.specialThanks.name2.x = 0
credits.specialThanks.name2.y = 0

credits.specialThanks.name3 = {}
credits.specialThanks.name3.x = 0
credits.specialThanks.name3.y = 0

credits.specialThanksPlay = {}
credits.specialThanksPlay.name = {}
credits.specialThanksPlay.name.x = 0
credits.specialThanksPlay.name.y = 0


SelectVirusP = ""

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

positioncurseurUpgrades = 1

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

scanTime = 25

timer = 0

patternTime = 0

cam_active = false

Scan = false
Safe = false

pause = false

keyPause = 0

gameOver = false


timerDebut = 1.5
activeTimer = true

timeaffiche = 0

function psystem_explosion_spawn(x,y)
local ps = {}
ps.x = x
ps.y = y
ps.ps = love.graphics.newParticleSystem(particle1, 32)
ps.ps:setParticleLifetime(0.4)
ps.ps:setEmitterLifetime(0.4)
ps.ps:setEmissionRate(500)
ps.ps:setSizeVariation(1)
ps.ps:setLinearAcceleration(-200, -200, 200, 200)
--ps.ps:setTangentialAcceleration(0,100)
ps.ps:setColors(255,255,255,255,255,255,255,0)
table.insert(liste_particles_explosion, ps)
end

function psystem_explosion_boss_spawn(x,y)
local ps = {}
ps.x = x
ps.y = y
ps.ps = love.graphics.newParticleSystem(particle1, 32)
ps.ps:setParticleLifetime(0.4)
ps.ps:setEmitterLifetime(0.4)
ps.ps:setEmissionRate(200)
ps.ps:setSizeVariation(1)
ps.ps:setLinearAcceleration(-800, -800, 800, 800)
--ps.ps:setTangentialAcceleration(0,100)
ps.ps:setColors(255,255,255,255,255,255,255,0)
table.insert(liste_particles_explosion_boss, ps)
end

function psystem_explosion_draw()

for _, v in pairs(liste_particles_explosion) do
  love.graphics.draw(v.ps, v.x, v.y)

end

end

function psystem_explosion_boss_draw()

for _, v in pairs(liste_particles_explosion_boss) do
  love.graphics.draw(v.ps, v.x, v.y)

end

end

function psystem_explosion_update(dt)

for _, v in pairs(liste_particles_explosion) do
  v.ps:update(dt)

end

end

function psystem_explosion_boss_update(dt)

for _, v in pairs(liste_particles_explosion_boss) do
  v.ps:update(dt)

end

end



function PutInLeaderboardOffline_rose()
  
  chunk = love.filesystem.load("leaderboard/lead_rose.lua")
  local result = chunk() -- execute the chunk
  
  addPlayer = {}
  print("Insertion du temps et du pseudo dans le leaderboard...")
  addPlayer.name = pseudo
  addPlayer.times = tonumber(yourTime)
  table.insert(Lrose,addPlayer)
  print("Terminé")
  print("Trions le leaderboard...")
  table.sort(Lrose, function (a,b) return tonumber(a["times"])<tonumber(b["times"]) end )
  print("Terminé")
  print("Mettons à jour le fichier...")
  love.filesystem.write('leaderboard/lead_rose.lua','Lrose = {}\nLrose[1] = {}\nLrose[1].name = "'..Lrose[1].name..'"\nLrose[1].times = "'..Lrose[1].times..'"\n\nLrose[2] = {}\nLrose[2].name = "'..Lrose[2].name..'"\nLrose[2].times = "'..Lrose[2].times..'"'..'\n\nLrose[3] = {}\nLrose[3].name = "'..Lrose[3].name..'"\nLrose[3].times = "'..Lrose[3].times..'"'..'\n\nLrose[4] = {}\nLrose[4].name = "'..Lrose[4].name..'"\nLrose[4].times = "'..Lrose[4].times..'"'..'\n\nLrose[5] = {}\nLrose[5].name = "'..Lrose[5].name..'"\nLrose[5].times = "'..Lrose[5].times..'"'..'\n\nLrose[6] = {}\nLrose[6].name = "'..Lrose[6].name..'"\nLrose[6].times = "'..Lrose[6].times..'"'..'\n\nLrose[7] = {}\nLrose[7].name = "'..Lrose[7].name..'"\nLrose[7].times = "'..Lrose[7].times..'"'..'\n\nLrose[8] = {}\nLrose[8].name = "'..Lrose[8].name..'"\nLrose[8].times = "'..Lrose[8].times..'"'..'\n\nLrose[9] = {}\nLrose[9].name = "'..Lrose[9].name..'"\nLrose[9].times = "'..Lrose[9].times..'"'..'\n\nLrose[10] = {}\nLrose[10].name = "'..Lrose[10].name..'"\nLrose[10].times = "'..Lrose[10].times..'"')
  print("Terminé")
end

function PutInLeaderboardOffline_jaune()
  
  chunk = love.filesystem.load("leaderboard/lead_jaune.lua")
  local result = chunk() -- execute the chunk
  
  addPlayer = {}
  print("Insertion du temps et du pseudo dans le leaderboard...")
  addPlayer.name = pseudo
  addPlayer.times = tonumber(yourTime)
  table.insert(Ljaune,addPlayer)
  print("Terminé")
  print("Trions le leaderboard...")
  table.sort(Ljaune, function (a,b) return tonumber(a["times"])<tonumber(b["times"]) end )
  print("Terminé")
  print("Mettons à jour le fichier...")
  love.filesystem.write('leaderboard/lead_jaune.lua','Ljaune = {}\nLjaune[1] = {}\nLjaune[1].name = "'..Ljaune[1].name..'"\nLjaune[1].times = "'..Ljaune[1].times..'"\n\nLjaune[2] = {}\nLjaune[2].name = "'..Ljaune[2].name..'"\nLjaune[2].times = "'..Ljaune[2].times..'"'..'\n\nLjaune[3] = {}\nLjaune[3].name = "'..Ljaune[3].name..'"\nLjaune[3].times = "'..Ljaune[3].times..'"'..'\n\nLjaune[4] = {}\nLjaune[4].name = "'..Ljaune[4].name..'"\nLjaune[4].times = "'..Ljaune[4].times..'"'..'\n\nLjaune[5] = {}\nLjaune[5].name = "'..Ljaune[5].name..'"\nLjaune[5].times = "'..Ljaune[5].times..'"'..'\n\nLjaune[6] = {}\nLjaune[6].name = "'..Ljaune[6].name..'"\nLjaune[6].times = "'..Ljaune[6].times..'"'..'\n\nLjaune[7] = {}\nLjaune[7].name = "'..Ljaune[7].name..'"\nLjaune[7].times = "'..Ljaune[7].times..'"'..'\n\nLjaune[8] = {}\nLjaune[8].name = "'..Ljaune[8].name..'"\nLjaune[8].times = "'..Ljaune[8].times..'"'..'\n\nLjaune[9] = {}\nLjaune[9].name = "'..Ljaune[9].name..'"\nLjaune[9].times = "'..Ljaune[9].times..'"'..'\n\nLjaune[10] = {}\nLjaune[10].name = "'..Ljaune[10].name..'"\nLjaune[10].times = "'..Ljaune[10].times..'"')
  print("Terminé")
  
end

function PutInLeaderboardOffline_rouge()
  
  chunk = love.filesystem.load("leaderboard/lead_rouge.lua")
  local result = chunk() -- execute the chunk
  
  addPlayer = {}
  print("Insertion du temps et du pseudo dans le leaderboard...")
  addPlayer.name = pseudo
  addPlayer.times = tonumber(yourTime)
  table.insert(Lrouge,addPlayer)
  print("Terminé")
  print("Trions le leaderboard...")
  table.sort(Lrouge, function (a,b) return tonumber(a["times"])<tonumber(b["times"]) end )
  print("Terminé")
  print("Mettons à jour le fichier...")
  love.filesystem.write('leaderboard/lead_rouge.lua','Lrouge = {}\nLrouge[1] = {}\nLrouge[1].name = "'..Lrouge[1].name..'"\nLrouge[1].times = "'..Lrouge[1].times..'"\n\nLrouge[2] = {}\nLrouge[2].name = "'..Lrouge[2].name..'"\nLrouge[2].times = "'..Lrouge[2].times..'"'..'\n\nLrouge[3] = {}\nLrouge[3].name = "'..Lrouge[3].name..'"\nLrouge[3].times = "'..Lrouge[3].times..'"'..'\n\nLrouge[4] = {}\nLrouge[4].name = "'..Lrouge[4].name..'"\nLrouge[4].times = "'..Lrouge[4].times..'"'..'\n\nLrouge[5] = {}\nLrouge[5].name = "'..Lrouge[5].name..'"\nLrouge[5].times = "'..Lrouge[5].times..'"'..'\n\nLrouge[6] = {}\nLrouge[6].name = "'..Lrouge[6].name..'"\nLrouge[6].times = "'..Lrouge[6].times..'"'..'\n\nLrouge[7] = {}\nLrouge[7].name = "'..Lrouge[7].name..'"\nLrouge[7].times = "'..Lrouge[7].times..'"'..'\n\nLrouge[8] = {}\nLrouge[8].name = "'..Lrouge[8].name..'"\nLrouge[8].times = "'..Lrouge[8].times..'"'..'\n\nLrouge[9] = {}\nLrouge[9].name = "'..Lrouge[9].name..'"\nLrouge[9].times = "'..Lrouge[9].times..'"'..'\n\nLrouge[10] = {}\nLrouge[10].name = "'..Lrouge[10].name..'"\nLrouge[10].times = "'..Lrouge[10].times..'"')
  print("Terminé")
  
end

function PutInLeaderboardOffline_original()
  
  chunk = love.filesystem.load("leaderboard/lead_original.lua")
  local result = chunk() -- execute the chunk
  
  addPlayer = {}
  print("Insertion du temps et du pseudo dans le leaderboard...")
  addPlayer.name = pseudo
  addPlayer.times = tonumber(yourTime)
  table.insert(Loriginal,addPlayer)
  print("Terminé")
  print("Trions le leaderboard...")
  table.sort(Loriginal, function (a,b) return tonumber(a["times"])<tonumber(b["times"]) end )
  print("Terminé")
  print("Mettons à jour le fichier...")
  love.filesystem.write('leaderboard/lead_original.lua','Loriginal = {}\nLoriginal[1] = {}\nLoriginal[1].name = "'..Loriginal[1].name..'"\nLoriginal[1].times = "'..Loriginal[1].times..'"\n\nLoriginal[2] = {}\nLoriginal[2].name = "'..Loriginal[2].name..'"\nLoriginal[2].times = "'..Loriginal[2].times..'"'..'\n\nLoriginal[3] = {}\nLoriginal[3].name = "'..Loriginal[3].name..'"\nLoriginal[3].times = "'..Loriginal[3].times..'"'..'\n\nLoriginal[4] = {}\nLoriginal[4].name = "'..Loriginal[4].name..'"\nLoriginal[4].times = "'..Loriginal[4].times..'"'..'\n\nLoriginal[5] = {}\nLoriginal[5].name = "'..Loriginal[5].name..'"\nLoriginal[5].times = "'..Loriginal[5].times..'"'..'\n\nLoriginal[6] = {}\nLoriginal[6].name = "'..Loriginal[6].name..'"\nLoriginal[6].times = "'..Loriginal[6].times..'"'..'\n\nLoriginal[7] = {}\nLoriginal[7].name = "'..Loriginal[7].name..'"\nLoriginal[7].times = "'..Loriginal[7].times..'"'..'\n\nLoriginal[8] = {}\nLoriginal[8].name = "'..Loriginal[8].name..'"\nLoriginal[8].times = "'..Loriginal[8].times..'"'..'\n\nLoriginal[9] = {}\nLoriginal[9].name = "'..Loriginal[9].name..'"\nLoriginal[9].times = "'..Loriginal[9].times..'"'..'\n\nLoriginal[10] = {}\nLoriginal[10].name = "'..Loriginal[10].name..'"\nLoriginal[10].times = "'..Loriginal[10].times..'"')
  print("Terminé")
  
end

function PutInLeaderboardOffline_originalV()
  
  chunk = love.filesystem.load("leaderboard/lead_originalV.lua")
  local result = chunk() -- execute the chunk
  
  addPlayer = {}
  print("Insertion du temps et du pseudo dans le leaderboard...")
  addPlayer.name = pseudo
  addPlayer.times = tonumber(yourTime)
  table.insert(LoriginalV,addPlayer)
  print("Terminé")
  print("Trions le leaderboard...")
  table.sort(LoriginalV, function (a,b) return tonumber(a["times"])<tonumber(b["times"]) end )
  print("Terminé")
  print("Mettons à jour le fichier...")
  love.filesystem.write('leaderboard/lead_originalV.lua','LoriginalV = {}\nLoriginalV[1] = {}\nLoriginalV[1].name = "'..LoriginalV[1].name..'"\nLoriginalV[1].times = "'..LoriginalV[1].times..'"\n\nLoriginalV[2] = {}\nLoriginalV[2].name = "'..LoriginalV[2].name..'"\nLoriginalV[2].times = "'..LoriginalV[2].times..'"'..'\n\nLoriginalV[3] = {}\nLoriginalV[3].name = "'..LoriginalV[3].name..'"\nLoriginalV[3].times = "'..LoriginalV[3].times..'"'..'\n\nLoriginalV[4] = {}\nLoriginalV[4].name = "'..LoriginalV[4].name..'"\nLoriginalV[4].times = "'..LoriginalV[4].times..'"'..'\n\nLoriginalV[5] = {}\nLoriginalV[5].name = "'..LoriginalV[5].name..'"\nLoriginalV[5].times = "'..LoriginalV[5].times..'"'..'\n\nLoriginalV[6] = {}\nLoriginalV[6].name = "'..LoriginalV[6].name..'"\nLoriginalV[6].times = "'..LoriginalV[6].times..'"'..'\n\nLoriginalV[7] = {}\nLoriginalV[7].name = "'..LoriginalV[7].name..'"\nLoriginalV[7].times = "'..LoriginalV[7].times..'"'..'\n\nLoriginalV[8] = {}\nLoriginalV[8].name = "'..LoriginalV[8].name..'"\nLoriginalV[8].times = "'..LoriginalV[8].times..'"'..'\n\nLoriginalV[9] = {}\nLoriginalV[9].name = "'..LoriginalV[9].name..'"\nLoriginalV[9].times = "'..LoriginalV[9].times..'"'..'\n\nLoriginalV[10] = {}\nLoriginalV[10].name = "'..LoriginalV[10].name..'"\nLoriginalV[10].times = "'..LoriginalV[10].times..'"')
  print("Terminé")
  
end

function LookFile_rose()
  
  chunkR = love.filesystem.load("leaderboard/lead_rose.lua")
  local result = chunkR() -- execute the chunk
  
  table.sort(Lrose, function (a,b) return tonumber(a["times"])<tonumber(b["times"]) end )
  print("Terminé")
  print("Mettons à jour le fichier...")
  love.filesystem.write('leaderboard/lead_rose.lua','Lrose = {}\nLrose[1] = {}\nLrose[1].name = "'..Lrose[1].name..'"\nLrose[1].times = "'..Lrose[1].times..'"\n\nLrose[2] = {}\nLrose[2].name = "'..Lrose[2].name..'"\nLrose[2].times = "'..Lrose[2].times..'"'..'\n\nLrose[3] = {}\nLrose[3].name = "'..Lrose[3].name..'"\nLrose[3].times = "'..Lrose[3].times..'"'..'\n\nLrose[4] = {}\nLrose[4].name = "'..Lrose[4].name..'"\nLrose[4].times = "'..Lrose[4].times..'"'..'\n\nLrose[5] = {}\nLrose[5].name = "'..Lrose[5].name..'"\nLrose[5].times = "'..Lrose[5].times..'"'..'\n\nLrose[6] = {}\nLrose[6].name = "'..Lrose[6].name..'"\nLrose[6].times = "'..Lrose[6].times..'"'..'\n\nLrose[7] = {}\nLrose[7].name = "'..Lrose[7].name..'"\nLrose[7].times = "'..Lrose[7].times..'"'..'\n\nLrose[8] = {}\nLrose[8].name = "'..Lrose[8].name..'"\nLrose[8].times = "'..Lrose[8].times..'"'..'\n\nLrose[9] = {}\nLrose[9].name = "'..Lrose[9].name..'"\nLrose[9].times = "'..Lrose[9].times..'"'..'\n\nLrose[10] = {}\nLrose[10].name = "'..Lrose[10].name..'"\nLrose[10].times = "'..Lrose[10].times..'"')
  print("Terminé")
  chunkR = love.filesystem.load("leaderboard/lead_rose.lua")
end

function LookFile_rouge()
  
  chunkR = love.filesystem.load("leaderboard/lead_rouge.lua")
  local result = chunkR() -- execute the chunk 
  
  table.sort(Lrouge, function (a,b) return tonumber(a["times"])<tonumber(b["times"]) end )
  print("Terminé")
  print("Mettons à jour le fichier...")
  love.filesystem.write('leaderboard/lead_rouge.lua','Lrouge = {}\nLrouge[1] = {}\nLrouge[1].name = "'..Lrouge[1].name..'"\nLrouge[1].times = "'..Lrouge[1].times..'"\n\nLrouge[2] = {}\nLrouge[2].name = "'..Lrouge[2].name..'"\nLrouge[2].times = "'..Lrouge[2].times..'"'..'\n\nLrouge[3] = {}\nLrouge[3].name = "'..Lrouge[3].name..'"\nLrouge[3].times = "'..Lrouge[3].times..'"'..'\n\nLrouge[4] = {}\nLrouge[4].name = "'..Lrouge[4].name..'"\nLrouge[4].times = "'..Lrouge[4].times..'"'..'\n\nLrouge[5] = {}\nLrouge[5].name = "'..Lrouge[5].name..'"\nLrouge[5].times = "'..Lrouge[5].times..'"'..'\n\nLrouge[6] = {}\nLrouge[6].name = "'..Lrouge[6].name..'"\nLrouge[6].times = "'..Lrouge[6].times..'"'..'\n\nLrouge[7] = {}\nLrouge[7].name = "'..Lrouge[7].name..'"\nLrouge[7].times = "'..Lrouge[7].times..'"'..'\n\nLrouge[8] = {}\nLrouge[8].name = "'..Lrouge[8].name..'"\nLrouge[8].times = "'..Lrouge[8].times..'"'..'\n\nLrouge[9] = {}\nLrouge[9].name = "'..Lrouge[9].name..'"\nLrouge[9].times = "'..Lrouge[9].times..'"'..'\n\nLrouge[10] = {}\nLrouge[10].name = "'..Lrouge[10].name..'"\nLrouge[10].times = "'..Lrouge[10].times..'"')
  print("Terminé")
  chunkR = love.filesystem.load("leaderboard/lead_rouge.lua")
  
end

function LookFile_jaune()
  
  chunkJ = love.filesystem.load("leaderboard/lead_jaune.lua")
  local result = chunkJ() -- execute the chunk
  
  table.sort(Ljaune, function (a,b) return tonumber(a["times"])<tonumber(b["times"]) end )
  print("Terminé")
  print("Mettons à jour le fichier...")
  love.filesystem.write('leaderboard/lead_jaune.lua','Ljaune = {}\nLjaune[1] = {}\nLjaune[1].name = "'..Ljaune[1].name..'"\nLjaune[1].times = "'..Ljaune[1].times..'"\n\nLjaune[2] = {}\nLjaune[2].name = "'..Ljaune[2].name..'"\nLjaune[2].times = "'..Ljaune[2].times..'"'..'\n\nLjaune[3] = {}\nLjaune[3].name = "'..Ljaune[3].name..'"\nLjaune[3].times = "'..Ljaune[3].times..'"'..'\n\nLjaune[4] = {}\nLjaune[4].name = "'..Ljaune[4].name..'"\nLjaune[4].times = "'..Ljaune[4].times..'"'..'\n\nLjaune[5] = {}\nLjaune[5].name = "'..Ljaune[5].name..'"\nLjaune[5].times = "'..Ljaune[5].times..'"'..'\n\nLjaune[6] = {}\nLjaune[6].name = "'..Ljaune[6].name..'"\nLjaune[6].times = "'..Ljaune[6].times..'"'..'\n\nLjaune[7] = {}\nLjaune[7].name = "'..Ljaune[7].name..'"\nLjaune[7].times = "'..Ljaune[7].times..'"'..'\n\nLjaune[8] = {}\nLjaune[8].name = "'..Ljaune[8].name..'"\nLjaune[8].times = "'..Ljaune[8].times..'"'..'\n\nLjaune[9] = {}\nLjaune[9].name = "'..Ljaune[9].name..'"\nLjaune[9].times = "'..Ljaune[9].times..'"'..'\n\nLjaune[10] = {}\nLjaune[10].name = "'..Ljaune[10].name..'"\nLjaune[10].times = "'..Ljaune[10].times..'"')
  print("Terminé")
   chunkJ = love.filesystem.load("leaderboard/lead_jaune.lua")
end

function LookFile_original()
  
  chunkO = love.filesystem.load("leaderboard/lead_original.lua")
  local result = chunkO() -- execute the chunk
  
  table.sort(Loriginal, function (a,b) return tonumber(a["times"])<tonumber(b["times"]) end )
  print("Terminé")
  print("Mettons à jour le fichier...")
  love.filesystem.write('leaderboard/lead_original.lua','Loriginal = {}\nLoriginal[1] = {}\nLoriginal[1].name = "'..Loriginal[1].name..'"\nLoriginal[1].times = "'..Loriginal[1].times..'"\n\nLoriginal[2] = {}\nLoriginal[2].name = "'..Loriginal[2].name..'"\nLoriginal[2].times = "'..Loriginal[2].times..'"'..'\n\nLoriginal[3] = {}\nLoriginal[3].name = "'..Loriginal[3].name..'"\nLoriginal[3].times = "'..Loriginal[3].times..'"'..'\n\nLoriginal[4] = {}\nLoriginal[4].name = "'..Loriginal[4].name..'"\nLoriginal[4].times = "'..Loriginal[4].times..'"'..'\n\nLoriginal[5] = {}\nLoriginal[5].name = "'..Loriginal[5].name..'"\nLoriginal[5].times = "'..Loriginal[5].times..'"'..'\n\nLoriginal[6] = {}\nLoriginal[6].name = "'..Loriginal[6].name..'"\nLoriginal[6].times = "'..Loriginal[6].times..'"'..'\n\nLoriginal[7] = {}\nLoriginal[7].name = "'..Loriginal[7].name..'"\nLoriginal[7].times = "'..Loriginal[7].times..'"'..'\n\nLoriginal[8] = {}\nLoriginal[8].name = "'..Loriginal[8].name..'"\nLoriginal[8].times = "'..Loriginal[8].times..'"'..'\n\nLoriginal[9] = {}\nLoriginal[9].name = "'..Loriginal[9].name..'"\nLoriginal[9].times = "'..Loriginal[9].times..'"'..'\n\nLoriginal[10] = {}\nLoriginal[10].name = "'..Loriginal[10].name..'"\nLoriginal[10].times = "'..Loriginal[10].times..'"')
  print("Terminé")
  chunkO = love.filesystem.load("leaderboard/lead_original.lua")
end

function LookFile_originalV()
  
  chunkOV = love.filesystem.load("leaderboard/lead_originalV.lua")
  local result = chunkOV() -- execute the chunk
  
  table.sort(LoriginalV, function (a,b) return tonumber(a["times"])<tonumber(b["times"]) end )
  print("Terminé")
  print("Mettons à jour le fichier...")
  love.filesystem.write('leaderboard/lead_originalV.lua','LoriginalV = {}\nLoriginalV[1] = {}\nLoriginalV[1].name = "'..LoriginalV[1].name..'"\nLoriginalV[1].times = "'..LoriginalV[1].times..'"\n\nLoriginalV[2] = {}\nLoriginalV[2].name = "'..LoriginalV[2].name..'"\nLoriginalV[2].times = "'..LoriginalV[2].times..'"'..'\n\nLoriginalV[3] = {}\nLoriginalV[3].name = "'..LoriginalV[3].name..'"\nLoriginalV[3].times = "'..LoriginalV[3].times..'"'..'\n\nLoriginalV[4] = {}\nLoriginalV[4].name = "'..LoriginalV[4].name..'"\nLoriginalV[4].times = "'..LoriginalV[4].times..'"'..'\n\nLoriginalV[5] = {}\nLoriginalV[5].name = "'..LoriginalV[5].name..'"\nLoriginalV[5].times = "'..LoriginalV[5].times..'"'..'\n\nLoriginalV[6] = {}\nLoriginalV[6].name = "'..LoriginalV[6].name..'"\nLoriginalV[6].times = "'..LoriginalV[6].times..'"'..'\n\nLoriginalV[7] = {}\nLoriginalV[7].name = "'..LoriginalV[7].name..'"\nLoriginalV[7].times = "'..LoriginalV[7].times..'"'..'\n\nLoriginalV[8] = {}\nLoriginalV[8].name = "'..LoriginalV[8].name..'"\nLoriginalV[8].times = "'..LoriginalV[8].times..'"'..'\n\nLoriginalV[9] = {}\nLoriginalV[9].name = "'..LoriginalV[9].name..'"\nLoriginalV[9].times = "'..LoriginalV[9].times..'"'..'\n\nLoriginalV[10] = {}\nLoriginalV[10].name = "'..LoriginalV[10].name..'"\nLoriginalV[10].times = "'..LoriginalV[10].times..'"')
  print("Terminé")
  chunkOV = love.filesystem.load("leaderboard/lead_originalV.lua")
end


function dist(x1,y1,x2,y2)
  return (math.sqrt((x1-x2)^2+(y1-y2)^2))
end

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

function lsh(value,shift) 	
return (value*(2^shift)) % 256 
end

function rsh(value,shift) 
return math.floor(value/2^shift) % 256 
end 


function bit(x,b)
return (x % 2^b - x % 2^(b-1) > 0) 
end 

function lor(x,y) 	
result = 0 	
for p=1,8 do 
result = result + (((bit(x,p) or bit(y,p)) == true) and 2^(p-1) or 0) end 	
return result 
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

function check()

  chunk = love.filesystem.load("glouglou/1.lua")
  
  
  local result = chunk() -- execute the chunk

  
end

function SC()
  scV:play()
  afficheS = true
  afficheFin = false


end

function ResetGame()
  
  toucheMur = false
  toucheTir = false
  toucheObject = false
  
  timeBlink = 1
  player.blink = false
  
  animationboss = false
  moving = false
  deadSound:stop()
  deadSound:setPitch(1)
  for k,v in pairs(liste_tirs) do liste_tirs[k]=nil end
  for k,v in pairs(liste_sprites) do liste_sprites[k]=nil end

  imgDecor[0] = love.graphics.newImage("ressources/lvldesign/sol.png")

  tower1.endormi = true
  
  tower3.endormi = true    
  tower4.endormi = true  
  tower5.endormi = true 
  tower6.endormi = true 

  activeTimer = true

  balayageVertical.active = false
  balayageVertical.sens = 0

  balayageHorizontal.active = false
  balayageHorizontal.sens = 0

  animationTime = 0

  timerDebut = 1.5
  Scan = false
  pause = false
  keyPause = 0
  love.audio.stop(lvl1Music)
  love.audio.stop(nigiro_music)

  player.speed = 81
  player.speedP = 1
  player.speedActu = 81
  player.life = 1
  player.maxLife = 1
  scanTime = 25

  timer = 0



end

function Fin()

  love.graphics.clear()
  -- Merci a Jimmy Labodudev pour son aide
  if SelectVirusP == "original" then 
    love.audio.stop(leaderboardMusic_rose)
    --love.audio.play(leaderboardMusic)
    b, c, h = http.request("http://ver-infect.atspace.cc/110/getData_original.php")
    --b, c, h = http.request("http://127.0.0.1/getData_original.php")
  end
  if SelectVirusP == "originalV" then
    love.audio.stop(leaderboardMusic_jaune)
    love.audio.stop(leaderboardMusic_rose)
    --love.audio.play(nigiro_music)
    b, c, h = http.request("http://ver-infect.atspace.cc/110/getData_originalV.php")
    --b, c, h = http.request("http://127.0.0.1/getData_originalV.php")
  end
  if SelectVirusP == "rouge" then
    love.audio.stop(leaderboardMusic_rose)
    --love.audio.play(leaderboardMusic)
    b, c, h = http.request("http://ver-infect.atspace.cc/110/getData_rouge.php")
    --b, c, h = http.request("http://127.0.0.1/getData_rouge.php")
  end
  if SelectVirusP == "rose" then
    --love.audio.play(leaderboardMusic_rose)
    love.audio.stop(leaderboardMusic)
    love.audio.stop(leaderboardMusic_jaune)
    b, c, h = http.request("http://ver-infect.atspace.cc/110/getData_rose.php")
    --b, c, h = http.request("http://127.0.0.1/getData_rose.php")
  end
  if SelectVirusP == "jaune" then
    love.audio.stop(leaderboardMusic_rose)
    --love.audio.play(leaderboardMusic_jaune)
    b, c, h = http.request("http://ver-infect.atspace.cc/110/getData_jaune.php")
    --b, c, h = http.request("http://127.0.0.1/getData_jaune.php")
  end
  afficheOptions = false
  afficheMainMenu = false
  afficheMenu = true
  afficheSelectVirus = false
  afficheClassement = false
  afficheFin = true

  love.audio.stop(lvl1Music)

  love.keyboard.setKeyRepeat(true)
  love.graphics.setFont(_fontMenu)

  camera.y = 0
  camera.x = 0

end

function credit() 
  
  afficheMainMenu = false
  afficheCredits = true
  afficheMenu = true
  afficheOptions = false
  afficheSelectVirus = false
  afficheClassement = false
  afficheClassementOffline = false
  afficheFin = false
  afficheUprades = false
  
  love.audio.stop(leaderboardMusic_jaune)
  love.audio.stop(leaderboardMusic)
  love.audio.stop(leaderboardMusic_rose)
  love.audio.stop(leaderboardMusic_nigiro)
  love.audio.stop(SelectVirusMusic)
  love.audio.stop(MenuMusic)
  love.audio.stop(secret1_music)
  love.audio.stop(secret1_musicP)
  love.audio.stop(nigiro_music)
  love.audio.stop(megalovania_remack)
  love.audio.stop(music_miniboss1)
  love.audio.play(win_music)
  love.audio.stop(gameOver_music)

  credits.developer.x = 20
  credits.developer.y = 300


  credits.developer.name.x = 20
  credits.developer.name.y = 320


  credits.designer.x = 20
  credits.designer.y = 370


  credits.designer.name.x = 20
  credits.designer.name.y = 390


  credits.musics.x = 20
  credits.musics.y = 440


  credits.musics.name.x = 20
  credits.musics.name.y = 460


  credits.specialThanks.x = 20
  credits.specialThanks.y = 510


  credits.specialThanks.name.x = 20
  credits.specialThanks.name.y = 530
  
  credits.specialThanks.name2.x = 20
  credits.specialThanks.name2.y = 540
  
  credits.specialThanks.name3.x = 20
  credits.specialThanks.name3.y = 550
    
  credits.specialThanksPlay.name.x = 20
  credits.specialThanksPlay.name.y = 600
    
end

function Leaderboard()




  if positionhorizontalClassement == 1 then

    NomClassement = "Origin"
    b, c, h = http.request("http://ver-infect.atspace.cc/110/getData_original.php")

    love.audio.play(leaderboardMusic)
    leaderboardMusic:setPitch(1)
    love.audio.pause(leaderboardMusic_rose)
    love.audio.pause(leaderboardMusic_nigiro)


  elseif positionhorizontalClassement == 2 then
    NomClassement = "Nigiro"
    b, c, h = http.request("http://ver-infect.atspace.cc/110/getData_originalV.php")
    love.audio.play(nigiro_music)
    love.audio.pause(leaderboardMusic_rose)


  elseif positionhorizontalClassement == 3 then
    NomClassement = "Ragel"
    b, c, h = http.request("http://ver-infect.atspace.cc/110/getData_rouge.php")
    love.audio.play(leaderboardMusic)
    love.audio.pause(nigiro_music)
    leaderboardMusic:setPitch(2)


  elseif positionhorizontalClassement == 4 then
    NomClassement = "Noobik"
    b, c, h = http.request("http://ver-infect.atspace.cc/110/getData_rose.php")
    love.audio.play(leaderboardMusic_rose)
    NomClassement = "Noobik"


  elseif positionhorizontalClassement == 5 then
    NomClassement = "TLP"
    b, c, h = http.request("http://ver-infect.atspace.cc/110/getData_jaune.php")
    love.audio.play(leaderboardMusic_jaune)
    love.audio.pause(leaderboardMusic_nigiro)
    --leaderboardMusic:setPitch(1.5)


  else
    pasInternet = true
  end


  afficheOptions = false
  afficheMainMenu = false
  afficheMenu = true
  afficheSelectVirus = false
  afficheClassement = true
  afficheFin = false

  

  love.graphics.setFont(_fontMenu)


end

function LeaderboardOffline()

  LookFile_rose()
  LookFile_rouge()
  LookFile_jaune()
  LookFile_original()
  LookFile_originalV()

  if positionhorizontalClassement == 1 then
    love.audio.play(leaderboardMusic)
    leaderboardMusic:setPitch(1)
    love.audio.pause(leaderboardMusic_rose)
    NomClassement = "Origin"


  elseif positionhorizontalClassement == 2 then
    love.audio.play(leaderboardMusic)
    leaderboardMusic:setPitch(0.5)
    love.audio.pause(leaderboardMusic_rose)
    NomClassement = "Nigiro"


  elseif positionhorizontalClassement == 3 then
    love.audio.play(leaderboardMusic)

    leaderboardMusic:setPitch(2)
    NomClassement = "Ragel"


  elseif positionhorizontalClassement == 4 then

    love.audio.play(leaderboardMusic_rose)
    NomClassement = "Noobik"


  elseif positionhorizontalClassement == 5 then
    love.audio.play(leaderboardMusic_jaune)
    love.audio.stop(leaderboardMusic)
    --leaderboardMusic:setPitch(1.5)
    NomClassement = "TLP"


  end


  afficheOptions = false
  afficheMainMenu = false
  afficheMenu = true
  afficheSelectVirus = false
  afficheClassement = false
  afficheClassementOffline = true
  afficheFin = false
  

  love.audio.stop(MenuMusic)
  love.audio.stop(nigiro_music)

  love.graphics.setFont(_fontMenu)


end

function Upgrades()
  
  afficheUprades = true 

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
  afficheClassementOffline = false
  afficheFin = false
  afficheUprades = false

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

  menuSelectVirus.selectyourvirus.secret1.x = 98
  menuSelectVirus.selectyourvirus.secret1.y = 100

  love.graphics.setFont(_fontMenu)




end


function MainMenu()
  gameOver = false
  love.graphics.setBackgroundColor(0,0,0)
  pseudo = ""
  cam_active = false
  virusTeleport:setPitch(1)
  deadSound:setPitch(1)
  leaderboardMusic:setPitch(1)
  lvl1Music:setPitch(1)
  love.audio.stop(leaderboardMusic_jaune)
  love.audio.stop(leaderboardMusic)
  love.audio.stop(leaderboardMusic_rose)
  love.audio.stop(leaderboardMusic_nigiro)
  love.audio.stop(SelectVirusMusic)
  love.audio.play(MenuMusic)
  love.audio.stop(secret1_music)
  love.audio.stop(secret1_musicP)
  love.audio.stop(nigiro_music)
  love.audio.stop(megalovania_remack)
  love.audio.stop(music_miniboss1)
  love.audio.stop(win_music)
  love.audio.stop(gameOver_music)
  SelectVirusP = ""

  deadSound:setLooping(false)
  enableSecret1 = false

  love.keyboard.setKeyRepeat(true)

  menu.principal.x = 1
  menu.principal.y = ((love.graphics.getHeight()/9))

  menu.play.x = 1
  menu.play.y = ((love.graphics.getHeight()/5))

  menu.options.x = -10
  menu.options.y = ((love.graphics.getHeight()/5+100))

  menu.leaderboard.x = -20
  menu.leaderboard.y = ((love.graphics.getHeight()/5+200))

  menu.leaderboardOffline.x = -20
  menu.leaderboardOffline.y = ((love.graphics.getHeight()/5+300))

  menu.quit.x = -30
  if check_fullscreen == true then
    menu.quit.y = ((love.graphics.getHeight()/5+400))
  else
    menu.quit.y = ((love.graphics.getHeight()/5+400))
  end
  curseurmenu.x = -20

  particule1_x = curseurmenu.x
  particule1_y = curseurmenu.y

  afficheMainMenu = true
  afficheCredits = false
  afficheMenu = true
  afficheOptions = false
  afficheSelectVirus = false
  afficheClassement = false
  afficheClassementOffline = false
  afficheFin = false
  afficheUprades = false

  Asecret1_music = false

  camera.y = 0
  camera.x = 0

  love.graphics.setFont(_fontMenu)


end

function OptionsMenu()



  menuOptions.x = love.graphics.getWidth()/2
  menuOptions.y = love.graphics.getHeight()/20

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
  afficheClassementOffline = false
  afficheUprades = false

  camera.y = 0
  camera.x = 0

  love.graphics.setFont(_fontMenu)

  positioncurseur = 1

end




function PremierNiveau()
  bossdead = false
  bossVulnerable = true
  patternTime = 0
  love.audio.stop(music_miniboss1)
  love.audio.stop(gameOver_music)
  
  pointCompetence = 0
  
  
  playonce = 1 
  playonce2 = 1
  map1()
  player.affiche = true

   if musicVarr == 1 then
  lvl1Music = love.audio.newSource("musics/lvl1.ogg", "stream")
  lvl1Music:setLooping(true)
  elseif musicVarr == 2 then
  lvl1Music = lvl1Music_var1
  lvl1Music:setLooping(true)
elseif musicVarr == 3 then
  lvl1Music = lvl1Music_var2
  lvl1Music:setLooping(true)
  elseif musicVarr == 4 then
  lvl1Music = love.audio.newSource("musics/lvl1.ogg", "stream")
  lvl1Music:setLooping(true)
  musicVarr = 1
  end

  tower1.rotation = 4.7 -- SPRITE TOURNER VERS LE HAUT
  tower2.rotation = 1.57 -- SPRITE TOURNER VERS LE BAS
  tower3.rotation = 4.7
  tower4.rotation = 1.57
  tower5.rotation = 1.57
  tower6.rotation = 1.8

  bossVulnerable = false

  cam_active = true
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
  afficheClassementOffline = false
  afficheUprades = false
  afficheCredits = false

  Niveau = 1

  --camera.y = 0

  --camera.x = player.x - love.graphics.getWidth() / 9 

  timeBougeVertical = 0
  timeBougeHorizontal = 0

  lvlActuel = 1

  -- Coordonnées du Spawn Depart
  caseDepartX = 11
  caseDepartY = 6

  -- Coordonnées du Spawn DEBUG
  --caseDepartX = 70
  --caseDepartY = 6
  
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



gameOver_music:setPitch(1)
  -- Met en place les coordonnées du joueur au spawn Depart 
  if SelectVirusP == "original" then
    win_music:setLooping(true)
    win_music:setPitch(1)
    psystem:setParticleLifetime(0.2, 0.2)
    psystem:setEmissionRate(80)
    imgDecor[1] = love.graphics.newImage("ressources/lvldesign/mur.png")
    imgDecor[7] = love.graphics.newImage("ressources/lvldesign/passable.png")
    love.audio.play(lvl1Music)
    deadSound:setLooping(false)
    playerStart = virus.skins.original.start
    virus.skins.jaune.power = false
    player.x = spawn.depart.x
    player.y = spawn.depart.y

  elseif SelectVirusP == "jaune" then
    psystem:setParticleLifetime(0.2, 0.2)
    psystem:setEmissionRate(80)
    win_music:setLooping(true)
    win_music:setPitch(0.8)
    imgDecor[1] = love.graphics.newImage("ressources/lvldesign/mur.png")
    imgDecor[7] = love.graphics.newImage("ressources/lvldesign/passable.png")
    love.audio.play(lvl1Music)
    deadSound:setLooping(false)

    playerStart = virus.skins.jaune.start
    virus.skins.jaune.power = true
    player.x = spawn.depart.x
    player.y = spawn.depart.y

elseif SelectVirusP == "rouge" then
    win_music:setLooping(true)
    win_music:setPitch(2)
    virusTeleport:setPitch(2)
    deadSound:setPitch(2)
    deadSound:setLooping(false)
    leaderboardMusic:setPitch(2)
    lvl1Music:setPitch(2)
    
    psystem:setParticleLifetime(0.3, 0.3)
  	psystem:setEmissionRate(100)
    imgDecor[1] = love.graphics.newImage("ressources/lvldesign/mur.png")
    imgDecor[7] = love.graphics.newImage("ressources/lvldesign/passable.png")
    love.audio.play(lvl1Music)
    playerStart = virus.skins.rouge.start
    player.speed = virus.skins.rouge.speed
    virus.skins.jaune.power = false
    player.x = spawn.depart.x
    player.y = spawn.depart.y

elseif SelectVirusP == "originalV" then
    win_music:setLooping(0.5)
    win_music:setPitch(0.8)
    psystem:setParticleLifetime(0.2, 0.2)
    psystem:setEmissionRate(80)
    virus.skins.jaune.power = false
    imgDecor[1] = love.graphics.newImage("ressources/lvldesign/murnigiro.png")
    imgDecor[7] = love.graphics.newImage("ressources/lvldesign/murnigiro.png")
    love.audio.play(nigiro_music)
    deadSound:setLooping(true)
    playerStart = virus.skins.originalV.start
    gameOver_music:setPitch(0.1)
    deadSound:setPitch(10)
    virusTeleport:setPitch(0.8)

    virus.skins.jaune.power = false
    player.x = spawn.depart.x
    player.y = spawn.depart.y

elseif SelectVirusP == "rose" then
  
    psystem:setParticleLifetime(0.2, 0.2)
  	psystem:setEmissionRate(80)
    imgDecor[1] = love.graphics.newImage("ressources/lvldesign/murrose.png")
    imgDecor[7] = love.graphics.newImage("ressources/lvldesign/murrose.png")
    love.audio.play(leaderboardMusic_rose)
    playerStart = virus.skins.rose.start
    leaderboardMusic:setPitch(0.9)
    deadSound:setLooping(false)
    virus.skins.jaune.power = false
    balayageHorizontal.y = -10
    balayageVertical.x = -10
    player.x = spawn.depart.x
    player.y = spawn.depart.y

  elseif enableSecret1 == true and cSecret1 == "true" then
    virus.skins.jaune.power = false
    SelectVirusP = ""
    deadSound:setLooping(false)
    playerStart = virus.skins.secret1.start
    player.speed = virus.skins.secret1.speed
    love.audio.play(secret1_musicP)
    love.audio.stop(lvl1Music)

    player.x = spawn.depart.x+4
    player.y = spawn.depart.y+4

  end
  
  player.speedActu = player.speed

end

function DeuxiemeNiveau()
  
  
  toucheMur = false
  toucheTir = false
  toucheObject = false
  player.affiche = true
  player.blink = false
  bossdead = false
  miniboss1.active = false
  bosslife = 64
  patternTime = 0
  paternBoss = 0
  miniboss1.x = 270
  animationTime = 0
  tempsBoss = 0
  departY = 0
  departX = 0
  player.life = 1
  timeBlink = 1
  
  playonce = 1
  playonce2 = 1
  love.keyboard.setKeyRepeat(false)
  
  
  
  winwrite = ""
  if SelectVirusP == "rouge" then 
    miniboss1.speed = 10
    miniboss1.y = -20
  elseif SelectVirusP == "original" or SelectVirusP == "jaune" or SelectVirusP == "rose" or SelectVirusP == "TLP" then
    miniboss1.speed = 5.5
    miniboss1.y = -20
  elseif SelectVirusP == "originalV" then
    miniboss1.speed = 5.5
    miniboss1.y = -20
end
  animationboss = true
  love.audio.play(music_miniboss1)
  love.audio.stop(secret1_musicP)
  love.audio.stop(lvl1Music)
  love.audio.stop(lvl1Music_var1)
  love.audio.stop(lvl1Music_var2)
  love.audio.stop(leaderboardMusic_rose)
  love.audio.stop(win_music)
  love.audio.stop(gameOver_music)
  map2()
 
-- Coordonnées du Spawn Depart
  caseDepartX = 18.5
  caseDepartY = 11


  -- Coordonnées du Spawn Finish
  --caseFinX = 26
  --caseFinY = 6
  imgDecor[0] = love.graphics.newImage("ressources/lvldesign/sol_rouge.png")
  -- Met en place les spawn 
  spawn.depart.x = caseDepartX*16
  spawn.depart.y = caseDepartY*16
  
  gameOver = false
  afficheMainMenu = false
  afficheMenu = false
  afficheOptions = false
  afficheSelectVirus = false
  afficheClassement = false
  afficheFin = false
  afficheClassementOffline = false
  afficheCredits = false
  
  Niveau = 2
  cam_active = true
  love.audio.stop(MenuMusic)
  love.audio.stop(SelectVirusMusic)
  -- Met en place les coordonnées du joueur au spawn Depart 
  if SelectVirusP == "original" then
    
    psystem:setParticleLifetime(0.2, 0.2)
    psystem:setEmissionRate(80)
    imgDecor[1] = love.graphics.newImage("ressources/lvldesign/mur.png")
    imgDecor[7] = love.graphics.newImage("ressources/lvldesign/passable.png")
    music_miniboss1:setPitch(1)
    deadSound:setLooping(false)
    playerStart = virus.skins.original.start
    virus.skins.jaune.power = false
    player.x = spawn.depart.x
    player.y = spawn.depart.y

  elseif SelectVirusP == "jaune" then
    psystem:setParticleLifetime(0.2, 0.2)
    psystem:setEmissionRate(80)
    imgDecor[1] = love.graphics.newImage("ressources/lvldesign/mur.png")
    imgDecor[7] = love.graphics.newImage("ressources/lvldesign/passable.png")
    music_miniboss1:setPitch(1)
    deadSound:setLooping(false)

    playerStart = virus.skins.jaune.start
    virus.skins.jaune.power = true
    player.x = spawn.depart.x
    player.y = spawn.depart.y

  elseif SelectVirusP == "rouge" then
    psystem:setParticleLifetime(0.3, 0.3)
  	psystem:setEmissionRate(100)
    imgDecor[1] = love.graphics.newImage("ressources/lvldesign/mur.png")
    imgDecor[7] = love.graphics.newImage("ressources/lvldesign/passable.png")
    playerStart = virus.skins.rouge.start
    player.speed = virus.skins.rouge.speed
    virusTeleport:setPitch(2)
    deadSound:setPitch(2)
    deadSound:setLooping(false)
    music_miniboss1:setPitch(2)
    leaderboardMusic:setPitch(2)
    lvl1Music:setPitch(2)
    virus.skins.jaune.power = false
    player.x = spawn.depart.x
    player.y = spawn.depart.y

elseif SelectVirusP == "originalV" then
  
    psystem:setParticleLifetime(0.2, 0.2)
    psystem:setEmissionRate(80)
    virus.skins.jaune.power = false
    imgDecor[1] = love.graphics.newImage("ressources/lvldesign/murnigiro.png")
    imgDecor[7] = love.graphics.newImage("ressources/lvldesign/murnigiro.png")
    love.audio.stop(nigiro_music)
    deadSound:setLooping(true)
    playerStart = virus.skins.originalV.start
    music_miniboss1:setPitch(0.8)
    deadSound:setPitch(10)
    virusTeleport:setPitch(0.8)

    virus.skins.jaune.power = false
    player.x = spawn.depart.x
    player.y = spawn.depart.y

elseif SelectVirusP == "rose" then
  
    psystem:setParticleLifetime(0.2, 0.2)
  	psystem:setEmissionRate(80)
    imgDecor[1] = love.graphics.newImage("ressources/lvldesign/murrose.png")
    imgDecor[7] = love.graphics.newImage("ressources/lvldesign/murrose.png")
    love.audio.stop(leaderboardMusic_rose)
    --love.audio.stop(music_miniboss1)
    playerStart = virus.skins.rose.start
    leaderboardMusic:setPitch(0.9)
    music_miniboss1:setPitch(1)
    deadSound:setLooping(false)
    virus.skins.jaune.power = false
    balayageHorizontal.y = -10
    balayageVertical.x = -10
    player.x = spawn.depart.x
    player.y = spawn.depart.y

  elseif enableSecret1 == true and cSecret1 == "true" then
    MainMenu()

  end


end

function TroisiemeNiveau()
  toucheMur = false
  toucheTir = false
  toucheObject = false
  player.affiche = true
  player.blink = false
  bossdead = false
  miniboss1.active = false
  bosslife = 64
  patternTime = 0
  paternBoss = 0
  miniboss1.x = 270
  animationTime = 0
  tempsBoss = 0
  departY = 0
  departX = 0
  player.life = 1
  timeBlink = 1
  
  playonce = 1
  playonce2 = 1
  love.keyboard.setKeyRepeat(false)
  
  
  
  winwrite = ""
  if SelectVirusP == "rouge" then 
    miniboss1.speed = 10
    miniboss1.y = -20
  elseif SelectVirusP == "original" or SelectVirusP == "jaune" or SelectVirusP == "rose" or SelectVirusP == "TLP" then
    miniboss1.speed = 5.5
    miniboss1.y = -20
  elseif SelectVirusP == "originalV" then
    miniboss1.speed = 5.5
    miniboss1.y = -20
  elseif SelectVirusP == "" then
    miniboss1.speed = 10
    miniboss1.y = -20
end
  animationboss = false
  love.audio.stop(music_miniboss1)
  love.audio.stop(secret1_musicP)
  love.audio.stop(lvl1Music)
  love.audio.stop(lvl1Music_var1)
  love.audio.stop(lvl1Music_var2)
  love.audio.stop(win_music)
  love.audio.stop(gameOver_music)
  map2()
 
-- Coordonnées du Spawn Depart
  caseDepartX = 18.5
  caseDepartY = 11


  -- Coordonnées du Spawn Finish
  --caseFinX = 26
  --caseFinY = 6
  imgDecor[0] = love.graphics.newImage("ressources/lvldesign/sol_rouge.png")
  -- Met en place les spawn 
  spawn.depart.x = caseDepartX*16
  spawn.depart.y = caseDepartY*16
  
  gameOver = false
  afficheMainMenu = false
  afficheMenu = false
  afficheOptions = false
  afficheSelectVirus = false
  afficheClassement = false
  afficheFin = false
  afficheClassementOffline = false
  
  
  Niveau = 3
  cam_active = true
  love.audio.stop(MenuMusic)
  love.audio.stop(SelectVirusMusic)
  -- Met en place les coordonnées du joueur au spawn Depart 
  if SelectVirusP == "original" then
    
    psystem:setParticleLifetime(0.2, 0.2)
    psystem:setEmissionRate(80)
    imgDecor[1] = love.graphics.newImage("ressources/lvldesign/mur.png")
    imgDecor[7] = love.graphics.newImage("ressources/lvldesign/passable.png")
    music_miniboss1:setPitch(1)
    deadSound:setLooping(false)
    playerStart = virus.skins.original.start
    virus.skins.jaune.power = false
    player.x = spawn.depart.x
    player.y = spawn.depart.y

  elseif SelectVirusP == "jaune" then
    psystem:setParticleLifetime(0.2, 0.2)
    psystem:setEmissionRate(80)
    imgDecor[1] = love.graphics.newImage("ressources/lvldesign/mur.png")
    imgDecor[7] = love.graphics.newImage("ressources/lvldesign/passable.png")
    music_miniboss1:setPitch(1)
    deadSound:setLooping(false)

    playerStart = virus.skins.jaune.start
    virus.skins.jaune.power = true
    player.x = spawn.depart.x
    player.y = spawn.depart.y

  elseif SelectVirusP == "rouge" then
    psystem:setParticleLifetime(0.3, 0.3)
  	psystem:setEmissionRate(100)
    imgDecor[1] = love.graphics.newImage("ressources/lvldesign/mur.png")
    imgDecor[7] = love.graphics.newImage("ressources/lvldesign/passable.png")
    playerStart = virus.skins.rouge.start
    player.speed = virus.skins.rouge.speed
    virusTeleport:setPitch(2)
    deadSound:setPitch(2)
    deadSound:setLooping(false)
    music_miniboss1:setPitch(2)
    leaderboardMusic:setPitch(2)
    lvl1Music:setPitch(2)
    virus.skins.jaune.power = false
    player.x = spawn.depart.x
    player.y = spawn.depart.y

elseif SelectVirusP == "originalV" then
  
    psystem:setParticleLifetime(0.2, 0.2)
    psystem:setEmissionRate(80)
    virus.skins.jaune.power = false
    imgDecor[1] = love.graphics.newImage("ressources/lvldesign/murnigiro.png")
    imgDecor[7] = love.graphics.newImage("ressources/lvldesign/murnigiro.png")
    love.audio.stop(nigiro_music)
    deadSound:setLooping(false)
    playerStart = virus.skins.originalV.start
    music_miniboss1:setPitch(0.8)
    deadSound:setPitch(10)
    virusTeleport:setPitch(0.8)

    virus.skins.jaune.power = false
    player.x = spawn.depart.x
    player.y = spawn.depart.y

elseif SelectVirusP == "rose" then
  
    psystem:setParticleLifetime(0.2, 0.2)
  	psystem:setEmissionRate(80)
    imgDecor[1] = love.graphics.newImage("ressources/lvldesign/murrose.png")
    imgDecor[7] = love.graphics.newImage("ressources/lvldesign/murrose.png")
    love.audio.play(leaderboardMusic_rose)
    --love.audio.stop(music_miniboss1)
    music_miniboss1:setPitch(1)
    playerStart = virus.skins.rose.start
    leaderboardMusic:setPitch(0.9)
    deadSound:setLooping(false)
    virus.skins.jaune.power = false
    balayageHorizontal.y = -10
    balayageVertical.x = -10
    player.x = spawn.depart.x
    player.y = spawn.depart.y

  elseif enableSecret1 == true and cSecret1 == "true" then
    virus.skins.jaune.power = false
    SelectVirusP = ""
    deadSound:setLooping(false)
    --love.audio.stop(music_miniboss1)
    playerStart = virus.skins.secret1.start
    player.speed = virus.skins.secret1.speed
    love.audio.play(secret1_musicP)
    love.audio.stop(lvl1Music)
    virus.skins.jaune.power = false
    deadSound:setLooping(false)
    music_miniboss1:setPitch(2)
    player.x = spawn.depart.x+4
    player.y = spawn.depart.y+4

  end


end


function CreeSprite(pNomImage, pX, pY)

  sprite = {}
  sprite.x = pX
  sprite.y = pY
  sprite.supprime = false
  sprite.sprite = love.graphics.newImage("ressources/"..pNomImage..".png")
  sprite.l = sprite.sprite:getWidth()
  sprite.h = sprite.sprite:getHeight()

  sprite.frame = 1
  sprite.listeFrames = {}
  sprite.maxFrame = 1

  table.insert(liste_sprites, sprite)

  return sprite

end

function CreeTir(pType, pNomImage, pX, pY, pVitesseX, pVitesseY)
  local tir = CreeSprite(pNomImage, pX, pY)
  tir.type = pType
  tir.vx = pVitesseX
  tir.vy = pVitesseY
  table.insert(liste_tirs, tir)
  love.audio.play(Shoottower)
 
  print("tire")
end

function math.angle(x1,y1, x2,y2) return math.atan2(y2-y1, x2-x1) end

function collide(a1, a2)
  if (a1==a2) then return false end
  local dx = a1.x - a2.x
  local dy = a1.y - a2.y

  if enableSecret1 == false then
    if (math.abs(dx+8) < 4+a2.sprite:getWidth()) then
      if (math.abs(dy+8) < 4+a2.sprite:getHeight()) then
        return true
      end
    end
  else
    if (math.abs(dx+8) < a2.sprite:getWidth()) then
      if (math.abs(dy+8) < a2.sprite:getHeight()) then
        return true
      end
    end
  end
  return false
end

function love.load()
  
  moving = false
  love.filesystem.setIdentity("Ver'InfectData")

  psystem = love.graphics.newParticleSystem(particle1, 32)
	psystem:setSizeVariation(1)
	psystem:setColors(255, 255, 255, 255, 255, 255, 255, 0) -- Fade to transparency.
  
  
  limit_caractere = 1

  file_leadJaune = love.filesystem.newFile("leaderboard/lead_jaune.lua")


  linesLeaderboard = {}


  filedirectory = love.filesystem.getSourceBaseDirectory()
  photoData = love.filesystem.read("glouglou/1.lua")
  backData = love.filesystem.read("glouglou/2.lua")
  --print(backData)
 
  if photoData ~= backData then
    
    love.event.quit()
    
  end
 
 
  

  -- LEADERBOARD LOCAL (non sécurisé)

  if not love.filesystem.exists("leaderboard") then
    love.filesystem.createDirectory("leaderboard")
  end


  --
  if not love.filesystem.exists("leaderboard/lead_jaune.lua") then
    love.filesystem.newFile("leaderboard/lead_jaune.lua") 
  end

  if not love.filesystem.exists("leaderboard/lead_rouge.lua") then
    love.filesystem.newFile("leaderboard/lead_rouge.lua") 
  end

  if not love.filesystem.exists("leaderboard/lead_rose.lua") then
    love.filesystem.newFile("leaderboard/lead_rose.lua") 
  end

  if not love.filesystem.exists("leaderboard/lead_original.lua") then
    love.filesystem.newFile("leaderboard/lead_original.lua") 
  end

  if not love.filesystem.exists("leaderboard/lead_originalV.lua") then
    love.filesystem.newFile("leaderboard/lead_originalV.lua") 
  end

  for lines in love.filesystem.lines("leaderboard/lead_jaune.lua") do
    table.insert(linesLeaderboard,lines)
  end

  print("Nombre de ligne : "..#linesLeaderboard)


  print("")



  width, height = love.window.getDesktopDimensions(display)


  largeurEcran = width
  hauteurEcran = height

  love.mouse.setVisible(false)
  love.window.setFullscreen(true)
  check_fullscreen = love.window.getFullscreen()
  print(check_fullscreen)

  pseudo = ""
  winwrite = ""
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
  check_secret1 = {}
  check_secret2 = {}
  highscores = {}

  getEmplacement1 = {}
  getEmplacement2 = {}
  getEmplacement3 = {}
  getEmplacement4 = {}
  getEmplacement5 = {}
  getEmplacement6 = {}
  getEmplacement7 = {}
  getEmplacement8 = {}
  getEmplacement9 = {}
  getEmplacement10 = {}








  print("Fichier des sauvegardes : "..savedirectory)



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

  if not love.filesystem.exists("secret1_check.lua") then
    love.filesystem.newFile("secret1_check.lua")
    love.filesystem.write("secret1_check.lua","false")
  end

  if not love.filesystem.exists("secret2_check.lua") then
    love.filesystem.newFile("secret2_check.lua")
    love.filesystem.write("secret2_check.lua","false")
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




  --print(highscore)


  for lines in love.filesystem.lines("secret1_check.lua") do
    table.insert(check_secret1,lines)
  end

  cSecret1 = check_secret1[1]



  print ("Secret 1 : "..cSecret1)



  --for lines in love.filesystem.lines("secret2_check.lua") do
  --table.insert(check_secret2,lines)
  --end

  --cSecret2 = check_secret2[1]


  -- print(cSecret1)
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
  
  musicVarr = 1
  
  avertissementScan = love.audio.newSource("sounds/warning.wav","static")

  Shoottower =  love.audio.newSource("sounds/towerShoot.wav","static")
  Toucher = love.audio.newSource("sounds/toucher.wav","static")

  deadSound = love.audio.newSource("sounds/dead.wav","static")
  lvlUp = love.audio.newSource("sounds/lvlup2.wav","static")
  takeSpeed = love.audio.newSource("sounds/speed.wav","static")
  input = love.audio.newSource("sounds/input.wav","static")
  puttime = love.audio.newSource("sounds/puttime.wav","static")

  music_miniboss1 = love.audio.newSource("musics/miniboss1.ogg", "stream")
  music_miniboss1:setLooping(true)
  megalovania_remack = love.audio.newSource("musics/megalovania_REMACK.ogg", "stream")

  secret1_musicP = love.audio.newSource("musics/secret1_mumu.ogg", "stream")
  secret1_musicP:setLooping(true)

  leaderboardMusic = love.audio.newSource("musics/leaderboard1.ogg", "stream")
  leaderboardMusic:setLooping(true)

  leaderboardMusic_rose = love.audio.newSource("musics/leaderboard_rose.ogg", "stream")
  leaderboardMusic_rose:setLooping(true)

  leaderboardMusic_jaune = love.audio.newSource("musics/leaderboard_jaune.ogg", "stream")
  leaderboardMusic_jaune:setLooping(true)

  leaderboardMusic_nigiro = love.audio.newSource("musics/leaderboard_nigiro.ogg", "stream")
  leaderboardMusic_nigiro:setLooping(true)

  --scV = love.graphics.newVideo("videos/test.ogv")

  MenuMusic = love.audio.newSource("musics/menu.ogg", "stream")
  MenuMusic:setLooping(true)

  lvl1Music = love.audio.newSource("musics/lvl1.ogg", "stream")
  lvl1Music_var1 = love.audio.newSource("musics/lvl1_var1.ogg", "stream")
  lvl1Music_var2 = love.audio.newSource("musics/lvl1_var2.ogg", "stream")
  
  secret1_music = love.audio.newSource("musics/secret1_music.ogg", "stream")
  nigiro_music = love.audio.newSource("musics/nigiro_music.ogg", "stream")
  nigiro_music:setLooping(true)

  gameOver_music = love.audio.newSource("musics/gameOver.ogg", "stream")

  SelectVirusMusic = love.audio.newSource("musics/selectvirus.ogg", "stream")
  SelectVirusMusic:setLooping(true)

  select1 = love.audio.newSource("sounds/select1.wav", "static")
  select2 = love.audio.newSource("sounds/select2.wav","static")
  select3 = love.audio.newSource("sounds/select3.wav","static")
  back = love.audio.newSource("sounds/back.wav","static")

  virusTeleport = love.audio.newSource("sounds/teleport.wav", "static")


  explosion_sound = love.audio.newSource("sounds/explosion_sound.wav", "static")
  explosion_boss = love.audio.newSource("sounds/explosion_boss.wav", "static")
  hit_sound = love.audio.newSource("sounds/hit.wav", "static")
  combo_sound = love.audio.newSource("sounds/combo.wav", "static")
  
  win_music = love.audio.newSource("musics/winboss.ogg", "stream")
  
  vision = love.graphics.newImage("ressources/test111.png")
  visionl = love.graphics.getWidth()
  visionh = love.graphics.getHeight()

  --lvl6Music = love.audio.newSource("musics/lvl6.ogg")
  --lvl6Music:setLooping(true)

  afficheOptions = false
  gameOver = false
  stopTimer = false

  timer = 0
  scanTime = 25
  positioncurseur = 1


  check()



  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  --love.graphics.setColor(255,255,255)
  love.window.setTitle("Ver'Infect")


  love.window.setMode(largeurFenetre,hauteurFenetre, {fullscreen=true, vsync=false,resizable=false, minwidth=800, minheight=600})


  MainMenu()
  --SC()
  --SelectVirus()
  --PremierNiveau()
  --DeuxiemeNiveau()
  --TroisiemeNiveau()


end


function love.update(dt)  
  


    if afficheCredits == true then
     
      credits.developer.y = credits.developer.y - 30 * dt
      credits.developer.name.y = credits.developer.name.y - 30 * dt
      
      credits.designer.y = credits.designer.y - 30 * dt
      credits.designer.name.y = credits.designer.name.y - 30 * dt
      
      credits.musics.y = credits.musics.y - 30 * dt
      credits.musics.name.y = credits.musics.name.y - 30 * dt
      
      credits.specialThanks.y = credits.specialThanks.y - 30 * dt
      credits.specialThanks.name.y = credits.specialThanks.name.y - 30 * dt
      credits.specialThanks.name2.y = credits.specialThanks.name2.y - 30 * dt
      credits.specialThanks.name3.y = credits.specialThanks.name3.y - 30 * dt
      credits.specialThanksPlay.name.y = credits.specialThanksPlay.name.y - 30 * dt
      
      if credits.specialThanksPlay.name.y < -10 then
        MainMenu()
      end
    end
    
  if afficheFin == true or afficheOptions == true or afficheSelectVirus == true or afficheMainMenu == true then

    love.keyboard.setKeyRepeat(true)
  else
    love.keyboard.setKeyRepeat(false)
  end



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
    psystem_explosion_update(dt)
    psystem_explosion_boss_update(dt)
    psystem:update(dt)
    if lvlActuel == 1 then

      love.audio.resume(lvl1Music)

    end

    if animationboss == false then
      if SelectVirusP == "jaune" then
        virus.skins.jaune.power = true
      else
        virus.skins.jaune.power = false
      end
      stopTimer = false
    if SelectVirusP == "rouge" then
      player.speed = virus.skins.rouge.speed
    elseif enableSecret1 == true then
      player.speed = virus.skins.secret1.speed
    else
      player.speed = player.speedActu
    
    end
  elseif animationboss == true then
    stopTimer = true
    blockvirus = true
    player.speed = 0
    virus.skins.jaune.power = false
  end
  

end

if positioncurseurUpgrades == 1 then
  hud.button.upgrades.vitesse.sprite = love.graphics.newImage("ressources/hud/speed_button_select.png")
  hud.button.upgrades.vie.sprite = love.graphics.newImage("ressources/hud/life_button.png")
elseif positioncurseurUpgrades == 2 then
  hud.button.upgrades.vitesse.sprite = love.graphics.newImage("ressources/hud/speed_button.png")
  hud.button.upgrades.vie.sprite = love.graphics.newImage("ressources/hud/life_button_select.png")
elseif positioncurseurUpgrades == 0 then
  positioncurseurUpgrades = 2
elseif positioncurseurUpgrades == 3 then
  positioncurseurUpgrades = 1
end

  if gameOver == true then
    love.audio.stop(lvl1Music)
    love.audio.stop(secret1_musicP)
    love.audio.stop(nigiro_music)
    love.audio.stop(music_miniboss1)
    love.audio.play(gameOver_music)
    
    if SelectVirusP == "originalV" then
      deadSound:setPitch(love.math.random(5,20))
    end


  end



  if afficheMenu == false and afficheMainMenu == false and afficheOptions == false and gameOver == false and afficheSelectVirus == false and afficheClassement == false and afficheFin == false and afficheS == false and afficheCredits == false then 

  if gameOver == false or pause == false then

   if player.blink == true then
      timeBlink = timeBlink - love.timer.getDelta()
      --print(timeBlink)
      -- QUAND ON PERDRA UNE VIE
      if timeBlink > 0.5 then
        player.affiche = false
        if playonce2 == 1 then
          player.life = player.life - 1
          playonce2 = playonce2 - 1
          love.audio.play(Toucher)
          print(player.life)
       end
      elseif timeBlink >= 0.7 and timeBlink < 0.75 then
        player.affiche = true
      elseif timeBlink >= 0.5 and timeBlink < 0.55 then
        player.affiche = false
      
      elseif timeBlink >= 0.3 and timeBlink < 0.35 then
        player.affiche = true
      elseif timeBlink > 0.1 and timeBlink< 0.15 then
      
        player.affiche = false
      elseif timeBlink <= 0 then
        player.affiche = true
        timeBlink = 1
        player.blink = false
        playonce2 = 1
      end
   
    end
  end

  if Niveau == 2 then
    
    if bosslife < 0 then
      pointCompetence = pointCompetence + 1
    end
    
    if bosslife <= 0 then
      
      
      miniboss1.active = false
      bosslife = 0
      miniboss1.start = love.graphics.newImage("ressources/boss/1/dead.png")
      stopTimer = true
      love.audio.stop(music_miniboss1)
      
      animationTime = animationTime + love.timer.getDelta()
      if animationTime >= 0 and animationTime < 3 then
      
      elseif animationTime >= 3 and animationTime < 3.1 then
      
      love.audio.play(explosion_boss)
      bossdead = true
      psystem_explosion_boss_spawn(miniboss1.x+32,miniboss1.y+32)
      elseif animationTime >= 5 then
      love.audio.play(win_music)
      Fin()
      end
    end
    
     if winwrite == "infect" or winwrite == "INFECT" then
       
        winwrite = ""
          if playonce == 1 then
            love.audio.play(explosion_sound)
            love.audio.play(combo_sound)
          
            bosslife = bosslife - 24
            
            playonce = playonce - 1
          end
    
      end
    
    if bossdead == false then
      if ((player.x <= miniboss1.x+miniboss1.l-7) and (miniboss1.x+7 <= player.x+player.l) and (player.y <= miniboss1.y+miniboss1.h-7) and (miniboss1.y+7 <= player.y+player.h)) then
        player.blink = true
       
       end
    end
    secondes = secondes - love.timer.getDelta()
    
   
    
    if animationboss == true then
    animationTime = animationTime + love.timer.getDelta()
      
      if SelectVirusP == "rouge" then 
        
        if animationTime >= 0 and animationTime < 10.5 then
          miniboss1.y = miniboss1.y + miniboss1.speed * dt
        elseif animationTime > 11.5 then
          miniboss1.active = true
          animationboss = false
          paternBoss = math.random(1,3)
          print("Numero du patern du boss : "..paternBoss)
          departY = miniboss1.y
          departX = miniboss1.x
          print("DEPART Y"..departY)
          print("DEPART X"..departX)
          animationTime = 0
        end
      
       
        
      elseif SelectVirusP == "original" or SelectVirusP == "originalV" or SelectVirusP == "jaune" or SelectVirusP == "rose" or SelectVirusP == "TLP" or SelectVirusP == "" then
        if animationTime >= 0 and animationTime < 22 then
          miniboss1.y = miniboss1.y + miniboss1.speed * dt
        elseif animationTime > 23.5 then
          miniboss1.active = true
          animationboss = false
          paternBoss = math.random(1,3)
          print("Numero du patern du boss : "..paternBoss)
          departY = miniboss1.y
          departX = miniboss1.x
          print("DEPART Y"..departY)
          print("DEPART X"..departX)
          animationTime = 0
        end
      end
    end

    if SelectVirusP == "rouge" then  
 
        if miniboss1.active == true then
           if bossVulnerable == true then
            miniboss1.start = love.graphics.newImage("ressources/boss/1/vulnerable.png")
          else
            miniboss1.start = love.graphics.newImage("ressources/boss/1/normal.png")
          end
          
          tempsBoss = tempsBoss + love.timer.getDelta()
          patternTime = patternTime + love.timer.getDelta()
          
          if tempsBoss >= 30 then
            bossVulnerable = true
            else
            bossVulnerable = false
          end

          

          -- PATERN 1 
            if paternBoss == 1 then
              
              if patternTime >= 0 and patternTime < 1 then
                
                miniboss1.speed = 70
                miniboss1.y = miniboss1.y + miniboss1.speed * dt
              
              elseif patternTime >= 1 and patternTime < 1.5 then
              
              elseif patternTime >= 1.5 and patternTime < 2.4 then
                miniboss1.speed = 80
                miniboss1.y = miniboss1.y - miniboss1.speed * dt
              elseif patternTime >= 2.5 and patternTime < 6 then
                miniboss1.chronotir = miniboss1.chronotir - 1
                if miniboss1.chronotir <= 0 then
                  miniboss1.chronotir = 45
                  angle1 = math.angle(miniboss1.x+4,miniboss1.y+4,player.x+8,player.y+8)
                  CreeTir("tower","laser1",miniboss1.x+4,miniboss1.y+4, (200 * math.cos(angle1)* dt) , (200 * math.sin(angle1) * dt)) 
                  
                  angle2 = math.angle(miniboss1.x+60,miniboss1.y+4,player.x+8,player.y+8)
                  CreeTir("tower","laser1",miniboss1.x+60,miniboss1.y+6, (200 * math.cos(angle2)* dt) , (200 * math.sin(angle2) * dt)) 
                  
                  angle3 = math.angle(miniboss1.x+4,miniboss1.y+60,player.x+8,player.y+8)
                  CreeTir("tower","laser1",miniboss1.x+4,miniboss1.y+60, (200 * math.cos(angle3)* dt) , (200 * math.sin(angle3) * dt)) 
                  
                  angle4 = math.angle(miniboss1.x+60,miniboss1.y+60,player.x+8,player.y+8)
                  CreeTir("tower","laser1",miniboss1.x+60,miniboss1.y+60, (200 * math.cos(angle4)* dt) , (200 * math.sin(angle4) * dt)) 
                end
              elseif patternTime >= 6 and patternTime < 7 then
                miniboss1.speed = 115
                miniboss1.x = miniboss1.x + miniboss1.speed * dt
                miniboss1.y = miniboss1.y + miniboss1.speed * dt
              elseif patternTime >= 7 and patternTime < 7.7 then
                miniboss1.speed = 170
                miniboss1.y = miniboss1.y - miniboss1.speed * dt
              elseif patternTime >= 7.7 and patternTime < 9 then
                miniboss1.speed = 170
                miniboss1.x = miniboss1.x - miniboss1.speed * dt
              elseif patternTime >= 9 and patternTime < 9.8 then
                miniboss1.speed = 170
                miniboss1.y = miniboss1.y + miniboss1.speed * dt
              elseif patternTime >= 9.8 and patternTime < 10.7 then
                miniboss1.speed = 115
                miniboss1.x = miniboss1.x + miniboss1.speed * dt
                miniboss1.y = miniboss1.y - miniboss1.speed * dt
                miniboss1.chronotir = miniboss1.chronotir - 1
                if miniboss1.chronotir <= 0 then
                  miniboss1.chronotir = 45
                  angle1 = math.angle(miniboss1.x+4,miniboss1.y+4,player.x+8,player.y+8)
                  CreeTir("tower","laser1",miniboss1.x+4,miniboss1.y+4, (200 * math.cos(angle1)* dt) , (200 * math.sin(angle1) * dt)) 
                  
                  angle2 = math.angle(miniboss1.x+60,miniboss1.y+4,player.x+8,player.y+8)
                  CreeTir("tower","laser1",miniboss1.x+60,miniboss1.y+6, (200 * math.cos(angle2)* dt) , (200 * math.sin(angle2) * dt)) 
                  
                  angle3 = math.angle(miniboss1.x+4,miniboss1.y+60,player.x+8,player.y+8)
                  CreeTir("tower","laser1",miniboss1.x+4,miniboss1.y+60, (200 * math.cos(angle3)* dt) , (200 * math.sin(angle3) * dt)) 
                  
                  angle4 = math.angle(miniboss1.x+60,miniboss1.y+60,player.x+8,player.y+8)
                  CreeTir("tower","laser1",miniboss1.x+60,miniboss1.y+60, (200 * math.cos(angle4)* dt) , (200 * math.sin(angle4) * dt)) 
                end
              elseif patternTime >= 10.7 and patternTime < 11 then
                miniboss1.speed = 115
                miniboss1.y = miniboss1.y - miniboss1.speed * dt
                
              elseif patternTime >= 11 and patternTime < 15.5 then
                miniboss1.chronotir = miniboss1.chronotir - 1
                if miniboss1.chronotir <= 0 then
                  miniboss1.chronotir = 45
                  angle1 = math.angle(miniboss1.x+4,miniboss1.y+4,player.x+8,player.y+8)
                  CreeTir("tower","laser1",miniboss1.x+4,miniboss1.y+4, (200 * math.cos(angle1)* dt) , (200 * math.sin(angle1) * dt)) 
                  
                  angle2 = math.angle(miniboss1.x+60,miniboss1.y+4,player.x+8,player.y+8)
                  CreeTir("tower","laser1",miniboss1.x+60,miniboss1.y+6, (200 * math.cos(angle2)* dt) , (200 * math.sin(angle2) * dt)) 
                  
                  angle3 = math.angle(miniboss1.x+4,miniboss1.y+60,player.x+8,player.y+8)
                  CreeTir("tower","laser1",miniboss1.x+4,miniboss1.y+60, (200 * math.cos(angle3)* dt) , (200 * math.sin(angle3) * dt)) 
                  
                  angle4 = math.angle(miniboss1.x+60,miniboss1.y+60,player.x+8,player.y+8)
                  CreeTir("tower","laser1",miniboss1.x+60,miniboss1.y+60, (200 * math.cos(angle4)* dt) , (200 * math.sin(angle4) * dt)) 
                end
              elseif patternTime >= 15.5 then
                
                if bossVulnerable == false then
                    paternBoss = 3
                  else
                    paternBoss = 4
                  end
                print(paternBoss)
                patternTime = 0
              end
              -- FIN DU PATERN 1
              
              -- PATERN 2
            elseif paternBoss == 2 then
              if patternTime >= 0 and patternTime < 1 then
              
                miniboss1.speed = 70
                miniboss1.y = miniboss1.y + miniboss1.speed * dt
              elseif patternTime >= 1 and patternTime < 1.5 then
                miniboss1.speed = 200
                miniboss1.x = miniboss1.x - miniboss1.speed * dt
              elseif patternTime >= 1.5 and patternTime < 2.5 then
                miniboss1.speed = 100
                miniboss1.y = miniboss1.y - miniboss1.speed * dt
              elseif patternTime >= 2.5 and patternTime < 3.5 then
                miniboss1.speed = 150
                miniboss1.y = miniboss1.y + miniboss1.speed * dt
              elseif patternTime >= 3.5 and patternTime < 3.7 then
                miniboss1.speed = 200
                miniboss1.x = miniboss1.x + miniboss1.speed * dt
              elseif patternTime >= 3.7 and patternTime < 4.7 then
                miniboss1.speed = 150
                miniboss1.y = miniboss1.y - miniboss1.speed * dt
              elseif patternTime >= 4.7 and patternTime < 4.9 then
                miniboss1.speed = 200
                miniboss1.x = miniboss1.x + miniboss1.speed * dt
              elseif patternTime >= 4.9 and patternTime < 5.9 then
                miniboss1.speed = 150
                miniboss1.y = miniboss1.y + miniboss1.speed * dt
              elseif patternTime >= 5.9 and patternTime < 6.2 then
                miniboss1.speed = 200
                miniboss1.x = miniboss1.x + miniboss1.speed * dt
              elseif patternTime >= 6.2 and patternTime < 7.2 then
                miniboss1.speed = 150
                miniboss1.y = miniboss1.y - miniboss1.speed * dt
              elseif patternTime >= 7.2 and patternTime < 7.5 then
                miniboss1.speed = 200
                miniboss1.x = miniboss1.x + miniboss1.speed * dt
              elseif patternTime >= 7.2 and patternTime < 7.5 then
                miniboss1.speed = 200
                miniboss1.x = miniboss1.x + miniboss1.speed * dt
              elseif patternTime >= 8 then
                miniboss1.y = 89.992737559514
                miniboss1.x = 270
         
                if bossVulnerable == false then
                    paternBoss = 1
                  else
                    paternBoss = 4
                  end
                print(paternBoss)
                patternTime = 0
              end
              -- FIN DU PATERN 2
            elseif paternBoss == 3 then
              if patternTime >= 0 and patternTime < 2 then 
            
                miniboss1.speed = 70
                miniboss1.y = miniboss1.y + miniboss1.speed * dt
              elseif patternTime >= 2 and patternTime < 3 then 
                miniboss1.speed = 100
                miniboss1.y = miniboss1.y - miniboss1.speed * dt
              elseif patternTime >= 3 and patternTime < 5 then 
                miniboss1.chronotir = miniboss1.chronotir - 1
                if miniboss1.chronotir <= 0 then
                  miniboss1.chronotir = 300
                  
                  -- HAUT BAS GAUCHE DROITE
                  angle1 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31,miniboss1.y+32)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle1)* dt) , (50 * math.sin(angle1) * dt))
                  
                  angledir1 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31,miniboss1.y+31.6)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledir1)* dt) , (50 * math.sin(angledir1) * dt))
                  
                  angle2 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+33,miniboss1.y+32)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle2)* dt) , (50 * math.sin(angle2) * dt)) 
                 
                  angledir2 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+33,miniboss1.y+32.4)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledir2)* dt) , (50 * math.sin(angledir2) * dt)) 
                
                  angle3 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+32,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle3)* dt) , (50 * math.sin(angle3) * dt)) 
                  
                  angledir3 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31.6,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledir3)* dt) , (50 * math.sin(angledir3) * dt)) 
                  
                  angle4 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+32,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle4)* dt) , (50 * math.sin(angle4) * dt))
                  
                  angledir4 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31.6,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledir4)* dt) , (50 * math.sin(angledir4) * dt))
                  
                  
                  -- DIAGONALE
                  angle5 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle5)* dt) , (50 * math.sin(angle5) * dt)) 
                  
                  angledia1 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+32.5,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledia1)* dt) , (50 * math.sin(angledia1) * dt)) 
                
                  angle6 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+33,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle6)* dt) , (50 * math.sin(angle6) * dt)) 
                  
                  angledia2 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+32.4,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledia2)* dt) , (50 * math.sin(angledia2) * dt)) 
                  
                  angle7 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+33,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle7)* dt) , (50 * math.sin(angle7) * dt)) 
                  
                  angledia3 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+34.5,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledia3)* dt) , (50 * math.sin(angledia3) * dt)) 
                  
                  angle8 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle8)* dt) , (50 * math.sin(angle8) * dt)) 
                  
                  angledia4 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+29.5,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledia4)* dt) , (50 * math.sin(angledia4) * dt)) 
                  
                end
              elseif patternTime >= 5 and patternTime < 5.1 then
                miniboss1.speed = 300
                miniboss1.x = miniboss1.x + miniboss1.speed * dt 
                miniboss1.y = miniboss1.y + miniboss1.speed * dt 
              elseif patternTime >= 5.1 and patternTime < 7 then
                miniboss1.chronotir = miniboss1.chronotir - 1
                if miniboss1.chronotir <= 0 then
                  miniboss1.chronotir = 300
                  
                  -- HAUT BAS GAUCHE DROITE
                  angle1 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31,miniboss1.y+32)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle1)* dt) , (50 * math.sin(angle1) * dt))
                  
                  angledir1 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31,miniboss1.y+31.6)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledir1)* dt) , (50 * math.sin(angledir1) * dt))
                  
                  angle2 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+33,miniboss1.y+32)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle2)* dt) , (50 * math.sin(angle2) * dt)) 
                 
                  angledir2 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+33,miniboss1.y+32.4)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledir2)* dt) , (50 * math.sin(angledir2) * dt)) 
                
                  angle3 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+32,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle3)* dt) , (50 * math.sin(angle3) * dt)) 
                  
                  angledir3 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31.6,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledir3)* dt) , (50 * math.sin(angledir3) * dt)) 
                  
                  angle4 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+32,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle4)* dt) , (50 * math.sin(angle4) * dt))
                  
                  angledir4 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31.6,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledir4)* dt) , (50 * math.sin(angledir4) * dt))
                  
                  
                  -- DIAGONALE
                  angle5 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle5)* dt) , (50 * math.sin(angle5) * dt)) 
                  
                  angledia1 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+32.5,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledia1)* dt) , (50 * math.sin(angledia1) * dt)) 
                
                  angle6 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+33,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle6)* dt) , (50 * math.sin(angle6) * dt)) 
                  
                  angledia2 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+32.4,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledia2)* dt) , (50 * math.sin(angledia2) * dt)) 
                  
                  angle7 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+33,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle7)* dt) , (50 * math.sin(angle7) * dt)) 
                  
                  angledia3 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+34.5,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledia3)* dt) , (50 * math.sin(angledia3) * dt)) 
                  
                  angle8 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle8)* dt) , (50 * math.sin(angle8) * dt)) 
                  
                  angledia4 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+29.5,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledia4)* dt) , (50 * math.sin(angledia4) * dt)) 
                  
                end
              elseif patternTime >= 7 and patternTime < 7.1 then
                miniboss1.speed = 330
                miniboss1.x = miniboss1.x - miniboss1.speed * dt 
                miniboss1.y = miniboss1.y - miniboss1.speed * dt
              elseif patternTime >= 7.1 and patternTime < 9.1 then
                miniboss1.chronotir = miniboss1.chronotir - 1
                if miniboss1.chronotir <= 0 then
                  miniboss1.chronotir = 300
                  
                  -- HAUT BAS GAUCHE DROITE
                  angle1 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31,miniboss1.y+32)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle1)* dt) , (50 * math.sin(angle1) * dt))
                  
                  angledir1 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31,miniboss1.y+31.6)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledir1)* dt) , (50 * math.sin(angledir1) * dt))
                  
                  angle2 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+33,miniboss1.y+32)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle2)* dt) , (50 * math.sin(angle2) * dt)) 
                 
                  angledir2 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+33,miniboss1.y+32.4)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledir2)* dt) , (50 * math.sin(angledir2) * dt)) 
                
                  angle3 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+32,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle3)* dt) , (50 * math.sin(angle3) * dt)) 
                  
                  angledir3 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31.6,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledir3)* dt) , (50 * math.sin(angledir3) * dt)) 
                  
                  angle4 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+32,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle4)* dt) , (50 * math.sin(angle4) * dt))
                  
                  angledir4 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31.6,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledir4)* dt) , (50 * math.sin(angledir4) * dt))
                  
                  
                  -- DIAGONALE
                  angle5 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle5)* dt) , (50 * math.sin(angle5) * dt)) 
                  
                  angledia1 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+32.5,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledia1)* dt) , (50 * math.sin(angledia1) * dt)) 
                
                  angle6 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+33,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle6)* dt) , (50 * math.sin(angle6) * dt)) 
                  
                  angledia2 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+32.4,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledia2)* dt) , (50 * math.sin(angledia2) * dt)) 
                  
                  angle7 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+33,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle7)* dt) , (50 * math.sin(angle7) * dt)) 
                  
                  angledia3 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+34.5,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledia3)* dt) , (50 * math.sin(angledia3) * dt)) 
                  
                  angle8 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle8)* dt) , (50 * math.sin(angle8) * dt)) 
                  
                  angledia4 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+29.5,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledia4)* dt) , (50 * math.sin(angledia4) * dt)) 
                  
                end
              elseif patternTime >= 9.1 then
                miniboss1.y = 89.992737559514
                miniboss1.x = 270
         
                  if bossVulnerable == false then
                    paternBoss = 2
                  else
                    paternBoss = 4
                  end
                print(paternBoss)
                patternTime = 0
              end
            elseif paternBoss == 4 then
              if patternTime >= 0 and patternTime < 2 then 
        
                miniboss1.speed = 70
                miniboss1.y = miniboss1.y + miniboss1.speed * dt
              elseif patternTime >= 2 and patternTime < 3 then 
                miniboss1.speed = 70
                miniboss1.y = miniboss1.y - miniboss1.speed * dt
              elseif patternTime >= 3 and patternTime < 5 then 
                miniboss1.chronotir = miniboss1.chronotir - 1
                miniboss1.chronotir2 = miniboss1.chronotir2 - 1
                
                if miniboss1.chronotir2 <= 0 then
                  miniboss1.chronotir2 = 45
                  angle10 = math.angle(miniboss1.x+4,miniboss1.y+4,player.x+8,player.y+8)
                  CreeTir("tower","laser1",miniboss1.x+4,miniboss1.y+4, (200 * math.cos(angle10)* dt) , (200 * math.sin(angle10) * dt)) 
                  
                  angle20 = math.angle(miniboss1.x+60,miniboss1.y+4,player.x+8,player.y+8)
                  CreeTir("tower","laser1",miniboss1.x+60,miniboss1.y+6, (200 * math.cos(angle20)* dt) , (200 * math.sin(angle20) * dt)) 
                  
                  angle30 = math.angle(miniboss1.x+4,miniboss1.y+60,player.x+8,player.y+8)
                  CreeTir("tower","laser1",miniboss1.x+4,miniboss1.y+60, (200 * math.cos(angle30)* dt) , (200 * math.sin(angle30) * dt)) 
                  
                  angle40 = math.angle(miniboss1.x+60,miniboss1.y+60,player.x+8,player.y+8)
                  CreeTir("tower","laser1",miniboss1.x+60,miniboss1.y+60, (200 * math.cos(angle40)* dt) , (200 * math.sin(angle40) * dt)) 
                end
                
                if miniboss1.chronotir <= 0 then
                  miniboss1.chronotir = 235
                  
                  -- HAUT BAS GAUCHE DROITE
                  angle1 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31,miniboss1.y+32)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle1)* dt) , (50 * math.sin(angle1) * dt))
                  
                  angledir1 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31,miniboss1.y+31.6)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledir1)* dt) , (50 * math.sin(angledir1) * dt))
                  
                  angle2 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+33,miniboss1.y+32)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle2)* dt) , (50 * math.sin(angle2) * dt)) 
                 
                  angledir2 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+33,miniboss1.y+32.4)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledir2)* dt) , (50 * math.sin(angledir2) * dt)) 
                
                  angle3 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+32,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle3)* dt) , (50 * math.sin(angle3) * dt)) 
                  
                  angledir3 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31.6,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledir3)* dt) , (50 * math.sin(angledir3) * dt)) 
                  
                  angle4 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+32,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle4)* dt) , (50 * math.sin(angle4) * dt))
                  
                  angledir4 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31.6,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledir4)* dt) , (50 * math.sin(angledir4) * dt))
                  
                  
                  -- DIAGONALE
                  angle5 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle5)* dt) , (50 * math.sin(angle5) * dt)) 
                  
                  angledia1 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+32.5,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledia1)* dt) , (50 * math.sin(angledia1) * dt)) 
                
                  angle6 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+33,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle6)* dt) , (50 * math.sin(angle6) * dt)) 
                  
                  angledia2 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+32.4,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledia2)* dt) , (50 * math.sin(angledia2) * dt)) 
                  
                  angle7 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+33,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle7)* dt) , (50 * math.sin(angle7) * dt)) 
                  
                  angledia3 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+34.5,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledia3)* dt) , (50 * math.sin(angledia3) * dt)) 
                  
                  angle8 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle8)* dt) , (50 * math.sin(angle8) * dt)) 
                  
                  angledia4 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+29.5,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledia4)* dt) , (50 * math.sin(angledia4) * dt)) 
                  
                end
              elseif patternTime >= 6.5 then
                paternBoss = 5
                patternTime = 0
              end
            elseif paternBoss == 5 then
              if patternTime >= 0 and patternTime < 2 then 
              miniboss1.chronotir = miniboss1.chronotir - 1
                miniboss1.chronotir2 = miniboss1.chronotir2 - 1
                
                if miniboss1.chronotir2 <= 0 then
                  miniboss1.chronotir2 = 45
                  angle10 = math.angle(miniboss1.x+4,miniboss1.y+4,player.x+8,player.y+8)
                  CreeTir("tower","laser1",miniboss1.x+4,miniboss1.y+4, (200 * math.cos(angle10)* dt) , (200 * math.sin(angle10) * dt)) 
                  
                  angle20 = math.angle(miniboss1.x+60,miniboss1.y+4,player.x+8,player.y+8)
                  CreeTir("tower","laser1",miniboss1.x+60,miniboss1.y+6, (200 * math.cos(angle20)* dt) , (200 * math.sin(angle20) * dt)) 
                  
                  angle30 = math.angle(miniboss1.x+4,miniboss1.y+60,player.x+8,player.y+8)
                  CreeTir("tower","laser1",miniboss1.x+4,miniboss1.y+60, (200 * math.cos(angle30)* dt) , (200 * math.sin(angle30) * dt)) 
                  
                  angle40 = math.angle(miniboss1.x+60,miniboss1.y+60,player.x+8,player.y+8)
                  CreeTir("tower","laser1",miniboss1.x+60,miniboss1.y+60, (200 * math.cos(angle40)* dt) , (200 * math.sin(angle40) * dt)) 
                end
                
                if miniboss1.chronotir <= 0 then
                  miniboss1.chronotir = 235
                  
                  -- HAUT BAS GAUCHE DROITE
                  angle1 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31,miniboss1.y+32)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle1)* dt) , (50 * math.sin(angle1) * dt))
                  
                  angledir1 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31,miniboss1.y+31.6)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledir1)* dt) , (50 * math.sin(angledir1) * dt))
                  
                  angle2 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+33,miniboss1.y+32)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle2)* dt) , (50 * math.sin(angle2) * dt)) 
                 
                  angledir2 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+33,miniboss1.y+32.4)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledir2)* dt) , (50 * math.sin(angledir2) * dt)) 
                
                  angle3 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+32,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle3)* dt) , (50 * math.sin(angle3) * dt)) 
                  
                  angledir3 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31.6,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledir3)* dt) , (50 * math.sin(angledir3) * dt)) 
                  
                  angle4 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+32,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle4)* dt) , (50 * math.sin(angle4) * dt))
                  
                  angledir4 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31.6,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledir4)* dt) , (50 * math.sin(angledir4) * dt))
                  
                  
                  -- DIAGONALE
                  angle5 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle5)* dt) , (50 * math.sin(angle5) * dt)) 
                  
                  angledia1 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+32.5,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledia1)* dt) , (50 * math.sin(angledia1) * dt)) 
                
                  angle6 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+33,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle6)* dt) , (50 * math.sin(angle6) * dt)) 
                  
                  angledia2 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+32.4,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledia2)* dt) , (50 * math.sin(angledia2) * dt)) 
                  
                  angle7 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+33,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle7)* dt) , (50 * math.sin(angle7) * dt)) 
                  
                  angledia3 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+34.5,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledia3)* dt) , (50 * math.sin(angledia3) * dt)) 
                  
                  angle8 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle8)* dt) , (50 * math.sin(angle8) * dt)) 
                  
                  angledia4 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+29.5,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledia4)* dt) , (50 * math.sin(angledia4) * dt)) 
                end
              elseif patternTime >= 3.5 then
                paternBoss = 5
                patternTime = 0
              end
            end
        end
        
    elseif SelectVirusP == "originalV" or SelectVirusP == "original" or SelectVirusP == "jaune" or SelectVirusP == "rose" or SelectVirusP == "TLP" then  
 
        if miniboss1.active == true then
          
           if bossVulnerable == true then
            miniboss1.start = love.graphics.newImage("ressources/boss/1/vulnerable.png")
          else
            miniboss1.start = love.graphics.newImage("ressources/boss/1/normal.png")
          end
          
          tempsBoss = tempsBoss + love.timer.getDelta()
          patternTime = patternTime + love.timer.getDelta()
          
          if tempsBoss >= 30 then
            bossVulnerable = true
            else
            bossVulnerable = false
          end

          

          -- PATERN 1 
            if paternBoss == 1 then
              
              if patternTime >= 0 and patternTime < 1 then
                
                miniboss1.speed = 70
                miniboss1.y = miniboss1.y + miniboss1.speed * dt
              
              elseif patternTime >= 1 and patternTime < 1.5 then
              
            elseif patternTime >= 1.5 and patternTime < 2.4 then
              
                miniboss1.speed = 80
                miniboss1.y = miniboss1.y - miniboss1.speed * dt
              elseif patternTime >= 2.5 and patternTime < 6 then
                miniboss1.chronotir = miniboss1.chronotir - 1
                if miniboss1.chronotir <= 0 then
                  miniboss1.chronotir = 45
                  angle1 = math.angle(miniboss1.x+4,miniboss1.y+4,player.x+8,player.y+8)
                  CreeTir("tower","laser1",miniboss1.x+4,miniboss1.y+4, (200 * math.cos(angle1)* dt) , (200 * math.sin(angle1) * dt)) 
                  
                  angle2 = math.angle(miniboss1.x+60,miniboss1.y+4,player.x+8,player.y+8)
                  CreeTir("tower","laser1",miniboss1.x+60,miniboss1.y+6, (200 * math.cos(angle2)* dt) , (200 * math.sin(angle2) * dt)) 
                  
                  angle3 = math.angle(miniboss1.x+4,miniboss1.y+60,player.x+8,player.y+8)
                  CreeTir("tower","laser1",miniboss1.x+4,miniboss1.y+60, (200 * math.cos(angle3)* dt) , (200 * math.sin(angle3) * dt)) 
                  
                  angle4 = math.angle(miniboss1.x+60,miniboss1.y+60,player.x+8,player.y+8)
                  CreeTir("tower","laser1",miniboss1.x+60,miniboss1.y+60, (200 * math.cos(angle4)* dt) , (200 * math.sin(angle4) * dt)) 
                end
              elseif patternTime >= 6 and patternTime < 7 then
                miniboss1.speed = 115
                miniboss1.x = miniboss1.x + miniboss1.speed * dt
                miniboss1.y = miniboss1.y + miniboss1.speed * dt
              elseif patternTime >= 7 and patternTime < 7.7 then
                miniboss1.speed = 170
                miniboss1.y = miniboss1.y - miniboss1.speed * dt
              elseif patternTime >= 7.7 and patternTime < 9 then
                miniboss1.speed = 170
                miniboss1.x = miniboss1.x - miniboss1.speed * dt
              elseif patternTime >= 9 and patternTime < 9.8 then
                miniboss1.speed = 170
                miniboss1.y = miniboss1.y + miniboss1.speed * dt
              elseif patternTime >= 9.8 and patternTime < 10.7 then
                miniboss1.speed = 115
                miniboss1.x = miniboss1.x + miniboss1.speed * dt
                miniboss1.y = miniboss1.y - miniboss1.speed * dt
                miniboss1.chronotir = miniboss1.chronotir - 1
                if miniboss1.chronotir <= 0 then
                  miniboss1.chronotir = 45
                  angle1 = math.angle(miniboss1.x+4,miniboss1.y+4,player.x+8,player.y+8)
                  CreeTir("tower","laser1",miniboss1.x+4,miniboss1.y+4, (200 * math.cos(angle1)* dt) , (200 * math.sin(angle1) * dt)) 
                  
                  angle2 = math.angle(miniboss1.x+60,miniboss1.y+4,player.x+8,player.y+8)
                  CreeTir("tower","laser1",miniboss1.x+60,miniboss1.y+6, (200 * math.cos(angle2)* dt) , (200 * math.sin(angle2) * dt)) 
                  
                  angle3 = math.angle(miniboss1.x+4,miniboss1.y+60,player.x+8,player.y+8)
                  CreeTir("tower","laser1",miniboss1.x+4,miniboss1.y+60, (200 * math.cos(angle3)* dt) , (200 * math.sin(angle3) * dt)) 
                  
                  angle4 = math.angle(miniboss1.x+60,miniboss1.y+60,player.x+8,player.y+8)
                  CreeTir("tower","laser1",miniboss1.x+60,miniboss1.y+60, (200 * math.cos(angle4)* dt) , (200 * math.sin(angle4) * dt)) 
                end
              elseif patternTime >= 10.7 and patternTime < 11 then
                miniboss1.speed = 115
                miniboss1.y = miniboss1.y - miniboss1.speed * dt
                
              elseif patternTime >= 11 and patternTime < 15.5 then
                miniboss1.chronotir = miniboss1.chronotir - 1
                if miniboss1.chronotir <= 0 then
                  miniboss1.chronotir = 45
                  angle1 = math.angle(miniboss1.x+4,miniboss1.y+4,player.x+8,player.y+8)
                  CreeTir("tower","laser1",miniboss1.x+4,miniboss1.y+4, (200 * math.cos(angle1)* dt) , (200 * math.sin(angle1) * dt)) 
                  
                  angle2 = math.angle(miniboss1.x+60,miniboss1.y+4,player.x+8,player.y+8)
                  CreeTir("tower","laser1",miniboss1.x+60,miniboss1.y+6, (200 * math.cos(angle2)* dt) , (200 * math.sin(angle2) * dt)) 
                  
                  angle3 = math.angle(miniboss1.x+4,miniboss1.y+60,player.x+8,player.y+8)
                  CreeTir("tower","laser1",miniboss1.x+4,miniboss1.y+60, (200 * math.cos(angle3)* dt) , (200 * math.sin(angle3) * dt)) 
                  
                  angle4 = math.angle(miniboss1.x+60,miniboss1.y+60,player.x+8,player.y+8)
                  CreeTir("tower","laser1",miniboss1.x+60,miniboss1.y+60, (200 * math.cos(angle4)* dt) , (200 * math.sin(angle4) * dt)) 
                end
              elseif patternTime >= 15.5 then
                
                if bossVulnerable == false then
                    paternBoss = 3
                  else
                    paternBoss = 4
                  end
                print(paternBoss)
                patternTime = 0
              end
              -- FIN DU PATERN 1
              
              -- PATERN 2
            elseif paternBoss == 2 then
              if patternTime >= 0 and patternTime < 1 then
              
                miniboss1.speed = 70
                miniboss1.y = miniboss1.y + miniboss1.speed * dt
              elseif patternTime >= 1 and patternTime < 1.5 then
                miniboss1.speed = 200
                miniboss1.x = miniboss1.x - miniboss1.speed * dt
              elseif patternTime >= 1.5 and patternTime < 2.5 then
                miniboss1.speed = 100
                miniboss1.y = miniboss1.y - miniboss1.speed * dt
              elseif patternTime >= 2.5 and patternTime < 3.5 then
                miniboss1.speed = 150
                miniboss1.y = miniboss1.y + miniboss1.speed * dt
              elseif patternTime >= 3.5 and patternTime < 3.7 then
                miniboss1.speed = 200
                miniboss1.x = miniboss1.x + miniboss1.speed * dt
              elseif patternTime >= 3.7 and patternTime < 4.7 then
                miniboss1.speed = 150
                miniboss1.y = miniboss1.y - miniboss1.speed * dt
              elseif patternTime >= 4.7 and patternTime < 4.9 then
                miniboss1.speed = 200
                miniboss1.x = miniboss1.x + miniboss1.speed * dt
              elseif patternTime >= 4.9 and patternTime < 5.9 then
                miniboss1.speed = 150
                miniboss1.y = miniboss1.y + miniboss1.speed * dt
              elseif patternTime >= 5.9 and patternTime < 6.2 then
                miniboss1.speed = 200
                miniboss1.x = miniboss1.x + miniboss1.speed * dt
              elseif patternTime >= 6.2 and patternTime < 7.2 then
                miniboss1.speed = 150
                miniboss1.y = miniboss1.y - miniboss1.speed * dt
              elseif patternTime >= 7.2 and patternTime < 7.5 then
                miniboss1.speed = 200
                miniboss1.x = miniboss1.x + miniboss1.speed * dt
              elseif patternTime >= 7.2 and patternTime < 7.5 then
                miniboss1.speed = 200
                miniboss1.x = miniboss1.x + miniboss1.speed * dt
              elseif patternTime >= 8 then
                miniboss1.y = 89.992737559514
                miniboss1.x = 270
         
                if bossVulnerable == false then
                    paternBoss = 1
                  else
                    paternBoss = 4
                  end
                print(paternBoss)
                patternTime = 0
              end
              -- FIN DU PATERN 2
            elseif paternBoss == 3 then
              if patternTime >= 0 and patternTime < 2 then 
            
                miniboss1.speed = 70
                miniboss1.y = miniboss1.y + miniboss1.speed * dt
              elseif patternTime >= 2 and patternTime < 3 then 
                miniboss1.speed = 100
                miniboss1.y = miniboss1.y - miniboss1.speed * dt
              elseif patternTime >= 3 and patternTime < 5 then 
                miniboss1.chronotir = miniboss1.chronotir - 1
                if miniboss1.chronotir <= 0 then
                  miniboss1.chronotir = 300
                  
                  -- HAUT BAS GAUCHE DROITE
                  angle1 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31,miniboss1.y+32)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle1)* dt) , (50 * math.sin(angle1) * dt))
                  
                  angledir1 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31,miniboss1.y+31.6)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledir1)* dt) , (50 * math.sin(angledir1) * dt))
                  
                  angle2 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+33,miniboss1.y+32)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle2)* dt) , (50 * math.sin(angle2) * dt)) 
                 
                  angledir2 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+33,miniboss1.y+32.4)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledir2)* dt) , (50 * math.sin(angledir2) * dt)) 
                
                  angle3 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+32,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle3)* dt) , (50 * math.sin(angle3) * dt)) 
                  
                  angledir3 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31.6,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledir3)* dt) , (50 * math.sin(angledir3) * dt)) 
                  
                  angle4 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+32,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle4)* dt) , (50 * math.sin(angle4) * dt))
                  
                  angledir4 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31.6,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledir4)* dt) , (50 * math.sin(angledir4) * dt))
                  
                  
                  -- DIAGONALE
                  angle5 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle5)* dt) , (50 * math.sin(angle5) * dt)) 
                  
                  angledia1 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+32.5,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledia1)* dt) , (50 * math.sin(angledia1) * dt)) 
                
                  angle6 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+33,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle6)* dt) , (50 * math.sin(angle6) * dt)) 
                  
                  angledia2 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+32.4,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledia2)* dt) , (50 * math.sin(angledia2) * dt)) 
                  
                  angle7 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+33,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle7)* dt) , (50 * math.sin(angle7) * dt)) 
                  
                  angledia3 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+34.5,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledia3)* dt) , (50 * math.sin(angledia3) * dt)) 
                  
                  angle8 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle8)* dt) , (50 * math.sin(angle8) * dt)) 
                  
                  angledia4 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+29.5,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledia4)* dt) , (50 * math.sin(angledia4) * dt)) 
                  
                end
              elseif patternTime >= 5 and patternTime < 5.1 then
                miniboss1.speed = 300
                miniboss1.x = miniboss1.x + miniboss1.speed * dt 
                miniboss1.y = miniboss1.y + miniboss1.speed * dt 
              elseif patternTime >= 5.1 and patternTime < 7 then
                miniboss1.chronotir = miniboss1.chronotir - 1
                if miniboss1.chronotir <= 0 then
                  miniboss1.chronotir = 300
                  
                  -- HAUT BAS GAUCHE DROITE
                  angle1 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31,miniboss1.y+32)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle1)* dt) , (50 * math.sin(angle1) * dt))
                  
                  angledir1 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31,miniboss1.y+31.6)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledir1)* dt) , (50 * math.sin(angledir1) * dt))
                  
                  angle2 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+33,miniboss1.y+32)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle2)* dt) , (50 * math.sin(angle2) * dt)) 
                 
                  angledir2 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+33,miniboss1.y+32.4)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledir2)* dt) , (50 * math.sin(angledir2) * dt)) 
                
                  angle3 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+32,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle3)* dt) , (50 * math.sin(angle3) * dt)) 
                  
                  angledir3 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31.6,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledir3)* dt) , (50 * math.sin(angledir3) * dt)) 
                  
                  angle4 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+32,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle4)* dt) , (50 * math.sin(angle4) * dt))
                  
                  angledir4 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31.6,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledir4)* dt) , (50 * math.sin(angledir4) * dt))
                  
                  
                  -- DIAGONALE
                  angle5 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle5)* dt) , (50 * math.sin(angle5) * dt)) 
                  
                  angledia1 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+32.5,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledia1)* dt) , (50 * math.sin(angledia1) * dt)) 
                
                  angle6 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+33,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle6)* dt) , (50 * math.sin(angle6) * dt)) 
                  
                  angledia2 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+32.4,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledia2)* dt) , (50 * math.sin(angledia2) * dt)) 
                  
                  angle7 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+33,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle7)* dt) , (50 * math.sin(angle7) * dt)) 
                  
                  angledia3 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+34.5,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledia3)* dt) , (50 * math.sin(angledia3) * dt)) 
                  
                  angle8 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle8)* dt) , (50 * math.sin(angle8) * dt)) 
                  
                  angledia4 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+29.5,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledia4)* dt) , (50 * math.sin(angledia4) * dt)) 
                  
                end
              elseif patternTime >= 7 and patternTime < 7.1 then
                miniboss1.speed = 330
                miniboss1.x = miniboss1.x - miniboss1.speed * dt 
                miniboss1.y = miniboss1.y - miniboss1.speed * dt
              elseif patternTime >= 7.1 and patternTime < 9.1 then
                miniboss1.chronotir = miniboss1.chronotir - 1
                if miniboss1.chronotir <= 0 then
                  miniboss1.chronotir = 300
                  
                  -- HAUT BAS GAUCHE DROITE
                  angle1 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31,miniboss1.y+32)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle1)* dt) , (50 * math.sin(angle1) * dt))
                  
                  angledir1 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31,miniboss1.y+31.6)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledir1)* dt) , (50 * math.sin(angledir1) * dt))
                  
                  angle2 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+33,miniboss1.y+32)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle2)* dt) , (50 * math.sin(angle2) * dt)) 
                 
                  angledir2 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+33,miniboss1.y+32.4)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledir2)* dt) , (50 * math.sin(angledir2) * dt)) 
                
                  angle3 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+32,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle3)* dt) , (50 * math.sin(angle3) * dt)) 
                  
                  angledir3 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31.6,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledir3)* dt) , (50 * math.sin(angledir3) * dt)) 
                  
                  angle4 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+32,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle4)* dt) , (50 * math.sin(angle4) * dt))
                  
                  angledir4 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31.6,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledir4)* dt) , (50 * math.sin(angledir4) * dt))
                  
                  
                  -- DIAGONALE
                  angle5 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle5)* dt) , (50 * math.sin(angle5) * dt)) 
                  
                  angledia1 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+32.5,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledia1)* dt) , (50 * math.sin(angledia1) * dt)) 
                
                  angle6 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+33,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle6)* dt) , (50 * math.sin(angle6) * dt)) 
                  
                  angledia2 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+32.4,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledia2)* dt) , (50 * math.sin(angledia2) * dt)) 
                  
                  angle7 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+33,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle7)* dt) , (50 * math.sin(angle7) * dt)) 
                  
                  angledia3 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+34.5,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledia3)* dt) , (50 * math.sin(angledia3) * dt)) 
                  
                  angle8 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle8)* dt) , (50 * math.sin(angle8) * dt)) 
                  
                  angledia4 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+29.5,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledia4)* dt) , (50 * math.sin(angledia4) * dt)) 
                  
                end
              elseif patternTime >= 9.1 then
                miniboss1.y = 89.992737559514
                miniboss1.x = 270
         
                  if bossVulnerable == false then
                    paternBoss = 2
                  else
                    paternBoss = 4
                  end
                print(paternBoss)
                patternTime = 0
              end
            elseif paternBoss == 4 then
              if patternTime >= 0 and patternTime < 2 then 
        
                miniboss1.speed = 70
                miniboss1.y = miniboss1.y + miniboss1.speed * dt
              elseif patternTime >= 2 and patternTime < 3 then 
                miniboss1.speed = 70
                miniboss1.y = miniboss1.y - miniboss1.speed * dt
              elseif patternTime >= 3 and patternTime < 5 then 
                miniboss1.chronotir = miniboss1.chronotir - 1
                miniboss1.chronotir2 = miniboss1.chronotir2 - 1
                
                if miniboss1.chronotir2 <= 0 then
                  miniboss1.chronotir2 = 45
                  angle10 = math.angle(miniboss1.x+4,miniboss1.y+4,player.x+8,player.y+8)
                  CreeTir("tower","laser1",miniboss1.x+4,miniboss1.y+4, (200 * math.cos(angle10)* dt) , (200 * math.sin(angle10) * dt)) 
                  
                  angle20 = math.angle(miniboss1.x+60,miniboss1.y+4,player.x+8,player.y+8)
                  CreeTir("tower","laser1",miniboss1.x+60,miniboss1.y+6, (200 * math.cos(angle20)* dt) , (200 * math.sin(angle20) * dt)) 
                  
                  angle30 = math.angle(miniboss1.x+4,miniboss1.y+60,player.x+8,player.y+8)
                  CreeTir("tower","laser1",miniboss1.x+4,miniboss1.y+60, (200 * math.cos(angle30)* dt) , (200 * math.sin(angle30) * dt)) 
                  
                  angle40 = math.angle(miniboss1.x+60,miniboss1.y+60,player.x+8,player.y+8)
                  CreeTir("tower","laser1",miniboss1.x+60,miniboss1.y+60, (200 * math.cos(angle40)* dt) , (200 * math.sin(angle40) * dt)) 
                end
                
                if miniboss1.chronotir <= 0 then
                  miniboss1.chronotir = 235
                  
                  -- HAUT BAS GAUCHE DROITE
                  angle1 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31,miniboss1.y+32)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle1)* dt) , (50 * math.sin(angle1) * dt))
                  
                  angledir1 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31,miniboss1.y+31.6)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledir1)* dt) , (50 * math.sin(angledir1) * dt))
                  
                  angle2 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+33,miniboss1.y+32)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle2)* dt) , (50 * math.sin(angle2) * dt)) 
                 
                  angledir2 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+33,miniboss1.y+32.4)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledir2)* dt) , (50 * math.sin(angledir2) * dt)) 
                
                  angle3 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+32,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle3)* dt) , (50 * math.sin(angle3) * dt)) 
                  
                  angledir3 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31.6,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledir3)* dt) , (50 * math.sin(angledir3) * dt)) 
                  
                  angle4 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+32,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle4)* dt) , (50 * math.sin(angle4) * dt))
                  
                  angledir4 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31.6,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledir4)* dt) , (50 * math.sin(angledir4) * dt))
                  
                  
                  -- DIAGONALE
                  angle5 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle5)* dt) , (50 * math.sin(angle5) * dt)) 
                  
                  angledia1 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+32.5,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledia1)* dt) , (50 * math.sin(angledia1) * dt)) 
                
                  angle6 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+33,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle6)* dt) , (50 * math.sin(angle6) * dt)) 
                  
                  angledia2 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+32.4,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledia2)* dt) , (50 * math.sin(angledia2) * dt)) 
                  
                  angle7 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+33,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle7)* dt) , (50 * math.sin(angle7) * dt)) 
                  
                  angledia3 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+34.5,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledia3)* dt) , (50 * math.sin(angledia3) * dt)) 
                  
                  angle8 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle8)* dt) , (50 * math.sin(angle8) * dt)) 
                  
                  angledia4 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+29.5,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledia4)* dt) , (50 * math.sin(angledia4) * dt)) 
                  
                end
              elseif patternTime >= 6.5 then
                paternBoss = 5
                patternTime = 0
              end
            elseif paternBoss == 5 then
              if patternTime >= 0 and patternTime < 2 then 
              miniboss1.chronotir = miniboss1.chronotir - 1
                miniboss1.chronotir2 = miniboss1.chronotir2 - 1
                
                if miniboss1.chronotir2 <= 0 then
                  miniboss1.chronotir2 = 45
                  angle10 = math.angle(miniboss1.x+4,miniboss1.y+4,player.x+8,player.y+8)
                  CreeTir("tower","laser1",miniboss1.x+4,miniboss1.y+4, (200 * math.cos(angle10)* dt) , (200 * math.sin(angle10) * dt)) 
                  
                  angle20 = math.angle(miniboss1.x+60,miniboss1.y+4,player.x+8,player.y+8)
                  CreeTir("tower","laser1",miniboss1.x+60,miniboss1.y+6, (200 * math.cos(angle20)* dt) , (200 * math.sin(angle20) * dt)) 
                  
                  angle30 = math.angle(miniboss1.x+4,miniboss1.y+60,player.x+8,player.y+8)
                  CreeTir("tower","laser1",miniboss1.x+4,miniboss1.y+60, (200 * math.cos(angle30)* dt) , (200 * math.sin(angle30) * dt)) 
                  
                  angle40 = math.angle(miniboss1.x+60,miniboss1.y+60,player.x+8,player.y+8)
                  CreeTir("tower","laser1",miniboss1.x+60,miniboss1.y+60, (200 * math.cos(angle40)* dt) , (200 * math.sin(angle40) * dt)) 
                end
                
                if miniboss1.chronotir <= 0 then
                  miniboss1.chronotir = 235
                  
                  -- HAUT BAS GAUCHE DROITE
                  angle1 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31,miniboss1.y+32)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle1)* dt) , (50 * math.sin(angle1) * dt))
                  
                  angledir1 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31,miniboss1.y+31.6)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledir1)* dt) , (50 * math.sin(angledir1) * dt))
                  
                  angle2 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+33,miniboss1.y+32)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle2)* dt) , (50 * math.sin(angle2) * dt)) 
                 
                  angledir2 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+33,miniboss1.y+32.4)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledir2)* dt) , (50 * math.sin(angledir2) * dt)) 
                
                  angle3 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+32,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle3)* dt) , (50 * math.sin(angle3) * dt)) 
                  
                  angledir3 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31.6,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledir3)* dt) , (50 * math.sin(angledir3) * dt)) 
                  
                  angle4 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+32,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle4)* dt) , (50 * math.sin(angle4) * dt))
                  
                  angledir4 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31.6,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledir4)* dt) , (50 * math.sin(angledir4) * dt))
                  
                  
                  -- DIAGONALE
                  angle5 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle5)* dt) , (50 * math.sin(angle5) * dt)) 
                  
                  angledia1 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+32.5,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledia1)* dt) , (50 * math.sin(angledia1) * dt)) 
                
                  angle6 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+33,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle6)* dt) , (50 * math.sin(angle6) * dt)) 
                  
                  angledia2 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+32.4,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledia2)* dt) , (50 * math.sin(angledia2) * dt)) 
                  
                  angle7 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+33,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle7)* dt) , (50 * math.sin(angle7) * dt)) 
                  
                  angledia3 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+34.5,miniboss1.y+31)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledia3)* dt) , (50 * math.sin(angledia3) * dt)) 
                  
                  angle8 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+31,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angle8)* dt) , (50 * math.sin(angle8) * dt)) 
                  
                  angledia4 = math.angle(miniboss1.x+32,miniboss1.y+32,miniboss1.x+29.5,miniboss1.y+33)
                  CreeTir("tower","laser1",miniboss1.x+32,miniboss1.y+32, (50 * math.cos(angledia4)* dt) , (50 * math.sin(angledia4) * dt)) 
                end
              elseif patternTime >= 3.5 then
                paternBoss = 5
                patternTime = 0
              end
            end
        end
        
    end
    if animationboss == true then
      paternBoss = 0
      if secondes >= 0.5 then
        
      imgDecor[0] = love.graphics.newImage("ressources/lvldesign/sol_rouge.png")
      
      --miniboss1.x = miniboss1.x + miniboss1.speed * dt
      
    elseif secondes >= 0 and secondes < 0.5 then
      
          
          
      imgDecor[0] = love.graphics.newImage("ressources/lvldesign/sol_orange.png")
     
      elseif secondes < 0 then
      secondes = 1
      
    end
  else
    imgDecor[0] = love.graphics.newImage("ressources/lvldesign/sol.png")
  end

  
  
  
  
  
  
  end
  
    if Asecret1_music == true then
      love.audio.play(secret1_music)
    end 

    -- PATTERN SCAN

    if randomNumber == 4 then

      randomNumber = 1
    end


    if Scan == true then
      love.audio.play(avertissementScan)

    end

    if pause == false then
      local n

      -- traitement des tirs
      for n=#liste_tirs,1,-1 do
        local tir = liste_tirs[n]
        tir.x = tir.x + tir.vx
        tir.y = tir.y + tir.vy

        -- Vérifie si on touche le heros
        if tir.type == "tower" then
        
          if collide(player,tir) then
            print("Boom je suis touché !!")
            tir.supprime = true
            table.remove(liste_tirs, n)
            --player.life = player.life - 1
            --love.audio.play(Toucher)
            
            if SelectVirusP == "rose" or Safe == true then
              gameOver = false
            else
              
              --gameOver = true
              player.blink = true
              
            end
          end
        end

        -- Vérifier si le tir n'est pas sorti de l'écran
        if (tir.y < 0 or tir.x < 0 or tir.x > 5000 or tir.y > 5000) and tir.supprime == false then

          -- Marque le sprite pour le supprimer plus tard
          tir.supprime = true
          table.remove(liste_tirs, n)

        end

      end


      -- Traitement et purge des sprites
      for n=#liste_sprites,1,-1 do
        local sprite = liste_sprites[n]
        -- Le sprite est il animé ?
        if sprite.maxFrame > 1 then
          sprite.frame = sprite.frame + 0.2
          if math.floor(sprite.frame) > sprite.maxFrame then
            sprite.supprime = true
          else
            sprite.image = sprite.listeFrames[math.floor(sprite.frame)]
          end
        end
        if sprite.supprime == true then
          table.remove(liste_sprites,n)
        end
      end

    


-- TOWER 1
      if tower1.endormi == false and gameOver == false then

        tower1.chronotir = tower1.chronotir - 1
        if tower1.chronotir <= 0 then
          tower1.chronotir = 300
          local vx,vy
          local angle
          angle = math.angle(tower1.x+8,tower1.y+16/2,player.x+8,player.y+8)
          vx = 200 * math.cos(angle) * dt
          vy = 200 * math.sin(angle) * dt
          CreeTir("tower","laser2",tower1.x,tower1.y,vx,vy)
          psystem_explosion_spawn(tower1.x,tower1.y)
        end
      end

      -- TOWER 2
      if tower2.endormi == false and gameOver == false then

        tower2.chronotir = tower2.chronotir - 1
        if tower2.chronotir <= 0 then
          tower2.chronotir = 300
          local vx,vy
          local angle
          angle = math.angle(tower2.x+8,tower2.y+16/2,player.x+8,player.y+8)
          vx = 200 * math.cos(angle) * dt
          vy = 200 * math.sin(angle) * dt
          CreeTir("tower","laser2",tower2.x,tower2.y,vx,vy)
          psystem_explosion_spawn(tower2.x,tower2.y)
        end
      end

      -- TOWER 3
      if tower3.endormi == false and gameOver == false then

        tower3.chronotir = tower3.chronotir - 1
        if tower3.chronotir <= 0 then
          tower3.chronotir = 300
          local vx,vy
          local angle
          angle = math.angle(tower3.x+8,tower3.y+16/2,player.x+8,player.y+8)
          vx = 200 * math.cos(angle) * dt
          vy = 200 * math.sin(angle) * dt
          CreeTir("tower","laser2",tower3.x,tower3.y,vx,vy)
          psystem_explosion_spawn(tower3.x,tower3.y)
        end
      end

      -- TOWER 4
      if tower4.endormi == false and gameOver == false then

        tower4.chronotir = tower4.chronotir - 1
        if tower4.chronotir <= 0 then
          tower4.chronotir = 300
          local vx,vy
          local angle
          angle = math.angle(tower4.x+8,tower4.y+16/2,player.x+16,player.y+16)
          vx = 200 * math.cos(angle) * dt
          vy = 200 * math.sin(angle) * dt
          CreeTir("tower","laser2",tower4.x,tower4.y,vx,vy)
          psystem_explosion_spawn(tower4.x,tower4.y)
        end
      end

      -- TOWER 5
      if tower5.endormi == false and gameOver == false then

        tower5.chronotir = tower5.chronotir - 1
        if tower5.chronotir <= 0 then
          tower5.chronotir = 300
          local vx,vy
          local angle
          angle = math.angle(tower5.x+8,tower5.y+16/2,player.x+16,player.y+16)
          vx = 200 * math.cos(angle) * dt
          vy = 200 * math.sin(angle) * dt
          CreeTir("tower","laser2",tower5.x,tower5.y,vx,vy)
          psystem_explosion_spawn(tower5.x,tower5.y)
        end
      end

      -- TOWER 6
      if tower6.endormi == false and gameOver == false then

        tower6.chronotir = tower6.chronotir - 1
        if tower6.chronotir <= 0 then
          tower6.chronotir = 300
          local vx,vy
          local angle
          angle = math.angle(tower6.x+8,tower6.y+16/2,player.x+16,player.y+16)
          vx = 200 * math.cos(angle) * dt
          vy = 200 * math.sin(angle) * dt
          CreeTir("tower","laser2",tower6.x,tower6.y,vx,vy)
          psystem_explosion_spawn(tower6.x,tower6.y)
        end
      end

      -- Pour savoir si le joueur rendre dans le champs de vision de la tourelle


      -- ROTATION
      -- TOURELLE 1 
      if dist(player.x+8,player.y+8,tower1.circle.x,tower1.circle.y) < 8+75 then

        tower1.rotation = math.atan2(player.x+8 - tower1.x, tower1.y - player.y+8) - math.pi /2
        tower1.endormi = false
      else
        tower1.endormi = true
      end

      -- TOURELLE 2
      if dist(player.x+8,player.y+8,tower2.circle.x,tower2.circle.y) < 8+75 then

        tower2.rotation = math.atan2(player.x+8 - tower2.x, tower2.y - player.y+8) - math.pi /2
        tower2.endormi = false
      else
        tower2.endormi = true
      end

      -- TOURELLE 3
      if dist(player.x+8,player.y+8,tower3.circle.x,tower3.circle.y) < 8+75 then

        tower3.rotation = math.atan2(player.x+8 - tower3.x, tower3.y - player.y+8) - math.pi /2
        tower3.endormi = false
      else
        tower3.endormi = true
      end

      -- TOURELLE 4
      if dist(player.x+8,player.y+8,tower4.circle.x,tower4.circle.y) < 8+75 then

        tower4.rotation = math.atan2(player.x+8 - tower4.x, tower4.y - player.y+8) - math.pi /2
        tower4.endormi = false
      else
        tower4.endormi = true
      end

      -- TOURELLE 5
      if dist(player.x+8,player.y+8,tower5.circle.x,tower5.circle.y) < 8+75 then

        tower5.rotation = math.atan2(player.x+8 - tower5.x, tower5.y - player.y+8) - math.pi /2
        tower5.endormi = false
      else
        tower5.endormi = true
      end

      -- TOURELLE 6
      if dist(player.x+8,player.y+8,tower6.circle.x,tower6.circle.y) < 8+75 then

        tower6.rotation = math.atan2(player.x+8 - tower6.x, tower6.y - player.y+8) - math.pi /2
        tower6.endormi = false
      else
        tower6.endormi = true
      end

    end

    if activeTimer == true then

      timerDebut = timerDebut - love.timer.getDelta()

    end


    if timerDebut < 0 then

      activeTimer = false
      timerDebut = timerDebut + 1.5

    end


    if pause == false then
      
      
      -- Pour qu'il aille pas trop loin
      if balayageVertical.x > 1150 then

        balayageVertical.x = 1150

      end

      -- POUR L'AUTRE SENS
      if balayageVertical.x == 1150 and balayageVertical.active == true then

        balayageVertical.sens = balayageVertical.sens + 1

      end


      -- QUAND IL DEMARRE A PARTIR DE SA POSITION DE DEPART
      if balayageVertical.x == -2 and balayageVertical.active == true and balayageVertical.sens == 0 then

        balayageVertical.sens = balayageVertical.sens + 1
        print(balayageVertical.sens)

      end

      -- QUAND IL REVIENT A SA POSITION DE DEPART
      if balayageVertical.x < -2 and balayageVertical.active == true and balayageVertical.sens == 2 then


        --balayageVertical.sens = 3

        print("Nous changeons de scan :"..randomNumber)
        randomNumber = randomNumber + 1
        print("Nous changeons de scan :"..randomNumber)
        balayageVertical.x = -2
        balayageVertical.active = false
        balayageVertical.sens = 0
        print(balayageVertical.sens)


      end
    end


    if pause == false then

      if balayageHorizontal.y > 1200 then

        balayageHorizontal.y = 1200

      end

   

      if balayageHorizontal.y == 1200 and balayageHorizontal.active == true then

        balayageHorizontal.sens = balayageHorizontal.sens + 1

      end


      if balayageHorizontal.y == -2 and balayageHorizontal.active == true and balayageHorizontal.sens == 0 then

        balayageHorizontal.sens = balayageHorizontal.sens + 1
        print(balayageHorizontal.sens)

      end


      if balayageHorizontal.y < -2 and balayageHorizontal.active == true and balayageHorizontal.sens == 2 then


        print("Nous changeons de scan :"..randomNumber)
        randomNumber = randomNumber + 1
        balayageHorizontal.y = -2
        balayageHorizontal.active = false
        print("scan"..randomNumber)
        balayageHorizontal.sens = 0
        print("sens :"..balayageHorizontal.sens)


      end

    end


    scoresS = yourTime
--if (mousex < 100


    if pause == false then
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
    end

    if Safe == false then

      if ((player.x <= balayageVertical.x+1) and (balayageVertical.x <= player.x+10) and (player.y <= balayageVertical.y+1000) and (balayageVertical.y <= player.y+10)) then
          
        if SelectVirusP == "rose" then

          gameOver = false

        else
          
          
          player.blink = true
          --gameOver = true
        end

      else 
        toucheObject = false
      end

      if ((player.x <= balayageHorizontal.x+1200) and (balayageHorizontal.x <= player.x+10) and (player.y <= balayageHorizontal.y+1) and (balayageHorizontal.y <= player.y+10)) then
        toucheObject = true
        if SelectVirusP == "rose" then

          gameOver = false

        else

          
          player.blink = true
          --gameOver = true
        end

      else
        toucheObject = false
      end


    end

  

    -- VERTICAL

    if ((player.x <= piege.bougeVertical1.x+10) and (piege.bougeVertical1.x  <= player.x+7) and (player.y<= piege.bougeVertical1.y+14) and (piege.bougeVertical1.y <= player.y+13.5)) then
      
      if SelectVirusP == "rose" then

        gameOver = false
        player.x = player.x - 1

      else

        player.x = player.x - 1
        
         
        
        --gameOver = true
        player.blink = true
      end

    else
      toucheObject = false
    end


    if ((player.x <= piege.bougeVertical2.x+10) and (piege.bougeVertical2.x  <= player.x+7) and (player.y <= piege.bougeVertical2.y+14) and (piege.bougeVertical2.y <= player.y+13.5)) then
      
      if SelectVirusP == "rose" then

        gameOver = false


      else

        player.x = player.x - 1
        
        player.blink = true
       -- gameOver = true

      end
    end


    -- HORIZONTAL

    if ((player.x <= piege.bougeHorizontal1.x+14) and (piege.bougeHorizontal1.x  <= player.x+13.5) and (player.y <= piege.bougeHorizontal1.y+10) and (piege.bougeHorizontal1.y <= player.y+7)) then
      
      if SelectVirusP == "rose" then

        gameOver = false
        player.y = player.y - 1

      else

        player.y = player.y - 1
        
        player.blink = true
       -- gameOver = true

      end
    end

 

    -- TIMER



    if stopTimer == false and activeTimer == false then


      if Niveau == 1 then
          scanTime = scanTime - love.timer.getDelta()
      end
      
          timer = timer + love.timer.getDelta()
          yourTime = timer

      
    
  end
    
  if player.life == 0 then
    gameOver = true
  elseif SelectVirusP == "rose" then
    gameOver = false
  end
  
    if gameOver == true then

      player.speed = 0
      love.graphics.setColor(200,0,0)
      Scan = false
      stopTimer = true


      love.audio.stop(lvl1Music)
      love.audio.stop(lvl1Music_var1)
      love.audio.stop(lvl1Music_var2)
      love.audio.stop(music_miniboss1)
      

    end

    if Niveau == 1 then

    if scanTime < 0.1 then
    
      scanTime = scanTime + 25


      --randomNumber = love.math.random(1, 5)
      if randomNumber == 2 then

        if SelectVirusP == "rose" then
          balayageVertical.active = false
        else
          balayageVertical.active = true
        end
      end

      if randomNumber == 1 then

        if SelectVirusP == "rose" then
          balayageHorizontal.active = false
        else
          balayageHorizontal.active = true
        end

      end

      if Safe == false and randomNumber == 3 then

        if SelectVirusP == "rose" then

          gameOver = false

        else

          --gameOver = true
          player.blink = true
          
          
        end
      elseif Safe == true and randomNumber == 3 then
        randomNumber = 1
      end



    end

    if scanTime < 1.5 then
      if SelectVirusP == "rouge" or SelectVirusP == "originalV" or SelectVirusP == "jaune" or SelectVirusP == "original" then
        Scan = true
        love.graphics.setColor(255,255,100)
      end

    end

    if scanTime >= 25 then
      
      Scan = false


    end


   
  
  else
    Scan = false
    balayageVertical.active = false
    balayageHorizontal.active = false
    end
 
   
   touches = love.touch.getTouches()

    if touchx == 0  or touchy == 0 then

      toucheEcran = false

    end



    -- TimePiege
    if Niveau == 1 then
      timeBougeVertical = timeBougeVertical + love.timer.getDelta()
      timeBougeHorizontal = timeBougeHorizontal + love.timer.getDelta()
    end

    if gameOver == false and pause == false and Niveau == 1 then
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
      --if player.x > love.graphics.getWidth() / 9 then
      -- camera.x = player.x - love.graphics.getWidth() / 9 
      --end

      -- if player.y > love.graphics.getWidth() / 12 then
      --camera.y = player.y - love.graphics.getWidth() / 12
      --end
--else
      --camera.x = 0
      --camera.y = 0

      -- CAMERA FOCUS
      if check_fullscreen == true then


        camera.x = math.max(0,(player.x - love.graphics.getWidth()/20.7 - 16 / 2) / camera.scaleX)
        camera.y = math.max(0,(player.y - love.graphics.getHeight()/17.3 - 16 / 2) / camera.scaleY)
      else
        camera.x = math.max(0,(player.x - love.graphics.getWidth()/9.85 - 16 / 2) / camera.scaleX)
        camera.y = math.max(0,(player.y - love.graphics.getHeight()/10 - 16 / 2) / camera.scaleY)

      end 


    end



    if gameOver == false and pause == false and activeTimer == false then

      if Niveau == 1 then
      piege.bougeVertical1.y = piege.bougeVertical1.y + piege.bougeVertical1.speed * dt
      piege.bougeVertical2.y = piege.bougeVertical2.y + piege.bougeVertical2.speed * dt
      piege.bougeHorizontal1.x = piege.bougeHorizontal1.x + piege.bougeHorizontal1.speed * dt
      end
    
      
    
      -- Mouvement du personnage 
      
      -- FLECHE
        if moveControls == "ARROW" then
        moving = true

          if love.keyboard.isDown("right") then
          psystem:setLinearAcceleration(-810, -340, -820, 340)
            if SelectVirusP == "original" then

              playerStart = virus.skins.original.right
              player.x = player.x + player.speed * dt


            elseif SelectVirusP == "jaune" then

              playerStart = virus.skins.jaune.right
              player.x = player.x + player.speed * dt


            elseif SelectVirusP == "rouge" then
              psystem:setLinearAcceleration(-810, -340, -820, 340)
              playerStart = virus.skins.rouge.right
              player.x = player.x + player.speed * dt

            elseif SelectVirusP == "originalV" then
              psystem:setLinearAcceleration(810, -340, 820, 340)
              playerStart = virus.skins.originalV.left
              player.x = player.x - player.speed * dt


            elseif SelectVirusP == "rose" then

              playerStart = virus.skins.rose.right
              player.x = player.x + player.speed * dt

            elseif cSecret1 == "true" and enableSecret1 == true then

              playerStart = virus.skins.secret1.right
              player.x = player.x + player.speed * dt


            end
          end

          if love.keyboard.isDown("left") then
          psystem:setLinearAcceleration(810, -340, 820, 340)
            if SelectVirusP == "original" then

                  playerStart = virus.skins.original.left
                  player.x = player.x - player.speed * dt


                elseif SelectVirusP == "jaune" then

                  playerStart = virus.skins.jaune.left
                  player.x = player.x - player.speed * dt


                elseif SelectVirusP == "rouge" then
                  psystem:setLinearAcceleration(810, -340, 820, 340)
                  playerStart = virus.skins.rouge.left
                  player.x = player.x - player.speed * dt


                elseif SelectVirusP == "originalV" then
                  psystem:setLinearAcceleration(-810, -340, -820, 340)
                  playerStart = virus.skins.originalV.right
                  player.x = player.x + player.speed * dt


                elseif SelectVirusP == "rose" then

                  playerStart = virus.skins.rose.left
                  player.x = player.x - player.speed * dt

                elseif cSecret1 == "true" and enableSecret1 == true then 
                  playerStart = virus.skins.secret1.left
                  player.x = player.x - player.speed * dt

                end

            end

          if love.keyboard.isDown("up")then
          psystem:setLinearAcceleration(-340, 810, 340, 820)
            if SelectVirusP == "original" then

              playerStart = virus.skins.original.up
              player.y = player.y - player.speed * dt


            elseif SelectVirusP == "jaune" then

              playerStart = virus.skins.jaune.up
              player.y = player.y - player.speed * dt


            elseif SelectVirusP == "rouge" then
              psystem:setLinearAcceleration(-340, 810, 340, 820)
              playerStart = virus.skins.rouge.up
              player.y = player.y - player.speed * dt


            elseif SelectVirusP == "originalV" then
              psystem:setLinearAcceleration(-340, -810, 340, -820)
              playerStart = virus.skins.originalV.down
              player.y = player.y + player.speed * dt


            elseif SelectVirusP == "rose" then

              playerStart = virus.skins.rose.up
              player.y = player.y - player.speed * dt


            elseif cSecret1 == "true" and enableSecret1 == true then

              playerStart = virus.skins.secret1.up
              player.y = player.y - player.speed * dt

            end


          end

          if love.keyboard.isDown("down")then
          psystem:setLinearAcceleration(-340, -810, 340, -820)
            if SelectVirusP == "original" then

              playerStart = virus.skins.original.down
              player.y = player.y + player.speed * dt


            elseif SelectVirusP == "jaune" then

              playerStart = virus.skins.jaune.down
              player.y = player.y + player.speed * dt


            elseif SelectVirusP == "rouge" then
              psystem:setLinearAcceleration(-340, -810, 340, -820)
              playerStart = virus.skins.rouge.down
              player.y = player.y + player.speed * dt


            elseif SelectVirusP == "originalV" then
              psystem:setLinearAcceleration(-340, 810, 340, 820)
              playerStart = virus.skins.originalV.up
              player.y = player.y - player.speed * dt


            elseif SelectVirusP == "rose" then

              playerStart = virus.skins.rose.down
              player.y = player.y + player.speed * dt

            elseif cSecret1 == "true" and enableSecret1 == true then

              playerStart = virus.skins.secret1.down
              player.y = player.y + player.speed * dt

            end


          end
        end


        -- ZQSD
        if moveControls == "ZQSD" then
        moving = true

          if love.keyboard.isDown("d")then
          psystem:setLinearAcceleration(-810, -340, -820, 340)
            if SelectVirusP == "original" then

              playerStart = virus.skins.original.right
              player.x = player.x + player.speed * dt


            elseif SelectVirusP == "jaune" then

              playerStart = virus.skins.jaune.right
              player.x = player.x + player.speed * dt


            elseif SelectVirusP == "rouge" then
              psystem:setLinearAcceleration(-810, -340, -820, 340)
              playerStart = virus.skins.rouge.right
              player.x = player.x + player.speed * dt


            elseif SelectVirusP == "originalV" then
              psystem:setLinearAcceleration(810, -340, 820, 340)
              playerStart = virus.skins.originalV.left
              player.x = player.x - player.speed * dt


            elseif SelectVirusP == "rose" then

              playerStart = virus.skins.rose.right
              player.x = player.x + player.speed * dt

            elseif cSecret1 == "true" and enableSecret1 == true then
              playerStart = virus.skins.secret1.right
              player.x = player.x + player.speed * dt

            end


        end


          if love.keyboard.isDown("q")then
          psystem:setLinearAcceleration(810, -340, 820, 340)
            if SelectVirusP == "original" then

              playerStart = virus.skins.original.left
              player.x = player.x - player.speed * dt


            elseif SelectVirusP == "jaune" then

              playerStart = virus.skins.jaune.left
              player.x = player.x - player.speed * dt


            elseif SelectVirusP == "rouge" then
            psystem:setLinearAcceleration(810, -340, 820, 340)  
              playerStart = virus.skins.rouge.left
              player.x = player.x - player.speed * dt


            elseif SelectVirusP == "originalV" then
              psystem:setLinearAcceleration(-810, -340, -820, 340)
              playerStart = virus.skins.originalV.right
              player.x = player.x + player.speed * dt

            elseif SelectVirusP == "rose" then

              playerStart = virus.skins.rose.left
              player.x = player.x - player.speed * dt

            elseif cSecret1 == "true" and enableSecret1 == true then
              playerStart = virus.skins.secret1.left
              player.x = player.x - player.speed * dt

            end


        end

          if love.keyboard.isDown("z")then
          psystem:setLinearAcceleration(-340, 810, 340, 820)
            if SelectVirusP == "original" then

              playerStart = virus.skins.original.up
              player.y = player.y - player.speed * dt


            elseif SelectVirusP == "jaune" then

              playerStart = virus.skins.jaune.up
              player.y = player.y - player.speed * dt


            elseif SelectVirusP == "rouge" then
              psystem:setLinearAcceleration(-340, 810, 340, 820)
              playerStart = virus.skins.rouge.up
              player.y = player.y - player.speed * dt


            elseif SelectVirusP == "originalV" then
              psystem:setLinearAcceleration(-340, -810, 340, -820)
              playerStart = virus.skins.originalV.down
              player.y = player.y + player.speed * dt

            elseif SelectVirusP == "rose" then

              playerStart = virus.skins.rose.up
              player.y = player.y - player.speed * dt

            elseif cSecret1 == "true" and enableSecret1 == true then

              playerStart = virus.skins.secret1.up
              player.y = player.y - player.speed * dt

            end


          end

          if love.keyboard.isDown("s")then
          psystem:setLinearAcceleration(-340, -810, 340, -820)
            if SelectVirusP == "original" then

              playerStart = virus.skins.original.down
              player.y = player.y + player.speed * dt


            elseif SelectVirusP == "jaune" then

              playerStart = virus.skins.jaune.down
              player.y = player.y + player.speed * dt


            elseif SelectVirusP == "rouge" then
              psystem:setLinearAcceleration(-340, -810, 340, -820)
              playerStart = virus.skins.rouge.down
              player.y = player.y + player.speed * dt


            elseif SelectVirusP == "originalV" then
              psystem:setLinearAcceleration(-340, 810, 340, 820)
              playerStart = virus.skins.originalV.up
              player.y = player.y - player.speed * dt

            elseif SelectVirusP == "rose" then

              playerStart = virus.skins.rose.down
              player.y = player.y + player.speed * dt

            elseif cSecret1 == "true" and enableSecret1 == true then

              playerStart = virus.skins.secret1.down
              player.y = player.y + player.speed * dt

            end


      end
      
        end


        -- WASD
        if moveControls == "WASD" then
      moving = true

        if love.keyboard.isDown("d")then
        psystem:setLinearAcceleration(-810, -340, -820, 340)
          if SelectVirusP == "original" then

            playerStart = virus.skins.original.right
            player.x = player.x + player.speed * dt


          elseif SelectVirusP == "jaune" then

            playerStart = virus.skins.jaune.right
            player.x = player.x + player.speed * dt


          elseif SelectVirusP == "rouge" then
            psystem:setLinearAcceleration(-810, -340, -820, 340)
            playerStart = virus.skins.rouge.right
            player.x = player.x + player.speed * dt


          elseif SelectVirusP == "originalV" then
            psystem:setLinearAcceleration(810, -340, 820, 340)
            playerStart = virus.skins.originalV.left
            player.x = player.x - player.speed * dt

          elseif SelectVirusP == "rose" then

            playerStart = virus.skins.rose.right
            player.x = player.x + player.speed * dt

          elseif cSecret1 == "true" and enableSecret1 == true then

            playerStart = virus.skins.secret1.right
            player.x = player.x + player.speed * dt

          end


        end


        if love.keyboard.isDown("a")then
        psystem:setLinearAcceleration(810, -340, 820, 340)
          if SelectVirusP == "original" then

            playerStart = virus.skins.original.left
            player.x = player.x - player.speed * dt


          elseif SelectVirusP == "jaune" then

            playerStart = virus.skins.jaune.left
            player.x = player.x - player.speed * dt


          elseif SelectVirusP == "rouge" then
            psystem:setLinearAcceleration(810, -340, 820, 340)  
            playerStart = virus.skins.rouge.left
            player.x = player.x - player.speed * dt


          elseif SelectVirusP == "originalV" then
            psystem:setLinearAcceleration(-810, -340, -820, 340)
            playerStart = virus.skins.originalV.right
            player.x = player.x + player.speed * dt


          elseif SelectVirusP == "rose" then

            playerStart = virus.skins.rose.left
            player.x = player.x - player.speed * dt

          elseif cSecret1 == "true" and enableSecret1 == true then

            playerStart = virus.skins.secret1.left
            player.x = player.x - player.speed * dt

          end


        end

        if love.keyboard.isDown("w")then
        psystem:setLinearAcceleration(-340, 810, 340, 820)
          if SelectVirusP == "original" then

            playerStart = virus.skins.original.up
            player.y = player.y - player.speed * dt


          elseif SelectVirusP == "jaune" then

            playerStart = virus.skins.jaune.up
            player.y = player.y - player.speed * dt


          elseif SelectVirusP == "rouge" then
            psystem:setLinearAcceleration(-340, 810, 340, 820)
            playerStart = virus.skins.rouge.up
            player.y = player.y - player.speed * dt


          elseif SelectVirusP == "originalV" then
            psystem:setLinearAcceleration(-340, -810, 340, -820)
            playerStart = virus.skins.originalV.down
            player.y = player.y + player.speed * dt

          elseif SelectVirusP == "rose" then

            playerStart = virus.skins.rose.up
            player.y = player.y - player.speed * dt

          elseif cSecret1 == "true" and enableSecret1 == true then

            playerStart = virus.skins.secret1.up
            player.y = player.y - player.speed * dt

          end



        end

        if love.keyboard.isDown("s")then
        psystem:setLinearAcceleration(-340, -810, 340, -820)
          if SelectVirusP == "original" then

            playerStart = virus.skins.original.down
            player.y = player.y + player.speed * dt


          elseif SelectVirusP == "jaune" then

            playerStart = virus.skins.jaune.down
            player.y = player.y + player.speed * dt


          elseif SelectVirusP == "rouge" then
            psystem:setLinearAcceleration(-340, -810, 340, -820)
            playerStart = virus.skins.rouge.down
            player.y = player.y + player.speed * dt


          elseif SelectVirusP == "originalV" then
            psystem:setLinearAcceleration(-340, 810, 340, 820)
            playerStart = virus.skins.originalV.up
            player.y = player.y - player.speed * dt


          elseif SelectVirusP == "rose" then

            playerStart = virus.skins.rose.down
            player.y = player.y + player.speed * dt

          elseif cSecret1 == "true" and enableSecret1 == true then

            playerStart = virus.skins.secret1.down
            player.y = player.y + player.speed * dt

          end


        end
      end
      
      

      
    
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


    if enableSecret1 == false then
      -- Collisions entre le joueur et le mur (TITLE)
      nColonneCollisionGauche = math.floor((player.x / LARGEURTILE) + 1.8)
      nLigneCollisionBas = math.floor((((player.y-4)+player.h/2) / HAUTEURTILE ) + 1)

      nColonneCollisionDroite = math.floor((player.x / LARGEURTILE) + 1.21)
      nLigneCollisionHaut = math.floor((((player.y+5)+player.h/2) / HAUTEURTILE) + 1)
    elseif enableSecret1 == true and cSecret1 == "true" then
      nColonneCollisionGauche = math.floor((player.x / LARGEURTILE) + 1.45)
      nLigneCollisionBas = math.floor((((player.y-3)+8/2) / HAUTEURTILE ) + 1)

      nColonneCollisionDroite = math.floor((player.x / LARGEURTILE) + 1.1)
      nLigneCollisionHaut = math.floor((((player.y+3.5)+8/2) / HAUTEURTILE) + 1)
    end

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


  if Niveau == 1 then
    -- VERTICAL
    if map[nLigneCollisionHautVERTCICAL1][nColonneCollisionDroiteVERTICAL1] == 1 then
      piege.bougeVertical1.speed = -20
      -- print("collision Haut du mur")
    end


    if map[nLigneCollisionBasVERTICAL1][nColonneCollisionGaucheVERTCICAL1] == 1 then
      piege.bougeVertical1.speed = 20
      --print("collision bas du mur")
    end


    if map[nLigneCollisionHautVERTCICAL2][nColonneCollisionDroiteVERTICAL2] == 1 then
      piege.bougeVertical2.speed = -40
      --print("collision Haut du mur")
    end


    if map[nLigneCollisionBasVERTICAL2][nColonneCollisionGaucheVERTCICAL2] == 1 then
      piege.bougeVertical2.speed = 40
      --print("collision bas du mur")
    end


    --HORIZONTAL

    if map[nLigneCollisionHautHORIZONTAL1][nColonneCollisionDroiteHORIZONTAL1] == 1 then
      piege.bougeHorizontal1.speed = -20
      --print("collision droite du mur")
    end


    if map[nLigneCollisionBasHORIZONTAL1][nColonneCollisionGaucheHORIZONTAL1] == 1 then
      piege.bougeHorizontal1.speed = 20
      -- print("collision gauche du mur")
    end

  end

if player.y > 0 and player.y < 947 then
    if map[nLigneCollisionBas][nColonneCollisionGauche] == 1 then


      if SelectVirusP == "rose" then

        gameOver = false
        player.x = ancienX
        player.y = ancienY
      else

        player.x = ancienX
        player.y = ancienY

    
        --gameOver = true
        player.blink = true
        
      end

    end

    if map[nLigneCollisionBas][nColonneCollisionGauche] == 5 then

      if SelectVirusP == "jaune" then

        Asecret1_music = true

        love.audio.pause(lvl1Music)
        love.audio.pause(secret1_musicP)
        cSecret1 = "true" -- quand il decouvre l'endroit
        afficheSecret1Debloque = true

      elseif SelectVirusP == "rose" then
        love.audio.play(megalovania_remack)
        love.audio.pause(leaderboardMusic_rose)
        afficheSecret2Debloque = true

      end

      --SelectVirusP = "secret1"
    else

      if enableSecret1 == true and cSecret1 == "true" then 
        love.audio.resume(secret1_musicP)
      else

        afficheSecret1Debloque = false
        afficheSecret2Debloque = false
        Asecret1_music = false
        love.audio.stop(megalovania_remack)
        love.audio.stop(secret1_music)
        love.audio.resume(lvl1Music)
        love.audio.resume(leaderboardMusic_rose)
      end
    end

    -- Asecret1_music
    

    if map[nLigneCollisionHaut][nColonneCollisionDroite] == 1 or map[nLigneCollisionBas][nColonneCollisionGauche] == 6 or map[nLigneCollisionBas][nColonneCollisionGauche] == 9 then

      if SelectVirusP == "rose" then

        gameOver = false
        player.x = ancienX
        player.y = ancienY
      else
        player.x = ancienX
        player.y = ancienY

        
        --gameOver = true
        player.blink = true
        
      end

    end


    -- ZONE SAFE
    if map[nLigneCollisionBas][nColonneCollisionGauche] == 2 or map[nLigneCollisionBas][nColonneCollisionGauche] == 5 then

      Safe = true


    else 

      Safe = false

    end

    if map[nLigneCollisionHaut][nColonneCollisionDroite] == 2 or map[nLigneCollisionHaut][nColonneCollisionDroite] == 5 then

      Safe = true


    else

      Safe = false

    end





    -- COLLISIONS FIN

    if map[nLigneCollisionBas][nColonneCollisionGauche] == 4 then
      love.audio.play(lvlUp)
      
      if Niveau == 1 then
        DeuxiemeNiveau() 
      end
    
      --Fin()
    end

    if map[nLigneCollisionHaut][nColonneCollisionDroite] == 4 then
      love.audio.play(lvlUp) 
      
      if Niveau == 1 then
        DeuxiemeNiveau() 
      end
      
      --Fin()
    end



    -- PIEGES
  end
  
  end


  if afficheMenu == true then

    avertissementScan:setVolume(soundVolume)
    Toucher:setVolume(soundVolume)
    Shoottower:setVolume(soundVolume)
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
    explosion_sound:setVolume(soundVolume)
    explosion_boss:setVolume(soundVolume)
    hit_sound:setVolume(soundVolume)
    combo_sound:setVolume(soundVolume)
    
    gameOver_music:setVolume(musicVolume)
    lvl1Music:setVolume(musicVolume)
    leaderboardMusic:setVolume(musicVolume)
    leaderboardMusic_rose:setVolume(musicVolume)
    leaderboardMusic_jaune:setVolume(musicVolume)
    leaderboardMusic_nigiro:setVolume(musicVolume)
    secret1_music:setVolume(musicVolume)
    secret1_musicP:setVolume(musicVolume)
    nigiro_music:setVolume(musicVolume)
    megalovania_remack:setVolume(musicVolume)
    music_miniboss1:setVolume(musicVolume)
    win_music:setVolume(musicVolume)

    MenuMusic:setVolume(musicVolume)
    SelectVirusMusic:setVolume(musicVolume)


    -- OMG

    if check_fullscreen == true then 

      menu.principal.y = ((love.graphics.getHeight()/9))


      menu.play.y = ((love.graphics.getHeight()/5))


      menu.options.y = ((love.graphics.getHeight()/5+100))

      menu.leaderboard.y = ((love.graphics.getHeight()/5+200))

      menu.leaderboardOffline.y = ((love.graphics.getHeight()/5+300))

      menu.quit.y = ((love.graphics.getHeight()/5+400))

    else

      menu.principal.y = ((love.graphics.getHeight()/10))

      menu.play.y = ((love.graphics.getHeight()/4))

      menu.options.y = ((love.graphics.getHeight()/4+75))


      menu.leaderboard.y = ((love.graphics.getHeight()/4+150))

      menu.leaderboardOffline.y = ((love.graphics.getHeight()/4+225))

      menu.quit.y = ((love.graphics.getHeight()/4+300))

    end
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
    menu.principal.x = menu.principal.x + 1500 * dt
    menu.play.x = menu.play.x + 1500 * dt
    menu.quit.x = menu.quit.x + 1500 * dt
    menu.leaderboard.x = menu.leaderboard.x + 1500 * dt
    menu.leaderboardOffline.x = menu.leaderboardOffline.x + 1500 * dt
    menu.options.x = menu.options.x + 1500 * dt
    curseurmenu.x = curseurmenu.x + 1100 * dt


    if menu.principal.x > love.graphics.getWidth()/2 then

      menu.principal.x = love.graphics.getWidth()/2

    end

    if menu.play.x > love.graphics.getWidth()/2 then

      menu.play.x = love.graphics.getWidth()/2

    end

    if menu.leaderboard.x > love.graphics.getWidth()/2 then

      menu.leaderboard.x = love.graphics.getWidth()/2

    end

    if menu.leaderboardOffline.x > love.graphics.getWidth()/2 then

      menu.leaderboardOffline.x = love.graphics.getWidth()/2

    end

    if menu.quit.x > love.graphics.getWidth()/2 then

      menu.quit.x = love.graphics.getWidth()/2

    end

    if menu.options.x > love.graphics.getWidth()/2 then

      menu.options.x = love.graphics.getWidth()/2

    end

    if afficheMainMenu == true and afficheOptions == false and afficheSelectVirus == false and afficheClassement == false and afficheFin == false then


      if curseurmenu.x > ((love.graphics.getWidth()/2)-100) then

        curseurmenu.x = ((love.graphics.getWidth()/2)-100)
        particule1_x = ((love.graphics.getWidth()/2)-100)
      end

      if positioncurseur == 1 then

        curseurmenu.y = menu.play.y-3


      elseif positioncurseur == 2 then

        curseurmenu.y = menu.options.y-3

      elseif positioncurseur == 3 then

        curseurmenu.y = menu.leaderboard.y-3

      elseif positioncurseur == 4 then

        curseurmenu.y = menu.leaderboardOffline.y-3

      elseif positioncurseur == 5 then

        curseurmenu.y = menu.quit.y-3

      end

      if positioncurseur == 0 then

        positioncurseur = 5

      elseif positioncurseur == 6 then

        positioncurseur = 1

      end



    end

    if afficheMainMenu == false and afficheOptions == false and afficheSelectVirus == true and afficheClassement == false and afficheFin == false then
      nameVirus.x =  curseurmenu2.x
      timeaffiche = timeaffiche + love.timer.getDelta()

      if positioncurseur2 == 1 then

        curseurmenu2.x = menuSelectVirus.selectyourvirus.jaune.x
        curseurmenu2.y = menuSelectVirus.selectyourvirus.jaune.y+14
        nameVirus.y =  curseurmenu2.y+15
        nameVirus.name = "VI-TLP"


      elseif positioncurseur2 == 2 then

        curseurmenu2.x = menuSelectVirus.selectyourvirus.originalV.x
        curseurmenu2.y = menuSelectVirus.selectyourvirus.originalV.y+14
        nameVirus.y =  curseurmenu2.y+15
        nameVirus.name = "VI-NigirO"

      elseif positioncurseur2 == 3 then

        curseurmenu2.x = menuSelectVirus.selectyourvirus.original.x
        curseurmenu2.y = menuSelectVirus.selectyourvirus.original.y+14
        nameVirus.y =  curseurmenu2.y+15
        nameVirus.name = "VI-Origin"

      elseif positioncurseur2 == 4 then

        curseurmenu2.x = menuSelectVirus.selectyourvirus.rouge.x
        curseurmenu2.y = menuSelectVirus.selectyourvirus.rouge.y+14
        nameVirus.name = "VI-RageL"

      elseif positioncurseur2 == 5 then

        curseurmenu2.x = menuSelectVirus.selectyourvirus.rose.x
        curseurmenu2.y = menuSelectVirus.selectyourvirus.rose.y+14
        nameVirus.y =  curseurmenu2.y+15
        nameVirus.name = "VI-NooBik"

      elseif cSecret1 == "true" and positioncurseur2 == 6 or positioncurseur2 == -1 then
        curseurmenu2.x = menuSelectVirus.selectyourvirus.secret1.x-6
        curseurmenu2.y = menuSelectVirus.selectyourvirus.secret1.y+5
        nameVirus.y =  curseurmenu2.y+15
        nameVirus.x =  curseurmenu2.x-10
        nameVirus.name = "VI-RageLoska"
      end
      -- SANS SECRET
      if positioncurseur2 == 0 and cSecret1 == "false" then

        positioncurseur2 = 5

      elseif positioncurseur2 == 6 and cSecret1 == "false" then

        positioncurseur2 = 1

        -- AVEC SECRET 
      elseif positioncurseur2 == 0 and cSecret1 == "true" then
        positioncurseur2 = 6
      elseif positioncurseur2 == 7 and cSecret1 == "true" then
        positioncurseur2 = 1
      end
    end

    if afficheMainMenu == false and afficheOptions == false and afficheSelectVirus == false and afficheClassement == true and afficheFin == false then

      if positionhorizontalClassement == 1 then
        love.audio.stop(leaderboardMusic_nigiro)
        leaderboardMusic:setPitch(1)
        NomClassement = "Origin"


      elseif positionhorizontalClassement == 2 then
        love.audio.stop(leaderboardMusic)
        NomClassement = "Nigiro"


      elseif positionhorizontalClassement == 3 then

        leaderboardMusic:setPitch(2)
        NomClassement = "Ragel"
        love.audio.stop(leaderboardMusic_nigiro)
        love.audio.stop(leaderboardMusic_rose)

      elseif positionhorizontalClassement == 4 then

        NomClassement = "Noobik"
        love.audio.stop(leaderboardMusic_jaune)

      elseif positionhorizontalClassement == 5 then

        NomClassement = "TLP"
        love.audio.stop(leaderboardMusic_rose)
        love.audio.play(leaderboardMusic_jaune)
        love.audio.stop(leaderboardMusic_nigiro)

      end

      if positionhorizontalClassement == 6 then
        b, c, h = http.request("http://ver-infect.atspace.cc/110/getData_original.php")
        --b, c, h = http.request("http://127.0.0.1/getData_original.php")

        positionhorizontalClassement = 1
        love.audio.stop(leaderboardMusic_jaune)
        love.audio.play(leaderboardMusic)

      elseif positionhorizontalClassement == 0 then
        b, c, h = http.request("http://ver-infect.atspace.cc/110/getData_jaune.php")
        --b, c, h = http.request("http://127.0.0.1/getData_jaune.php")
        positionhorizontalClassement = 5
        love.audio.play(leaderboardMusic_jaune)
        love.audio.stop(leaderboardMusic)
      end
    end

    if afficheMainMenu == false and afficheOptions == false and afficheSelectVirus == false and afficheClassement == false and afficheClassementOffline == true and afficheFin == false then

      if positionhorizontalClassement == 1 then
        love.audio.play(leaderboardMusic)
        love.audio.stop(leaderboardMusic_nigiro)
        leaderboardMusic:setPitch(1)
        NomClassement = "Origin"


      elseif positionhorizontalClassement == 2 then
        leaderboardMusic:setPitch(0.5)
        NomClassement = "Nigiro"
        love.audio.stop(leaderboardMusic)
        love.audio.play(leaderboardMusic_nigiro)


      elseif positionhorizontalClassement == 3 then

        leaderboardMusic:setPitch(2)
        NomClassement = "Ragel"
        love.audio.stop(leaderboardMusic_nigiro)
        love.audio.play(leaderboardMusic)
        love.audio.stop(leaderboardMusic_rose)

      elseif positionhorizontalClassement == 4 then

        NomClassement = "Noobik"
        love.audio.play(leaderboardMusic_rose)
        love.audio.stop(leaderboardMusic)
        love.audio.stop(leaderboardMusic_jaune)
      elseif positionhorizontalClassement == 5 then

        NomClassement = "TLP"
        love.audio.stop(leaderboardMusic_rose)
        love.audio.play(leaderboardMusic_jaune)

      end

      if positionhorizontalClassement == 6 then

        positionhorizontalClassement = 1
        love.audio.stop(leaderboardMusic_jaune)
      elseif positionhorizontalClassement == 0 then

        positionhorizontalClassement = 5
        love.audio.stop(leaderboardMusic)
      end
    end



    if afficheMainMenu == false and afficheOptions == true and afficheSelectVirus == false and afficheClassement == false and afficheFin == false then


      if check_fullscreen == true then

        curseurmenu.x = ((love.graphics.getWidth()/20)-100)

      else
        curseurmenu.x = 1
      end
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

-- particles love.graphics.draw(psystem,1,1)
--if check_fullscreen == true then

  -- love.graphics.translate(largeurEcran / 2, hauteurEcran / 2)
  --else
  --love.graphics.translate(1,1)
  --end 
  love.graphics.scale(1,1)
  if afficheMainMenu == true and afficheMenu == true and afficheOptions == false and afficheSelectVirus == false and afficheClassement == false and afficheFin == false then
    love.graphics.setColor(255,255,255)
    love.graphics.draw(imgBackground,1,1,0,love.graphics.getWidth()/32,love.graphics.getHeight()/32)


    if language == "english" then



      if check_fullscreen == true then


        love.graphics.print("[F1] WINDOW",60,30,0,5,5)
        love.graphics.print("[F2] FULLSCREEN",60,60,0,5,5)
        love.graphics.print("VER-INFECT",menu.principal.x,menu.principal.y,0,5,5,30,5/2)
        love.graphics.print("Play",  menu.play.x,menu.play.y,0,5,5,100/2,5/2)
        love.graphics.print("Settings",  menu.options.x,  menu.options.y,0,5,5,100/2,5/2)
        love.graphics.print("Leaderboard online",  menu.leaderboard.x,  menu.leaderboard.y,0,5,5,100/2,5/2)
        love.graphics.print("Leaderboard offline",  menu.leaderboardOffline.x,  menu.leaderboardOffline.y,0,5,5,100/2,5/2)
        love.graphics.print("Quit",  menu.quit.x,  menu.quit.y,0,5,5,100/2,7/2)
        love.graphics.draw(curseurmenu.sprite, curseurmenu.x, curseurmenu.y-15,0,5,5,100/2,5/2)
        love.graphics.print("Version 1.20",love.graphics.getWidth()/2,love.graphics.getHeight()/1.07,0,5,5,100/2,5/2)

      else
        love.graphics.print("[F1] WINDOW",30,500,0,4,4)
        love.graphics.print("[F2] FULLSCREEN",440,500,0,4,4)
        love.graphics.print("VER-INFECT",menu.principal.x,menu.principal.y,0,4,4,30,5/2)
        love.graphics.print("Play",  menu.play.x,menu.play.y,0,4,4,100/2,5/2)
        love.graphics.print("Settings",  menu.options.x,  menu.options.y,0,4,4,100/2,5/2)
        love.graphics.print("Leaderboard online",  menu.leaderboard.x,  menu.leaderboard.y,0,4,4,100/2,5/2)
        love.graphics.print("Leaderboard offline",  menu.leaderboardOffline.x,  menu.leaderboardOffline.y,0,4,4,100/2,5/2)
        love.graphics.print("Quit",  menu.quit.x,  menu.quit.y,0,4,4,100/2,7/2)
        love.graphics.draw(curseurmenu.sprite, curseurmenu.x, curseurmenu.y-15,0,4,4,100/2,5/2)
        love.graphics.print("Version 1.20",love.graphics.getWidth()/2,love.graphics.getHeight()/1.07,0,4,4,100/2,5/2)
      end

    elseif language == "french" then

      if check_fullscreen == true then

        
        love.graphics.print("[F1] FENETRE",60,30,0,5,5)
        love.graphics.print("[F2] PLEINE ECRAN",60,60,0,5,5)
        love.graphics.print("VER-INFECT",menu.principal.x,menu.principal.y,0,5,5,30,5/2)
        love.graphics.print("Jouer",  menu.play.x, menu.play.y,0,5,5,100/2,5/2)
        love.graphics.print("Options",  menu.options.x,  menu.options.y,0,5,5,100/2,5/2)
        love.graphics.print("Classement en ligne",  menu.leaderboard.x,  menu.leaderboard.y,0,5,5,100/2,5/2)
        love.graphics.print("Classement local",  menu.leaderboardOffline.x,  menu.leaderboardOffline.y,0,5,5,100/2,5/2)
        love.graphics.print("Quitter",  menu.quit.x,  menu.quit.y,0,5,5,100/2,7/2)
        love.graphics.draw(curseurmenu.sprite, curseurmenu.x, curseurmenu.y-15,0,5,5,100/2,5/2)
        love.graphics.print("Version 1.20",love.graphics.getWidth()/2,love.graphics.getHeight()/1.07,0,5,5,100/2,5/2)
      else
        love.graphics.print("[F1] FENETRE",30,500,0,4,4)
        love.graphics.print("[F2] PLEINE ECRAN",390,500,0,4,4)
        love.graphics.print("VER-INFECT",menu.principal.x,menu.principal.y,0,4,4,30,5/2)
        love.graphics.print("Jouer",  menu.play.x, menu.play.y,0,4,4,100/2,5/2)
        love.graphics.print("Options",  menu.options.x,  menu.options.y,0,4,4,100/2,5/2)
        love.graphics.print("Classement en ligne",  menu.leaderboard.x,  menu.leaderboard.y,0,4,4,100/2,5/2)
        love.graphics.print("Classement local",  menu.leaderboardOffline.x,  menu.leaderboardOffline.y,0,4,4,100/2,5/2)
        love.graphics.print("Quitter",  menu.quit.x,  menu.quit.y,0,4,4,100/2,7/2)
        love.graphics.draw(curseurmenu.sprite, curseurmenu.x, curseurmenu.y-15,0,4,4,100/2,5/2)
        love.graphics.print("Version 1.20",love.graphics.getWidth()/2,love.graphics.getHeight()/1.07,0,4,4,100/2,5/2)
      end
    end

  end

  if afficheCredits == true then
    love.graphics.scale(4,4)
  if language ==  "english" then
    love.graphics.setColor(0,255,0)
    love.graphics.print("DELEVOPER", credits.developer.x,credits.developer.y)
    love.graphics.setColor(255,255,255)
    love.graphics.print("JSkey", credits.developer.name.x,credits.developer.name.y)
    
     love.graphics.setColor(0,255,0)
    love.graphics.print("GRAPHICS", credits.designer.x,credits.designer.y)
    love.graphics.setColor(255,255,255)
    love.graphics.print("JSkey", credits.designer.name.x,credits.designer.name.y)
    
    love.graphics.setColor(0,255,0)
    love.graphics.print("MUSICS/SOUNDS", credits.musics.x,credits.musics.y)
    love.graphics.setColor(255,255,255)
    love.graphics.print("JSkey", credits.musics.name.x,credits.musics.name.y)
    
    love.graphics.setColor(0,255,0)
    love.graphics.print("SPECIAL THANKS", credits.specialThanks.x,credits.specialThanks.y)
    love.graphics.setColor(255,255,255)
    love.graphics.print("Franck", credits.specialThanks.name.x,credits.specialThanks.name.y)
    love.graphics.print("thewrath", credits.specialThanks.name2.x,credits.specialThanks.name2.y)
    love.graphics.print("Jimmy Labodudev", credits.specialThanks.name3.x,credits.specialThanks.name3.y)
    love.graphics.print("Thanks for playing !", credits.specialThanksPlay.name.x,credits.specialThanksPlay.name.y)
  elseif language == "french" then
    love.graphics.setColor(0,255,0)
    love.graphics.print("DEVELOPPEUR", credits.developer.x,credits.developer.y)
    love.graphics.setColor(255,255,255)
    love.graphics.print("J.Skey", credits.developer.name.x,credits.developer.name.y)
    
    love.graphics.setColor(0,255,0)
    love.graphics.print("GRAPHIQUES", credits.designer.x,credits.designer.y)
    love.graphics.setColor(255,255,255)
    love.graphics.print("J.Skey", credits.designer.name.x,credits.designer.name.y)
    love.graphics.setColor(0,255,0)
    love.graphics.print("MUSIQUES/BRUITAGES", credits.musics.x,credits.musics.y)
    love.graphics.setColor(255,255,255)
    love.graphics.print("J.Skey", credits.musics.name.x,credits.musics.name.y)
    
    love.graphics.setColor(0,255,0)
    love.graphics.print("REMERCIEMENTS SPECIAL", credits.specialThanks.x,credits.specialThanks.y)
    love.graphics.setColor(255,255,255)
    love.graphics.print("Franck", credits.specialThanks.name.x,credits.specialThanks.name.y)
    love.graphics.print("thewrath", credits.specialThanks.name2.x,credits.specialThanks.name2.y)
    love.graphics.print("Jimmy Labodudev", credits.specialThanks.name3.x,credits.specialThanks.name3.y)
    love.graphics.print("MERCI D'AVOIR JOUÉ !", credits.specialThanksPlay.name.x,credits.specialThanksPlay.name.y)
  end
end

  -- MENU SELECTION
  if afficheSelectVirus == true and afficheMainMenu == false and afficheMenu == true and afficheOptions == false and afficheClassement == false and afficheFin == false then
    love.graphics.draw(imgBackground,1,1,0,love.graphics.getWidth()/32,love.graphics.getHeight()/32)
    if language == "english" then

      if check_fullscreen == true then
        love.graphics.print("Choose your virus", love.graphics.getWidth()/2,love.graphics.getHeight()/20,0,5,5,52,5/2)
        love.graphics.translate(love.graphics.getWidth()/4,love.graphics.getHeight()/9)
      else
        love.graphics.print("Choose your virus", love.graphics.getWidth()/2,30,0,4,4,50,5/2)
      end
    end

    if language == "french" then

      if check_fullscreen == true then
        love.graphics.print("Choisissez votre virus", love.graphics.getWidth()/2,love.graphics.getHeight()/20,0,5,5,60,5/2)
        love.graphics.translate(love.graphics.getWidth()/4,love.graphics.getHeight()/9)

      else
        love.graphics.print("Choisissez votre virus", love.graphics.getWidth()/2,30,0,4,4,60,5/2)
      end
    end
    love.graphics.scale(4,4)



    love.graphics.draw(menuSelectVirus.selectyourvirus.original.sprite,menuSelectVirus.selectyourvirus.original.x,menuSelectVirus.selectyourvirus.original.y,0,1.5,1.5)
    love.graphics.draw(menuSelectVirus.selectyourvirus.originalV.sprite,menuSelectVirus.selectyourvirus.originalV.x,menuSelectVirus.selectyourvirus.originalV.y,0,1.5,1.5)
    love.graphics.draw(menuSelectVirus.selectyourvirus.rouge.sprite,menuSelectVirus.selectyourvirus.rouge.x,menuSelectVirus.selectyourvirus.rouge.y,0,1.5,1.5)
    love.graphics.draw(menuSelectVirus.selectyourvirus.rose.sprite,menuSelectVirus.selectyourvirus.rose.x,menuSelectVirus.selectyourvirus.rose.y,0,1.5,1.5)
    love.graphics.draw(menuSelectVirus.selectyourvirus.jaune.sprite,menuSelectVirus.selectyourvirus.jaune.x,menuSelectVirus.selectyourvirus.jaune.y,0,1.5,1.5)

    if cSecret1 == "true" then
      love.graphics.draw(menuSelectVirus.selectyourvirus.secret1.sprite,menuSelectVirus.selectyourvirus.secret1.x,menuSelectVirus.selectyourvirus.secret1.y,0,1.5,1.5)
    end
    love.graphics.draw(curseurmenu2.sprite,curseurmenu2.x+4,curseurmenu2.y+4)
    love.graphics.print(nameVirus.name,nameVirus.x-12,nameVirus.y)
  end

  if afficheS ==  true then
    --- love.graphics.draw(scV,0,0,0,(love.graphics.getWidth()/1400))
  end

  -- CLASSEMENT ONLINE
  if afficheOptions == false and afficheMenu == true and afficheMainMenu == false and afficheSelectVirus == false and afficheClassement == true and afficheClassementOffline == false and afficheFin == false then

    love.graphics.draw(imgBackground,1,1,0,love.graphics.getWidth()/32,love.graphics.getHeight()/32)
    love.graphics.scale(4,4)

    if language == "english" then 

      if check_fullscreen == true then

        love.graphics.translate(love.graphics.getWidth()/20,love.graphics.getHeight()/40)
        ChangeColor("<--[ %2ESC%0 ] ",1,1)
        ChangeColor("< %2Leaderboard%0 "..NomClassement.." >", ((love.graphics.getWidth()/8)/4),10)

        if b == nil then

          love.graphics.print("Not Internet...",10,((love.graphics.getHeight()/4)/4))
        else 

          love.graphics.print(b,10,((love.graphics.getHeight()/4)/4))
        end
      else

        ChangeColor("<--[ %2ESC%0 ] ",10,10)
        ChangeColor("< %2Leaderboard%0 "..NomClassement.." >", ((800/3)/4),10)

        if b == nil then 

          love.graphics.print("Not Internet...",10,30)
        else

          love.graphics.print(b,10,30)
        end

      end



    elseif language == "french" then

      if check_fullscreen == true then

        love.graphics.translate(love.graphics.getWidth()/20,love.graphics.getHeight()/40)
        ChangeColor("<--[ %2ECHAP%0 ] " ,1,1)
        ChangeColor("< %2Classement%0 "..NomClassement.." >", ((love.graphics.getWidth()/8)/4),10)

        if b == nil then
          love.graphics.print("Pas Internet...",10,((love.graphics.getHeight()/4)/4))
        else

          love.graphics.print(b,10,((love.graphics.getHeight()/4)/4))
        end
      else

        ChangeColor("<--[ %2ECHAP%0 ] " ,10,10)
        ChangeColor("< %2Classement%0 "..NomClassement.." >", ((800/3.5)/3),10)

        if b == nil then

          love.graphics.print("Pas Internet...",10,30)
        else

          love.graphics.print(b,10,30)

        end
      end



    end



  end

  -- CLASSEMENT OFFLINE
  if afficheOptions == false and afficheMenu == true and afficheMainMenu == false and afficheSelectVirus == false and afficheClassement == false and afficheClassementOffline == true and afficheFin == false then

    love.graphics.draw(imgBackground,1,1,0,love.graphics.getWidth()/32,love.graphics.getHeight()/32)
    love.graphics.scale(4,4)
   



    if language == "english" then 

      if check_fullscreen == true then

        love.graphics.translate(love.graphics.getWidth()/20,love.graphics.getHeight()/40)
        ChangeColor("<--[ %2ESC%0 ] ",1,1)
        ChangeColor("%1OFFLINE%0 ",((love.graphics.getWidth()/4.5)/4),1)
        ChangeColor("< %2Leaderboard%0 "..NomClassement.." >", ((love.graphics.getWidth()/8)/4),10)

        if positionhorizontalClassement == 1 then

          --LookFile_original()

          if Loriginal[1]["name"] == "" and Loriginal[1]["times"] == "10000000000" then
            love.graphics.print("1. ****",10,30)
          else
            love.graphics.print("1. "..Loriginal[1]["name"].." : "..Loriginal[1]["times"],10,30)
          end 

          if Loriginal[2]["name"] == "" and Loriginal[2]["times"] == "10000000000" then
            love.graphics.print("2. ****",10,40)
          else
            love.graphics.print("2. "..Loriginal[2]["name"].." : "..Loriginal[2]["times"],10,40)
          end 

          if Loriginal[3]["name"] == "" and Loriginal[3]["times"] == "10000000000" then
            love.graphics.print("3. ****",10,50)
          else
            love.graphics.print("3. "..Loriginal[3]["name"].." : "..Loriginal[3]["times"],10,50)
          end 

          if Loriginal[4]["name"] == "" and Loriginal[4]["times"] == "10000000000" then
            love.graphics.print("4. ****",10,60)
          else
            love.graphics.print("4. "..Loriginal[4]["name"].." : "..Loriginal[4]["times"],10,60)
          end 

          if Loriginal[5]["name"] == "" and Loriginal[5]["times"] == "10000000000" then
            love.graphics.print("5. ****",10,70)
          else
            love.graphics.print("5. "..Loriginal[5]["name"].." : "..Loriginal[5]["times"],10,70)
          end

          if Loriginal[6]["name"] == "" and Loriginal[6]["times"] == "10000000000" then
            love.graphics.print("6. ****",10,80)
          else
            love.graphics.print("6. "..Loriginal[6]["name"].." : "..Loriginal[6]["times"],10,80)
          end

          if Loriginal[7]["name"] == "" and Loriginal[7]["times"] == "10000000000" then
            love.graphics.print("7. ****",10,90)
          else
            love.graphics.print("7. "..Loriginal[7]["name"].." : "..Loriginal[7]["times"],10,90)
          end

          if Loriginal[8]["name"] == "" and Loriginal[8]["times"] == "10000000000" then
            love.graphics.print("8. ****",10,100)
          else
            love.graphics.print("8. "..Loriginal[8]["name"].." : "..Loriginal[8]["times"],10,100)
          end


          if Loriginal[9]["name"] == "" and Loriginal[9]["times"] == "10000000000" then
            love.graphics.print("9. ****",10,110)
          else
            love.graphics.print("9. "..Loriginal[9]["name"].." : "..Loriginal[9]["times"],10,110)
          end


          if Loriginal[10]["name"] == "" and Loriginal[10]["times"] == "10000000000" then
            love.graphics.print("10. ****",10,120)
          else
            love.graphics.print("10. "..Loriginal[10]["name"].." : "..Loriginal[10]["times"],10,120)
          end

        elseif positionhorizontalClassement == 2 then

          --LookFile_originalV()

          if LoriginalV[1]["name"] == "" and LoriginalV[1]["times"] == "10000000000" then
            love.graphics.print("1. ****",10,30)
          else
            love.graphics.print("1. "..LoriginalV[1]["name"].." : "..LoriginalV[1]["times"],10,30)
          end 

          if LoriginalV[2]["name"] == "" and LoriginalV[2]["times"] == "10000000000" then
            love.graphics.print("2. ****",10,40)
          else
            love.graphics.print("2. "..LoriginalV[2]["name"].." : "..LoriginalV[2]["times"],10,40)
          end 

          if LoriginalV[3]["name"] == "" and LoriginalV[3]["times"] == "10000000000" then
            love.graphics.print("3. ****",10,50)
          else
            love.graphics.print("3. "..LoriginalV[3]["name"].." : "..LoriginalV[3]["times"],10,50)
          end 

          if LoriginalV[4]["name"] == "" and LoriginalV[4]["times"] == "10000000000" then
            love.graphics.print("4. ****",10,60)
          else
            love.graphics.print("4. "..LoriginalV[4]["name"].." : "..LoriginalV[4]["times"],10,60)
          end 

          if LoriginalV[5]["name"] == "" and LoriginalV[5]["times"] == "10000000000" then
            love.graphics.print("5. ****",10,70)
          else
            love.graphics.print("5. "..LoriginalV[5]["name"].." : "..LoriginalV[5]["times"],10,70)
          end

          if LoriginalV[6]["name"] == "" and LoriginalV[6]["times"] == "10000000000" then
            love.graphics.print("6. ****",10,80)
          else
            love.graphics.print("6. "..LoriginalV[6]["name"].." : "..LoriginalV[6]["times"],10,80)
          end

          if LoriginalV[7]["name"] == "" and LoriginalV[7]["times"] == "10000000000" then
            love.graphics.print("7. ****",10,90)
          else
            love.graphics.print("7. "..LoriginalV[7]["name"].." : "..LoriginalV[7]["times"],10,90)
          end

          if LoriginalV[8]["name"] == "" and LoriginalV[8]["times"] == "10000000000" then
            love.graphics.print("8. ****",10,100)
          else
            love.graphics.print("8. "..LoriginalV[8]["name"].." : "..LoriginalV[8]["times"],10,100)
          end


          if LoriginalV[9]["name"] == "" and LoriginalV[9]["times"] == "10000000000" then
            love.graphics.print("9. ****",10,110)
          else
            love.graphics.print("9. "..LoriginalV[9]["name"].." : "..LoriginalV[9]["times"],10,110)
          end


          if LoriginalV[10]["name"] == "" and LoriginalV[10]["times"] == "10000000000" then
            love.graphics.print("10. ****",10,120)
          else
            love.graphics.print("10. "..LoriginalV[10]["name"].." : "..LoriginalV[10]["times"],10,120)
          end



        elseif positionhorizontalClassement == 3 then

          --LookFile_rouge()

          if Lrouge[1]["name"] == "" and Lrouge[1]["times"] == "10000000000" then
            love.graphics.print("1. ****",10,30)
          else
            love.graphics.print("1. "..Lrouge[1]["name"].." : "..Lrouge[1]["times"],10,30)
          end 

          if Lrouge[2]["name"] == "" and Lrouge[2]["times"] == "10000000000" then
            love.graphics.print("2. ****",10,40)
          else
            love.graphics.print("2. "..Lrouge[2]["name"].." : "..Lrouge[2]["times"],10,40)
          end 

          if Lrouge[3]["name"] == "" and Lrouge[3]["times"] == "10000000000" then
            love.graphics.print("3. ****",10,50)
          else
            love.graphics.print("3. "..Lrouge[3]["name"].." : "..Lrouge[3]["times"],10,50)
          end 

          if Lrouge[4]["name"] == "" and Lrouge[4]["times"] == "10000000000" then
            love.graphics.print("4. ****",10,60)
          else
            love.graphics.print("4. "..Lrouge[4]["name"].." : "..Lrouge[4]["times"],10,60)
          end 

          if Lrouge[5]["name"] == "" and Lrouge[5]["times"] == "10000000000" then
            love.graphics.print("5. ****",10,70)
          else
            love.graphics.print("5. "..Lrouge[5]["name"].." : "..Lrouge[5]["times"],10,70)
          end

          if Lrouge[6]["name"] == "" and Lrouge[6]["times"] == "10000000000" then
            love.graphics.print("6. ****",10,80)
          else
            love.graphics.print("6. "..Lrouge[6]["name"].." : "..Lrouge[6]["times"],10,80)
          end

          if Lrouge[7]["name"] == "" and Lrouge[7]["times"] == "10000000000" then
            love.graphics.print("7. ****",10,90)
          else
            love.graphics.print("7. "..Lrouge[7]["name"].." : "..Lrouge[7]["times"],10,90)
          end

          if Lrouge[8]["name"] == "" and Lrouge[8]["times"] == "10000000000" then
            love.graphics.print("8. ****",10,100)
          else
            love.graphics.print("8. "..Lrouge[8]["name"].." : "..Lrouge[8]["times"],10,100)
          end


          if Lrouge[9]["name"] == "" and Lrouge[9]["times"] == "10000000000" then
            love.graphics.print("9. ****",10,110)
          else
            love.graphics.print("9. "..Lrouge[9]["name"].." : "..Lrouge[9]["times"],10,110)
          end


          if Lrouge[10]["name"] == "" and Lrouge[10]["times"] == "10000000000" then
            love.graphics.print("10. ****",10,120)
          else
            love.graphics.print("10. "..Lrouge[10]["name"].." : "..Lrouge[10]["times"],10,120)
          end



        elseif positionhorizontalClassement == 4 then

          -- LookFile_rose()

          if Lrose[1]["name"] == "" and Lrose[1]["times"] == "10000000000" then
            love.graphics.print("1. ****",10,30)
          else
            love.graphics.print("1. "..Lrose[1]["name"].." : "..Lrose[1]["times"],10,30)
          end 

          if Lrose[2]["name"] == "" and Lrose[2]["times"] == "10000000000" then
            love.graphics.print("2. ****",10,40)
          else
            love.graphics.print("2. "..Lrose[2]["name"].." : "..Lrose[2]["times"],10,40)
          end 

          if Lrose[3]["name"] == "" and Lrose[3]["times"] == "10000000000" then
            love.graphics.print("3. ****",10,50)
          else
            love.graphics.print("3. "..Lrose[3]["name"].." : "..Lrose[3]["times"],10,50)
          end 

          if Lrose[4]["name"] == "" and Lrose[4]["times"] == "10000000000" then
            love.graphics.print("4. ****",10,60)
          else
            love.graphics.print("4. "..Lrose[4]["name"].." : "..Lrose[4]["times"],10,60)
          end 

          if Lrose[5]["name"] == "" and Lrose[5]["times"] == "10000000000" then
            love.graphics.print("5. ****",10,70)
          else
            love.graphics.print("5. "..Lrose[5]["name"].." : "..Lrose[5]["times"],10,70)
          end

          if Lrose[6]["name"] == "" and Lrose[6]["times"] == "10000000000" then
            love.graphics.print("6. ****",10,80)
          else
            love.graphics.print("6. "..Lrose[6]["name"].." : "..Lrose[6]["times"],10,80)
          end

          if Lrose[7]["name"] == "" and Lrose[7]["times"] == "10000000000" then
            love.graphics.print("7. ****",10,90)
          else
            love.graphics.print("7. "..Lrose[7]["name"].." : "..Lrose[7]["times"],10,90)
          end

          if Lrose[8]["name"] == "" and Lrose[8]["times"] == "10000000000" then
            love.graphics.print("8. ****",10,100)
          else
            love.graphics.print("8. "..Lrose[8]["name"].." : "..Lrose[8]["times"],10,100)
          end


          if Lrose[9]["name"] == "" and Lrose[9]["times"] == "10000000000" then
            love.graphics.print("9. ****",10,110)
          else
            love.graphics.print("9. "..Lrose[9]["name"].." : "..Lrose[9]["times"],10,110)
          end


          if Lrose[10]["name"] == "" and Lrose[10]["times"] == "10000000000" then
            love.graphics.print("10. ****",10,120)
          else
            love.graphics.print("10. "..Lrose[10]["name"].." : "..Lrose[10]["times"],10,120)
          end


        elseif positionhorizontalClassement == 5 then

          --LookFile_jaune()

          if Ljaune[1]["name"] == "" and Ljaune[1]["times"] == "10000000000" then
            love.graphics.print("1. ****",10,30)
          else
            love.graphics.print("1. "..Ljaune[1]["name"].." : "..Ljaune[1]["times"],10,30)
          end 

          if Ljaune[2]["name"] == "" and Ljaune[2]["times"] == "10000000000" then
            love.graphics.print("2. ****",10,40)
          else
            love.graphics.print("2. "..Ljaune[2]["name"].." : "..Ljaune[2]["times"],10,40)
          end 

          if Ljaune[3]["name"] == "" and Ljaune[3]["times"] == "10000000000" then
            love.graphics.print("3. ****",10,50)
          else
            love.graphics.print("3. "..Ljaune[3]["name"].." : "..Ljaune[3]["times"],10,50)
          end 

          if Ljaune[4]["name"] == "" and Ljaune[4]["times"] == "10000000000" then
            love.graphics.print("4. ****",10,60)
          else
            love.graphics.print("4. "..Ljaune[4]["name"].." : "..Ljaune[4]["times"],10,60)
          end 

          if Ljaune[5]["name"] == "" and Ljaune[5]["times"] == "10000000000" then
            love.graphics.print("5. ****",10,70)
          else
            love.graphics.print("5. "..Ljaune[5]["name"].." : "..Ljaune[5]["times"],10,70)
          end

          if Ljaune[6]["name"] == "" and Ljaune[6]["times"] == "10000000000" then
            love.graphics.print("6. ****",10,80)
          else
            love.graphics.print("6. "..Ljaune[6]["name"].." : "..Ljaune[6]["times"],10,80)
          end

          if Ljaune[7]["name"] == "" and Ljaune[7]["times"] == "10000000000" then
            love.graphics.print("7. ****",10,90)
          else
            love.graphics.print("7. "..Ljaune[7]["name"].." : "..Ljaune[7]["times"],10,90)
          end

          if Ljaune[8]["name"] == "" and Ljaune[8]["times"] == "10000000000" then
            love.graphics.print("8. ****",10,100)
          else
            love.graphics.print("8. "..Ljaune[8]["name"].." : "..Ljaune[8]["times"],10,100)
          end


          if Ljaune[9]["name"] == "" and Ljaune[9]["times"] == "10000000000" then
            love.graphics.print("9. ****",10,110)
          else
            love.graphics.print("9. "..Ljaune[9]["name"].." : "..Ljaune[9]["times"],10,110)
          end


          if Ljaune[10]["name"] == "" and Ljaune[10]["times"] == "10000000000" then
            love.graphics.print("10. ****",10,120)
          else
            love.graphics.print("10. "..Ljaune[10]["name"].." : "..Ljaune[10]["times"],10,120)
          end

        end

      else

        ChangeColor("<--[ %2ESC%0 ] ",10,10)
        ChangeColor("%1OFFLINE%0 ",((love.graphics.getWidth()/3.5)/3),4)
        ChangeColor("< %2Leaderboard%0 "..NomClassement.." >", ((800/3)/4),10)

        if positionhorizontalClassement == 1 then


          --LookFile_original()


          if Loriginal[1]["name"] == "" and Loriginal[1]["times"] == "10000000000" then
            love.graphics.print("1. ****",10,30)
          else
            love.graphics.print("1. "..Loriginal[1]["name"].." : "..Loriginal[1]["times"],10,30)
          end 

          if Loriginal[2]["name"] == "" and Loriginal[2]["times"] == "10000000000" then
            love.graphics.print("2. ****",10,40)
          else
            love.graphics.print("2. "..Loriginal[2]["name"].." : "..Loriginal[2]["times"],10,40)
          end 

          if Loriginal[3]["name"] == "" and Loriginal[3]["times"] == "10000000000" then
            love.graphics.print("3. ****",10,50)
          else
            love.graphics.print("3. "..Loriginal[3]["name"].." : "..Loriginal[3]["times"],10,50)
          end 

          if Loriginal[4]["name"] == "" and Loriginal[4]["times"] == "10000000000" then
            love.graphics.print("4. ****",10,60)
          else
            love.graphics.print("4. "..Loriginal[4]["name"].." : "..Loriginal[4]["times"],10,60)
          end 

          if Loriginal[5]["name"] == "" and Loriginal[5]["times"] == "10000000000" then
            love.graphics.print("5. ****",10,70)
          else
            love.graphics.print("5. "..Loriginal[5]["name"].." : "..Loriginal[5]["times"],10,70)
          end

          if Loriginal[6]["name"] == "" and Loriginal[6]["times"] == "10000000000" then
            love.graphics.print("6. ****",10,80)
          else
            love.graphics.print("6. "..Loriginal[6]["name"].." : "..Loriginal[6]["times"],10,80)
          end

          if Loriginal[7]["name"] == "" and Loriginal[7]["times"] == "10000000000" then
            love.graphics.print("7. ****",10,90)
          else
            love.graphics.print("7. "..Loriginal[7]["name"].." : "..Loriginal[7]["times"],10,90)
          end

          if Loriginal[8]["name"] == "" and Loriginal[8]["times"] == "10000000000" then
            love.graphics.print("8. ****",10,100)
          else
            love.graphics.print("8. "..Loriginal[8]["name"].." : "..Loriginal[8]["times"],10,100)
          end


          if Loriginal[9]["name"] == "" and Loriginal[9]["times"] == "10000000000" then
            love.graphics.print("9. ****",10,110)
          else
            love.graphics.print("9. "..Loriginal[9]["name"].." : "..Loriginal[9]["times"],10,110)
          end


          if Loriginal[10]["name"] == "" and Loriginal[10]["times"] == "10000000000" then
            love.graphics.print("10. ****",10,120)
          else
            love.graphics.print("10. "..Loriginal[10]["name"].." : "..Loriginal[10]["times"],10,120)
          end

        elseif positionhorizontalClassement == 2 then


          --LookFile_originalV()

          if LoriginalV[1]["name"] == "" and LoriginalV[1]["times"] == "10000000000" then
            love.graphics.print("1. ****",10,30)
          else
            love.graphics.print("1. "..LoriginalV[1]["name"].." : "..LoriginalV[1]["times"],10,30)
          end 

          if LoriginalV[2]["name"] == "" and LoriginalV[2]["times"] == "10000000000" then
            love.graphics.print("2. ****",10,40)
          else
            love.graphics.print("2. "..LoriginalV[2]["name"].." : "..LoriginalV[2]["times"],10,40)
          end 

          if LoriginalV[3]["name"] == "" and LoriginalV[3]["times"] == "10000000000" then
            love.graphics.print("3. ****",10,50)
          else
            love.graphics.print("3. "..LoriginalV[3]["name"].." : "..LoriginalV[3]["times"],10,50)
          end 

          if LoriginalV[4]["name"] == "" and LoriginalV[4]["times"] == "10000000000" then
            love.graphics.print("4. ****",10,60)
          else
            love.graphics.print("4. "..LoriginalV[4]["name"].." : "..LoriginalV[4]["times"],10,60)
          end 

          if LoriginalV[5]["name"] == "" and LoriginalV[5]["times"] == "10000000000" then
            love.graphics.print("5. ****",10,70)
          else
            love.graphics.print("5. "..LoriginalV[5]["name"].." : "..LoriginalV[5]["times"],10,70)
          end

          if LoriginalV[6]["name"] == "" and LoriginalV[6]["times"] == "10000000000" then
            love.graphics.print("6. ****",10,80)
          else
            love.graphics.print("6. "..LoriginalV[6]["name"].." : "..LoriginalV[6]["times"],10,80)
          end

          if LoriginalV[7]["name"] == "" and LoriginalV[7]["times"] == "10000000000" then
            love.graphics.print("7. ****",10,90)
          else
            love.graphics.print("7. "..LoriginalV[7]["name"].." : "..LoriginalV[7]["times"],10,90)
          end

          if LoriginalV[8]["name"] == "" and LoriginalV[8]["times"] == "10000000000" then
            love.graphics.print("8. ****",10,100)
          else
            love.graphics.print("8. "..LoriginalV[8]["name"].." : "..LoriginalV[8]["times"],10,100)
          end


          if LoriginalV[9]["name"] == "" and LoriginalV[9]["times"] == "10000000000" then
            love.graphics.print("9. ****",10,110)
          else
            love.graphics.print("9. "..LoriginalV[9]["name"].." : "..LoriginalV[9]["times"],10,110)
          end


          if LoriginalV[10]["name"] == "" and LoriginalV[10]["times"] == "10000000000" then
            love.graphics.print("10. ****",10,120)
          else
            love.graphics.print("10. "..LoriginalV[10]["name"].." : "..LoriginalV[10]["times"],10,120)
          end



        elseif positionhorizontalClassement == 3 then


          --LookFile_rouge()


          if Lrouge[1]["name"] == "" and Lrouge[1]["times"] == "10000000000" then
            love.graphics.print("1. ****",10,30)
          else
            love.graphics.print("1. "..Lrouge[1]["name"].." : "..Lrouge[1]["times"],10,30)
          end 

          if Lrouge[2]["name"] == "" and Lrouge[2]["times"] == "10000000000" then
            love.graphics.print("2. ****",10,40)
          else
            love.graphics.print("2. "..Lrouge[2]["name"].." : "..Lrouge[2]["times"],10,40)
          end 

          if Lrouge[3]["name"] == "" and Lrouge[3]["times"] == "10000000000" then
            love.graphics.print("3. ****",10,50)
          else
            love.graphics.print("3. "..Lrouge[3]["name"].." : "..Lrouge[3]["times"],10,50)
          end 

          if Lrouge[4]["name"] == "" and Lrouge[4]["times"] == "10000000000" then
            love.graphics.print("4. ****",10,60)
          else
            love.graphics.print("4. "..Lrouge[4]["name"].." : "..Lrouge[4]["times"],10,60)
          end 

          if Lrouge[5]["name"] == "" and Lrouge[5]["times"] == "10000000000" then
            love.graphics.print("5. ****",10,70)
          else
            love.graphics.print("5. "..Lrouge[5]["name"].." : "..Lrouge[5]["times"],10,70)
          end

          if Lrouge[6]["name"] == "" and Lrouge[6]["times"] == "10000000000" then
            love.graphics.print("6. ****",10,80)
          else
            love.graphics.print("6. "..Lrouge[6]["name"].." : "..Lrouge[6]["times"],10,80)
          end

          if Lrouge[7]["name"] == "" and Lrouge[7]["times"] == "10000000000" then
            love.graphics.print("7. ****",10,90)
          else
            love.graphics.print("7. "..Lrouge[7]["name"].." : "..Lrouge[7]["times"],10,90)
          end

          if Lrouge[8]["name"] == "" and Lrouge[8]["times"] == "10000000000" then
            love.graphics.print("8. ****",10,100)
          else
            love.graphics.print("8. "..Lrouge[8]["name"].." : "..Lrouge[8]["times"],10,100)
          end


          if Lrouge[9]["name"] == "" and Lrouge[9]["times"] == "10000000000" then
            love.graphics.print("9. ****",10,110)
          else
            love.graphics.print("9. "..Lrouge[9]["name"].." : "..Lrouge[9]["times"],10,110)
          end


          if Lrouge[10]["name"] == "" and Lrouge[10]["times"] == "10000000000" then
            love.graphics.print("10. ****",10,120)
          else
            love.graphics.print("10. "..Lrouge[10]["name"].." : "..Lrouge[10]["times"],10,120)
          end



        elseif positionhorizontalClassement == 4 then


          -- LookFile_rose()


          if Lrose[1]["name"] == "" and Lrose[1]["times"] == "10000000000" then
            love.graphics.print("1. ****",10,30)
          else
            love.graphics.print("1. "..Lrose[1]["name"].." : "..Lrose[1]["times"],10,30)
          end 

          if Lrose[2]["name"] == "" and Lrose[2]["times"] == "10000000000" then
            love.graphics.print("2. ****",10,40)
          else
            love.graphics.print("2. "..Lrose[2]["name"].." : "..Lrose[2]["times"],10,40)
          end 

          if Lrose[3]["name"] == "" and Lrose[3]["times"] == "10000000000" then
            love.graphics.print("3. ****",10,50)
          else
            love.graphics.print("3. "..Lrose[3]["name"].." : "..Lrose[3]["times"],10,50)
          end 

          if Lrose[4]["name"] == "" and Lrose[4]["times"] == "10000000000" then
            love.graphics.print("4. ****",10,60)
          else
            love.graphics.print("4. "..Lrose[4]["name"].." : "..Lrose[4]["times"],10,60)
          end 

          if Lrose[5]["name"] == "" and Lrose[5]["times"] == "10000000000" then
            love.graphics.print("5. ****",10,70)
          else
            love.graphics.print("5. "..Lrose[5]["name"].." : "..Lrose[5]["times"],10,70)
          end

          if Lrose[6]["name"] == "" and Lrose[6]["times"] == "10000000000" then
            love.graphics.print("6. ****",10,80)
          else
            love.graphics.print("6. "..Lrose[6]["name"].." : "..Lrose[6]["times"],10,80)
          end

          if Lrose[7]["name"] == "" and Lrose[7]["times"] == "10000000000" then
            love.graphics.print("7. ****",10,90)
          else
            love.graphics.print("7. "..Lrose[7]["name"].." : "..Lrose[7]["times"],10,90)
          end

          if Lrose[8]["name"] == "" and Lrose[8]["times"] == "10000000000" then
            love.graphics.print("8. ****",10,100)
          else
            love.graphics.print("8. "..Lrose[8]["name"].." : "..Lrose[8]["times"],10,100)
          end


          if Lrose[9]["name"] == "" and Lrose[9]["times"] == "10000000000" then
            love.graphics.print("9. ****",10,110)
          else
            love.graphics.print("9. "..Lrose[9]["name"].." : "..Lrose[9]["times"],10,110)
          end


          if Lrose[10]["name"] == "" and Lrose[10]["times"] == "10000000000" then
            love.graphics.print("10. ****",10,120)
          else
            love.graphics.print("10. "..Lrose[10]["name"].." : "..Lrose[10]["times"],10,120)
          end


        elseif positionhorizontalClassement == 5 then


          --LookFile_jaune()


          if Ljaune[1]["name"] == "" and Ljaune[1]["times"] == "10000000000" then
            love.graphics.print("1. ****",10,30)
          else
            love.graphics.print("1. "..Ljaune[1]["name"].." : "..Ljaune[1]["times"],10,30)
          end 

          if Ljaune[2]["name"] == "" and Ljaune[2]["times"] == "10000000000" then
            love.graphics.print("2. ****",10,40)
          else
            love.graphics.print("2. "..Ljaune[2]["name"].." : "..Ljaune[2]["times"],10,40)
          end 

          if Ljaune[3]["name"] == "" and Ljaune[3]["times"] == "10000000000" then
            love.graphics.print("3. ****",10,50)
          else
            love.graphics.print("3. "..Ljaune[3]["name"].." : "..Ljaune[3]["times"],10,50)
          end 

          if Ljaune[4]["name"] == "" and Ljaune[4]["times"] == "10000000000" then
            love.graphics.print("4. ****",10,60)
          else
            love.graphics.print("4. "..Ljaune[4]["name"].." : "..Ljaune[4]["times"],10,60)
          end 

          if Ljaune[5]["name"] == "" and Ljaune[5]["times"] == "10000000000" then
            love.graphics.print("5. ****",10,70)
          else
            love.graphics.print("5. "..Ljaune[5]["name"].." : "..Ljaune[5]["times"],10,70)
          end

          if Ljaune[6]["name"] == "" and Ljaune[6]["times"] == "10000000000" then
            love.graphics.print("6. ****",10,80)
          else
            love.graphics.print("6. "..Ljaune[6]["name"].." : "..Ljaune[6]["times"],10,80)
          end

          if Ljaune[7]["name"] == "" and Ljaune[7]["times"] == "10000000000" then
            love.graphics.print("7. ****",10,90)
          else
            love.graphics.print("7. "..Ljaune[7]["name"].." : "..Ljaune[7]["times"],10,90)
          end

          if Ljaune[8]["name"] == "" and Ljaune[8]["times"] == "10000000000" then
            love.graphics.print("8. ****",10,100)
          else
            love.graphics.print("8. "..Ljaune[8]["name"].." : "..Ljaune[8]["times"],10,100)
          end


          if Ljaune[9]["name"] == "" and Ljaune[9]["times"] == "10000000000" then
            love.graphics.print("9. ****",10,110)
          else
            love.graphics.print("9. "..Ljaune[9]["name"].." : "..Ljaune[9]["times"],10,110)
          end


          if Ljaune[10]["name"] == "" and Ljaune[10]["times"] == "10000000000" then
            love.graphics.print("10. ****",10,120)
          else
            love.graphics.print("10. "..Ljaune[10]["name"].." : "..Ljaune[10]["times"],10,120)
          end

        end


      end



    elseif language == "french" then

      if check_fullscreen == true then

        love.graphics.translate(love.graphics.getWidth()/20,love.graphics.getHeight()/40)
        ChangeColor("<--[ %2ECHAP%0 ] " ,1,1)
        ChangeColor("%1HORS LIGNE%0 ",((love.graphics.getWidth()/5)/4),1)
        ChangeColor("< %2Classement%0 "..NomClassement.." >", ((love.graphics.getWidth()/8)/4),10)

        if positionhorizontalClassement == 1 then

          --LookFile_original()

          if Loriginal[1]["name"] == "" and Loriginal[1]["times"] == "10000000000" then
            love.graphics.print("1. ****",10,30)
          else
            love.graphics.print("1. "..Loriginal[1]["name"].." : "..Loriginal[1]["times"],10,30)
          end 

          if Loriginal[2]["name"] == "" and Loriginal[2]["times"] == "10000000000" then
            love.graphics.print("2. ****",10,40)
          else
            love.graphics.print("2. "..Loriginal[2]["name"].." : "..Loriginal[2]["times"],10,40)
          end 

          if Loriginal[3]["name"] == "" and Loriginal[3]["times"] == "10000000000" then
            love.graphics.print("3. ****",10,50)
          else
            love.graphics.print("3. "..Loriginal[3]["name"].." : "..Loriginal[3]["times"],10,50)
          end 

          if Loriginal[4]["name"] == "" and Loriginal[4]["times"] == "10000000000" then
            love.graphics.print("4. ****",10,60)
          else
            love.graphics.print("4. "..Loriginal[4]["name"].." : "..Loriginal[4]["times"],10,60)
          end 

          if Loriginal[5]["name"] == "" and Loriginal[5]["times"] == "10000000000" then
            love.graphics.print("5. ****",10,70)
          else
            love.graphics.print("5. "..Loriginal[5]["name"].." : "..Loriginal[5]["times"],10,70)
          end

          if Loriginal[6]["name"] == "" and Loriginal[6]["times"] == "10000000000" then
            love.graphics.print("6. ****",10,80)
          else
            love.graphics.print("6. "..Loriginal[6]["name"].." : "..Loriginal[6]["times"],10,80)
          end

          if Loriginal[7]["name"] == "" and Loriginal[7]["times"] == "10000000000" then
            love.graphics.print("7. ****",10,90)
          else
            love.graphics.print("7. "..Loriginal[7]["name"].." : "..Loriginal[7]["times"],10,90)
          end

          if Loriginal[8]["name"] == "" and Loriginal[8]["times"] == "10000000000" then
            love.graphics.print("8. ****",10,100)
          else
            love.graphics.print("8. "..Loriginal[8]["name"].." : "..Loriginal[8]["times"],10,100)
          end


          if Loriginal[9]["name"] == "" and Loriginal[9]["times"] == "10000000000" then
            love.graphics.print("9. ****",10,110)
          else
            love.graphics.print("9. "..Loriginal[9]["name"].." : "..Loriginal[9]["times"],10,110)
          end


          if Loriginal[10]["name"] == "" and Loriginal[10]["times"] == "10000000000" then
            love.graphics.print("10. ****",10,120)
          else
            love.graphics.print("10. "..Loriginal[10]["name"].." : "..Loriginal[10]["times"],10,120)
          end

        elseif positionhorizontalClassement == 2 then

          -- LookFile_originalV()

          if LoriginalV[1]["name"] == "" and LoriginalV[1]["times"] == "10000000000" then
            love.graphics.print("1. ****",10,30)
          else
            love.graphics.print("1. "..LoriginalV[1]["name"].." : "..LoriginalV[1]["times"],10,30)
          end 

          if LoriginalV[2]["name"] == "" and LoriginalV[2]["times"] == "10000000000" then
            love.graphics.print("2. ****",10,40)
          else
            love.graphics.print("2. "..LoriginalV[2]["name"].." : "..LoriginalV[2]["times"],10,40)
          end 

          if LoriginalV[3]["name"] == "" and LoriginalV[3]["times"] == "10000000000" then
            love.graphics.print("3. ****",10,50)
          else
            love.graphics.print("3. "..LoriginalV[3]["name"].." : "..LoriginalV[3]["times"],10,50)
          end 

          if LoriginalV[4]["name"] == "" and LoriginalV[4]["times"] == "10000000000" then
            love.graphics.print("4. ****",10,60)
          else
            love.graphics.print("4. "..LoriginalV[4]["name"].." : "..LoriginalV[4]["times"],10,60)
          end 

          if LoriginalV[5]["name"] == "" and LoriginalV[5]["times"] == "10000000000" then
            love.graphics.print("5. ****",10,70)
          else
            love.graphics.print("5. "..LoriginalV[5]["name"].." : "..LoriginalV[5]["times"],10,70)
          end

          if LoriginalV[6]["name"] == "" and LoriginalV[6]["times"] == "10000000000" then
            love.graphics.print("6. ****",10,80)
          else
            love.graphics.print("6. "..LoriginalV[6]["name"].." : "..LoriginalV[6]["times"],10,80)
          end

          if LoriginalV[7]["name"] == "" and LoriginalV[7]["times"] == "10000000000" then
            love.graphics.print("7. ****",10,90)
          else
            love.graphics.print("7. "..LoriginalV[7]["name"].." : "..LoriginalV[7]["times"],10,90)
          end

          if LoriginalV[8]["name"] == "" and LoriginalV[8]["times"] == "10000000000" then
            love.graphics.print("8. ****",10,100)
          else
            love.graphics.print("8. "..LoriginalV[8]["name"].." : "..LoriginalV[8]["times"],10,100)
          end


          if LoriginalV[9]["name"] == "" and LoriginalV[9]["times"] == "10000000000" then
            love.graphics.print("9. ****",10,110)
          else
            love.graphics.print("9. "..LoriginalV[9]["name"].." : "..LoriginalV[9]["times"],10,110)
          end


          if LoriginalV[10]["name"] == "" and LoriginalV[10]["times"] == "10000000000" then
            love.graphics.print("10. ****",10,120)
          else
            love.graphics.print("10. "..LoriginalV[10]["name"].." : "..LoriginalV[10]["times"],10,120)
          end



        elseif positionhorizontalClassement == 3 then

          -- LookFile_rouge()

          if Lrouge[1]["name"] == "" and Lrouge[1]["times"] == "10000000000" then
            love.graphics.print("1. ****",10,30)
          else
            love.graphics.print("1. "..Lrouge[1]["name"].." : "..Lrouge[1]["times"],10,30)
          end 

          if Lrouge[2]["name"] == "" and Lrouge[2]["times"] == "10000000000" then
            love.graphics.print("2. ****",10,40)
          else
            love.graphics.print("2. "..Lrouge[2]["name"].." : "..Lrouge[2]["times"],10,40)
          end 

          if Lrouge[3]["name"] == "" and Lrouge[3]["times"] == "10000000000" then
            love.graphics.print("3. ****",10,50)
          else
            love.graphics.print("3. "..Lrouge[3]["name"].." : "..Lrouge[3]["times"],10,50)
          end 

          if Lrouge[4]["name"] == "" and Lrouge[4]["times"] == "10000000000" then
            love.graphics.print("4. ****",10,60)
          else
            love.graphics.print("4. "..Lrouge[4]["name"].." : "..Lrouge[4]["times"],10,60)
          end 

          if Lrouge[5]["name"] == "" and Lrouge[5]["times"] == "10000000000" then
            love.graphics.print("5. ****",10,70)
          else
            love.graphics.print("5. "..Lrouge[5]["name"].." : "..Lrouge[5]["times"],10,70)
          end

          if Lrouge[6]["name"] == "" and Lrouge[6]["times"] == "10000000000" then
            love.graphics.print("6. ****",10,80)
          else
            love.graphics.print("6. "..Lrouge[6]["name"].." : "..Lrouge[6]["times"],10,80)
          end

          if Lrouge[7]["name"] == "" and Lrouge[7]["times"] == "10000000000" then
            love.graphics.print("7. ****",10,90)
          else
            love.graphics.print("7. "..Lrouge[7]["name"].." : "..Lrouge[7]["times"],10,90)
          end

          if Lrouge[8]["name"] == "" and Lrouge[8]["times"] == "10000000000" then
            love.graphics.print("8. ****",10,100)
          else
            love.graphics.print("8. "..Lrouge[8]["name"].." : "..Lrouge[8]["times"],10,100)
          end


          if Lrouge[9]["name"] == "" and Lrouge[9]["times"] == "10000000000" then
            love.graphics.print("9. ****",10,110)
          else
            love.graphics.print("9. "..Lrouge[9]["name"].." : "..Lrouge[9]["times"],10,110)
          end


          if Lrouge[10]["name"] == "" and Lrouge[10]["times"] == "10000000000" then
            love.graphics.print("10. ****",10,120)
          else
            love.graphics.print("10. "..Lrouge[10]["name"].." : "..Lrouge[10]["times"],10,120)
          end



        elseif positionhorizontalClassement == 4 then

          --LookFile_rose()

          if Lrose[1]["name"] == "" and Lrose[1]["times"] == "10000000000" then
            love.graphics.print("1. ****",10,30)
          else
            love.graphics.print("1. "..Lrose[1]["name"].." : "..Lrose[1]["times"],10,30)
          end 

          if Lrose[2]["name"] == "" and Lrose[2]["times"] == "10000000000" then
            love.graphics.print("2. ****",10,40)
          else
            love.graphics.print("2. "..Lrose[2]["name"].." : "..Lrose[2]["times"],10,40)
          end 

          if Lrose[3]["name"] == "" and Lrose[3]["times"] == "10000000000" then
            love.graphics.print("3. ****",10,50)
          else
            love.graphics.print("3. "..Lrose[3]["name"].." : "..Lrose[3]["times"],10,50)
          end 

          if Lrose[4]["name"] == "" and Lrose[4]["times"] == "10000000000" then
            love.graphics.print("4. ****",10,60)
          else
            love.graphics.print("4. "..Lrose[4]["name"].." : "..Lrose[4]["times"],10,60)
          end 

          if Lrose[5]["name"] == "" and Lrose[5]["times"] == "10000000000" then
            love.graphics.print("5. ****",10,70)
          else
            love.graphics.print("5. "..Lrose[5]["name"].." : "..Lrose[5]["times"],10,70)
          end

          if Lrose[6]["name"] == "" and Lrose[6]["times"] == "10000000000" then
            love.graphics.print("6. ****",10,80)
          else
            love.graphics.print("6. "..Lrose[6]["name"].." : "..Lrose[6]["times"],10,80)
          end

          if Lrose[7]["name"] == "" and Lrose[7]["times"] == "10000000000" then
            love.graphics.print("7. ****",10,90)
          else
            love.graphics.print("7. "..Lrose[7]["name"].." : "..Lrose[7]["times"],10,90)
          end

          if Lrose[8]["name"] == "" and Lrose[8]["times"] == "10000000000" then
            love.graphics.print("8. ****",10,100)
          else
            love.graphics.print("8. "..Lrose[8]["name"].." : "..Lrose[8]["times"],10,100)
          end


          if Lrose[9]["name"] == "" and Lrose[9]["times"] == "10000000000" then
            love.graphics.print("9. ****",10,110)
          else
            love.graphics.print("9. "..Lrose[9]["name"].." : "..Lrose[9]["times"],10,110)
          end


          if Lrose[10]["name"] == "" and Lrose[10]["times"] == "10000000000" then
            love.graphics.print("10. ****",10,120)
          else
            love.graphics.print("10. "..Lrose[10]["name"].." : "..Lrose[10]["times"],10,120)
          end


        elseif positionhorizontalClassement == 5 then

          -- LookFile_jaune()

          if Ljaune[1]["name"] == "" and Ljaune[1]["times"] == "10000000000" then
            love.graphics.print("1. ****",10,30)
          else
            love.graphics.print("1. "..Ljaune[1]["name"].." : "..Ljaune[1]["times"],10,30)
          end 

          if Ljaune[2]["name"] == "" and Ljaune[2]["times"] == "10000000000" then
            love.graphics.print("2. ****",10,40)
          else
            love.graphics.print("2. "..Ljaune[2]["name"].." : "..Ljaune[2]["times"],10,40)
          end 

          if Ljaune[3]["name"] == "" and Ljaune[3]["times"] == "10000000000" then
            love.graphics.print("3. ****",10,50)
          else
            love.graphics.print("3. "..Ljaune[3]["name"].." : "..Ljaune[3]["times"],10,50)
          end 

          if Ljaune[4]["name"] == "" and Ljaune[4]["times"] == "10000000000" then
            love.graphics.print("4. ****",10,60)
          else
            love.graphics.print("4. "..Ljaune[4]["name"].." : "..Ljaune[4]["times"],10,60)
          end 

          if Ljaune[5]["name"] == "" and Ljaune[5]["times"] == "10000000000" then
            love.graphics.print("5. ****",10,70)
          else
            love.graphics.print("5. "..Ljaune[5]["name"].." : "..Ljaune[5]["times"],10,70)
          end

          if Ljaune[6]["name"] == "" and Ljaune[6]["times"] == "10000000000" then
            love.graphics.print("6. ****",10,80)
          else
            love.graphics.print("6. "..Ljaune[6]["name"].." : "..Ljaune[6]["times"],10,80)
          end

          if Ljaune[7]["name"] == "" and Ljaune[7]["times"] == "10000000000" then
            love.graphics.print("7. ****",10,90)
          else
            love.graphics.print("7. "..Ljaune[7]["name"].." : "..Ljaune[7]["times"],10,90)
          end

          if Ljaune[8]["name"] == "" and Ljaune[8]["times"] == "10000000000" then
            love.graphics.print("8. ****",10,100)
          else
            love.graphics.print("8. "..Ljaune[8]["name"].." : "..Ljaune[8]["times"],10,100)
          end


          if Ljaune[9]["name"] == "" and Ljaune[9]["times"] == "10000000000" then
            love.graphics.print("9. ****",10,110)
          else
            love.graphics.print("9. "..Ljaune[9]["name"].." : "..Ljaune[9]["times"],10,110)
          end


          if Ljaune[10]["name"] == "" and Ljaune[10]["times"] == "10000000000" then
            love.graphics.print("10. ****",10,120)
          else
            love.graphics.print("10. "..Ljaune[10]["name"].." : "..Ljaune[10]["times"],10,120)
          end
        end

      else

        ChangeColor("<--[ %2ECHAP%0 ] " ,10,10)
        ChangeColor("%1HORS LIGNE%0 ",((love.graphics.getWidth()/3.7)/3),4)
        ChangeColor("< %2Classement%0 "..NomClassement.." >", ((800/3.5)/3),10)

        if positionhorizontalClassement == 1 then

          --LookFile_original()

          if Loriginal[1]["name"] == "" and Loriginal[1]["times"] == "10000000000" then
            love.graphics.print("1. ****",10,30)
          else
            love.graphics.print("1. "..Loriginal[1]["name"].." : "..Loriginal[1]["times"],10,30)
          end 

          if Loriginal[2]["name"] == "" and Loriginal[2]["times"] == "10000000000" then
            love.graphics.print("2. ****",10,40)
          else
            love.graphics.print("2. "..Loriginal[2]["name"].." : "..Loriginal[2]["times"],10,40)
          end 

          if Loriginal[3]["name"] == "" and Loriginal[3]["times"] == "10000000000" then
            love.graphics.print("3. ****",10,50)
          else
            love.graphics.print("3. "..Loriginal[3]["name"].." : "..Loriginal[3]["times"],10,50)
          end 

          if Loriginal[4]["name"] == "" and Loriginal[4]["times"] == "10000000000" then
            love.graphics.print("4. ****",10,60)
          else
            love.graphics.print("4. "..Loriginal[4]["name"].." : "..Loriginal[4]["times"],10,60)
          end 

          if Loriginal[5]["name"] == "" and Loriginal[5]["times"] == "10000000000" then
            love.graphics.print("5. ****",10,70)
          else
            love.graphics.print("5. "..Loriginal[5]["name"].." : "..Loriginal[5]["times"],10,70)
          end

          if Loriginal[6]["name"] == "" and Loriginal[6]["times"] == "10000000000" then
            love.graphics.print("6. ****",10,80)
          else
            love.graphics.print("6. "..Loriginal[6]["name"].." : "..Loriginal[6]["times"],10,80)
          end

          if Loriginal[7]["name"] == "" and Loriginal[7]["times"] == "10000000000" then
            love.graphics.print("7. ****",10,90)
          else
            love.graphics.print("7. "..Loriginal[7]["name"].." : "..Loriginal[7]["times"],10,90)
          end

          if Loriginal[8]["name"] == "" and Loriginal[8]["times"] == "10000000000" then
            love.graphics.print("8. ****",10,100)
          else
            love.graphics.print("8. "..Loriginal[8]["name"].." : "..Loriginal[8]["times"],10,100)
          end


          if Loriginal[9]["name"] == "" and Loriginal[9]["times"] == "10000000000" then
            love.graphics.print("9. ****",10,110)
          else
            love.graphics.print("9. "..Loriginal[9]["name"].." : "..Loriginal[9]["times"],10,110)
          end


          if Loriginal[10]["name"] == "" and Loriginal[10]["times"] == "10000000000" then
            love.graphics.print("10. ****",10,120)
          else
            love.graphics.print("10. "..Loriginal[10]["name"].." : "..Loriginal[10]["times"],10,120)
          end

        elseif positionhorizontalClassement == 2 then

          --LookFile_originalV()

          if LoriginalV[1]["name"] == "" and LoriginalV[1]["times"] == "10000000000" then
            love.graphics.print("1. ****",10,30)
          else
            love.graphics.print("1. "..LoriginalV[1]["name"].." : "..LoriginalV[1]["times"],10,30)
          end 

          if LoriginalV[2]["name"] == "" and LoriginalV[2]["times"] == "10000000000" then
            love.graphics.print("2. ****",10,40)
          else
            love.graphics.print("2. "..LoriginalV[2]["name"].." : "..LoriginalV[2]["times"],10,40)
          end 

          if LoriginalV[3]["name"] == "" and LoriginalV[3]["times"] == "10000000000" then
            love.graphics.print("3. ****",10,50)
          else
            love.graphics.print("3. "..LoriginalV[3]["name"].." : "..LoriginalV[3]["times"],10,50)
          end 

          if LoriginalV[4]["name"] == "" and LoriginalV[4]["times"] == "10000000000" then
            love.graphics.print("4. ****",10,60)
          else
            love.graphics.print("4. "..LoriginalV[4]["name"].." : "..LoriginalV[4]["times"],10,60)
          end 

          if LoriginalV[5]["name"] == "" and LoriginalV[5]["times"] == "10000000000" then
            love.graphics.print("5. ****",10,70)
          else
            love.graphics.print("5. "..LoriginalV[5]["name"].." : "..LoriginalV[5]["times"],10,70)
          end

          if LoriginalV[6]["name"] == "" and LoriginalV[6]["times"] == "10000000000" then
            love.graphics.print("6. ****",10,80)
          else
            love.graphics.print("6. "..LoriginalV[6]["name"].." : "..LoriginalV[6]["times"],10,80)
          end

          if LoriginalV[7]["name"] == "" and LoriginalV[7]["times"] == "10000000000" then
            love.graphics.print("7. ****",10,90)
          else
            love.graphics.print("7. "..LoriginalV[7]["name"].." : "..LoriginalV[7]["times"],10,90)
          end

          if LoriginalV[8]["name"] == "" and LoriginalV[8]["times"] == "10000000000" then
            love.graphics.print("8. ****",10,100)
          else
            love.graphics.print("8. "..LoriginalV[8]["name"].." : "..LoriginalV[8]["times"],10,100)
          end


          if LoriginalV[9]["name"] == "" and LoriginalV[9]["times"] == "10000000000" then
            love.graphics.print("9. ****",10,110)
          else
            love.graphics.print("9. "..LoriginalV[9]["name"].." : "..LoriginalV[9]["times"],10,110)
          end


          if LoriginalV[10]["name"] == "" and LoriginalV[10]["times"] == "10000000000" then
            love.graphics.print("10. ****",10,120)
          else
            love.graphics.print("10. "..LoriginalV[10]["name"].." : "..LoriginalV[10]["times"],10,120)
          end



        elseif positionhorizontalClassement == 3 then

          --LookFile_rouge()

          if Lrouge[1]["name"] == "" and Lrouge[1]["times"] == "10000000000" then
            love.graphics.print("1. ****",10,30)
          else
            love.graphics.print("1. "..Lrouge[1]["name"].." : "..Lrouge[1]["times"],10,30)
          end 

          if Lrouge[2]["name"] == "" and Lrouge[2]["times"] == "10000000000" then
            love.graphics.print("2. ****",10,40)
          else
            love.graphics.print("2. "..Lrouge[2]["name"].." : "..Lrouge[2]["times"],10,40)
          end 

          if Lrouge[3]["name"] == "" and Lrouge[3]["times"] == "10000000000" then
            love.graphics.print("3. ****",10,50)
          else
            love.graphics.print("3. "..Lrouge[3]["name"].." : "..Lrouge[3]["times"],10,50)
          end 

          if Lrouge[4]["name"] == "" and Lrouge[4]["times"] == "10000000000" then
            love.graphics.print("4. ****",10,60)
          else
            love.graphics.print("4. "..Lrouge[4]["name"].." : "..Lrouge[4]["times"],10,60)
          end 

          if Lrouge[5]["name"] == "" and Lrouge[5]["times"] == "10000000000" then
            love.graphics.print("5. ****",10,70)
          else
            love.graphics.print("5. "..Lrouge[5]["name"].." : "..Lrouge[5]["times"],10,70)
          end

          if Lrouge[6]["name"] == "" and Lrouge[6]["times"] == "10000000000" then
            love.graphics.print("6. ****",10,80)
          else
            love.graphics.print("6. "..Lrouge[6]["name"].." : "..Lrouge[6]["times"],10,80)
          end

          if Lrouge[7]["name"] == "" and Lrouge[7]["times"] == "10000000000" then
            love.graphics.print("7. ****",10,90)
          else
            love.graphics.print("7. "..Lrouge[7]["name"].." : "..Lrouge[7]["times"],10,90)
          end

          if Lrouge[8]["name"] == "" and Lrouge[8]["times"] == "10000000000" then
            love.graphics.print("8. ****",10,100)
          else
            love.graphics.print("8. "..Lrouge[8]["name"].." : "..Lrouge[8]["times"],10,100)
          end


          if Lrouge[9]["name"] == "" and Lrouge[9]["times"] == "10000000000" then
            love.graphics.print("9. ****",10,110)
          else
            love.graphics.print("9. "..Lrouge[9]["name"].." : "..Lrouge[9]["times"],10,110)
          end


          if Lrouge[10]["name"] == "" and Lrouge[10]["times"] == "10000000000" then
            love.graphics.print("10. ****",10,120)
          else
            love.graphics.print("10. "..Lrouge[10]["name"].." : "..Lrouge[10]["times"],10,120)
          end



        elseif positionhorizontalClassement == 4 then

          -- LookFile_rose()

          if Lrose[1]["name"] == "" and Lrose[1]["times"] == "10000000000" then
            love.graphics.print("1. ****",10,30)
          else
            love.graphics.print("1. "..Lrose[1]["name"].." : "..Lrose[1]["times"],10,30)
          end 

          if Lrose[2]["name"] == "" and Lrose[2]["times"] == "10000000000" then
            love.graphics.print("2. ****",10,40)
          else
            love.graphics.print("2. "..Lrose[2]["name"].." : "..Lrose[2]["times"],10,40)
          end 

          if Lrose[3]["name"] == "" and Lrose[3]["times"] == "10000000000" then
            love.graphics.print("3. ****",10,50)
          else
            love.graphics.print("3. "..Lrose[3]["name"].." : "..Lrose[3]["times"],10,50)
          end 

          if Lrose[4]["name"] == "" and Lrose[4]["times"] == "10000000000" then
            love.graphics.print("4. ****",10,60)
          else
            love.graphics.print("4. "..Lrose[4]["name"].." : "..Lrose[4]["times"],10,60)
          end 

          if Lrose[5]["name"] == "" and Lrose[5]["times"] == "10000000000" then
            love.graphics.print("5. ****",10,70)
          else
            love.graphics.print("5. "..Lrose[5]["name"].." : "..Lrose[5]["times"],10,70)
          end

          if Lrose[6]["name"] == "" and Lrose[6]["times"] == "10000000000" then
            love.graphics.print("6. ****",10,80)
          else
            love.graphics.print("6. "..Lrose[6]["name"].." : "..Lrose[6]["times"],10,80)
          end

          if Lrose[7]["name"] == "" and Lrose[7]["times"] == "10000000000" then
            love.graphics.print("7. ****",10,90)
          else
            love.graphics.print("7. "..Lrose[7]["name"].." : "..Lrose[7]["times"],10,90)
          end

          if Lrose[8]["name"] == "" and Lrose[8]["times"] == "10000000000" then
            love.graphics.print("8. ****",10,100)
          else
            love.graphics.print("8. "..Lrose[8]["name"].." : "..Lrose[8]["times"],10,100)
          end


          if Lrose[9]["name"] == "" and Lrose[9]["times"] == "10000000000" then
            love.graphics.print("9. ****",10,110)
          else
            love.graphics.print("9. "..Lrose[9]["name"].." : "..Lrose[9]["times"],10,110)
          end


          if Lrose[10]["name"] == "" and Lrose[10]["times"] == "10000000000" then
            love.graphics.print("10. ****",10,120)
          else
            love.graphics.print("10. "..Lrose[10]["name"].." : "..Lrose[10]["times"],10,120)
          end


        elseif positionhorizontalClassement == 5 then

          --LookFile_jaune()

          if Ljaune[1]["name"] == "" and Ljaune[1]["times"] == "10000000000" then
            love.graphics.print("1. ****",10,30)
          else
            love.graphics.print("1. "..Ljaune[1]["name"].." : "..Ljaune[1]["times"],10,30)
          end 

          if Ljaune[2]["name"] == "" and Ljaune[2]["times"] == "10000000000" then
            love.graphics.print("2. ****",10,40)
          else
            love.graphics.print("2. "..Ljaune[2]["name"].." : "..Ljaune[2]["times"],10,40)
          end 

          if Ljaune[3]["name"] == "" and Ljaune[3]["times"] == "10000000000" then
            love.graphics.print("3. ****",10,50)
          else
            love.graphics.print("3. "..Ljaune[3]["name"].." : "..Ljaune[3]["times"],10,50)
          end 

          if Ljaune[4]["name"] == "" and Ljaune[4]["times"] == "10000000000" then
            love.graphics.print("4. ****",10,60)
          else
            love.graphics.print("4. "..Ljaune[4]["name"].." : "..Ljaune[4]["times"],10,60)
          end 

          if Ljaune[5]["name"] == "" and Ljaune[5]["times"] == "10000000000" then
            love.graphics.print("5. ****",10,70)
          else
            love.graphics.print("5. "..Ljaune[5]["name"].." : "..Ljaune[5]["times"],10,70)
          end

          if Ljaune[6]["name"] == "" and Ljaune[6]["times"] == "10000000000" then
            love.graphics.print("6. ****",10,80)
          else
            love.graphics.print("6. "..Ljaune[6]["name"].." : "..Ljaune[6]["times"],10,80)
          end

          if Ljaune[7]["name"] == "" and Ljaune[7]["times"] == "10000000000" then
            love.graphics.print("7. ****",10,90)
          else
            love.graphics.print("7. "..Ljaune[7]["name"].." : "..Ljaune[7]["times"],10,90)
          end

          if Ljaune[8]["name"] == "" and Ljaune[8]["times"] == "10000000000" then
            love.graphics.print("8. ****",10,100)
          else
            love.graphics.print("8. "..Ljaune[8]["name"].." : "..Ljaune[8]["times"],10,100)
          end


          if Ljaune[9]["name"] == "" and Ljaune[9]["times"] == "10000000000" then
            love.graphics.print("9. ****",10,110)
          else
            love.graphics.print("9. "..Ljaune[9]["name"].." : "..Ljaune[9]["times"],10,110)
          end


          if Ljaune[10]["name"] == "" and Ljaune[10]["times"] == "10000000000" then
            love.graphics.print("10. ****",10,120)
          else
            love.graphics.print("10. "..Ljaune[10]["name"].." : "..Ljaune[10]["times"],10,120)
          end

        end

      end



    end



  end

  if afficheOptions == false and afficheMenu == true and afficheMainMenu == false and afficheSelectVirus == false and afficheClassement == false and afficheFin == true then
    love.graphics.draw(imgBackground,1,1,0,love.graphics.getWidth()/32,love.graphics.getHeight()/32)
    love.graphics.setColor(255,255,255)
    love.graphics.scale(4,4)
    if check_fullscreen == true then



      if b == nil then


        if language == "english" then

          love.graphics.print("Not Internet...",love.graphics.getWidth()/10,((love.graphics.getHeight()/4)/4))
          love.graphics.print("Press enter for put your time in L_Offline",(love.graphics.getWidth()/11)/2,((love.graphics.getHeight()/3)/4))

          love.graphics.setColor(0,255,0)
          love.graphics.printf("Your name : "..pseudo, (love.graphics.getWidth()/9.5)/2, 125,(love.graphics.getWidth()/4)/2,"center")
          love.graphics.setColor(255,255,255)
          love.graphics.print("Your time :   "..string.format("%f",yourTime).."  s", (love.graphics.getWidth()/6.5)/2, 20)

        elseif language == "french" then

          love.graphics.print("Pas internet...",love.graphics.getWidth()/10,((love.graphics.getHeight()/4)/4))
          love.graphics.print("Pressez entrée pour mettre votre temps dans le C_Horsligne",(love.graphics.getWidth()/25)/2,((love.graphics.getHeight()/3)/4))

          love.graphics.setColor(0,255,0)
          love.graphics.printf("Votre pseudo : "..pseudo, (love.graphics.getWidth()/9.5)/2, 125,(love.graphics.getWidth()/4)/2,"center")
          love.graphics.setColor(255,255,255)
          love.graphics.print("Votre temps :   "..string.format("%f",yourTime).."  s", (love.graphics.getWidth()/6.5)/2, 10)

        end

      else

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
    else




      if b == nil then


        if language == "english" then

          love.graphics.print("Not Internet...",love.graphics.getWidth()/13 ,((love.graphics.getHeight()/4)/4))
          love.graphics.printf("Write and press enter for put your time in L_Offline",(love.graphics.getWidth()/30)/1,((love.graphics.getHeight()/3)/4),150,"center")

          love.graphics.setColor(0,255,0)
          love.graphics.printf("Your name : "..pseudo, 10, 125, love.graphics.getWidth())
          love.graphics.setColor(255,255,255)
          love.graphics.print("Your time :   "..string.format("%f",yourTime).."  s", 10, 10)

        elseif language == "french" then

          love.graphics.print("Pas internet...",love.graphics.getWidth()/13,((love.graphics.getHeight()/4)/4))
          love.graphics.printf("Pressez entrée pour mettre votre temps dans le C_Horsligne",(love.graphics.getWidth()/30)/1,((love.graphics.getHeight()/3)/4),150,"center")

          love.graphics.setColor(0,255,0)
          love.graphics.printf("Votre pseudo : "..pseudo, 10, 125, love.graphics.getWidth())
          love.graphics.setColor(255,255,255)
          love.graphics.print("Votre temps :   "..string.format("%f",yourTime).."  s", 10, 10)

        end

      else

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

    end

  end

  -- SC

  if afficheS == true then


  end

  -- MENU OPTIONS
  if afficheOptions == true and afficheMenu == true and afficheMainMenu == false and afficheSelectVirus == false and afficheClassement == false and afficheFin == false then

    love.graphics.draw(imgBackground,1,1,0,love.graphics.getWidth()/32,love.graphics.getHeight()/32)
    love.graphics.scale(4,4)

    if language == "english" then

      if check_fullscreen == true then
        love.graphics.print("SETTINGS", ((love.graphics.getWidth()/2)/4),love.graphics.getHeight()/25,0,1.1,1.1,25,12/2)
        love.graphics.translate(love.graphics.getWidth()/20,love.graphics.getHeight()/40)
        ChangeColor("<--[ %2ESC%0 ] ", 1,1)
      else
        love.graphics.print("SETTINGS", ((love.graphics.getWidth()/2)/4),10,0,1,1,12,3/2)
        ChangeColor("<--[ %2ESC%0 ] ", 10,10)
      end


      ChangeColor("Language : [ %2"..tradlanguage.."%0 ]", menuOptions.langue.x,menuOptions.langue.y)
      ChangeColor("Controls : [ %2"..tradControls.."%0 ]", menuOptions.controls.x,menuOptions.controls.y) 

      if tonumber(musicVolume) == 0 or tonumber(musicVolume) == 1 then
        ChangeColor("Musics Volume : [ %2"..musicVolume.."%0 ]", menuOptions.musics.x,menuOptions.musics.y) 
      else
        ChangeColor("Musics Volume : [ %2"..string.format("%.2f",musicVolume).."%0 ]", menuOptions.musics.x,menuOptions.musics.y)
      end

      if tonumber(soundVolume) == 0 or tonumber(soundVolume) == 1 then 
        ChangeColor("Sounds Volume : [ %2"..soundVolume.."%0 ]", menuOptions.sounds.x,menuOptions.sounds.y) 
      else
        ChangeColor("Sounds Volume : [ %2"..string.format("%.2f",soundVolume).."%0 ]", menuOptions.sounds.x,menuOptions.sounds.y)
      end
      ChangeColor("%3Apply%0 ", menuOptions.apply.x,menuOptions.apply.y) 

      love.graphics.draw(curseurmenu.sprite, curseurmenu.x, curseurmenu.y)

    elseif language == "french" then


      if check_fullscreen == true then
        love.graphics.print("OPTIONS", ((love.graphics.getWidth()/2)/4),love.graphics.getHeight()/25,0,1.1,1.1,25,12/2)
        love.graphics.translate(love.graphics.getWidth()/20,love.graphics.getHeight()/40)
        ChangeColor("<--[ %2ECHAP%0 ] ", 1,1)
      else
        love.graphics.print("OPTIONS", ((love.graphics.getWidth()/2)/4),10,0,1,1,12,3/2)
        ChangeColor("<--[ %2ECHAP%0 ] ", 10,10)
      end


      ChangeColor("Langue : [ %2"..tradlanguage.."%0 ]", menuOptions.langue.x,menuOptions.langue.y)
      ChangeColor("Controles : [ %2"..tradControls.."%0 ]", menuOptions.controls.x,menuOptions.controls.y) 

      if tonumber(musicVolume) == 0 or tonumber(musicVolume) == 1 then
        ChangeColor("Volumes des musiques : [ %2"..musicVolume.."%0 ]", menuOptions.musics.x,menuOptions.musics.y) 
      else
        ChangeColor("Volumes des musiques : [ %2"..string.format("%.2f",musicVolume).."%0 ]", menuOptions.musics.x,menuOptions.musics.y) 
      end

      if tonumber(soundVolume) == 0 or tonumber(soundVolume) == 1 then
        ChangeColor("Volumes des bruitages : [ %2"..soundVolume.."%0 ]", menuOptions.sounds.x,menuOptions.sounds.y) 
      else
        ChangeColor("Volumes des bruitages : [ %2"..string.format("%.2f",soundVolume).."%0 ]", menuOptions.sounds.x,menuOptions.sounds.y) 
      end

      ChangeColor("%3Appliquer%0", menuOptions.apply.x,menuOptions.apply.y) 
      love.graphics.draw(curseurmenu.sprite, curseurmenu.x, curseurmenu.y)


    end



  end

  if cam_active == true then

    

    if check_fullscreen == true then
      love.graphics.translate(love.graphics.getWidth()/3.7, love.graphics.getHeight()/5)
    end
    camera:set()

    
    local colonne
    local ligne

    if afficheMenu == false and afficheS == false then

      if activeTimer == false then
        love.graphics.setFont(_fontGame)
      end


      for ligne=0,59 do

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

      --love.graphics.print("Nombre de tirs = "..#liste_tirs,camera.x+87,camera.y+55,0,0.5)

      love.graphics.draw(spawn.depart.sprite, spawn.depart.x, spawn.depart.y)
      --love.graphics.draw(spawn.fin.sprite, spawn.fin.x, spawn.fin.y)
      --love.graphics.draw(bonus.speed.sprite, bonus.speed.x , bonus.speed.y)

      --love.graphics.circle("fill", player.x+8, player.y+8, 8, 100)

      
      love.graphics.setColor(200, 0, 0)
      psystem_explosion_draw()
      love.graphics.setColor(255, 255, 255)
      if SelectVirusP == "rouge" then
        love.graphics.setColor(255, 0, 0)
        if player.affiche == true then
          love.graphics.draw(psystem,player.x+8,player.y+8)
        end
      elseif SelectVirusP == "jaune" then
        love.graphics.setColor(255, 255, 0)
        if player.affiche == true then
          love.graphics.draw(psystem,player.x+8,player.y+8)
        end
        psystem_explosion_draw()
        
      elseif SelectVirusP == "originalV" then
        love.graphics.setColor(255, 255, 255)
        
        if player.affiche == true then
          love.graphics.draw(psystem,player.x+8,player.y+8)
        end
        
      elseif SelectVirusP == "original" then
        love.graphics.setColor(255, 255, 255)
        if player.affiche == true then
        love.graphics.draw(psystem,player.x+8,player.y+8)
      end
      
      elseif SelectVirusP == "rose" then
        love.graphics.setColor(255, 0, 255)
        if player.affiche == true then
        love.graphics.draw(psystem,player.x+8,player.y+8)
        end
      end
      love.graphics.setColor(255, 255, 255)
    
      if player.affiche == true then
        love.graphics.draw(playerStart, player.x, player.y)
      end
      
      if Niveau == 2 then
        if bossdead == false then
          
          love.graphics.draw(miniboss1.start, miniboss1.x, miniboss1.y)
        end
      end
      love.graphics.setColor(0,255,249)
      psystem_explosion_boss_draw()
      love.graphics.setColor(255, 255, 255)
      --love.graphics.draw(psystem_explosion, explosion.x, explosion.y)
      --love.graphics.draw(IA.sprite, IA.x, IA.y)
      --love.graphics.circle("fill", tower1.circle.x, tower1.circle.y, 75, 100)




      if tower1.x < player.x+153 and tower1.x > player.x-137 and tower1.y < player.y+93 and tower1.y > player.y-77 then
        love.graphics.draw(tower1.sprite, tower1.x, tower1.y,tower1.rotation,1,1,16/2,16/2)
      end
      --love.graphics.circle("fill", tower2.circle.x, tower2.circle.y, 75, 100)

      if tower2.x < player.x+153 and tower2.x > player.x-137 and tower2.y < player.y+93 and tower2.y > player.y-77 then
        love.graphics.draw(tower2.sprite, tower2.x, tower2.y,tower2.rotation,1,1,16/2,16/2)
      end

      if tower3.x < player.x+153 and tower3.x > player.x-137 and tower3.y < player.y+93 and tower3.y > player.y-77 then
        love.graphics.draw(tower3.sprite, tower3.x, tower3.y,tower3.rotation,1,1,16/2,16/2)
      end

      if tower4.x < player.x+153 and tower4.x > player.x-137 and tower4.y < player.y+93 and tower4.y > player.y-77 then
        love.graphics.draw(tower4.sprite, tower4.x, tower4.y,tower4.rotation,1,1,16/2,16/2)
      end

      if tower5.x < player.x+153 and tower5.x > player.x-137 and tower5.y < player.y+93 and tower5.y > player.y-77 then
        love.graphics.draw(tower5.sprite, tower5.x, tower5.y,tower5.rotation,1,1,16/2,16/2)
      end

      if tower6.x < player.x+153 and tower6.x > player.x-137 and tower6.y < player.y+93 and tower6.y > player.y-77 then
        love.graphics.draw(tower6.sprite, tower6.x, tower6.y,tower6.rotation,1,1,16/2,16/2)
      end

      if piege.bougeVertical1.x < player.x+153 and piege.bougeVertical1.x > player.x-145 and piege.bougeVertical1.y < player.y+93 and piege.bougeVertical1.y > player.y-77 then
        love.graphics.draw(piege.bougeVertical1.sprite,piege.bougeVertical1.x,piege.bougeVertical1.y)
      end

      if piege.bougeVertical2.x < player.x+145 and piege.bougeVertical2.x > player.x-145 and piege.bougeVertical2.y < player.y+93 and piege.bougeVertical2.y > player.y-77 then
        love.graphics.draw(piege.bougeVertical2.sprite,piege.bougeVertical2.x,piege.bougeVertical2.y)
      end

      if piege.bougeHorizontal1.x < player.x+145 and piege.bougeHorizontal1.x > player.x-145 and piege.bougeHorizontal1.y < player.y+93 and piege.bougeHorizontal1.y > player.y-85 then
        love.graphics.draw(piege.bougeHorizontal1.sprite,piege.bougeHorizontal1.x,piege.bougeHorizontal1.y)
      end


      local n
      for n=1,#liste_sprites do
        local s = liste_sprites[n]

      --  if s.x < player.x+143 and s.x > player.x-127 and s.y < player.y+87 and s.y > player.y-73 then
          love.graphics.draw(s.sprite, s.x, s.y, 0, 1.5, 1.5, s.l/2, s.h/2)
       -- end
      end
      

      if balayageVertical.active == true then
        love.graphics.setColor(255,0,0)
        love.graphics.rectangle("line",balayageVertical.x,balayageVertical.y,1,1000)
        love.graphics.setColor(255,255,255)
      elseif balayageHorizontal.active == true then
        love.graphics.setColor(255,0,0)
        love.graphics.rectangle("line",balayageHorizontal.x,balayageHorizontal.y,1200,1)
        love.graphics.setColor(255,255,255)
      end



      -- HUD
      if gameOver == false and activeTimer == false then 
       
       
       
        -- ENGLISH
        if language == "english" then

          if afficheSecret1Debloque == true then
            love.graphics.setColor(0,255,0)
            love.graphics.print("NEW VIRUS AVAILABLE !",camera.x+50, camera.y+50,0,0.5)
            love.graphics.setColor(255,255,255)
          end

          if afficheSecret2Debloque == true then
            love.graphics.setColor(0,255,0)
            love.graphics.print("MEGALOVANIA REMIX !",camera.x+50, camera.y+50,0,0.5)
            love.graphics.setColor(255,255,255)
          end

          love.graphics.setColor(255,255,255)
          
          love.graphics.print("Time :  "..string.format("%f",timer).." s",camera.x+59, camera.y+5,0,0.5)
          if Niveau == 2 then
            love.graphics.setColor(255,0,0)
            love.graphics.rectangle("fill", miniboss1.x, miniboss1.y-5, bosslife, 2 )
            love.graphics.setColor(255,255,255)
          end
          love.graphics.setColor(255,255,255)


         -- love.graphics.print("Version Alpha 0.40",camera.x+60, camera.y+140,0,0.5)

          
          if Niveau == 1 then
            
            if SelectVirusP == "rouge" or SelectVirusP == "originalV" or SelectVirusP == "jaune" or SelectVirusP == "original" and Niveau == 1 then
              love.graphics.print("Scan : "..string.format("%i",scanTime),camera.x+5, camera.y+5,0,0.5)
            end
            
          end

        end

        -- FRENCH
        if language == "french" then

          if afficheSecret1Debloque == true then
            love.graphics.setColor(0,255,0)
            love.graphics.print("NOUVEAU VIRUS DISPONIBLE !",camera.x+50, camera.y+50,0,0.5)
            love.graphics.setColor(255,255,255)
          end

          if afficheSecret2Debloque == true then
            love.graphics.setColor(0,255,0)
            love.graphics.print("MEGALOVANIA REMIX !",camera.x+50, camera.y+50,0,0.5)
            love.graphics.setColor(255,255,255)
          end

          love.graphics.print("Temps :  "..string.format("%f",timer).." s",camera.x+59, camera.y+5,0,0.5)
          
          if Niveau == 2 then
            love.graphics.setColor(255,0,0)
            love.graphics.rectangle("fill", miniboss1.x, miniboss1.y-5, bosslife, 2 )
            love.graphics.setColor(255,255,255)
          end
          love.graphics.print(""..winwrite,miniboss1.x, miniboss1.y,0,0.5)
          
          love.graphics.setColor(255,255,255)


          --love.graphics.print("Version Alpha 0.40",camera.x+60, camera.y+140,0,0.5)

          --[[
          if afficheUprades == true and pointCompetence > 0 then
            
            --love.graphics.print("+ [1] SPEED"..player.speed,camera.x+40, camera.y+100,0,0.5)
            
            love.graphics.draw(hud.button.upgrades.vitesse.sprite,camera.x+49,camera.y+90)
            love.graphics.draw(hud.button.upgrades.vitesse.barre,camera.x+55,camera.y+130)
            
            love.graphics.draw(hud.button.upgrades.vie.sprite,camera.x+99,camera.y+90)
            
            
           
            
        
          end
          --]]
          
          if Niveau == 1 then
            
            if SelectVirusP == "rouge" or SelectVirusP == "originalV" or SelectVirusP == "jaune" or SelectVirusP == "original" then
              love.graphics.print("Scan : "..string.format("%i",scanTime),camera.x+5, camera.y+5,0,0.5)
            end
            
          end
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

    --love.graphics.draw(vision, player.x-40,player.y,0,0.6,0.6,visionl/2,visionh/2)
    if player.life == 1 then
     love.graphics.draw(hud.coeur.sprite,camera.x,camera.y+140)
   
     
    elseif player.life == 2 then
      love.graphics.draw(hud.coeur.sprite,camera.x,camera.y+140)
      love.graphics.draw(hud.coeur.sprite,camera.x+9,camera.y+140)

    elseif player.life == 3 then
      love.graphics.draw(hud.coeur.sprite,camera.x,camera.y+140)
      love.graphics.draw(hud.coeur.sprite,camera.x+9,camera.y+140)
      love.graphics.draw(hud.coeur.sprite,camera.x+18,camera.y+140)
    
    elseif player.life == 4 then
      love.graphics.draw(hud.coeur.sprite,camera.x,camera.y+140)
      love.graphics.draw(hud.coeur.sprite,camera.x+9,camera.y+140)
      love.graphics.draw(hud.coeur.sprite,camera.x+18,camera.y+140)
      love.graphics.draw(hud.coeur.sprite,camera.x+27,camera.y+140)
    
    elseif player.life == 5 then
      love.graphics.draw(hud.coeur.sprite,camera.x,camera.y+140)
      love.graphics.draw(hud.coeur.sprite,camera.x+9,camera.y+140)
      love.graphics.draw(hud.coeur.sprite,camera.x+18,camera.y+140)
      love.graphics.draw(hud.coeur.sprite,camera.x+27,camera.y+140)
      love.graphics.draw(hud.coeur.sprite,camera.x+36,camera.y+140)
     
    end
    camera:unset()
  end
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
    local byteoffset2 = utf8.offset(winwrite, -1)
    if byteoffset then
      -- remove the last UTF-8 character.
      -- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
      pseudo = string.sub(pseudo, 1, byteoffset - 1)
     
      
      
      love.audio.play(back)
      limit_caractere = limit_caractere - 1
      
    elseif byteoffset2 then
      winwrite = string.sub(winwrite, 1, byteoffset2 - 1)
      love.audio.play(back)
    end
  end

  if afficheMenu == true then





  end

  if key == "f1" then




    love.window.setFullscreen(false)
    check_fullscreen = love.window.getFullscreen()
    print(check_fullscreen)
  end

  if key == "f2" then

    love.window.setFullscreen(true)
    check_fullscreen = love.window.getFullscreen()
    print(check_fullscreen)
  end

-- MENU PRINCIPAL
  if afficheMainMenu == true and afficheOptions == false and afficheSelectVirus == false and afficheClassement == false and afficheClassementOffline == false then


    if key == "escape" then 

      love.event.quit()
    end


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

        MenuMusic:stop()

        Leaderboard()


      end
    end

    if positioncurseur == 4 then

      if key == "return" then

        LeaderboardOffline()

      end
    end

    if positioncurseur == 5 then

      if key == "return" then

        love.audio.play(select2)
        love.event.quit()
        love.filesystem.write("language.lua","language\n=\n" ..language)
        love.filesystem.write("controls.lua","controls\n=\n" ..moveControls)
        love.filesystem.write("sound.lua","soundVolume\n=\n"..soundVolume .."\n\nmusicVolume\n=\n"..musicVolume)

      end
    end
  end

  if afficheCredits == true then
    
     if key == "escape" then 

      MainMenu()
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

  -- CLASSEMENT ONLINE
  if afficheMainMenu == false and afficheOptions == false and afficheSelectVirus == false and afficheClassement == true and afficheClassementOffline == false and afficheFin == false then


    if key == "escape" then
      MainMenu()
      love.audio.play(back)
      positioncurseur = 3
    end

    if key == "right" then

      positionhorizontalClassement = positionhorizontalClassement + 1
      love.audio.play(select3)

      if positionhorizontalClassement == 1 then 

        love.audio.stop(leaderboardMusic_nigiro)
        love.audio.play(leaderboardMusic)
        b, c, h = http.request("http://ver-infect.atspace.cc/110/getData_original.php")
        --b, c, h = http.request("http://127.0.0.1/getData_original.php")
      elseif positionhorizontalClassement == 2 then

        love.audio.stop(leaderboardMusic)
        love.audio.play(leaderboardMusic_nigiro)
        b, c, h = http.request("http://ver-infect.atspace.cc/110/getData_originalV.php")
        --b, c, h = http.request("http://127.0.0.1/getData_originalV.php")
      elseif positionhorizontalClassement == 3 then

        love.audio.stop(leaderboardMusic_rose)
        love.audio.play(leaderboardMusic)
        b, c, h = http.request("http://ver-infect.atspace.cc/110/getData_rouge.php")
        --b, c, h = http.request("http://127.0.0.1/getData_rouge.php")
      elseif positionhorizontalClassement == 4 then

        love.audio.play(leaderboardMusic_rose)
        love.audio.stop(leaderboardMusic)
        b, c, h = http.request("http://ver-infect.atspace.cc/110/getData_rose.php")
        --b, c, h = http.request("http://127.0.0.1/getData_rose.php")
      elseif positionhorizontalClassement == 5 then

        love.audio.stop(leaderboardMusic_rose)
        love.audio.play(leaderboardMusic_jaune)
        b, c, h = http.request("http://ver-infect.atspace.cc/110/getData_jaune.php")
        --b, c, h = http.request("http://127.0.0.1/getData_jaune.php")
      end



    end

    if key == "left" then

      positionhorizontalClassement = positionhorizontalClassement - 1
      love.audio.play(select3)

      if positionhorizontalClassement == 1 then 

        love.audio.stop(leaderboardMusic)
        love.audio.play(leaderboardMusic)
        b, c, h = http.request("http://ver-infect.atspace.cc/110/getData_original.php")
        --b, c, h = http.request("http://127.0.0.1/getData_original.php")

      elseif positionhorizontalClassement == 2 then


        love.audio.play(leaderboardMusic_nigiro)
        b, c, h = http.request("http://ver-infect.atspace.cc/110/getData_originalV.php")
        --b, c, h = http.request("http://127.0.0.1/getData_originalV.php")
      elseif positionhorizontalClassement == 3 then

        love.audio.stop(leaderboardMusic_rose)
        love.audio.play(leaderboardMusic)
        b, c, h = http.request("http://ver-infect.atspace.cc/110/getData_rouge.php")
        --b, c, h = http.request("http://127.0.0.1/getData_rouge.php")

      elseif positionhorizontalClassement == 4 then

        love.audio.play(leaderboardMusic_rose)
        love.audio.stop(leaderboardMusic)
        b, c, h = http.request("http://ver-infect.atspace.cc/110/getData_rose.php")
        --b, c, h = http.request("http://127.0.0.1/getData_rose.php")
      elseif positionhorizontalClassement == 5 then

        love.audio.stop(leaderboardMusic_rose)
        love.audio.play(leaderboardMusic_jaune)
        b, c, h = http.request("http://ver-infect.atspace.cc/110/getData_jaune.php")
        --b, c, h = http.request("http://127.0.0.1/getData_jaune.php")
      end



    end

  end

  -- CLASSEMENT OFFLINE
  if afficheMainMenu == false and afficheOptions == false and afficheSelectVirus == false and afficheClassement == false and afficheClassementOffline == true and afficheFin == false then


    if key == "escape" then
      MainMenu()
      love.audio.play(back)
      positioncurseur = 4
    end

    if key == "right" then

      positionhorizontalClassement = positionhorizontalClassement + 1
      love.audio.play(select3)






    end

    if key == "left" then

      positionhorizontalClassement = positionhorizontalClassement - 1
      love.audio.play(select3)

      if positionhorizontalClassement == 1 then 


        love.audio.play(leaderboardMusic)


      elseif positionhorizontalClassement == 2 then


        love.audio.play(leaderboardMusic_nigiro)


      elseif positionhorizontalClassement == 3 then

        love.audio.stop(leaderboardMusic_rose)
        love.audio.play(leaderboardMusic)


      elseif positionhorizontalClassement == 4 then

        love.audio.play(leaderboardMusic_rose)
        love.audio.stop(leaderboardMusic)


      elseif positionhorizontalClassement == 5 then

        love.audio.stop(leaderboardMusic_rose)
        love.audio.play(leaderboardMusic_jaune)

      end



    end

  end

  if afficheMainMenu == false and afficheOptions == false and afficheSelectVirus == false and afficheClassement == false and afficheFin == true then

 

    if key == "escape" then
      
      credit()
      love.audio.play(back)
    end

    if key == "return" then


      if b == nil then

        print("Nous allons mettre votre temps sur le classement hors ligne")

        if SelectVirusP == "original" then 
          PutInLeaderboardOffline_original()
          positionhorizontalClassement = 1
          LeaderboardOffline()
          credit()

        elseif SelectVirusP == "originalV" then
          PutInLeaderboardOffline_originalV()
          positionhorizontalClassement = 2
          LeaderboardOffline()
          credit()

        elseif SelectVirusP == "jaune" then
          PutInLeaderboardOffline_jaune()
          positionhorizontalClassement = 5
          LeaderboardOffline()
          credit()

        elseif SelectVirusP == "rose" then
          PutInLeaderboardOffline_rose()
          positionhorizontalClassement = 4
          LeaderboardOffline()
          credit()

        elseif SelectVirusP == "rouge" then
          PutInLeaderboardOffline_rouge()
          positionhorizontalClassement = 3
          LeaderboardOffline()
          credit()

      end
      
        print("Operation terminé")

      else

        if SelectVirusP == "original" then 

          response_body = {}
          request_body = "name="..pseudo.."&time="..yourTime
          socket.http.request {

            -- Merci a Jimmy Labodudev pour son aide
            url = "http://ver-infect.atspace.cc/110/saveData_original.php",
            method = "POST",
            headers = {

              ["Content-Length"] = string.len(request_body),
              ["Content-Type"] = "application/x-www-form-urlencoded"

            },
            source = ltn12.source.string(request_body),
            sink = ltn12.sink.table(response_body)
          }
          table.foreach(response_body,print)
          PutInLeaderboardOffline_original()
          positionhorizontalClassement = 1

        elseif SelectVirusP == "originalV" then 

          response_body = {}
          request_body = "name="..pseudo.."&time="..yourTime
          socket.http.request {

            -- Merci a Jimmy Labodudev pour son aide
            url = "http://ver-infect.atspace.cc/110/saveData_originalV.php",
            method = "POST",
            headers = {

              ["Content-Length"] = string.len(request_body),
              ["Content-Type"] = "application/x-www-form-urlencoded"

            },
            source = ltn12.source.string(request_body),
            sink = ltn12.sink.table(response_body)
          }
          table.foreach(response_body,print)
          PutInLeaderboardOffline_originalV()
          positionhorizontalClassement = 2
        elseif SelectVirusP == "rouge" then 

          response_body = {}
          request_body = "name="..pseudo.."&time="..yourTime
          socket.http.request {

            -- Merci a Jimmy Labodudev pour son aide
            url = "http://ver-infect.atspace.cc/110/saveData_rouge.php",
            method = "POST",
            headers = {

              ["Content-Length"] = string.len(request_body),
              ["Content-Type"] = "application/x-www-form-urlencoded"

            },
            source = ltn12.source.string(request_body),
            sink = ltn12.sink.table(response_body)
          }
          table.foreach(response_body,print)
          PutInLeaderboardOffline_rouge()
          positionhorizontalClassement = 3
        elseif SelectVirusP == "rose" then 

          response_body = {}
          request_body = "name="..pseudo.."&time="..yourTime
          socket.http.request {

            -- Merci a Jimmy Labodudev pour son aide
            url = "http://ver-infect.atspace.cc/110/saveData_rose.php",
            method = "POST",
            headers = {

              ["Content-Length"] = string.len(request_body),
              ["Content-Type"] = "application/x-www-form-urlencoded"

            },
            source = ltn12.source.string(request_body),
            sink = ltn12.sink.table(response_body)
          }
          table.foreach(response_body,print)
          PutInLeaderboardOffline_rose()
          positionhorizontalClassement = 4
        elseif SelectVirusP == "jaune" then 

          response_body = {}
          request_body = "name="..pseudo.."&time="..yourTime
          socket.http.request {

            -- Merci a Jimmy Labodudev pour son aide
            url = "http://ver-infect.atspace.cc/110/saveData_jaune.php",
            method = "POST",
            headers = {

              ["Content-Length"] = string.len(request_body),
              ["Content-Type"] = "application/x-www-form-urlencoded"

            },
            source = ltn12.source.string(request_body),
            sink = ltn12.sink.table(response_body)
          }
          table.foreach(response_body,print)
          PutInLeaderboardOffline_jaune()
          positionhorizontalClassement = 5
        end
        love.audio.play(puttime)

        credit()
      end


    end



end

if pointCompetence == 0 then
  afficheUpgrades = false
end

  if afficheUprades == true then
    
    if pointCompetence > 0 then
    
      --[[if key == "right" then
        positioncurseurUpgrades = positioncurseurUpgrades + 1
      elseif key == "left" then
        positioncurseurUpgrades = positioncurseurUpgrades - 1
      end
      --]]
      --[[
      if positioncurseurUpgrades == 1 then
        if key == "return" then
          TroisiemeNiveau()
          if SelectVirusP == "rouge" then
          virus.skins.rouge.speed = virus.skins.rouge.speed + 100
        else
         player.speedActu = player.speedActu + 10
          end
          pointCompetence = pointCompetence - 1
        end
      elseif positioncurseurUpgrades == 2 then
        if key == "return" then
          player.life = player.life + 1
          pointCompetence = pointCompetence - 1
        end
      end
      --]]
    end
  end

  -- SELECT VIRUS
  if afficheMainMenu == false and afficheOptions == false and afficheSelectVirus == true and afficheClassement == false and afficheFin == false then



    if key == "right" then

      love.audio.play(select3)

      if positioncurseur2 == 1 then
        positioncurseur2 = positioncurseur2 + 1
      elseif positioncurseur2 == 2 then
        positioncurseur2 = positioncurseur2 + 1
      elseif positioncurseur2 == 3 then
        positioncurseur2 = positioncurseur2 + 1
      elseif positioncurseur2 == 4 then
        positioncurseur2 = positioncurseur2 + 1
      elseif positioncurseur2 == 5 and cSecret1 == "false" then
        positioncurseur2 = positioncurseur2 + 1
      elseif positioncurseur2 == 5 and cSecret1 == "true" then
        positioncurseur2 = -1
      elseif positioncurseur2 == -1 and cSecret1 == "true" then
        positioncurseur2 = 5
      end
    end

    if key == "left" then
      love.audio.play(select3)
      if positioncurseur2 == 1 and cSecret1 == "false"  then
        positioncurseur2 = positioncurseur2 - 1
      elseif positioncurseur2 == 1 and cSecret1 == "true" then
        positioncurseur2 = -1
      elseif positioncurseur2 == 2 then
        positioncurseur2 = positioncurseur2 - 1
      elseif positioncurseur2 == 3 then
        positioncurseur2 = positioncurseur2 - 1
      elseif positioncurseur2 == 4 then
        positioncurseur2 = positioncurseur2 - 1
      elseif positioncurseur2 == 5 then
        positioncurseur2 = positioncurseur2 - 1
      elseif positioncurseur2 == -1 and cSecret1 == "true" then
        positioncurseur2 = 1


      end
    end

    if cSecret1 == "true" then

      if key == "down" then
        love.audio.play(select3)
        positioncurseur2 = -1
      end

      if key == "up" then
        positioncurseur2 = 3
      end

    end
    if key == "escape" then

      MainMenu()
      love.audio.play(back)

    end


    if timeaffiche > 0.0001 and afficheFin == false then 

      if positioncurseur2 == 1 then

        if key == "return" then
            
          ResetGame()
          PremierNiveau()
          SelectVirusP = "jaune"
          print(SelectVirusP)
  

        end

      end

      if positioncurseur2 == 2 then

        if key == "return" then
          
          ResetGame()
          PremierNiveau()
          SelectVirusP = "originalV"
          print(SelectVirusP)
    
     

        end

      end

      if positioncurseur2 == 3 then

        if key == "return" then

          ResetGame()
          PremierNiveau()
          SelectVirusP = "original"
          print(SelectVirusP)
    
          

        end

      end

      if positioncurseur2 == 4 then

        if key == "return" then


          ResetGame()
          PremierNiveau()
          SelectVirusP = "rouge"
          print(SelectVirusP)
     
      

        end

      end

      if positioncurseur2 == 5 then

        if key == "return" then
          
          
          ResetGame()
          PremierNiveau()
          SelectVirusP = "rose"
          print(SelectVirusP)
      
       

        end

      end

      if positioncurseur2 == -1 then

        if key == "return" then
          
          ResetGame()
          PremierNiveau()
          enableSecret1 = true
          SelectVirusP = ""
          print(SelectVirusP)
       
        

        end

      end
    

    end

  end


  if activeTimer == false then

    if key == "1" then
      keyPause = keyPause + 1
    end
  end


  if afficheMenu == false then
    if key == "escape" then

      love.audio.play(back)
      MainMenu()
      love.audio.stop(lvl1Music)
      love.audio.stop(nigiro_music)
      love.audio.stop(secret1_music)


    end
  
  if afficheUprades == false and afficheFin == false then

    if key == "return" then


      ResetGame()
      PremierNiveau()

      musicVarr = musicVarr + 1
      
      

    end
  end

    if afficheMenu == false and afficheMainMenu == false and afficheOptions == false and gameOver == false and afficheSelectVirus == false and activeTimer == false and afficheClassement == false then 

      --if key == "p" then

      --cSecret1 = true -- quand il decouvre l'endroit
      --enableSecret1 = true
      --love.filesystem.write("secret1_check.lua","true")


      --end

      if winwrite == "infect" or winwrite == "INFECT" then
        
       
      end
      
      --[[
      if key == "kp*" then
        player.x = tower4.x+35
        player.y = tower4.y-80
      end
      --]]
      
      if moveControls == "ARROW" then

        if love.keyboard.isDown("right") then
          if key == "space" and pause == false then
            if virus.skins.jaune.power == true then
              
              love.audio.play(virusTeleport)
              player.x = player.x + 34
              psystem_explosion_spawn(player.x+8,player.y+8)
            end
          end
        end

        if love.keyboard.isDown("left") then
          if key == "space" and pause == false  then
            if virus.skins.jaune.power == true then
              
              love.audio.play(virusTeleport)
              player.x = player.x - 34
              psystem_explosion_spawn(player.x+8,player.y+8)
            end
          end
        end

        if love.keyboard.isDown("up") then
          if key == "space" and pause == false  then
            if virus.skins.jaune.power == true then
              
              love.audio.play(virusTeleport)
              player.y = player.y - 34
              psystem_explosion_spawn(player.x+8,player.y+8)
            end
          end
        end

        if love.keyboard.isDown("down") then
          if key == "space" and pause == false  then
            if virus.skins.jaune.power == true then
             
              love.audio.play(virusTeleport)
              player.y = player.y + 34
              psystem_explosion_spawn(player.x+8,player.y+8)
            end
          end
        end

      end


      if moveControls == "ZQSD" then

        if love.keyboard.isDown("d") then
          if key == "space" and pause == false  then
            if virus.skins.jaune.power == true then
              
              love.audio.play(virusTeleport)
              player.x = player.x + 34
              psystem_explosion_spawn(player.x+8,player.y+8)
            end
          end
        end

        if love.keyboard.isDown("q") then
          if key == "space" and pause == false  then
            if virus.skins.jaune.power == true then
              
              love.audio.play(virusTeleport)
              player.x = player.x - 34
              psystem_explosion_spawn(player.x+8,player.y+8) 
            end
          end
        end

        if love.keyboard.isDown("z") then
          if key == "space" and pause == false  then
            if virus.skins.jaune.power == true then
              
              love.audio.play(virusTeleport)
              player.y = player.y - 34
              psystem_explosion_spawn(player.x+8,player.y+8)
            end
          end
        end

        if love.keyboard.isDown("s") then
          if key == "space" and pause == false  then
            if virus.skins.jaune.power == true then
              
              love.audio.play(virusTeleport)
              player.y = player.y + 34
              psystem_explosion_spawn(player.x+8,player.y+8)

            end
          end
        end

      end


      if moveControls == "WASD" then

        if love.keyboard.isDown("d") then
          if key == "space" and pause == false  then
            if virus.skins.jaune.power == true then
              
              love.audio.play(virusTeleport)
              player.x = player.x + 34
              psystem_explosion_spawn(player.x+8,player.y+8)
            end
          end
        end

        if love.keyboard.isDown("a") then
          if key == "space" and pause == false  then
            if virus.skins.jaune.power == true then
              
              love.audio.play(virusTeleport)
              player.x = player.x - 34
              psystem_explosion_spawn(player.x+8,player.y+8)
            end
          end
        end

        if love.keyboard.isDown("w") then
          if key == "space" and pause == false  then
            if virus.skins.jaune.power == true then
              love.audio.play(virusTeleport)
              player.y = player.y - 34
              psystem_explosion_spawn(player.x+8,player.y+8)
            end
          end
        end

        if love.keyboard.isDown("s") then
          if key == "space" and pause == false  then
            if virus.skins.jaune.power == true then
              
              love.audio.play(virusTeleport)
              player.y = player.y + 34
              psystem_explosion_spawn(player.x+8,player.y+8)

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

  if cSecret1 == "true" then
    love.filesystem.write("secret1_check.lua","true")
  end

end

function love.keyreleased(key)


if afficheMenu == false and afficheMainMenu == false and afficheFin == false and pause == false then
  
  if key == "z" or key == "s" or key == "q" or key == "d" or key == "a" or key == "up" or key == "w" or key =="down" or key == "left" or key == "right"then
    psystem:setLinearAcceleration(0, 0, 0, 0)
  
  end
end

end

function love.textinput(t)
  if afficheFin == true and limit_caractere <= 15 then
    limit_caractere = limit_caractere + 1
    print("cara:"..limit_caractere)
    love.audio.play(input)
    pseudo = pseudo .. t
  else
    pseudo = pseudo
  end

  if bossVulnerable == true and pause == false and afficheMenu == false then
  
   
    if t == "i" or t == "n" or t == "f" or t == "e" or t == "c" or t == "t" or t == "I" or t == "N" or t == "F" or t == "E" or t == "C" or t == "T" then
      love.audio.play(hit_sound)
      playonce = 1
      bosslife = bosslife - 2
      winwrite = winwrite .. t
    else
      winwrite = winwrite
    end
    
  end
 
end


