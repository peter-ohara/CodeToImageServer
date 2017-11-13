class WelcomeController < ApplicationController
  def index
    source = "def printer_foo(message):\n     print(message)\n     print(\"Done\")\n"

    theme = Rouge::Themes::MonokaiSublime.render(scope: '.highlight')
    formatter = Rouge::Formatters::HTML.new(theme)
    lexer = Rouge::Lexers::Shell.new
    formatted_source = formatter.format(lexer.lex(source))

    html = "<style>#{theme} html, body { background: #282a36; padding: 10px 10px 10px 10px; font-size: 20px }</style> \n <pre class='highlight'>#{formatted_source}</pre>"

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

      format.json do
        @kit = IMGKit.new(html)

        file = Tempfile.new(["code_image_#{Time.current.to_s}", '.png'], 'tmp', :encoding => 'ascii-8bit')
        file.write(@kit.to_png)
        file.flush

        results = Cloudinary::Uploader.upload(file.path)
        render json: results
      end
    end
  end
end
