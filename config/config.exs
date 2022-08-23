import Config

if Mix.env() == :dev do
  config(:gen_chatting_ets, node_env: :dev)
end
