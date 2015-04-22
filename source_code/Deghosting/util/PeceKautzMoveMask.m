function [moveMask, num] = PeceKautzMoveMask(imageStack, iterations, ke_size, kd_size)
%
%
%        [moveMask, num] = PeceKautzMoveMask(imageStack, iterations, kernelSize)
%
%
%        Input:
%           -imageStack: an exposure stack of LDR images
%           -iterations: number of iterations for improving the movements'
%           mask
%           -ke_size: size of the erosion kernel
%           -kd_size: size of the dilation kernel
%
%        Output:
%           -moveMask: movements' mask
%           -num: number of different connected components in moveMask
% 
%     Copyright (C) 2013-15  Francesco Banterle
%
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
%     The paper describing this technique is:
%     "Bitmap Movement Detection: HDR for Dynamic Scenes"
% 	  by Fabrizio Pece, Jan Kautz
%     in Conference on Visual Media Production (CVMP)
%     London, UK, November 2010
%

if(~exist('iterations', 'var'))
    iterations = 1;
end

if(~exist('ke_size', 'var'))
    ke_size = 3;
end

if(~exist('kd_size', 'var'))
    kd_size = 17;
end

n = size(imageStack, 4);
[moveMask, ~] = WardComputeThreshold(imageStack(:,:,:,1)); 
for i = 2:n   
    [mask, ~] = WardComputeThreshold(imageStack(:,:,:,i));
    moveMask = moveMask + mask;
end

%filtering the noise
moveMask(moveMask == n) = 0;

%convert moveMask into a binary mask
moveMask(moveMask > 0) = 1;    

kernel_d = strel('disk', kd_size);
kernel_e = strel('disk', ke_size);

for i=1:iterations
    moveMask = imdilate(moveMask, kernel_d);
    moveMask = imerode(moveMask, kernel_e);
end

%calculate connected components
[moveMask1, num1] = bwlabel(moveMask, 4);
[moveMask2, num2] = bwlabel(1 - moveMask, 4);

moveMask = moveMask1 + (moveMask2 + num1);
num = num1 + num2;

end