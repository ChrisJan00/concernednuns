sounds = { -- sounds table
	laugh = {
		love.audio.newSound("flash_01.wav"),
		love.audio.newSound("flash_02.wav"),
		love.audio.newSound("flash_03.wav"),
		love.audio.newSound("flash_04.wav"),
		love.audio.newSound("flash_05.wav"),
		love.audio.newSound("flash_06.wav"),
	},
	eek = {
		love.audio.newSound("eek_01.wav"),
		love.audio.newSound("eek_02.wav"),
		love.audio.newSound("eek_03.wav"),
	},
}

function nun_eeks()
	--if not love.audio.isPlaying() then
		love.audio.play(sounds.eek[math.random(1,#sounds.eek)])
	--end
end

function guy_laughs()
	--if not love.audio.isPlaying() then
		love.audio.play(sounds.laugh[math.random(1,#sounds.laugh)])
	--end
end
