class HTMLBuilder
  attr_accessor :message
  def the_test(board)
    @my_board = "<table><tbody>"

    board.each do |line|
      @my_board += "<tr>"

      line.each do |spot|
        @my_board += "<td><a class='spot_link' href='/move?number=#{spot}'> #{spot} </a></td>"
      end

      @my_board += "</tr>"
    end

    @my_board += "</tbody></table>"
  end

  def generate_page
    "<!doctype html><html lang=''><head><meta charset='utf-8'><title></title>
    #{css}</head><body>
    <form action='menu'><select name='menu'>
    <option value='human'>Human vs. Human</option>
    <option value='computer'>Human vs. Computer</option>
    </select><input type='submit' value='type game'/></form>
    <h1>Tic-Tac-Toe</h1><p>#{message}</p><div id='board'>#{@my_board}</div>
    <form action='reset'><input type='submit' value='Reset'/></form></body></html>"
  end

  private

  attr_accessor :board

  def css
    "<style>
    body { background: #000; color: #fff; text-align: center; }
    td { height: 100px; width: 100px; text-align: center; border: 1px solid #fff; }
    table { border-collapse: collapse; margin: 0 auto; }
    .spot_link { display: block; height: 100px; line-height: 100px; }
    a { text-decoration: none; color: #fff; }
    </style>"
  end
end
