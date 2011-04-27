# encoding: UTF-8
require 'helper'

class TestToRegexp < Test::Unit::TestCase
  def test_000_versus_eval_ascii
    str = "/finalis(e)/im"
    old_way = eval(str)
    new_way = str.to_regexp
    assert_equal old_way, new_way
  end

  def test_000a_versus_eval_utf8
    str = "/finalis(é)/im"
    old_way = eval(str)
    new_way = str.to_regexp
    assert_equal old_way, new_way
  end
  
  def test_001_utf8
    assert_equal 'ë', '/(ë)/'.to_regexp.match('Citroën').captures[0]
  end
  
  def test_002_multiline
    assert_equal nil, '/foo.*(bar)/'.to_regexp.match("foo\n\nbar")
    assert_equal 'bar', '/foo.*(bar)/m'.to_regexp.match("foo\n\nbar").captures[0]
  end
  
  def test_003_ignore_case
    assert_equal nil, '/(FOO)/'.to_regexp.match('foo')
    assert_equal 'foo', '/(FOO)/i'.to_regexp.match('foo').captures[0]
  end
  
  def test_004_percentage_r_notation
    assert_equal '/', '%r{(/)}'.to_regexp.match('/').captures[0]
  end
  
  def test_005_multiline_and_ignore_case
    assert_equal 'bar', '/foo.*(bar)/mi'.to_regexp.match("foo\n\nbar").captures[0]
  end
  
  def test_006_cant_fix_garbled_input
    if RUBY_VERSION >= '1.9'
      garbled = 'finalisé'.force_encoding('ASCII-8BIT') # like if it was misinterpreted
      assert_raises(Encoding::CompatibilityError) do
        '/finalis(é)/'.to_regexp.match(garbled)
      end
    else # not applicable to ruby 1.8
      garbled = 'finalisé'
      assert_nothing_raised do
        '/finalis(é)/'.to_regexp.match(garbled)
      end
    end
  end
  
  def test_007_possible_garbled_input_fix_using_manfreds_gem
    if RUBY_VERSION >= '1.9'
      require 'ensure/encoding'
      garbled = 'finalisé'.force_encoding('ASCII-8BIT') # like if it was misinterpreted
      assert_equal 'é', '/finalis(é)/'.to_regexp.match(garbled.ensure_encoding('UTF-8')).captures[0]
    else # not applicable to ruby 1.8
      garbled = 'finalisé'
      assert_equal 'é', '/finalis(é)/'.to_regexp.match(garbled).captures[0]
    end
  end
  
  def test_008_as_regexp
    str = '/finalis(é)/in'
    assert_equal ['finalis(é)', ::Regexp::IGNORECASE, 'n'], str.as_regexp
    assert_equal Regexp.new(*str.as_regexp), str.to_regexp
  end
  
  def test_009_ruby_19_splat
    assert_equal nil, 'hi'.to_regexp
  end
  
  def test_010_regexp_to_regexp
    a = /foo/
    assert_equal a, a.to_regexp
  end
end
