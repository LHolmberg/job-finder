import UIKit
import Firebase

class EditJobVC: UIViewController {
    let mainView = UIView()
    
    var jobTitle = String()
    var jobLocation = String()
    var jobSalary = String()
    var jobDescription = String()
    
    var jobIndex = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.2499243319, green: 0.2499725819, blue: 0.2499180138, alpha: 0.7895780457)
        SetupView()
        SetupBody()
    }
    
    func SetupView() {
        mainView.layer.cornerRadius = 10
        mainView.backgroundColor = .white
        view.addSubview(mainView)
        mainView.Anchor(top: self.view.topAnchor, bottom: self.view.bottomAnchor, leading: self.view.leadingAnchor, trailing: self.view.trailingAnchor, padding: .init(top: 250, left: 20, bottom: -250, right: -20))
        
        let dismissBtn = UIButton()
        dismissBtn.setTitle("X", for: .normal)
        dismissBtn.backgroundColor = .black
        dismissBtn.addTarget(self, action: #selector(Dismiss(_:)), for: .touchUpInside)
        mainView.addSubview(dismissBtn)
        dismissBtn.Anchor(top: mainView.topAnchor, bottom: nil, leading: mainView.leadingAnchor, trailing: nil,padding: .init(top: 25, left: 20, bottom: 0, right: 0) , size: .init(width: 20, height: 20))
        
        let titleLbl = UILabel()
        titleLbl.text = jobTitle
        titleLbl.font = UIFont(name: "Avenir-Medium", size: 20)
        titleLbl.textColor = .black
        titleLbl.textAlignment = .center
        mainView.addSubview(titleLbl)
        titleLbl.Anchor(top: mainView.topAnchor, bottom: nil, leading: mainView.leadingAnchor, trailing: mainView.trailingAnchor, padding: .init(top: 25, left: 0, bottom: 0, right: 0))
        
        let locationLbl = UILabel()
        locationLbl.text = "Job Location: " + jobLocation
        locationLbl.font = UIFont(name: "Avenir", size: 20)
        locationLbl.textColor = .black
        mainView.addSubview(locationLbl)
        locationLbl.Anchor(top: titleLbl.topAnchor, bottom: nil, leading: mainView.leadingAnchor, trailing: mainView.trailingAnchor, padding: .init(top: 60, left: 20, bottom: 0, right: 0))
        
        let salaryLbl = UILabel()
        salaryLbl.text = "Hourly rate: " + jobSalary
        salaryLbl.font = UIFont(name: "Avenir", size: 20)
        salaryLbl.textColor = .black
        mainView.addSubview(salaryLbl)
        salaryLbl.Anchor(top: locationLbl.bottomAnchor, bottom: nil, leading: mainView.leadingAnchor, trailing: mainView.trailingAnchor, padding: .init(top: 20, left: 20, bottom: 0, right: 0))
        
        let descriptionLbl = VerticalAlignedLabel()
        descriptionLbl.text = "Job Description: " + jobDescription
        descriptionLbl.font = UIFont(name: "Avenir", size: 20)
        descriptionLbl.numberOfLines = 10
        descriptionLbl.textColor = .black
        mainView.addSubview(descriptionLbl)
        descriptionLbl.Anchor(top: salaryLbl.bottomAnchor, bottom: nil, leading: mainView.leadingAnchor, trailing: mainView.trailingAnchor, padding: .init(top: 20, left: 20, bottom: 0, right: -20), size: .init(width: 0, height: 200))
        descriptionLbl.sizeToFit()
    }
    
    func SetupBody() {
        let removeJobBtn = UIButton()
        removeJobBtn.setTitle("Remove Job", for: .normal)
        removeJobBtn.addTarget(self, action: #selector(RemoveJob), for: .touchUpInside)
        removeJobBtn.backgroundColor = #colorLiteral(red: 0.7338394657, green: 0, blue: 0.07439097849, alpha: 1)
        removeJobBtn.layer.cornerRadius = 10
        mainView.addSubview(removeJobBtn)
        removeJobBtn.Anchor(top: nil, bottom: mainView.bottomAnchor, leading: mainView.leadingAnchor, trailing: mainView.trailingAnchor, size: .init(width: 0, height: 55))
    }
    
    @objc func RemoveJob() {
        DataHandeler.instance.REF_BASE.child("postedJobs").observeSingleEvent(of: .value) { (snapshot) in
            var n = 0
            for i in snapshot.value as! NSDictionary {
                if n == self.jobIndex {
                    let parentVC = (self.parent)! as! PostedJobsVC
                    snapshot.childSnapshot(forPath: i.key as! String).ref.removeValue()
                    
                    print("Job successfully removed")
                    
                    parentVC.SetMyPostedJobs()
                    parentVC.postedJobsCV!.reloadData()
                    self.view.removeFromSuperview()
                }
                n += 1
            }
        }
    }
    
    @objc func Dismiss(_ button: UIButton) {
        self.view.removeFromSuperview()
    }
}
