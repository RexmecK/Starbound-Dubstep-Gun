timeline = {
	_tracks = {},
	_functions = {}
}

function timeline:update()
	for i,v in pairs(self._tracks) do
		if v.playing then
			local currentTime = os.clock() - v.playedTime
			local keycount = 0
			for i2,v2 in pairs(v.keys) do
				if v2.time < currentTime then
					for i3, v3 in pairs(v2.events) do
						self:fireEvent(v3)
					end
					self._tracks[i].playedkeys[i2] = v2
					self._tracks[i].keys[i2] = nil
				end
				keycount = keycount + 1
			end
		end
	end
end

function timeline:play(name)
	if self._tracks[name].playing then
		self:stop(name)
	end
	self._tracks[name].playing = true
	self._tracks[name].playedTime = os.clock()
end

function timeline:stop(name)
	self._tracks[name].playing = false
	for i,v in pairs(self._tracks[name].playedkeys) do
		self._tracks[name].keys[i] = v
	end
	self._tracks[name].playedkeys = {}
end

-- [{"events" : ["func1"], "time" : 2.0}]
function timeline:add(name, a)
	self._tracks[name] = {playing = false, playedTime = 0, keys = a, playedkeys = {}}
end

function timeline:setEvent(name, func)
	self._functions[name] = func
end

function timeline:fireEvent(name)
	if self._functions[name] then
		self._functions[name]()
	end
end

addClass("timeline")