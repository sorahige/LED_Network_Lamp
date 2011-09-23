// Example 08B: Arduino Network Lamp

#define SENSOR 0
#define R_LED 9
#define G_LED 10
#define B_LED 11
#define BUTTON 12

int val = 0; //SENSOR(0)から読み取った値を格納する変数

int btn = LOW;
int old_btn = LOW;
int state = 0;
char buffer[7];
int pointer = 0;
byte inByte = 0;

byte r = 0;
byte g = 0;
byte b = 0;

void setup() {
  Serial.begin(9600); //open serial port
  pinMode(BUTTON, INPUT);
}

void loop() {
  val = analogRead(SENSOR);  // SENSOR(A0)から値を読み込む
  Serial.println(val) ;       // Serial通信で値を送信

  if (Serial.available() > 0) {
    //受信したデータを読み取る
    inByte = Serial.read();

    // マーカ(#)が見つかったら、続く６文字が色情報
    if (inByte == '#') {
      while (pointer < 6) {               // 6文字蓄積
        buffer[pointer] = Serial.read();  // バッファに格納
        pointer++;                        // ポインタを1進める
      }

      // 3つの16進の数字がそろったので、RGBの3バイトにデコード
      r = hex2dec(buffer[1]) + hex2dec(buffer[0]) * 16;
      g = hex2dec(buffer[3]) + hex2dec(buffer[2]) * 16;
      b = hex2dec(buffer[5]) + hex2dec(buffer[4]) * 16;

      pointer = 0;
    }
  }

  btn = digitalRead(BUTTON);

  if ((btn == HIGH) && (old_btn == LOW)) {
    state = 1 - state;
  }

  old_btn = btn;

  if (state == 1) {
    analogWrite(R_LED, r);
    analogWrite(G_LED, g);    
    analogWrite(B_LED, b);
  }
  else {
    analogWrite(R_LED, 0);
    analogWrite(G_LED, 0);    
    analogWrite(B_LED, 0);
  }
  delay(100); // wait 0.1sec
}

int hex2dec(byte c) {
  if (c >= '0' && c <= '9' ) {
    return c - '0';
  }
  else if (c >= 'A' && c <= 'F') {
    return c - 'A' + 10;
  }
}




