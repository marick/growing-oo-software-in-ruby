class SniperSnapshotDisplayer
  def initialize(ui)
    @ui = ui
  end
  def sniper_state_changed(sniper_snapshot)
    SwingUtilities.invoke_later do
      @ui.sniper_state_changed(sniper_snapshot)
    end
  end
  private

  def show_status(status)
    SwingUtilities.invoke_later do
      App::Log.info(me("Showing #{status.inspect}"))
      @ui.show_status(status)
    end
  end
end

