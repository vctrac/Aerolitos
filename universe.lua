--#################################################--Universe--##################################################--
local ww, wh, grid = ...
local canvas=love.graphics.newCanvas(ww, wh);
local t={ star={}, planet={} };
local colors={
	{97/255,152/255,206/255},
	{254/255,255/255,179/255},
	{207/255,107/255,79/255},
	{240/255,87/255,75/255},
	{161/255,165/255,181/255},
	{258/255,226/255,251/255},
	{161/255,47/255,48/255},
	{84/255,172/255,97/255}
};
local str = {"aeoiu","bcdfghjklmnpqrstvwxyz","-"};
local function Name()
	local numb = math.random(2)
	local name = str[numb]
	local frst = math.random(name:len())
	name = string.sub(name,frst,frst):upper()
	local leng = math.random(3,6)
	for i=1,leng do
		local scnd;
		local boo = string.find(str[numb],string.sub(name,name:len()-1,name:len()-1))
		if numb == 1 and math.random(10)<3 and boo==nil then
			local nu = math.random(str[numb]:len())
			scnd = string.sub(str[numb],nu,nu)
		else
			numb = numb%2+1;
			local nu = math.random(str[numb]:len())
			scnd = string.sub(str[numb],nu,nu)
		end
		if math.random(15)==5 and scnd=='s' then scnd = "ss"; end
		name = name .. scnd;
	end
	if leng<4 then
		name = name .. str[3] .. math.random(1,99);
		if math.random(10)>8 then
			local nb = math.random(str[2]:len())
			name = name .. string.sub(str[2],nb,nb);
		end
	end
	return name;
end

do
	for i=1,50 do
		table.insert( t.star, { x=math.random(ww), y=math.random(wh), s=math.random(2), r=math.random(200), a=math.random(160,250)/255 });
		table.insert( t.star, { x=math.random(ww), y=math.random(wh), s=math.random(2,3), r=math.random(200), a=math.random(200,250)/255 });
	end;
	
	for i=1,3 do table.insert( t.planet, { x=math.random(ww), y=math.random(wh), s=math.random(6,18), c=colors[math.random(#colors)] });
	end
	
	love.graphics.setCanvas(canvas)
	for i,k in ipairs(t.star) do
        -- love.graphics.setColor(150,150,130,k.a);
        love.graphics.setColor(0.72,0.72,0.72,k.a);
        love.graphics.rectangle("fill",math.floor(k.x),math.floor(k.y),k.s,k.s);
	end
	for i,k in ipairs(t.planet) do
		love.graphics.setColor(1, 1, 1, 0.37);
		love.graphics.circle("fill",math.floor(k.x),math.floor(k.y),k.s+4,16);
		love.graphics.setColor(k.c);
		love.graphics.circle("fill",math.floor(k.x),math.floor(k.y),k.s,18);
		-- love.graphics.setColor(255, 255, 255)
		-- love.graphics.print(Name(),math.floor(k.x)-20,math.floor(k.y)-(k.s+20))
	end
	if grid then
		love.graphics.setColor( 0, 0.6, 0,0.7);
		local nw=ww/100
		for i=1,nw do
			local n=i*100;
			love.graphics.line(n,0,n,wh)
			love.graphics.line(0,n,ww,n)
		end
	end
	love.graphics.setCanvas()
end
return canvas;