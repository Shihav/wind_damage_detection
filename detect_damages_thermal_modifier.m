clear all
close all
clc

names{1}='HGA04A-01';
names{2}='HGA04A-02';
names{3}='HGA04A-03';
names{4}='HGA05A-02';
names{5}='HGA05A-03';
names{6}='Specimen1';

% flist=[276 975;
%     101 800;
%     121 670;
%     151 900;
%     101 850;
%     800 1350];

flist=[1 1053;
    1 819;
    1 721;
    1 930;
    1 902;
    1 1408];

thlist=[126 126 126 126 126 126]
step=1;

for in=1:6

fname=names{in};
% 
v = VideoReader([fname '.avi']);

A = xlsread([cd filesep 'Correlation' filesep fname ' ImageCycles' '.xlsx']);

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
[X,Y] = meshgrid(1:854,1:338);
% 
th=thlist(in);
k=1;
frame=[];
sized=[];
cyc=[];
mkdir(fname)
mkdir([fname filesep 'frame'])
% mkdir([fname filesep 'blade'])
% mkdir([fname filesep 'damage'])
mkdir([fname filesep 'segment'])
% mkdir([fname filesep 'crack'])
mkdir([fname filesep 'plot'])
mkdir([fname filesep 'final'])
% mkdir([fname filesep 'final2'])

temp=uint8(rgb2gray(read(v,flist(in,2)-5)));

tempC=temp(43:896,1165:1502,:);
tempC(:)=0;
tempC(225:(854-124),49:(338-28))=1;
IMSFt=tempC;

% [maskt,IMSFt,BW3t]=test_modifier(tempC,th-15);

for kin=flist(in,1):step:flist(in,2)
% while hasFrame(v)
%     temp=uint8(rgb2gray(readFrame(v)));
    temp=uint8(rgb2gray(read(v,kin)));
%       tempt=uint8(rgb2gray(read(v,kin-13)));
    tempC=temp(43:896,1165:1502,:);
%     tempCt=tempt(43:896,1165:1502,:);
%     tempCd=abs(tempC-tempCt);
%     figure(1)
%     imshow(tempC);
    [mask,IMSF,BW3]=test_modifier(tempC,th);
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
            colormap(bone) 
                                        C = colormap; 
                L = size(C,1);
                Gs = round(interp1(linspace(1,255,L),1:L,double(round(qzr2))));
                Gs(isnan(Gs))=1;
       
                H = reshape(C(Gs,:),[size(Gs) 3]); 
                tempCR=uint8(255*H);
                imwrite(tempCR,[cd filesep fname filesep 'frame' filesep fname '_frame_' num2str(k,'%.4d') '.png']);
%                 figure;imshow(tempCR);
%                  se = offsetstrel('ball',5,5);
%                 BW = edge(mask,'canny');
%                 se = strel('line',11,90);
%                 BW2=imdilate(BW,se);
% 
%                 
%                 TC=tempCR;
                colg=[245 60 40];
                colgr=[45 60 245];
                colw=[255 255 255];
%                 for kin=1:3
%                     tt=TC(:,:,kin);
%                     tt(BW2==1)=colg(kin);
%                     TC(:,:,kin)=tt;
%                 end
%                 figure;imshow(TC);
%                 imwrite(TC,[cd filesep fname filesep 'blade' filesep 'blade' num2str(k,'%.4d') '.png']);
%                 TCR=tempCR;
%                 for kin=1:3
%                     tt=TCR(:,:,kin);
%                     tt(mask==0)=0;
%                     TCR(:,:,kin)=tt;
%                 end
%                 figure;imshow(TCR);
                
%                 stats = regionprops(IMSF);
%                 centroid = stats.Centroid;
                
                [xmin,ymin]=find(IMSF==1);
%                 if size(xmin,1)==0
%                     cx=size(IMSF,1)/2;
%                     cy=size(IMSF,2)/2;
%                 else
%                 cx=mean(xmin);
%                 cy=mean(ymin);
%                 end
%                 
%                 cxin=cx-100;
%                 cxout=cx+49;
%                 cyin=cy-50;
%                 cyout=cy+49;
%                 
                dk=[5,5,5,5];
                dk2=[5,5,5,5];
                kid=1;
%                 portion(1,:)=[cxin cxout cyin cyout];
                colorb=[0.9 0.9 0]*255;
                size1=size(IMSF,1);
                size2=size(IMSF,2);
                slice1=uint8(255*ones(size1,5,3));
                slice2=uint8(255*ones(5,5,3));
                slice3=uint8(255*ones(5,size2,3));
                slice4=uint8(255*ones(size1,size2,3));
                
                TCR=tempCR;
%                 
%                 cutCC=Bor_create(TCR,portion,dk2,colorb,kid);
%                 figure;imshow(TCRB);
% imwrite(TCRB,[cd filesep fname filesep 'damage' filesep 'damage' num2str(k,'%.4d') '.png']);
                
                cutC=TCR;
%                 figure;imshow(cutC);
                cutD=IMSFt;
%                 figure;imshow(cutD);
                bor=cutD-imerode(cutD,ones(9));
%                 figure;imshow(bor);
                cutCC=cutC;
                for kin1=1:3
                    tt=cutCC(:,:,kin1);
                    tt(bor==1)=colw(kin1);
                    cutCC(:,:,kin1)=tt;
                end
                
                                cutC=cutCC;
%                 figure;imshow(cutC);
                cutD=IMSF;
%                 figure;imshow(cutD);
                bor=cutD-imerode(cutD,ones(9));
%                 figure;imshow(bor);
                cutCC=cutC;
                for kin2=1:3
                    tt=cutCC(:,:,kin2);
                    tt(bor==1)=colg(kin2);
                    cutCC(:,:,kin2)=tt;
                end
%                                 figure;imshow(cutCC);
                         imwrite(cutCC,[cd filesep fname filesep 'segment' filesep fname '_segment_' num2str(k,'%.4d') '.png']);       
                                  cutS=BW3;
                                  cutS=imdilate(cutS,ones(3));
%                 figure;imshow(cutS);  
                
%                                 cutCS=cutC;
%                 for kin=1:3
%                     tt=cutCS(:,:,kin);
%                     tt(cutS==1)=colgr(kin);
%                     cutCS(:,:,kin)=tt;
%                 end
% %                                 figure;imshow(cutCS);
%                  imwrite(cutCS,[cd filesep fname filesep 'crack' filesep 'crack' num2str(k,'%.4d') '.png']);               

%sized(k)=length(xmin);
sized(k)=mean(tempC(IMSFt>0));
cyc(k)=A(kin,2);
% figure

s=scatter(cyc,sized,30,[.5 .3 .3],'filled');hold on
s.MarkerFaceAlpha = .4; 

polyplot(cyc,sized,7,'r-','linewidth',3);

ylim([30 160]);
% xlim([1 round((flist(in,2)-flist(in,1))/step)]);
xlim([1 max(A(:,2))]);

   set(gca, 'Ticklength', [0 0])

ylabel(['Mean thermal intensity at region of interest'],'FontSize', 12,'FontName','Arial');
xlabel(['Number of cycles'],'FontSize', 12,'FontName','Arial');
% title(['Damage progression'],'FontSize', 25,'FontName','Arial');

  
set(gcf,'color','w');
grid off
box off

ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
                                            set(gcf,'PaperPositionMode','auto')
%  imwrite(tempCR,[cd filesep fname filesep 'frame' filesep 'frame' num2str(k,'%.4d') '.png']);                                           
export_fig([cd filesep fname filesep 'plot' filesep fname '_plot_' num2str(k,'%.4d')],'-a2', '-m3','-p0.05','-q101','-png', '-r300'); 
% 
% 
fin = imresize(imread([cd filesep fname filesep 'plot' filesep fname '_plot_' num2str(k,'%.4d') '.png']),[size(IMSF,1) 3*size(IMSF,2)]);
if size(fin,3)==1
% fin1=[uint8(255*ones(size1,50)) fin uint8(255*ones(size1,50))];
fin2=cat(3,fin,fin,fin);
else
fin2=fin;
end
% % 
% %                      
%  cutCC1=Bor_create(cutCC,[1 480 1 640],dk2,colorb,kid);
%  cutCS1=Bor_create(cutCS,[1 480 1 640],dk2,colorb,kid);
%  

slice5=uint8(255*ones(50,5,3));
slice6=uint8(255*ones(50,size(IMSF,2),3));

 Final= [slice2 slice3 slice2 slice3 slice2 slice3 slice3 slice3 slice2;
     slice5 slice6 slice5 slice6 slice5  slice6 slice6 slice6 slice5;
     slice1 tempCR slice1 cutCC slice1 fin2 slice1;
     slice2 slice3 slice2 slice3 slice2 slice3 slice3 slice3 slice2
%      slice2 slice3 slice2 slice3 slice2 slice3 slice2 slice3 slice3 slice3 slice2;
     ];
 
          Final = insertText(Final,[338/2+5 30],'A. Thermal Image','FontSize',30,'Font','Arial','BoxOpacity',0,'AnchorPoint','center');
%           Final = insertText(Final,[970 30],'B. Blade Detection','FontSize',45,'Font','Arial','BoxOpacity',0,'AnchorPoint','center');
%           Final = insertText(Final,[1615 30],'C. Damage Localization','FontSize',45,'Font','Arial','BoxOpacity',0,'AnchorPoint','center');
          Final = insertText(Final,[338+338/2+10 30],'B. Damage Segmentation','FontSize',30,'Font','Arial','BoxOpacity',0,'AnchorPoint','center');
%           Final = insertText(Final,[2*338+15+338/2 30],'C. Crack Identification','FontSize',30,'Font','Arial','BoxOpacity',0,'AnchorPoint','center');
          Final = insertText(Final,[2*338+15+3*338/2 30],'C. Damage Progression','FontSize',30,'Font','Arial','BoxOpacity',0,'AnchorPoint','center');


 
% %        slice1 resC3(:,:,:,1) slice1 resC3(:,:,:,2) slice1 resC3(:,:,:,3) slice1 resC3(:,:,:,4) slice1;         
% %        slice5 slice6 slice5 slice6 slice5 slice6 slice5 slice6 slice5;  
% %         slice1 resC3(:,:,:,5) slice1 resC3(:,:,:,6) slice1 resC3(:,:,:,7) slice1 resC3(:,:,:,8) slice1;         
% %        slice5 slice6 slice5 slice6 slice5 slice6 slice5 slice6 slice5;  
% %         slice1 resC3(:,:,:,9) slice1 resC3(:,:,:,10) slice1 resC3(:,:,:,11) slice1 resC3(:,:,:,12) slice1;         
% % %         slice5 slice6 slice5 slice6 slice5 slice6 slice5 slice6 slice5;  
% % %         slice1 resZ2(:,:,:,10) slice1 resZ2(:,:,:,11) slice1 resZ2(:,:,:,12) slice1;         
% %         slice2 slice3 slice2 slice3 slice2 slice3 slice2 slice3 slice2;
% %             ];
% 
imwrite(Final,[cd filesep fname filesep 'final' filesep fname '_final_' num2str(k,'%.4d') '.png']); 
% 
%  slice5=uint8(255*ones(50,5,3));
% slice6=uint8(255*ones(50,640,3));
%  
%  Final2= [slice2 slice3 slice2 slice3 slice2 slice3 slice2;
%      slice5 slice6 slice5 slice6 slice5 slice6 slice5;
%      slice1 tempCR slice1 TC slice1 TCRB slice1;
%      slice2 slice3 slice2 slice3 slice2 slice3 slice2;
%      slice5 slice6 slice5 slice6 slice5 slice6 slice5;
%      slice1 cutCC1 slice1 cutCS1 slice1 fin2 slice1;
%      slice2 slice3 slice2 slice3 slice2 slice3 slice2;
%      ];
%  
%           

% imwrite(Final2,[cd filesep fname filesep 'final2' filesep 'final2' num2str(k,'%.4d') '.png']); 


k=k+1
close all
end
end