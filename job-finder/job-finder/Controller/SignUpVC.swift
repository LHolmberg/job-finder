import UIKit

class SignUpVC: UIViewController {
    let emailTxt = TextFieldDesign()
    let passwordTxt = TextFieldDesign()
    let firstNameTxt = TextFieldDesign()
    let lastNameTxt = TextFieldDesign()
    let accountTypeSeg = UISegmentedControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gradientView = GradientView()
        gradientView.bottomColor = #colorLiteral(red: 0.2246764898, green: 0.3621136546, blue: 0.5893768668, alpha: 1)
        gradientView.topColor = #colorLiteral(red: 0.2088427842, green: 0.275624752, blue: 0.4520844817, alpha: 1)
        view = gradientView
        SetupBody()
    }
    
    @objc func SignUp() {
        if emailTxt.text != "" && passwordTxt.text != "" && firstNameTxt.text != "" && lastNameTxt.text != "" {
            let accountHandeler = AccountHandeler(email: emailTxt.text!, password: passwordTxt.text!, firstName: firstNameTxt.text!, lastName: lastNameTxt.text!, accountType: accountTypeSeg.titleForSegment(at: accountTypeSeg.selectedSegmentIndex)!)
            accountHandeler.RegisterUser(userCreationComplete: { (success, error) in
                if success {
                    var vc = UIViewController()

                    switch self.accountTypeSeg.titleForSegment(at: self.accountTypeSeg.selectedSegmentIndex) {
                    case "Job Poster":
                        vc = CreateJobVC()
                    default:
                        vc = ExploreVC()
                    }
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: false, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                        NSLog("The \"OK\" alert occured.")
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        } else {
            print("NOOOO")
        }
    }
    
    func SetupBody() {
        let signUpBtn = UIButton()
        let signUpBtnAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Avenir", size: 15),
            .foregroundColor: UIColor.black,
        ]
        signUpBtn.setAttributedTitle(NSAttributedString(string: "Sign Up", attributes: signUpBtnAttributes), for: .normal)
        signUpBtn.addTarget(self, action: #selector(SignUp), for: .touchUpInside)
        signUpBtn.layer.cornerRadius = 7
        signUpBtn.backgroundColor = .white
        view.addSubview(signUpBtn)
        signUpBtn.Anchor(top: nil, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 30, bottom: -200, right: -30), size: .init(width: 0, height: 50))
        
        let backBtn = UIButton(type: .custom)
        let backImg = UIImage(named: "icons8-left-50") as UIImage?
        backBtn.setImage(backImg, for: .normal)
        backBtn.addTarget(self, action: #selector(Back), for: .touchUpInside)
        view.addSubview(backBtn)
        backBtn.Anchor(top: view.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: nil, padding: .init(top: 50, left: 30, bottom: 0, right:  0), size: .init(width: 50, height: 50))
        
        accountTypeSeg.insertSegment(withTitle: "Job Searcher", at: 0, animated: false)
        accountTypeSeg.insertSegment(withTitle: "Job Poster", at: 1, animated: false)
        accountTypeSeg.selectedSegmentIndex = 0
        accountTypeSeg.selectedSegmentTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.view.addSubview(accountTypeSeg)
        accountTypeSeg.Anchor(top: nil, bottom: signUpBtn.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 30, bottom: -25, right: -30),size: .init(width: 0, height: 40))
        
        let accountTypelbl = UILabel()
        accountTypelbl.font = UIFont(name: "Avenir-Medium", size: 15)
        accountTypelbl.text = "Account Type"
        view.addSubview(accountTypelbl)
        accountTypelbl.Anchor(top: nil, bottom: accountTypeSeg.topAnchor, leading: view.leadingAnchor, trailing: nil, padding: .init(top: 0, left: 35, bottom: 0, right: 0))
        
        passwordTxt.tintColor = .white
        passwordTxt.placeholder = "Password"
        passwordTxt.isSecureTextEntry = true
        passwordTxt.borderActiveColor = .white
        passwordTxt.borderInactiveColor = .black
        view.addSubview(passwordTxt)
        passwordTxt.Anchor(top: nil, bottom: accountTypelbl.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 30, bottom: -25, right: -30), size: .init(width: 0, height: 60))
        

        lastNameTxt.tintColor = .white
        lastNameTxt.borderActiveColor = .white
        lastNameTxt.borderInactiveColor = .black
        lastNameTxt.placeholder = "Last name"
        view.addSubview(lastNameTxt)
        lastNameTxt.Anchor(top: nil, bottom: passwordTxt.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 30, bottom: -10, right: -30), size: .init(width: 0, height: 60))
        
        firstNameTxt.tintColor = .white
        firstNameTxt.borderActiveColor = .white
        firstNameTxt.borderInactiveColor = .black
        firstNameTxt.placeholder = "First name"
        view.addSubview(firstNameTxt)
        firstNameTxt.Anchor(top: nil, bottom: lastNameTxt.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 30, bottom: -10, right: -30), size: .init(width: 0, height: 60))
        
        emailTxt.tintColor = .white
        emailTxt.borderActiveColor = .white
        emailTxt.borderInactiveColor = .black
        emailTxt.placeholder = "Email"
        view.addSubview(emailTxt)
        emailTxt.Anchor(top: nil, bottom: firstNameTxt.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 30, bottom: -10, right: -30), size: .init(width: 0, height: 60))
    }
    
    @objc func Back() {
        let vc = SignInVC()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }
}
