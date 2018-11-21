#!/usr/bin/env ruby

require 'optparse'

$stdout.sync = true

while input = ARGF.gets
  input.each_line do |line|
    parts       = line.split
    next unless parts.size >= 20
    timestamp   = parts[5].gsub("[","")+" "+parts[6].gsub("]","")
    ip          = parts[0]
    request     = parts[8]
    status      = parts[10]
    size        = parts[11]
    output_line = "#{timestamp}|#{ip}|#{request}|#{status}|#{size}"
    begin
      $stdout.puts output_line
    rescue Errno::EPIPE
      exit(74)
    end
  end
end
