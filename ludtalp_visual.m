%% A kep szegmentalasa

% Kep beolvasasa
clear; clc;
RGB = imread('person1_blue.jpg');

figure(1);
subplot(2,2,[1 2]);
imshow(RGB);

% Kek kor megkeres
Kor = (RGB(:,:,3) == 255);

% HSV szinterre valtas
HSV = rgb2hsv(RGB);

% Hue csatorna
Hue = HSV(:,:,1);

% Hisztogram keszitese
[yHue, kor_x] = imhist(Hue);

subplot(2,2,4);
plot(kor_x,yHue,'-r');

% Hisztogram alapjan kep szegmentalasa
HueMin = 0.3;
HueMax = 0.9;

% Binaris kep
BW = (Hue > HueMin ) & (Hue < HueMax);
BW = ~BW;

% Legnagyobb terulet a binaris kepen belul
BW = bwareafilt(BW, 1);
BW = imfill(BW,'holes');

% Kor hozzadva a binaris kephez
BW = BW & ~Kor;

figure(1);
subplot(2,2,3);
imshow(BW);

%% A lab kontorjanak keresese
clear channel1Max channel1Min HSV Hue RGB x yHue;

% Kontur megadasa
B = bwboundaries(BW,'noholes');
kuntur = B{1};

% B(:,1) - Y
% B(:,2) - X

figure(2);
imshow(BW,[.5 .5 .5; .3, .3, .8]) 

% Kontur  kirajzolasa
figure(2);
hold on
plot(kuntur(:,2), kuntur(:,1), 'w', 'LineWidth', 1)

%% Lab meretenek meghatarozasa 

% labujj megkeresese
labujj = find(kuntur(:,2) == min(kuntur(:,2)),1,'first');
plot(kuntur(labujj,2),kuntur(labujj,1),'*r','LineWidth',10);

% Sarok keresese a kek kort hasznalva
[kor_y,kor_x] = find(Kor,1,'first');
plot(kor_x,kor_y,'*g','LineWidth',10);

spontok = (kuntur(kuntur(:,1) > kor_y,:));
sarok = find(spontok(:,2) == max(spontok(:,2)),1,'first');

plot(spontok(sarok,2), spontok(sarok,1), '*r', 'LineWidth', 10)

% Lab meret meghatarozasa pixelben
labmeret = spontok(sarok,2) - kuntur(labujj,2);


%% Lab boltozati szakasz pontjai
felsopont = find(kuntur(:,1) == min(kuntur(:,1)),1,'first');
boltozat = labujj:felsopont;

% A kek ponthoz legkozelebbi kontur eso pont keresese
kor_pont = [kor_x,kor_y];
dist_min = norm(kor_pont-[kuntur(boltozat(1),2) kuntur(boltozat(1),1)]);
dist_min_index = 0;
for i = 1:length(boltozat)
   kek = [kuntur(boltozat(i),2) kuntur(boltozat(i),1)];
   dist = norm(kek-kor_pont);
   if (dist < dist_min)
       dist_min = dist;
       dist_min_index = i;
   end
end

% Legkozelebbi kontur pont
pont_dist_min = [kuntur(boltozat(dist_min_index),2),kuntur(boltozat(dist_min_index),1)];
plot(pont_dist_min(1),pont_dist_min(2),'*k','LineWidth',5);

% Boltozatt vizsgalt szalaszra szukitve
boltozat(dist_min_index:end)=[];
boltozat(1:round(0.4*length(boltozat)))=[];

plot(kuntur(boltozat,2),kuntur(boltozat,1),'-r','LineWidth',3);

%% polinom keresese a vizsgalt szakaszon

pol = polyfit(kuntur(boltozat,2),kuntur(boltozat,1),3);

offset = length(boltozat)*0.2;
pol_x = kuntur(boltozat(1),2)-offset:1:kuntur(boltozat(end),2)+offset;
pol_y = polyval(pol,pol_x);

plot(pol_x,pol_y,'-y','LineWidth',2);
