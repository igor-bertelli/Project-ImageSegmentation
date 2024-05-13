void setup() {
    size(300, 300);
    noLoop();
}

void draw() {
    PImage img = loadImage("0194.jpg");
    PImage cinza = createImage(img.width, img.height, RGB);
    PImage sobel = createImage(img.width, img.height, RGB);
    PImage gt = createImage(img.width, img.height, RGB);
    PImage segmentada = createImage(img.width, img.height, RGB);
    PImage destaqueVermelho = createImage(img.width, img.height, RGB);
    PImage cinzaDestaqueVermelho = createImage(img.width, img.height, RGB);

    for(int i = 0; i < img.pixels.length; i++) {
        float cinzaValue = brightness(img.pixels[i]);
        cinza.pixels[i] = color(cinzaValue);
    }

    for(int i = 0; i < 3; i++) {
        sobel = sobel(cinza);
    }

    for(int i = 0; i < sobel.pixels.length; i++) {
        float cinzaValue = brightness(sobel.pixels[i]);
        if(cinzaValue > 70) 
            sobel.pixels[i] = color(255);
        else 
            sobel.pixels[i] = color(0);
    }

    for(int i = 0; i < 12; i++) {
        sobel = mediana(sobel);
    }

    for(int i = 0; i < img.pixels.length; i++) {
        float r = red(img.pixels[i]);
        float g = green(img.pixels[i]);
        float b = blue(img.pixels[i]);

        if(r > 150 && g < 100 && b < 100) {
            segmentada.pixels[i] = img.pixels[i];
            destaqueVermelho.pixels[i] = color(255);
        } else {
            segmentada.pixels[i] = color(0);
            destaqueVermelho.pixels[i] = color(0);
        }
        
        float grayWithRed = (r + g + b) / 3;
        if(r > 150 && g < 100 && b < 100) {
            cinzaDestaqueVermelho.pixels[i] = color(255);
        } else {
            cinzaDestaqueVermelho.pixels[i] = color(grayWithRed);
        }
    }
    
    image(segmentada, 0, 0);
    save("0194-segmentada.jpg");

    image(destaqueVermelho, 0, 0);
    save("0194-destaque-vermelho.jpg");

    image(cinzaDestaqueVermelho, 0, 0);
    save("0194-cinza-destaque-vermelho.jpg");
}

PImage sobel(PImage cinza) {
    PImage aux = createImage(cinza.width, cinza.height, RGB);

    int[][] gx = {{-1,-2,-1},{0,0,0},{1,2,1}};
    int[][] gy = {{-1,0,1},{-2,0,2}, {-1,0,1}};

    for (int y = 0; y < cinza.height; y++) {
        for (int x = 0; x < cinza.width; x++) {
            int pos = y * cinza.width + x;
            float sumx = 0;
            float sumy = 0;
            for (int i = -1; i <= 1; i++) {
                for (int j = -1; j <= 1; j++) {
                    int x0 = constrain(x + j, 0, cinza.width - 1);
                    int y0 = constrain(y + i, 0, cinza.height - 1);
                    sumx += gx[i + 1][j + 1] * brightness(cinza.pixels[y0 * cinza.width + x0]);
                    sumy += gy[i + 1][j + 1] * brightness(cinza.pixels[y0 * cinza.width + x0]);
                }
            }
            float total = sqrt(sumx * sumx + sumy * sumy);
            aux.pixels[pos] = color(total);
        }
    }
    return aux;
}

PImage mediana(PImage img) {
    PImage aux = createImage(img.width, img.height, RGB);

    int[][] kernel = {{1,1,1},{1,1,1},{1,1,1}};
  
    for(int x = 1; x < img.width - 1; x++) {
        for(int y = 1; y < img.height - 1; y++) {
            int index = 0;
            int[] values = new int[kernel.length * kernel[0].length];
            
            for(int i = -1; i <= 1; i++) {
                for (int j = -1; j <= 1; j++) {
                    int px = constrain(x + i, 0, img.width - 1);
                    int py = constrain(y + j, 0, img.height - 1);
                    values[index] = int(brightness(img.pixels[py * img.width + px]));
                    index++;
                }
            }

            int medianValue = median(values);
            aux.pixels[y * img.width + x] = color(medianValue);
        }
    }
    return aux;
}

int median(int[] values) {
    int[] sortedValues = values.clone();
    bubbleSort(sortedValues);
    int medianIndex = sortedValues.length / 2;
    return sortedValues[medianIndex];
}

void bubbleSort(int[] arr) {
    int n = arr.length;
    for (int i = 0; i < n-1; i++) {
        for (int j = 0; j < n-i-1; j++) {
            if (arr[j] > arr[j+1]) {
                int temp = arr[j];
                arr[j] = arr[j+1];
                arr[j+1] = temp;
            }
        }
    }
}
