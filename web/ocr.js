// // // // window.extractTextFromImage = function (imageData) {
// // // //   return Tesseract.recognize(
// // // //     imageData,
// // // //     "eng"
// // // //   ).then(({ data }) => {
// // // //     return data.text;
// // // //   });
// // // // };





// // // // Tesseract v5 compatible (NO worker.load)

// // // let worker = null;
// // // let isReady = false;

// // // async function getWorker() {
// // //   if (!worker) {
// // //     worker = await Tesseract.createWorker({
// // //       logger: m => console.log(m),
// // //     });
// // //   }
// // //   if (!isReady) {
// // //     await worker.loadLanguage('eng');
// // //     await worker.initialize('eng');
// // //     isReady = true;
// // //   }
// // //   return worker;
// // // }

// // // window.extractTextFromImage = async function (imageData) {
// // //   const w = await getWorker();
// // //   const { data } = await w.recognize(imageData);
// // //   return data.text;
// // // };










// // window.extractTextFromImage = async function (imageData) {
// //   if (!imageData) {
// //     return "";
// //   }

// //   const result = await Tesseract.recognize(
// //     imageData,
// //     'eng'
// //   );

// //   return result.data && result.data.text
// //     ? result.data.text
// //     : "";
// // };











// let worker = null;

// async function getWorker() {
//   if (!worker) {
//     worker = await Tesseract.createWorker("eng");
//   }
//   return worker;
// }

// // 🔹 Resize image (optional but fast)
// function resizeImage(imageData, maxWidth = 1024) {
//   return new Promise((resolve) => {
//     const img = new Image();
//     img.src = imageData;
//     img.onload = () => {
//       const scale = Math.min(1, maxWidth / img.width);
//       const canvas = document.createElement("canvas");
//       canvas.width = img.width * scale;
//       canvas.height = img.height * scale;
//       const ctx = canvas.getContext("2d");
//       ctx.drawImage(img, 0, 0, canvas.width, canvas.height);
//       resolve(canvas.toDataURL("image/jpeg", 0.8));
//     };
//   });
// }

// // 🔹 Called from Flutter
// window.extractTextFromImage = async function (imageData) {
//   const worker = await getWorker();
//   const resized = await resizeImage(imageData);
//   const result = await worker.recognize(resized);
//   return result.data.text || "";
// };


window.extractTextFromImage = function (imageData) {
  return Tesseract.recognize(
    imageData,
    "eng"
  ).then(({ data }) => {
    return data.text;
  });
};
