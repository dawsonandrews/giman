/**
 * Direct file uploads to AWS S3
 *
 * Example Form inputs
 * -------------------
 * <input type="hidden" id="product_images" name="product[images]" value="[{}, {}]">
 * <input type="file" data-direct-s3-upload data-direct-s3-upload-for="product_images" multiple="multiple" data-supported-types="image/jpeg,image/jpg,image/png,image/gif">
 * <div class="file-upload-dropbox" style="height: 120px; border: dashed 2px #ccc;" data-direct-s3-upload-dropbox data-direct-s3-upload-for="product_images"></div>
 *
 */
$(function() {
  var directUploadId = 0;
  // Loggers:

  $(document).on("directUpload:started", function(ev, args) {
    console.log("directUpload:started", args);
  });

  $(document).on("directUpload:failed", function(ev, args) {
    console.error("directUpload:failed", args.message);
  });

  $(document).on("directUpload:progress", function(ev, args) {
    console.log("directUpload:progress", args.percentLoaded+"%");
  });

  $(document).on("directUpload:complete", function(ev, args) {
    console.log("directUpload:complete", args.fileData);
  });


  $(document).on("change", "[data-direct-s3-upload]", function(ev) {
    var $input = $(ev.currentTarget),
        targetParam = $input.attr("data-direct-s3-upload-for"),
        files = ev.target.files;

    _.each(files, function(file) {
      directUploadFile(file, $input, targetParam);
    }); // files.forEach
  });

  // Disable standard file dragging navigation
  $(document).on("dragenter", function(e) {
    e.stopPropagation();
    e.preventDefault();
  });

  $(document).on("dragover", function(e) {
    e.stopPropagation();
    e.preventDefault();
  });

  $(document).on("click", "[data-direct-s3-upload-dropbox]", function(ev) {
    ev.preventDefault();
    ev.stopPropagation();

    $(ev.currentTarget).siblings("input[type=file]").click();
  });

  $(document).on("drop", "[data-direct-s3-upload-dropbox]", function(ev) {
    ev.preventDefault();
    ev.stopPropagation();

    var $input = $(ev.currentTarget),
        targetParam = $input.attr("data-direct-s3-upload-for"),
        dataTransfer = ev.originalEvent.dataTransfer,
        files = dataTransfer.files;

    _.each(files, function(file) {
      directUploadFile(file, $input, targetParam);
    }); // files.forEach
  });

  $(document).on("directUpload:removeFile", function(ev, args) {
    removeHiddenFieldForUpload(args.$form, args.targetParam, args.serverId);
  });

  function getHiddenFieldFor($form, targetParam, serverId) {
    var found = null;

    $form.find('input[name="'+targetParam+'"]').each(function() {
      if (String($(this).val()) === String(serverId)) {
        found = $(this);
      }
    });

    return found;
  }

  function addHiddenFieldForUpload($form, targetParam, serverId) {
    var exists = getHiddenFieldFor($form, targetParam, serverId);

    if (! exists) {
      $form.prepend('<input type="hidden" name="'+targetParam+'" value="'+serverId+'">');
    }
  }

  function removeHiddenFieldForUpload($form, targetParam, serverId) {
    var exists = getHiddenFieldFor($form, targetParam, serverId);
    if (exists) exists.remove();
  }

  function directUploadFile(file, $input, targetParam) {
    var supportedTypes = $input.attr("data-supported-types"),
        uniqueFileId = "directUpload:"+(directUploadId++);

    if (supportedTypes && supportedTypes.split(",").indexOf(file.type) < 0) {
      return $(document).trigger("directUpload:failed", {
        uniqueFileId: uniqueFileId,
        file: file,
        $input: $input,
        message: "Unsupported file type: "+ file.type
      });
    }

    $(document).trigger("directUpload:started", {
      uniqueFileId: uniqueFileId,
      file: file,
      $input: $input
    });

    var objectUrl = URL.createObjectURL(file);

    $(document).trigger("directUpload:previewReady", {
      uniqueFileId: uniqueFileId,
      file: file,
      $input: $input,
      objectUrl: objectUrl
    });

    // Get a presigned URL to begin the upload
    $.ajax({
      url: "/uploads/presign"
    }).done(function(data, status) {
      var formData = new FormData();
      formData.append("key", data.fields["key"]);
      formData.append("policy", data.fields["policy"]);
      formData.append("success_action_status", data.fields["success_action_status"]);
      formData.append("x-amz-algorithm", data.fields["x-amz-algorithm"]);
      formData.append("x-amz-credential", data.fields["x-amz-credential"]);
      formData.append("x-amz-date", data.fields["x-amz-date"]);
      formData.append("x-amz-signature", data.fields["x-amz-signature"]);
      formData.append("acl", data.fields["acl"]);
      formData.append("file", file);

      // Begin uploading the file to AWS S3
      $.ajax({
        url: data.url,
        data: formData,
        type: "POST",
        contentType: false,
        cache: false,
        processData: false,
        dataType: "xml",
        xhr: function() {
          var myXhr = $.ajaxSettings.xhr();
          if(myXhr.upload){ // Check if upload property exists
            myXhr.upload.addEventListener('progress',function(event) {
              var percentLoaded = Math.round((event.loaded / event.total) * 100);

              $(document).trigger("directUpload:progress", {
                uniqueFileId: uniqueFileId,
                file: file,
                $input: $input,
                event: event,
                loaded: event.loaded,
                total: event.total,
                percentLoaded: percentLoaded
              });
            }, false);
          }
          return myXhr;
        }
      })
      .done(function(data, status) {
        var xml = $(data),
            fileData;

        fileData = {
          uniqueFileId: uniqueFileId,
          url: xml.find("Location").text(),
          s3key: xml.find("Key").text(),
          contentType: file.type,
          size: file.size,
          filename: file.name,
          lastModified: file.lastModified
        };

        $.ajax({
          url: "/uploads",
          type: "POST",
          data: {
            url: fileData.url,
            s3_path: fileData.s3key,
            content_type: fileData.contentType,
            size: fileData.size,
            filename: fileData.filename,
            last_modified_at: fileData.lastModified
          }
        })
        .done(function(data, status) {
          // Attach server ID to data
          fileData.serverId = data.id;

          addHiddenFieldForUpload($input.closest("form"), targetParam, fileData.serverId);

          $(document).trigger("directUpload:complete", {
            uniqueFileId: uniqueFileId,
            file: file,
            $input: $input,
            fileData: fileData
          });
        })
        .fail(function(err) {
          $(document).trigger("directUpload:failed", {
            uniqueFileId: uniqueFileId,
            file: file,
            $input: $input,
            message: "Failed to create file on your server"
          });
        });
      })
      .fail(function(err) {
        $(document).trigger("directUpload:failed", {
          uniqueFileId: uniqueFileId,
          file: file,
          $input: $input,
          message: "Failed to upload to S3"
        });
      }); // ajax - s3 upload
    }).fail(function(err) {
      $(document).trigger("directUpload:failed", {
        uniqueFileId: uniqueFileId,
        file: file,
        $input: $input,
        message: "Failed to get presigned URL"
      });
    }); // ajax - presign
  }
});