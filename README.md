# Dolby.io Communications APIs iOS SDK Getting Started app

This is the sample app from the iOS app used in the
Getting Started article.  [Link Coming Soon]

You can find additional reference documentation here:
- [iOS Reference](https://docs.dolby.io/communications/docs/ios-client-sdk-voxeetsdk)

## Build and Run
We've implemented Swift Package Manager from within XCode to add the Dolby.io SDK to this project.  We'll use a Developer Token while in developement, and recommend you use a token service for production deployment.

- Download the app and open with xCode.
- Select the project's target and Signings and Capibilities Tab.
- Select your team and set the project's bundle ID.
  - Typically, com.**teamid**.ios.quickstart where **teamid** equals your team id.

![Xcode Build Setting](./wiki-quickstart-bundleid.png)

- Open Constants.swift and if missing, replace the API_TOKEN with your developer token*.  Create a **Developer Token** with the handy [bookmarklet](https://developer-token-dolbyio.netlify.app).
  
- Build and run your application.
- You can test the app with another particpant by going to the developer dashboard at https://dashboard.dolby.io/dashboard/applications/summary and selecting your app and the communications apis link in the sidebar, select the test tab and join a conference.

### Tips:
- If you have any issues with the SDK not being recognized; try updating the packages or re-installing the package SDK. (See below)

 
## Installing the SDK with Swift Package Manager

The Swift Package Manager is a tool for automating the process of downloading, compiling, and linking dependencies. The Swift Package Manager is supported in SDK 3.4.0 and later versions.

1. Select `File` ▸ `Add Packages…` to add package dependency.

2. In the opened window, find the search box and specify the URL to the SDK repository: https://github.com/voxeet/voxeet-sdk-ios.

3. Choose voxeet-sdk-ios from the results list.

4. Select the proper SDK version from the `Dependency Rule` dropdown list.
   
    ![SPM Settings](./wiki-spm-install.png)

5. Select the `Add Package` option.
