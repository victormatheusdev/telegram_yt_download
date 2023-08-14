require 'telegram/bot'
require 'open-uri'
require 'yt_dlp'


token = ENV["TELEGRAM_BOT_TOKEN"]

# Cria uma instância do bot
bot = Telegram::Bot::Client.new(token)

# Inicia o loop de escuta das mensagens
p "Iniciando bot!"
bot.listen do |message|
    Thread.new do
  # Verifica se a mensagem é uma url de vídeo do Youtube
  if message.respond_to?(:text) && message.text.start_with?("https://")
        begin
        # Responde ao usuário que está baixando o vídeo
        bot.api.send_message(chat_id: message.chat.id, text: "Baixando o vídeo...")

        # Usa a gem youtube-dl.rb para baixar o vídeo e converter para mp3

        video = YtDlp::Video.new(message.text, extract_audio: true, audio_format: 'mp3', audio_quality:0, embed_thumbnail:true, embed_metadata: true)
        output_file = video.download
        new_file = File.basename(output_file, File.extname(output_file)) + ".mp3"
        # Responde ao usuário que está enviando o mp3
        bot.api.send_message(chat_id: message.chat.id, text: "Enviando o mp3...")

        # Envia o arquivo mp3 para o usuário
        bot.api.send_audio(chat_id: message.chat.id, audio: Faraday::UploadIO.new(new_file, 'audio/mpeg'))

        # Exclui o arquivo localmente
        File.delete(new_file)
        rescue StandardError => e
            bot.api.send_message(chat_id: message.chat.id, text: "Erro ao caixar vídeo do jeito tradicional. Tentando secundário.")
            video = YtDlp::Video.new(message.text, extract_audio: true, audio_format: 'mp3', audio_quality:0)
            output_file = video.download
            new_file = File.basename(output_file, File.extname(output_file)) + ".mp3"
            # Responde ao usuário que está enviando o mp3
            bot.api.send_message(chat_id: message.chat.id, text: "Enviando o mp3...")

            # Envia o arquivo mp3 para o usuário
            bot.api.send_audio(chat_id: message.chat.id, audio: Faraday::UploadIO.new(new_file, 'audio/mpeg'))

            # Exclui o arquivo localmente
            File.delete(new_file)
        end
    else
        # Responde ao usuário que não é uma url válida do Youtube
        bot.api.send_message(chat_id: message.chat.id, text: "Desculpe, isso não é uma url válida do Youtube.")
    end
    end
end
