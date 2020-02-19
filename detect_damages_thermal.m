clear all
close all
clc
% 
v = VideoReader('XC_0-Rec-BladewithTEdefectsNEW-000107-350_15_55_01_928.wmv');
% k=1;
% frame=[];
% while hasFrame(v)
%     frame(:,:,k) = rgb2gray(readFrame(v));
%     k=k+1
% 
% nframe=size(frame,3);
% detect=uint8(zeros(size(frame)));
% end
% 
[X,Y] = meshgrid(1:640,1:480);
% 
th=150;
k=1;
frame=[];
sized=[];
mkdir('results')
mkdir(['results' filesep 'frame'])
mkdir(['results' filesep 'blade'])
mkdir(['results' filesep 'damage'])
mkdir(['results' filesep 'segment'])
mkdir(['results' filesep 'crack'])
mkdir(['results' filesep 'plot'])
mkdir(['results' filesep 'final'])
mkdir(['results' filesep 'final2'])

while hasFrame(v)
    temp=uint8(rgb2gray(readFrame(v)));
    tempC=temp(1:480,1:640,:);
%     figure(1)
%     imshow(tempC);
    [mask,IMSF,BW3]=test(tempC,X,Y,th);
%     figure(2)
%     H = fspecial('laplacian',.5);
% J = imfilter(tempC,H,'replicate'); 
% %imshow(blurred);
%  %   J = uint8(stdfilt(tempC));
%     imshow(J);
% close all
% figure(1)
% imshow([tempC 255*mask;255*IMSF 255*BW3]);

    qzr2=tempC;
            colormap(hot) 
                                        C = colormap; 
                L = size(C,1);
                Gs = round(interp1(linspace(1,255,L),1:L,double(round(qzr2))));
                Gs(isnan(Gs))=1;
       
                H = reshape(C(Gs,:),[size(Gs) 3]); 
                tempCR=uint8(255*H);
                imwrite(tempCR,[cd filesep 'results' filesep 'frame' filesep 'frame' num2str(k,'%.3d') '.png']);
%                 figure;imshow(tempCR);
%                  se = offsetstrel('ball',5,5);
                BW = edge(mask,'canny');
                se = strel('line',11,90);
                BW2=imdilate(BW,se);

                
                TC=tempCR;
                colg=[60 255 40];
                for kin=1:3
                    tt=TC(:,:,kin);
                    tt(BW2==1)=colg(kin);
                    TC(:,:,kin)=tt;
                end
%                 figure;imshow(TC);
                imwrite(TC,[cd filesep 'results' filesep 'blade' filesep 'blade' num2str(k,'%.3d') '.png']);
                TCR=tempCR;
                for kin=1:3
                    tt=TCR(:,:,kin);
                    tt(mask==0)=0;
                    TCR(:,:,kin)=tt;
                end
%                 figure;imshow(TCR);
                
%                 stats = regionprops(IMSF);
%                 centroid = stats.Centroid;
                
                [xmin,ymin]=find(IMSF==1);
                if size(xmin,1)==0
                    cx=240;
                    cy=320;
                else
                cx=mean(xmin);
                cy=mean(ymin);
                end
                
                cxin=cx-50;
                cxout=cx+49;
                cyin=cy-50;
                cyout=cy+49;
                
                dk=[5,5,5,5];
                dk2=[5,5,5,5];
                kid=1;
                portion(1,:)=[cxin cxout cyin cyout];
                colorb=[0.9 0.9 0]*255;
                size1=size(IMSF,1);
                size2=size(IMSF,2);
                slice1=uint8(255*ones(size1,5,3));
                slice2=uint8(255*ones(5,5,3));
                slice3=uint8(255*ones(5,size2,3));
                slice4=uint8(255*ones(size1,size2,3));
                
                TCRB=Bor_create(TCR,portion,dk2,colorb,kid);
%                 figure;imshow(TCRB);
imwrite(TCRB,[cd filesep 'results' filesep 'damage' filesep 'damage' num2str(k,'%.3d') '.png']);
                
                cutC=imresize(TCR(cxin:cxout,cyin:cyout,:),[size1 size2],'nearest');
%                 figure;imshow(cutC);
                cutD=imresize(IMSF(cxin:cxout,cyin:cyout,:),[size1 size2],'nearest');
%                 figure;imshow(cutD);
                bor=cutD-imerode(cutD,ones(9));
%                 figure;imshow(bor);
                cutCC=cutC;
                for kin=1:3
                    tt=cutCC(:,:,kin);
                    tt(bor==1)=colg(kin);
                    cutCC(:,:,kin)=tt;
                end
%                                 figure;imshow(cutCC);
                         imwrite(cutCC,[cd filesep 'results' filesep 'segment' filesep 'segment' num2str(k,'%.3d') '.png']);       
                                  cutS=imresize(BW3(cxin:cxout,cyin:cyout,:),[size1 size2],'nearest');
                                  cutS=imdilate(cutS,ones(9));
%                 figure;imshow(cutS);  
                
                                cutCS=cutC;
                for kin=1:3
                    tt=cutCS(:,:,kin);
                    tt(cutS==1)=colg(kin);
                    cutCS(:,:,kin)=tt;
                end
%                                 figure;imshow(cutCS);
                 imwrite(cutCS,[cd filesep 'results' filesep 'crack' filesep 'crack' num2str(k,'%.3d') '.png']);               

sized(k)=length(xmin);
figure

s=scatter(1:k,sized,30,[.2 .2 .2],'filled');hold on
s.MarkerFaceAlpha = .3; 

polyplot(1:k,sized,5,'r-','linewidth',3);

ylim([75 275]);
xlim([1 750]);

   set(gca, 'Ticklength', [0 0])

ylabel(['Size of the crack in number of pixels'],'FontSize', 16,'FontName','Arial');
xlabel(['Number of frame'],'FontSize', 16,'FontName','Arial');
% title(['Damage progression'],'FontSize', 25,'FontName','Arial');

  
set(gcf,'color','w');
grid off
box off

ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
                                            set(gcf,'PaperPositionMode','auto')
%  imwrite(tempCR,[cd filesep 'results' filesep 'frame' filesep 'frame' num2str(k,'%.3d') '.png']);                                           
export_fig([cd filesep 'results' filesep 'plot' filesep 'plot' num2str(k,'%.3d')],'-a2', '-m3','-p0.05','-q101','-png', '-r300'); 
% 
% 
fin = imresize(imread([cd filesep 'results' filesep 'plot' filesep 'plot' num2str(k,'%.3d') '.png']),[size1 size2-100]);
if size(fin,3)==1
fin1=[uint8(255*ones(size1,50)) fin uint8(255*ones(size1,50))];
fin2=cat(3,fin1,fin1,fin1);
else
fin2=[uint8(255*ones(size1,50,3)) fin uint8(255*ones(size1,50,3))];
end
% 
%                      
 cutCC1=Bor_create(cutCC,[1 480 1 640],dk2,colorb,kid);
 cutCS1=Bor_create(cutCS,[1 480 1 640],dk2,colorb,kid);
 
 Final= [slice2 slice3 slice2 slice3 slice2 slice3 slice2;
     slice1 tempCR slice1 TC slice1 TCRB slice1;
     slice2 slice3 slice2 slice3 slice2 slice3 slice2;
     slice1 cutCC1 slice1 cutCS1 slice1 fin2 slice1
     ];
%        slice1 resC3(:,:,:,1) slice1 resC3(:,:,:,2) slice1 resC3(:,:,:,3) slice1 resC3(:,:,:,4) slice1;         
%        slice5 slice6 slice5 slice6 slice5 slice6 slice5 slice6 slice5;  
%         slice1 resC3(:,:,:,5) slice1 resC3(:,:,:,6) slice1 resC3(:,:,:,7) slice1 resC3(:,:,:,8) slice1;         
%        slice5 slice6 slice5 slice6 slice5 slice6 slice5 slice6 slice5;  
%         slice1 resC3(:,:,:,9) slice1 resC3(:,:,:,10) slice1 resC3(:,:,:,11) slice1 resC3(:,:,:,12) slice1;         
% %         slice5 slice6 slice5 slice6 slice5 slice6 slice5 slice6 slice5;  
% %         slice1 resZ2(:,:,:,10) slice1 resZ2(:,:,:,11) slice1 resZ2(:,:,:,12) slice1;         
%         slice2 slice3 slice2 slice3 slice2 slice3 slice2 slice3 slice2;
%             ];

imwrite(Final,[cd filesep 'results' filesep 'final' filesep 'final' num2str(k,'%.3d') '.png']); 

 slice5=uint8(255*ones(50,5,3));
slice6=uint8(255*ones(50,640,3));
 
 Final2= [slice2 slice3 slice2 slice3 slice2 slice3 slice2;
     slice5 slice6 slice5 slice6 slice5 slice6 slice5;
     slice1 tempCR slice1 TC slice1 TCRB slice1;
     slice2 slice3 slice2 slice3 slice2 slice3 slice2;
     slice5 slice6 slice5 slice6 slice5 slice6 slice5;
     slice1 cutCC1 slice1 cutCS1 slice1 fin2 slice1;
     slice2 slice3 slice2 slice3 slice2 slice3 slice2;
     ];
 
          
          Final2 = insertText(Final2,[325 30],'A. Thermal Image','FontSize',45,'Font','Arial','BoxOpacity',0,'AnchorPoint','center');
          Final2 = insertText(Final2,[970 30],'B. Blade Detection','FontSize',45,'Font','Arial','BoxOpacity',0,'AnchorPoint','center');
          Final2 = insertText(Final2,[1615 30],'C. Damage Localization','FontSize',45,'Font','Arial','BoxOpacity',0,'AnchorPoint','center');
          Final2 = insertText(Final2,[325 565],'D. Damage Segmentation','FontSize',45,'Font','Arial','BoxOpacity',0,'AnchorPoint','center');
          Final2 = insertText(Final2,[970 565],'E. Crack Identification','FontSize',45,'Font','Arial','BoxOpacity',0,'AnchorPoint','center');
          Final2 = insertText(Final2,[1615 565],'F. Damage Progression','FontSize',45,'Font','Arial','BoxOpacity',0,'AnchorPoint','center');


imwrite(Final2,[cd filesep 'results' filesep 'final2' filesep 'final2' num2str(k,'%.3d') '.png']); 


k=k+1
close all
end
