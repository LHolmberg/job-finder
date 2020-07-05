import UIKit
import Firebase

class ExploreVC: UIViewController {
    
    let navbar = GradientView()
    var newJobsCV: UICollectionView? = nil
    var newJobs = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        SetupNavbar()
        SetupCollectionView()
        SetupBody()
        SetNewJobs()
    }
    
    func SetupNavbar() {
        view.addSubview(navbar)
        navbar.Anchor(top: view.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, size: .init(width: 0, height: 120))
        
        navbar.layer.cornerRadius = 15
        
        let titleLbl = UILabel()
        titleLbl.textAlignment = .center
        titleLbl.font = UIFont.init(name: "Avenir-Medium", size: 25)
        titleLbl.textColor = .white
        titleLbl.text = "Find A New Job"

        navbar.addSubview(titleLbl)
        titleLbl.Anchor(top: navbar.topAnchor, bottom: nil, leading: navbar.leadingAnchor, trailing: navbar.trailingAnchor, padding: .init(top: 60, left: 0, bottom: 0, right:  0))
    }
    
    func SetNewJobs() {
        newJobs = [:]
        DataHandeler.instance.REF_BASE.child("postedJobs").observeSingleEvent(of: .value) { (snapshot) in
            if let snap = snapshot.value as? NSMutableDictionary {
                for i in snap {
                    let data = i.value as! [String: Any]
                    self.newJobs[self.newJobs.count] = data
                }
                self.newJobsCV!.reloadData()
            } else {
                print("Error parsing data")
            }
        }
    }
    
    func SetupBody() {
        let bodyTitleLbl = UILabel()
        bodyTitleLbl.font = UIFont(name: "Avenir-Medium", size: 17)
        bodyTitleLbl.text = "New Jobs"
        view.addSubview(bodyTitleLbl)
        bodyTitleLbl.Anchor(top: navbar.bottomAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: .init(top: 20, left: 15, bottom: 0, right: 0))
        
        let landscapingBtn = UIButton()
        landscapingBtn.setTitle("Landscaping", for: .normal)
        landscapingBtn.backgroundColor = .gray
        landscapingBtn.layer.cornerRadius = 5
        view.addSubview(landscapingBtn)
        landscapingBtn.Anchor(top: nil, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: nil, padding: .init(top: 0, left: 15, bottom: -90, right: 0),size: .init(width: self.view.frame.width / 2.3, height: self.view.frame.width / 2.1))
        
        let btn2 = UIButton()
        btn2.setTitle("Landscaping", for: .normal)
             btn2.backgroundColor = .gray
        btn2.layer.cornerRadius = 5
             view.addSubview(btn2)
        btn2.Anchor(top: nil, bottom: view.bottomAnchor, leading: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: -90, right: -15),size: .init(width: self.view.frame.width / 2.3, height: self.view.frame.width / 2.1))
        
        let electricityBtn = UIButton()
        electricityBtn.setTitle("Electricity", for: .normal)
        electricityBtn.backgroundColor = .gray
        electricityBtn.layer.cornerRadius = 5
        view.addSubview(electricityBtn)
        electricityBtn.Anchor(top: nil, bottom: landscapingBtn.topAnchor, leading: view.leadingAnchor, trailing: nil, padding: .init(top: 0, left: 15, bottom: -30, right: 0),size: .init(width: self.view.frame.width / 2.3, height: self.view.frame.width / 2.1))
        
        let btn4 = UIButton()
        btn4.setTitle("Landscaping", for: .normal)
             btn4.backgroundColor = .gray
        btn4.layer.cornerRadius = 5
             view.addSubview(btn4)
        btn4.Anchor(top: nil, bottom: btn2.topAnchor, leading: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: -30, right: -15),size: .init(width: self.view.frame.width / 2.3, height: self.view.frame.width / 2.1))
        
        let infoLbl = UILabel()
        infoLbl.font = UIFont(name: "Avenir-Medium", size: 17)
        infoLbl.text = "Explore Jobs Within Your Expertise"
        view.addSubview(infoLbl)
        infoLbl.Anchor(top: nil, bottom: electricityBtn.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 15, bottom: -15, right: 0))
        
        let signOutBtn = UIButton()
        signOutBtn.addTarget(self, action: #selector(SignOut), for: .touchUpInside)
        let signOutBtnAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Avenir-Medium", size: 20),
            .foregroundColor: UIColor.black,
        ]
        signOutBtn.setAttributedTitle(NSAttributedString(string: "Sign Out", attributes: signOutBtnAttributes), for: .normal)
        view.addSubview(signOutBtn)
        signOutBtn.Anchor(top: nil, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: -30, right: 0))
    }
    
    @objc func SignOut() {
        do {
            try! Auth.auth().signOut()
            let vc = SignInVC()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    func SetupCollectionView() { // for recommended jobs
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 200, height: 130)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20

        newJobsCV = UICollectionView(frame: CGRect(x: 0, y: 165, width: view.frame.width, height: 140), collectionViewLayout: layout)
        if let newJobsCV = newJobsCV {
            newJobsCV.register(JobCell.self, forCellWithReuseIdentifier: "MyCell")
            newJobsCV.isPagingEnabled = true
            newJobsCV.backgroundColor = UIColor.white
            newJobsCV.dataSource = self
            newJobsCV.delegate = self
            
            view.addSubview(newJobsCV)
        }
    }
}

extension ExploreVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newJobs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! JobCell
        let data = Array(newJobs)[indexPath.row].value as! [String: Any]
        myCell.jobTitle.text = data["title"] as! String
        myCell.jobLocation.text = (data["location"] as! [String: Any])["literal"] as! String
        myCell.jobHourlyRate.text = data["salary"] as! String + " $/hr"
        myCell.backgroundColor = #colorLiteral(red: 0.912365973, green: 0.9125189185, blue: 0.9123458266, alpha: 1)
        myCell.layer.cornerRadius = 10
        
        return myCell
    }
}

extension ExploreVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = Array(newJobs)[indexPath.row].value as! [String: Any]
        let popover = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "jobListing") as! JobListingVC
        
        popover.jobLatt = (data["location"] as! [String: Any])["latt"] as! String
        popover.jobLongt = (data["location"] as! [String: Any])["longt"] as! String
        popover.jobTitle = data["title"] as! String
        popover.jobDescription = data["description"] as! String
        popover.jobSalary = data["salary"] as! String
        popover.jobPoster = data["jobPoster"] as! String
        popover.jobID = indexPath.row
        
        self.addChild(popover)
        popover.view.frame = self.view.frame
        self.view.addSubview(popover.view)
        popover.didMove(toParent: self)
    }
}
