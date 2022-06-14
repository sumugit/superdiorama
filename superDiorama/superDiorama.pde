boolean isGrid = true, isAxis = true, night = false;
//回転用
float rad = 0, rad2 = 28, rad4 = 0;
int alpha = 70, a = 0;
//観覧車option
//色のバリエーション
color[] colorPallet = {color(230, 0, 18, alpha), color(243, 152, 0, alpha), color(255, 251, 0, alpha), color(143, 195, 31, alpha),
                       color(0, 153, 68, alpha), color(0, 158, 150, alpha), color(0, 160, 233, alpha), color(0, 104, 183, alpha),
                       color(29, 32, 136, alpha), color(146, 7, 131, alpha), color(228, 0, 127, alpha), color(229, 0, 79, alpha)};
final float gondolaSize =  50;      // ゴンドラの半径
final float speed       =   .3;  // 回転速度
final float depth       =   10;      // 奥行きの大きさ
final int   r2   =  40;      // ゴンドラの外側円柱
final int   r1   =  20;      // ゴンドラの内側円柱
float rad3 = 0;     //回転角

//Image option
PImage imgLeaf, imgTrunk, imgTrainSide, imgTrainFront, imgLogo;
PShape trunk, base;

void setup(){
    size(800, 800, P3D);
    imgLeaf = loadImage("leaf.jpg");
    imgTrunk = loadImage("trunk.jpg");
    imgTrainSide = loadImage("train01.png");
    imgTrainFront = loadImage("train02.jpg");
    imgLogo = loadImage("mig.jpg");
    noStroke(); 
}
void axis(char s, color c){
    int len = 200;fill(c);
    stroke(c);
    pushMatrix();
    if(isAxis){
        box(len, 1, 1);
        pushMatrix();
        translate(len / 2, 0, 0);
        sphere(3);
        text(s, 5, -5, 0);
        popMatrix();
    }
    
    if(isGrid){
        pushMatrix();
        translate(0, -len / 2, -len / 2);
        int ngrids = 20, xs = len / ngrids, ys = len / ngrids;
        for(int i = 1; i < ngrids; i++){
            line(0, 0, ys * i, 0, len, ys * i); 
            line(0, xs * i, 0, 0, xs * i, len); 
        }
        popMatrix();
    }
    popMatrix();
    noStroke();
} 
    
void drawAxis(char s, color c){
    switch(s){
        case 'X': axis(s, c);break;
        case 'Y': pushMatrix();rotateZ(PI / 2);axis(s, c);popMatrix();break;
        case 'Z': pushMatrix();rotateY(-PI / 2);axis(s, c);popMatrix();break;
        }
    }
    
void keyPressed(){
    switch(key){
        case 'g': if(isGrid) isGrid = false;
        else isGrid = true;break;
        case 'a': if(isAxis) isAxis = false;else isAxis = true;break;
        case 'n': if(night) night = false; else night = true;break;
        case 's': saveFrame("photo" + a + ".png");a++;break;
        }
    }

 //円柱の作成(長さ,上面の半径,底面の半径)
void pillar(float length, float radius1 , float radius2){
    float x,y,z;
    pushMatrix();
    //底面の作成
    beginShape(TRIANGLE_FAN);
    z = -length / 2;
    vertex(0, 0, z);
    for(int deg = 0; deg <= 360; deg = deg + 10){
        x = cos(radians(deg)) * radius1;
        y = sin(radians(deg)) * radius1;
        vertex(x, y, z);
    }
    endShape();              
    //上面の作成
    beginShape(TRIANGLE_FAN);
    z = length / 2;
    vertex(0, 0, z);
    for(int deg = 0; deg <= 360; deg = deg + 10){
        x = cos(radians(deg)) * radius2;
        y = sin(radians(deg)) * radius2;
        vertex(x, y, z);
    }
    endShape();
    //側面の作成
    beginShape(TRIANGLE_STRIP);
    for(int deg =0; deg <= 360; deg = deg + 5){
        x = cos(radians(deg)) * radius1;
        y = sin(radians(deg)) * radius1;
        z = -length / 2;
        vertex(x, y, z);
        x = cos(radians(deg)) * radius2;
        y = sin(radians(deg)) * radius2;
        z = length / 2;
        vertex(x, y, z);
    }
    endShape();
    popMatrix();
}

//車の土台
void drawBody(float s, float x, float z, int r, int g, int b, boolean dir){
    pushMatrix();
    fill(r, g, b);
    scale(s);
    translate(x + .05, .2, z);
    rotateY(PI/2);
    if(dir) rotateY(rad*PI/(180*2));
    else rotateY(-rad*PI/180);
    drawBox(1.3, .3, .55, 4);
    //正面部品
    if(dir){
        //目
        pushMatrix();
        if(night) emissive(242, 242, 176);
        fill(255, 0, 0);
        translate(.65, .05, .01*int(55/4));
        rotateY(PI/2);
        box(.01*int(55/4), .05, .05);
        popMatrix();
        //目
        pushMatrix();
        translate(.65, .05, -.01*int(55/4));
        rotateY(PI/2);
        box(.01*int(55/4), .05, .05);
        popMatrix();
        emissive(0);
        //口
        pushMatrix();
        fill(255);
        translate(.66, -.1, 0);
        rotateY(PI/2);
        box(.55, .1, .02);
        popMatrix();
    }
    popMatrix();
    //胴体上
    pushMatrix();
    fill(r, g, b);
    scale(s);
    translate(x, .5, z);
    rotateY(PI/2);
    if (dir) rotateY(rad*PI/(180*2));
    else rotateY(-rad*PI/180);
    drawBox(1., .3, .55, 4);
    popMatrix();
}

//タイヤの描画
void drawTire(float s, float x, float z, boolean dir){
    //回転の中心
    pushMatrix();
    fill(255, 254, 59);
    scale(s);
    translate(x + .05, .2, z);
    rotateY(PI/2);
    if (dir) rotateY(rad*PI/(180*2));
    else rotateY(-rad*PI/180);
    //後輪
    pushMatrix();
    fill(0);
    translate(-.35, -.05, .25);
    pillar(.1, .15, .15);
    fill(255);
    pillar(.1, .1, .1);
    popMatrix();
    //後輪
    pushMatrix();
    fill(0);
    translate(-.35, -.05, -.25);
    pillar(.1, .15, .15);
    fill(255);
    pillar(.1, .1, .1);
    popMatrix();
    //前輪
    pushMatrix();
    fill(0);
    translate(.25, -.05, .25);
    pillar(.1, .15, .15);
    fill(255);
    pillar(.1, .1, .1);
    popMatrix();
    //前輪
    pushMatrix();
    fill(0);
    translate(.25, -.05, -.25);
    pillar(.1, .15, .15);
    fill(255);
    pillar(.1, .1, .1);
    popMatrix();

    popMatrix();
}

//車の描画
void drawCar(float s, float x, float z, int r, int g, int b, boolean dir){
    drawBody(s, x, z, r, g, b, dir);
    drawTire(s, x, z, dir);
}

//四角錐を描画
void pyramid(int p){
        fill(255);
        beginShape(TRIANGLES);
        if(p == 1){
            //葉の描画
            texture(imgLeaf);
            textureMode(NORMAL);
        }
        vertex(0, .5, 0, .5, 0); vertex(-.5, 0, -.5, 0, 1); vertex(.5, 0, -.5, 1, 0);
        vertex(0, .5, 0, .5, 0); vertex(.5, 0, -.5, 0, 1); vertex(.5, 0, .5, 1, 0);
        vertex(0, .5, 0, .5, 0); vertex(.5, 0, .5, 0, 1); vertex(-.5, 0, .5, 1, 0);
        vertex(0, .5, 0, .5, 0); vertex(-.5, 0, .5, 0, 1); vertex(-.5, 0, -.5, 1, 0);
        vertex(-.5, 0, -.5, .5, 0); vertex(.5, 0, .5, 0, 1); vertex(.5, 0, -.5, 1, 0);
        vertex(-.5, 0, -.5, .5, 0); vertex(-.5, 0, .5, 0, 1); vertex(.5, 0, .5, 1, 0);
        endShape(); 
} 

//箱を描画
void drawBox(float s, float h, float d, int p){
    beginShape(QUADS);
    //pはどのboxを描画するか
    if(p == 1){
        //幹
        texture(imgTrunk); 
    }
    textureMode(NORMAL);
    //各面(計6面)で描画
    vertex(-s/2, h/2, -d/2, 0, 0);vertex(-s/2, -h/2, -d/2, 0, 1);vertex(s/2, -h/2, -d/2, 1, 1);vertex(s/2, h/2, -d/2, 1, 0);
    vertex(s/2, h/2, -d/2, 0, 0);vertex(s/2, -h/2, -d/2, 0, 1);vertex(s/2, -h/2, d/2, 1, 1);vertex(s/2, h/2, d/2, 1, 0);
    vertex(s/2, h/2, d/2, 0, 0);vertex(s/2, -h/2, d/2, 0, 1);vertex(-s/2, -h/2, d/2, 1, 1);vertex(-s/2, h/2, d/2, 1, 0);
    vertex(-s/2, h/2, d/2, 0, 0);vertex(-s/2, -h/2, d/2, 0, 1);vertex(-s/2, -h/2, -d/2, 1, 1);vertex(-s/2, h/2, -d/2, 1, 0);
    vertex(-s/2, h/2, d/2, 0, 0);vertex(-s/2, h/2, -d/2, 0, 1);vertex(s/2, h/2, -d/2, 1, 1);vertex(s/2, h/2, d/2, 1, 0);
    vertex(-s/2, -h/2, -d/2, 0, 0);vertex(-s/2, -h/2, d/2, 0, 1);vertex(s/2, -h/2, d/2, 1, 1);vertex(s/2, -h/2, -d/2, 1, 0);
    endShape();
}

//葉全体の描画
void leaves(){
    fill(255);
    pushMatrix();
    translate(0, .5, 0);
    scale(.6, .6, .6);
    pyramid(1);
    popMatrix();
    pushMatrix();
    translate(0, .25, 0);
    scale(.8, .8, .8);
    pyramid(1);
    popMatrix();
    pushMatrix();
    pyramid(1);
    popMatrix();
}

//幹の描画
void trunk(){
    fill(255);
    pushMatrix();
    scale(.2, .4, .2);
    translate(0, .5, 0);
    drawBox(1, 1, 1, 1);
    popMatrix();
}

//木の描画
void drawTree(float s, float x, float z){
    noStroke();
    pushMatrix();
    scale(s, s, s);
    translate(x, 0, z);
    trunk();
    pushMatrix();
    translate(0, .4, 0);
    leaves();
    popMatrix();
    popMatrix();
}

//家の描画
void drawHouse(float s, float x, float z){
    fill(255);
    //土台
    pushMatrix();
    scale(s);
    translate(x, 0.3, z);
    drawBox(0.6, 0.6, 0.6, 2);
    popMatrix();
    //屋根
    pushMatrix();
    scale(s);
    translate(x, 0.6, z);
    pyramid(2);
    popMatrix();
}

//観覧車の描画
void drawFerrisWheel(float s, float x, float z){
    scale(s);
    pushMatrix();
    if(night) emissive(255, 255, 255);
    translate(x, 0, z);
    // 脚
    stroke(126, 15, 9);
    strokeWeight(5);
    line(x - depth, 0, z + depth, x, 80, z + depth);
    line(x + depth, 0, z + depth, x, 80, z + depth);
    line(x - depth, 0, z - depth, x, 80, z - depth);
    line(x + depth, 0, z - depth, x, 80, z - depth);
    strokeWeight(1);
    noStroke();
    popMatrix();
    //支柱
    pushMatrix();
    stroke(126, 15, 9);
    strokeWeight(5);
    translate(x, 80, z);
    for(int i=0; i<24; i++){
        line(x, 0, z + depth, x + gondolaSize*cos(radians(rad3 + 15*i)), gondolaSize*sin(radians(rad3 + 15*i)), z + depth);
        line(x, 0, z - depth, x + gondolaSize*cos(radians(rad3 + 15*i)), gondolaSize*sin(radians(rad3 + 15*i)), z - depth);
        //客室
        pushMatrix();
        stroke(colorPallet[i%12]);
        translate(x + gondolaSize*cos(radians(rad3 + 15*i)), gondolaSize*sin(radians(rad3 + 15*i)), z);
        pillar(15, 5, 5);
        stroke(126, 15, 9);
        popMatrix();
    }
    strokeWeight(1);
    noStroke();
    popMatrix();
    //間の円
    pushMatrix();
    stroke(126, 15, 9);
    strokeWeight(3);
    translate(x, 80, z);
    for(float j = 0; j < 360; j++) {
        line(x + r1 * cos(j), r1 * sin(j), z + depth, x + r1*cos(j + 1), r1 * sin(j+1),  z + depth);
        line(x + r1 * cos(j), r1 * sin(j), z - depth, x + r1*cos(j + 1), r1 * sin(j+1),  z - depth);
        line(x + r2 * cos(j), r2 * sin(j), z + depth, x + r2*cos(j + 1), r2 * sin(j+1),  z + depth);
        line(x + r2 * cos(j), r2 * sin(j), z - depth, x + r2*cos(j + 1), r2 * sin(j+1),  z - depth);
    }
    strokeWeight(1);
    noStroke();
    popMatrix();
    emissive(0);
}

//箱を描画
void signBoard(float s, float h, float d, int p){
    beginShape(QUADS);
    //各面(計6面)で描画
    vertex(s/2, h/2, -d/2, 0, 0);vertex(s/2, -h/2, -d/2, 0, 1);vertex(s/2, -h/2, d/2, 1, 1);vertex(s/2, h/2, d/2, 1, 0);
    vertex(-s/2, h/2, d/2, 0, 0);vertex(-s/2, -h/2, d/2, 0, 1);vertex(-s/2, -h/2, -d/2, 1, 1);vertex(-s/2, h/2, -d/2, 1, 0);
    endShape();
    beginShape(QUADS);
    texture(imgLogo);
    textureMode(NORMAL);
    vertex(-s/2, h/2, -d/2, 0, 0);vertex(-s/2, -h/2, -d/2, 0, 1);vertex(s/2, -h/2, -d/2, 1, 1);vertex(s/2, h/2, -d/2, 1, 0);
    vertex(s/2, h/2, d/2, 0, 0);vertex(s/2, -h/2, d/2, 0, 1);vertex(-s/2, -h/2, d/2, 1, 1);vertex(-s/2, h/2, d/2, 1, 0);
    endShape();
    beginShape(QUADS);
    vertex(-s/2, h/2, d/2, 0, 0);vertex(-s/2, h/2, -d/2, 0, 1);vertex(s/2, h/2, -d/2, 1, 1);vertex(s/2, h/2, d/2, 1, 0);
    vertex(-s/2, -h/2, -d/2, 0, 0);vertex(-s/2, -h/2, d/2, 0, 1);vertex(s/2, -h/2, d/2, 1, 1);vertex(s/2, -h/2, -d/2, 1, 0);
    endShape();
}

//コンビニの描画
void drawConv(float s, float x, float z){
    fill(200);
    //土台
    pushMatrix();
    scale(s);
    translate(x, .025, z);
    //床
    pushMatrix();
    translate(0, 0, .1);
    drawBox(.8, .05, .8, 4);
    popMatrix();
    //主部
    fill(128);
    if(night) emissive(255, 245, 102);
    translate(0, .225, 0);
    drawBox(.7, .4, .5, 4);
    translate(0, .3, 0);
    //帯
    fill(200);
    if(night) emissive(100, 100, 100);
    drawBox(.9, .2, .7, 4);
    fill(0, 104, 196);
    drawBox(.901, .1, .701, 4);
    translate(0, -.07, 0);
    fill(200, 0, 0);
    drawBox(.901, .01, .701, 4);
    popMatrix();
    //ドアとか窓とか
    //縦2等分線
    fill(200);
    emissive(0);
    pushMatrix();
    scale(s);
    translate(x, .25, z + .26);
    drawBox(.02, .4, .02, 4);
    popMatrix();
    //縦4等分線
    pushMatrix();
    scale(s);
    translate(x + .175, .25, z + .26);
    drawBox(.02, .4, .02, 4);
    popMatrix();
    //横2等分線
    //正面
    pushMatrix();
    scale(s);
    translate(x + .2625, .25, z + .26);
    drawBox(.175, .02, .02, 4);
    popMatrix();
    //側面
    pushMatrix();
    scale(s);
    translate(x + .352, .25, z);
    drawBox(.02, .02, .5, 4);
    popMatrix();
    pushMatrix();
    scale(s);
    translate(x - .352, .25, z);
    drawBox(.02, .02, .5, 4);
    popMatrix();
    pushMatrix();
    scale(s);
    translate(x, .25, z - .252);
    drawBox(.7, .02, .02, 4);
    popMatrix();
    //入口の帯
    pushMatrix();
    scale(s);
    translate(x + .0875, .4, z + .26);
    drawBox(.175, .1, .02, 4);
    popMatrix();
    //柱
    pushMatrix();
    scale(s);
    pushMatrix();
    translate(x + .35, .25, z + .25);
    drawBox(.0875, .5, .0875, 4);
    popMatrix();
    pushMatrix();
    translate(x - .35, .25, z + .25);
    drawBox(.0875, .5, .0875, 4);
    popMatrix();
    pushMatrix();
    translate(x + .35, .25, z - .25);
    drawBox(.0875, .5, .0875, 4);
    popMatrix();
    pushMatrix();
    translate(x - .35, .25, z - .25);
    drawBox(.0875, .5, .0875, 4);
    popMatrix();
    popMatrix();
    //ゴミ箱
    pushMatrix();
    scale(s);
    translate(x - .25, .135, z + .29);
    drawBox(.08, .2, .08, 4);
    popMatrix();
    pushMatrix();
    scale(s);
    translate(x - .15, .135, z + .29);
    drawBox(.08, .2, .08, 4);
    popMatrix();
    pushMatrix();
    scale(s);
    translate(x - .05, .135, z + .29);
    drawBox(.08, .2, .08, 4);
    popMatrix();
    //看板
    pushMatrix();
    scale(s);
    translate(x + .6, .4, z + .5);
    rotateX(PI/2);
    pillar(.8, .03, .03);
    popMatrix();
    pushMatrix();
    if(night) emissive(100, 100, 100);
    scale(s);
    translate(x + .6, .95, z + .5);
    signBoard(.3, .3, .1, 5);
    popMatrix();
}

//駅
void drawStation(float s, float x, float z){
    fill(200);
    //土台
    pushMatrix();
    emissive(0);
    scale(s);
    translate(x, .05, z);
    //床
    drawBox(.8, .1, .5, 4);
    popMatrix();
    //壁
    pushMatrix();
    scale(s);
    translate(x, .2, z - .15);
    drawBox(.8, .2, .05, 4);
    popMatrix();
    //屋根
    pushMatrix();
    if(night) emissive(200, 200, 200);
    scale(s);
    translate(x, .3, z - .15);
    rotateX(radians(-15));
    translate(0, 0, .20);
    drawBox(.9, .05, .5, 4);
    popMatrix();
    //柱
    pushMatrix();
    emissive(0);
    scale(s);
    translate(x + .775/2 - .1, .25, z + .15);
    rotateX(PI/2);
    pillar(.3, .025, .025);
    popMatrix();
    pushMatrix();
    scale(s);
    translate(x + .775/4 - .1, .25, z + .15);
    rotateX(PI/2);
    pillar(.3, .025, .025);
    popMatrix();
    pushMatrix();
    scale(s);
    translate(x - .775/2 + .1, .25, z + .15);
    rotateX(PI/2);
    pillar(.3, .025, .025);
    popMatrix();
    pushMatrix();
    scale(s);
    translate(x - .775/4 + .1, .25, z + .15);
    rotateX(PI/2);
    pillar(.3, .025, .025);
    popMatrix();
}

//傘
void umbrella(float r){
    pushMatrix();
    translate(0, .3, 0);
    beginShape(QUADS);
    //正八角錐(計8面)
    for(int i = 0; i < 8; i++){
        if(i%2==0) fill(230, 0, 0);
        else fill(230);
        vertex(0, 0, 0);vertex(-r*cos(radians(30))*cos(radians((360*i)/8)), -r*sin(radians(30)), r*cos(radians(30))*sin(radians(360*i/8)));
        vertex(-r*cos(radians(30))*cos(radians((360*i)/8)), -r*sin(radians(30)), r*cos(radians(30))*sin(radians(360*i/8)));vertex(-r*cos(radians(30))*cos(radians(360*(i+1)/8)), -r*sin(radians(30)), r*cos(radians(30))*sin(radians(360*(i+1)/8)));
        vertex(-r*cos(radians(30))*cos(radians(360*(i+1)/8)), -r*sin(radians(30)), r*cos(radians(30))*sin(radians(360*(i+1)/8)));vertex(0, 0, 0);
    }
    endShape();
    popMatrix();
}

//机
void desk() {
    fill(200);
    //台座
    pushMatrix();
    translate(0, .01, 0);
    rotateX(PI/2);
    pillar(.02, .1, .1);
    popMatrix();
    //支柱
    pushMatrix();
    translate(0, .01 + .4, 0);
    rotateX(PI/2);
    pillar(.8, .02, .02);
    popMatrix();
    //机
    pushMatrix();
    translate(0, .01 + .25, 0);
    drawBox(.4, .03, .4, 4);
    popMatrix();
    //ジュース
    pushMatrix();
    if(night) emissive(163, 188, 226);
    fill(163, 188, 226);
    translate(-.08, .01 + .25 + .015 + .05, .1);
    rotateX(PI/2);
    pillar(.1, .05, .04);
    popMatrix();
    pushMatrix();
    fill(163, 188, 226);
    translate(.08, .01 + .25 + .015 + .05, -.1);
    rotateX(PI/2);
    pillar(.1, .05, .04);
    popMatrix();
    emissive(0);
}

//イス
void chair() {
    fill(200);
    //4足
    pushMatrix();
    scale(2);
    translate(.05, .05, -.05);
    drawBox(.02, .1, .02, 4);
    popMatrix();
    pushMatrix();
    scale(2);
    translate(-.05, .05, -.05);
    drawBox(.02, .1, .02, 4);
    popMatrix();
    pushMatrix();
    scale(2);
    translate(.05, .05, .05);
    drawBox(.02, .1, .02, 4);
    popMatrix();
    pushMatrix();
    scale(2);
    translate(-.05, .05, .05);
    drawBox(.02, .1, .02, 4);
    popMatrix();
    //背もたれ
    pushMatrix();
    scale(2);
    translate(0, .1 + .01, 0);
    drawBox(.12, .02, .12, 4);
    popMatrix();
    pushMatrix();
    scale(2);
    //scale(-1, 1, 1);
    translate(-.06 + .01, .1 + .06, 0);
    drawBox(.02, .11, .11, 4);
    popMatrix(); 
}

//テラスの描画
void drawTerrace(float s, float x, float z) {
    //机
    pushMatrix();
    scale(s);
    translate(x, 0, z);
    desk();
    popMatrix();
    //傘
    pushMatrix();
    scale(s);
    translate(x, .57, z);
    umbrella(.5);
    popMatrix();
    //イス
    pushMatrix();
    scale(s);
    translate(x + .4, 0, z);
    scale(-1, 1, 1);
    chair();
    popMatrix();
    pushMatrix();
    scale(s);
    translate(x - .4, 0, z);
    chair();
    popMatrix();
}

//大きい家の屋根
void largeRoof(float x, float z, float c, float d, float h){
    fill(170);
    pushMatrix();
    beginShape(QUADS);
    vertex(-d/2, 0, -c/2);vertex(-d/2, 0, c/2);vertex(d/2, 0, c/2);vertex(d/2, 0, -c/2);
    //側面1
    vertex(-d/2, 0, c/2);vertex(-d-d/2, -h*sin(radians(40)), c/2 + h*cos(radians(40)));
    vertex(-d-d/2, -h*sin(radians(40)), c/2 + h*cos(radians(40)));vertex(d + d/2, -h*sin(radians(40)), c/2 + h*cos(radians(40)));
    vertex(d + d/2, -h*sin(radians(40)), c/2 + h*cos(radians(40)));vertex(d/2, 0, c/2);
    vertex(d/2, 0, c/2);vertex(-d/2, 0, c/2);
    //側面2
    vertex(d/2, 0, c/2);vertex(d + d/2, -h*sin(radians(40)), c/2 + h*cos(radians(40)));
    vertex(d + d/2, -h*sin(radians(40)), c/2 + h*cos(radians(40)));vertex(d+d/2, -h*sin(radians(40)), -c/2 - h*cos(radians(40)));
    vertex(d+d/2, -h*sin(radians(40)), -c/2 - h*cos(radians(40)));vertex(d/2, 0, -c/2);
    vertex(d/2, 0, -c/2);vertex(d/2, 0, c/2);
    //側面3
    vertex(d/2, 0, -c/2);vertex(d+d/2, -h*sin(radians(40)), -c/2 - h*cos(radians(40)));
    vertex(d+d/2, -h*sin(radians(40)), -c/2 - h*cos(radians(40)));vertex(-d - d/2, -h*sin(radians(40)), -c/2 - h*cos(radians(40)));
    vertex(-d - d/2, -h*sin(radians(40)), -c/2 - h*cos(radians(40)));vertex(-d/2, 0, -c/2);
    vertex(-d/2, 0, -c/2);vertex(d/2, 0, -c/2);
    //側面4
    vertex(-d/2, 0, -c/2);vertex(-d - d/2, -h*sin(radians(40)), -c/2 - h*cos(radians(40)));
    vertex(-d - d/2, -h*sin(radians(40)), -c/2 - h*cos(radians(40)));vertex(-d-d/2, -h*sin(radians(40)), c/2 + h*cos(radians(40)));
    vertex(-d-d/2, -h*sin(radians(40)), c/2 + h*cos(radians(40)));vertex(-d/2, 0, c/2);
    vertex(-d/2, 0, c/2);vertex(-d/2, 0, -c/2);
    endShape();
    popMatrix();
    //屋根部屋1
    pushMatrix();
    translate(0, -.05, 0);
    drawBox(.25, .02, .7, 4);
    popMatrix();
    pushMatrix();
    translate(.15, -.08, 0);
    rotateZ(radians(-40));
    drawBox(.1, .02, .7, 4);
    popMatrix();
    pushMatrix();
    translate(-.15, -.08, 0);
    rotateZ(radians(40));
    drawBox(.1, .02, .7, 4);
    popMatrix();
    //部屋1
    fill(200);
    pushMatrix();
    translate(0, -.09, 0);
    drawBox(.25, .09, .65, 4);
    fill(128);
    if(night) emissive(255, 245, 102);
    drawBox(.18, .04, .656, 4);
    popMatrix();
    //屋根部屋2
    fill(170);
    pushMatrix();
    emissive(0);
    translate(0, -.08, -.06);
    rotateX(radians(-30));
    drawBox(.7, .02, .14, 4);
    popMatrix();
    pushMatrix();
    translate(0, -.08, .06);
    rotateX(radians(30));
    drawBox(.7, .02, .14, 4);
    popMatrix();
    //部屋2
    fill(200);
    pushMatrix();
    translate(0, -.12, 0);
    drawBox(.65, .11, .11, 4);
    fill(128);
    if(night) emissive(255, 245, 102);
    drawBox(.656, .06, .06, 4);
    popMatrix();
    //蓋
    fill(170);
    pushMatrix();
    emissive(0);
    translate(0, -h*sin(radians(40)) - .01, 0);
    drawBox(3*d + .02, .02, 3*d + .02, 4);
    popMatrix();
}

//立派な家
void drawLargeHouse(float s, float x, float z){
    float d = .3;
    //屋根
    pushMatrix();
    scale(s);
    translate(x, .78, z);
    largeRoof(x, z, .2, d, .4);
    popMatrix();
    //土台
    //床
    pushMatrix();
    fill(200);
    scale(s);
    translate(x, .03, z);
    drawBox(3*d + .02, .06, 3*d + .02, 4);
    popMatrix();
    //腹
    pushMatrix();
    if(night) emissive(255, 245, 102);
    fill(128);
    scale(s);
    translate(x, .03 + .2, z);
    drawBox(2.5*d, .4, 2.5*d, 4);
    popMatrix();
    //天井
    pushMatrix();
    emissive(0);
    fill(150);
    scale(s);
    translate(x, .03 + .4 + .04, z);
    drawBox(3*d + .05, .08, 3*d + .05, 4);
    popMatrix();
    //柱
    pushMatrix();
    fill(200);
    scale(s);
    translate(x + 1.25*d, .03 + .2, z + 1.25*d);
    drawBox(.3*d, .4, .3*d, 4);
    popMatrix(); 
    pushMatrix();
    fill(200);
    scale(s);
    translate(x - 1.25*d, .03 + .2, z - 1.25*d);
    drawBox(.3*d, .4, .3*d, 4);
    popMatrix(); 
    pushMatrix();
    fill(200);
    scale(s);
    translate(x + 1.25*d, .03 + .2, z - 1.25*d);
    drawBox(.3*d, .4, .3*d, 4);
    popMatrix();
    pushMatrix();
    fill(200);
    scale(s);
    translate(x - 1.25*d, .03 + .2, z + 1.25*d);
    drawBox(.3*d, .4, .3*d, 4);
    popMatrix();
    //側面
    pushMatrix();
    fill(200);
    scale(s);
    translate(x + 1.25*d, .03 + .2, z);
    drawBox(.02, .03, 2.8*d, 4);
    popMatrix();
    pushMatrix();
    fill(200);
    scale(s);
    translate(x + 1.25*d + .04, .03 + .2, z);
    drawBox(.05, .4, .1, 4);
    popMatrix();
    pushMatrix();
    fill(200);
    scale(s);
    translate(x - 1.25*d, .03 + .2 - .1, z);
    drawBox(.02, .2, 2.8*d, 4);
    popMatrix();
    pushMatrix();
    fill(200);
    scale(s);
    translate(x - 1.25*d - .04, .03 + .2, z);
    drawBox(.05, .4, .1, 4);
    popMatrix();
    pushMatrix();
    fill(200);
    scale(s);
    translate(x, .03 + .1, z - 1.25*d);
    drawBox(2.8*d, .2, .02, 4);
    popMatrix();
    //ガレージ
    pushMatrix();
    fill(200);
    scale(s);
    translate(x - 3*d/7, .03 + .1, z + 1.25*d);
    drawBox(4*d/3, .2, .02, 4);
    popMatrix();
    //ドア
    pushMatrix();
    fill(200);
    scale(s);
    translate(x + 3*d/10, 0.25, z + 1.25*d);
    drawBox(.04, .38, .1, 4);
    popMatrix();
    pushMatrix();
    fill(200);
    scale(s);
    translate(x + 1.01*d, 0.25, z + 1.25*d);
    drawBox(.04, .38, .1, 4);
    popMatrix();
    pushMatrix();
    fill(200);
    scale(s);
    translate(x + .8*d, .25, z + 1.25*d);
    drawBox(.02, .38, .02, 4);
    popMatrix();
    //玄関
    pushMatrix();
    fill(200);
    scale(s);
    translate(x + .65*d, .015, z + 1.7*d);
    drawBox(.2, .03, .1, 4);
    popMatrix(); 
}

//六角柱の描画
void drawHexagonalPrism(float a, float h) {
    pushMatrix();
    beginShape(QUADS);
    //三角柱を6回繰り返すイメージ
    for(int i=0; i<6; i++){
        //上面
        vertex(0, h/2, 0);vertex(a*cos(radians(60*i)), h/2, a*sin(radians(60*i)));
        vertex(a*cos(radians(60*i)), h/2, a*sin(radians(60*i)));vertex(a*cos(radians(60*(i + 1))), h/2, a*sin(radians(60*(i + 1))));
        vertex(a*cos(radians(60*(i + 1))), h/2, a*sin(radians(60*(i + 1))));vertex(0, h/2, 0);
        //側面
        vertex(a*cos(radians(60*i)), h/2, a*sin(radians(60*i)));vertex(a*cos(radians(60*i)), -h/2, a*sin(radians(60*i)));
        vertex(a*cos(radians(60*i)), -h/2, a*sin(radians(60*i)));vertex(a*cos(radians(60*(i + 1))), -h/2, a*sin(radians(60*(i + 1))));
        vertex(a*cos(radians(60*(i + 1))), -h/2, a*sin(radians(60*(i + 1))));vertex(a*cos(radians(60*(i + 1))), h/2, a*sin(radians(60*(i + 1))));
        vertex(a*cos(radians(60*(i + 1))), h/2, a*sin(radians(60*(i + 1))));vertex(a*cos(radians(60*i)), h/2, a*sin(radians(60*i)));
        //底面
        vertex(0, -h/2, 0);vertex(a*cos(radians(60*i)), -h/2, a*sin(radians(60*i)));
        vertex(a*cos(radians(60*i)), -h/2, a*sin(radians(60*i)));vertex(a*cos(radians(60*(i + 1))), -h/2, a*sin(radians(60*(i + 1))));
        vertex(a*cos(radians(60*(i + 1))), -h/2, a*sin(radians(60*(i + 1))));vertex(0, -h/2, 0);
    }
    endShape();
    popMatrix();
}

//管制塔
void drawLightHouse(float s, float x, float z) {
    //土台
    pushMatrix();
    fill(200);
    scale(s);
    translate(x, .03, z);
    drawBox(1, .06, .5, 4);
    popMatrix();
    pushMatrix();
    fill(128);
    if(night) emissive(255, 245, 102);
    scale(s);
    translate(x, .06 + .125, z);
    drawBox(.8, .25, .4, 4);
    popMatrix();
    pushMatrix();
    fill(200);
    emissive(0);
    scale(s);
    translate(x, .06 + .25 + .03, z);
    drawBox(1, .06, .5, 4);
    popMatrix();
    //窓とか
    pushMatrix();
    fill(200);
    scale(s);
    translate(x + .4 - .02 + .16, .06 + .125, z);
    for(int i=0; i<6; i++){
        translate(-.16, 0, 0);
        drawBox(.06, .25, .5, 4);
    }
    popMatrix();
    pushMatrix();
    fill(200);
    scale(s);
    translate(x, .06 + .125, z);
    drawBox(.8, .04, .5, 4);
    popMatrix();
    //柱
    pushMatrix();
    scale(s);
    translate(x - .25, .06 + .25 + .06 + .01, z);
    drawBox(.35, .02, .35, 4);
    popMatrix();
    pushMatrix();
    scale(s);
    translate(x - .25, .06 + .25 + .06 + .02 + .125, z);
    drawHexagonalPrism(.1, .25);
    popMatrix();
    //主部
    pushMatrix();
    scale(s);
    translate(x - .25, .06 + .25 + .06 + .02 + .25 + .07, z);
    drawHexagonalPrism(.17, .14);
    popMatrix();
    pushMatrix();
    fill(128);
    if(night) emissive(255, 245, 102);
    scale(s);
    translate(x - .25, .06 + .25 + .06 + .02 + .25 + .14 + .03, z);
    drawHexagonalPrism(.15, .06);
    popMatrix();
    pushMatrix();
    emissive(0);
    fill(200);
    scale(s);
    translate(x - .25, .06 + .25 + .06 + .02 + .25 + .14 + .06 + .03, z);
    drawHexagonalPrism(.2, .06);
    popMatrix();
    pushMatrix();
    fill(200);
    scale(s);
    translate(x - .25, .06 + .25 + .06 + .02 + .25 + .14 + .06 + .06 + .02, z);
    drawHexagonalPrism(.1, .04);
    popMatrix();
    //上のアンテナ
    pushMatrix();
    fill(128);
    scale(s);
    translate(x - .25, .06 + .25 + .06 + .02 + .25 + .14 + .06 + .06 + .04 + .04, z);
    drawBox(.01, .08, .01, 4);
    popMatrix();
    for(int i=0; i<8; i++){
        pushMatrix();
        fill(128);
        scale(s);
        translate(x - .25 + .06*cos(PI*i/4), .06 + .25 + .06 + .02 + .25 + .14 + .06 + .06 + .04 + .03, z + .06*sin(PI*i/4));
        drawBox(.01, .06, .01, 4);
        popMatrix();  
    }
}

//パンタグラフ
void pantograph() {
    float length = .44721359549995794;
    fill(128);
    //ひし形(手前)
    pushMatrix();
    scale(.5);
    translate(0, 0, .1);
    //ひし形
    pushMatrix();
    translate(-.2, -.1, 0);
    rotateZ(-PI/6);
    drawBox(length, .03, .03, 4);
    popMatrix();
    pushMatrix();
    translate(-.2, .1, 0);
    rotateZ(PI/6);
    drawBox(length, .03, .03, 4);
    popMatrix();
    pushMatrix();
    translate(.2, -.1, 0);
    rotateZ(PI/6);
    drawBox(length, .03, .03, 4);
    popMatrix();
    pushMatrix();
    translate(.2, .1, 0);
    rotateZ(-PI/6);
    drawBox(length, .03, .03, 4);
    popMatrix();
    popMatrix();
    //ひし形(奥)
    pushMatrix();
    scale(.5);
    translate(0, 0, -.1);
    //ひし形
    pushMatrix();
    translate(-.2, -.1, 0);
    rotateZ(-PI/6);
    drawBox(length, .03, .03, 4);
    popMatrix();
    pushMatrix();
    translate(-.2, .1, 0);
    rotateZ(PI/6);
    drawBox(length, .03, .03, 4);
    popMatrix();
    pushMatrix();
    translate(.2, -.1, 0);
    rotateZ(PI/6);
    drawBox(length, .03, .03, 4);
    popMatrix();
    pushMatrix();
    translate(.2, .1, 0);
    rotateZ(-PI/6);
    drawBox(length, .03, .03, 4);
    popMatrix();
    popMatrix();
    //つなぎ
    pushMatrix();
    scale(.5);
    pushMatrix();
    translate(-.4, 0, 0);
    drawBox(.03, .03, .2, 4);
    popMatrix();
    pushMatrix();
    translate(.4, 0, 0);
    drawBox(.03, .03, .2, 4);
    popMatrix();
    pushMatrix();
    translate(0, .2, 0);
    drawBox(.03, .03, .5, 4);
    popMatrix();
    popMatrix();
}

//電車の車輪
void wheel(float x, float z){
    //後輪
    pushMatrix();
    translate(-.5, 0, .2);
    pillar(.02, .075, .075);
    popMatrix();
    pushMatrix();
    translate(-.3, 0, .2);
    pillar(.02, .075, .075);
    popMatrix();
    //後輪
    pushMatrix();
    translate(-.5, 0, -.2);
    pillar(.02, .075, .075);
    popMatrix();
    pushMatrix();
    translate(-.3, 0, -.2);
    pillar(.02, .075, .075);
    popMatrix();
    //前輪
    pushMatrix();
    translate(.5, 0, .2);
    pillar(.02, .075, .075);
    popMatrix();
    pushMatrix();
    translate(.3, 0, .2);
    pillar(.02, .075, .075);
    popMatrix();
    //前輪
    pushMatrix();
    translate(.5, 0, -.2);
    pillar(.02, .075, .075);
    popMatrix();
    pushMatrix();
    translate(.3, 0, -.2);
    pillar(.02, .075, .075);
    popMatrix();
}

//電車専用box(texture)
void drawTrainBox(float s, float h, float d, boolean flont){
    if(flont){
        //正面
        beginShape(QUADS);
        texture(imgTrainFront);
        textureMode(NORMAL);
        vertex(s/2, h/2, -d/2, .2, .1);vertex(s/2, -h/2, -d/2, .2, 1);vertex(s/2, -h/2, d/2, .8, 1);vertex(s/2, h/2, d/2, .8, .1);
        endShape();

        //側面
        beginShape(QUADS);
        texture(imgTrainSide);
        textureMode(NORMAL);
        vertex(-s/2, h/2, -d/2, .05, .1);vertex(-s/2, -h/2, -d/2, .05, .9);vertex(s/2, -h/2, -d/2, .9, .9);vertex(s/2, h/2, -d/2, .9, .1);
        vertex(s/2, h/2, d/2, .05, .1);vertex(s/2, -h/2, d/2, .05, .9);vertex(-s/2, -h/2, d/2, .9, .9);vertex(-s/2, h/2, d/2, .9, .1);
        endShape();

        //上面
        beginShape(QUADS);
        fill(200);
        vertex(-s/2, h/2, d/2, 0, 0);vertex(-s/2, h/2, -d/2, 0, 1);vertex(s/2, h/2, -d/2, 1, 1);vertex(s/2, h/2, d/2, 1, 0);
        vertex(-s/2, -h/2, -d/2, 0, 0);vertex(-s/2, -h/2, d/2, 0, 1);vertex(s/2, -h/2, d/2, 1, 1);vertex(s/2, -h/2, -d/2, 1, 0);
        endShape();

        //背面
        beginShape(QUADS);
        fill(200);
        vertex(-s/2, h/2, d/2, 0, 0);vertex(-s/2, -h/2, d/2, 0, 1);vertex(-s/2, -h/2, -d/2, 1, 1);vertex(-s/2, h/2, -d/2, 1, 0);
        endShape();
    } else {
        //背面
        beginShape(QUADS);
        fill(200);
        vertex(s/2, h/2, -d/2, 0, 0);vertex(s/2, -h/2, -d/2, 0, 1);vertex(s/2, -h/2, d/2, 1, 1);vertex(s/2, h/2, d/2, 1, .1);
        endShape();

        //側面
        beginShape(QUADS);
        texture(imgTrainSide);
        textureMode(NORMAL);
        vertex(-s/2, h/2, -d/2, .05, .1);vertex(-s/2, -h/2, -d/2, .05, .9);vertex(s/2, -h/2, -d/2, .9, .9);vertex(s/2, h/2, -d/2, .9, .1);
        vertex(s/2, h/2, d/2, .05, .1);vertex(s/2, -h/2, d/2, .05, .9);vertex(-s/2, -h/2, d/2, .9, .9);vertex(-s/2, h/2, d/2, .9, .1);
        endShape();

        //上面
        beginShape(QUADS);
        fill(200);
        vertex(-s/2, h/2, d/2, 0, 0);vertex(-s/2, h/2, -d/2, 0, 1);vertex(s/2, h/2, -d/2, 1, 1);vertex(s/2, h/2, d/2, 1, 0);
        vertex(-s/2, -h/2, -d/2, 0, 0);vertex(-s/2, -h/2, d/2, 0, 1);vertex(s/2, -h/2, d/2, 1, 1);vertex(s/2, -h/2, -d/2, 1, 0);
        endShape();

        //正面
        beginShape(QUADS);
        texture(imgTrainFront);
        textureMode(NORMAL);
        vertex(-s/2, h/2, d/2, .2, .1);vertex(-s/2, -h/2, d/2, .2, 1);vertex(-s/2, -h/2, -d/2, .8, 1);vertex(-s/2, h/2, -d/2, .8, .1);
        endShape();
    }
}

//電車
void drawTrain(float s, float x, float z, float rot, boolean dir) {
    pushMatrix();
    if(night) emissive(100, 100, 100);
    fill(200);
    scale(s);
    translate(x, .35, z);
    rotateY(PI/2);
    rotateY(rot*PI/180);
    drawTrainBox(1.3, .55, .55, dir);
    popMatrix();
    //胴体上
    pushMatrix();
    scale(s);
    translate(x, .655, z);
    rotateY(PI/2);
    rotateY(rot*PI/180);
    translate(.25, 0, 0);
    drawBox(.3, .06, .4, 4);
    popMatrix();
    pushMatrix();
    scale(s);
    translate(x, .655, z);
    rotateY(PI/2);
    rotateY(rot*PI/180);
    translate(-.25, 0, 0);
    drawBox(.3, .06, .4, 4);
    popMatrix();
    //パンタグラフ
    pushMatrix();
    scale(s);
    translate(x, .655 + .03 + .1, z);
    rotateY(PI/2);
    rotateY(rot*PI/180);
    translate(.25, 0, 0);
    pantograph();
    popMatrix();
    pushMatrix();
    scale(s);
    translate(x, .655 + .03 + .1, z);
    rotateY(PI/2);
    rotateY(rot*PI/180);
    translate(-.25, 0, 0);
    pantograph();
    popMatrix();
    //車輪
    pushMatrix();
    fill(128);
    scale(s);
    translate(x, .075, z);
    rotateY(PI/2);
    rotateY(rot*PI/180);
    wheel(x, z);
    popMatrix();
    emissive(0);
}

//線路と電線
void drawRailroad(float R1, float R2, float y){
    pushMatrix();
    strokeWeight(5);
    for(float j = 0; j < 360; j++) {
        //輪
        stroke(115, 66, 41);
        line(R1 * cos(j), y, R1 * sin(j), R1*cos(j + .1), y,  R1 * sin(j + .1));
        line(R2 * cos(j), y, R2 * sin(j), R2*cos(j + .1), y,  R2 * sin(j + .1));
        strokeWeight(7);
        //縦線
        line((R1-5) * cos(10*j), y, (R1-5) * sin(10*j), (R2+5)*cos(10*j), y,  (R2+5) * sin(10*j));
        //電線
        stroke(100);
        strokeWeight(3);
        line(((R1+R2)/2) * cos(j), y + 68, ((R1+R2)/2) * sin(j), ((R1+R2)/2)*cos(j + .1), y + 68,  ((R1+R2)/2) * sin(j + .1));
        strokeWeight(5);
    }
    strokeWeight(1);
    noStroke();
    popMatrix();
}

//鉄道柵
void drawFence(float r){
    fill(200);
    for(int i = 0; 3*i<360; i++){
        pushMatrix();
        translate(r*cos(radians(3*i)), 15, r*sin(radians(3*i)));
        rotateY(radians(-3*i + 90));
        drawBox(5, 30, 5, 4);
        translate(0, 6, 0);
        drawBox(15, 6, 2, 4);
        translate(0, -16, 0);
        drawBox(15, 6, 2, 4);
        popMatrix();
    }
}

//街頭
void drawLight(float r){
    for(int i = 0; 60*i<360; i++){
        pushMatrix();
        emissive(0);
        fill(128);
        translate(r*cos(radians(60*i)), 40, r*sin(radians(60*i)));
        rotateY(radians(-60*i));
        rotateX(PI/2);
        pillar(80, 3, 3);
        popMatrix();
        pushMatrix();
        translate(r*cos(radians(60*i)), 88, r*sin(radians(60*i)));
        if(night) emissive(242, 242, 176);
        fill(200, 200, 200);
        sphere(8);
        popMatrix();
    }
    emissive(0);
}

void draw(){
    if(!night){
        //昼
        background(154, 217, 246);
        lights();
        pointLight(255, 255, 255, 300 * cos(-rad*PI/450), 30, 400 * sin(-rad*PI/450));
    }
    else {
        //夜
        background(0, 0, 48);
        pointLight(200, 200, 200, 300 * cos(-rad*PI/450), 80, 400 * sin(-rad*PI/450));
        spotLight(220, 220, 255, 0, 150, 0, 0, -1, 0, PI/2, 800);
    }
    float cameraX = map(mouseX, 0, width, 400, -200);
    float cameraY = map(mouseY, 0, height, 400, -200);
    float x1, z1, x2, z2, x3, z3, radius1 = 3, radius2 = 5.8;
    //カメラワーク(回転)
    camera(400 * cos(-rad*PI/450), cameraY, 400 * sin(-rad*PI/450), 0, 0, 0, 0, -1, 0);
    //カメラワーク(固定)
    //camera(cameraX, cameraY, 400, 0, 0, 0, 0, -1, 0);
    pushMatrix();
    //drawAxis('X', color(255, 0, 0, 60)); 
    //drawAxis('Y', color(0, 255, 0, 60));
    //drawAxis('Z', color(0, 0, 255, 60));
    x1 = radius1 * cos(radians(-rad));
    z1 = radius1 * sin(radians(-rad));
    x2 = radius2 * cos(radians(-rad4));
    z2 = radius2 * sin(radians(-rad4));
    x3 = radius1 * cos(radians(-rad2));
    z3 = radius1 * sin(radians(-rad2));
    pushMatrix();
    translate(0, -5, 0);
    rotateX(PI/2);
    //線路の砂利
    fill(239, 205, 154);
    pillar(1, 265, 265);
    //建物置く地面
    if(night) emissive(0, 53, 103);
    fill(93, 135, 183);
    pillar(10.3, 190, 190);
    popMatrix();
    emissive(0);
    /*オブジェクト*/
    //観覧車
    drawFerrisWheel(1.5, 0, 0);
    //コンビニ
    pushMatrix();
    rotateY(PI/5);
    drawConv(70, .12, 1.);
    popMatrix();
    //テラス
    pushMatrix();
    rotateY(-PI/8);
    drawTerrace(70, 0, 1.4);
    popMatrix();
    //駅
    pushMatrix();
    rotateY(-2*PI/5 + PI + PI/9);
    drawStation(90, 0, 1);
    popMatrix();
    //管制塔
    pushMatrix();
    rotateY(PI/6);
    drawLightHouse(70, .0, -1.4);
    popMatrix();
    //立派な家
    pushMatrix();
    rotateY(-PI/2);
    drawLargeHouse(65, .0, 1.3);
    popMatrix();
    //木々
    pushMatrix();
    drawTree(40, 2.6, .2);
    drawTree(40, .3, -2.6);
    popMatrix();
    //電車
    drawTrain(50, x1, z1, rad, false);
    drawTrain(50, x3, z3, rad2, true);
    popMatrix();
    //線路
    drawRailroad(215, 240, .0);
    //鉄道柵
    drawFence(260);
    //街頭
    drawLight(270);
    pushMatrix();
    //道路
    fill(118);
    translate(0, -9.55, 0);
    rotateX(PI/2);
    pillar(10, 330, 330);
    popMatrix();
    //車
    drawCar(52, x2, z2, 255, 254, 59, true);
    //電車(先頭)の速度
    rad++;
    //電車(後ろ)の速度
    rad2++;
    //観覧車の速度
    rad3 += speed;
    //車の速度
    rad4 += .5;
} 