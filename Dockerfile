FROM ruby:2.7

# Define o diretório de trabalho para /app
WORKDIR /app

# Copia os arquivos do código para o contêiner
COPY bot.rb Gemfile Gemfile.lock ./

# Instala as gems necessárias
RUN bundle install

# Define a variável de ambiente do token de autorização do bot
# Define a porta que o bot irá ouvir
EXPOSE 80

# Define o comando de inicialização do bot
CMD ["ruby", "bot.rb"]