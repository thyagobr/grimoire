require_relative "../app.rb"

class QuestionAnsweredAgent
  attr_accessor :consumer
  KAFKA_URLS = ["localhost:9092"]

  trap("INT") { puts "Shutting down."; @consumer.stop; exit}

  def self.run!
    puts "*** [AgentConnection] QuestionAnsweredAgent: Connection to Kafka setup on #{KAFKA_URLS}"
    kafka = Kafka.new(KAFKA_URLS, client_id: "QuestionAnsweredAgent")

    @consumer = kafka.consumer(group_id: "survey_consumer_group")
    @consumer.subscribe('question_answered')
    begin
      @consumer.each_message do |message|
        puts "New message:"
        begin
          value = JSON.parse(message.value)
          temp_message = value.dup
          puts "#{value}"
          respondent = Respondent.find(value["respondent_id"])
          question = Question.find(value["question_id"])
          answer = Answer.create(respondent: respondent, question: question)

          options = Option.find(value["event"]["option_ids"])
          options.each do |option|
            answer.options.create(option: option)
          end
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

QuestionAnsweredAgent.run!
