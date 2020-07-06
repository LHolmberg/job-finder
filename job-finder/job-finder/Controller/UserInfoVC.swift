import UIKit
import Firebase

class UserInfoVC: UIViewController {
    let mainView = UIView()
    
    var userEmail = String()
    var userFirstName = String()
    var userLastName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.2499243319, green: 0.2499725819, blue: 0.2499180138, alpha: 0.7895780457)
        SetupView()
    }
    
    func SetupView() {
        mainView.layer.cornerRadius = 10
        mainView.backgroundColor = .white
        view.addSubview(mainView)
        mainView.Anchor(top: self.view.topAnchor, bottom: self.view.bottomAnchor, leading: self.view.leadingAnchor, trailing: self.view.trailingAnchor, padding: .init(top: 320, left: 20, bottom: -320, right: -20))
        
        let dismissBtn = UIButton()
        dismissBtn.setTitle("X", for: .normal)
        dismissBtn.backgroundColor = .black
        dismissBtn.addTarget(self, action: #selector(Dismiss(_:)), for: .touchUpInside)
        mainView.addSubview(dismissBtn)
        dismissBtn.Anchor(top: mainView.topAnchor, bottom: nil, leading: mainView.leadingAnchor, trailing: nil,padding: .init(top: 25, left: 20, bottom: 0, right: 0) , size: .init(width: 20, height: 20))
        
        let userEmailLbl = UILabel()
        userEmailLbl.text = userEmail
        userEmailLbl.font = UIFont(name: "Avenir-Medium", size: 20)
        userEmailLbl.textColor = .black
        userEmailLbl.textAlignment = .center
        mainView.addSubview(userEmailLbl)
        userEmailLbl.Anchor(top: mainView.topAnchor, bottom: nil, leading: mainView.leadingAnchor, trailing: mainView.trailingAnchor, padding: .init(top: 25, left: 0, bottom: 0, right: 0))
        
        let userFirstNameLbl = UILabel()
        userFirstNameLbl.text = "First Name: " + userFirstName
        userFirstNameLbl.font = UIFont(name: "Avenir", size: 20)
        userFirstNameLbl.textColor = .black
        mainView.addSubview(userFirstNameLbl)
        userFirstNameLbl.Anchor(top: userEmailLbl.topAnchor, bottom: nil, leading: mainView.leadingAnchor, trailing: mainView.trailingAnchor, padding: .init(top: 60, left: 20, bottom: 0, right: 0))
        
        let userLastNameLbl = UILabel()
        userLastNameLbl.text = "Last Name: " + userLastName
        userLastNameLbl.font = UIFont(name: "Avenir", size: 20)
        userLastNameLbl.textColor = .black
        mainView.addSubview(userLastNameLbl)
        userLastNameLbl.Anchor(top: userFirstNameLbl.bottomAnchor, bottom: nil, leading: mainView.leadingAnchor, trailing: mainView.trailingAnchor, padding: .init(top: 20, left: 20, bottom: 0, right: 0))
    }

    @objc func Dismiss(_ button: UIButton) {
        self.view.removeFromSuperview()
    }
}
