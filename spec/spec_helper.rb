require 'simplecov'

SimpleCov.start do
  coverage_dir 'coverage'
  add_filter '/spec/'
end
