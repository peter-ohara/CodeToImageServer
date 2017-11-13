class WelcomeController < ApplicationController
  def index
    source = "def printer(message):\n     print(message)\n     print(\"Done\")\n"

    theme = Rouge::Themes::MonokaiSublime.render(scope: '.highlight')
    formatter = Rouge::Formatters::HTML.new(theme)
    lexer = Rouge::Lexers::Shell.new
    formatted_source = formatter.format(lexer.lex(source))

    html = "<style>#{theme} html, body { background: #282a36 }</style> \n <pre class='highlight'>#{formatted_source}</pre>"

    respond_to do |format|
      format.png do
        @kit = IMGKit.new(html)
        send_data(@kit.to_png, type: 'image/png', disposition: 'inline')
      end

      format.jpg do
        @kit = IMGKit.new(html)
        send_data(@kit.to_jpg, type: 'image/jpeg', disposition: 'inline')
      end

      format.html do
        render plain: html
      end
    end
  end
end
