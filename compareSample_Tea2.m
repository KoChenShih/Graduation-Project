
function example()

data1 = multibandread('D:\畢專檔案2\20210812_BlackA_4.0f_6.5ms_corrected.raw',[333,400,150],'float32=>float32',0,'bsq','ieee-le');
data1 = double(data1);
data2 = multibandread('D:\畢專檔案2\20210812_GreenA_4.0f_6.5ms_corrected.raw',[333,400,150],'float32=>float32',0,'bsq','ieee-le');
data2 = double(data2);

%open file
fid=fopen('D:\畢專檔案2\20210812_BlackA_4.0f_6.5ms_corrected.hdr');
info=fread(fid,'char=>char');
info=info';
fclose(fid);

%wavelength
start=strfind(info,'wavelength = {');
len=length('wavelength = {');
stop=strfind(info,'}');

wavelength = [];
for i = start+len : stop-1
    wavelength = [wavelength, info(i)];
end
    wavelength = str2num(wavelength);
    wavelength = wavelength';
    
map = [1 0 0;
       1 0.5 0;
       1 1 0;
       0 1 0;
       0 0 1;
       0.9 0 1;
       0.9 0.7 0;
       0.5 1 1;
       0.7 0.2 0.3; 
       0.2 0.2 0;
       0 0.447 0.741;
       1 0 0.6;
       0 0 0.5;
       1 0.5 0.5;
       0.6 1 0.6;
       0.9 0.6 1;
       1 0.9 0.7;
       0.9 1 0.8;
       0.8 0.8 1
       ];      

  
time = 1;    


%做kmeans
I = cat(2,data1,data2);
[r,c,b] = size(I);
dat = reshape(I,r*c,b); %每一行以column major存I的資料到dat,會有150行
nonzero = any(dat>0.2,2);
[idx,Ctrs] = kmeans(dat(nonzero),3);    

temp = zeros(r*c,1);
temp(nonzero) = idx;
x1 = reshape(temp,r,c); %把temp變成r*c


%設定figure 1屬性
f1 = figure;
f1.Position = [950 50 550 700];
imagesc(label2rgb(x1,'parula','k')),axis off, axis image,hold on; %把kmeans的圖顯示出來
f1.Name = 'Compare';


set(f1,'WindowButtondownFcn',@callBack) ;


%設定figure 3屬性
f2 = figure('visible','off');
f2.Position = [100 200 800 500];
f2.Name = 'Result';

function callBack(object,event)
    t = gca;
    mousePos = get(gca,'CurrentPoint');
    x = fix(mousePos(1,1));
    y = fix(mousePos(1,2));
    disp(['x= ',num2str(x),'  y= ',num2str(y)]);
    
    e = 15; %用來決定做與周圍幾乘幾平均
    height = e; %正方形高
    width = e;  %正方形寬
   
    %把點顯示在figure上
    text('Position',[x,y],'String',['  ',num2str(y),' , ',num2str(x)],'Color',map(time,:),'FontWeight','bold');
    %拉出正方形
    rectangle('Position',[x-width/2 y-height/2 height width],'EdgeColor', map(time,:),'LineWidth', 1)
    
    %讓figure 3 顯現
    set(f2,'visible','on');
    
   ee = fix(e/2);
   eq = (ee+1);
    
    
    %做平均
    if (y-ee) < 1 && (x-ee) < 1       %最左上
        d1(time,:) = sum( sum( I([y y+ee],[x x+ee],:) ) )/(eq*eq);
        
    elseif (y-ee) < 1 && (x+ee) <=800 %最上
        d1(time,:) = sum( sum( I([y y+ee],[x-ee x x+ee],:) ) )/(eq*e);
        
    elseif (y-ee) < 1 && (x+ee) > 800 %最右上
        d1(time,:) = sum( sum( I([y y+ee],[x-ee x],:) ) )/(eq*eq);
        
    elseif (y+ee) <= 333 && (x-ee) < 1 %最左
        d1(time,:) = sum( sum( I([y-ee y y+ee],[x x+ee],:) ) )/(eq*e);
        
    elseif (y+ee) <= 333 && (x+ee) > 800 %最右
        d1(time,:) = sum( sum( I([y-ee y y+ee],[x-ee x],:) ) )/(eq*e);
        
    elseif (y+ee) > 333 && (x-ee) < 1 %最左下
        d1(time,:) = sum( sum( I([y-ee y],[x x+ee],:) ) )/(eq*eq);
        
    elseif (y+ee) > 333 && (x-ee) <=800 %最下
        d1(time,:) = sum( sum( I([y-ee y],[x-ee x x+ee],:) ) )/(eq*e);
        
    elseif (y+ee) > 333 && (x+ee) >800 %最右下
        d1(time,:) = sum( sum( I([y-ee y],[x-ee x],:) ) )/(eq*eq);   
        
    else
        d1(time,:) = sum( sum( I([y-ee y y+ee],[x-ee x x+ee],:) ) )/(e*e);
    end 
    
 figure(f2);
        plot(wavelength,d1(time,:),'Color',map(time,:)); 
 
    grid on
    hold on
    time = time + 1;  
    
end

end

