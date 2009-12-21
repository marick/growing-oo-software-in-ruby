class SniperStateDisplayer
  def initialize(ui)
    @ui = ui
  end
  def sniper_bidding
    show_status(MainWindow::STATUS_BIDDING)
  end

  def sniper_lost
    show_status(MainWindow::STATUS_LOST)
  end

  def sniper_winning # This seems to have popped up from nowhere.
    show_status(MainWindow::STATUS_WINNING)
  end

  private

  def show_status(status)
    SwingUtilities.invoke_later do
      @ui.show_status(status)
      TestLogger.debug(me("Showing #{status}"))
    end
  end
end

