class ConversionController < ApplicationController
  skip_before_action :verify_authenticity_token

  def convert
    message = params[:message]
    html = convert_to_html(message)

    respond_to do |format|
      format.png do
        render_png(html)
      end

      format.jpg do
        render_jpg(html)
      end

      format.html do
        render plain: html
      end

      format.json do
        results = upload_to_cloudinary(html)
        render json: results
      end
    end
  end

  private

  def convert_to_html(message)
    theme = Rouge::Themes::MonokaiSublime.render(scope: '.highlight')
    formatter = Rouge::Formatters::HTML.new
    lexer = Rouge::Lexers::Shell.new
    formatted_message = formatter.format(lexer.lex(message.to_s))

    "<style>
      #{theme}
      html, body {
        background: #282a36;
        padding: 10px 10px 10px 10px;
        font-size: 20px;
      }
      .highlight {
        white-space: pre-wrap;
      }
    </style>
    <div class='highlight'>#{formatted_message}</pre>"
  end

  def render_png(html)
    @kit = get_image_kit(html)
    send_data(@kit.to_png, type: 'image/png', disposition: 'inline')
  end

  def render_jpg(html)
    @kit = get_image_kit(html)
    send_data(@kit.to_jpg, type: 'image/jpeg', disposition: 'inline')
  end

  def upload_to_cloudinary(html)
    @kit = get_image_kit(html)

    file = Tempfile.new(["code_image_#{Time.current.to_s.underscore}", '.png'],
                        'tmp', encoding: 'ascii-8bit')
    file.write(@kit.to_png)
    file.flush

    Cloudinary::Uploader.upload(file.path)
  end

  def get_image_kit(html)
    IMGKit.new(html, width: 500)
  end
end
