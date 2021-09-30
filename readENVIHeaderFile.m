%--------------------------------------------------------------------------
% Author : Yannis Papagiannakos 
% Date   : 24 / 02 / 2021
%--------------------------------------------------------------------------
% function [TnsDims, dType, offset, interleave, byteorder, wavelengths] = readENVIHeaderFile(fileNameProp)
%
% Description: Function readENVIHeaderFile takes as input argument the name
% of the header file (.hdr) and returns:
% * TnsDims : HSI dimensions
%
% * dType   : The type of data representation
%             1 = Byte: 8-bit unsigned integer
%             2 = Integer: 16-bit signed integer
%             3 = Long: 32-bit signed integer
%             4 = Floating-point: 32-bit single-precision
%             5 = Double-precision: 64-bit double-precision floating-point
%             6 = <NOT SUPPORTED YET> Complex: Real-imaginary pair of single-precision floating-point
%             9 = <NOT SUPPORTED YET> Double-precision complex: Real-imaginary pair of double precision floating-point
%             12 = Unsigned integer: 16-bit
%             13 = Unsigned long integer: 32-bit
%             14 = 64-bit long integer (signed)
%             15 = 64-bit unsigned long integer (unsigned)
%
% * offset  : Scalar specifying the zero-based location of the first data 
%             element in the file. This value represents the number of bytes 
%             from the beginning of the file to where the data begins.
%
% * interleave : Format in which the data is stored, specified as one of these values:
%             'bsq' — Band-Sequential
%             'bil'— Band-Interleaved-by-Line
%             'bip'— Band-Interleaved-by-Pixel
%
% * byteorder :  Character vector or string scalar specifying the byte ordering 
%                (machine format) in which the data is stored, such as
%             'ieee-le' — Little-endian
%             'ieee-be' — Big-endian
%
% * wavelengths : Lists the center wavelength values of each band in an image. 
%
% -- For more details read : + http://enviidl.com/help/Subsystems/envi/Content/ExploreImagery/ENVIHeaderFiles.htm
%                            + https://www.mathworks.com/help/matlab/ref/multibandread.html
%                            + https://prediktera.com/download/pdf/Prediktera_Evince_Breeze_hyperspectral_file_format.pdf      
%
% -- Inspired by : https://www.mathworks.com/matlabcentral/answers/242269-how-to-read-aviris-hyperspectral-image#answer_288300
%
%--------------------------------------------------------------------------

function [TnsDims, dType, offset, interleave, byteorder, wavelengths] = readENVIHeaderFile(fileNameProp)

    fprintf(['--- Reading header file:' fileNameProp  ' ---\n']);

    % dataDim := [lines, samples, bands]
    lines = str2double(readInfo(fileNameProp, '\s+lines\s+=\s+\d*'));
    samples = str2double(readInfo(fileNameProp, '\s+samples\s+=\s+\d*'));
    bands = str2double(readInfo(fileNameProp, '\s+bands\s+=\s+\d*'));
    TnsDims = [lines, samples, bands];

    % dType = 'int16';    % For data type 2
    dType_enum = str2double(readInfo(fileNameProp, '\s+data type\s+=\s+\d*'));

    switch dType_enum
        case 1
            dType = 'int8';
        case 2
            dType = 'int16';
        case 3
            dType = 'int32';
        case 4
            dType = 'single';
        case 5
            dType = 'double';
        case 6
            fprintf('*** COMPLEX TYPE NOT SUPPORTED YET!***\n');
            return    
        case 9
            fprintf('*** COMPLEX TYPE NOT SUPPORTED YET!***\n');
            return
        case 12
            dType = 'uint16';
        case 13
            dType = 'uint32';
        case 14
            dType = 'int64';
        case 15
            dType = 'uint64';
        otherwise
            fprintf('*** UNKNOWN DATA TYPE !***\n');
            return
    end

    offset = str2double(readInfo(fileNameProp, '\s+header offset\s+=\s+\d*'));
    interleave = char(readInfo(fileNameProp, '\s+interleave\s+=\s+\w*'));

    % bOrder = 'ieee-be'; % For byte order 1
    bOrder_enum = str2double(readInfo(fileNameProp, '\s+byte order\s+=\s+\d*'));

    switch bOrder_enum
        case 0
            byteorder = 'ieee-le'; % Little-endian
        case 1
            byteorder = 'ieee-be'; % Big-endian
        otherwise
            fprintf('*** UNKNOWN BYTE ORDER !***\n');
            return        
    end
    
    % append wavelengths in nanometers (nm)
    wavelengths = appendWavelength(fileNameProp, '\s*wavelength\s*=\s*{\s*[\d*.\d*\s*[,\s*]*]*\s*}');
end

