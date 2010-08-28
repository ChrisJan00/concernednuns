images = {
	background =  love.graphics.newImage("background.png"),

	nun_calm_left = love.graphics.newImage("nun_calm_left.png"),
	nun_calm_right = love.graphics.newImage("nun_calm_right.png"),

	nun_concerned_left = love.graphics.newImage("nun_concerned_left.png"),
	nun_concerned_right = love.graphics.newImage("nun_concerned_right.png"),

	guy_walk_left = love.graphics.newImage("guy_walk_left.png"),
	guy_walk_right = love.graphics.newImage("guy_walk_right.png"),

	guy_flash1_left = love.graphics.newImage("guy_flash1_left.png"),
	guy_flash1_right = love.graphics.newImage("guy_flash1_right.png"),
}

animations = {
	nun_calm_left = love.graphics.newAnimation(images.nun_calm_left, 17, 33, 0.120),
	nun_calm_right = love.graphics.newAnimation(images.nun_calm_right, 17, 33, 0.120),

	nun_concerned_left = love.graphics.newAnimation(images.nun_concerned_left, 20, 33, 0.080),
	nun_concerned_right = love.graphics.newAnimation(images.nun_concerned_right, 20, 33, 0.080),

	guy_walk_left = love.graphics.newAnimation(images.guy_walk_left, 13, 38, 0.120),
	guy_walk_right = love.graphics.newAnimation(images.guy_walk_right, 13, 38, 0.120),

	guy_flash_left = love.graphics.newAnimation(images.guy_flash1_left, 31, 39, 0.240),
	guy_flash_right = love.graphics.newAnimation(images.guy_flash1_right, 31, 39, 0.240),
}

function animations_update(delta)
	animations.nun_calm_left:update(delta)
	animations.nun_calm_right:update(delta)
	animations.nun_concerned_left:update(delta)
	animations.nun_concerned_right:update(delta)
	animations.guy_walk_left:update(delta)
	animations.guy_walk_right:update(delta)
	animations.guy_flash_left:update(delta)
	animations.guy_flash_right:update(delta)
end
