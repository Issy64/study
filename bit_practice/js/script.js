const colorPicker = document.querySelector("#colorPicker");
const colorText = document.querySelector("#colorText");
const pickingBackgroundColor = document.querySelector(".picking");
// console.log("test");

// colorText.textContent = "change example";
// console.log(colorPicker.value);
// colorText.textContent = colorPicker.value;

colorPicker.addEventListener("input", () => {
    // console.log(colorPicker.value);
    let hexToBinary = 0;
    hexToBinary = colorPicker.value;
    hexToBinary = hexToBinary.substr(1);
    // console.log(parseInt(hexToBinary, 16));
    hexToBinary = parseInt(hexToBinary,16).toString(2);
    console.log(hexToBinary);

    // const binaryRed = ((hexToBinary >> 16) & 0xff);
    // console.log(binaryRed);

    colorText.textContent = hexToBinary;
    pickingBackgroundColor.style.backgroundColor = colorPicker.value;
});