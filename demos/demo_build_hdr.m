%
%      This HDR Toolbox demo creates an HDR radiance map:
%	   1) Read a stack of LDR images
%	   2) Read exposure values from the EXIF
%	   3) Estimate the Camera Response Function (CRF)
%	   4) Build the radiance map using the stack and stack_exposure
%	   5) Save the radiance map in .hdr format
%	   6) Show the tone mapped version of the radiance map
%
%       Author: Francesco Banterle
%       Copyright 2015 (c)
%






name_folder = 'stack';
format = 'jpg';

disp('1) Read a stack of LDR images');
stack = ReadLDRStack(name_folder, format);

disp('2) Read exposure values from the exif');
%stack_exposure = ReadLDRStackInfo(name_folder, format);

stack_exposure=[
0.03125;
0.0625; 
0.125;  
0.25;   
0.5;    
1;      
2;      
4;      
8;      
16;     
32;     
64;     
128;    
256;    
512;    
1024; 
];

stack_exposure=1./stack_exposure;

disp('3) Estimate the Camera Response Function (CRF)');
[lin_fun, ~] = ComputeCRF(stack, stack_exposure,256,0);    
h = figure(1);
set(h, 'Name', 'The Camera Response Function (CRF)');
plot(lin_fun);

disp('4) Build the radiance map using the stack and stack_exposure');
imgHDR = BuildHDR(stack, stack_exposure, 'LUT', lin_fun, 'Deb97', 'log');

disp('5) Save the radiance map in the .hdr format');
hdrimwrite(imgHDR, 'hdr_image.pfm');

disp('6) Show the tone mapped version of the radiance map with gamma encoding');
h = figure(2);
set(h, 'Name', 'Tone mapped version of the built HDR image');
GammaTMO(ReinhardBilTMO(imgHDR, 0.18), 2.2, 0, 1);