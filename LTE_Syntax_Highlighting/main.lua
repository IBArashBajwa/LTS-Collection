local utf8 = require("utf8");
local theme = require("theme");

local function isCharacterSeparator(c)
	for _, separator in pairs(theme.SEPARATORS) do
		if c == separator then
			return true;
		end;
	end;
	return false;
end;

local function getThemeColorOfCharacters(characters)
	local color = theme.NORMAL_COLOR;
	for _, keyword in pairs(theme.KEYWORDS) do
		if characters == keyword then
			color = theme.KEYWORD_COLOR;
			return color;
		end;
	end;
	for _, specialWord in pairs(theme.SPECIAL) do
		if characters == specialWord then
			color = theme.SPECIAL_COLOR;
			return color;
		end;
	end;
	return color;
end;

local function newTextLine() --an object for editing text, useful for syntax highlighting, as it will separate it in tokens
	local textLine = {
		coloredText = {};
		__previousWord = "";
		__justSeparated = false;
		__totalCharacters = 0;
	};

	function textLine:print(x, y)
		love.graphics.print(self.coloredText, x, y);
	end;

	function textLine:addCharacter(c)
		if isCharacterSeparator(c) then
			print("yes", self.__previousWord);

			local color = getThemeColorOfCharacters(self.coloredText[#self.coloredText]);
			--print(unpack(color), previousWord)
			self.coloredText[#self.coloredText-1] = color;
			--coloredText[#coloredText+1] = previousWord;
			self.coloredText[#self.coloredText+1] = theme.NORMAL_COLOR;
			self.coloredText[#self.coloredText+1] = c;
			self.__justSeparated = true;
			--self.coloredText[#self.coloredText+1] = theme.NORMAL_COLOR;
			--self.coloredText[#self.coloredText+1] = "";
			self.__previousWord = "";
		else
			if self.__justSeparated then
				self.coloredText[#self.coloredText+1] = theme.NORMAL_COLOR;
				self.coloredText[#self.coloredText+1] = c;
				self.__previousWord = c;
				self.__justSeparated = false;
			else
				if self.coloredText[#self.coloredText] == nil then
					self.coloredText = {theme.NORMAL_COLOR, c};
					self.__previousWord = c;
				else
					self.coloredText[#self.coloredText] = self.coloredText[#self.coloredText] .. c;
					self.__previousWord = self.__previousWord .. c;
				end;
			end;
		end;
		self.__totalCharacters = self.__totalCharacters + 1;
	end;

	function textLine:addLastWord()
		if self.__previousWord == "" then return end; -- no last word to add
		local color = theme.NORMAL_COLOR;
		for _, keyword in pairs(theme.KEYWORDS) do
			if self.__previousWord == keyword then
				color = theme.KEYWORD_COLOR;
			end;
		end;
		self.coloredText[#self.coloredText-1] = color;
		--self.__previousWord = "";
	end;

	function textLine:eraseCharacter()
		if #self.coloredText == 0 then return end; --Can't erase anything, nothing there to erase, so return/cancel.
		if self.coloredText[#self.coloredText] == "" then
			table.remove(self.coloredText); --remove string
			table.remove(self.coloredText); --remove color
			--self.__previousWord = self.coloredText[#self.coloredText] or "";
		end;

		local text = self.coloredText[#self.coloredText];
		local byteoffset = utf8.offset(text, -1)


		if byteoffset then
			local newText = string.sub(text, 1, byteoffset - 1);
			self.coloredText[#self.coloredText] = newText;
			self.__previousWord = newText;
		end

		self.__totalCharacters = self.__totalCharacters - 1;

	end;

	function textLine:getNumberOfCharacters()
		print(self.__totalCharacters);
		return self.__totalCharacters;
	end;



	return textLine;
end;

local textLines = {
	newTextLine();
};
local currentLineIndex = 1;

local function addNewLine()
	textLines[currentLineIndex]:addLastWord();
	if lineIndex == #textLines then
		currentLineIndex = currentLineIndex + 1;
	else
		currentLineIndex = currentLineIndex + 1;
		for lineIndex = currentLineIndex, #textLines+1 do
			textLines[lineIndex+1] = textLines[lineIndex];
		end;
		textLines[currentLineIndex] = newTextLine();
	end;
	textLines[currentLineIndex] = newTextLine();
end;

local function eraseLine()
	if currentLineIndex == 1 then --If the lineIndex is 1, we can't or shouldn't go to 0, so we cancel/return.
		return
	end;

	local lineNumber = 1;
	for i = 1, #textLines do
		if lineNumber ~= currentLineIndex then
			textLines[lineNumber] = textLines[i];
			lineNumber = lineNumber + 1;
		end;
	end;
	currentLineIndex = currentLineIndex - 1;
end;

function love.load()
	love.keyboard.setKeyRepeat(true);
end;


function love.update(deltaTime)

end;


function love.draw()
	for lineNumber = 1, #textLines do
		textLines[lineNumber]:print(0, (lineNumber-1)*12);
	end;
end;

function love.keypressed(key, scancode, isRepeat)
	if key == "return" then
		addNewLine();
	elseif key == "backspace" then
		local currentTextLine = textLines[currentLineIndex];
		if currentTextLine:getNumberOfCharacters() > 0 then --Are there are any characters in TextLine? If Yes: erase character, if No: eraseLine.
			currentTextLine:eraseCharacter();
		else
			eraseLine();
		end;
	elseif key == "tab" then
		textLines[currentLineIndex]:addCharacter('\t');
	end;
end;

function love.textinput(t) --Catching what user types, and concatenating.
	textLines[currentLineIndex]:addCharacter(t);
end;
