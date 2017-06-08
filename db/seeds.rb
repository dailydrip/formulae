# frozen_string_literal: true

puts 'Creating Application'
a = Application.create

puts 'Creating Api Keys'
ApiKey.create(application: a, creator: true, submitter: true, analytics: true)
ApiKey.create(application: a, creator: false, submitter: true, analytics: true)
ApiKey.create(application: a, creator: false, submitter: false, analytics: true)

f = Form.create(application: a)

s1 = Section.create(name: 'My section',
                    form: f,
                    order: 0,
                    content: 'This section is for test')

s2 = Section.create(name: 'My second section',
                    form: f,
                    order: 1,
                    content: 'This section is for a second test')

s3 = Section.create(name: 'Section with question dependencies',
                    form: f,
                    order: 1,
                    content: 'This section is for a test with question dependencies')

s4 = Section.create(name: 'Section with question dependencies',
                    form: f,
                    order: 1,
                    content: 'This section is for a test with question dependencies')

s5 = Section.create(name: 'Section with question dependencies',
                    form: f,
                    order: 1,
                    content: 'This section is for a test with question dependencies')
Question.create(section: s1,
                order: 0,
                key: 'Key', label: 'This is a label',
                content: 'What is your Name?',
                required: true,
                question_type: 'string', hidden: false)
Question.create(section: s1,
                order: 0,
                key: 'Key', label: 'Email address',
                content: 'Tell us your email address so we can contact you with
                  special offers and sell it later when we go under!',
                required: true,
                validate_as: 'email',
                question_type: 'string', hidden: false)

Question.create(section: s2,
                order: 1,
                key: 'Key', label: 'About You',
                content: 'Tell me more about you',
                question_type: 'text', hidden: false)

q = Question.create(section: s3,
                    order: 1,
                    key: 'Key', label: 'Happiness',
                    content: 'Are you happy?',
                    question_type: 'boolean', hidden: false)

choice1 = Choice.create(question: q, label: 'Yes')
choice2 = Choice.create(question: q, label: 'No')

q2 = Question.create(section: s4,
                     order: 1,
                     key: 'Key', label: 'Happiness',
                     content: 'What makes you happy?',
                     question_type: 'boolean', hidden: false)
# There is a question dependency between
# 'Are you happy?' -> Yes -> Go to What makes you happy?
#                  -> No  -> Go to What makes you sad?
question_dependency = QuestionDependency.create(question: q2)
question_dependency.choices << choice1

q3 = Question.create(section: s5,
                     order: 1,
                     key: 'Key', label: 'Happiness',
                     content: 'What makes you sad?',
                     question_type: 'boolean', hidden: false)

question_dependency = QuestionDependency.create(question: q3)
question_dependency.choices << choice2

puts 'Creating an AdminUser'
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
