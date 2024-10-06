// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
import $ from 'jquery';
window.$ = window.jQuery = $;
import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
require("jquery-ui-dist/jquery-ui");
Rails.start()
Turbolinks.start()
ActiveStorage.start()

require("trix")
require("@rails/actiontext")
import 'bootstrap/dist/js/bootstrap'
import 'bootstrap/dist/css/bootstrap'
//require("stylesheets/application.scss");
import "@fortawesome/fontawesome-free/css/all"
import "chartkick"

import videojs from 'video.js'
import 'video.js/dist/video-js.css'
//import "Chart.bundle"

// require("jquery") // yarn add jquery
// require("jquery-ui-dist/jquery-ui"); // yarn add jquery-ui-dist 

// // Add this at the end of the file:
// $(function() {
//   $("#draggable").draggable();
// });
import "../trix-editor-overides"
import "../youtube"
import 'selectize/dist/js/standalone/selectize';// selectize();
require("@nathanvda/cocoon")

// $(document).on('turbolinks:load', function(){
//     let videoPlayer = videojs(document.getElementById('my-video'), {
//         controls: true,
//         playbackRates: [0.5, 1, 1.5],
//         autoplay: false,
//         fluid: true,
//         preload: false,
//         autoplay: false,
//         liveui: true,
//         responsive: true,
//         loop: false,
//         poster: "https://i.imgur.com/EihmtGG.jpg"
//     })
//     videoPlayer.addClass('video-js');
//     videoPlayer.addClass('vjs-big-play-centered');
// })
$(document).on("turbolinks:load", function(){
    $(".selectize-tags").selectize({
        create: function(input, callback) {
          $.post('/tags.json', { tag: { name: input } })
            .done(function(response){
              console.log(response)
              callback({value: response.id, text: response.name });
            })
        }
    });
    $("video").bind("contextmenu",function(){
        return false;
    });
});

$(document).ready(function(){
    
})