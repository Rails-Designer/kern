module Kern
  class FormBuilder < ActionView::Helpers::FormBuilder
    module Input
      if Gem.loaded_specs.key?("rails_icons")
        require "rails_icons"

        include RailsIcons::Helpers::IconHelper
      end

      FIELD_TYPES = {
        string: :text_field,
        email: :email_field,
        password: :password_field,
        url: :url_field,
        text: :text_area,
        integer: :number_field,
        float: :number_field,
        decimal: :number_field,
        datetime: :datetime_local_field,
        date: :date_field
      }.freeze

      def input(attribute, options = {})
        label_suffix = options.delete(:label_suffix)
        hint = options.delete(:hint)

        @template.content_tag(:div, data: {slot: "field"}, class: options[:field_css] || field_css) do
          label_html = label(attribute, options)

          @template.safe_join([
            (if label_suffix
               @template.content_tag(:div, class: "flex items-center justify-between") do
                 @template.safe_join([label_html, @template.content_tag(:span, label_suffix.html_safe, class: "text-xs font-medium text-gray-500")].compact)
               end
             end),

            (label_html unless label_suffix),

            input_field(attribute, options),

            (@template.content_tag(:p, hint.html_safe, class: "flex items-center gap-x-1 mt-0.5 px-0.5 text-xs font-light text-gray-500") if hint)
          ].compact)
        end
      end

      def label(attribute, text = nil, options = {}, &block)
        text, options = nil, text if text.is_a?(Hash)
        label_options = options[:label] || {}
        field_errors = @object&.errors&.where(attribute)

        label_options[:class] = class_names("flex items-center gap-1 text-sm font-medium", {"text-gray-700": field_errors&.none?, "text-red-600": field_errors&.any?})
        label_text = text || I18n.t("labels.#{attribute}", default: attribute.to_s.humanize)

        super(attribute, label_options) do
          safe_join([
            begin
              icon("warning-circle", class: "size-3.5 scale-100 transition ml-0 ease-in-out duration-300 starting:ml-3.5 starting:scale-0") if field_errors&.any?
            rescue
              nil
            end,
            label_text.html_safe? ? label_text : label_text.to_s
          ].compact)
        end
      end

      def toggle_wrapper(&block)
        content_tag(:div, yield, data: {slot: "toggle-field"}, class: "flex items-start gap-x-2 [&>input]:mt-[0.15em]")
      end

      def toggle_label(method, text)
        label(method, text.html_safe, class: toggle_label_css)
      end

      private

      def input_field(attribute, options)
        return select(attribute, options[:collection], {}, options.except(:as, :label, :collection)) if options[:collection]

        send(FIELD_TYPES.fetch(options[:as] || type_for(attribute), :text_field), attribute, options.except(:as, :label, :collection))
      end

      def type_for(attribute)
        return :email if attribute.to_s.end_with?("email")
        return :password if attribute.to_s.include?("password")
        return :url if attribute.match?(/url|website|site/)
        return :string unless valid?(attribute)

        @object.type_for_attribute(attribute.to_s).type
      rescue NoMethodError
        :string
      end

      def valid?(attribute)
        @object.respond_to?(attribute) &&
          @object.respond_to?(:has_attribute?) &&
          @object.has_attribute?(attribute)
      end
    end
  end
end
