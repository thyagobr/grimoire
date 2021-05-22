require "bundler/inline"

gemfile do
  source "https://rubygems.org"
  gem "ruby-kafka"
  gem "httparty"
  gem "json"
  gem "byebug"
end

require "kafka"

class Consumer
  attr_accessor :consumer
  KAFKA_URLS = ["localhost:9092"]

  trap("INT") { puts "Shutting down."; @consumer.stop; exit}

  def self.run!
    puts "Consumer: Connection to Kafka setup on #{KAFKA_URLS}"
    kafka = Kafka.new(KAFKA_URLS, client_id: "SurveyConsumer")

    @consumer = kafka.consumer(group_id: "survey_consumer_group")
    @consumer.subscribe('question_answered')
    begin
      @consumer.each_message do |message|
        puts "New message:"
        begin
          value = JSON.parse(message.value)
          temp_message = value.dup
          puts "#{value}"
        rescue StandardError => e
          puts "Consumer Error"
          puts e
        end
        puts "-"*100
      end
    rescue Kafka::ProcessingError => e
      @consumer.stop
      puts e.cause
    end
  end
end

Consumer.run!
