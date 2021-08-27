
clear;

data = multibandread('D:\畢專檔案2\20210812_BlackA_4.0f_6.5ms_reflectance.raw',[333,400,150],'float32=>float32',0,'bsq','ieee-le');
data = double(data);
data2 = multibandread('D:\畢專檔案2\20210812_GreenA_4.0f_6.5ms_reflectance.raw',[333,400,150],'float32=>float32',0,'bsq','ieee-le');
data2 = double(data2);

I = cat(2,data,data2);
[fl,s,b] = size(I);

%一列是一個樣本點的298*1向量(每一個樣本點裡的特徵資訊就是各個波段)
dat = reshape(I,fl*s,b);
nonzero = any(dat>0.2,2);
%執行kmeans將 n*p矩陣(dat)的觀測值劃分為k群,idx :N*1的向量，儲存的是每個點的分群標號
[idx,Ctrs]=kmeans(dat(nonzero),4);                                    
temp = zeros(fl*s,1);
temp(nonzero) = idx;
x1 = reshape(temp,fl,s);

figure,imagesc(label2rgb(x1,'parula','k')),axis off, axis image;

%畫出聚類為n的點。dat(Idx==1,1),為第一類的樣本的第一個座標；X(Idx==1,2)為第二類的樣本的第二個座標...
% plot(combine(idx==1,1),combine(idx==1,2),'r.','MarkerSize',14)
% hold on
% plot(combine(idx==2,1),combine(idx==2,2),'b.','MarkerSize',14)
% hold on
% plot(dat(idx==3,1),dat(idx==3,2),'g.','MarkerSize',14)
% hold on
% plot(dat(idx==4,1),dat(idx==4,2),'y.','MarkerSize',14)  

% plot(Ctrs(:,1),Ctrs(:,2),'kx','MarkerSize',14,'LineWidth',4)
% plot(Ctrs(:,1),Ctrs(:,2),'kx','MarkerSize',14,'LineWidth',4)
% plot(Ctrs(:,1),Ctrs(:,2),'kx','MarkerSize',14,'LineWidth',4)
% plot(Ctrs(:,1),Ctrs(:,2),'kx','MarkerSize',14,'LineWidth',4)

%legend('Cluster 1','Cluster 2','Centroids','Location','NW')

