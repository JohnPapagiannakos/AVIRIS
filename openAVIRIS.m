%--------------------------------------------------------------------------
% date:      22/02/2021
% author: Yannis Papagiannakos
%--------------------------------------------------------------------------
% source based on code 
% url: https://www.mathworks.com/matlabcentral/answers/242269-how-to-read-aviris-hyperspectral-image#answer_288300

% "AVIRIS is an acronym for the Airborne Visible InfraRed Imaging Spectro-
% meter. AVIRIS is a premier instrument in the realm of Earth Remote Sensing. 
% It is a unique optical sensor that delivers calibrated images of the 
% upwelling spectral radiance in 224 contiguous spectral channels (also 
% called bands) with wavelengths from 400 to 2500 nanometers (nm). 
% AVIRIS has been flown on four aircraft platforms: NASA's ER-2 jet, 
% Twin Otter International's turboprop, Scaled Composites' Proteus, and 
% NASA's WB-57. The ER-2 flies at approximately 20 km above sea level, at 
% about 730 km/hr. The Twin Otter aircraft flies at 4km above ground level 
% at 130km/hr. AVIRIS has flown all across the US, plus Canada and Europe."

clear; close all

pathToFile   = '~/Documents/Sparse/Dataset/AVIRIS/';

% Dataset Info
% --- AVIRIS Data Portal 2006-2020 ---
% * url        : https://aviris.jpl.nasa.gov/dataportal/
% * get from   : https://popo.jpl.nasa.gov/avcl/y10_data/f101020t01p00r01.tar.gz
% * Dataset id : f101020t01p00r01
% * Site Name  : Nav Init

Dataset_ID       = 'f101020t01p00r01';
pathToFile   = [pathToFile Dataset_ID '/f101020t01p00r01rdn_b/'];
fileNameData = 'f101020t01p00r01rdn_b_sc01_ort_img';
fileNameProp = [fileNameData '.hdr'];

% Dataset_ID       = 'f100908t01p00r01';
% pathToFile   = [pathToFile Dataset_ID '/f100908t01p00r01rdn_b/'];
% fileNameData = 'f100908t01p00r01rdn_b_sc01_ort_img';
% fileNameProp = [fileNameData '.hdr'];


[TnsDims,dType,hOffset,intlve,bOrder, wavelengths] = readENVIHeaderFile([pathToFile fileNameProp]);

% Construct tensor X from dataset
X = multibandread([pathToFile fileNameData],TnsDims,dType,hOffset,intlve,bOrder);
