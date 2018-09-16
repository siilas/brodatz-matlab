clear all;
close all;

diretorio = 'brodatz-textures/';
padrao_arquivos = fullfile(diretorio, 'D*.gif');
arquivos = dir(padrao_arquivos);

contador = 0;

for i = 1 : size(arquivos)
    caminho_textura = fullfile(diretorio, arquivos(i).name);
    textura = imread(caminho_textura);
    [altura, largura] = size(textura);
    
    parte1 = textura(1 : altura/2, 1 : largura/2);
    parte2 = textura(1 : altura/2, (largura/2) + 1 : largura);
    parte3 = textura(1 : altura/2, (largura/2) + 1 : largura);
    parte4 = textura((altura/2) + 1 : altura, (largura/2) + 1 : largura);
    
    contador = contador + 1;
    texturas(:, :, contador) = parte1;
    valores(:, :, contador) = calcularLBP(parte1);
    contador = contador + 1;
    texturas(:, :, contador) = parte2;
    valores(:, :, contador) = calcularLBP(parte2);
    contador = contador + 1;
    texturas(:, :, contador) = parte3;
    valores(:, :, contador) = calcularLBP(parte3);
    contador = contador + 1;
    texturas(:, :, contador) = parte4;
    valores(:, :, contador) = calcularLBP(parte4);
end

acertos = 0;
erros = 0;
    
for y = 1 : contador
    menor_indice = 0;
    menor_valor = 100.0;
    for x = 1 : contador
        if (y ~= x)
            result = double(sqrt(sum((valores(:,:,y) - valores(:,:,x)) .^ 2)));
            if (result < menor_valor)
                menor_valor = result;
                menor_indice = x;
            end
        end
    end
    imshowpair(texturas(:, :, y), texturas(:, :, menor_indice), 'montage');
    tecla = input('O resultado está correto? S - Sim / Outra tecla - Não \n');
    if (tecla == 1)
        acertos = acertos + 1;
    else
        erros = erros + 1;
    end
    porcentagem = (acertos * 100 / (acertos + erros));
    fprintf('Porcentagem de acertos: %d%. \n', round(porcentagem));
    pause;
end

function histo = calcularLBP(textura)
    pesos = [ 1 2 4; 128 0 8; 64 32 16 ];
    [altura, largura] = size(textura);
    O = zeros(altura, largura);
    
    for x = 2 : altura - 1
        for y = 2 : largura - 1
            patch = textura(x - 1 : x + 1, y - 1 : y + 1);
            patch_b = patch >= patch(2, 2);
            patch_pesos = patch_b.*pesos;
            pb = sum(sum(patch_pesos));
            O(x, y) = pb;
        end
    end
    
    histo = zeros(1, 256);

    for x = 2 : altura - 1
        for y = 2 : largura - 1
            histo(O(x, y) + 1) = histo(O(x, y) + 1) + 1;
        end
    end

    histo = double(histo) / ((altura - 2) * (largura - 2));
    return;
end
