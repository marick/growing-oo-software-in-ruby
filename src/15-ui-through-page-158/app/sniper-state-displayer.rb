class SniperStateDisplayer
  def initialize(ui)
    @ui = ui
  end
  def sniper_bidding(state)
    SwingUtilities.invoke_later do
      @ui.sniper_status_changed(state, MainWindow::STATUS_BIDDING)
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
      @ui.show_status(status)
      TestLogger.debug(me("Showing #{status}"))
    end
  end
end

