require "bundler/inline"

gemfile do
  source "https://rubygems.org"
  gem "ruby-kafka"
  gem "json"
  gem "byebug"
end

class Producer
  KAKFA_URLS = ["localhost:9092"]

  attr_accessor :producer

  def initialize
    connect!
  end

  def connect!
    kafka = ::Kafka.new(["localhost:9092"], client_id: "producer")
    kafka.alter_topic("question_answered", "max.message.bytes" => 10_000_000)

    @producer = kafka.async_producer(
      delivery_threshold: 20,           # Delivery once N msg have been buffered.
      delivery_interval: 20,            # Trigger a delivery every N seconds.
      max_buffer_size: 5_000,           # Allow at most 5K messages to be buffered.
      max_buffer_bytesize: 100_000_000, # Allow at most 100MB to be buffered.
      compression_codec: :gzip,
      compression_threshold: 10,
    )

    # Handling Ctrl-C cleanly in Ruby the ZeroMQ way:
    trap("INT") { puts "Shutting down."; @producer.shutdown; exit}

    puts "Connection to Kafka setup on #{KAKFA_URLS}"
    self
  end

  def produce
    @producer.produce({ message: 'what up' }.to_json, topic: "question_answered")
    @producer.deliver_messages
    shutdown!
  end

  def shutdown!
    @producer.deliver_messages
    @producer.shutdown
  end
end
