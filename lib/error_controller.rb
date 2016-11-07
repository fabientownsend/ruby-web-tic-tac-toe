  class ErrorController
    def update(one, two, three, html)
      @game = three
    end

    def action(env)
      @game
    end

    def response
      "error 404"
    end
  end
