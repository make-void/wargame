class QueueView extends Backbone.View ## maybe rename with backbone syntax

  render: () ->
    haml = Haml $("#queueView-tmpl").html()
    content = haml this.model.attributes

    $(this.el).html content

    this