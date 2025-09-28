//リファクタリング① => 繰り返し使ってる煩雑な数値変換は関数にまとめてスッキリ見せる

const colorPicker = document.querySelector("#colorPicker");
const colorPickBin = document.querySelector("#colorPickBin");
const colorPickHex = document.querySelector("#colorPickHex");
const pickingBackgroundColor = document.querySelector(".picking");
const colorBitRed = document.querySelector("#colorBitRed");
const colorBitGreen = document.querySelector("#colorBitGreen");
const colorBitBlue = document.querySelector("#colorBitBlue");

const colorPickerAction = () => {
    //カラーコードの値から#を抜き出して取得する
    const colorHex = colorPicker.value.substr(1);
    //取得したカラーコードの16進数文字列を2進数文字列に変換する。
    //24bitのままだと桁ズレが怖いので8bitずつ処理する。
    //関数化して役割を切り分ける
    const hexToBinary = (hex, sliceStart, sliceEnd) => {
        const hSlice = hex.slice(sliceStart, sliceEnd);//16進数を指定ビットで切り取る
        const htb = parseInt(hSlice, 16).toString(2);//16進数文字列 -> int型 -> 2進数文字列
        return htb.padStart(8, "0");//2進数文字列を8bit表示を保証して返す
    };

    const redBitBin = hexToBinary(colorHex, 0, 2);
    const greenBitBin = hexToBinary(colorHex, 2, 4);
    const blueBitBin = hexToBinary(colorHex, 4, 6);
    // console.log(redBitBin);
    // console.log(blueBitBin);
    // console.log(greenBitBin);
    const colorBitBin = redBitBin + " " + greenBitBin + " " + blueBitBin;

    colorPickBin.textContent = colorBitBin;
    colorPickHex.textContent = colorPicker.value;
    pickingBackgroundColor.style.backgroundColor = colorPicker.value;

    colorBitRed.textContent = redBitBin;
    colorBitGreen.textContent = greenBitBin;
    colorBitBlue.textContent = blueBitBin;
};

colorPicker.addEventListener("input", colorPickerAction);

const inputMask = document.querySelector("#inputMask");
const maskBitRed = document.querySelector("#maskBitRed");
const maskBitGreen = document.querySelector("#maskBitGreen");
const maskBitBlue = document.querySelector("#maskBitBlue");


const maskBitAction = () => {
    const maskBin = inputMask.value;
    // console.log(maskBin);
    const maskRed = maskBin.slice(0, 8);
    const maskGreen = maskBin.slice(8, 16);
    const maskBlue = maskBin.slice(16, 24);
    // console.log(maskRed);
    // console.log(maskBlue);
    // console.log(maskGreen);
    maskBitRed.textContent = maskRed;
    maskBitGreen.textContent = maskGreen;
    maskBitBlue.textContent = maskBlue;
};

inputMask.addEventListener("input", maskBitAction);

const bitCalcs = document.querySelectorAll(".bitCalcs");
const bitAnd = document.querySelector("#and");
const bitOR = document.querySelector("#or");
const bitNot = document.querySelector("#not");
const bitXor = document.querySelector("#xor");
const resultBitRed = document.querySelector("#maskedBitRed");
const resultBitGreen = document.querySelector("#maskedBitGreen");
const resultBitBlue = document.querySelector("#maskedBitBlue");
const resultBitBin = document.querySelector("#maskedBitBin");
const resultBitHex = document.querySelector("#maskedBitHex");
const bgColor = document.querySelector("#bgColor");
const result = document.querySelector(".result");

bitCalcs.forEach(function (bitCalc) {
    bitCalc.addEventListener("click", (events) => {
        // console.log("push!");
        let r = "";
        let g = "";
        let b = "";

        const andCalc = (a, b) => {
            const ac = parseInt(a, 2) & parseInt(b, 2);//両ビットパターンもnumber型に変換してAND演算
            return ac.toString(2).padStart(8, "0");//8bitの出力を保証して返す
        };
        const orCalc = (a, b) => {
            const oc = parseInt(a, 2) | parseInt(b, 2);
            return oc.toString(2).padStart(8, "0");
        };
        const xorCalc = (a, b) => {
            const xc = parseInt(a, 2) ^ parseInt(b, 2);
            return xc.toString(2).padStart(8, "0");
        };
        const notCalc = (a) => {
            const bi = BigInt("0b" + a);//BigIntで2進数文字列を読み込む
            const nbi = ~bi & ((1n << BigInt(8)) - 1n);//読み込んだ数値を反転し、符号ビットを無視するため、11111111でAND処理
            return nbi.toString(2).padStart(8, "0");
        };

        switch (events.target.id) {
            case "and":
                // console.log(colorBitRed.textContent);
                // console.log(maskBitRed.textContent);
                // Red bit
                r = andCalc(colorBitRed.textContent, maskBitRed.textContent);
                // Green bit
                g = andCalc(colorBitGreen.textContent, maskBitGreen.textContent);
                // Blue bit
                b = andCalc(colorBitBlue.textContent, maskBitBlue.textContent);
                break;
            case "or":
                // Red bit
                r = orCalc(colorBitRed.textContent, maskBitRed.textContent);
                // Green bit
                g = orCalc(colorBitGreen.textContent, maskBitGreen.textContent);
                // Blue bit
                b = orCalc(colorBitBlue.textContent, maskBitBlue.textContent);
                break;
            case "not":
                // Red bit
                r = notCalc(colorBitRed.textContent);
                // Green bit
                g = notCalc(colorBitGreen.textContent);
                // Blue bit
                b = notCalc(colorBitBlue.textContent);
                break;
            case "xor":
                // Red bit
                r = xorCalc(colorBitRed.textContent, maskBitRed.textContent);
                // Green bit
                g = xorCalc(colorBitGreen.textContent, maskBitGreen.textContent);
                // Blue bit
                b = xorCalc(colorBitBlue.textContent, maskBitBlue.textContent);
                break;
            default:
                console.log("I have no idea...");
        };
        resultBitRed.textContent = r;
        resultBitGreen.textContent = g;
        resultBitBlue.textContent = b;

        resultBitBin.textContent = r + g + b;
        const bthRed = parseInt(r, 2).toString(16).padStart(2, "0");
        const bthGreen = parseInt(g, 2).toString(16).padStart(2, "0");
        const bthBlue = parseInt(b, 2).toString(16).padStart(2, "0");
        const bth = "#" + bthRed + bthGreen + bthBlue;
        // console.log(bth);
        resultBitHex.textContent = bth;
        result.style.backgroundColor = bth;
    });
});

window.addEventListener("load", () => {
    colorPickerAction();
    maskBitAction();
});