# encoding: utf-8
module ToRegexp
  module Regexp
    def to_regexp
      self
    end
  end
  
  module String
    REGEXP_DELIMITERS = {
      '%r{' => '}',
      '/' => '/',
    }

    def to_regexp(options = {})
      if args = as_regexp(options)
        ::Regexp.new *args
      end
    end
    
    def as_regexp(options = {})
      unless options.is_a?(::Hash)
        raise ::ArgumentError, "[to_regexp] Options must be a Hash"
      end
      str = self.strip
      
      if options[:literal] == true
        content = ::Regexp.escape str
      elsif delim_set = REGEXP_DELIMITERS.detect { |k, v| str.start_with?(k) }
        delim_start, delim_end = delim_set.map { |delim| ::Regexp.escape delim }
        /\A#{delim_start}(.*)#{delim_end}([^#{delim_end}]*)\z/u =~ str
        content = $1
        inline_options = $2
        return unless content.is_a?(::String)
        content.gsub! '\\/', '/'
        if inline_options
          options[:ignore_case] = true if inline_options.include?('i')
          options[:multiline] = true if inline_options.include?('m')
          options[:extended] = true if inline_options.include?('x')
          # 'n', 'N' = none, 'e', 'E' = EUC, 's', 'S' = SJIS, 'u', 'U' = UTF-8
          options[:lang] = inline_options.scan(/[nesu]/i).join.downcase
        end
      else
        return
      end
      
      ignore_case = options[:ignore_case] ? ::Regexp::IGNORECASE : 0
      multiline = options[:multiline] ? ::Regexp::MULTILINE : 0
      extended = options[:extended] ? ::Regexp::EXTENDED : 0
      lang = options[:lang] || ''
      if ::RUBY_VERSION > '1.9' and lang.include?('u')
        lang = lang.delete 'u'
      end
      
      if lang.empty?
        [ content, (ignore_case|multiline|extended) ]
      else
        [ content, (ignore_case|multiline|extended), lang ]
      end
    end
  end

end

::String.send :include, ::ToRegexp::String
::Regexp.send :include, ::ToRegexp::Regexp
