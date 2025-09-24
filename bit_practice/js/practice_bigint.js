const numA = 255;
const numB = -255;
const numC = 15;
const biNumA = BigInt(numA);
const biNumB = BigInt(numB);
const biNumC = BigInt(numC);

console.log(numA);
console.log(numB);
console.log(biNumA);
console.log(biNumB);

// Number型と混在できない
// console.log(biNumA - 1);
console.log(biNumA - 1n);


// BigIntに文字列が渡されても数値として認識してもらえる。
// ただし、整数リテラル表現であることが条件
console.log(BigInt("0b1111")); //15n
//BigInt("0b" + 2進ビット列)で2進数を扱う事ができる。
const bitNum = "1010";
const biBitNum = BigInt("0b" + bitNum);
console.log(biBitNum); //出力は10n、0b1010
console.log(~biBitNum); //0b0101にしたつもり、出力は-11n
// 11は0b1011、2の補数にすると0100 + 1 -> 0101(-11n)
console.log(~biBitNum.toString(2)); //-1011
const biBitNumA = ~biBitNum + 1n;
console.log(biBitNumA.toString(2)); //-1010
//だいぶカオスになってきた。。。

//符号ビットを無視したいので数値部分だけビットマスクする
const biBitNumB = ~biBitNum & BigInt("0b1111");
console.log(biBitNumB.toString(2)); //101になった！
//4桁のビット数を保証するpadstartを付け加えると
console.log(biBitNumB.toString(2).padStart(4, "0")); //0101になった！

//これまでの内容を整理して8bitで作る
const n = "11001010"; //NOTしたい2進数
const a = BigInt("0b" + n); //BigInt化
const b = ~a & BigInt("0b11111111"); //反転して符号ビット無視
console.log(n);
console.log(b.toString(2).padStart(8, "0"));


//((1n << BigInt(8)) - 1n)は算術的に11111111を作りたかった？
console.log((1n << BigInt(8)).toString(2)); //100000000
console.log(((1n << BigInt(8)) - 1n).toString(2)); //11111111

//NOT演算ではそのまま「~」で演算しようとするとビット反転時にマイナス扱いにされてしまう。
//それでは意図したビット反転の論理演算にならないので、
//ビット反転時に必要ビット数分だけマスクすることで符号ビットを無視するようにする。