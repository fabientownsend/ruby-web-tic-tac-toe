class HTMLBuilder
  attr_accessor :message

  def generate_board(board)
    @my_board = "<table><tbody>" + create_line(board) + "</tbody></table>"
  end

  def generate_page
    "<!doctype html><html lang=''><head><meta charset='utf-8'><title></title>
    #{css}</head><body>#{@list_game_types}
    <h1>Tic-Tac-Toe</h1><p>#{message}</p><div id='board'>#{@my_board}</div>
    <form action='reset'><input type='submit' value='Reset'/></form></body></html>"
  end

  def game_types(selected = nil)
    @list_game_types = "<form action='menu'><select name='menu'>"\
      + create_list(selected)\
      + "</select><input type='submit' value='type game'/></form>"
  end

  private

  attr_accessor :board

  def create_list(selected)
    TYPES.map { |value, menu| create_option(selected, value, menu) }.join
  end

  TYPES = {
    "human_vs_human" => "Human vs. Human",
    "human_vs_computer" => "Human vs. Computer",
    "computer_vs_computer" => "Computer vs. Computer"
  }

  def create_option(selected, value, menu)
    if (selected == value)
      "<option value='#{value}' selected='selected'>#{menu}</option>"
    else
      "<option value='#{value}'>#{menu}</option>"
    end
  end

  def create_line(board)
    board.map { |lines| "<tr>" + create_cells(lines) + "</tr>" }.join
  end

  def create_cells(lines)
    lines.map { |spot|
      "<td><a class='spot_link' href='/move?number=#{spot}'> #{spot} </a></td>" }.join
  end

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
