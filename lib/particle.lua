local Boom={}
Boom.stack={}
function Boom:add( x,y,Spd,Max,Life,Cor)
	if x>100 and x<600 and y>100 and y<600 then
		local t={}
		t.cor=Cor or {1,1,1};
		t.life = Life+math.random(Life);
		for i=1,Max do
			local ang,spd=math.random(360),Spd*4 + math.random(Spd*6);
			t[i] = { x=x, y=y, vx = math.sin(ang)*spd, vy = math.cos(ang)*spd, s=2, l=t.life };
		end
		table.insert(self.stack,t);
	end
end
function Boom:up(dt,grav)
	for n,s in pairs(self.stack) do
		for num,dust in ipairs(s) do
			if dust.l > 0 then
				if grav then dust.vy = dust.vy + grav*dt; end
				if dust.l > s.life then table.insert(s,{ x=dust.x, y=dust.y, vx = dust.vx, vy = dust.vy, l=dust.l-10 }); end
				dust.x = dust.x + dust.vx*dt;
				dust.y = dust.y + dust.vy*dt;
				dust.l = dust.l- dt;
			else
				table.remove(s,num);
			end
		end
		if #s<1 then table.remove(self.stack,n); end
	end
end
function Boom:draw()
	for n=1,#self.stack do
		lg.setColor(self.stack[n].cor);
		for i=1,#self.stack[n] do
			lg.rectangle("fill",self.stack[n][i].x, self.stack[n][i].y, self.stack[n][i].s, self.stack[n][i].s);
		end
	end
end
function Boom:fdraw()
	for n=1,#self.stack do
		for i=1,#self.stack[n] do
			if self.stack[n][i].s then
				lg.setColor(self.stack[n].cor[1],self.stack[n].cor[2],self.stack[n].cor[3],math.max(self.stack[n][i].l+0.1,0));
				lg.rectangle("fill",self.stack[n][i].x-1, self.stack[n][i].y-1, self.stack[n][i].s, self.stack[n][i].s);
			else
				lg.setColor(self.stack[n].cor[1],self.stack[n].cor[2],self.stack[n].cor[3],math.max(self.stack[n][i].l-0.05,0));
				lg.line(self.stack[n][i].x, self.stack[n][i].y,self.stack[n][i].x-self.stack[n][i].vx/4, self.stack[n][i].y-self.stack[n][i].vy/4);
			end
		end
	end
end
return Boom;