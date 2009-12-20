Then /^the sniper shows that it.s joining$/ do
  @driver.should have_sniper_status MainWindow::STATUS_JOINING
end

Then /^the sniper shows that it.s lost the auction$/ do
  @driver.should have_sniper_status MainWindow::STATUS_LOST
end

Then /^the sniper shows that it.s bidding in the auction$/ do
  @driver.should have_sniper_status MainWindow::STATUS_BIDDING
end

