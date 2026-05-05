# frozen_string_literal: true

require File.expand_path("../../test_helper", __dir__)
require "yaml/store"
require "fileutils"

module Ruberto
  class FileCacheTest < Minitest::Test
    def setup
      file_cache_path = "ruberto_cache.yaml"
      File.delete(file_cache_path) if File.exist?(file_cache_path)

      @cache = FileCache.new(file_cache_path)
    end

    def teardown
      @cache.clear
    end

    def test_write_and_read
      @cache.write("foo", "bar")
      assert_equal "bar", @cache.read("foo")
    end

    def test_write_and_read_complex_object
      @cache.write("foo", { foo: "bar", bar: "baz" })
      assert_equal "bar", @cache.read("foo")[:foo]
      assert_equal "baz", @cache.read("foo")[:bar]
    end

    def test_delete
      @cache.write("key", "value")
      @cache.delete("key")
      assert_nil @cache.read("key")
    end

    def test_clear
      @cache.write("key1", "value1")
      @cache.write("key2", "value2")

      @cache.clear
      assert_nil @cache.read("key1")
      assert_nil @cache.read("key2")
    end

    def test_clear_and_write_again
      @cache.write("key1", "value1")
      @cache.write("key2", "value1")
      @cache.clear
      @cache.write("key1", "value2")

      assert "value2", @cache.read("key1")
      assert_nil @cache.read("key2")
    end

    def test_migrates_from_yaml_store_format
      yaml_path = "ruberto_legacy_cache.yaml"
      legacy = YAML::Store.new(yaml_path)
      legacy.transaction { legacy["token"] = "old_value" }

      cache = FileCache.new(yaml_path)

      assert_nil cache.read("token")
      cache.write("token", "new_value")
      assert_equal "new_value", cache.read("token")
    ensure
      File.delete(yaml_path) if File.exist?(yaml_path)
    end
  end
end
