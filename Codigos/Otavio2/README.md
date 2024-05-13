Este código processa a imagem "0441.jpg" usando várias técnicas de processamento de imagem. Ele realiza as seguintes operações:

1. Ajusta o contraste da imagem.
2. Aumenta a saturação da imagem com um valor mínimo de saturação.
3. Aplica um filtro de mediana para reduzir o ruído.
4. Pinta os pixels fora de uma caixa delimitadora especificada.
5. Separa a imagem em componentes vermelho, azul e amarelo.
6. Aplica vários filtros a cada componente.
7. Cria uma máscara combinando as componentes filtradas.
8. Compara a máscara com uma imagem de referência.

O código utiliza as seguintes funções:

- `increaseSaturationWithMin()`: Aumenta a saturação de uma imagem com um valor mínimo de saturação.
- `adjustContrast()`: Ajusta o contraste de uma imagem.
- `applyMedianFilter()`: Aplica um filtro de mediana a uma imagem.
- `paintPixelsOutsideBoundingBox()`: Pinta os pixels fora de uma caixa delimitadora especificada.
- `applyRGBMaxFilter()`: Aplica um filtro RGB máximo a uma imagem.
- `applyCompositeColorToBlackFilter()`: Aplica um filtro de cor composta para preto a uma imagem.
- `median()`: Calcula o valor mediano de uma lista de números.
- `increaseSaturation()`: Aumenta a saturação de uma imagem.
- `applyRedFilter()`: Aplica um filtro vermelho a uma imagem.
- `applyBlackToWhiteFilter()`: Aplica um filtro de preto para branco a uma imagem.
- `applyNeighborFilter()`: Aplica um filtro de vizinho a uma imagem.
- `processHoles()`: Processa buracos em uma imagem.
- `fillHolesBasedOnBorderContact()`: Preenche buracos com base no contato com a borda em uma imagem.
- `applyBlueFilter()`: Aplica um filtro azul a uma imagem.
- `applyYellowFilter()`: Aplica um filtro amarelo a uma imagem.
- `sumImages()`: Soma várias imagens juntas.
- `compareImages()`: Compara duas imagens e cria uma imagem de comparação.
- `saveImage()`: Salva uma imagem em um arquivo.
- `loadImage()`: Carrega uma imagem de um arquivo.

Parâmetros:

- `img_2`: A imagem de entrada "0441.jpg".
- `middleImage_2`: A imagem intermediária após ajustar o contraste e aumentar a saturação.
- `redImage_2`: O componente vermelho da imagem.
- `blueImage_2`: O componente azul da imagem.
- `yellowImage_2`: O componente amarelo da imagem.
- `sumImage_2`: A imagem de máscara combinada.
- `comparacao_2`: A imagem de comparação entre a máscara e a imagem de referência.
- `mask_2`: A imagem de máscara.
- `ground_truth_2`: A imagem de referência.
