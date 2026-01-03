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
        file: :file_field,
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
               @template.content_tag(:div, class: label_suffix_wrapper_css) do
                 @template.safe_join([label_html, @template.content_tag(:span, label_suffix.html_safe, class: label_suffix_css)].compact)
               end
             end),

            (label_html unless label_suffix),

            input_field(attribute, options),

            (@template.content_tag(:p, hint.html_safe, class: hint_css) if hint)
          ].compact)
        end
      end

      def label(attribute, text = nil, options = {}, &block)
        text, options = nil, text if text.is_a?(Hash)
        label_options = options[:label] || {}
        field_errors = @object&.errors&.where(attribute)

        label_options[:class] = label_css(has_errors: field_errors&.any?)
        label_text = text || I18n.t("labels.#{attribute}", default: attribute.to_s.humanize)

        super(attribute, label_options) do
          safe_join([
            begin
              icon("warning-circle", class: label_icon_css) if field_errors&.any?
            rescue
              nil
            end,
            label_text.html_safe? ? label_text : label_text.to_s
          ].compact)
        end
      end

      def toggle_wrapper(&block)
        content_tag(:div, yield, data: {slot: "field"}, class: "flex items-start gap-x-2 [&>input]:mt-[0.17em]")
      end

      def toggle_label(id, text)
        @template.label_tag(id, text.html_safe, class: toggle_label_css)
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
        return :file if attribute.match?(/hero|image|avatar/)
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
