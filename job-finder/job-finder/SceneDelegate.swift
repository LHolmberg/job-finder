import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        if Auth.auth().currentUser != nil {
            window = UIWindow(windowScene: windowScene)
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            
            DataHandeler.instance.GetUserAccountType { result in
                if result == "Job Searcher" {
                    let viewController = storyboard.instantiateViewController(withIdentifier: "searcherHome") as! ExploreVC
                    self.window?.rootViewController = viewController
                    self.window?.makeKeyAndVisible()
                } else {
                    let viewController = storyboard.instantiateViewController(withIdentifier: "posterHome") as! CreateJobVC
                    self.window?.rootViewController = viewController
                    self.window?.makeKeyAndVisible()
                }
            }
        } else {
            window = UIWindow(windowScene: windowScene)
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "signInVC") as! SignInVC
            self.window?.rootViewController = viewController
            self.window?.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {

        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

