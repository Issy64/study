const colorPicker = document.querySelector("#colorPicker");
const colorText = document.querySelector("#colorText");
const pickingBackgroundColor = document.querySelector(".picking");
const colorBitRed = document.querySelector("#colorBitRed");
const colorBitBlue = document.querySelector("#colorBitBlue");
const colorBitGreen = document.querySelector("#colorBitGreen");

colorPicker.addEventListener("input", () => {
    const hexToBinary = colorPicker.value.substr(1);
    //取得したカラーコードの16進数文字列を2進数文字列に変換する。
    //24bitのままだと桁ズレが怖いので8bitずつ処理する。
    //もう少し簡単な記述はなかったものか…
    const redBitBin = parseInt(hexToBinary.slice(0, 2), 16).toString(2).padStart(8, "0");
    const blueBitBin = parseInt(hexToBinary.slice(2, 4), 16).toString(2).padStart(8, "0");
    const greenBitBin = parseInt(hexToBinary.slice(4, 6), 16).toString(2).padStart(8, "0");
    // console.log(redBitBin);
    // console.log(blueBitBin);
    // console.log(greenBitBin);
    const colorBitBin = redBitBin + " " + blueBitBin + " " + greenBitBin;

    colorText.textContent = colorBitBin;
    pickingBackgroundColor.style.backgroundColor = colorPicker.value;

    colorBitRed.textContent = redBitBin;
    colorBitBlue.textContent = blueBitBin;
    colorBitGreen.textContent = greenBitBin;
});

const inputMask = document.querySelector("#inputMask");
const maskBitRed = document.querySelector("#maskBitRed");
const maskBitBlue = document.querySelector("#maskBitBlue");
const maskBitGreen = document.querySelector("#maskBitGreen");

inputMask.addEventListener("input", () => {
    const maskBin = inputMask.value;
    // console.log(maskBin);
    const maskRed = maskBin.slice(0, 8);
    const maskBlue = maskBin.slice(8, 16);
    const maskGreen = maskBin.slice(16, 24);
    // console.log(maskRed);
    // console.log(maskBlue);
    // console.log(maskGreen);
    maskBitRed.textContent = maskRed;
    maskBitBlue.textContent = maskBlue;
    maskBitGreen.textContent = maskGreen;
});

const bitCalcs = document.querySelectorAll(".bitCalcs");
const bitAnd = document.querySelector("#and");
const bitOR = document.querySelector("#or");
const bitNot = document.querySelector("#not");
const bitXor = document.querySelector("#xor");
const resultBitRed = document.querySelector("#maskedBitRed");
const resultBitBlue = document.querySelector("#maskedBitBlue");
const resultBitGreen = document.querySelector("#maskedBitGreen");
const resultBit = document.querySelector("#maskedBit");
const bgColor = document.querySelector("#bgColor");

bitCalcs.forEach(function (bitCalc) {
    bitCalc.addEventListener("click", (events) => {
        // console.log("push!");
        let r = "";
        let b = "";
        let g = "";
        switch (events.target.id) {
            case "and":
                // console.log(colorBitRed.textContent);
                // console.log(maskBitRed.textContent);
                // Red bit
                const resultAndRed = parseInt(colorBitRed.textContent, 2) & parseInt(maskBitRed.textContent, 2);
                r = resultAndRed.toString(2).padStart(8, "0");
                // Blue bit
                const resultAndBlue = parseInt(colorBitBlue.textContent, 2) & parseInt(maskBitBlue.textContent, 2);
                b = resultAndBlue.toString(2).padStart(8, "0");
                // Green bit
                const resultAndGreen = parseInt(colorBitGreen.textContent, 2) & parseInt(maskBitGreen.textContent, 2);
                g = resultAndGreen.toString(2).padStart(8, "0");
                break;
            case "or":
                // Red bit
                const resultOrRed = parseInt(colorBitRed.textContent, 2) | parseInt(maskBitRed.textContent, 2);
                r = resultOrRed.toString(2).padStart(8, "0");
                // Blue bit
                const resultOrBlue = parseInt(colorBitBlue.textContent, 2) | parseInt(maskBitBlue.textContent, 2);
                b = resultOrBlue.toString(2).padStart(8, "0");
                // Green bit
                const resultOrGreen = parseInt(colorBitGreen.textContent, 2) | parseInt(maskBitGreen.textContent, 2);
                g = resultOrGreen.toString(2).padStart(8, "0");
                break;
            case "not":
                // Red bit
                //ここの記述は再度理解のため要検証
                const sRedBig = BigInt("0b" + colorBitRed.textContent);
                const tRedBig = ~sRedBig & ((1n << BigInt(8)) - 1n);
                const resultNotRed = tRedBig.toString(2).padStart(8, "0");
                r = resultNotRed;
                // Blue bit
                const sBlueBig = BigInt("0b" + colorBitBlue.textContent);
                const tBlueBig = ~sBlueBig & ((1n << BigInt(8)) - 1n);
                const resultNotBlue = tBlueBig.toString(2).padStart(8, "0");
                b = resultNotBlue;
                // Green bit
                const sGreenBig = BigInt("0b" + colorBitGreen.textContent);
                const tGreenBig = ~sGreenBig & ((1n << BigInt(8)) - 1n);
                const resultNotGreen = tGreenBig.toString(2).padStart(8, "0");
                g = resultNotGreen;
                break;
            case "xor":
                // Red bit
                const resultXorRed = parseInt(colorBitRed.textContent, 2) ^ parseInt(maskBitRed.textContent, 2);
                r = resultXorRed.toString(2).padStart(8, "0");
                // Blue bit
                const resultXorBlue = parseInt(colorBitBlue.textContent, 2) ^ parseInt(maskBitBlue.textContent, 2);
                b = resultXorBlue.toString(2).padStart(8, "0");
                // Green bit
                const resultXorGreen = parseInt(colorBitGreen.textContent, 2) ^ parseInt(maskBitGreen.textContent, 2);
                g = resultXorGreen.toString(2).padStart(8, "0");
                break;
            default:
                console.log("I have no idea...");
        };
        resultBitRed.textContent = r;
        resultBitBlue.textContent = b;
        resultBitGreen.textContent = g;

        resultBit.textContent = r + b + g;
        const bthRed = parseInt(r,2).toString(16).padStart(2,"0");
        const bthBlue = parseInt(b,2).toString(16).padStart(2,"0");
        const bthGreen = parseInt(g,2).toString(16).padStart(2,"0");
        const bth = "#"+bthRed+bthBlue+bthGreen;
        // console.log(bth);
        bgColor.style.backgroundColor = bth;
        bgColor.style.fontColor = "#cfcfcf"
    });
});

