%load model mesh2005 in 
%
% Jamie Pringle, University of New Hampshire
%
% Saves out several .mat files with geometric information
% 
% mesh2005.mat contains
%   M the number of nodes, on which all scalers are stored (T,S,eta, H etc)
%   N the number of triangles, roughly twice M
%     also the number of U,V points, each on the centroid of the triangle
%   KBM1 the number of sigma levels on which U,V,T,S etc are stored.
%   
%   and the structure "mesh2005", whose feilds are
%   mesh2005.surround(N,3) the U,V (or centroid) points clockwise arround 
%                      a U,V point, called NBE in model and paper
%   mesh2005.trinodes(N,3) the t/s nodes surrounding a triangle, in clockwise order
%                      called NV in model and N(j) in paper
%   mesh2005.edges(M,6)  the up to 6 other nodes that each node is connected
%                    to. NaN if the edge does not exist.
%   mesh2005.nedges(M,1) the number of edges each node is connected to.
%   mesh2005.nodexy(M,2) the x and y position of the nodes, x is 1 coloumn
%   mesh2005.depth(M) the depth
%   mesh2005.uvnode(N,2) the x and y positions of the centroids of the triangles
%                    at which U and V are defined. (sorry for the poor name)
%   mesh2005.nodez(KBM1,M) the depth of each scaler, assuming free surface=0
%   mesh2005.zuv(KBM1,N)   the depth of each U,V point, assuming free surface=0
%   mesh2005.sigvec(KBM1) the sigma coordinate grid
%
% interpcoef.mat contains
% the interpolation coefficients to interpolate u,v and the scalers
% from where they are stored to any surrounding point. see the routines 
% window_sect_inf_make.f and window_sect_data_make.f for information, or
% secflux.m for how they are used.
%
% depthgrd.mat contains depth gridded onto a course rectangular grid
%    depthgrd.xvec is x dimension of grid
%    depthgrd.yvec is y dimension of grid
%    depthgrid.dpth is the depth
%
% depthgrd_fine.mat contains depth gridded onto a finer rectangular grid
%
%

clear all

%filename of datafile and grid file

% filedir  ='/Volumes/SHAOMING/ZJU/HZB/DATA_result/mshao_chj/output2005/netcdf'
addpath('/Volumes/SHAOMING/ZJU/HZB/DATA_result/mshao_chj/output2005/netcdf');
% filehname ='chj_0555.nc';
 filegrid='chj_0001.nc';

%get M, the number of nodes, and N, the number of triangles
 ncgrid=netcdf(filegrid,'nowrite');  
 %M=length(ncgrid{'VX'}); %number of nodes
 %N=length(ncgrid{'XC'}); %number of triangles
 M=length(ncgrid{'x'}); %number of nodes
 N=length(ncgrid{'v'}); %number of triangles
 
 %KBM1=size(ncgrid{'ZALL'},1);
 KBM1=size(ncgrid{'siglev'},1);
 
%%get mesh2005 data
 %mesh2005.surround=ncgrid{'NBE'}(:)';
 %mesh2005.trinodes=ncgrid{'NV'}(1:3,:)';
%  mesh2005.surround=ncgrid{''}(:)';
 mesh2005.trinodes=ncgrid{'nv'}(1:3,:)';

%read in node positions
 mesh2005.nodexy=zeros(M,2);
 mesh2005.nodexy(:,1)=ncgrid{'x'}';
 mesh2005.nodexy(:,2)=ncgrid{'y'}';

%get bathy data, and adjust as in model
 mesh2005.depth=ncgrid{'h'}(:);

%form u,v locations (the centroid of triangle)
 uvnodes=zeros(N,2);
 uvdepth=zeros(N,1);
 for n=1:N
   uvnode(n,1)=(mesh2005.nodexy(mesh2005.trinodes(n,1),1)+...
       mesh2005.nodexy(mesh2005.trinodes(n,2),1)+...
       mesh2005.nodexy(mesh2005.trinodes(n,3),1))/3;
   uvnode(n,2)=(mesh2005.nodexy(mesh2005.trinodes(n,1),2)+...
       mesh2005.nodexy(mesh2005.trinodes(n,2),2)+...
       mesh2005.nodexy(mesh2005.trinodes(n,3),2))/3;
   uvdepth(n)=(mesh2005.depth(mesh2005.trinodes(n,1))+...
       mesh2005.depth(mesh2005.trinodes(n,2))+...
       mesh2005.depth(mesh2005.trinodes(n,3)))/3;
 end
 mesh2005.uvnode=uvnode;
 mesh2005.uvdepth=uvdepth;

%% get data on how each node is connected to three other nodes
 edges=zeros(M,6)*nan;
 nedges=zeros(M,1); %number of edges already found
 for n=1:N
   n;
   [edges,nedges]=insert_edge(mesh2005.trinodes(n,1),mesh2005.trinodes(n,2),edges,nedges);
   [edges,nedges]=insert_edge(mesh2005.trinodes(n,2),mesh2005.trinodes(n,3),edges,nedges);
   [edges,nedges]=insert_edge(mesh2005.trinodes(n,3),mesh2005.trinodes(n,1),edges,nedges);
   [edges,nedges]=insert_edge(mesh2005.trinodes(n,2),mesh2005.trinodes(n,1),edges,nedges);
   [edges,nedges]=insert_edge(mesh2005.trinodes(n,3),mesh2005.trinodes(n,2),edges,nedges);
   [edges,nedges]=insert_edge(mesh2005.trinodes(n,1),mesh2005.trinodes(n,3),edges,nedges);
 end
 mesh2005.edges=edges;
 mesh2005.nedges=nedges;

%% create a full xyz list of node locations
%
%for node, their are KBM1 depths, so we must include all these depths in ...
%the list of locations
 zall=repmat((1:KBM1)',1,M);
 zuv=repmat((1:KBM1)',1,N);

%make z in depth coordinates, not the discrete equivalent of sigman coords.
 dsig=1/(KBM1+1);
 sigvec=(0:(KBM1-1))'*dsig+0.5*dsig;
 for m=1:M
   zall(:,m)=-sigvec*mesh2005.depth(m);
 end
 for n=1:N
   zuv(:,n)=-sigvec*mesh2005.uvdepth(n);
 end
 mesh2005.nodez=zall;
 mesh2005.zuv=zuv;
 mesh2005.sigvec=sigvec;
 
% save mesh2005 mesh2005 M N KBM1
save chjmesh20052005 mesh2005 M N KBM1
    
%the following produces depth on a 2D regular grid
%for ease of visualization.

%define the regular grid
 ndx=100;
 xvec=min(mesh2005.nodexy(:,1)):(max(mesh2005.nodexy(:,1))- min(mesh2005.nodexy(:,1)))/ndx:max(mesh2005.nodexy(:,1)); 
 yvec=min(mesh2005.nodexy(:,2)):(max(mesh2005.nodexy(:,2))- min(mesh2005.nodexy(:,2)))/ndx:max(mesh2005.nodexy(:,2)); 
 
%make the 2D depth array, and save
 dpth=griddata(mesh2005.nodexy(:,1),mesh2005.nodexy(:,2),mesh2005.depth,xvec,yvec');
 depthgrd.xvec=xvec;
 depthgrd.yvec=yvec;
 depthgrd.dpth=dpth;
 save chjdepthgrd2005 depthgrd

%define the regular grid
 ndx=300;
 xvec=min(mesh2005.nodexy(:,1)):(max(mesh2005.nodexy(:,1))- min(mesh2005.nodexy(:,1)))/ndx:max(mesh2005.nodexy(:,1)); 
 yvec=min(mesh2005.nodexy(:,2)):(max(mesh2005.nodexy(:,2))- min(mesh2005.nodexy(:,2)))/ndx:max(mesh2005.nodexy(:,2));
 
%make the 2D depth array, and save
 dpth=griddata(mesh2005.nodexy(:,1),mesh2005.nodexy(:,2),mesh2005.depth,xvec,yvec');
 depthgrd.xvec=xvec;
 depthgrd.yvec=yvec;
 depthgrd.dpth=dpth;
 save chjdepthgrd_fine_2005 depthgrd


 

%% plot nodes
figure
subplot 121
plot(mesh2005.nodexy(:,1),mesh2005.nodexy(:,2),'b.');

% plot(mesh2005.nodexy(:,1),mesh2005.nodexy(:,2),'b.',mesh2005.uvnode(:,1),mesh2005.uvnode(:,2),'r.');

hold on
for m=1:M
  for ne=1:mesh2005.nedges(m)
    plot([mesh2005.nodexy(m,1) mesh2005.nodexy(mesh2005.edges(m,ne),1)], ...
        [mesh2005.nodexy(m,2) mesh2005.nodexy(mesh2005.edges(m,ne),2)],'b-')
  end
end
hold off
     title('Model Grid, 2005','Margin',2,'FontSize',30,'FontName','Cambria')
   ylabel('X-coordinate [ Km]','Margin',2,'FontSize',30,'FontName','Cambria')
   xlabel('X-coordinate [ Km]','Margin',2,'FontSize',30,'FontName','Cambria')
    axis([0 6.5*10^5 3.13*10^6 3.79*10^6 ])

%    grid
   set(gca,'FontSize',30,'FontName','Cambria')   
   
   
subplot 122

plot(mesh2005.nodexy(:,1),mesh2005.nodexy(:,2),'b.');

% plot(mesh2005.nodexy(:,1),mesh2005.nodexy(:,2),'b.',mesh2005.uvnode(:,1),mesh2005.uvnode(:,2),'r.');

hold on
for m=1:M
  for ne=1:mesh2005.nedges(m)
    plot([mesh2005.nodexy(m,1) mesh2005.nodexy(mesh2005.edges(m,ne),1)], ...
        [mesh2005.nodexy(m,2) mesh2005.nodexy(mesh2005.edges(m,ne),2)],'b-')
  end
end
hold off
     title('Model Grid, 2005','Margin',2,'FontSize',30,'FontName','Cambria')
   ylabel('X-coordinate [ Km]','Margin',2,'FontSize',30,'FontName','Cambria')
   xlabel('X-coordinate [ Km]','Margin',2,'FontSize',30,'FontName','Cambria')
    axis([2*10^5 4.3*10^5 3.27*10^6 3.46*10^6 ])

%    grid
   set(gca,'FontSize',30,'FontName','Cambria')   
