# encoding: utf-8
module ToRegexp
  module String
    REGEXP_DELIMITERS = {
      '%r{' => '}',
      '/' => '/',
    }

    def to_regexp
      ::Regexp.new *as_regexp
    end
    
    def as_regexp
      str = self.dup
      unless delim_set = REGEXP_DELIMITERS.detect { |k, v| str.start_with? k }
        # no starting delimiter found
        return
      end
      delim_start, delim_end = delim_set.map { |delim| ::Regexp.escape delim }
      /\A#{delim_start}(.*)#{delim_end}([^#{delim_end}]*)\z/u =~ str.strip
      content = $1
      options = $2
      unless content.is_a?(::String) and options.is_a?(::String)
        # maybe a missing end delimiter?
        return
      end
      content.gsub! '\\/', '/'
      ignore_case = options.include?('i') ? ::Regexp::IGNORECASE : 0
      multiline = options.include?('m') ? ::Regexp::MULTILINE : 0
      extended = options.include?('x') ? ::Regexp::EXTENDED : 0
      # 'n', 'N' = none, 'e', 'E' = EUC, 's', 'S' = SJIS, 'u', 'U' = UTF-8
      lang = options.scan(/[nesu]/i).join.downcase
      if ::RUBY_VERSION > '1.9' and lang.include?('u')
        lang.gsub! 'u', ''
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
