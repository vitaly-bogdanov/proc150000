# iex -S mix
defmodule Proc do
  def loop(n) do
    receive do
      {:msg, text, caller} -> send(caller, {:reply, "#{text} - reply from #{n}"})
    end
    loop(n)
  end
  # -----------------------------------------------------------------------------------
  def start_all_proc(count) do
    1..count
    |> Enum.to_list
    |> Enum.map(fn(n) -> start_proc(n) end)
  end
  defp start_proc(n) do
    Task.start(fn -> loop(n) end) # вызывает spawn
  end
  # -----------------------------------------------------------------------------------
  def send_all_msg(pids, msg) do
    pids
    |> Enum.each(fn({:ok, pid}) -> send_msg(pid, msg) end)
  end
  defp send_msg(pid, msg) do
    send(pid, {:msg, msg, self()})
  end
  # -----------------------------------------------------------------------------------
  def kill_all_proc(pids) do
    pids |> Enum.each(fn({:ok, pid}) -> kill_proc(pid) end)
  end
  defp kill_proc(pid) do
    Process.exit(pid, :kill)
  end
end
