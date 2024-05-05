import java.util.ArrayList;
import java.util.Stack;

PImage img;
PImage mask;
PImage middleImage;

void setup() {
  img = loadImage("0230.jpg"); // Certifique-se de colocar o caminho correto da imagem
  mask = createImage(img.width, img.height, RGB);
  middleImage = createImage(img.width, img.height, RGB);

  adjustContrast(img, middleImage, 10);
  saveImage(middleImage, "middleImage1");
  increaseSaturation(middleImage, middleImage, 20);
  saveImage(middleImage, "middleImage2");
  applyCompositeColorToBlackFilter(middleImage, middleImage, 0, 50, 50, 230);
  saveImage(middleImage, "middleImage3");
  applyRGBMaxFilter(middleImage, middleImage);
  saveImage(middleImage, "middleImage4");
  applyRedFilter(middleImage, middleImage);
  saveImage(middleImage, "middleImage5");
  applyBlackToWhiteFilter(middleImage, middleImage);
  saveImage(middleImage, "middleImage6");
  applyNeighborFilter(middleImage, middleImage);
  saveImage(middleImage, "middleImage7");
  processHoles(middleImage, middleImage);
  saveImage(middleImage, "middleImage8");
}

void increaseSaturation(PImage inputImage, PImage outputImage, float saturationFactor) {
  inputImage.loadPixels();
  outputImage.loadPixels();
  
  // Definir o modelo de cor para HSB para facilitar o ajuste da saturação
  colorMode(HSB, 360, 100, 100);

  // Processar cada pixel
  for (int i = 0; i < inputImage.pixels.length; i++) {
    color oldColor = inputImage.pixels[i];
    float h = hue(oldColor);
    float s = saturation(oldColor);
    float b = brightness(oldColor);
    s *= saturationFactor;  // Ajustar a saturação
    s = constrain(s, 0, 100);  // Garantir que a saturação esteja dentro do intervalo permitido
    outputImage.pixels[i] = color(h, s, b);
  }

  outputImage.updatePixels();
  
  // Voltar ao modelo de cor RGB
  colorMode(RGB, 255);
}

void adjustContrast(PImage inputImage, PImage outputImage, float contrastFactor) {
  inputImage.loadPixels();
  outputImage.loadPixels();
  float factor = (259 * (contrastFactor + 255)) / (255 * (259 - contrastFactor));
  for (int i = 0; i < inputImage.pixels.length; i++) {
    color oldColor = inputImage.pixels[i];
    float r = red(oldColor);
    float g = green(oldColor);
    float b = blue(oldColor);
    r = constrain(factor * (r - 128) + 128, 0, 255);
    g = constrain(factor * (g - 128) + 128, 0, 255);
    b = constrain(factor * (b - 128) + 128, 0, 255);
    outputImage.pixels[i] = color(r, g, b);
  }
  outputImage.updatePixels();
}

void applyRGBMaxFilter(PImage inputImage, PImage outputImage) {
  inputImage.loadPixels();
  outputImage.loadPixels();

  for (int i = 0; i < inputImage.pixels.length; i++) {
    color inColor = inputImage.pixels[i];
    float r = red(inColor);
    float g = green(inColor);
    float b = blue(inColor);

    // Encontrar o valor máximo entre os canais R, G e B
    float maxVal = max(r, max(g, b));

    // Ajustar cada canal para o valor máximo
    outputImage.pixels[i] = color(r == maxVal ? maxVal : 0, g == maxVal ? maxVal : 0, b == maxVal ? maxVal : 0);
  }

  outputImage.updatePixels();
}

void applyMedianFilter(PImage inputImage, PImage outputImage, int kernelSize) {
  inputImage.loadPixels();
  outputImage.loadPixels();

  int width = inputImage.width;
  int height = inputImage.height;
  int edge = kernelSize / 2;

  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      if (i < edge || i >= (width - edge) || j < edge || j >= (height - edge)) {
        outputImage.pixels[j * width + i] = inputImage.pixels[j * width + i];
      } else {
        ArrayList<Float> reds = new ArrayList<Float>();
        ArrayList<Float> greens = new ArrayList<Float>();
        ArrayList<Float> blues = new ArrayList<Float>();

        for (int kx = -edge; kx <= edge; kx++) {
          for (int ky = -edge; ky <= edge; ky++) {
            int pixelIndex = (j + ky) * width + (i + kx);
            color col = inputImage.pixels[pixelIndex];
            reds.add(red(col));
            greens.add(green(col));
            blues.add(blue(col));
          }
        }

        outputImage.pixels[j * width + i] = color(
          median(reds),
          median(greens),
          median(blues)
        );
      }
    }
  }

  outputImage.updatePixels();
}

// Função para calcular a mediana em um ArrayList de Float
float median(ArrayList<Float> values) {
  // Implementação simples de um algoritmo de ordenação
  // Vamos usar um bubble sort para ordenar a lista devido à simplicidade
  for (int i = 0; i < values.size() - 1; i++) {
    for (int j = 0; j < values.size() - 1 - i; j++) {
      if (values.get(j) > values.get(j + 1)) {
        float temp = values.get(j);
        values.set(j, values.get(j + 1));
        values.set(j + 1, temp);
      }
    }
  }

  int middle = values.size() / 2;
  if (values.size() % 2 == 1) {
    return values.get(middle);
  } else {
    return (values.get(middle - 1) + values.get(middle)) / 2.0;
  }
}

void applyCompositeColorToBlackFilter(PImage inputImage, PImage outputImage, float minThreshold, float maxThreshold, float minIntensity, float maxIntensity) {
    inputImage.loadPixels();
    outputImage.loadPixels();

    for (int i = 0; i < inputImage.pixels.length; i++) {
        color currentColor = inputImage.pixels[i];
        float r = red(currentColor);
        float g = green(currentColor);
        float b = blue(currentColor);

        // Calcular as diferenças entre os canais
        float diffRG = abs(r - g);
        float diffRB = abs(r - b);
        float diffGB = abs(g - b);

        // Verificar se duas cores estão dentro dos limiares de proximidade e dentro dos limites de intensidade
        if (((diffRG >= minThreshold && diffRG <= maxThreshold && r > minIntensity && g > minIntensity && r < maxIntensity && g < maxIntensity) ||
            (diffRB >= minThreshold && diffRB <= maxThreshold && r > minIntensity && b > minIntensity && r < maxIntensity && b < maxIntensity) ||
            (diffGB >= minThreshold && diffGB <= maxThreshold && g > minIntensity && b > minIntensity && g < maxIntensity && b < maxIntensity)) &&
            !(diffRG == 0 && diffRB == 0 && diffGB == 0)) { // Verificar que não são cinzas
            outputImage.pixels[i] = color(0);  // Configura o pixel para preto
        } else {
            outputImage.pixels[i] = currentColor;  // Mantém a cor original
        }
    }

    outputImage.updatePixels();
}

void applyRedFilter(PImage inputImage, PImage outputImage) {
  inputImage.loadPixels();
  outputImage.loadPixels();

  for (int i = 0; i < inputImage.pixels.length; i++) {
    color inColor = inputImage.pixels[i];
    float r = red(inColor);
    float g = green(inColor);
    float b = blue(inColor);

    // Check if the pixel is predominantly red
    if (r > g && r > b) {
      outputImage.pixels[i] = inColor;
    } else {
      outputImage.pixels[i] = color(0);
    }
  }

  outputImage.updatePixels();
}

void applyBlackToWhiteFilter(PImage inputImage, PImage outputImage) {
  inputImage.loadPixels();
  outputImage.loadPixels();

  for (int i = 0; i < inputImage.pixels.length; i++) {
    color currentColor = inputImage.pixels[i];
    if (currentColor != color(0)) {
      outputImage.pixels[i] = color(255);
    } else {
      outputImage.pixels[i] = currentColor;
    }
  }

  outputImage.updatePixels();
}

void applyNeighborFilter(PImage inputImage, PImage outputImage) {
  inputImage.loadPixels();
  outputImage.loadPixels();

  int width = inputImage.width;
  int height = inputImage.height;

  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      int pixelIndex = j * width + i;
      color currentColor = inputImage.pixels[pixelIndex];
      int neighborCount = 0;

      // Check the neighbors in a 3x3 grid around the current pixel
      for (int kx = -1; kx <= 1; kx++) {
        for (int ky = -1; ky <= 1; ky++) {
          int neighborX = i + kx;
          int neighborY = j + ky;

          // Skip the current pixel itself
          if (kx == 0 && ky == 0) {
            continue;
          }

          // Check if the neighbor is within the image boundaries
          if (neighborX >= 0 && neighborX < width && neighborY >= 0 && neighborY < height) {
            int neighborPixelIndex = neighborY * width + neighborX;
            color neighborColor = inputImage.pixels[neighborPixelIndex];

            // Check if the neighbor has the same color as the current pixel
            if (neighborColor == currentColor) {
              neighborCount++;
            }
          }
        }
      }

      // If at least 2 neighbors have the same color, keep the pixel, otherwise set it to black
      if (neighborCount >= 2) {
        outputImage.pixels[pixelIndex] = currentColor;
      } else {
        outputImage.pixels[pixelIndex] = color(0);
      }
    }
  }

  outputImage.updatePixels();
}

void processHoles(PImage inputImg, PImage outputImg) {
  inputImg.loadPixels();
  outputImg.loadPixels();
  int[][] borderTouch = new int[inputImg.width][inputImg.height];

  checkAndFillBorders(inputImg, borderTouch);

  // Preencher buracos internos que tocam no máximo uma borda
  for (int x = 1; x < inputImg.width - 1; x++) {
    for (int y = 1; y < inputImg.height - 1; y++) {
      if (brightness(inputImg.pixels[x + y * inputImg.width]) == 0 && borderTouch[x][y] == 0 ) {
        floodFill(inputImg, outputImg, x, y, color(255, 255, 255), borderTouch); // Preenche com vermelho
      }
    }
  }
  outputImg.updatePixels();
}

void checkAndFillBorders(PImage inputImg, int[][] borderTouch) {
  // Checa bordas horizontalmente e verticalmente
  for (int x = 0; x < inputImg.width; x++) {
    floodFillEdge(inputImg, x, 0, borderTouch);
    floodFillEdge(inputImg, x, inputImg.height - 1, borderTouch);
  }
  for (int y = 0; y < inputImg.height; y++) {
    floodFillEdge(inputImg, 0, y, borderTouch);
    floodFillEdge(inputImg, inputImg.width - 1, y, borderTouch);
  }
}

void floodFillEdge(PImage inputImg, int x, int y, int[][] borderTouch) {
  Stack<int[]> stack = new Stack<>();
  stack.push(new int[]{x, y});

  while (!stack.isEmpty()) {
    int[] pos = stack.pop();
    x = pos[0];
    y = pos[1];

    if (x < 0 || x >= inputImg.width || y < 0 || y >= inputImg.height || borderTouch[x][y] != 0 || brightness(inputImg.pixels[x + y * inputImg.width]) > 0) {
      continue;
    }

    borderTouch[x][y] = 1;  // Marca o pixel como conectado a uma borda
    stack.push(new int[]{x + 1, y});
    stack.push(new int[]{x - 1, y});
    stack.push(new int[]{x, y + 1});
    stack.push(new int[]{x, y - 1});
  }
}

void floodFill(PImage inputImg, PImage outputImg, int x, int y, color c, int[][] borderTouch) {
  Stack<int[]> stack = new Stack<>();
  stack.push(new int[]{x, y});

  while (!stack.isEmpty()) {
    int[] pos = stack.pop();
    x = pos[0];
    y = pos[1];

    if (x < 0 || x >= inputImg.width || y < 0 || y >= inputImg.height || borderTouch[x][y] != 0 || brightness(inputImg.pixels[x + y * inputImg.width]) > 0) {
      continue;
    }

    outputImg.pixels[x + y * inputImg.width] = c;
    stack.push(new int[]{x + 1, y});
    stack.push(new int[]{x - 1, y});
    stack.push(new int[]{x, y + 1});
    stack.push(new int[]{x, y - 1});
  }
}


void saveImage(PImage img, String str) {
  // Salva o mapa de profundidade
  img.save(str + ".png");
}