-- Project: Heaven Of Earth
-- http://www.bivekjoshi.com.np
-- Version: 1.0
-- Copyright 2016 Bivek Joshi All Rights Reserved.

-- housekeeping stuff

-- Hides the status bar of the mobile phone
display.setStatusBar(display.HiddenStatusBar)

local centerX = display.contentCenterX
local centerY = display.contentCenterY

-- set up forward references
local spwanEnemy
local shipSmash
local gameTitle 
local planetDamage
local resetGame

local scoreTxt
local score
local numHits
local hitPlanet
local planet
local background
local playerLife
local lifeText
local scoreIncrement

-- preload audio

local sndKill = audio.loadSound("boing-1.wav")
local sndBlast = audio.loadSound("blast.mp3")
local sndLose = audio.loadSound("wahwahwah.mp3")

-- Reset Game

function resetGame()
	numHits = 75
	score = 0
	scoreIncrement = 3
	playerLife = numHits/25
	display.remove(planet)
end

-- create play screen

local function createPlayScreen()
	background = display.newImage("background.png")
	background.y = 130
	background.alpha = 0


	planet = display.newImage("planet.png")
	planet.x = centerX
	planet.y = display.contentHeight + 60
	planet.alpha = 0

	transition.to(background, {time = 2000, y = centerY, x = centerX, alpha = 1})

	local function showTitle()
		gameTitle = display.newImage ("gametitle.png")
		gameTitle.alpha = 0
		gameTitle:scale(4,4);
		transition.to(gameTitle , {time=500,alpha=1,xScale = 1, yScale=1})
		startGame()
	end
	transition.to(planet, {time = 2000, alpha = 1, y = centerY, onComplete = showTitle})
end

-- game functions

function spawnEnemy()
	local enemy = display.newImage("octopus.png")
	enemy.x = math.random(20, display.contentWidth-20)
	enemy.y = math.random(20, display.contentHeight-20)
	enemy:addEventListener('touch', shipSmash)
	
	if math.random(2) == 1 then
		enemy.x = math.random (-100 , -10)
	else
		enemy.x = math.random (display.contentWidth +10,display.contentWidth +100)
	end
	enemy.y = math.random (display.contentHeight)
	
	enemy.trans = transition.to ( enemy,  { x=centerX, y=centerY, time =2000, onComplete = hitPlanet } )
end

-- Smash Ship
function shipSmash (event)
	local obj = event.target
	display.remove( obj )
	audio.play(sndKill)
	transition.cancel (event.target.trans)
	score = score + scoreIncrement
	scoreTxt.text = "Score: " .. score
	spawnEnemy()
	return true
end

function startGame()
	local text = display.newText ("Tap here to start. Protect  the planet!", 0, 0, "Helvetica", 24)
	text.x = centerX
	text.y = display.contentHeight - 30
	text:setFillColor(255,255,0)
	local function goAway(event)
		display.remove(event.target)
		text = nil
		display.remove(gameTitle)
		spawnEnemy()
		lifeText = display.newText( "Life: "..playerLife, 0, 0 , "Helvetica", 20 )
		lifeText.x=display.contentWidth-30
		lifeText.y=15
		lifeText:setFillColor(255,255,0)

		scoreTxt = display.newText("Score: 0", 0, 0, "Helvetica", 20)
		scoreTxt.x = centerX
		scoreTxt.y = 15
		score = 0
		scoreTxt:setFillColor(255,255,0)
	end
	text:addEventListener("tap",goAway)
end

function planetDamage()
 local function goAway1(event)
 	planet.xScale =1
 	planet.yScale = 1
 	planet.alpha = numHits/100
 end
 transition.to(planet, {time = 200, xScale = 1.2, yScale=1.2, alpha=1, onComplete = goAway1} )
end

function hitPlanet ( obj )
	numHits=numHits-25
	if(numHits==0) then
		playerLife=0
	else
		playerLife = numHits/25
	end
	lifeText.text = "Life: " .. playerLife
	display.remove( obj )
	planetDamage()
	audio.play(sndBlast)
	if(numHits==0) then
 		resetGame()
 		createPlayScreen()
 	else
		spawnEnemy()
	end
end


resetGame()
createPlayScreen()
