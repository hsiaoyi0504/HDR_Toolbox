function val = MaximumError(img1, img2)
%
%
%      val = MaximumError(img1, img2)
%
%       the maximum error between two images
%
%       Input:
%           -img1: input source image
%           -img2: input target image
%
%       Output:
%           -val: the absolute maximum error between img1 and img2
% 
%     Copyright (C) 2014-2015  Francesco Banterle
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

if(CheckSameImage(img1,img2) == 0)
    error('The two images are different they can not be used.');
end

delta = abs(img1 - img2);

val = max(delta(:));

end