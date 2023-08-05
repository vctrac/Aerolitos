
local function elastic(a,b)
	local masses = a.mass + b.mass;

	local v1 = a.vel * ( a.mass - b.mass ) + 2*b.mass*b.vel;
	local v2 = b.vel * ( b.mass - a.mass ) + 2*a.mass*a.vel;

	return v1/masses, v2/masses;
end

local onColl = function(dt, a, b, x, y)
	if a.id == "rock" and b.id == "rock" then
		a:move(x,y); b:move(-x,-y);
		a.vel, b.vel = elastic( a, b );
	end
	if a.id == "bullet" and b.id == "rock" then
		a.f = false;
		local pnt = b.mass>40 and 20 or b.mass>20 and 50 or 100;
		score = score + pnt;
		asteroids:blowUp(b);
	elseif b.id == "bullet" and a.id == "rock" then
		b.f = false;
		local pnt = a.mass>40 and 20 or a.mass>20 and 50 or 100;
		score = score + pnt;
		asteroids:blowUp(a);
	end
	if (a.id == "bullet" and b.id == "ship") or (b.id == "bullet" and a.id == "ship") then
		if a.f then a.f = false; else b.f = false; end
		player:blowUp();
	end
	if (a.id == "bullet" and b.id == "alien") then
		a.f = false;
		b.id = false;
		score = score + 250;
		local x,y = b:center();
		table.insert(misc, fuel( x, y ));
	elseif (b.id == "bullet" and a.id == "alien") then
		b.f = false;
		a.id = false;
		score = score + 250;
		local x,y = a:center();
		table.insert(misc, fuel( x, y ));
	end
	if a.id == "ship" and b.id == "rock" then
		player:blowUp();
		asteroids:blowUp(b);
		
	elseif b.id == "ship" and a.id == "rock" then
		player:blowUp();
		asteroids:blowUp(a);
	end
	if (a.id == "ship" and b.id == "fuel") or (b.id == "ship" and a.id == "fuel") then
		if a.id=="fuel" then a.id = false; else b.id = false; end
		player.fuel = math.min(player.fuel + 50,100);
		audio.connect:play();
		audio.connect:seek(0);
		cout:add("added fuel!");
	end
	if a.id == "alien" and b.id == "rock" then
		a.id = false;
		asteroids:blowUp(b);
		
	elseif b.id == "alien" and a.id == "rock" then
		b.id = false;
		asteroids:blowUp(a);
	end
end
local postColl = function(dt, a, b)

end
local HUD = {}
function HUD:draw()
	lg.setColor(0,0.62,0);
	for i=1, deaths do
		local x=i*15;
		lg.polygon("line",x,25,x+5,10,x+10,25);
	end

	lg.printf("score : " .. score,0,18,SW,"center");
	lg.print("> ".. tostring(love.timer.getFPS( )), 465,10);
	lg.setColor(0, 0.38, 0.55);
	progBar(10,400,8,90,player.fuel,100);
	cout:draw();
	if player.isDead then
		lg.setColor(0,1,0);
		if deaths<=0 then
			lg.printf("Game Over",0,200,500,"center");
		else
			lg.printf("One more time!",0,200,500,"center");
			lg.circle("line",250,250,20,22);
		end
	end
end
fuel = class("fuel");
function fuel:init( x, y )
	self.life = 5;
	self.vel = vec.new(math.random(-20,20),math.random(-20,20));
	self.body = collider:addRectangle(x,y,10,10);
	self.body.id = "fuel";
end
game = {};
function game:enter()
	lg.setFont(font);
	collider = require 'lib.HardonCollider'(100, onColl, postColl);
	require 'lib.Vector';
	require 'lib.bullet';
	asteroids = require 'asteroid';
	ship = require 'ship';
	audio = {};
	audio.shoot = love.audio.newSource("snd/shoot.wav","static");
	audio.engine = love.audio.newSource("snd/engine.ogg","static");
	audio.alien = love.audio.newSource("snd/Pasted.wav","static");
	audio.explosion = love.audio.newSource("snd/skull.wav","static");
	audio.connect = love.audio.newSource("snd/connect.wav","static");
	audio.music = love.audio.newSource("snd/bgm01.ogg","stream");

	world={w=700,h=700};
	cam = require 'lib.gamera'.new(100,100,world.w-100,world.h-100);
	cam:setWindow(0,0,500,500);
	cam:setPosition(world.w/2,world.h/2);

	score = 0;
	deaths = 3;
	player = ship:new(world.w/2-100,world.h/2-100);
	enemy = require 'alien';
	misc = {};
	stars = love.filesystem.load('universe.lua')(world.w, world.h);
	
	audio.music:setVolume(0.5);
	audio.music:setLooping(true);
	audio.music:play();
	lg.setBackgroundColor(0.01,0,0.01);
end

function game:update(dt)
	collider:update(dt);
	player:up(dt);
	enemy:up(dt);
	Bllt:up(dt);
	asteroids:up(dt,player.x, player.y);
	Boom:up(dt);
	for un,dos in ipairs(misc) do
		dos.body:move( (dt*dos.vel):unpack( ) );
		dos.life = dos.life - dt;
		if dos.life<=0 or not dos.body.id then
			collider:remove( dos.body );
			table.remove( misc, un );
		end
	end
	-- mouse.x,mouse.y = love.mouse.getPosition()
	-- cout.time = cout.time>0 and cout.time - dt or 0;
	cout:update(dt)
end

function game:draw()
	lg.setColor(1,1,1);
	cam:draw(function(l,t,w,h)
		lg.draw(stars);
		player:draw();
		enemy:draw();
		Bllt:draw();
		asteroids:draw();
		lg.setColor(0,0.6,1);
		for un,dos in ipairs(misc) do
			dos.body:draw("fill");
		end
		Boom:draw();
	end);
	HUD:draw();
end
function game:keypressed(k)
	if k == "escape" then
		game.restart( );
	end
	if k == "g" then asteroids:gen(8); end
	if k == "r" or k == "return" and player.isDead then
		if deaths<=0 then
			game.restart( );
		else
			player = nil;
			player = ship:new(250,250);
		end
	end
end
function game.restart( )
	player:blowUp();
	Boom.stack = {};
	Bllt.stack={};
	enemy.ets = {};
	enemy.time = 0;
	asteroids:destroy();
	audio.music:stop();
	state.switch(menu);
end