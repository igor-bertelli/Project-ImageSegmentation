import java.util.Queue;
import java.util.LinkedList;
import java.awt.Point;
import java.util.Arrays;

void setup() {
    size(300, 400);
    noLoop();
}

void draw() {
    PImage img = loadImage("0074.jpg");
    PImage cinza = createImage(img.width, img.height, RGB);
    PImage sobel = createImage(img.width, img.height, RGB);
    PImage gt = createImage(img.width, img.height, RGB);
    PImage segmentada = createImage(img.width, img.height, RGB);

    for(int i = 0; i < img.pixels.length; i++) {
        float c = green(img.pixels[i]);

        cinza.pixels[i] = color(c);
    }

    image(cinza, 0, 0);
    save("0074-cinza.jpg");  

    for(int i = 0; i < 3; i++) {
        sobel = sobel(cinza);
    }

    image(sobel, 0, 0);
    save("0074-sobel.jpg"); 
    
    floodFill(sobel, 150, 200);
    floodFill(sobel, 176, 315);
    floodFill(sobel, 136, 215);
    floodFill(sobel, 196, 212);
    floodFill(sobel, 16, 147);
    floodFill(sobel, 153, 298);
    floodFill(sobel, 184, 342);
    floodFill(sobel, 152, 321);
    floodFill(sobel, 159, 336);

    for(int i = 0; i < 12; i++) {
        sobel = mediana(sobel);
    }

    for(int y = 0; y < img.height; y++) {
        for(int x = 0; x < img.width; x++) {
            if(y < 40)
                gt.pixels[y * img.width + x] = color(0);
            else 
                gt.pixels[y * img.width + x] = sobel.pixels[y * img.width + x];
        }
    }
    image(gt, 0, 0);
    save("0074-gt.jpg");

    for(int i = 0; i < img.pixels.length; i++) {
        if(red(gt.pixels[i]) == 255)
            segmentada.pixels[i] = img.pixels[i];
        else 
            segmentada.pixels[i] = color(0);
    }

    image(segmentada, 0, 0);
    save("0074-segmentada.jpg");
}

PImage sobel(PImage cinza) {
    PImage aux = createImage(cinza.width, cinza.height, RGB);

    int[][] gx = {{-1,-2,-1},{0,0,0},{1,2,1}};
    int[][] gy = {{-1,0,1},{-2,0,2}, {-1,0,1}};

    for (int y = 0; y < cinza.height; y++) {
        for (int x = 0; x < cinza.width; x++) {
        int jan = 1;
        int pos = (y)*cinza.width + (x);

        float mediaOx = 0, mediaOy = 0;

        for (int i = jan*(-1); i <= jan; i++) {
            for (int j = jan*(-1); j <= jan; j++) {
            int disy = y+i;
            int disx = x+j;
            if (disy >= 0 && disy < cinza.height &&
                disx >= 0 && disx < cinza.width) {
                int pos_aux = disy * cinza.width + disx;
                float Ox = red(cinza.pixels[pos_aux]) * gx[i+1][j+1];
                float Oy = red(cinza.pixels[pos_aux]) * gy[i+1][j+1];
                mediaOx += Ox;
                mediaOy += Oy;
            }
            }
        }

        float mediaFinal = sqrt(mediaOx*mediaOx + mediaOy*mediaOy);

        if(mediaFinal > 70) 
            mediaFinal = 255;
        else 
            mediaFinal = 0;

        aux.pixels[pos] = color(mediaFinal, mediaFinal, mediaFinal);
        }
    }

    return aux;
}

PImage mediana(PImage img) {
    PImage aux = createImage(img.width, img.height, RGB);

    int[][] kernel = {{1,1,1},{1,1,1},{1,1,1}};

    int[] values = new int[kernel.length * kernel[0].length];
  
    for(int x = 1; x < img.width - 1; x++) {
        for(int y = 1; y < img.height - 1; y++) {
            int index = 0;
            
            for(int i = -1; i <= 1; i++) {
                for (int j = -1; j <= 1; j++) {
                int px = constrain(x + i, 0, img.width - 1);
                int py = constrain(y + j, 0, img.height - 1);
                values[index] = img.pixels[py * img.width + px];
                index++;
                }
            }
            
            Arrays.sort(values);
            int medianIndex = values.length / 2;
            aux.pixels[y * img.width + x] = values[medianIndex];
        }
    }
    return aux;
}

void floodFill(PImage img, int x, int y) {
    Queue<Point> q = new LinkedList<Point>();
    q.add(new Point(x, y));

    while(!q.isEmpty()) {
        Point p = q.poll();

        if(fillTest(img, p.x, p.y)) {
            img.pixels[p.y * img.width + p.x] = color(255);

            q.add(new Point(p.x - 1, p.y));
            q.add(new Point(p.x + 1, p.y));
            q.add(new Point(p.x, p.y - 1));
            q.add(new Point(p.x, p.y + 1));
        }
    }
    
    img.updatePixels();
}

boolean fillTest(PImage img, int x, int y) {
    if(y < 0) return false;
    if(x < 0) return false;
    if(y > img.height-1) return false;
    if(x > img.width-1) return false;
    if(red(img.pixels[y * img.width + x]) == 255) return false;

    return true;
}