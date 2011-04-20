# encoding: utf-8
module ToRegexp
  module String
    REGEXP_DELIMITERS = {
      '%r{' => '}',
      '/' => '/',
    }

    def to_regexp
      str = self.dup
      unless delim_set = REGEXP_DELIMITERS.detect { |k, v| str.start_with? k }
        raise ::ArgumentError, "[to_regexp] String must start with one of: #{REGEXP_DELIMITERS.keys.join(', ')}"
      end
      delim_start, delim_end = delim_set.map { |delim| ::Regexp.escape delim }
      /\A#{delim_start}(.*)#{delim_end}([^#{delim_end}]*)\z/u =~ str.strip
      content = $1
      options = $2
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
        ::Regexp.new content, (ignore_case|multiline|extended)
      else
        ::Regexp.new content, (ignore_case|multiline|extended), lang
      end
    end
  end

end

::String.send :include, ::ToRegexp::String
