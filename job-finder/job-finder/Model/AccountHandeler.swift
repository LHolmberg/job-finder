import Foundation
import Firebase

class AccountHandeler {
    private var email: String
    private var password: String
    private var firstName: String
    private var lastName: String
    private var accountType: String
    
    init(email: String, password: String, firstName: String, lastName: String, accountType: String) {
        self.email = email
        self.password = password
        self.firstName = firstName
        self.lastName = lastName
        self.accountType = accountType
    }
    
    static let instance = DataHandeler()
    
    func RegisterUser(userCreationComplete: @escaping(_ status: Bool, _ error: Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            guard let authDataResult = authDataResult else {
                userCreationComplete(false, error)
                return
            }
            
            let userData = ["provider": authDataResult.user.providerID, "email": authDataResult.user.email, "firstName": self.firstName, "lastName": self.lastName, "accountType": self.accountType]
            DataHandeler.instance.CreateDBUser(uid: authDataResult.user.uid, userData: userData)
            userCreationComplete(true, nil)
        }
    }
    
    func LoginUser(loginComplete: @escaping(_ status: Bool, _ error: Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (_, error) in
            if error != nil {
                loginComplete(false, error)
                return
            }
            
            loginComplete(true, nil)
        }
    }
}
