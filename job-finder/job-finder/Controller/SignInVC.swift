import UIKit
import Firebase

class SignInVC: UIViewController {
    
    let passwordTxt = TextFieldDesign()
    let emailTxt = TextFieldDesign()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0, green: 0.7298330069, blue: 0.652797401, alpha: 1)
        SetupBody()
    }
    
    @objc func PresentSignUpVC() {
        let signUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "signUpVC") as! SignUpVC
        self.addChild(signUpVC)
        signUpVC.view.frame = self.view.frame
        self.view.addSubview(signUpVC.view)
        signUpVC.didMove(toParent: self)
    }
    
    @objc func SignIn() {
        let accountHandeler = AccountHandeler(email: emailTxt.text!, password: passwordTxt.text!, firstName: "", lastName: "", accountType: "")
        accountHandeler.LoginUser(loginComplete: { (success, error) in
            if success {
                DataHandeler.instance._REF_USERS_.child(Auth.auth().currentUser!.uid).child("accountType").observeSingleEvent(of: .value) { res in
                    DispatchQueue.main.async {
                        let accType = res.value as! String
                        var vc = UIViewController()
                        vc.modalPresentationStyle = .fullScreen
                        switch accType {
                        case "Job Poster":
                            vc = CreateJobVC()
                        default:
                            vc = ExploreVC()
                        }
                        
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: false, completion: nil)
                    }
                }
            } else {
                let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    func SetupBody() {
        let signUpBtn = UIButton()
        let signUpBtnAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Avenir-Medium", size: 17),
            .foregroundColor: UIColor.white,
        ]
        signUpBtn.setAttributedTitle(NSAttributedString(string: "Dont have an account? Sign Up", attributes: signUpBtnAttributes), for: .normal)
        signUpBtn.addTarget(self, action: #selector(PresentSignUpVC), for: .touchUpInside)
        view.addSubview(signUpBtn)
        signUpBtn.Anchor(top: nil, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: -200, right: 0))
        
        let attributeView = UIView()
        attributeView.backgroundColor = .white
        view.addSubview(attributeView)
        attributeView.Anchor(top: nil, bottom: signUpBtn.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 20, bottom: -10, right: -20),size: .init(width: 0, height: 2))
        
        let loginBtn = UIButton()
        let loginBtnAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Avenir", size: 15),
            .foregroundColor: UIColor.black,
        ]
        loginBtn.setAttributedTitle(NSAttributedString(string: "Login", attributes: loginBtnAttributes), for: .normal)
        loginBtn.addTarget(self, action: #selector(SignIn), for: .touchUpInside)
        loginBtn.layer.cornerRadius = 7
        loginBtn.backgroundColor = .white
        view.addSubview(loginBtn)
        loginBtn.Anchor(top: nil, bottom: attributeView.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 30, bottom: -100, right: -30), size: .init(width: 0, height: 50))
        
        
        passwordTxt.tintColor = .white
        passwordTxt.placeholder = "Password"
        passwordTxt.borderActiveColor = .white
        passwordTxt.borderInactiveColor = .black
        passwordTxt.isSecureTextEntry = true
        view.addSubview(passwordTxt)
        passwordTxt.Anchor(top: nil, bottom: loginBtn.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 30, bottom: -25, right: -30), size: .init(width: 0, height: 60))
        
        emailTxt.tintColor = .white
        emailTxt.placeholder = "Email"
        emailTxt.borderActiveColor = .white
        emailTxt.borderInactiveColor = .black
        view.addSubview(emailTxt)
        emailTxt.Anchor(top: nil, bottom: passwordTxt.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 30, bottom: -10, right: -30), size: .init(width: 0, height: 60))
    }
}
