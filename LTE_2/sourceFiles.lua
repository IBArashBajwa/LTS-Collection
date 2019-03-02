local utf8 = require("utf8");

local sourceFiles = {};

function sourceFiles.newSourceFile(fileName)
	return {
		fileName = fileName;
		filePath = "";
		isSaved = false;
		--isOpen = true;
		textLines = {""};
		totalLines = 1;
		--currentTextLine = {};
		currentTextLine = "";
		currentLineIndex = 1;
		cursorLinePosition = 1;
		cursorColumnPosition = 1;
		visibleStartLineIndex	= 1;
	};
end;

local utf8_offset = utf8.offset;
local string_sub = string.sub;
function sourceFiles.erase(sourceFile)
	local textLine = sourceFile.currentTextLine;
	if #textLine > 0 then
		local byteoffset = utf8_offset(textLine, -1)
		
		if byteoffset then
			sourceFile.currentTextLine = string_sub(textLine, 1, byteoffset - 1);
		end
	elseif sourceFile.totalLines > 1 then
		textLine = sourceFile.textLines[sourceFile.currentLineIndex-1];
		for lineIndex = sourceFile.currentLineIndex, sourceFile.totalLines do --move lines down to up 
			sourceFile.textLines[lineIndex] = sourceFile.textLines[lineIndex+1];
		end;
		sourceFile.currentLineIndex = sourceFile.currentLineIndex - 1;
		sourceFile.totalLines = sourceFile.totalLines - 1;
		sourceFile.textLines[sourceFile.currentLineIndex] = textLine;
		sourceFile.cursorColumnPosition = #textLine;
		sourceFile.currentTextLine = textLine;
	end;
	--[[
	local tokens = #sourceFile.currentTextLine;
	if tokens > 0 then
		local lastToken = sourceFile.currentTextLine[tokens];
		if lastToken then			
			local byteoffset = utf8_offset(lastToken, -1)
			print(lastToken, string_sub(lastToken, 1, byteoffset - 1));
			
		
			if byteoffset then
				sourceFile.currentTextLine[tokens] = string_sub(lastToken, 1, byteoffset - 1);
			end
		elseif sourceFile.totalLines > 1 then
			print("yoho");
			sourceFile.currentLineIndex = sourceFile.currentLineIndex - 1;
			sourceFile.totalLines = sourceFile.totalLines - 1;
		end;
	end;
	]]
end;

local tabConcat = table.concat;
function sourceFiles.appendText(sourceFile, t)
	--sourceFile.currentTextLine[#sourceFile.currentTextLine+1] = t; --this may not be super important, although we'll see
	sourceFile.currentTextLine = tabConcat({sourceFile.currentTextLine, t});
end;

function sourceFiles.addTextToLine(sourceFile)
	sourceFile.textLines[sourceFile.currentLineIndex] = sourceFile.currentTextLine;--tableConcat(sourceFile.currentTextLine);
	sourceFile.currentTextLine = "";
end;

function sourceFiles.addNewLine(sourceFile)
	if #sourceFile.currentTextLine > 0 then
		sourceFiles.addTextToLine(sourceFile);
		--return;
	end;
	if sourceFile.currentLineIndex == sourceFile.totalLines then
		sourceFile.currentLineIndex = sourceFile.currentLineIndex + 1;
		sourceFile.totalLines = sourceFile.totalLines + 1;
		sourceFile.textLines[sourceFile.currentLineIndex] = "";
	elseif sourceFile.currentLineIndex < sourceFile.totalLines then
		sourceFile.currentLineIndex = sourceFile.currentLineIndex+1;
		sourceFile.totalLines = sourceFile.totalLines + 1;
		for i=sourceFile.currentLineIndex, sourceFile.totalLines do
			sourceFile.textLines[i+1] = sourceFile.textLines[i];
		end;
		sourceFile.textLines[sourceFile.currentLineIndex] = "";
	end;
end;

return sourceFiles;