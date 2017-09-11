%%%%%%%%%%%%%%MATLAB SCript to Automatically Detect chAT Surfaces%%%%%%%%%
clear all
close all

%STEP 1%%%%%%%%%%Downsample Image to 128x128x64%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%remember to put image in VNet/ImagesHere folder%%%%%%%%%%%%%%%
files = dir('/media/areca_raid/VNet/ImagesHere/*chAT_STD.tif');
for file = files'
    FileTif = file.name;
    if exist(strcat('/media/areca_raid/VNet/Dataset/TBP/',FileTif), 'file') ~= 2
        %FileTif = '00505_2R_C01_chAT_STD.tif'
        InfoImage=imfinfo(FileTif);
        mImage=InfoImage(1).Width;
        nImage=InfoImage(1).Height;
        NumberImages=length(InfoImage);
        im=zeros(nImage,mImage,NumberImages,'uint16');
        
        TifLink = Tiff(FileTif, 'r');
        for i=1:NumberImages
            TifLink.setDirectory(i);
            im(:,:,i)=TifLink.read();
        end
        TifLink.close();
        
        ny=128;nx=128;nz=64; %% desired output dimensions
        [y x z]=...
            ndgrid(linspace(1,size(im,1),ny),...
            linspace(1,size(im,2),nx),...
            linspace(1,size(im,3),nz));
        imOut=interp3(double(im),x,y,z);
        imOut = uint16(imOut);
        
        imwrite(imOut(:,:,1), strcat('/media/areca_raid/VNet/Dataset/TBP/',FileTif));
        for k = 2:size(imOut,3)
            imwrite(imOut(:,:,k), strcat('/media/areca_raid/VNet/Dataset/TBP/',FileTif), 'writemode', 'append');
        end
    end
end
cd('/media/areca_raid/VNet/')


%STEP 2%%%%%%%%%%%%Call python to run CNN%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
system('python /media/areca_raid/VNet/main.py -test'); %%detect ON
pause(1);
system('python /media/areca_raid/VNet/main.py -test2');  %%detect OFF
pause(1);

%STEP 3%%%%%%%%%%Resample to Original Size%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all;
files = dir('/media/areca_raid/VNet/ImagesHere/*chAT_STD.tif');
for file = files'
    FileTif = file.name;
    fname = strrep(FileTif,'chAT_STD.tif','');
    cnnname = strcat(fname, 'chAT_STD_rotate.tif');
    
    if exist(strcat('/media/areca_raid/VNet/ResultsON/',cnnname), 'file') == 2
        %FileTif = '00505_2R_C01_chAT_STD.tif'
        InfoImage=imfinfo(strcat('/media/areca_raid/VNet/ResultsON/',cnnname));
        mImage=InfoImage(1).Width;
        nImage=InfoImage(1).Height;
        NumberImages=length(InfoImage);
        
        cnnim = zeros(nImage, mImage, NumberImages, 'uint8');
        TifLink = Tiff(strcat('/media/areca_raid/VNet/ResultsON/',cnnname), 'r');
        for i=1:NumberImages
            TifLink.setDirectory(i);
            cnnim(:,:,i)=TifLink.read();
        end
        TifLink.close();
        
        InfoImage=imfinfo(strcat('/media/areca_raid/VNet/ImagesHere/',FileTif));  %this is dst image to project to
        nx=InfoImage(1).Width;
        nz=InfoImage(1).Height;
        ny=length(InfoImage);
        
        [y x z]=...
            ndgrid(linspace(1,size(cnnim,1),ny),...
            linspace(1,size(cnnim,2),nx),...
            linspace(1,size(cnnim,3),nz));
        
        imcnnOutON=interp3(double(cnnim),x,y,z, 'spline');
        imcnnOutON = uint8(imcnnOutON);
        
        
%%%%%%%%%%%CAll functions that detect ON %%%%%%%%%%%%%
        DetectONSurface(imcnnOutON, cnnname);
                
        %%%%%%UNCOMMENT TO DOUBLE CHECK THE RESULT BY WRITING TO FILE%%%%%%%%%%%%%%%
       % name = strcat('/media/areca_raid/VNet/Results/',cnnname);
       % imwrite(imcnnOutON(:,:,1), name);
       % for k = 2:size(imcnnOutON,3)
       %     imwrite(imcnnOutON(:,:,k), name , 'writemode', 'append');
       % end        
    end
%%%%%%%%%%%%%%%%%%%resize the OFF image and call detectOFF%%%%%%%%%%%%%%
    if exist(strcat('/media/areca_raid/VNet/ResultsOFF/',cnnname), 'file') == 2
        %FileTif = '00505_2R_C01_chAT_STD.tif'
        InfoImage=imfinfo(strcat('/media/areca_raid/VNet/ResultsOFF/',cnnname));
        mImage=InfoImage(1).Width;
        nImage=InfoImage(1).Height;
        NumberImages=length(InfoImage);
        
        cnnim = zeros(nImage, mImage, NumberImages, 'uint8');
        TifLink = Tiff(strcat('/media/areca_raid/VNet/ResultsOFF/',cnnname), 'r');
        for i=1:NumberImages
            TifLink.setDirectory(i);
            cnnim(:,:,i)=TifLink.read();
        end
        TifLink.close();
        
        InfoImage=imfinfo(strcat('/media/areca_raid/VNet/ImagesHere/',FileTif));  %this is dst image to project to
        nx=InfoImage(1).Width;
        nz=InfoImage(1).Height;
        ny=length(InfoImage);
        
        [y x z]=...
            ndgrid(linspace(1,size(cnnim,1),ny),...
            linspace(1,size(cnnim,2),nx),...
            linspace(1,size(cnnim,3),nz));
        
        imcnnOutOFF = interp3(double(cnnim),x,y,z, 'spline');
        imcnnOutOFF = uint8(imcnnOutOFF);
    
        DetectOFFSurface(imcnnOutOFF, cnnname);
    end

%%%%%%%%%%%%%%%%%%%%%%%%to double check%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
%%%%%%%%%%%Call a function to detect both ON and OFF%%%%%%%%%%%%%%%%%%%%%%%        
%%%%%%%%%%%%%%%%%%%%%%%%%not yet implemented%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
	%DetectONandOFFSurface(imcnnOut, cnnname);

end

%%%%%%%%%%Delete the temporary images%%%%%%%%%%%%%%%%%%%%%%%
cd('/media/areca_raid/VNet/Dataset/TBP');
delete *.tif


