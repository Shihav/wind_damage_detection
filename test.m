function [mask,IMSF,BW3]=test(tempC,X,Y,th)
% close all
% clc
fig=1;
I=tempC;

%BW = bwmorph(I,'thicken');
BW = edge(I,'canny');
%BW1 = imrotate(BW,90,'crop');
% figure, imshow(BW);
%BW=rotI;
[H,theta,rho] = hough(BW,'Theta',-90:0.5:89.5);

% figure, imshow(imadjust(mat2gray(H)),[],'XData',theta,'YData',rho,...
%         'InitialMagnification','fit');
% xlabel('\theta (degrees)'), ylabel('\rho');
% axis on, axis normal, hold on;
% colormap(hot)
P = houghpeaks(H,2,'NHoodSize',[63 11],'threshold',ceil(0.5*max(H(:))));
% x = theta(P(:,2));
% y = rho(P(:,1));
% plot(x,y,'s','color','w');
lines = houghlines(BW,theta,rho,P,'FillGap',50,'MinLength',100);
% lines = houghlines(BW,theta,rho,P);
% figure, imshow(BW), hold on
% max_len = 0;
% for k = 1:length(lines)
%    xy = [lines(k).point1; lines(k).point2];
%    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
%    % Plot beginnings and ends of lines
%    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
%    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
%      % Determine the endpoints of the longest line segment
% end
  

% figure, imshow(BW), hold on
% max_len = 0;
F=[];
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   x = xy(:,1);
   y = xy(:,2);
    c = [[1; 1]  x(:)]\y(:);                        % Calculate Parameter Vector
slope_m(k) = c(2);
intercept_b(k) = c(1);

F(:,:,k)=Y-X.*slope_m(k)-intercept_b(k);


%    m=(xy(1,2)-xy(2,2))/xy(1,1)-xy(2,1);
%    b=xy(1,2)-m
   
   
%    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
   % Plot beginnings and ends of lines
   %plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
  % plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
     % Determine the endpoints of the longest line segment
end

if intercept_b(1)>intercept_b(2)
mask=F(:,:,1)<0 & F(:,:,2)>0;
else
    mask=F(:,:,2)<0 & F(:,:,1)>0;
end
% figure;imagesc(mask);

IM=I;
IM(mask==0)=0;

% figure;imshow(IM);

IMS = imgaussfilt(IM,.5);
IMSF=IMS>th;
% figure
% imshow(IMSF);

BW3 = bwmorph(IMSF,'skel',Inf);
% figure
% imshow(BW3)




