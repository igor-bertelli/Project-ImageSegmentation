# Projeto de Processamento de Imagem com Processing

Este projeto ilustra o uso do Processing, uma linguagem de programação e ambiente de desenvolvimento integrado (IDE) especializado na criação de imagens, animações e interações visuais. O código implementado realiza várias operações de processamento de imagem numa imagem de entrada, utilizando filtros complexos e manipulações pixel a pixel.

## Funções e Descrições

- `setup()`: Inicializa o programa, carrega a imagem de entrada, aplica uma série de filtros e operações de processamento de imagem, e salva cada resultado intermediário como uma nova imagem.

- `increaseSaturation(PImage inputImage, PImage outputImage, float saturationFactor)`: Aumenta a saturação da imagem de entrada por um fator especificado.

- `adjustContrast(PImage inputImage, PImage outputImage, float contrastFactor)`: Ajusta o contraste da imagem de entrada por um fator especificado.

- `applyRGBMaxFilter(PImage inputImage, PImage outputImage)`: Aplica um filtro RGB Max.

- `applyMedianFilter(PImage inputImage, PImage outputImage, int kernelSize)`: Aplica um filtro de mediana.

- `applyCompositeColorToBlackFilter(PImage inputImage, PImage outputImage, float minThreshold, float maxThreshold, float minIntensity, float maxIntensity)`: Transforma cores compostas em preto, baseando-se em limiares de intensidade e cor.

- `applyRedFilter(PImage inputImage, PImage outputImage)`: Aplica um filtro que destaca a cor vermelha.

- `applyBlackToWhiteFilter(PImage inputImage, PImage outputImage)`: Converte tons de preto em branco.

- `applyNeighborFilter(PImage inputImage, PImage outputImage)`: Aplica um filtro que considera os pixels vizinhos.

- `processHoles(PImage inputImg, PImage outputImg)`: Processa "buracos" na imagem.

- `fillHolesBasedOnBorderContact(PImage inputImg, PImage outputImg, int maxBorderPixels)`: Preenche buracos que tocam a borda da imagem.

- `compareImages(PImage img1, PImage img2, PImage outputImg)`: Compara duas imagens pixel a pixel e destaca diferenças.

- `saveImage(PImage img, String str)`: Salva a imagem processada em um arquivo.

## Resultados Intermediários e Finais

As operações geram várias imagens intermediárias:

- `middleimage1.png` a `middleimage8.png`: Cada uma destas imagens representa o estado após a aplicação de cada filtro.

- `mask.png`: A máscara gerada após aplicação dos filtros.

- `comparacao.png`: Uma comparação de `mask.png` com `ground_truth.png`, mostrando as diferenças pixel a pixel, vermelho se existir em `mask.png` e não em `ground_truth.png` e verde se existir em `ground_truth.png` e não existir em `mask.png`.

Este projeto demonstra a flexibilidade do Processing na manipulação e no processamento de imagens, fornecendo uma ferramenta poderosa para análises visuais detalhadas e desenvolvimento de algoritmos de processamento de imagem.
