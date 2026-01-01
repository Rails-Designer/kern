module Kern
  class FormBuilder < ActionView::Helpers::FormBuilder
    module Styles
      def field_css
        "w-full [&[data-slot='field']+[data-slot='field']]:mt-4"
      end

      def label_css(has_errors: false)
        base = <<~CSS
          flex items-center gap-1 text-sm font-medium
        CSS

        class_names(base, has_errors ? "text-red-600" : "text-gray-700")
      end

      def label_icon_css
        <<~CSS
          size-3.5
          scale-100 transition ml-0 ease-in-out duration-300
          starting:ml-3.5 starting:scale-0
        CSS
      end

      def label_suffix_wrapper_css
        <<~CSS
          flex items-center justify-between
        CSS
      end

      def label_suffix_css
        <<~CSS
          text-xs font-medium text-gray-500
        CSS
      end

      def hint_css
        <<~CSS
          flex items-center gap-x-1 mt-0.5 px-0.5
          text-xs font-light text-gray-500
        CSS
      end

      def input_css
        <<~CSS
          w-full px-2.5 py-1.5
          text-sm font-normal text-gray-900
          bg-white
          border-0 ring ring-gray-200/80 rounded-sm
          hover:ring-gray-300
          disabled:opacity-50 disabled:hover:ring-gray-200/80
          outline-none
          focus:bg-white focus:ring focus:ring-brand-300
        CSS
      end

      def file_field_css
        <<~CSS
          w-full py-1.5
          text-sm font-normal text-gray-600
          disabled:opacity-50
          file:mr-2 file:py-1 file:px-4
          file:text-xs file:font-medium
          file:bg-gray-100 file:text-gray-700
          file:rounded-full file:border-0
          hover:file:bg-gray-200
          focus:outline-hidden focus:ring-0
        CSS
      end

      def toggle_input_css
        <<~CSS
          peer
          accent-brand-500
          border border-gray-100
          rounded-md
          focus:outline-hidden focus:ring focus:ring-offset-1 focus:ring-gray-300
          disabled:opacity-25 disabled:cursor-not-allowed
        CSS
      end

      def toggle_label_css
        <<~CSS
          block text-sm font-normal text-gray-800 peer-disabled:opacity-50 peer-disabled:cursor-not-allowed
        CSS
      end
    end
  end
end
