function seminarska1(original, A)
    %Urh Vovk 63180315
    %funkcija se uporablja tako, da za prvi parameter damo imread(slika),
    %za drugega pa faktor A
    
    if ndims(original) == 2 %ce je slika crno-bela
    
        %Prvi del naloge za crno bele slike
        kernel = ones(3,3)/9; %Ustvari jedro za glajenje slike
        blur = imfilter(original,kernel); %glajenje originala
        originalMinusBlur = original - blur; %od originala odstejemo z jedrom glajen original
        highboost = original + A*originalMinusBlur; %originalu pristejemo razliko A-krat

        figure('Name','Highboost filter(crno-bela slika)'); %prikaz vseh korakov highboost ostrenja
        zoom on;

        %Prikaz rezultatov prvega dela naloge
        subplot(2,2,1); 
        imshow(original); 
        title('Originalna slika');

        subplot(2,2,2); 
        imshow(blur); 
        title('Z jedrom glajen original');

        subplot(2,2,3); 
        imshow(originalMinusBlur);
        title('Original minus glajen original');

        subplot(2,2,4); 
        imshow(highboost); 
        title(['Highboost filter s faktorjem ' num2str(A)]);


        %Drugi del naloge - crno bela slika
        laplacianMask1 = [0 1 0; 1 -4 1; 0 1 0]; %laplac maska1
        der1 = conv2(im2double(original),laplacianMask1,'same'); %drugi odvod s prvo laplac masko
        laplaceSharp1 = im2double(original) - der1; %od originala odstejemo drugi odvod s prvo laplac masko

        laplacianMask2 = [1 1 1; 1 -8 1; 1 1 1]; %laplac maska2
        der2 = conv2(im2double(original),laplacianMask2,'same'); %drugi odvod z drugo laplac masko
        laplaceSharp2 = im2double(original) - der2; %od originala odstejemo drugi odvod z drugo laplac masko

        %Prikaz rezultatov drugega dela naloge
        figure('Name','Ostrenje z Laplac masko(crno-bela slika)');
        zoom on;

        subplot(2,2,1); 
        imshow(der1); 
        title('Aproksimacija drugega odvoda slike s prvo laplac masko');

        subplot(2,2,2); 
        imshow(laplaceSharp1); 
        title('S prvo laplac masko ostrena slika');

        subplot(2,2,3); 
        imshow(der2); 
        title('Aproksimacija drugega odvoda slike z drugo laplac masko');

        subplot(2,2,4); 
        imshow(laplaceSharp2); 
        title('Z drugo laplac masko ostrena slika');
        
    else if ndims(original) == 3 %ce je slika barvna
        
        %prvi del naloge - barvna slika
        kernel = ones(3,3)/9; %jedro za glajenje
        
        blurRed = imfilter(original(:,:,1), kernel); %gladimo rdeci kanal
        blurGreen = imfilter(original(:,:,2), kernel); %gladimo zeleni kanal
        blurBlue = imfilter(original(:,:,3), kernel); %gladimo modri kanal
        blur = cat(3,blurRed,blurGreen,blurBlue); %zdruzimo glajenje kanalov
        
        originalMinusBlurRed = original(:,:,1) - blurRed; %od rdecega kanala originala odstejemo glajenje rdecega kanala
        originalMinusBlurGreen = original(:,:,2) - blurGreen; %od zelenega kanala originala odstejemo glajenje zelenega kanala
        originalMinusBlurBlue = original(:,:,3) - blurBlue; %od modrega kanal odstejemo glajenje modrega kanala
        originalMinusBlur = cat(3,originalMinusBlurRed,originalMinusBlurGreen,originalMinusBlurBlue); %zdruzimo razlike
        
        highboostRed = original(:,:,1) + A*originalMinusBlurRed; %originalu prištejemo A-kratnik razlike v rdecem kanalu
        highboostGreen = original(:,:,2) + A*originalMinusBlurGreen; %originalu prištejemo A-kratnik razlike v zelenem kanalu
        highboostBlue = original(:,:,3) + A*originalMinusBlurBlue; %originalu prištejemo A-kratnik razlike v modrem kanalu
        highboost = cat(3,highboostRed,highboostGreen,highboostBlue); %zdruzimo skupaj, da dobimo ostreno sliko
        
        %prikaz rezultatov prvega dela naloge - barvna slika
        figure('Name','Highboost filter(barvna slika)');
        zoom on;
        
        subplot(2,2,1); 
        imshow(original); 
        title('Originalna slika');

        subplot(2,2,2); 
        imshow(blur); 
        title('Z jedrom glajen original');

        subplot(2,2,3); 
        imshow(originalMinusBlur);
        title('Original minus glajen original');

        subplot(2,2,4); 
        imshow(highboost); 
        title(['Highboost filter s faktorjem ' num2str(A)]);
        
        
        %Drugi del naloge - barvna slika
        
        laplacianMask1 = [0 1 0; 1 -4 1; 0 1 0]; %laplac maska1
        der1Red = conv2(im2double(original(:,:,1)),laplacianMask1,'same'); %drugi odvod rdecega kanala s prvo masko
        der1Green = conv2(im2double(original(:,:,2)),laplacianMask1,'same'); %drugi odvod zelenega kanala s prvo masko
        der1Blue = conv2(im2double(original(:,:,3)),laplacianMask1,'same'); %drugi odvod modrega kanala s prvo masko
        der1 = cat(3,der1Red,der1Green,der1Blue); %zdruzimo druge odvode s prvo masko
        
        laplaceSharp1Red = im2double(original(:,:,1)) - der1Red; %od rdecega kanala odstejemo njegov drugi odvod s prvo masko
        laplaceSharp1Green = im2double(original(:,:,2)) - der1Green; %od zelenega kanala odstejemo njegov drugi odvod s prvo masko
        laplaceSharp1Blue = im2double(original(:,:,3)) - der1Blue; %od modrega kanala odstejemo njegov drugi odvod s prvo masko
        laplaceSharp1 = cat(3,laplaceSharp1Red,laplaceSharp1Green,laplaceSharp1Blue); %zdruzimo razlike originala in drugega odvoda za prvo masko
        
        laplacianMask2 = [1 1 1; 1 -8 1; 1 1 1]; %laplac maska2
        der2Red = conv2(im2double(original(:,:,1)),laplacianMask2,'same'); %drugi odvod rdecega kanala z drugo masko
        der2Green = conv2(im2double(original(:,:,2)),laplacianMask2,'same'); %drugi odvod zelenega kanala z drugo masko
        der2Blue = conv2(im2double(original(:,:,3)),laplacianMask2,'same'); %drugi odvod modrega kanala z drugo masko
        der2 = cat(3,der2Red,der2Green,der2Blue); %zdruzimo druge odvode z drugo masko
        
        laplaceSharp2Red = im2double(original(:,:,1)) - der2Red; %od rdecega kanala odstejemo njegov drugi odvod z drugo masko
        laplaceSharp2Green = im2double(original(:,:,2)) - der2Green; %od zelenega kanala odstejemo njegov drugi odvod z drugo masko
        laplaceSharp2Blue = im2double(original(:,:,3)) - der2Blue; %od modrega kanala odstejemo njegov drugi odvod z drugo masko
        laplaceSharp2 = cat(3,laplaceSharp2Red,laplaceSharp2Green,laplaceSharp2Blue); %zdruzimo razlike originala in drugega odvoda za drugo masko
        
        %Prikaz rezultatov drugega dela naloge - barvna slika
        figure('Name','Ostrenje z Laplac masko(barvna slika)');
        zoom on;

        subplot(2,2,1); 
        imshow(der1); 
        title('Aproksimacija drugega odvoda slike s prvo laplac masko');

        subplot(2,2,2); 
        imshow(laplaceSharp1); 
        title('S prvo laplac masko ostrena slika');

        subplot(2,2,3); 
        imshow(der2); 
        title('Aproksimacija drugega odvoda slike z drugo laplac masko');

        subplot(2,2,4); 
        imshow(laplaceSharp2); 
        title('Z drugo laplac masko ostrena slika');
        
    end
end

