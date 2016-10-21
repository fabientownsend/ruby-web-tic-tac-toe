class HTMLBuilder
  def self.board(board)
    html_board = "<table><tbody>"

    board.each do |line|
      html_board += "<tr>"

      line.each do |spot|
        html_board += "<td><a class='spot_link' href='/move?number=#{spot}'> #{spot} </a></td>"
      end

      html_board += "</tr>"
    end

    html_board += "</tbody></table>"
  end

  def self.generate_page(message, board)
    "<!doctype html><html lang=''><head><meta charset='utf-8'><title></title>
    #{css}</head><body>
    <h1>Tic-Tac-Toe</h1><p>#{message}</p><div id='board'>#{board}</div>
    <form action='reset'><input type='submit' value='Reset'/></form></body></html>"
  end

  private

  attr_accessor :board

  def self.css
    "<style>
    body { background: #000; color: #fff; text-align: center; }
    td { height: 100px; width: 100px; text-align: center; border: 1px solid #fff; }
    table { border-collapse: collapse; margin: 0 auto; }
    .spot_link { display: block; height: 100px; line-height: 100px; }
    a { text-decoration: none; color: #fff; }
    </style>"
  end
end
