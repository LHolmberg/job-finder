import UIKit
import MapKit
import Firebase

class JobListingVC: UIViewController {
    
    var jobLatt = String()
    var jobLongt = String()
    var jobTitle = String()
    var jobSalary = String()
    var jobPoster = String()
    var jobDescription = String()
    var jobID = Int()
    
    let mainView = UIView()
    let mapView = MKMapView()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.2499243319, green: 0.2499725819, blue: 0.2499180138, alpha: 0.7895780457)
        SetupView()
        SetupBody()
        
        if CLLocationManager.locationServicesEnabled() {
            CheckLocationAuthorization()
        } else {
            print("Location error")
        }
    }
    
    func GetDistanceToJob() -> Double {
        let loc1 = CLLocation(latitude: Double(jobLatt)!, longitude: Double(jobLongt)!)
        
        return (locationManager.location?.distance(from: loc1))! / 1000
    }
    
    func ZoomToJobLocation() {
        let jobLatitude = Double(jobLatt)
        let jobLongitude = Double(jobLongt)
        
        mapView.showsUserLocation = true
        
        let jobAnnotation = MKPointAnnotation()
        jobAnnotation.title = "Job"
        jobAnnotation.coordinate = CLLocationCoordinate2D(latitude: jobLatitude!, longitude: jobLongitude!)
        mapView.addAnnotation(jobAnnotation)
        
        let span = MKCoordinateSpan.init(latitudeDelta: 0.01, longitudeDelta:
              0.01)
        let coordinate = CLLocationCoordinate2D.init(latitude: jobLatitude!, longitude: jobLongitude!)
        let region = MKCoordinateRegion.init(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func CheckLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
            case .authorizedWhenInUse:
                ZoomToJobLocation()
            case .denied:
                break
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                ZoomToJobLocation()
            case .restricted:
                break
            case .authorizedAlways:
                break
            @unknown default:
                fatalError()
        }
    }
    
    func SetupView() {
        mainView.layer.cornerRadius = 10
        mainView.backgroundColor = .white
        view.addSubview(mainView)
        mainView.Anchor(top: self.view.topAnchor, bottom: self.view.bottomAnchor, leading: self.view.leadingAnchor, trailing: self.view.trailingAnchor, padding: .init(top: 100, left: 20, bottom: -100, right: -20))
        
        mainView.addSubview(mapView)
        mapView.Anchor(top: mainView.topAnchor, bottom: mainView.bottomAnchor, leading: mainView.leadingAnchor, trailing: mainView.trailingAnchor, padding: .init(top: 60, left: 0, bottom: -350, right: 0))
        
        let dismissBtn = UIButton()
        dismissBtn.setTitle("X", for: .normal)
        dismissBtn.backgroundColor = .black
        dismissBtn.addTarget(self, action: #selector(Dismiss(_:)), for: .touchUpInside)
        mainView.addSubview(dismissBtn)
        dismissBtn.Anchor(top: mainView.topAnchor, bottom: nil, leading: mainView.leadingAnchor, trailing: nil,padding: .init(top: 25, left: 20, bottom: 0, right: 0) , size: .init(width: 20, height: 20))
        
        let titleLbl = UILabel()
        titleLbl.text = jobTitle
        titleLbl.font = UIFont(name: "Avenir-Medium", size: 20)
        titleLbl.textAlignment = .center
        mainView.addSubview(titleLbl)
        titleLbl.Anchor(top: mainView.topAnchor, bottom: nil, leading: mainView.leadingAnchor, trailing: mainView.trailingAnchor, padding: .init(top: 25, left: 0, bottom: 0, right: 0))
        
    }
    
    func SetupBody() {
        let infoLbl = UILabel()
        infoLbl.font = UIFont(name: "Avenir", size: 20)
        infoLbl.text = "Information About The Job"
        infoLbl.textAlignment = .center
        mainView.addSubview(infoLbl)
        infoLbl.Anchor(top: mapView.bottomAnchor, bottom: nil, leading: mainView.leadingAnchor, trailing: mainView.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0))
        
        let jobPosterLbl = UILabel()
        jobPosterLbl.font = UIFont(name: "Avenir", size: 15)
        jobPosterLbl.text = "Job Poster: " + jobPoster
        mainView.addSubview(jobPosterLbl)
        jobPosterLbl.Anchor(top: infoLbl.bottomAnchor, bottom: nil, leading: mainView.leadingAnchor, trailing: nil, padding: .init(top: 20, left: 20, bottom: 0, right: 0))
        
        let jobSalaryLbl = UILabel()
        jobSalaryLbl.font = UIFont(name: "Avenir", size: 15)
        jobSalaryLbl.text = "Hourly Rate: " + jobSalary + " $/hr"
        mainView.addSubview(jobSalaryLbl)
        jobSalaryLbl.Anchor(top: jobPosterLbl.bottomAnchor, bottom: nil, leading: mainView.leadingAnchor, trailing: nil, padding: .init(top: 15, left: 20, bottom: 0, right: 0))
        
        let jobDistanceLbl = UILabel()
        jobDistanceLbl.font = UIFont(name: "Avenir", size: 15)
        jobDistanceLbl.text = "Distance To The Job: " + String(GetDistanceToJob().rounded()) + " km"
        mainView.addSubview(jobDistanceLbl)
        jobDistanceLbl.Anchor(top: jobSalaryLbl.bottomAnchor, bottom: nil, leading: mainView.leadingAnchor, trailing: nil, padding: .init(top: 15, left: 20, bottom: 0, right: 0))
        
        let jobDescriptionLbl = VerticalAlignedLabel()
        jobDescriptionLbl.numberOfLines = 10
        jobDescriptionLbl.font = UIFont(name: "Avenir", size: 15)
        jobDescriptionLbl.text = "Job Description: " + jobDescription
        mainView.addSubview(jobDescriptionLbl)
        jobDescriptionLbl.Anchor(top: jobDistanceLbl.bottomAnchor, bottom: nil, leading: mainView.leadingAnchor, trailing: mainView.trailingAnchor, padding: .init(top: 15, left: 20, bottom: 0, right: -20))
        
        
        let applyBtn = UIButton()
        applyBtn.setTitle("Apply", for: .normal)
        applyBtn.addTarget(self, action: #selector(ApplyToJob), for: .touchUpInside)
        applyBtn.backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
        applyBtn.layer.cornerRadius = 10
        mainView.addSubview(applyBtn)
        applyBtn.Anchor(top: nil, bottom: mainView.bottomAnchor, leading: mainView.leadingAnchor, trailing: mainView.trailingAnchor, size: .init(width: 0, height: 55))
    }
    
    @objc func ApplyToJob() {
        DataHandeler.instance.GetPostedJobs { jobs, success in
            if success {
                let hashID = (Array(jobs)[self.jobID]).key as! String
                DataHandeler.instance.REF_BASE.child("postedJobs").child(hashID).child("applicants")
                    .updateChildValues(["email": Auth.auth().currentUser!.email!])
                self.view.removeFromSuperview()
            }
        }
    }
    
    @objc func Dismiss(_ button: UIButton) {
        self.view.removeFromSuperview()
    }

}
