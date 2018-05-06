#!/usr/bin/env ruby
#
# Usage:
#   script/simple_bench.rb 100
#

ENV['RAILS_ENV'] ||= 'profile'
require_relative '../config/boot'
require 'bundler/setup'
require_relative '../config/environment'

module SimpleBench
  PERCENTILES = [
    50,
    75,
    90,
    99,
  ]

  class << self
    def percentile(times)
      app = Rack::MockRequest.new(Rails.application)
      durations = []

      path = '/'
      params = {}

      # warmup
      warms = times / 10
      warms.times do |i|
        app.get(path, params)
        print "\rwarmup: #{i + 1}/#{warms}"
      end
      puts

      # benchmark
      i = 0
      while i < times
        started_at = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        app.get(path, params)
        duration = Process.clock_gettime(Process::CLOCK_MONOTONIC) - started_at

        durations << duration
        i += 1
        print "\rbenchmark: #{i}/#{times}"
      end
      puts "\ntotal time: #{"%.1f" % durations.inject(&:+)}s"

      puts "\nGET #{path}:"
      show_percentiles(durations)
    end

    def stackprof
      StackProf.start(mode: :cpu, interval: 10, out: "#{RUBY_VERSION}.dump")
      # xxx: tbd
      StackProf.stop
    end

    private

    def show_percentiles(durations)
      percentiles = PERCENTILES.dup
      results = {}

      durations.sort.each_with_index do |duration, index|
        percentile = (index / durations.size.to_f) * 100
        matched, percentiles = percentiles.partition { |threshold| percentile >= threshold }

        matched.each do |match|
          results[match] = duration
        end
        break if percentiles.empty?
      end

      results.each do |percentile, duration|
        puts "  #{percentile}: #{"%.1f" % (duration * 1000)}ms"
      end
    end
  end
end

# todo: mkdir -p tmp/letter_avatars

SimpleBench.percentile(Integer(ARGV.first) || 100)
