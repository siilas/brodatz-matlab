clear all;
close all;

diretorio = 'brodatz-textures/';

padrao_arquivos = fullfile(diretorio, 'D*.gif');

arquivos = dir(padrao_arquivos);

for i = 1:length(arquivos)
    caminho_textura = fullfile(diretorio, arquivos(i).name);
    texturas = imread(caminho_textura);
end

imshow(texturas);