function [kor,labmeret,pol] = ludtalp(file)

RGB = imread(file);

Kor = (RGB(:,:,3) == 255);

HSV = rgb2hsv(RGB);
Hue = HSV(:,:,1);

BW = (Hue > 0.3 ) & (Hue < 0.9);
BW = ~BW;

BW = bwareafilt(BW, 1);
BW = imfill(BW,'holes');
BW = BW & ~Kor;

B = bwboundaries(BW,'noholes');
kuntur = B{1};

labujj = find(kuntur(:,2) == min(kuntur(:,2)),1,'first');

[kor_y,kor_x] = find(Kor,1,'first');
spontok = (kuntur(kuntur(:,1) > kor_y,:));
sarok = find(spontok(:,2) == max(spontok(:,2)),1,'first');

labmeret = spontok(sarok,2) - kuntur(labujj,2);

felsopont = find(kuntur(:,1) == min(kuntur(:,1)),1,'first');
boltozat = labujj:felsopont;

% A kek ponthoz legkozelebbi kontur eso pont keresese
kor = [kor_x,kor_y];
dist_min = norm(kor-[kuntur(boltozat(1),2) kuntur(boltozat(1),1)]);
dist_min_index = 0;
for i = 1:length(boltozat)
   kek = [kuntur(boltozat(i),2) kuntur(boltozat(i),1)];
   dist = norm(kek-kor);
   if (dist < dist_min)
       dist_min = dist;
       dist_min_index = i;
   end
end

boltozat(dist_min_index:end)=[];
boltozat(1:round(0.4*length(boltozat)))=[];

pol = polyfit(kuntur(boltozat,2),kuntur(boltozat,1),3);
end