defmodule GenChattingEtsTest do
  use ExUnit.Case
  doctest GenChattingEts

  test "greets the world" do
    assert GenChattingEts.hello() == :world
  end
end
