let Comment = {};

Comment.initialize_all = function() {
  if ($("#c-posts").length || $("#c-comments").length) {
    $(document).on("click.danbooru.comment", ".edit_comment_link", Comment.show_edit_form);
    $(document).on("click.danbooru.comment", ".expand-comment-response", Comment.show_new_comment_form);
    $(document).on("click.danbooru.comment", ".unhide-comment-link", Comment.unhide_comment);
  }
}

Comment.show_new_comment_form = function(e) {
  $(e.target).hide();
  var $form = $(e.target).closest("div.new-comment").find("form");
  $form.show();
  $form[0].scrollIntoView(false);
  e.preventDefault();
}

Comment.show_edit_form = function(e) {
  $(this).closest(".comment").find(".edit_comment").show();
  e.preventDefault();
}

Comment.unhide_comment = function(e) {
  let $comment = $(this).closest(".comment");
  $comment.find(".unhide-comment-link").hide();
  $comment.find(".body").show();
  e.preventDefault();
}

$(document).ready(function() {
  Comment.initialize_all();
});

export default Comment
