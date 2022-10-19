//Tree掲示板行全体リンク
/*global jQuery $*/
jQuery(document).on("turbolinks:load", function() {
  $(".tree_tbody_tr").on('click', function() {
      window.location = $(this).data("link");
  });
});

