import Foundation
import Firebase

let DB_BASE = Database.database().reference()

class DataHandeler {
    static let instance = DataHandeler()
    
    private var _REF_BASE = DB_BASE
    public var _REF_USERS_ = DB_BASE.child("users")
    
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS_
    }
    
    func CreateDBUser(uid: String, userData: [String: Any]) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func GetUserSnapshot(completion: @escaping ([DataSnapshot]) -> Void) {
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            completion(userSnapshot)
        }
    }
    
    func FindUser(email: String, handler: @escaping (_ value: DataSnapshot, _ success: Bool) -> Void) {
           GetUserSnapshot { (userSnapshot) in
               var foundUser = false
               for user in userSnapshot {
                   let dict = user.value as! [String: Any]
                   if dict["email"] as! String == email {
                       foundUser = true
                       handler(user, foundUser)
                   }
               }
               if foundUser == false {
                   handler(userSnapshot[0], foundUser)
               }
           }
    }
    
    func GetUserAccountType(completion: @escaping (String) -> Void) {
        FindUser(email: Auth.auth().currentUser!.email!) { (user, success) in
            completion(user.childSnapshot(forPath: "accountType").value as! String)
        }
    }
    
    func GetPostedJobs(handler: @escaping (NSDictionary, Bool) -> Void) {
        let a =  DataHandeler.instance.REF_BASE.child("postedJobs")
        var dataList: NSDictionary = NSDictionary()
        
       a.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.childrenCount != 0 {
                dataList = snapshot.value as! NSDictionary
                handler(dataList, true)
            } else {
                handler(dataList, false)
            }
        }
    }
    
    func RemoveApplication(email: String, jobTitle: String) {
        GetPostedJobs { (jobs, _) in
            let a = self.REF_BASE.child("postedJobs")
            a.observeSingleEvent(of: .value) { (snapshot) in
                let dict = snapshot.value as! [String: Any]
                for i in dict {
                    let n = i.value as! [String: Any]
                    if let j = n["applicants"] as? [String: Any] {
                        for k in j {
                            if (k.value as! [String: Any])["email"] as! String == email && n["title"] as! String == jobTitle {
                                for i in jobs {
                                    snapshot.childSnapshot(forPath: i.key as! String).childSnapshot(forPath: "applicants")
                                        .childSnapshot(forPath: k.key).ref.removeValue()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
       
    
    func GetJsonData(url: URL, completion: @escaping ([String: Any]) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, res, err) in
           if let d = data {
                if let value = String(data: d, encoding: String.Encoding.ascii) {

                   if let jsonData = value.data(using: String.Encoding.utf8) {
                       do {
                            let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
                            completion(json)
                       } catch {
                           print("ERROR \(error.localizedDescription)")
                       }
                   }
               }

           }
       }.resume()
    }
}
