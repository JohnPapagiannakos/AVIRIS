function value = readInfo(baseFileName, expression)
    filetext = fileread(baseFileName);
    A = regexp(filetext, expression, 'match');
    A = regexprep(A,'\s+',' ');
    tmp_char = split(A, " ");
    value = tmp_char(end);
end

