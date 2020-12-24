module ApplicationHelper
  def full_title page_title = ""
    base_title = t "foods_drinks"
    page_title.blank? ? base_title : "#{page_title} | #{base_title}"
  end

  def load_image_product product
    image_tag (product.images.attached? ? product.images : "default.jpeg"),
              class: "pic-4"
  end
end
