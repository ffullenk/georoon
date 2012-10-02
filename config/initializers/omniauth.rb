Rails.application.config.middleware.use OmniAuth::Builder do
  # provider :developer unless Rails.env.production?
  # provider :twitter, 'W1AlZmNK4UnLhsg1N5XaRw', 'Eqi76j0vwr0O6SX5DxMnC0wmG0404ol44Cx2u6fM'
  provider :facebook, '316225008475265', 'e77097c282e05f30dae47f3327ef18ec',
           :scope => 'email,read_stream, publish_stream', :display => 'popup'
end