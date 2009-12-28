class SniperSnapshotDisplayer
  def initialize(ui)
    @ui = ui
  end
  def sniper_bidding(sniper_snapshot)
    SwingUtilities.invoke_later do
      @ui.sniper_state_changed(sniper_snapshot)
    end
  end

  def sniper_lost
    show_status(MainWindow::STATUS_LOST)
  end

  def sniper_winning 
    show_status(MainWindow::STATUS_WINNING)
  end

  def sniper_won
    show_status(MainWindow::STATUS_WON)
  end

  private

  def show_status(status)
    SwingUtilities.invoke_later do
      App::Log.info(me("Showing #{status.inspect}"))
      @ui.show_status(status)
    end
  end
end

