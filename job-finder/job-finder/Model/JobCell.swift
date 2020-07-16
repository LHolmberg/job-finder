import UIKit

class JobCell: UICollectionViewCell {
    var jobTitle: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Avenir-Medium", size: 16)
        lbl.textColor = .white
        return lbl
    }()

    var jobLocation: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Avenir", size: 15)
        lbl.textColor = .white
        return lbl
    }()
    
    var jobHourlyRate: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Avenir", size: 15)
        lbl.textColor = .white
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension JobCell {
    fileprivate func Setup() {
        self.addSubview(jobTitle)
        self.addSubview(jobLocation)
        self.addSubview(jobHourlyRate)
        
        jobTitle.Anchor(top: self.topAnchor, bottom: nil, leading: self.leadingAnchor, trailing: self.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 0))
        jobTitle.textAlignment = .center
        
        jobLocation.Anchor(top: jobTitle.bottomAnchor, bottom: nil, leading: self.leadingAnchor, trailing: nil, padding: .init(top: 10, left: 10, bottom: 0, right: 0))
        jobHourlyRate.Anchor(top: jobLocation.bottomAnchor, bottom: nil, leading: self.leadingAnchor, trailing: nil, padding: .init(top: 10, left: 10, bottom: 0, right: 0))
    }
}
