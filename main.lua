-- assert(love.graphics.isSupported("canvas"), "Your graphics card does not support canvases, sorry!")
state = require 'lib.gamestate';
Boom = require 'lib.particle';
require 'lib.middleclass';
require 'menu';
require 'game';

function love.load()
	USER = string.gsub("$USER","%$(%w+)", os.getenv);
	lg = love.graphics;	
	SW = lg.getWidth();
	SH = lg.getHeight();
	kb = love.keyboard.isDown;

	mouse={};
	mouse.x,mouse.y = love.mouse.getPosition();

	font = lg.newFont("8-bit Madness.ttf",16);
	fontb = lg.newFont("8-bit Madness.ttf",36);

	state.registerEvents();
	-- state.switch(game);
	state.switch(menu);
end

cout = { color = {1,1,1}, time = 1, txt="hello friend!" };
function cout:add(str,color)
	self.txt = str;
	self.time = 1;
	self.color = color or {1,1,1};
end
function cout:update(dt)
	cout.time = cout.time>0 and cout.time - 0.25*dt or 0;
end
function cout:draw()
	if self.time>0 then
		lg.setColor( self.color[1], self.color[2], self.color[3], math.ceil(self.time) );
		lg.printf( self.txt, 100, 485, 390, "right" );
	end
end

function dist(x1,y1,x2,y2)
  local dx,dy=(x2-x1),(y2-y1);
  return math.sqrt(math.pow(dx,2)+math.pow(dy,2));
end
function progBar(x,y,w,h,vmin,vmax)
	local n=math.ceil((vmin/vmax)*h);
	lg.rectangle("line",x,y,w,h);
	lg.rectangle("fill",x,y+h,w,-n);
end
