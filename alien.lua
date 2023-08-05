local Alien = class("Alien");
local color = {
	{160/255, 11/255, 158/255},
	{29/255, 160/255, 12/255},
	{229/255, 222/255, 31/255},
	{229/255, 126/255, 31/255},
	{0, 112/255, 154/255},
	{154/255, 0, 0}
};
local angles = {
	{ 0, 45, 90, 135, 180 },
	{ 180, 225, 270, 315, 0 }
};
function Alien:init( x, y )
	self.x = x;			self.y = y;
	local spd = x>350 and -50 or 50;
	self.color = math.random(#color);
	self.time = 0;		self.rate = 1;
	self.ang = 0;		self.tb = y<325 and 1 or 2;
	self.say = " ";
	self.rotation = 0;
	self.g = gun:new( 2, 250, 20 );
	self.ship=collider:addPolygon( -12,0,-7,-4,7,-4,12,0,7,6,-7,6 );
	self.ship.id = "alien";
	self.ship.vel = vec.new(spd,0);
	self.ship:moveTo(x,y);
end
function Alien:up(dt)
	self.x,self.y = self.ship:center();
	if self.time>self.rate then
		self.ang = angles[self.tb][math.random(5)];
		self.g:fire( self.x, self.y, self.ang, audio.shoot);
		self.time = math.random();
		if math.random(80)==13 and self.say == " " then
			self.say = "press 'g'!";
		end
	end
	self.time = self.time + dt;
	self.rotation = self.rotation + 5*dt;
	local sy = math.sin(self.rotation)/2;
	self.ship:move( self.ship.vel.x*dt, sy+self.ship.vel.y*dt );
	self.ship:setRotation(math.sin(self.rotation)/3);
	self.g:up( dt);
	audio.alien:play();
	audio.alien:seek(0);
end
local enemy = {};
enemy.ets = {};
enemy.time = 0;
local rate = 20;
local say = {
	"Muahahahaha",
	"I hate humans!",
	"Hah! Loser",
	"Huehuehue",
	"Stupid humans!",
	"Patetic!"
}
function enemy:up( dt )
	self.time = self.time + dt;
	if self.time>rate then
		local tx = math.random(20)<10 and 80 or 620;
		local ty = math.random(20)>10 and 250 or 450;
		table.insert(self.ets, Alien(tx,ty+math.random(-60,60)));
		self.time=math.random(-3,8);
	end
	for n,s in ipairs(self.ets) do
		s:up( dt );
		if player.isDead and s.say == " " then
			s.say = say[math.random(#say)]
		end
		if s.x>700 or s.x<0 or not s.ship.id then
			self.blowUp(s);
			table.remove(self.ets, n);
		end
	end
end
function enemy:draw( )
	for n,s in ipairs(self.ets) do
		lg.setColor(color[s.color]);
		s.ship:draw( "line" );
		lg.print(s.say,s.x-25,s.y-20);
	end
end
function enemy.blowUp( obj )
	local x,y = obj.ship:center();
	Boom:add( x, y,15,math.random(20,30),100,color[obj.color]);
	collider:remove(obj.ship);
	audio.explosion:play();
	audio.explosion:seek(0);
end
return enemy;