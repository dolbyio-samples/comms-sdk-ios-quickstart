import UIKit
import VoxeetSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func fetchDeveloperToken(completion: @escaping (_ token: String?) -> Void) {
        if (API_TOKEN == "<REPLACE-WITH-YOUR-DEVELOPER-TOKEN>"){
            assertionFailure("You must add a valid developer token in Constants.swift")
        };
        completion(API_TOKEN);
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Fetch access token.
        fetchDeveloperToken { accessToken in
            guard let token = accessToken else { return }
            
            // Voxeet SDK OAuth initialization.
            VoxeetSDK.shared.initialize(accessToken: token) { (refreshClosure, isExpired) in
                // VoxeetSDK calls this closure when the token needs to be refreshed.
                self.fetchDeveloperToken { accessToken in
                    guard let token = accessToken else { return }
                    // Call the SDK’s refresh closure with the new token
                    refreshClosure(token)
                }
            }
        }
        VoxeetSDK.shared.notification.push.type = .none
        VoxeetSDK.shared.conference.defaultBuiltInSpeaker = true
        VoxeetSDK.shared.conference.defaultVideo = false
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    /*
     Use this function if you want to use your own token server
     SEE https://github.com/dolbyio-samples/comms-sdk-platform-token-service for details.
     This function fetches the token by a post request with the app identifier, if matching on the service then a token is returned
    */
    func fetchSecureToken(completion: @escaping (_ token: String?) -> Void) {
        let serverURL = "<ENTER_YOUR_TOKEN_SERVER_URL>"  // enter your token server url
        let bundleID = Bundle.main.infoDictionary?["CFBundleIdentifier"] as! String
        
        let url = URL(string: serverURL)!
        var request = URLRequest(url: url)
        let headers = [
            "appidentifier": bundleID
        ]
        request.allHTTPHeaderFields = headers
        request.httpMethod = "POST"
        request.timeoutInterval = 60

        
        let task = URLSession.shared.dataTask(with: request) { data, _, _ in
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let accessToken = json["access_token"] as? String {
                completion(accessToken)
            } else {
                completion(nil)
            }
        }
        task.resume()
        
    }
}
