require 'telegram/bot'
require 'youtube-dl.rb'

token = ENV["TELEGRAM_BOT_TOKEN"]

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    if message.text.start_with?('/baixar')
      url = message.text.split(' ')[1]
      filename = "#{message.chat.id}.mp3"

      # Baixa o vídeo e converte para MP3
      YoutubeDL.download(url, output: filename, format: 'bestaudio[ext=m4a]')

      # Envia o arquivo de MP3 para o usuário
      bot.api.send_audio(chat_id: message.chat.id, audio: Faraday::UploadIO.new(filename, 'audio/mp3'))

      # Remove o arquivo localmente
      File.delete(filename) if File.exist?(filename)
    end
  end
end
