require 'twirlio/runtime.rb'


class StdOutSender
  def say(message)
    puts message
  end
end

class StdInReader
  def read
    readline
  end
end

@runtime = Runtime.new(StdOutSender.new, StdInReader.new)

# code = """
#
# (send message)
# (read variable)
# (read variable
#   (if conditional expression)
#   (if conditional expression)
# )
#
# expression = (send template)
#            | (read variable)
#            | (read variable conditionals)
#
# template        = 'regular mustache template'
# variable        = 'any word'
# conditionals    = (if conditional expression)
#                 | (if conditional expression) conditionals
#
# (send message)
# (read variable
#   (if (= 5)
#       (send message)
# )

code = """

  (send 'Hi! welcome to Twilio Pizza Delivery!!!! please enter your name' )
  (read name)
  (send 'Hi {{name}}, please enter your order')
  (read order)
  (send 'Now please enter your address')
  (read address)
  (send 'Great {{name}}, your order of {{order}} will be delivered to {{address}} in 10 minutes ')
  (send 'If your order is complete please reply with YES')
  (read complete)
  (if (= complete 'YES')
    ((send 'Your order is complete, yeah!')
     (send 'This is another statement')
     (send 'This is the final statement'))
    (send 'thats too bad, chao!' ))
"""

code = """
(send 'Cuantas categorias de producto tiene')
(read categorias)
(send 'Cual es la categoria con mas productos')
(read popcategory)
(send 'Cuantos productos hay en {{popcategory}}')
(read numpop)
(if (> numpop '5')
  (send 'ud va a tener un descuento')
  (send 'chao'))
"""

p @runtime.execute(code)




