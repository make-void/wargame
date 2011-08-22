guard 'livereload' do
  watch(%r{.+\.(rb|ru)})
  watch(%r{app/(models|controllers|mailers)/.+\.(rb|yml|haml)})
  watch(%r{app/views/\w+/.+\.(html|erb|haml)})  
  watch(%r{public/javascripts/.+\.(js|coffee)})
  watch(%r{public/stylesheets/.+\.(sass|css)})

end

guard 'coffeescript', :input => 'public/javascripts'
