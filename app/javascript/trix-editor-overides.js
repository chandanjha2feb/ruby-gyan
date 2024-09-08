// Blacklist all file attachments
// window.addEventListener("trix-file-accept", function(event) {
//   event.preventDefault()
//   alert("File attachment not supported!")
// })

// Only images

window.addEventListener("trix-file-accept", function(event) {
    //const maxFileSize = 1024 * 1024 // 1MB 
    const maxFileSize = 3000 * 3000 // around 9MB 
    if (event.file.size > maxFileSize) {
      event.preventDefault()
      //alert("Only support attachment files upto size 9MB!")
      alert("Only support attachment files upto size 9MB!")
    }
})

// File size
// window.addEventListener("trix-file-accept", function(event) {
//   const maxFileSize = 1024 * 1024 // 1MB 
//   if (event.file.size > maxFileSize) {
//     event.preventDefault()
//     alert("Only support attachment files upto size 1MB!")
//   }
// })