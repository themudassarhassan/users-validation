module HomePageHelper
  def status_badge(status)
    base_classes = "px-2 inline-flex text-xs leading-5 font-semibold rounded-full"
    status_classes = {
      success: "bg-green-100 text-green-800",
      failure: "bg-red-100 text-red-800",
      error: "bg-yellow-100 text-yellow-800"
    }

    content_tag :span, status, class: "#{base_classes} #{status_classes[status]}"
  end
end
