import UIKit
import Firebase

class ShowApplicantsVC: UIViewController {
    let postedJobsBtn = UIButton(type: .custom) as UIButton
    let applicationsBtn = UIButton(type: .custom) as UIButton
    let createJobBtn = UIButton(type: .custom) as UIButton
    let navbar = GradientView()
    
    var applicants: NSMutableDictionary = NSMutableDictionary()
    var applicantsCV: UICollectionView? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        NavigationBarSetup.instance.SetupNavbar(view: view, navbar: navbar, postedJobsBtn: postedJobsBtn, createJobBtn: createJobBtn, applicationsBtn: applicationsBtn, currentVC: "ShowApplicantsVC")
        Initialize()
        SetupBody()
        SetMyPostedJobs()
        SetupCollectionView()
    }
    
    func Initialize() {
        createJobBtn.addTarget(self, action: #selector(PresentCreateJobVC), for: .touchUpInside)
        postedJobsBtn.addTarget(self, action: #selector(PresentPostedJobsVC), for: .touchUpInside)
    }
    
    @objc func PresentCreateJobVC() {
        let vc = CreateJobVC()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    @objc func PresentPostedJobsVC() {
        let vc = PostedJobsVC()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    func SetMyPostedJobs() {
        applicants = [:]
        DataHandeler.instance.REF_BASE.child("postedJobs").observeSingleEvent(of: .value) { (snapshot) in
            if let snap = snapshot.value as? NSMutableDictionary {
                for i in snap {
                    let data = i.value as! [String: Any]
                    if data["jobPoster"] as! String == Auth.auth().currentUser!.email! {
                        let apps = data["applicants"] as! [String: Any]
                        self.applicants[self.applicants.count] = apps
                    }
                }
                self.applicantsCV!.reloadData()
            } else {
                print("Error parsing data")
            }
        }
    }
    
    func SetupBody() {
        let viewTitleLbl = UILabel()
        viewTitleLbl.text = "Applicants"
        viewTitleLbl.font = UIFont(name: "Avenir-Medium", size: 20)
        viewTitleLbl.textAlignment = .center
        viewTitleLbl.textColor = .black
        view.addSubview(viewTitleLbl)
        viewTitleLbl.Anchor(top: navbar.bottomAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0))
    }
    
    func SetupCollectionView() { // All of the users posted jobs
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: self.view.frame.width / 1.2, height: 65)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20

        applicantsCV = UICollectionView(frame: CGRect(x: 0, y: 180, width: view.frame.width, height: self.view.frame.height - 180), collectionViewLayout: layout)
        if let postedJobsCV = applicantsCV {
            postedJobsCV.register(ApplicantCell.self, forCellWithReuseIdentifier: "ApplCell")
            postedJobsCV.isPagingEnabled = true
            postedJobsCV.backgroundColor = UIColor.white
            postedJobsCV.dataSource = self
            postedJobsCV.delegate = self
            
            view.addSubview(postedJobsCV)
        }
    }
    
    @objc func ShowUserInfo() {
        print("Hello")
    }
}

extension ShowApplicantsVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return applicants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ApplCell", for: indexPath) as! ApplicantCell
        
        let data = Array(applicants)[indexPath.row].value as! [String: Any]
        myCell.applicantEmail.text = data["email"] as! String
        myCell.applicantInfo.addTarget(self, action: #selector(ShowUserInfo), for: .touchUpInside)
        
        myCell.backgroundColor = #colorLiteral(red: 0.912365973, green: 0.9125189185, blue: 0.9123458266, alpha: 1)
        myCell.layer.cornerRadius = 10
        
        return myCell
    }
}

extension ShowApplicantsVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as! JobCell
        let data = Array(applicants)[indexPath.row].value as! [String: Any]
        
        let popover = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "editJob") as! EditJobVC
        popover.jobTitle = selectedCell.jobTitle.text!
        popover.jobLocation = selectedCell.jobLocation.text!
        popover.jobSalary = selectedCell.jobHourlyRate.text!
        popover.jobDescription = data["description"] as! String
        popover.jobIndex = indexPath.row
        
        self.addChild(popover)
        popover.view.frame = self.view.frame
        self.view.addSubview(popover.view)
        popover.didMove(toParent: self)
    }
}

