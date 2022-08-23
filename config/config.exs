import Config

case Mix.env() do
  :dev -> config(:gen_chatting_ets, node_env: :dev)
end
