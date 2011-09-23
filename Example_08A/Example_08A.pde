// Example 06B

#define LED 9 // LED connected
int val = 0;


void setup() {
  pinMode(LED, OUTPUT);
  // A0はanalog-in専用なので設定不要
}

void loop() {

  val = analogRead(0); //A0からの入力を読み込む

  analogWrite(LED,val/4);
  delay(10);

}


