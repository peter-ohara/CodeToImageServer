class WelcomeController < ApplicationController
  def index
    source = 'print("Hello world")'
    theme = Rouge::Themes::MonokaiSublime.render(scope: '.highlight')
    formatter = Rouge::Formatters::HTML.new(theme)
    lexer = Rouge::Lexers::Shell.new
    formatted_source = formatter.format(lexer.lex(source))

    html = "<style>#{theme}</style> \n <div class='highlight' style='background: black;'>#{formatted_source}</div>"

    @kit = IMGKit.new(html)

    respond_to do |format|
      format.png do
        send_data(@kit.to_png, type: 'image/png', disposition: 'inline')
      end

      format.jpg do
        send_data(@kit.to_jpg, type: 'image/jpeg', disposition: 'inline')
      end

      format.html do
        render inline: html
      end
    end
  end
end
