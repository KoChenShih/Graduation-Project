
function example()

data1 = multibandread('D:\畢專檔案2\20210812_BlackA_4.0f_6.5ms_reflectance.raw',[333,400,150],'float32=>float32',0,'bsq','ieee-le');
data1 = double(data1);
data2 = multibandread('D:\畢專檔案2\20210812_GreenA_4.0f_6.5ms_reflectance.raw',[333,400,150],'float32=>float32',0,'bsq','ieee-le');
data2 = double(data2);

%open file
fid=fopen('D:\畢專檔案2\20210812_BlackA_4.0f_6.5ms_reflectance.hdr');
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

A = data1(:,:,1);
B = data2(:,:,1);

%設定figure 1屬性
f1 = figure;
tiledlayout(2,1);
f1.Position = [950 50 550 700];
nexttile
imagesc(A),axis off,axis image,colormap(gray),hold on;
nexttile
imagesc(B),axis off,axis image,colormap(gray),hold on;
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
    
    %把點顯示在figure上
    text('Position',[x,y],'String',['* ',num2str(y),' , ',num2str(x)],'Color',map(time,:),'FontWeight','bold');
   
    
    %讓figure 3 顯現
    set(f2,'visible','on');
    
    %ind2sub
    %sub2ind
    
    %存資料到r1跟r2陣列
    %{
 d1(time,:) = data1(y,x,:) + data1(y-1,x-1,:) + data1(y,x-1,:) +... 
                 data1(y+1,x-1,:) + data1(y+1,x,:) + data1(y+1,x+1,:) +...
                 data1(y,x+1,:) + data1(y-1,x+1,:) + data1(y-1,x,:);
    d1(time,:) = d1(time,:)/9;
    %}
    
    if (y-1) < 1 && (x-1) < 1       %最左上
        d1(time,:) = sum( sum( data1([y y+1],[x x+1],:) ) )/4;
        
    elseif (y-1) < 1 && (x+1) <=400 %最上
        d1(time,:) = sum( sum( data1([y y+1],[x-1 x x+1],:) ) )/6;
        
    elseif (y-1) < 1 && (x+1) > 400 %最右上
        d1(time,:) = sum( sum( data1([y y+1],[x-1 x],:) ) )/4;
        
    elseif (y+1) <= 333 && (x-1) < 1 %最左
        d1(time,:) = sum( sum( data1([y-1 y y+1],[x x+1],:) ) )/6;
        
    elseif (y+1) <= 333 && (x+1) > 400 %最右
        d1(time,:) = sum( sum( data1([y-1 y y+1],[x-1 x],:) ) )/6;
        
    elseif (y+1) > 333 && (x-1) < 1 %最左下
        d1(time,:) = sum( sum( data1([y-1 y],[x x+1],:) ) )/4;
        
    elseif (y+1) > 333 && (x-1) <=400 %最下
        d1(time,:) = sum( sum( data1([y-1 y],[x-1 x x+1],:) ) )/6;
        
    elseif (y+1) > 333 && (x+1) >400 %最右下
        d1(time,:) = sum( sum( data1([y-1 y],[x-1 x],:) ) )/4;   
        
    else
        d1(time,:) = sum( sum( data1([y-1 y y+1],[x-1 x x+1],:) ) )/9;
    end

    %{
    d2(time,:) = data2(y,x,:) + data2(y-1,x-1,:) + data2(y,x-1,:) +... 
                 data2(y+1,x-1,:) + data2(y+1,x,:) + data2(y+1,x+1,:) +...
                 data2(y,x+1,:) + data2(y-1,x+1,:) + data2(y-1,x,:);
    d2(time,:) = d2(time,:)/9;
    %}
    
    if (y-1) < 1 && (x-1) < 1       %最左上
        d2(time,:) = sum( sum( data2([y y+1],[x x+1],:) ) )/4;
        
    elseif (y-1) < 1 && (x+1) <=400 %最上
        d2(time,:) = sum( sum( data2([y y+1],[x-1 x x+1],:) ) )/6;
        
    elseif (y-1) < 1 && (x+1) > 400 %最右上
        d2(time,:) = sum( sum( data2([y y+1],[x-1 x],:) ) )/4;
        
    elseif (y+1) <= 333 && (x-1) < 1 %最左
        d2(time,:) = sum( sum( data2([y-1 y y+1],[x x+1],:) ) )/6;
        
    elseif (y+1) <= 333 && (x+1) > 400 %最右
        d2(time,:) = sum( sum( data2([y-1 y y+1],[x-1 x],:) ) )/6;
        
    elseif (y+1) > 333 && (x-1) < 1 %最左下
        d2(time,:) = sum( sum( data2([y-1 y],[x x+1],:) ) )/4;
        
    elseif (y+1) > 333 && (x-1) <=400 %最下
        d2(time,:) = sum( sum( data2([y-1 y],[x-1 x x+1],:) ) )/6;
        
    elseif (y+1) > 333 && (x+1) >400 %最右下
        d2(time,:) = sum( sum( data2([y-1 y],[x-1 x],:) ) )/4;   
        
    else
        d2(time,:) = sum( sum( data2([y-1 y y+1],[x-1 x x+1],:) ) )/9;
    end
    
 figure(f2);
    if t.Position(1,2)==0.5875
        plot(wavelength,d1(time,:),'Color',map(time,:)); 
    else
        plot(wavelength,d2(time,:),'Color',map(time,:)); 
    
    end

    
    grid on
    hold on
    time = time + 1;  
    
end

end

