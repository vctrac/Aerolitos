function love.conf(t)
    t.title = "Aerolitos"        -- The title of the window the game is in (string)
    t.author = "Sodium"        -- The author of the game (string)
    t.url = nil                 -- The website of the game (string)
    t.identity = nil            -- The name of the save directory (string)
    t.version = "11.4"         -- The LÖVE version this game was made for (string)
    t.console = false           -- Attach a console (boolean, Windows only)	
    t.release = false           -- Enable release mode (boolean)
    t.window.width = 500        -- The window width (number)
    t.window.height = 500       -- The window height (number)
    t.window.fullscreen = false -- Enable fullscreen (boolean)
    t.window.vsync = true      -- Enable vertical sync (boolean)
    t.window.fsaa = 0           -- The number of FSAA-buffers (number)
    t.modules.joystick = false  -- Enable the joystick module (boolean)
    t.modules.audio = true      -- Enable the audio module (boolean)
    t.modules.keyboard = true   -- Enable the keyboard module (boolean)
    t.modules.event = true      -- Enable the event module (boolean)
    t.modules.image = false      -- Enable the image module (boolean)
    t.modules.graphics = true   -- Enable the graphics module (boolean)
    t.modules.timer = true      -- Enable the timer module (boolean)
    t.modules.mouse = true      -- Enable the mouse module (boolean)
    t.modules.sound = true      -- Enable the sound module (boolean)
    t.modules.physics = false    -- Enable the physics module (boolean)
end

 ------------------------------------------------------------------------------
 --  Game Name - space tactical action mining game etc
 --  Copyright(C) 2013 Sodium
 --
 --  This program is free software: you can redistribute it and/or modify
 --  it under the terms of the GNU General Public License as published by
 --   the Free Software Foundation, either version 3 of the License, or
 --                (at your option) any later version.
 --
 --  This program is distributed in the hope that it will be useful,
 --  but WITHOUT ANY WARRANTY; without even the implied warranty of
 --  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 --  GNU General Public License for more details.
 --
 --  You should have received a copy of the GNU General Public License
 --  along with this program; If not, see <http://www.gnu.org/licenses/>.
 --------------------------------------------------------------------------------
