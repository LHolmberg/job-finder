import UIKit
import Firebase

class ShowApplicantsVC: UIViewController {
    let postedJobsBtn = UIButton(type: .custom) as UIButton
    let applicationsBtn = UIButton(type: .custom) as UIButton
    let createJobBtn = UIButton(type: .custom) as UIButton
    let navbar = GradientView()
    
    var applicants: NSMutableDictionary = NSMutableDictionary()
    var applicantsCV: UICollectionView? = nil
    
    var selectedCellIndex = 1

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
                    if data["jobPoster"] as! String == Auth.auth().currentUser!.email! && data["applicants"] != nil {
                        for i in data["applicants"] as! [String: Any] {
                            self.applicants[self.applicants.count] = [i.value, ["title": data["title"]]] as! [[String: Any]]
                        }
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
        layout.itemSize = CGSize(width: self.view.frame.width / 1.2, height: 130)
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
    
    @objc func ShowUserInfo(_ sender: UIButton) {
        let selectedCellData = (Array(self.applicants)[sender.tag]).value as! [[String: Any]]
        let selectedApplicant = selectedCellData[0]["email"] as! String
        
        DataHandeler.instance.FindUser(email: selectedApplicant) { user, success in
            if success {
                let popover = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "userInfo") as! UserInfoVC
                popover.userEmail = user.childSnapshot(forPath: "email").value as! String
                popover.userFirstName = user.childSnapshot(forPath: "firstName").value as! String
                popover.userLastName = user.childSnapshot(forPath: "lastName").value as! String
                self.addChild(popover)
                popover.view.frame = self.view.frame
                self.view.addSubview(popover.view)
                popover.didMove(toParent: self)
            }
        }
    }
    
    @objc func AcceptApplicant(_ sender: UIButton) {
        // TO-DO HERE:
        // - Fix a system for accepting applicants (eg. a chat system where you can get to earn more trust and give more detailed address information)
    }
    
    
    @objc func DeclineApplicant(_ sender: UIButton) {
        DataHandeler.instance.GetPostedJobs { res, success in
            if success {
                let selectedCellData = (Array(self.applicants)[sender.tag]).value as! [[String: Any]]
                let selectedApplicant = selectedCellData[0]["email"] as! String
                let selectedTitle = selectedCellData[1]["title"] as! String
                
                for i in res {
                    let data = i.value as! [String: Any]
                    if let apps = data["applicants"] as? [String: Any] {
                        let title = data["title"] as! String
                        for n in apps.values {
                            if selectedApplicant == (n as! [String: Any])["email"] as! String && title == selectedTitle {
                                DataHandeler.instance.RemoveApplication(email: selectedApplicant, jobTitle: selectedTitle)
                                self.applicantsCV!.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
}

extension ShowApplicantsVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return applicants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ApplCell", for: indexPath) as! ApplicantCell
        
        let data = Array(applicants)[indexPath.row].value as! [[String: Any]]
        
        myCell.applicantEmail.text = "Applicant: " + String(data[0]["email"] as! String)
        myCell.applicantJob.text = "Job: " + String(data[1]["title"] as! String)

        myCell.applicantJob.tag = indexPath.row
        myCell.acceptApplicant.tag = indexPath.row
        myCell.declineApplicant.tag = indexPath.row

        myCell.applicantInfo.addTarget(self, action: #selector(ShowUserInfo(_ :)), for: .touchUpInside)
        myCell.acceptApplicant.addTarget(self, action: #selector(AcceptApplicant(_ :)), for: .touchUpInside)
        myCell.declineApplicant.addTarget(self, action: #selector(DeclineApplicant(_ :)), for: .touchUpInside)

        let gradientView = GradientView()
        gradientView.topColor =  #colorLiteral(red: 0.04548885673, green: 0.1401814222, blue: 0.1931747198, alpha: 1)
        gradientView.bottomColor = #colorLiteral(red: 0.07231562585, green: 0.1956573427, blue: 0.2803950608, alpha: 1)
        myCell.backgroundView = gradientView
        myCell.backgroundView!.layer.cornerRadius = 10

        return myCell
    }
}

extension ShowApplicantsVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCellIndex = indexPath.row
    }
}

