%	Copyright (C) 2011 Fabrizio Pece
%
%	This file is part of Depth Encoding.
%
%	This program is distributed in the hope that it will be useful,
%	but WITHOUT ANY WARRANTY; without even the implied warranty of
%	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%	GNU General Public License for more details.
%
%	You should have received a copy of the GNU General Public License
%	along with this program; if not, write to the Free Software Foundation,
%	Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
%
%	MANUAL:
%
% 	Writes a ply point cloud from a depth image. If the rgb image is passed
% 	as well, then also colour is written at each point.
%
%
%	Args:
%	@filename:  string for the ply filename location. Something like 'test.ply'
%	depth: is the depth map from which the point cloud will be generated
%	image: (optional) is the rgb image from where the pontc colours will be taken
%
%	Example of usage
%	
%	plywrite('test.ply', my_depth_map, my_colour_map );
%

function  plywrite(filename, depth, image )

rgb = false;

if nargin == 3
   rgb = true; 
   if max(image(:))<=1.0
       image = image.*255;
   end
end

ext = regexp(filename,'\.','split');
if(strcmp(ext{2},'ply'))
    filename = [ext{1} '.ply'];
end

display(['Writing ' filename]);

[dx dy dz] = size(depth);
D = depth(:);
tot_points = 0;
%count tot points to write out
for(x=1:dx*dy)
    if(D(x)~=0)
       tot_points = tot_points + 1; 
    end
end

fid = fopen( filename, 'wb' );

%write header
	fprintf(fid,'ply\n');
	fprintf(fid,'format ascii 1.0\n');
	fprintf(fid,'element vertex %d\n',tot_points);
	fprintf(fid,'property float x\n');
	fprintf(fid,'property float y\n');
	fprintf(fid,'property float z\n');
    if(rgb)
        fprintf(fid,'property uchar diffuse_red\n');
        fprintf(fid,'property uchar diffuse_green\n');
        fprintf(fid,'property uchar diffuse_blue\n');
    end
	fprintf(fid,'end_header\n');
    
%write points
MT = depth2metersImage(depth);
for(x=1:dx)
    for(y=1:dy)
        if(depth(x,y)~=0)
            %[m_x m_y m_z] = depth2meters(x,y,depth(x,y));
            m_x = MT(x,y,1);
            m_y = MT(x,y,2);
            m_z = MT(x,y,3);
            if(rgb)
                fprintf(fid,'%f %f %f %u %u %u \n',-m_x,m_y,-m_z,image(x,y,1),image(x,y,2),image(x,y,3));
            else
                %fprintf(fid,'%f %f %f\n',x,y,-depth(x,y));
                fprintf(fid,'%f %f %f\n',-m_x,m_y,-m_z);
            end
        end
    end
end

fclose(fid);

