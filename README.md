# Physio Tracker

Steps to build on ios.
1) Add signing capabilities
2) Go to Runner on left hand menu -> Targets -> Runner -> Build Settings -> Signing -> Delete Code Signing Entitlements 
3) Go to repo/ios/Runner/Base.lproj/ change LaunchScreen.storyboard.xml and Main.storyboard.xml to LaunchScreen.storyboard and Main.storyboard
4) Go to Runner on left hand menu -> Project -> Runner -> Info. Under Configurations change Debug, Release & Profile to have 0 configuration sets each. Quit Xcode. In terminal go to repo root and do: rm -rf Pods/ Podfile.lock ; pod install.
https://stackoverflow.com/questions/26287103/cocoapods-warning-cocoapods-did-not-set-the-base-configuration-of-your-project
