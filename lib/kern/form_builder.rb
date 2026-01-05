require "kern/form_builder/input"

module Kern
  class FormBuilder < ActionView::Helpers::FormBuilder
    include ActionView::Helpers::TagHelper

    include Input

    def self.load_styles
      if defined?(::FormBuilder::Styles)
        include ::FormBuilder::Styles
      else
        require "kern/form_builder/styles"
        include Styles
      end
    end

    %w[
      text_field email_field password_field
      search_field telephone_field url_field number_field
      date_field time_field datetime_field datetime_local_field month_field week_field
    ].each do |field_type|
      define_method(field_type) do |method, options = {}|
        field_classes(options, input_css)

        super(method, options)
      end
    end
    alias_method :phone_field, :telephone_field

    def text_area(method, options = {})
      field_classes(options, input_css)

      super
    end
    alias_method :textarea, :text_area

    def check_box(method, options = {}, checked_value = "1", unchecked_value = "0", &block)
      field_classes(options, toggle_input_css)
      label_text = block ? @template.capture(&block) : method.to_s.humanize
      custom_id = options[:id] || method

      toggle_wrapper do
        super(method, options, checked_value, unchecked_value) + label(custom_id, label_text)
      end
    end
    alias_method :checkbox, :check_box

    def radio_button(method, tag_value, options = {}, &block)
      field_classes(options, toggle_input_css)
      label_text = block ? @template.capture(&block) : tag_value.to_s.humanize
      custom_id = options[:id] || "#{method}_#{tag_value}"

      toggle_wrapper do
        super(method, tag_value, options) + toggle_label(custom_id, label_text)
      end
    end

    def select(method, choices = nil, options = {}, html_options = {})
      field_classes(html_options, input_css)

      super
    end

    def file_field(method, options = {})
      field_classes(options, file_field_css)

      super
    end

    def collection_select(method, collection, value_method, text_method, options = {}, html_options = {})
      field_classes(html_options, input_css)
      super
    end

    def grouped_collection_select(method, collection, group_method, group_label_method, option_key_method, option_value_method, options = {}, html_options = {})
      field_classes(html_options, input_css)

      super
    end

    def collection_check_boxes(method, collection, value_method, text_method, options = {}, html_options = {})
      field_classes(html_options, toggle_input_css, "rounded-sm")

      toggle_wrapper do
        @template.collection_check_boxes(object_name, method, collection, value_method, text_method, options, html_options) do |template|
          template.check_box(class: html_options[:class]) + toggle_label("#{method}_#{template.value.to_s.underscore}", template.text)
        end
      end
    end
    alias_method :collection_checkboxes, :collection_check_boxes

    def collection_radio_buttons(method, collection, value_method, text_method, options = {}, html_options = {})
      field_classes(html_options, toggle_input_css)

      toggle_wrapper do
        @template.collection_radio_buttons(object_name, method, collection, value_method, text_method, options, html_options) do |template|
          template.radio_button(class: html_options[:class]) + toggle_label("#{method}_#{template.value.to_s.underscore}", template.text)
        end
      end
    end

    private

    def field_classes(options, base_css, *additional_classes)
      options[:class] = options[:class].presence || class_names(base_css, *additional_classes, options[:additional_class])
      options.delete(:additional_class)
    end

    def toggle_wrapper(&block)
      content_tag(:div, yield, data: {slot: "field"}, class: "flex items-start gap-x-2 [&>input]:mt-[0.17em]")
    end
  end
end
