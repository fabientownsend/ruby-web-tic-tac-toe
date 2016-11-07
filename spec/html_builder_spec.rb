require 'html_builder'
require 'marks'

RSpec.describe HTMLBuilder do
  let (:html) { HTMLBuilder.new }

  it "display the page with a default message" do
    expect(html.create).to include("default")
  end

  it "display the page with the message set" do
    expect(html.create(:message => "the message")).to include("<p>the message</p>")
  end

  it "doesn't display the page if the board isn't set" do
    expect(html.create).not_to include(board)
  end

  it "display the page with the menu human vs human selected by default" do
    expect(html.create).to include("value='human_vs_human' selected='selected'")
  end

  it "display the page with the menu human vs computer selected" do
    expect(html.create(:current_game_type => "human_vs_computer")).to include("value='human_vs_computer' selected='selected'")
  end

  it "display the page with the board" do
    expect(html.create(
      :board => [[0, 1, 2], [3, 4, 5], [6, 7, 8]]
    )).to include(board)
  end

  it "display the page with the board marked" do
    expect(html.create(
      :board => [[Mark::CROSS, 1, 2], [3, 4, 5], [6, 7, 8]]
    )).to include(board_with_mark)
  end

  it "had a reset button" do
    expect(html.create).to include("value='Reset'")
  end

  private

  def board
    "<table><tbody><tr><td><a class='spot_link' href='/move?number=0'> 0 </a></td><td><a class='spot_link' href='/move?number=1'> 1 </a></td><td><a class='spot_link' href='/move?number=2'> 2 </a></td></tr><tr><td><a class='spot_link' href='/move?number=3'> 3 </a></td><td><a class='spot_link' href='/move?number=4'> 4 </a></td><td><a class='spot_link' href='/move?number=5'> 5 </a></td></tr><tr><td><a class='spot_link' href='/move?number=6'> 6 </a></td><td><a class='spot_link' href='/move?number=7'> 7 </a></td><td><a class='spot_link' href='/move?number=8'> 8 </a></td></tr></tbody></table>"
  end

  def board_with_mark
    "<table><tbody><tr><td><a class='spot_link' href='/move?number=X'> X </a></td><td><a class='spot_link' href='/move?number=1'> 1 </a></td><td><a class='spot_link' href='/move?number=2'> 2 </a></td></tr><tr><td><a class='spot_link' href='/move?number=3'> 3 </a></td><td><a class='spot_link' href='/move?number=4'> 4 </a></td><td><a class='spot_link' href='/move?number=5'> 5 </a></td></tr><tr><td><a class='spot_link' href='/move?number=6'> 6 </a></td><td><a class='spot_link' href='/move?number=7'> 7 </a></td><td><a class='spot_link' href='/move?number=8'> 8 </a></td></tr></tbody></table>"
  end
end
