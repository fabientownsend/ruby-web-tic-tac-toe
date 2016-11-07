class HTMLBuilder

  def create(args = {})
    update_informations(args)
    content = menu_game_type + game_status + create_board + reset_button
    header + body(content)
  end

  private

  attr_reader :message, :board, :current_game_type

  def update_informations(args = defaults)
    args = defaults.merge(args)

    @board = args[:board]
    @message = args[:message]
    @current_game_type = args[:current_game_type]
  end

  def defaults
    { :message => "default", :board => [], :current_game_type => TYPES.keys.first}
  end

  def game_status
    "<p>#{message}</p>"
  end

  def reset_button
    "<form action='reset'><input type='submit' value='Reset'/></form>"
  end

  TYPES = {
    "human_vs_human" => "Human vs. Human",
    "human_vs_computer" => "Human vs. Computer",
    "computer_vs_computer" => "Computer vs. Computer"
  }

  def menu_game_type
    "<form action='menu'><select name='menu'>"\
      + creat_options\
      + "</select><input type='submit' value='type game'/></form>"
  end

  def creat_options
    TYPES.map { |game_type_value, menu| create_option(game_type_value, menu) }.join
  end

  def create_option(game_type_value, menu)
    if (current_game_type == game_type_value)
      "<option value='#{game_type_value}' selected='selected'>#{menu}</option>"
    else
      "<option value='#{game_type_value}'>#{menu}</option>"
    end
  end

  def create_board
    "<table><tbody>" + create_board_lines + "</tbody></table>"
  end

  def create_board_lines
    board.map { |line| "<tr>" + create_line_cells(line) + "</tr>" }.join
  end

  def create_line_cells(line)
    line.map { |cell_id|
      "<td><a class='spot_link' href='/move?number=#{cell_id}'> #{cell_id} </a></td>" }.join
  end

  def header
    "<!doctype html><html lang=''><head><meta charset='utf-8'><title></title>\
    #{css}</head>"
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

  def body(content = "")
    "<body>#{content}</body></html>"
  end
end
