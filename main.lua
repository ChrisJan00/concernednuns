function load()

	start_time = love.timer.getTime()
	max_time = 1 * 60  -- 1 minute

	math.randomseed(os.time())

	-- images
	love.filesystem.require("images.lua")
	love.filesystem.require("sound.lua")


	-- Colors
	love.graphics.setBackgroundColor(love.graphics.newColor(51,181,51))
	love.graphics.setColor(love.graphics.newColor(222,0,222))

	-- Audio system
	love.audio.setChannels(16)
	love.audio.setVolume(.3)

	-- Font
	love.graphics.setFont(love.default_font)

	-- Entities

	player = {
		coords = {320,240},
        direction = {0,0},      -- (increment horizontal, increment vertical)
		looking_left = false,
        step = 300,               -- speed multiplier
        spritesize = { 17, 33 },
	}

    screensize = { 640, 480 }

	num_nuns = 30

	nun_list = {}
	for i = 1,num_nuns do
		nun_list[i] = {
			coords = { math.random( screensize[1] ), math.random( screensize[2] ) },
			direction = { math.random()*2-1, math.random(  )*2-1},
			step = 40,
			concern = 0, -- calms down slowly
		}
	end

	nun_calm_rate = 0.999
	nun_spritesize = { 17, 33 }

	score = 0
	score_multiplier = 1

	max_concern = 5
	concern_radius = 150

	space_was_pressed = false
	flashing_timer = 0
	flashing_delay = 0.8

	max_nun_eeks = 4

	guy_animation = animations.guy_walk_right

	playing = true


end

function update(dt)

  if not playing then
	return
  end

  animations_update(dt)

  update_player( dt )

  update_nuns( dt )

  if flashing_timer>0 then
	flashing_timer = flashing_timer - dt
	if flashing_timer <= 0 then
		scare_nuns()
	end
  end

  elapsed_time = love.timer.getTime() - start_time
  if elapsed_time >= max_time then
	playing = false
  end

end

function update_player( dt )
	player.coords[1] = player.coords[1] + player.direction[1] * player.step * dt
  player.coords[2] = player.coords[2] + player.direction[2] * player.step * dt

  -- ==========   screen limits collision   ===========

  if player.coords[1] + player.spritesize[1] >= screensize[1] then
        player.coords[1] = 0
  end

  if player.coords[1] < 0 then
        player.coords[1] = screensize[1] - player.spritesize[1]
  end

  if player.coords[2] + player.spritesize[2] >= screensize[2] then
        player.coords[2] = 0
  end

  if player.coords[2] < 0 then
        player.coords[2] =  screensize[2] - player.spritesize[2]
  end

  -- ==========   END screen limits collision   ===========
end

function update_nuns( dt )


	for i=1,num_nuns do

		score = score + math.floor(nun_list[i].concern * score_multiplier)
		nun_list[i].concern = nun_list[i].concern * nun_calm_rate

		nun_list[i].coords[1] = nun_list[i].coords[1] + nun_list[i].direction[1] * nun_list[i].step * dt * (1+nun_list[i].concern)
		nun_list[i].coords[2] = nun_list[i].coords[2] + nun_list[i].direction[2] * nun_list[i].step * dt * (1+nun_list[i].concern)

		-- screen limits

		if nun_list[i].coords[1] + nun_spritesize[1] >= screensize[1] then
			nun_list[i].coords[1] = 0
		end

		if nun_list[i].coords[1] < 0 then
			nun_list[i].coords[1] = screensize[1] - nun_spritesize[1]
		end

		if nun_list[i].coords[2] + nun_spritesize[2] >= screensize[2] then
			nun_list[i].coords[2] = 0
		end

		if nun_list[i].coords[2] < 0 then
			nun_list[i].coords[2] =  screensize[2] - nun_spritesize[2]
		end

		-- inter-nun collision
		for j=1,num_nuns do
			if i ~= j then
				if nun_list[i].coords[1] <= nun_list[j].coords[1]+nun_spritesize[1] and
					nun_list[i].coords[2] <= nun_list[j].coords[2]+nun_spritesize[2] and
					nun_list[i].coords[1]+nun_spritesize[1] >= nun_list[j].coords[1] and
					nun_list[i].coords[2]+nun_spritesize[2] >= nun_list[j].coords[2] then

					-- collided!!! fleeeee
					d_vector = {
						nun_list[i].coords[1] - nun_list[j].coords[1],
						nun_list[i].coords[2] - nun_list[j].coords[2]  }

					norm_d_vector = math.sqrt(d_vector[1]*d_vector[1] + d_vector[2]*d_vector[2])
					if norm_d_vector < 0.01 then
						norm_d_vector = 0.01
					end

					nun_list[i].direction[1] = d_vector[1] / norm_d_vector
					nun_list[i].direction[2] = d_vector[2] / norm_d_vector
				end
			end
		end


	end
end

function scare_nuns( dt )

    num_nun_eeks = 0

	for i=1,num_nuns do

		d_vector = {
			nun_list[i].coords[1] - player.coords[1],
			nun_list[i].coords[2] - player.coords[2]  }

		norm_d_vector = math.sqrt(d_vector[1]*d_vector[1] + d_vector[2]*d_vector[2])
		if norm_d_vector < 0.01 then
			norm_d_vector = 0.01
		end

		if norm_d_vector <= concern_radius then

			if num_nun_eeks <= max_nun_eeks then
				num_nun_eeks = num_nun_eeks + 1
				nun_eeks()
			end

			nun_list[i].direction[1] = d_vector[1] / norm_d_vector
			nun_list[i].direction[2] = d_vector[2] / norm_d_vector
			nun_list[i].concern = max_concern
		end
	end
end

-- ============== DRAW FUNCTION ==============

function draw()



	love.graphics.draw(images.background,320,240)

if playing then
	-- player
	if player.direction[1]>0 then
		player.looking_left = false
	end
	if player.direction[1]<0 then
		player.looking_left = true
	end

	if not player.looking_left and flashing_timer<=0 then
		guy_animation = animations.guy_walk_right
	end
	if player.looking_left and flashing_timer<=0 then
		guy_animation = animations.guy_walk_left
	end
	if not player.looking_left and flashing_timer>0 then
		guy_animation = animations.guy_flash_right
	end
	if player.looking_left and flashing_timer>0 then
		guy_animation = animations.guy_flash_left
	end

	love.graphics.draw(guy_animation,
			player.coords[1]+math.floor(player.spritesize[1]/2),
			player.coords[2]+math.floor(player.spritesize[2]/2))

	-- nuns
	for i=1,num_nuns do
		if nun_list[i].concern > max_concern / 3 then
			if nun_list[i].direction[1] >= 0 then
				nun_animation = animations.nun_concerned_right
			else
				nun_animation = animations.nun_concerned_left
			end
		else
			if nun_list[i].direction[1] >= 0 then
				nun_animation = animations.nun_calm_right
			else
				nun_animation = animations.nun_calm_left
			end
		end

		love.graphics.draw(nun_animation,
			nun_list[i].coords[1]+math.floor(nun_spritesize[1]/2),
			nun_list[i].coords[2]+math.floor(nun_spritesize[2]/2))
	end

	-- score
	love.graphics.draw( "Time:" .. math.floor(max_time - love.timer.getTime() ) .. " s  " ..
						"Score:".. math.floor(score/num_nuns) , 240 , 25 )
else
	love.graphics.draw( "GAME ENDED.  Your score:".. math.floor(score/num_nuns) , 240 , 125 )
	love.graphics.draw( "Press ESC to exit" , 240 , 155 )
end

end

-- ============== END DRAW FUNCTION ==============


function keypressed(key)

	--if key == love.key_
	if key == love.key_escape then
        love.system.exit()
    end

	if playing then

    if key == love.key_up then
        player.direction = {0,-1}
    end

    if key == love.key_down then
        player.direction = {0,1}
    end

    if key == love.key_left then
        player.direction = {-1,0}
    end

    if key == love.key_right then
        player.direction = {1,0}
    end

	if key == love.key_space then
		if flashing_timer <= 0 then
		if not space_was_pressed then
			space_was_pressed = true
			-- scare_nuns()

			guy_laughs()
			flashing_timer = flashing_delay
		end
		end
	end

	end
end

function keyreleased(key)

  if key == love.key_up or
		key == love.key_down or
    	key == love.key_left or
		key == love.key_right then

		player.direction = {0,0}
  end

  if key == love.key_space then
	space_was_pressed = false
  end
end

