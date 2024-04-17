@gtg_feature
Feature: Proof of concept


  @test_0
  Scenario: Can gtg be started?
    * Start application "gtg" via "command"


  @test_1
  Scenario: test_1 description string
    * Start application "gtg" via "command"
    * Left click "Actionable" "radio button"
    * Left click "Closed" "radio button"
    * Left click "Open" "radio button"


  @test_2
  Scenario: test_2 description string
    * Start application "gtg" via "command"
    * Close application "gtg" via "shortcut"
    * Application "gtg" is no longer running


  @test_3
  Scenario: test_3 description string
    * Start application "gtg" via command "flatpak run org.gnome.GTG"  in "session"
    * Key combo: "<Super><Up>"
    * Left click "Start Tomorrow" "push button"



  @test_4
  Scenario: test_4 description string
    * Start application "gtg" via "command"
    # Equivalent of sleep(3) in python but without the need to code it on your own.
    * Wait 3 seconds before action
    * Custom step template


