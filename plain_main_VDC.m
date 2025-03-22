clear
%close all


trainDB_size = 1; %a dummy parameter

%***********************MNIST**************************************
% [~, ~, labels_test, labels_train, images_train_SC, images_test_SC]= mnist_db_construct();
% % images_train = double(images_train);
% % images_test = double(images_test);
% 
% ws_hog = load('hog_144.mat');
% out_train = ws_hog.out_train;
% out_test = ws_hog.out_test;
%level = 255--> 87.10
%***********************MNIST**************************************

%***********************Fashion MNIST**************************************
% [~, ~, labels_test, labels_train, images_train_SC, images_test_SC]= fmnist_db_construct();
% ws_fmnist = load('hog_144_fMNIST.mat');
% out_train = ws_fmnist.out_train;
% out_test = ws_fmnist.out_test;
%level = 31--> 72.80
%***********************Fashion MNIST**************************************

%***********************Blood MNIST**************************************
% load('bloodmnist.mat')
% labels_train = double(train_labels);
% labels_test = double(test_labels);
% 
% %total_training_images = 11959; 
% %total_test_images = 3421;
% ws_blood = load('hog144_blood.mat');
% out_train = ws_blood.out_train;
% out_test = ws_blood.out_test;
%level=255 --> 61

%numberOfClasses = 8;
%***********************Blood MNIST**************************************

%***********************Breast MNIST**************************************
% load('breastmnist.mat')
% labels_train = double(train_labels);
% labels_test = double(test_labels);
% 
% %total_training_images = 546; %SVHN    73257
% %total_test_images = 156; %SVHN 
% 
% ws_breast = load('hog144_breast.mat');
% out_train = ws_breast.out_train;
% out_test = ws_breast.out_test;
%level = 15 --> 75
%numberOfClasses =2 ;
%***********************Breast MNIST**************************************

%***********************SVHN**********************************************
% load('SVHN_labels.mat')
% 
% % total_training_images = 73257; %SVHN    73257
% % total_test_images = 26032;
% 
% ws_SVHN = load('hog144_SVHN.mat');
% out_train = ws_SVHN.out_train;
% out_test = ws_SVHN.out_test;
% level = 15 -->63.40
%***********************SVHN**********************************************

%************************CIFAR10************************************
levels = 255;
load('cifar10.mat');
% total_training_images = 50000;
% total_test_images = 10000;
image_row_size = 18;
image_column_size = 18;
load('HOG_CIFAR10.mat');
images_train = double(uint8(rescale(featureVectorTRAIN,0,levels)));
images_test = double(uint8(rescale(featureVectorTEST,0,levels)));
% images_train = featureVectorTRAIN;
% images_test = featureVectorTEST;
% level = 255 --> 48.3
%************************CIFAR10************************************

% image_row_size = 12;
% image_column_size = 12;
numberOfClasses = 10;

%levels = 255;

% images_train = uint8(rescale(out_train,0,levels));
% images_train = double(images_train);
% images_test = uint8(rescale(out_test,0,levels));
% images_test = double(images_test);

% images_train = out_train;
% images_test = out_test;

total_training_images = 1000; %the total #s you want to include (fifo)
total_test_images = 1000; %the total #s you want to include (fifo)
D = 1024; %vector dimension 512-->86.90  1024-->87.60  2048-->89.80

low_intensity = 0;
high_intensity = levels;

M = high_intensity+1; %quantization interval

initial_vector_seed = ones(1,D);
intensity_vector = ones(M,D);

threshold = ((high_intensity+1)/2); %Half value of max. intensity value; mid value

bitflip_count = D/(M); %note that D >= 2*high_intensity

P_hypervector = zeros(image_row_size, image_column_size, D);
% P_hypervector2 = ones(784,D).*-1;
% P_hypervector3 = ones(28,28,D);
% P_hypervector4 = ones(14,28,D);
% P_hypervector5 = ones(14,28,D);

%initial_vector_seedP = ones(784,D).*-1;

%-----------------------First RANDOM Method--------------------------------

% r = round((high_intensity-low_intensity).*rand(28,28,D) + low_intensity);
% %r is random vector for position hypervectors
% 
% for i = 1:1:image_row_size
%     for j = 1:1:image_column_size
%         for z = 1:1:D
%             if threshold <= r(i,j,z)
%                 P_hypervector(i,j,z) = -1;
%             end
%             if threshold > r(i,j,z)
%                 P_hypervector(i,j,z) = 1;
%             end
%         end
%     end
% end

%-----------------------First RANDOM Method--------------------------------

%-----------------------Second SOBOL Method--------------------------------
%Sobol LD Contribution
% sobol_sequences = net(sobolset(28*28),(D));
% sobol_sequences = transpose(sobol_sequences);
% sobol_sequences = reshape(sobol_sequences, [28,28,D]);
% threshold = 0.5; %update threshold
% 
% for i = 1:1:image_row_size
%     for j = 1:1:image_column_size
%         for z = 1:1:D
%             if threshold <= sobol_sequences(i,j,z)
%                 P_hypervector(i,j,z) = -1;
%             end
%             if threshold > sobol_sequences(i,j,z)
%                 P_hypervector(i,j,z) = 1;
%             end
%         end
%     end
% end


%
% sobol_sequences = net(sobolset(1),(D));
% sobol_sequences = transpose(sobol_sequences);
% sobol_sequences = reshape(sobol_sequences, [1,1,D]);
% for i = 1:1:image_row_size
%     for j = 1:1:image_column_size
%         for z = 1:1:D
%             if sobol_sequences(i*j) <= sobol_sequences(1,1,z)
%                 P_hypervector(i,j,z) = -1;
%             end
%             if sobol_sequences(i*j) > sobol_sequences(1,1,z)
%                 P_hypervector(i,j,z) = 1;
%             end
%         end
%     end
% end


% sobol_sequences = net(sobolset(28*28),(D));
% sobol_sequences = transpose(sobol_sequences);
% sobol_sequences = reshape(sobol_sequences, [28,28,D]);
% threshold = 0.5; %update threshold
% for i = 1:1:image_row_size
%     for j = 1:1:image_column_size
%         for z = 1:1:D
%             if threshold <= sobol_sequences(i,j,z)
%                 P_hypervector(i,j,z) = -1;
%             end
%             if threshold > sobol_sequences(i,j,z)
%                 P_hypervector(i,j,z) = 1;
%             end
%         end
%     end
% end

%-----------------------Second SOBOL Method--------------------------------



%-------------------------Third VDC Method---------------------------------
%Sobol LD Contribution
%
% VDC = vdcorput(D, 2);
% stop_size = (image_row_size*image_column_size);
% 
% for i=1:1:stop_size
%     for j=1:1:D
%         if VDC(i) > VDC(j)
%             bitstream(i,j) = +1;
%         else
%             bitstream(i,j) = -1;
%         end
%     end
% end
% 
% bitstream = transpose(bitstream);
% P_hypervector = reshape(bitstream, [image_row_size, image_row_size, D]);
%
%
%
% iterim = 0;
% for s=1:1:28
%     for g=1:1:28
%         iterim = (iterim + 1);
%             P_hypervector3(s, g, :) = bitstream(s*g,:);
%     end
% end
% P_hypervector = P_hypervector3;








% sobol_sequences = net(sobolset(28*28),(D));
% sobol_sequences = transpose(sobol_sequences);
% sobol_sequences = reshape(sobol_sequences, [28,28,D]);
% threshold = 0.5; %update threshold
% 
% for i = 1:1:image_row_size
%     for j = 1:1:image_column_size
%         for z = 1:1:D
%             if threshold <= sobol_sequences(i,j,z)
%                 P_hypervector(i,j,z) = -1;
%             end
%             if threshold > sobol_sequences(i,j,z)
%                 P_hypervector(i,j,z) = 1;
%             end
%         end
%     end
% end

%-------------------------Third VDC Method---------------------------------



% iter = 1; %iteration for the total bitflips do not affect the previous bitflips
% for k=1:1:M %k = 1.....256 (0...255 pixel values)
%     while iter <= bitflip_count
%         rand_pos = round((D-1).*rand(1,1) + (1));
%         if initial_vector_seed(rand_pos) == 1
%             initial_vector_seed(rand_pos) = -1;
%             iter = iter + 1;
%         end
%     end
%     intensity_vector(k,:) = initial_vector_seed;
%     iter = 1;
% end


% for k=1:1:784 %k = 1.....256 (0...255 pixel values)
%     initial_vector_seedTEMP = initial_vector_seedP(k,:);
%     initial_vector_seedTEMP(1:(k*1)) = 1;
%     P_hypervector2(k,:) = initial_vector_seedTEMP;
% end
% P_hypervector = reshape(P_hypervector2, [28,28,D]);
% 
% for i = 1:1:image_row_size
%     for j = 1:1:image_column_size
%         for z = 1:1:D
%             P_hypervector(i,j,z) = P_hypervector2(i*j,z);
% 
%             if sobol_sequences(i*j) > sobol_sequences(1,1,z)
%                 P_hypervector(i,j,z) = 1;
%             end
%         end
%     end
% end

% iterim = 0;
% for s=1:1:28
%     for g=1:1:28
%         iterim = (iterim + 1);
%             P_hypervector3(s, g, 1:iterim) = -1;
%     end
% end
% P_hypervector = P_hypervector3;


% iterim = 0;
% for s=1:1:28
%     for g=1:1:28
%         iterim = (iterim + 1);
%             P_hypervector3(s, g, 1:iterim) = -1;
%             %P_hypervector3(s,g,:) = circshift(P_hypervector3(s,g,:),iterim);
%     end
% end
% P_hypervector = P_hypervector3;


%Half and half

% iterim = 0;
% for s=1:1:14
%     for g=1:1:28
%         iterim = (iterim + 1);
%             P_hypervector4(s, g, 1:iterim) = -1;
%     end
% end
% P_hypervector5 = P_hypervector4 .* -1;
% P_hypervector = cat(1, P_hypervector4, P_hypervector5);








%------------------------------Mehran VDC-------------------------------
DD = D;
% 
X2_stream_vdc = zeros(DD,DD);
T_FF_vdc = zeros(DD,DD);
yy_xor1 = zeros(DD,DD);
vd(:,1) = vdcorput(DD-1,2);

for i = 1:DD
    for k = 1:DD
        if i/(DD) > vd(k,1)
            X2_stream_vdc(i,k) = 1;
        end         
    end
end

for j = 1:DD
    T_FF_vdc(j,:) = JK_behaviour(X2_stream_vdc(j,:), X2_stream_vdc(j,:), DD);
    yy_xor1(j,:) = xor(X2_stream_vdc(j,:), T_FF_vdc(j,:));
end
yy_xor1(yy_xor1 == 0) = -1;

% xx = [1023, 1024, 1022, 512, 2, 511, 1018, 513, 6, 1021, 1020, 768, 256, 4, 767,1012, 1014, 510, 384, 640, 255, 10, 514, 12, 1016, 896, 257, 128, 769, 8,...
% 1019, 1010, 14, 1008, 960, 64, 506, 518, 16, 1017, 992, 1002, 895, 32, 22, 1000, 192, 832, 998, 24, 26, 127, 639, 897, 385, 129, 383, 254, 641,...
% 1004, 1006, 1015, 976, 928, 766, 509, 96, 770, 704, 320, 48, 18, 959, 258, 20, 1009, 515, 508, 448, 961, 576, 516, 994, 30, 63, 993, 1007, 991, 65,...
% 986, 500, 38, 524, 250, 1011, 774, 982, 126, 31, 416, 58, 1013, 608, 996, 42, 966, 762, 638, 898, 502, 386, 62, 262, 5, 962, 7, 522, 15, 28, 980,...
% 974, 3, 990, 33, 50, 894, 972, 970, 382, 44, 978, 54, 34, 642, 52, 130, 9, 46, 122, 984, 831, 17, 902, 864];

%  numbers = [2047, 2048, 2046, 1024, 2, 1023, 1025, 2042, 6, 2045, 2044, 1536, 512, 4, 1535, 2036, 511, 2038, 1022, 513, 768, 1280, 1537, 10, 1026, 12, 2040, 1792, 256, 8, 2043, 2034, 14, 2041, 2032, 1920, 128, 1791, 1018, 16, 1030, 2026, 255, 22, 1279, 1793, 2016, 1984, 2024, 64, 257, 769, 384, 32, 767, 1664, 2022, 24, 26, 1281, 2039, 1021, 510, 1919, 2028, 2030, 1027, 2033, 1534, 1538, 1408, 640, 18, 1921, 20, 514, 127, 2000, 192, 1856, 1020, 896, 48, 1152, 1028, 129, 2018, 30, 1952, 2031, 96, 2017, 1985, 1983, 2035, 63, 2015, 5, 2037, 3, 7, 2010, 38, 1012, 2020, 31, 15, 1036, 65, 2006, 506, 254, 28, 42, 832, 9, 1216, 1542, 1663, 1278, 1990, 58, 1794, 1014, 1530, 770, 518, 33, 1034, 385, 383, 62, 2004, 17, 2014, 1986, 1665, 1998, 1790, 44, 50, 766, 2002, 34, 1996, 1994, 1282, 258, 46, 54, 126, 52, 2008, 1922, 1728, 1016, 960, 704, 320, 1344, 40, 1151, 897, 1088, 1032, 895, 1407, 13, 1010, 1153, 1038, 641, 11, 1409, 250, 639, 1982, 122, 1798, 1918, 1926, 1274, 774, 66, 448, 130, 1600, 1978, 70, 1958, 1946, 102, 509, 90, 2023, 1533, 1008, 992, 1000, 928, 1539, 1002, 1968, 2025, 1056, 1120, 1040, 1888, 1855, 1048, 762, 1046, 160, 80, 1286, 1786, 508, 1019, 262, 515, 1540, 1857, 2029, 1992, 998, 191, 2012, 193, 1050, 1029, 56, 1017, 1532, 1472, 576, 36, 516, 1662, 1031, 1914, 386, 1962, 1950, 2019, 86, 1632, 134, 976, 416, 98, 1072, 1988, 500, 60, 1954, 1960, 382, 94, 1548, 1944, 1972, 1666, 88, 104, 1942, 23, 106, 1951, 25, 76, 1999, 2001, 1696, 352, 1953, 224, 1824, 1932, 116, 2027, 1974, 961, 1524, 524, 1087, 74, 1854, 1936, 1970, 95, 1850, 502, 1440, 194, 608, 198, 112, 78, 19, 1150, 1658, 390, 898, 1546, 97, 1964, 118, 831, 1930, 1840, 1217, 47, 190, 208, 29, 2021, 84, 1858, 1248, 800, 1004, 186, 1862, 959, 1872, 1044, 49, 176, 1526, 1215, 638, 378, 1410, 522, 252, 1006, 1670, 833, 864, 1796, 994, 244, 1376, 1184, 1934, 672, 1054, 1804, 114, 1042, 1966, 1089, 480, 1406, 82, 642, 1795, 1924, 1276, 124, 1568, 772, 894, 253, 1009, 1948, 1154, 1940, 1268, 780, 1727, 108, 1039, 1277, 100, 504, 902, 993, 1146, 771, 1544, 21, 498, 1055, 1987, 246, 1550, 966, 1894, 1082, 321, 1343, 154, 1789, 1802, 1729, 705, 1956, 986, 1980, 1599, 464, 1584, 319, 764, 816, 1086, 1232, 1062, 962, 1284, 2013, 92, 230, 1788, 447, 736, 1818, 982, 634, 1312, 1414, 1528, 1504, 449, 1601, 488, 68, 260, 27, 1270, 544, 520, 1015, 765, 703, 1066, 778, 1560, 1908, 1976, 826, 830, 259, 1222, 1846, 1844, 490, 1218, 1345, 202, 1283, 486, 756, 1522, 1882, 1923, 1760, 204, 140, 1292, 166, 526, 61, 1558, 1562, 496, 288, 1780, 72, 1938, 110, 1928, 1552, 120, 970, 1816, 232, 268, 974, 1868, 996, 972, 1078, 1033, 1052, 180, 1402, 1076, 922, 1074, 646, 125, 1126, 234, 1896, 1814, 1878, 1842, 890, 206, 1866, 170, 152, 182, 1254, 794, 1158, 242, 1806, 1488, 980, 991, 1744, 1512, 560, 1638, 304, 1898, 410, 1068, 1910, 536, 150, 978, 1328, 720, 240, 1916, 1870, 1808, 1514, 1070, 138, 178, 214, 35, 1834, 534, 1520, 1471, 758, 1473, 1510, 1256, 132, 792, 1290, 528, 538, 834, 1214, 1782, 1997, 2009, 934, 218, 1011, 1830, 782, 1057, 1266, 575, 1652, 790, 1258, 2003, 266, 248, 1114, 396, 1890, 1800, 1904, 158, 1007, 838, 577, 1210, 1037, 144, 1734, 314, 1264, 1917, 784, 710, 1338, 358, 1690, 1013, 1342, 706, 318, 990, 1730, 1981, 2007, 1880, 454, 1035, 1594, 984, 1272, 944, 168, 958, 1058, 1064, 1906, 776, 1104, 848, 1041, 1200, 142, 1712, 1598, 1648, 336, 1090, 450, 1654, 400, 926, 954, 394, 1887, 406, 1642, 1122, 1094, 1822, 742, 1886, 1876, 1306, 226, 372, 1676, 131, 1848, 1726, 162, 1640, 920, 822, 172, 408, 322, 918, 820, 1228, 1226, 1128, 51, 45, 200, 1130, 1722, 39, 1766, 908, 1140, 326, 1991, 282, 744, 1889, 1304, 1660, 422, 754, 1852, 1434, 614, 1626, 1294, 67, 507, 388, 1836, 432, 1768, 1616, 161, 912, 414, 212, 196, 1136, 806, 1634, 1541, 1242, 1874, 280, 1838, 746, 210, 174, 818, 1230, 1832, 702, 1302, 1778, 1346, 1238, 810, 216, 270, 505, 1543, 159, 1993, 398, 1770, 41, 1650, 938, 930, 698, 1531, 1702, 1350, 1688, 1566, 482, 278, 346, 1118, 688, 1360, 360, 1110, 760, 1288, 752, 798, 1296, 906, 1686, 927, 1967, 362, 1142, 492, 374, 1250, 1784, 1674, 1556, 458, 1912, 1529, 1969, 1590, 446, 1776, 1823, 264, 460, 1478, 1588, 1119, 1825, 870, 1864, 570, 470, 517, 474, 929, 1121, 1602, 1178, 1860, 1382, 136, 442, 236, 666, 1812];
% xx = numbers(numbers <= D);
% %xx = xx(randperm(length(xx)));
% %xx = xx(1:image_row_size*image_column_size);
% xx = numbers;
% xx = xx(randperm(length(xx)));

%load('xx_2k.mat')

load('xx.mat')
% xx1 = xx;
% xx1 = xx1(xx1 <= D);
% yy2 = yy_xor1(xx1,1:D);
% tt = zeros(1,length(xx1));
% for t = 1:length(xx1)
%     if (sum(yy2(t,:)) == 0)
%         tt(t) = xx1(t);
%     end
% end
% tt = tt(tt ~= 0);
% tt = tt(1:image_row_size*image_column_size);
% temp = yy_xor1(tt,1:D);

% xx = xx(1:image_row_size*image_column_size);
temp = yy_xor1(xx,1:D);

%temp = yy_xor1(512:512+783,1:D);
P_hypervector = reshape(temp,image_row_size,image_column_size,D);

% yy = [1023, 1024, 1022, 512, 2, 511, 1018, 513, 6, 1021, 1020, 768, 256, 4, 767, 1012, 1014, 510, 384, 640, 255, 10, 514, 12, 1016, 896,...
%           257, 128, 769, 8, 1019, 1010, 14, 1008, 960, 64, 506, 518, 16, 1017, 992, 1002, 895, 32, 22, 1000, 192, 832, 998, 24, 26, 127, 639, 897,...
%           385, 129, 383, 254, 641, 1004, 1006, 1015, 976, 928, 766, 509, 96, 770, 704, 320, 48, 18, 959, 258, 20, 1009, 515, 508, 448, 961, 576,...
%           516, 994, 30]; %  D = 1024

%------------------------------Mehran VDC-------------------------------




% 
for k=1:1:M %k = 1.....256 (0...255 pixel values)
    initial_vector_seedTEMP = initial_vector_seed;
    initial_vector_seedTEMP(1:(k*bitflip_count)) = -1;
    intensity_vector(k,:) = initial_vector_seedTEMP;
end


WaitMessage = parfor_wait(total_training_images, 'Waitbar', true);

%TRAINING STARTS
cumulative_class_hypervector = zeros(numberOfClasses,D);

cumulative_class_hypervector0 = zeros(1,D);
cumulative_class_hypervector1 = zeros(1,D);
cumulative_class_hypervector2 = zeros(1,D);
cumulative_class_hypervector3 = zeros(1,D);
cumulative_class_hypervector4 = zeros(1,D);
cumulative_class_hypervector5 = zeros(1,D);
cumulative_class_hypervector6 = zeros(1,D);
cumulative_class_hypervector7 = zeros(1,D);
cumulative_class_hypervector8 = zeros(1,D);
cumulative_class_hypervector9 = zeros(1,D);

parfor TRAIN_IMAGE_INDEX = 1:total_training_images %50 will be total db size


    WaitMessage.Send;
    pause(0.002);

    shaped_images = zeros(trainDB_size, image_row_size, image_column_size);

    shaped_images(1,:,:) = reshape(images_train(:, TRAIN_IMAGE_INDEX), [1,image_row_size,image_column_size]);

    %----------------------------BINDING---------------------------------------
    %Allocate mem.
    xored_Images = zeros(trainDB_size, image_row_size, image_column_size, D);

    for item_image=1:1:trainDB_size %iterating over training images
        for i=1:1:image_row_size
            for j = 1:1:image_column_size
                %temp = circshift(intensity_vector(shaped_images(item_image,i,j)+1,:),i*j);
                temp = reshape(P_hypervector(i,j,:), [1,D]) .* intensity_vector(shaped_images(item_image,i,j)+1,:);
                xored_Images(item_image, i, j, :) = reshape(temp, [1,1,1,D]);
            end
        end
    end

%     out_train_reshape = reshape(images_train(:,TRAIN_IMAGE_INDEX), image_row_size, image_column_size);
%     for item_image=1:1:trainDB_size
%         for i = 1:image_row_size
%             for j = 1:image_column_size
%                 temp = P_hypervector(i,j,:) .* out_train_reshape(i,j);
%                 xored_Images(item_image, i, j, :) = reshape(temp, [1,1,1,D]);
%             end
%         end
%     end

    %----------------------------BUNDLING--------------------------------------
    %Allocate mem.
    bundled = zeros(trainDB_size, D);

    for item_image=1:1:trainDB_size %iterating over training images
        for i=1:1:image_row_size
            for j = 1:1:image_column_size
                bundled(item_image, :) = bundled(item_image, :) + reshape(xored_Images(item_image, i, j, :), [1,D]);
            end
        end
    end
    %--------------------------------------------------------------------------

    %----------------------------BINARIZING------------------------------------
    %Allocate mem.
    bundled_signed = sign(bundled);
    %Exception handling for `0` values
    for z = 1:1:D
        if bundled_signed(z) == 0 %0 is 1 for us
            bundled_signed(z) = 1;
        end
    end
    %--------------------------------------------------------------------------

    %--------------------------------------------------------------------------
    %-------------------------CLASS HYPERVECTOR--------------------------------
    %Allocate mem.

    %EITHER----------------------------------------------------------------
    %The following was a better choice for cumulative_class_hypervector, but parfor gets angry :(
    %cumulative_class_hypervector(labels_train(TRAIN_IMAGE_INDEX)+1,:) = cumulative_class_hypervector(labels_train(TRAIN_IMAGE_INDEX)+1,:) + bundled_signed;
    %EITHER----------------------------------------------------------------

    if labels_train(TRAIN_IMAGE_INDEX) == 0
        cumulative_class_hypervector0 = cumulative_class_hypervector0 + bundled_signed;
    end
    if labels_train(TRAIN_IMAGE_INDEX) == 1
        cumulative_class_hypervector1 = cumulative_class_hypervector1 + bundled_signed;
    end
    if labels_train(TRAIN_IMAGE_INDEX) == 2
        cumulative_class_hypervector2 = cumulative_class_hypervector2 + bundled_signed;
    end
    if labels_train(TRAIN_IMAGE_INDEX) == 3
        cumulative_class_hypervector3 = cumulative_class_hypervector3 + bundled_signed;
    end
    if labels_train(TRAIN_IMAGE_INDEX) == 4
        cumulative_class_hypervector4 = cumulative_class_hypervector4 + bundled_signed;
    end
    if labels_train(TRAIN_IMAGE_INDEX) == 5
        cumulative_class_hypervector5 = cumulative_class_hypervector5 + bundled_signed;
    end
    if labels_train(TRAIN_IMAGE_INDEX) == 6
        cumulative_class_hypervector6 = cumulative_class_hypervector6 + bundled_signed;
    end
    if labels_train(TRAIN_IMAGE_INDEX) == 7
        cumulative_class_hypervector7 = cumulative_class_hypervector7 + bundled_signed;
    end
    if labels_train(TRAIN_IMAGE_INDEX) == 8
        cumulative_class_hypervector8 = cumulative_class_hypervector8 + bundled_signed;
    end
    if labels_train(TRAIN_IMAGE_INDEX) == 9
        cumulative_class_hypervector9 = cumulative_class_hypervector9 + bundled_signed;
    end

end %end of training iteration

WaitMessage.Destroy %close status bar

cumulative_class_hypervector = cat(1, cumulative_class_hypervector0, cumulative_class_hypervector1, cumulative_class_hypervector2, ...
    cumulative_class_hypervector3, cumulative_class_hypervector4, cumulative_class_hypervector5, cumulative_class_hypervector6, ...
    cumulative_class_hypervector7, cumulative_class_hypervector8, cumulative_class_hypervector9);

%BINARY--------------------------------------------------------------------
%---------------------------CLASS HYPERVECTOR SIGN-------------------------
signed_class_hypervector = (cumulative_class_hypervector);

%zero correction
% zero_index = find(~signed_class_hypervector);
% zero_index_size = size(zero_index);
% for z = 1:1:zero_index_size
%     signed_class_hypervector(zero_index(z)) = 1;
% end
%---------------------------CLASS HYPERVECTOR SIGN-------------------------


%TESTING STARS
%Status bar
%h = waitbar(0,'TESTING');
WaitMessage = parfor_wait(total_test_images, 'Waitbar', true);

accuracy = 0;
parfor TESTING_IMAGE_INDEX = 1:1:total_test_images %50 will be total db size


    %waitbar(TESTING_IMAGE_INDEX/total_test_images,h)
    WaitMessage.Send;
    pause(0.002);
    %--------------------------------------------------------------------------

    shaped_images = zeros(trainDB_size, image_row_size, image_column_size);


    shaped_images(1,:,:) = reshape(images_train(:, TESTING_IMAGE_INDEX), [1,image_row_size,image_column_size]);
    %shaped_images(1,:,:) = reshape(images_test(:, TESTING_IMAGE_INDEX), [1,image_row_size,image_column_size]);
    %shaped_images(1,:,:) = reshape(images_test(:, TESTING_IMAGE_INDEX), [1,28,28]);


    %----------------------------BINDING-----------------------------------
    %Allocate mem.
    xored_Images = zeros(trainDB_size, image_row_size, image_column_size, D);

    for item_image=1:1:trainDB_size %iterating over training images
        for i=1:1:image_row_size
            for j = 1:1:image_column_size
                %temp = circshift(intensity_vector(shaped_images(item_image,i,j)+1,:),i*j);
                temp = reshape(P_hypervector(i,j,:), [1,D]) .* intensity_vector(shaped_images(item_image,i,j)+1,:);
                for k = 1:1:D
                    xored_Images(item_image, i, j, k) = temp(k);
                end
            end
        end
    end

%     out_test_reshape = reshape(images_train(:,TESTING_IMAGE_INDEX), image_row_size, image_column_size);
%     for item_image=1:1:trainDB_size
%         for i = 1:image_row_size
%             for j = 1:image_column_size
%                 temp = P_hypervector(i,j,:) .* out_test_reshape(i,j);
%                 xored_Images(item_image, i, j, :) = reshape(temp, [1,1,1,D]);
%             end
%         end
%     end

    %----------------------------BUNDLING--------------------------------------
    %Allocate mem.
    bundled = zeros(trainDB_size, D);

    for item_image=1:1:trainDB_size %iterating over training images
        for i=1:1:image_row_size
            for j = 1:1:image_column_size
                %for k = 1:1:D
                 %   reshape_temp(k) = xored_Images(item_image, i, j, k);
                %end
                %bundled(item_image, :) = bundled(item_image, :) + reshape_temp;
                bundled(item_image, :) = bundled(item_image, :) + reshape(xored_Images(item_image, i, j, :), [1,D]);
            end
        end
    end
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    %SIGN
    %----------------------------BINARIZING--------------------------------
    %Allocate mem.
    bundled_signed = sign(bundled);
    %Exception handling for `0` values
    for z = 1:1:D
        if bundled_signed(z) == 0 %0 is 1 for us
            bundled_signed(z) = 1;
        end
    end
    %----------------------------------------------------------------------

    %CLASSIFICATION
    cosAngle = zeros(1, numberOfClasses);
    for classes = 1:1:numberOfClasses
        cosAngle(classes) = dot(bundled_signed(1,:), signed_class_hypervector(classes,:))/(norm(bundled_signed(1,:))*norm(signed_class_hypervector(classes, :)));
    end

    [value, position] = max(cosAngle);

    %Y_predicted(TESTING_IMAGE_INDEX) = position;
    %Y_reference(TESTING_IMAGE_INDEX) = (labels_test(TESTING_IMAGE_INDEX)+1);

    Y_predicted(TESTING_IMAGE_INDEX) = position;
    Y_reference(TESTING_IMAGE_INDEX) = (labels_train(TESTING_IMAGE_INDEX)+1);

%     if position == (labels_test(TESTING_IMAGE_INDEX)+1)
%         accuracy = accuracy + 1;
%     end

    if position == (labels_train(TESTING_IMAGE_INDEX)+1)
        accuracy = accuracy + 1;
    end

end %end of testing for
%delete(h);
WaitMessage.Destroy

classification_percentage = (accuracy * 100) / total_test_images

%cm = confusionchart(Y_reference, Y_predicted);

%sercanConfusionMatrix(cm)
