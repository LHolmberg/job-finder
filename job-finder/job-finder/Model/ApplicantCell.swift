import UIKit

class ApplicantCell: UICollectionViewCell {
    var applicantEmail: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Avenir", size: 17)
        return lbl
    }()
    
    var applicantInfo = UIButton(type: .custom)
    var acceptApplicant = UIButton(type: .custom)
    var declineApplicant = UIButton(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ApplicantCell {
    fileprivate func Setup() {
        applicantInfo.setImage(UIImage(named: "icons8-info-50"), for: .normal)
        acceptApplicant.setImage(UIImage(named: "icons8-checkmark-yes-32"), for: .normal)
        declineApplicant.setImage(UIImage(named: "icons8-macos-close-32"), for: .normal)
        self.addSubview(applicantEmail)
        self.addSubview(applicantInfo)
        self.addSubview(acceptApplicant)
        self.addSubview(declineApplicant)
        
        applicantEmail.Anchor(top: self.topAnchor, bottom: nil, leading: self.leadingAnchor, trailing: self.trailingAnchor, padding: .init(top: 22, left: 20, bottom: 0, right: 0))
        applicantInfo.Anchor(top: self.topAnchor, bottom: nil, leading: nil, trailing: self.trailingAnchor, padding: .init(top: 18, left: 0, bottom: 0, right: -5), size: .init(width: 30, height: 30))
        acceptApplicant.Anchor(top: self.topAnchor, bottom: nil, leading: nil, trailing: self.trailingAnchor, padding: .init(top: 18, left: 0, bottom: 0, right: -60), size: .init(width: 30, height: 30))
        declineApplicant.Anchor(top: self.topAnchor, bottom: nil, leading: nil, trailing: self.trailingAnchor, padding: .init(top: 18, left: 0, bottom: 0, right: -95), size: .init(width: 30, height: 30))
    }
}
