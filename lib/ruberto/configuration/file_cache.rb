# frozen_string_literal: true

require "pstore"

module Ruberto
  class FileCache
    def initialize(file_cache_path)
      @file_cache_path = file_cache_path
      @store = PStore.new(file_cache_path)
      reset_if_incompatible!
    end

    def read(key) = @store.transaction { @store[key] }
    def write(key, value) = @store.transaction { @store[key] = value }

    def clear
      File.delete(@file_cache_path) if File.exist?(@file_cache_path)
    end

    def delete(key) = @store.transaction { @store.delete(key) }

    private

    def reset_if_incompatible!
      @store.transaction(true) {}
    rescue StandardError
      clear
      @store = PStore.new(@file_cache_path)
    end
  end
end
