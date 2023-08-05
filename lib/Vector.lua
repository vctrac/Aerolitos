vec = {}
vec.__index = vec

function vec.__add(a, b)
  if type(a) == "number" then
    return vec.new(b.x + a, b.y + a)
  elseif type(b) == "number" then
    return vec.new(a.x + b, a.y + b)
  else
    return vec.new(a.x + b.x, a.y + b.y)
  end
end

function vec.__sub(a, b)
  if type(a) == "number" then
    return vec.new(b.x - a, b.y - a)
  elseif type(b) == "number" then
    return vec.new(a.x - b, a.y - b)
  else
    return vec.new(a.x - b.x, a.y - b.y)
  end
end

function vec.__mul(a, b)
  if type(a) == "number" then
    return vec.new(b.x * a, b.y * a)
  elseif type(b) == "number" then
    return vec.new(a.x * b, a.y * b)
  else
    return vec.new(a.x * b.x, a.y * b.y)
  end
end

function vec.__div(a, b)
  if type(a) == "number" then
    return vec.new(b.x / a, b.y / a)
  elseif type(b) == "number" then
    return vec.new(a.x / b, a.y / b)
  else
    return vec.new(a.x / b.x, a.y / b.y)
  end
end

function vec.__eq(a, b)
  return a.x == b.x and a.y == b.y
end

function vec.__lt(a, b)
  return a.x < b.x or (a.x == b.x and a.y < b.y)
end

function vec.__le(a, b)
  return a.x <= b.x and a.y <= b.y
end

function vec.__tostring(a)
  local x,y=a:floor()
  return "x : " .. x .."\ny : " .. y;
end

function vec.new(x, y)
  return setmetatable({ x = x or 0, y = y or 0 }, vec)
end
function vec.add(a, b)
  if type(a) == "number" then
    return vec.new(b.x + a, b.y + a)
  elseif type(b) == "number" then
    return vec.new(a.x + b, a.y + b)
  else
    return vec.new(a.x + b.x, a.y + b.y)
  end
end
function vec.distance(a, b)
  return (b - a):len()
end

function vec:dot(v)
	return self.x * v.x + self.y * v.y
end

function vec:clone()
  return vec.new(self.x, self.y)
end

function vec:unpack()
  return self.x, self.y
end

function vec:floor()
  return math.floor(self.x), math.floor(self.y)
end

function vec:len()
  return math.sqrt(self.x * self.x + self.y * self.y)
end

function vec:lenSq()
  return self.x * self.x + self.y * self.y
end

function vec:normalize()
  local len = self:len()
  self.x = self.x / len
  self.y = self.y / len
  return self
end

function vec:normalized()
  return self / self:len()
end

function vec:rotate(phi)
  local c = math.cos(phi)
  local s = math.sin(phi)
  self.x = c * self.x - s * self.y
  self.y = s * self.x + c * self.y
  return self
end

function vec:rotated(phi)
  return self:clone():rotate(phi)
end

function vec:perpendicular()
  return vec.new(-self.y, self.x)
end

function vec:projectOn(other)
  return (self * other) * other / other:lenSq()
end

function vec:cross(other)
  return self.x * other.y - self.y * other.x
end

setmetatable(vec, { __call = function(_, ...) return vec.new(...) end })
