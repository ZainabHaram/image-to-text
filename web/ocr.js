// window.extractTextFromImage = function (imageData) {
//   return Tesseract.recognize(
//     imageData,
//     "eng"
//   ).then(({ data }) => {
//     return data.text;
//   });
// };






// 🔹 Create a reusable Tesseract worker
const worker = Tesseract.createWorker({
  logger: (m) => console.log(m), // optional: progress in console
});

let isWorkerReady = false;

// 🔹 Initialize worker only once
async function initWorker() {
  if (!isWorkerReady) {
    await worker.load();
    await worker.loadLanguage('eng');
    await worker.initialize('eng');
    isWorkerReady = true;
  }
}

// 🔹 Resize image to speed up OCR
function resizeImage(imageData, maxWidth = 1024) {
  return new Promise((resolve) => {
    const img = new Image();
    img.src = imageData;
    img.onload = () => {
      const scale = Math.min(1, maxWidth / img.width);
      const canvas = document.createElement('canvas');
      canvas.width = img.width * scale;
      canvas.height = img.height * scale;
      const ctx = canvas.getContext('2d');
      ctx.drawImage(img, 0, 0, canvas.width, canvas.height);
      resolve(canvas.toDataURL('image/jpeg', 0.8)); // compress a bit
    };
  });
}

// 🔹 Main function called from Flutter
window.extractTextFromImage = async function(imageData) {
  await initWorker(); // initialize worker once
  const resized = await resizeImage(imageData); // resize for speed

  const { data } = await worker.recognize(resized, {
    tessedit_pageseg_mode: Tesseract.PSM.SINGLE_BLOCK, // faster mode
  });

  return data.text;
};
