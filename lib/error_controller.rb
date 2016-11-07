  class ErrorController
    def action(env)
      response
    end

    private

    def response
      {
        :message => "error 404"
      }
    end
  end
