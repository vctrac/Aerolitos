local Ship = class("Ship")

function Ship:init( x, y )
	self.x = x;			self.y = y;
	self.spd = 0;		self.spdf = 50;					--actual speed / multiplier factor
	self.pw = 0;		self.vmax = 29.9;				--engine power / max total velocity
	self.ang = 0;		self.color = { 0.19, 0.98, 0.19 };	--ship angle / ship color
	self.isDead = false;self.fuel = 100;
	self.turnR = false;	self.turnL = false;
	self.g = gun:new( 3, 400, 20 );
	self.ship=collider:addPolygon( -10, 5, 10, 0, -10, -5 );
	self.ship.id = "ship";
	self.ship.vel = vec.new(0,0);
end
function Ship:up(dt)
	if not self.isDead then
		self.turnR = kb("right","d");
		self.turnL = kb("left","a");
		if self.turnL then self.ang = self.ang - 150*dt;
		elseif self.turnR then self.ang = self.ang + 150*dt; end
		if kb("up","w") and self.fuel>0 then
			self.pw = self.pw<10 and self.pw + 5*dt or 10;
			self.ship.vel.x = self.ship.vel.x + math.cos(math.rad(self.ang))*4*dt;
			self.ship.vel.y = self.ship.vel.y + math.sin(math.rad(self.ang))*4*dt;
			audio.engine:play();
			local pow = self.ship.vel:lenSq();
			self.spd = pow;
			if pow>self.vmax then   -- fix diagonal speed
				local factor = math.sqrt( self.vmax/pow );
				self.ship.vel = self.ship.vel * factor;
			end
			self.fuel = self.fuel - 10*dt;
		else
			self.pw = self.pw>0 and self.pw - 6*dt or 0;
		end
		if kb("x","space") then
			self.g:fire( self.x+100, self.y+100, self.ang, audio.shoot , self.ship.vel:unpack() );
		end

		self.x = (self.x + self.ship.vel.x*self.spdf*dt)%500;
		self.y = (self.y + self.ship.vel.y*self.spdf*dt)%500;
		self.ship:moveTo( 100+self.x, 100+self.y );
		self.ship:setRotation( math.rad( self.ang));
		self.g:up( dt);
	end
end
function Ship:draw()
	if not self.isDead then
		local x,y = self.x +100,self.y+100;
		lg.push();   --Engine Fire
		 lg.translate(x,y);
		 lg.rotate(math.rad(self.ang));
		 lg.translate(-x,-y);
		 lg.setColor(0, 0.5882, 0.9804);
		 if self.pw>0 then
			lg.polygon('line', x-10, y-2.5, x-(11+self.pw), y, x-10, y+2.5);
		 end
		 if self.turnL then lg.polygon('line', x-8, y-8, x-6, y-11, x-4, y-8);
		 elseif self.turnR then lg.polygon('line', x-8, y+8, x-6, y+11, x-4, y+8); end
		lg.pop();
		lg.setColor(self.color);
		self.ship:draw("line");
  	end
end
function Ship:blowUp()
	Boom:add(self.x+100,self.y+100,15,math.random(15,20),100,self.color);
	collider:remove(self.ship);
	self.isDead = true;
	deaths = deaths - 1;
end
return Ship;