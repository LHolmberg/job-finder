import UIKit
import Firebase

class CreateJobVC: UIViewController {
    let navbar = GradientView()
    
    let jobLocationTxt = TextFieldDesign()
    let jobTitleTxt = TextFieldDesign()
    let jobSalaryTxt = TextFieldDesign()
    let jobDescriptionTxt = TextFieldDesign()
    
    let postedJobsBtn = UIButton(type: .custom) as UIButton
    let applicationsBtn = UIButton(type: .custom) as UIButton
    let createJobBtn = UIButton(type: .custom) as UIButton
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        NavigationBarSetup.instance.SetupNavbar(view: self.view, navbar: navbar, postedJobsBtn: postedJobsBtn, createJobBtn: createJobBtn, applicationsBtn: applicationsBtn, currentVC: "PosterHomeVC")
        SetupBody()
        Initialize()
    }
    
    func Initialize() {
        self.postedJobsBtn.addTarget(self, action: #selector(PresentPostedJobsVC), for: .touchUpInside)
        self.applicationsBtn.addTarget(self, action: #selector(PresentApplicantsVC), for: .touchUpInside)
    }
    
    @objc func PresentPostedJobsVC() {
        let vc = PostedJobsVC()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    @objc func PresentApplicantsVC() {
        let vc = ShowApplicantsVC()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }

  
    func SetupBody() {
        let viewTitleLbl = UILabel()
        viewTitleLbl.text = "Post A New Job"
        viewTitleLbl.font = UIFont(name: "Avenir-Medium", size: 20)
        viewTitleLbl.textAlignment = .center
        viewTitleLbl.textColor = .black
        view.addSubview(viewTitleLbl)
        viewTitleLbl.Anchor(top: navbar.bottomAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0))
        
        jobTitleTxt.tintColor = .black
        jobTitleTxt.placeholder = "Job Title"
        jobTitleTxt.borderActiveColor = .black
        jobTitleTxt.borderInactiveColor = .black
        view.addSubview(jobTitleTxt)
        jobTitleTxt.Anchor(top: viewTitleLbl.bottomAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 30, bottom: -25, right: -30), size: .init(width: 0, height: 60))
        
        
        jobLocationTxt.tintColor = .black
        jobLocationTxt.placeholder = "Job Location"
        jobLocationTxt.borderActiveColor = .black
        jobLocationTxt.borderInactiveColor = .black
        view.addSubview(jobLocationTxt)
        jobLocationTxt.Anchor(top: jobTitleTxt.bottomAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 30, bottom: -25, right: -30), size: .init(width: 0, height: 60))
        
        
        jobSalaryTxt.keyboardType = .numberPad
        jobSalaryTxt.tintColor = .black
        jobSalaryTxt.placeholder = "I am willing to pay: ($ / hr)"
        jobSalaryTxt.borderActiveColor = .black
        jobSalaryTxt.borderInactiveColor = .black
        view.addSubview(jobSalaryTxt)
        jobSalaryTxt.Anchor(top: jobLocationTxt.bottomAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 30, bottom: -25, right: -30), size: .init(width: 0, height: 60))
        
        jobDescriptionTxt.tintColor = .black
        jobDescriptionTxt.placeholder = "Job Description"
        jobDescriptionTxt.borderActiveColor = .black
        jobDescriptionTxt.borderInactiveColor = .black
        view.addSubview(jobDescriptionTxt)
        jobDescriptionTxt.Anchor(top: jobSalaryTxt.bottomAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 30, bottom: -25, right: -30), size: .init(width: 0, height: 60))
        
        let createJobBtn = UIButton()
        createJobBtn.backgroundColor = .black
        createJobBtn.layer.cornerRadius = 15
        createJobBtn.setTitle("Post Job", for: .normal)
        createJobBtn.addTarget(self, action: #selector(CreateJob), for: .touchUpInside)
        view.addSubview(createJobBtn)
        createJobBtn.Anchor(top: jobDescriptionTxt.bottomAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: .init(top: 30, left: 20, bottom: 0, right: -20), size: .init(width: 0, height: 65))
        
        let signOutBtn = UIButton()
        let signOutBtnAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Avenir-Medium", size: 20),
            .foregroundColor: UIColor.black,
        ]
        signOutBtn.setAttributedTitle(NSAttributedString(string: "Sign Out", attributes: signOutBtnAttributes), for: .normal)
        signOutBtn.addTarget(self, action: #selector(SignOut), for: .touchUpInside)
        view.addSubview(signOutBtn)
        signOutBtn.Anchor(top: nil, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 20, bottom: -30, right: -20), size: .init(width: 0, height: 65))
    }
    
    @objc func SignOut() {
        do {
            try! Auth.auth().signOut()
            let vc = SignInVC()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    @objc func CreateJob() {
        let url = URL(string: "https://geocode.xyz/" + jobLocationTxt.text! + "?json=1")
        DataHandeler.instance.GetJsonData(url: url!) { val in
            let latitude = val["latt"] as! String
            let longitude = val["longt"] as! String
            DispatchQueue.main.async {
                if self.jobLocationTxt.text != "" && self.jobTitleTxt.text != "" && self.jobSalaryTxt.text != "" && self.jobDescriptionTxt.text != "" {
                    if !latitude.contains(".000") {
                        DataHandeler.instance.FindUser(email: Auth.auth().currentUser!.email!) { user, success  in
                            if success {
                                let job = DataHandeler.instance.REF_BASE.child("postedJobs").child(UUID().uuidString)
                                job.updateChildValues(["title": self.jobTitleTxt.text!])
                                job.child("location").updateChildValues(["latt": latitude])
                                job.child("location").updateChildValues(["longt": longitude])
                                job.child("location").updateChildValues(["literal": self.jobLocationTxt.text!])
                                job.updateChildValues(["salary": self.jobSalaryTxt.text!])
                                job.updateChildValues(["description": self.jobDescriptionTxt.text!])
                                job.updateChildValues(["jobPoster": Auth.auth().currentUser!.email!])
                                
                                let alert = UIAlertController(title: "Success", message: "You successfully posted a new job! You can edit/remove the job in your posted jobs section.", preferredStyle: .alert)
                                 alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                                     NSLog("The \"OK\" alert occured.")
                                }))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    } else { // Error parsing job location
                        let alert = UIAlertController(title: "Error", message: "Problem handeling your location, please scale up geographically.", preferredStyle: .alert)
                         alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                             NSLog("The \"OK\" alert occured.")
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                } else {
                    print("Enter all fields")
                }
            }
        }
    }
    
}
