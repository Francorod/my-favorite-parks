//
//  teste.swift
//  Landmarks
//
//  Created by Franco Rodrigues on 2/14/22.
//

import UIKit

// [START auth_import]
import Firebase

import FirebaseCore


@UIApplicationMain
// [START signin_delegate]
class AppDelegate: UIResponder, UIApplicationDelegate {
  // [END signin_delegate]
  var window: UIWindow?

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [
                     UIApplication.LaunchOptionsKey: Any
                   ]?) -> Bool {
    // [START firebase_configure]
    // Use Firebase library to configure APIs
    FirebaseApp.configure()
    // [END firebase_configure]
    ApplicationDelegate.shared.application(application,
                                           didFinishLaunchingWithOptions: launchOptions)

    return true
  }

  // [START new_delegate]
  @available(iOS 9.0, *)
  func application(_ application: UIApplication, open url: URL,
                   options: [UIApplication.OpenURLOptionsKey: Any])
    -> Bool {
    // [END new_delegate]
    return self.application(application,
                            open: url,
                            // [START new_options]
                            sourceApplication: options[UIApplication.OpenURLOptionsKey
                              .sourceApplication] as? String,
                            annotation: [:])
  }

  // [END new_options]
  // [START old_delegate]
  func application(_ application: UIApplication, open url: URL, sourceApplication: String?,
                   annotation: Any) -> Bool {
    // [END old_delegate]
    if handlePasswordlessSignIn(withURL: url) {
      return true
    }
    if GIDSignIn.sharedInstance.handle(url) {
      return true
    }
    return ApplicationDelegate.shared.application(application,
                                                  open: url,
                                                  // [START old_options]
                                                  sourceApplication: sourceApplication,
                                                  annotation: annotation)
  }

  // [END old_options]
  func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                   restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
    return userActivity.webpageURL.flatMap(handlePasswordlessSignIn)!
  }

  func handlePasswordlessSignIn(withURL url: URL) -> Bool {
    let link = url.absoluteString
    // [START is_signin_link]
    if Auth.auth().isSignIn(withEmailLink: link) {
      // [END is_signin_link]
      UserDefaults.standard.set(link, forKey: "Link")
      (window?.rootViewController as? UINavigationController)?
        .popToRootViewController(animated: false)
      window?.rootViewController?.children[0]
        .performSegue(withIdentifier: "passwordless", sender: nil)
      return true
    }
    return false
  }
}
