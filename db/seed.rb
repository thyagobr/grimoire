respondent = Respondent.create(uuid: "thyagobr")
question = Question.create(uuid: "eye-color") 
Option.create(uuid: "brown_eye", question: question)
Option.create(uuid: "blue_eye", question: question)
