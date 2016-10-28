/*    ____                  __                   _   __                   ______           
    / __ \____ _____  ____/ /___  ____ ___     / | / /___ _____ ___  ___/_  __/___ _____ _
   / /_/ / __ `/ __ \/ __  / __ \/ __ `__ \   /  |/ / __ `/ __ `__ \/ _ \/ / / __ `/ __ `/
  / _, _/ /_/ / / / / /_/ / /_/ / / / / / /  / /|  / /_/ / / / / / /  __/ / / /_/ / /_/ / 
 /_/ |_|\__,_/_/ /_/\__,_/\____/_/ /_/ /_/  /_/ |_/\__,_/_/ /_/ /_/\___/_/  \__,_/\__, /  
 
 A random name tag generator.
 
 Pulls random fake names generated from a genetic algorithm and prints them on a Dymo label machine
 
 Use:
 N makes new name
 P prints nametag
 
 Software dependencies:
 Fonts:
 "DINPro-Regular"
 "DINAlternate-Bold"
 
 Hardware dependencies:
 OSX computer
 Dymo LaberWriter loaded with: DYMO LW Name Badge Labels 2 1/4" x 4" SKU: 30857
 Printer must be set to defaul printer
 
 //Todo, ensure names are never used twice, GA gen real surnames
 
 */
import processing.pdf.*;
import java.io.*;
Table givenNames;// Table surnames; if we get them made
int givenNamesLen;
int givenNameIndex;
int surameIndex;

PFont surnameFont;
PFont givenNameFont;

PShape staticGraphics;

String filename;

String givenName;
String surname;

String wholeName;

void setup() {
  size(288, 162); //72 pixels/points per inch, paper size is 2.25 x 4", doc size is then 162px x 288
  smooth();//antialiased
  fill(0);//all text black
  frameRate(30);

  println("WELCOME TO NAMETAG MACHINE!");
  println("Use:");
  println(" N makes new name");
  println(" P prints nametag");

  staticGraphics = loadShape("NameTagGround2.svg");//Background LL logo and "Hello My Name is banner"

  //Create the fonts
  surnameFont = createFont("DINPro-Regular", 23);//23
  givenNameFont = createFont("DINAlternate-Bold", 37);//37
  textFont(givenNameFont);//set current font to first name
  //Load Names
  givenNames = loadTable("GivenNames.csv");//load the single-column CSV of names
  givenNamesLen = givenNames.getRowCount();//how many names?

  chooseNames();//coose 1st set of names
}

void chooseNames() {
  //Randomly pick names from the database
  givenNameIndex = int(random(givenNamesLen-1));//pick 1st random name
  surameIndex = int(random(givenNamesLen-1)); //until we have a CSV of surnames, we are pretending first names are last names
  //println(givenNamesLen + " total rows in table");

  //append USED to column 2

  givenName = givenNames.getString(givenNameIndex, 0);
  surname = givenNames.getString(surameIndex, 0);
  wholeName = ( givenName+" " +surname);
  println("Welcome to the party comrade " + wholeName);
}

void draw() {
  background(255);//blank the BG
  renderName();
}

void renderName() {
  //puts the names on the screen
  shape(staticGraphics, 0, 0);//place the static BG
  textFont(givenNameFont);
  text(givenName, 33, 101);//37px tall
  textFont(surnameFont);
  text(surname, 33, 135);//23px tall
}

void makePDF() {
  //renders a PDF of the screen and saves to /data folder
  filename = wholeName +".pdf";
  println("Writing PDF " + filename);
  beginRecord(PDF, "data/"+filename);
  fill(0); 
  background(255);
  renderName();
  endRecord();
  printPDF();
}

void printPDF() {
  //make a termianl command to print the previusly made PDF
  String fullFilePath =   (dataPath(filename));
  String[] params = {"/usr/bin/lp", "-o", "orientation-requested=5", fullFilePath}; 
  println("Printing PDF " + filename);
  exec(params); 
  //terminal printing advanced info https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man1/lp.1.html
}


void keyPressed() {
  if (key == 'p' || key == 'P') {
    makePDF();
  }
  if (key == 'n' || key == 'N') {
    chooseNames();
  }
}