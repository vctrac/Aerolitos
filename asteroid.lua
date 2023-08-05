local isOut = function(r,x,y)
	return not (x+r>0 and x-r<world.w and y+r>0 and y-r<world.h);
end
local make =  function(n, r, e) -- (faces, radius, gaps)
	n = math.max(8, n);
	local t = {};
	local angleDiff = 2 * math.pi / n;
	local angle = 0;
	for i = 1,n do
	  angle = angle + angleDiff;
	  table.insert(t,r * math.cos(angle));
	  table.insert(t,r * math.sin(angle));
	  if math.random() < 0.45 then
		local a = angle + angleDiff / 4;
		local tmpR = r + math.random(-e,(e/2));
		table.insert(t,tmpR * math.cos(a));
		table.insert(t,tmpR * math.sin(a));
	  end
	end
	return unpack(t);
end

local Aster = class("Asteroid");
function Aster:init( x, y, r, a )
	local radius = r or math.random(5,60);
	local spd = math.random(30,60);
	local ang = a or math.rad(math.random(360));
	self.seen = false;
	self.body = collider:addPolygon( make( radius/4, radius, radius/2) );
	self.body.id = "rock";
	self.body.mass = radius;
	self.body.vel = vec.new(math.cos( ang ) * spd, math.sin( ang ) * spd);
	self.body.rot = math.rad(math.random(-25,25));
	self.body:moveTo( x, y);
end
---=-=-=--====---==--========----===-=====--===-=-=====----
local Time = 11;
local Rate = 10;
asteroids = {};
asteroids.stack = {};
function asteroids:add(x,y,r,a)
	table.insert(self.stack, Aster( x, y, r, a));
end
function asteroids:up(dt, px, py )
	for n,s in ipairs(self.stack) do
		local x,y = s.body:center();
		x = (x + s.body.vel.x*dt)%world.w;
		y = (y + s.body.vel.y*dt)%world.h;
		s.body:moveTo( x, y );
		s.body:rotate(s.body.rot*dt);
		if not s.body.id then collider:remove( s.body ); table.remove( self.stack, n ); end
	end
	if #self.stack<20 then
		Time = Time + dt;
		if Time > Rate and math.random(10)>3 then
			self:gen(5);
			Time = 0;
		end
	end
end
function asteroids:draw()
	lg.setColor(0.88,0.88,0.92);
	for n,s in ipairs(self.stack) do
		s.body:draw("line");
	end
end
function asteroids:blowUp(obj)
	obj.id = false;
	local x,y = obj:center();
	if obj.mass>20 then
		local r = math.max(8,obj.mass/4);
		for n=1,math.random(2,4) do
			self:add(x+math.random(-5,5),y+math.random(-5,5),r);
		end
	end
	audio.explosion:play();
	audio.explosion:seek(0);
	Boom:add(x,y,15,math.random(6,10),100);
end
function asteroids:gen(max)
	for i=1,math.random(max) do
		local x,y = math.random(world.w),math.random(world.h);
		local out = function(x,y) return (x<100 or x>600) and (y<100 or y>600); end
		while not out(x,y) do
			x,y = math.random(world.w),math.random(world.h);
		end
		local px,py = player.ship:center();
		px = px+math.random(-100,100);
		py = py+math.random(-100,100);
		local ang = math.atan2(x-px,py-y) + math.pi/2;
		table.insert(self.stack, Aster( x, y,nil , ang));
	end
end
function asteroids:destroy()
	for _, aster in ipairs(self.stack) do
		collider:remove(aster.body);
	end
	self.stack = {};
end
return asteroids;