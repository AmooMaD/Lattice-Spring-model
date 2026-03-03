% discription:
% calculate the relaxation of a cube wihch is initially under compression
%
 
clc
clear all
close all
%% lattice parameters
 
%deltaX=deltaY=deltaT=1; in lattice parameters
Ni=5;
Nj=75;
M=10;
E=1e0; %spring stifness
F0=1e-3;
Nc = 5e6; %number of cycles
cs = sqrt(3*E/M) %sound speed has to be smaller than one
theta = 0.5; %viscosity term to damp
 
% X from N to S and Y from W to E
%                             6  2  5
%                              \ | /
% locations based on model:  3--   --1
%                              / | \
%                             7  4  8
 
ex = [0,-1,0,1,-1,-1,1,1];
ey = [1,0,-1,0,1,-1,-1,1];
d0 = [1,1,1,1,sqrt(2),sqrt(2),sqrt(2),sqrt(2)]; %distqnce between lattice at rest
 
 
%% MESH %%
[X0,Y0] = meshgrid(1:Ni,1:Nj); %initial position of lattice
X0 = X0' ; Y0 = Y0' ; 
 
 
%% VARIABLES INITIALIZATION%%
Fx=zeros(Ni,Nj); Fy=zeros(Ni,Nj); %total force at each lattice
Vx=zeros(Ni,Nj); Vy=zeros(Ni,Nj); %velocity in T+deltaT

Ax=zeros(Ni,Nj);
Ay=zeros(Ni,Nj);

fx = zeros(Ni,Nj,8); %sub-force applied on the node i,j for the lattice k in the x direction
fy = zeros(Ni,Nj,8); %sub- force applied on the node i,j for the lattice k in the y direction

ux=zeros(Ni,Nj);
uy=zeros(Ni,Nj);
 
X = X0 ; Y = Y0 ; %initialisation of lattice positions at time t
 
%% initial an boundary conditions%%
Fx_ext=zeros(Ni,Nj); Fy_ext=zeros(Ni,Nj); %external forces applied on the object (boundary conditions)
Fx_ext(:,end) = F0; %Fx_ext(:,end)=-F0;

Fx_tot = Fx + Fx_ext; Fy_tot = Fy + Fy_ext; 
% 
% Ax = Fx_tot./M ;     Ay = Fy_tot./M ; %acceleration in t

 
figure(1), clf
plot(Y0,X0,'x'), hold on
quiver(Y0,X0,Fy_ext./F0,Fx_ext./F0,'LineWidth',3), axis equal on
 
ylabel('X'), xlabel('Y')
 
 
%% loop on the time to look at the steady state solution %%
 
for t=1:Nc
    
    
    Sx = Vx + 0.5.* Ax ; %v in t+1/2
    Sy = Vy + 0.5.* Ay ;
    
    X = X + Sx;   % relative displacement
    Y = Y + Sy;
    
%     
%     X(:,1) = X0(:,1);
%     Y(:,1) = Y0(:,1);
    
    %% calculate fx and fy for all the lattice,without care about BC %%
    for c =1:8
        
        dx = X - circshift(X,[-ex(c) -ey(c)]);   dy = Y - circshift(Y,[-ex(c) -ey(c)]);
        
        d =  sqrt( dx.^2 + dy.^2 ); %deformation
        
        fx(:,:,c) = -E .*  (d-d0(c)).*dx./d ;
        fy(:,:,c) = -E .*  (d-d0(c)).*dy./d ;
        
    end
        %% treatment of nodes at boundaries %%
    fx(1,:,[2 5 6]) = 0;       fy(1,:,[2 5 6]) = 0;     %north
    fx(end,:,[4 7 8]) = 0;     fy(end,:,[4 7 8]) = 0;     %south
    fx(:,1,[3 6 7]) = 0;       fy(:,1,[3 6 7]) = 0;     %west
    fx(:,end,[1 5 8]) = 0;     fy(:,end,[1 5 8]) = 0;  %east    
    
    
    %% total internal elastic force on each lattice %%
    Fx  = sum(fx,3); Fy  = sum(fy,3);    %elastic force
    
    Fx_ext(:,1)=-Fx(:,1); Fy_ext(:,1)=-Fy(:,1); %fixed east bounary
        
    %Fx_ext(:,end)=-Fx(:,end); Fy_ext(:,end)=-Fy(:,end); %fixed west bounary
    
    Fx_tot = Fx + Fx_ext; Fy_tot = Fy + Fy_ext; 
        
    Ax = Fx_tot./M - theta.*Sx;    
    Ay = Fy_tot./M - theta.*Sy; %acceleration in t
    
        
    Vx = Sx + 0.5.* Ax;   %v in t
    Vy = Sy + 0.5.* Ay;
      
        
    if mod(t,5000)==1
        
    figure(2), clf
    subplot(2,2,1),imagesc(Fx_tot), colorbar
    subplot(2,2,2),imagesc(Fy_tot), colorbar
    subplot(2,2,3), plot(Fx_tot(ceil(Ni/2),:),'o')
    subplot(2,2,4), plot(Y,X,'o'),xlabel('X'), ylabel('Y'), axis equal on
    drawnow
    
    end
end