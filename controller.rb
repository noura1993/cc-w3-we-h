require('sinatra')
require('sinatra/contrib/all')
require_relative('./models/film')
also_reload('./models/*')

get('/') do
    @films = Film.all()
    erb( :index )
end

get('/films/:id') do
    @film = Film.find(params[:id].to_i)
    erb( :films )
end

get('/films') do
    @films = Film.all()
    erb( :index )
end