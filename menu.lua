
local Audio = love.audio.newSource("snd/confirm.wav","static");
local blowup = love.audio.newSource("snd/blow.wav","static");
local launch = love.audio.newSource("snd/launch.wav","static");
local fireworks = {};
fireworks.color = {
	{1,1,0},
	{1,0,0},
	{0,1,0},
	{1, 0.41, 0},
	{0,1,1},
	{1,0,1}
};
fireworks.stack = {};
function fireworks:add(x,y,spd,time,max)
	local  t = {}
	t.time = time;
	t.x = x;
	t.y = y;
	t.w = 2;
	t.h = 4;
	t.l = 0;
	t.g = 0;
	t.max = max;
	t.vx = math.random(-40,40);
	t.vy = spd + math.random(spd/2);
	t.color = self.color[math.random(6)];
	table.insert( self.stack, t );
	launch:play();
	launch:seek(0);
end
function fireworks:up( dt )
	for no, one in pairs(self.stack) do
		if one.g<one.time then
			one.g = one.g + 50*dt;
			one.x = one.x + one.vx*dt;
			one.y = one.y - (one.vy - one.g)*dt;
		else
			if one.l == 0 then
				local t={};
				t.cor = one.color;
				t.life = 150+math.random(-50,50);
				for i=1,one.max do
					local ang,spd=math.random(360),50 + math.random(150);
					t[i] = { x=one.x, y=one.y, vx = math.sin(ang)*spd, vy = math.cos(ang)*spd, s=math.random(3), l=t.life+1 };
				end
				table.insert(Boom.stack,t);
				one.x,one.y = 0,0;
				one.w,one.h = SW,SH;
				one.l = 1;
				blowup:play();
				blowup:seek(0);
			end
			if one.l>1.1 then
				table.remove(self.stack, no);
			end
			one.l=one.l+dt;
		end
	end
end

menu={}
function menu:enter()
	self.cur = 1;
	self.time = 0;
	Namey = 0;
	star = {};
	for i=1,25 do
		star[i]={math.random(SW),math.random(SW),math.random(3)};
	end
end
function menu:keypressed(k)
	if k=="up" then self.cur=self.cur>1 and self.cur-1 or 2; Audio:play();Audio:seek(0);
	elseif k=="down" then self.cur=self.cur<2 and self.cur+1 or 1; Audio:play();Audio:seek(0); end
	if k=="return" or k==" " then
		if self.cur==1 then
			Boom.stack = {};
			fireworks.stack = {};
			state.switch(game);
		elseif self.cur==2 then love.event.quit();
		end
	end
	if k == "f" then fireworks:add(math.random(100,400),500,150,math.random(200,260),150); end
end
function menu:update(dt)
	fireworks:up( dt );
	Boom:up(dt,150);
	if self.cur == 2 then
		if self.time>4 then
			fireworks:add(math.random(100,400),500,150,math.random(200,260),math.random(100,150));
			self.time = math.random(5);
		else
			self.time = self.time + dt;
		end
	else
		Namey = Namey + dt;
	end
end
function menu:draw()
	local ty = math.sin(Namey)*20;
	lg.setFont(font);
	if self.cur==1 then
    	lg.setColor(0.01, 0, 0.01);
		lg.rectangle("fill",0,0,SW,SH);
	else
		lg.setColor(0, 0, 0);
		lg.rectangle("fill",0,0,SW,SH);
		lg.setColor(1,1,1);
		lg.print("?",130,170+ty);
    	lg.printf("[ Sodium ]",5,480,SW-10,"left");
	end

	lg.setColor(1, 1, 1);
	for i=1,25 do
		lg.rectangle("fill",star[i][1],star[i][2],star[i][3],star[i][3]);
	end
	lg.print("> ".. tostring(love.timer.getFPS( )), 465,10);
	
	for no, one in pairs(fireworks.stack) do
		if one.g > 250 then
			lg.setColor(one.color[1],one.color[2],one.color[3],0.23);
		else
			lg.setColor(one.color);
		end
		lg.rectangle("fill",one.x,one.y,one.w,one.h);
	end

	Boom:fdraw();
	
	if self.cur==1 then lg.setColor(1,1,1); else lg.setColor(0.39,0.39,0.39); end
	lg.print("START",100,150+ty);
	if self.cur==2 then lg.setColor(1,1,1); else lg.setColor(0.39,0.39,0.39); end
	lg.print("QUIT",100,170+ty);
	
	lg.setFont(fontb);
	if self.cur==2 then
		lg.setColor(0,0,0);
		love.graphics.rectangle("fill",418,247,58,40);
		love.graphics.rectangle("fill",420,305,39,43);
		love.graphics.rectangle("fill",419,367,61,42);
		love.graphics.rectangle("fill",379,247,41,162);
		love.graphics.rectangle("fill",18,196,44,163);
		love.graphics.rectangle("fill",62,317,59,42);
		love.graphics.rectangle("fill",139,247,42,160);
		love.graphics.rectangle("fill",181,247,59,42);
		love.graphics.rectangle("fill",198,289,42,118);
		love.graphics.rectangle("fill",168,367,38,40);
		love.graphics.polygon("fill", 258,198,291,198,327,359,282,359);
		love.graphics.polygon("fill", 358,199,324,199,291,359,332,359);
	end
	lg.setColor(0.19, 0.39, 1);
	lg.printf("'-=[ AEROLITOS ]=-'",0 ,50+ty ,SW ,"center");
end