/*Programa desarrollado para controlar el numero de saltos que da una persona en un trampolín por medio de un sensor utrasonico, el numero de saltos determinará si la persona cumple o no el reto 
predispuesto por el programa. Al finalizar la experiencia se mostrara un video ganador o perdedor segun el resultado 
El programa contiene un registro el cual envia los datos a sqlite.
se debe hacer la conexion con arduino y cargar el codigo guardado en la data del programa.
*/
//Programa V 5.0
//Elaborado por David Palacio Rubiano

import de.bezier.data.sql.*;//Libreria para conexión sqlite
import processing.serial.*; // Libreria para leer serial
import processing.video.*; // libreria para importar videos
import controlP5.*;// librería para construir formulario

int up, saltos, cont, i, delay, puerta, saltost, condicion;
int puerta2 = 1;
int aux = 6;
int r = int(random(1, 9));
float val1, val2, val3,v;
String reto, t;

PImage start,reto1,boton,instruccion,login; // imagenes

boolean min = false;

Movie cronometro, ganar, perder; // videos

ControlP5 cp5;
Textarea myTextarea;


SQLite db;
String nombre, cedula, val;

String textValue = "";

Serial myPort;

void setup() {
  fullScreen();
  login = loadImage("login.jpg");//imagen de registro
  start = loadImage("start.jpg");// imagen para comenzar a jugar
  reto1 = loadImage("reto1.jpg");// imagen que muestra el reto de la experiencia
  boton = loadImage("botonConteo.png"); // boton de la experiencia, conteo de saltos
  instruccion = loadImage("instrucciones.png");//instrucciones mostradas en la seccion de saltos


  cronometro = new Movie(this, "cronometro.mp4");// video temporizador de la experiencia
  ganar = new Movie(this, "ganar.mp4");//video ganar
  perder = new Movie(this, "perder.mp4");// vieo perder

  cp5 = new ControlP5(this);
    
  String portName = Serial.list()[0]; // se hace una lista de seriales para luego leerlos
  println(portName);
  myPort = new Serial(this, portName, 9600);// se configura la velocidad, debe estar sincronizada con arduino
}
void movieEvent(Movie m) {
  m.read();
}
void draw() {
  commSerial(); // lee los valores mandados por el serial

  if (puerta2 == 1) { // si puerta = 2 se muestra el formulario
   image(login, 0, 0);
   cp5.addTextfield("pp")// textField
    .setPosition(380, 688)
    .setSize(365, 60)
    .setFont(createFont("arial", 30))
    .setFocus(true)
    .setColor(color(0,0,0))
    .setColorBackground(color(255, 255, 255)) 
    ;

  cp5.addTextfield("oo")// textField
    .setPosition(380, 760)
    .setSize(365, 60)
    .setFont(createFont("arial", 30))
    .setFocus(true)
    .setColor(color(0,0,0))
    .setColorBackground(color(255, 255, 255)) 
    ;

  cp5.addBang("LOGIN") // boton
    .setPosition(360, 848)
    .setFont(createFont("arial", 30))
    .setSize(400, 80)
    .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
    .setColor(color(255, 255, 255))
    ; 
  }

  puerta2 = -1; // se desactiva el formulario para que no se siga generando
  i = 1;
  puerta = 1;
  if (condicion == 1) {
    puerta = 0;
    i = 0;
  }
  t = nf(saltos, 2); 
  if (i == 0) { // si i = 0, se eliminan los elementos del formulario y se muestra la imagen principal de la experiencia
    cp5.remove("LOGIN");
    cp5.remove("pp");
    cp5.remove("oo");
    image(start, 0, 0);
  }
  if (puerta == 0) { 
    sumador(); //conteo de up al presionar cualquier tecla
  }
  if (up > 1) {
    i = -1;
    switch(r) { // retos elegidos aleatoriamente
    case 1:
      reto = "Salta 50 veces en 60 segundos";
      saltost = 50;// total de saltos que el usuario debe realizar
      v = 1;// velocidad del video
      break;
    case 2:
      reto = "Salta 55 veces en 60 segundos";
      saltost = 55;
      v = 1;
      break;
    case 3:
      reto = "salta 30 veces en 40 segundos";
      saltost = 30;
      v = 1.5;
      break;
    case 4:
      reto = "salta 35 veces en 40 segundos";
      saltost = 35;
      v = 1.5;
      break;
    case 5:
      reto = "salta 20 veces en 30 segundos";
      saltost = 20;
      v = 2;
      break;
    case 6:
      reto = "Salta 25 veces en 30 segundos";
      saltost = 25;
      v = 2;
      break;
    case 7:
      reto= "Salta 20 veces en 20 segundos";
      saltost = 20;
      v = 3;
      break;
    case 8:
      reto = "Salta 15 veces en 20 segundos";
      saltost = 15;
      v = 3;
      break;
    case 9:
      reto = "Salta 10 veces en 10 segundos";
      saltost = 10;
      v =6;
      break;
    case 10:
      reto = "Salta 7 veces en 10 segundos";
      saltost = 7;
      v = 6;
      break;
    }

    if (delay == 0) {
      delay(1000);
    }
    cont++;
    image(reto1, 0, 0);// se muestra pantalla del reto 
    textSize(70);
    text(reto, 5, 1200);// text del reto
    if (cont > 4 && cont < 11) { //se esperan 5 segundos para iniciar el contador
      aux--;
      fill(0, 0, 0);
      textSize(200);
      text(aux, 475, 1000);// texto del contador del reto
      fill(255, 255, 255);
    }
    if (aux == 0) {
      if (val == null) {
        val = "0";
      }
      val1 = float(val);
      int val4 = 0;
      val4 = int(val1);
      println(val4);
      if (val4 >17 && min == true) {
        min =false;
        saltos++; // se incrementa el numero de saltos cuando la persona baja y sube
      } else if (min == false && val4< 16) {
        min = true;
      }

      puerta = 1; 
      delay = 1; //se eimina el delay para que el video se reproduzca con normalidad
      cronometro.play(); // Se reproduce la pantalla de la experiencia
      cronometro.speed(v);// velocidad del video
      image(cronometro, 0, 0, 1080, 1920); // se posiciona la pantalla de la experiencia
      image(boton, 0, 300);// boton del contador
      image(instruccion, 0, 1620);// instruccion inferior
      fill(255, 255, 255);
      textSize(200);
      text(t, 420, 900);// contador de 2 cifras
    }
  }
  if (cronometro.time() == 60 && saltost - saltos <0 || saltost - saltos <0) {
    condicion = 0;// se desactiva i y puerta 
    up = -1;
    ganar.play(); // se reproduce el video ganador
    image(ganar, 0, 0, 1080, 1920);
    if (ganar.time() > 9) { // se reestablecen todos los valores iniciales para que la experiencia vuelva a comenzar
      ganar.stop();
      cronometro.stop();
      aux = 6;
      r = int(random(1, 9));
      cont = 0;
      delay = 0;
      saltos = 0;
      up = 0;
      puerta2 = 1;
      condicion = 0;
    }
  }
  if (cronometro.time() ==60 && saltost-saltos >= 0) {
    condicion = 0;// se desactiva i y puerta 
    up = -1;
    perder.play();// se reproduce el video perdedor
    image(perder, 0, 0, 1080, 1920);
    if (perder.time() > 9) {// se reestablecen todos los valores iniciales para que la experiencia vuelva a comenzar
      perder.stop();
      cronometro.stop();
      aux = 6;
      r = int(random(1, 9));
      cont = 0;
      delay = 0;
      saltos = 0;
      up = 0;
      puerta2 = 1;
      condicion = 0;
    }
  }
}

void sumador() { // funcion para sumar up con cualquier tecla
  if (keyPressed==true ) {
    up++;
  }
}

void controlEvent(ControlEvent theEvent) {
  if (theEvent.isAssignableFrom(Button.class)) {
    println("controlEvent: accessing a string from controller '"
      +theEvent.getName()+"': "
      +theEvent.getStringValue()
      );
  }
}

public void input(String theText) {
  println("a textfield event for controller 'input' : "+theText);
}

public void LOGIN() {// cuando se ejecuta el boton se toman los valores de los textField para mandarlos por un query a la base de datos
  try {
    nombre =  (cp5.get(Textfield.class, "pp").getText()); 
    cedula = (cp5.get(Textfield.class, "oo").getText()); 
    db = new SQLite( this, "jumpAround.db" );

    if (db.connect()) {
      db.query("INSERT into Usuario (nombre,cedula) values('"+nombre+"','"+cedula+"')");
    }
          condicion = 1;// cuando se realiza la conexion condicion = 1;
    
  }
  catch(Exception e) {
    print("Error al grabar la base de datos");
  }
}

void commSerial() { // funcion que lee serial
  //Leer Serial  
  if ( myPort.available() > 0) 
  { 
    val = myPort.readStringUntil('\n');
  }
}
