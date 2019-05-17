%% Ludtalp vizsgalat a mappaban levo jpg kepeken
clear;

files = dir('*.jpg');
size = length(files);

ID = (1:size)';
file_name = strings(size,1);
lab_meret = zeros(size,1);
polinom = zeros(size,4);
kor_xy = zeros(size,2);

% Minden JPG file-ra lefuttatni a scriptet
for i = 1:length(files)
   fn = string(files(i).name); 
   file_name(i) = fn;
   [kor_xy(i,:),lab_meret(i),polinom(i,:)] = ludtalp(fn);
end

% Exportalas excel dokumentumba
T = table(ID,file_name,lab_meret,kor_xy,polinom);
writetable(T,'patientdata.xlsx');

%% Ponilonom kirajzolasa
figure(1);
clf;

hold on;
x = 600:2400;

for i = 1:5
   legendCell{i} = file_name(i);
   y = -polyval(polinom(i,:),x);
   plot(x,y);
end

legend(legendCell);


