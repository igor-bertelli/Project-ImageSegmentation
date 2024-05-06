PImage img;
void setup() {
  size(400, 267);
  noLoop();
  //Define o limiar para a limiarização
  int valorLimiar = 122;
  //Carrega a imagem escolhida
  img = loadImage("0282.jpg");
  //Carrega a imagem para manipulação dos pixels
  img.loadPixels(); 
  // Percorre todos os pixels da imagem
  for (int i = 0; i < img.pixels.length; i++) {
    int corAtual = img.pixels[i];
    // Calcula a média para receber na escala de cinza
    int mediaEscalaCinza = (int)(red(corAtual) * 0.5 + green(corAtual) * 0.5 + blue(corAtual) * 0.0);
    if (mediaEscalaCinza > valorLimiar) {
      img.pixels[i] = color(255); 
    } else {
      img.pixels[i] = color(0); 
    }
  }
  img.updatePixels();
}

void draw() {
  image(img, 0, 0); 
  save("limiarizacao.jpg");
}

