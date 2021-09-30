function wavelength = appendWavelength(baseFileName, expression)
    filetext = fileread(baseFileName);
    A = regexp(filetext, expression, 'match');
    A = regexprep(A,'\s+',' ');
    tmp_char = split(A, " ");
    cell_array = tmp_char(5:2:end);
    wavelength = zeros(1, length(cell_array));
    
    for iter=1:length(cell_array)
        wavelength(iter) = str2double(char(cell_array(iter)));
    end
end

