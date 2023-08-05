gun = class("gun");
function gun:init(rate,speed,radius)
	self.time = 40;
	self.rate = rate;
	self.spd = speed;
	self.radi = radius or 0;
	self.isFiring = false;
end
function gun:fire(x,y,a,sfx,velx,vely )
	if self.time > self.rate then
		if sfx then sfx:play(); sfx:seek(0); end
		
		self.isFiring=true;
		local vx,vy = velx or 0, vely or 0;
		local b = collider:addCircle(x+math.cos(math.rad(a))*self.radi,y+math.sin(math.rad(a))*self.radi,2);
		b.id = "bullet";
		b.f = true;
		b.vx = (math.cos(math.rad(a))*self.spd + vx*25);
		b.vy = (math.sin(math.rad(a))*self.spd + vy*25);

		table.insert(Bllt.stack,b);
		self.time=0;
	end
end

function gun:up(dt)
	self.time=self.time<40 and self.time+10*dt or 40;
	if self.time==0 then self.isFiring=false; end
end
--=====--=---=====-=======--====--====--
Bllt={};
Bllt.stack={};
function Bllt:up(dt)
	for i,k in ipairs(self.stack) do
		k:move(k.vx*dt, k.vy*dt);
		if not k.f then collider:remove(k) table.remove(self.stack,i); end
		local bx,by = k:center();
		k.f = (bx>100 and bx<600 and by>100 and by<600);
	end
end;
function Bllt:draw()
	lg.setColor(255,255,0);
	for n,s in ipairs(self.stack) do
		s:draw("line");
	end
end;
