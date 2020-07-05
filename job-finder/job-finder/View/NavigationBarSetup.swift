import UIKit

class NavigationBarSetup {
    static let instance = NavigationBarSetup()
    
    func SetupNavbar(view: UIView, navbar: UIView, postedJobsBtn: UIButton, createJobBtn: UIButton, applicationsBtn: UIButton, currentVC: String) {
          view.addSubview(navbar)
          navbar.Anchor(top: view.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, size: .init(width: 0, height: 120))
          navbar.layer.cornerRadius = 15
          
          let createJobImg = UIImage(named: "icons8-create-50-3") as UIImage?
          let postedJobsImg = UIImage(named: "icons8-folder-50") as UIImage?
          let applicationsImg = UIImage(named: "icons8-envelope-50") as UIImage?
          
          postedJobsBtn.setImage(postedJobsImg, for: .normal)
          navbar.addSubview(postedJobsBtn)
          postedJobsBtn.Anchor(top: navbar.topAnchor, bottom: nil, leading: navbar.leadingAnchor, trailing: navbar.trailingAnchor, padding: .init(top: 54, left: 0, bottom: 0, right:  0), size: .init(width: 50, height: 50))
          

          createJobBtn.setImage(createJobImg, for: .normal)
          navbar.addSubview(createJobBtn)
          createJobBtn.Anchor(top: navbar.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: nil, padding: .init(top: 50, left: 50, bottom: 0, right:  0), size: .init(width: 50, height: 50))
          
          applicationsBtn.setImage(applicationsImg, for: .normal)
          navbar.addSubview(applicationsBtn)
          applicationsBtn.Anchor(top: navbar.topAnchor, bottom: nil, leading: nil, trailing: view.trailingAnchor, padding: .init(top: 54, left: 0, bottom: 0, right: -50), size: .init(width: 50, height: 50))

          let selectedView = UIView()
          selectedView.backgroundColor = .white
          navbar.addSubview(selectedView)
          
        if currentVC == "PosterHomeVC" {
            selectedView.Anchor(top: postedJobsBtn.bottomAnchor, bottom: nil, leading: postedJobsBtn.leadingAnchor, trailing: nil, padding: .init(top: 4, left: 46.5, bottom: 0, right: 0), size: .init(width: 50, height: 2))
        } else if currentVC == "PostedJobsVC" {
            selectedView.Anchor(top: postedJobsBtn.bottomAnchor, bottom: nil, leading: postedJobsBtn.leadingAnchor, trailing: nil, padding: .init(top: 4, left: 182, bottom: 0, right: 0), size: .init(width: 50, height: 2))
        } else {
            selectedView.Anchor(top: postedJobsBtn.bottomAnchor, bottom: nil, leading: postedJobsBtn.leadingAnchor, trailing: nil, padding: .init(top: 4, left: view.frame.width - 100, bottom: 0, right: 0), size: .init(width: 50, height: 2))
        }
    }
}
