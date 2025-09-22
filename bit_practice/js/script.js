const colorPicker = document.querySelector("#colorPicker");
const colorText = document.querySelector("#colorText");
const pickingBackgroundColor = document.querySelector(".picking");
const colorBitRed = document.querySelector("#colorBitRed");
const colorBitBlue = document.querySelector("#colorBitBlue");
const colorBitGreen = document.querySelector("#colorBitGreen");

colorPicker.addEventListener("input", () => {
    let hexToBinary = colorPicker.value.substr(1);
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
    console.log(maskBin);
    const maskRed = maskBin.slice(0, 8);
    const maskBlue = maskBin.slice(8, 16);
    const maskGreen = maskBin.slice(16, 24);
    console.log(maskRed);
    console.log(maskBlue);
    console.log(maskGreen);
    maskBitRed.textContent = maskRed;
    maskBitBlue.textContent = maskBlue;
    maskBitGreen.textContent = maskGreen;
});