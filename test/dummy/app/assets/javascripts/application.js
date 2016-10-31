// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require giman/giman
//= require_self

$(function() {

  $("[data-giman-drop-upload]").each(function() {
    var $dropbox = $(this),
        $input = $('#'+$dropbox.attr('data-giman-drop-upload')),
        $status = $dropbox.find('.upload-text'),
        $form = $dropbox.closest("form"),
        $btn = $form.find("input[type=submit]");

    console.log("Setup ", $dropbox);

    // Cache original text so we can change it
    $status.attr("data-original-txt", $status.text());
    $btn.attr("data-original-txt", $btn.val());

    $input.on("directUpload:started", function(e) {
      $btn.attr("disabled", true).val("Uploading...");
    });

    $input.on("directUpload:progress", function(e, args) {
      $status.text("Uploading "+ args.percentLoaded +"%");
    });

    $input.on("directUpload:complete", function(e, args) {
      $status.text("Upload complete!");
      setTimeout(function() {
        $status.text($status.attr("data-original-txt"));
      }, 1000);

      $btn.removeAttr("disabled").val($btn.attr("data-original-txt"));

      if ($dropbox.attr('data-with-preview')) {
        $("#"+$dropbox.attr('data-with-preview')).html('<img src="'+ args.fileData.url +'" style="max-width: 100%;">');
      }
    });
  });

});