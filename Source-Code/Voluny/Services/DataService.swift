//
//  DataService.swift
//  Voluny
//


import Foundation
import Firebase
import FirebaseStorage

let DB_BASE = Database.database().reference()
let ST_BASE = Storage.storage().reference()

class DataService{
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_EXPERIENCES = DB_BASE.child("experiences")
    private var _REF_REVIEWS = DB_BASE.child("reviews")
    private var _REF_CATEGORIES = DB_BASE.child("categories")
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_NOTIFICATIONS = DB_BASE.child("notifications")
    private var _REF_RECRUITERS = DB_BASE.child("recruiters")
    private var _REF_CITIESS = DB_BASE.child("cities")
    
    private var _ST_PROFILE = ST_BASE.child("profile_images")
    private var _ST_ICONS = ST_BASE.child("Experiences_Icon")
    private var _ST_BANNERS = ST_BASE.child("Experiences_Banner")
    
    var ST_BANNERS: StorageReference{
        return _ST_BANNERS
    }
    
    var ST_ICONS: StorageReference{
        return _ST_ICONS
    }
    
    var REF_BASE: DatabaseReference{
        return _REF_BASE
    }
    
    var REF_CITIES: DatabaseReference{
        return _REF_CITIESS
    }
    
    var REF_EXPERIENCES: DatabaseReference{
        return _REF_EXPERIENCES
    }
    
    var REF_REVIEWS: DatabaseReference{
        return _REF_REVIEWS
    }
    
    var REF_CATEGORIES: DatabaseReference{
        return _REF_CATEGORIES
    }
    
    var REF_USERS: DatabaseReference{
        return _REF_USERS
    }
    
    var ST_USERS: StorageReference{
        return _ST_PROFILE
    }
    
    var REF_NOTIFICATIONS: DatabaseReference{
        return _REF_NOTIFICATIONS
    }
    
    var REF_RECRUITERS: DatabaseReference{
        return _REF_RECRUITERS
    }
    
    func createUser(uid: String, userData: Dictionary<String, Any>, userImage: UIImage, handler: @escaping() ->() ){
        REF_USERS.child(uid).updateChildValues(userData)
        
        if let imageData = userImage.jpegData(compressionQuality: 1.0){
            let imageUID = NSUUID().uuidString
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            ST_USERS.child(uid).child(imageUID).putData(imageData, metadata: metadata, completion: { (metadata, error) in
                if error != nil{
                    print("Unable to upload image to Firebase storage: ", String(describing: error))
                }else{
                    print("Successfully uploaded image to Firebase")
                    if let url = metadata?.downloadURL()?.absoluteString{
                        self.REF_USERS.child(uid).child("profilePicture").setValue(url)
                        handler()
                    }
                }
            })
        }
    }
    
    func createExperience(uid: String, userData: Dictionary<String, Any>, iconImage: UIImage, bannerImage: UIImage, handler: @escaping(_ success: Bool) ->() ){
        
        REF_RECRUITERS.child(uid).child("organization").observeSingleEvent(of: .value) { (snapshot) in
            var orgName = ""
            if let name = snapshot.value as? String{
                orgName = name
            }
            let newExp = self.REF_EXPERIENCES.childByAutoId()
            let key = newExp.key
            self.REF_CITIES.child(userData["city"] as! String).child(key).setValue(true)
            print("uploading exp..")
            newExp.updateChildValues(userData)
            newExp.child("location").setValue(orgName)
            var category:String = userData["category"] as! String
            category = category.uppercased()
            self.REF_CATEGORIES.child(category).child(key).setValue(true)
            self.REF_RECRUITERS.child(uid).child("activeExperiences").child(key).setValue(true)
            
            if let imageData1 = iconImage.jpegData(compressionQuality: 0.2){
                let imageUID1 = NSUUID().uuidString
                let metadata1 = StorageMetadata()
                metadata1.contentType = "image/jpeg"
                
                self.ST_ICONS.child(imageUID1).putData(imageData1, metadata: metadata1, completion: { (metadata1, error1) in
                    if error1 != nil{
                        print("Unable to upload image to Firebase storage: ", String(describing: error1))
                    }else{
                        print("Successfully uploaded image to Firebase")
                        if let url1 = metadata1?.downloadURL()?.absoluteString{
                            newExp.child("iconPhoto").setValue(url1)
                        }
                        if let imageData2 = bannerImage.jpegData(compressionQuality: 0.2){
                            let imageUID2 = NSUUID().uuidString
                            let metadata2 = StorageMetadata()
                            metadata2.contentType = "image/jpeg"
                            
                            self.ST_BANNERS.child(imageUID2).putData(imageData2, metadata: metadata2, completion: { (metadata2, error2) in
                                if error2 != nil{
                                    print("Unable to upload image to Firebase storage: ", String(describing: error2))
                                    handler(false)
                                }else{
                                    print("Successfully uploaded image to Firebase")
                                    if let url2 = metadata2?.downloadURL()?.absoluteString{
                                        newExp.child("bannerPhoto").setValue(url2)
                                        handler(true)
                                }
                            }
                        })
                    }
                  }
                })
            }
        }
    }
    
    func createRecruiter(uid: String, userData: Dictionary<String, Any>){
        REF_RECRUITERS.child(uid).updateChildValues(userData)
    }
    
    func isUserVolunteer(uid: String, handler: @escaping(_ isVolunteer: Bool) ->() ){
        REF_USERS.child(uid).child("userType").observe(.value) { (snapshot) in
            if let type = snapshot.value as? String{
                handler(true)
            }else{
                handler(false)
            }
        }
    }
    
    
    
    func applyUser(experienceID: String, userID: String, recruiter: String){
        REF_USERS.child(userID).child("pendingExperiences").child(experienceID).setValue(true)
        REF_RECRUITERS.child(recruiter).child("activeExperiences").child(experienceID).child("pendingPeople").child(userID).setValue(true)
        print("User successfully applied")
    }
    
    func didUserApply(experienceID: String, userID: String, applied: @escaping (_ status: Bool) ->() ){
        var isApplied = false
        
        REF_USERS.child(userID).child("pendingExperiences").observeSingleEvent(of: .value) { (pendingSnapshot) in
            guard let pendingSnapshot = pendingSnapshot.children.allObjects as? [DataSnapshot] else {return}
        
            for each in pendingSnapshot{
                if each.key == experienceID{
                    print("user already applied")
                    isApplied = true
                    applied(isApplied)
                    return
                }
            }
            
            self.REF_USERS.child(userID).child("acceptedExperiences").observeSingleEvent(of: .value) { (acceptedSnpapshot) in
                guard let acceptedSnpapshot = acceptedSnpapshot.children.allObjects as? [DataSnapshot] else {return}
        
                for each in acceptedSnpapshot{
                    if each.key == experienceID{
                        print("user already applied and accepted")
                        isApplied = true
                        applied(isApplied)
                        return
                    }
                }
                
                self.REF_USERS.child(userID).child("declinedExperiences").observeSingleEvent(of: .value){ (declinedSnapshot) in
                    guard let declinedSnapshot = declinedSnapshot.children.allObjects as? [DataSnapshot] else {return}
                    
                    for each in declinedSnapshot{
                        if each.key == experienceID{
                            print("User already applied and declined")
                            isApplied = true
                            applied(isApplied)
                            return
                        }
                    }
                    applied(isApplied)
                }
//                applied(isApplied)
            }
        }
    }

    
    func getExperiencesForCity(userCity: String, handler: @escaping(_ experiencesArray: [Experience]) ->() ){
        var experiences = [Experience]()
        REF_EXPERIENCES.observeSingleEvent(of: .value) { (experienceSnapshot) in
            guard let experienceSnapshot = experienceSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for eachExperience in experienceSnapshot{
                let city = eachExperience.childSnapshot(forPath: "city").value as! String
                let location = eachExperience.childSnapshot(forPath: "location").value as! String
                let title = eachExperience.childSnapshot(forPath: "title").value as! String
                let rating = eachExperience.childSnapshot(forPath: "rating").value as! Double
                let shortDescription = eachExperience.childSnapshot(forPath: "shortDescription").value as! String
                let longDescription = eachExperience.childSnapshot(forPath: "longDescription").value as! String
                let date = eachExperience.childSnapshot(forPath: "date").value as! String
                let preciseLocation = eachExperience.childSnapshot(forPath: "preciseLocation").value as! String
                let category = eachExperience.childSnapshot(forPath: "category").value as! String
                let ageGroup = eachExperience.childSnapshot(forPath: "ageGroup").value as! String
                let iconPhoto = eachExperience.childSnapshot(forPath: "iconPhoto").value as! String
                let bannerPhoto = eachExperience.childSnapshot(forPath: "bannerPhoto").value as! String
                let id = eachExperience.key
                let time = eachExperience.childSnapshot(forPath: "time").value as! String
                let recruiter = eachExperience.childSnapshot(forPath: "recruiter").value as! String
                
                let experience = Experience(city: city, location: location, title: title, rating: rating, shortDescription: shortDescription, longDescription: longDescription, date: date, preciseLocation: preciseLocation, category: category, ageGroup: ageGroup, iconPhoto: iconPhoto, bannerPhoto: bannerPhoto, id: id, time: time, recruiter: recruiter)
                
                if city == userCity{
                    experiences.append(experience)
                }
            }
            handler(experiences)
        }
    }
    
    
    func getExperiencesForStatus(userID: String, status: String, handler: @escaping(_ experiencesArray: [MyVolunteerExperience]) ->() ){
        var experiences = [MyVolunteerExperience]()
        var appliedIDs = [String]()
    
        
        REF_USERS.child(userID).child(status).observeSingleEvent(of: .value) { (appliedSnaphsot) in
            guard let appliedSnaphsot = appliedSnaphsot.children.allObjects as? [DataSnapshot] else {return}
            print(status)
            print(appliedSnaphsot.count)
            if appliedSnaphsot.count == 0{
                handler(experiences)
                return
            }
            for eachApplied in appliedSnaphsot{
                appliedIDs.append(eachApplied.key)
                self.REF_EXPERIENCES.child(eachApplied.key).observeSingleEvent(of: .value, with: { (experienceSnapshot) in
                    print(experienceSnapshot.key)
                    let title = experienceSnapshot.childSnapshot(forPath: "title").value as? String
                    let location = experienceSnapshot.childSnapshot(forPath: "preciseLocation").value as? String
                    let date  = experienceSnapshot.childSnapshot(forPath: "date").value as? String
                    let time = experienceSnapshot.childSnapshot(forPath: "time").value as? String
                    let recruiterID = experienceSnapshot.childSnapshot(forPath: "recruiter").value as? String
                    if title != nil && location != nil && date != nil && time != nil && recruiterID != nil{
                        let experience = MyVolunteerExperience(title: title!, location: location!, date: date!, time: time!, expID: eachApplied.key, recruiterID: recruiterID!)
                        experiences.append(experience)
                        handler(experiences)
                    }
                    
                })
                
            }
            
            
//            self.REF_EXPERIENCES.observeSingleEvent(of: .value) { (experienceSnapshot) in
//                guard let experienceSnapshot = experienceSnapshot.children.allObjects as? [DataSnapshot] else {return}
//                for eachExperience in experienceSnapshot{
//                    if appliedIDs.contains(eachExperience.key){
//                        let title = eachExperience.childSnapshot(forPath: "title").value as! String
//                        let location = eachExperience.childSnapshot(forPath: "preciseLocation").value as! String
//                        let date  = eachExperience.childSnapshot(forPath: "date").value as! String
//                        let time = eachExperience.childSnapshot(forPath: "time").value as! String
//                        let recruiterID = eachExperience.childSnapshot(forPath: "recruiter").value as! String
//                        let experience = MyVolunteerExperience(title: title, location: location, date: date, time: time, expID: eachExperience.key, recruiterID: recruiterID)
//                        experiences.append(experience)
//                    }
//                }
//                handler(experiences)
//            }
            
        }
    }
    
    func getReviewsForExperience(expID: String, handler: @escaping(_ reviewsArray: [Review]) ->() ){
        var reviews = [Review]()
        REF_REVIEWS.child(expID).observeSingleEvent(of: .value) { (reviewSnapshot) in
            guard let reviewSnapshot = reviewSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for eachReview in reviewSnapshot{
                let reviewerName = eachReview.childSnapshot(forPath: "reviewerName").value as! String
                let rating = eachReview.childSnapshot(forPath: "rating").value as! Double
                let date = eachReview.childSnapshot(forPath: "date").value as! String
                let reviewDescription = eachReview.childSnapshot(forPath: "reviewDescription").value as! String
                
                let review = Review(reviewerName: reviewerName, rating: rating, date: date, reviewDescription: reviewDescription)
                reviews.append(review)
            }
            handler(reviews)
        }
    }
    
    func getExperiencesFromCategory(userCity: String, category: String, handler: @escaping(_ experiencesArray: [Experience]) ->() ){
        var experiences = [Experience]()
        var neededExpIDs = [String]()
        REF_CATEGORIES.child(category).observeSingleEvent(of: .value) { (categorySnapshot) in
            guard let categorySnapshot = categorySnapshot.children.allObjects as? [DataSnapshot] else {return}
            for eachCategoryExp in categorySnapshot{
                print(eachCategoryExp.key)
                neededExpIDs.append(eachCategoryExp.key)
            }
            self.REF_EXPERIENCES.observeSingleEvent(of: .value) { (experienceSnapshot) in
                guard let experienceSnapshot = experienceSnapshot.children.allObjects as? [DataSnapshot] else {return}
                for eachExperience in experienceSnapshot{
                    if neededExpIDs.contains(eachExperience.key){
                        let city = eachExperience.childSnapshot(forPath: "city").value as! String
                        let location = eachExperience.childSnapshot(forPath: "location").value as! String
                        let title = eachExperience.childSnapshot(forPath: "title").value as! String
                        let rating = eachExperience.childSnapshot(forPath: "rating").value as! Double
                        let shortDescription = eachExperience.childSnapshot(forPath: "shortDescription").value as! String
                        let longDescription = eachExperience.childSnapshot(forPath: "longDescription").value as! String
                        let date = eachExperience.childSnapshot(forPath: "date").value as! String
                        let preciseLocation = eachExperience.childSnapshot(forPath: "preciseLocation").value as! String
                        let category = eachExperience.childSnapshot(forPath: "category").value as! String
                        let ageGroup = eachExperience.childSnapshot(forPath: "ageGroup").value as! String
                        let iconPhoto = eachExperience.childSnapshot(forPath: "iconPhoto").value as! String
                        let bannerPhoto = eachExperience.childSnapshot(forPath: "bannerPhoto").value as! String
                        let id = eachExperience.key
                        let time = eachExperience.childSnapshot(forPath: "time").value as! String
                        let recruiter = eachExperience.childSnapshot(forPath: "recruiter").value as! String
                        
                        let dateString = "\(date) \(time)"
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
                        let fullDate = dateFormatter.date(from: dateString)
                        
                        let experience = Experience(city: city, location: location, title: title, rating: rating, shortDescription: shortDescription, longDescription: longDescription, date: date, preciseLocation: preciseLocation, category: category, ageGroup: ageGroup, iconPhoto: iconPhoto, bannerPhoto: bannerPhoto, id: id, time: time, recruiter: recruiter)
                        
                        if fullDate! >= Date(){
                            if city == userCity{
                                experiences.append(experience)
                            }
                            
                        }
                    }
                }
                handler(experiences)
            }
        }
    }
    
    func addToLatestUserApplied(userID: String, experience: Experience? = nil, status: String, active: RecruiterActiveExperience? = nil){
        REF_USERS.child(userID).child("last3").observeSingleEvent(of: .value){ (lastSnapshot) in
            guard let lastSnapshot = lastSnapshot.children.allObjects as? [DataSnapshot] else {return}
            let date = Date()
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second,], from: date)

            if lastSnapshot.count < 3{
                
                if let exp = experience{
                    let userData = ["title": exp.title, "status": status, "date": "\(components.day!).\(components.month!).\(components.year!) \(components.hour!):\(components.minute!):\(components.second!)"]
                    self.REF_USERS.child(userID).child("last3").child(exp.id).updateChildValues(userData)
                }
                
                if let act = active{
                    let userData = ["title": act.title, "status": status, "date": "\(components.day!).\(components.month!).\(components.year!) \(components.hour!):\(components.minute!):\(components.second!)"]
                    self.REF_USERS.child(userID).child("last3").child(act.expID).updateChildValues(userData)
                }
            }else{
                let formatter = DateFormatter()
                formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
                var latestDate = formatter.date(from: "\(components.day!).\(components.month!).\(components.year!) \(components.hour!):\(components.minute!):\(components.second!)")
                var latestExpID = ""
                var oldestDate = ""
                
                for each in lastSnapshot{
                    let eachDateString = each.childSnapshot(forPath: "date").value as! String
                    let eachDate = formatter.date(from: eachDateString)
                    if eachDate! < latestDate!{
                        latestDate = eachDate
                        latestExpID = each.key
                        oldestDate = each.childSnapshot(forPath: "date").value as! String
                    }
                }
                
                if let exp = experience{
                    let userData = ["title": exp.title, "status": status, "date": "\(components.day!).\(components.month!).\(components.year!) \(components.hour!):\(components.minute!):\(components.second!)"]
                    print("oldest date was: ", oldestDate)
                    print("latest exp id", latestExpID)
                    
                    if latestExpID.count >= 1{
                        self.REF_USERS.child(userID).child("last3").child(latestExpID).removeValue()
                    }
                    
                    self.REF_USERS.child(userID).child("last3").child(exp.id).updateChildValues(userData)
                }
                
                if let act = active{
                    let userData = ["title": act.title, "status": status, "date": "\(components.day!).\(components.month!).\(components.year!) \(components.hour!):\(components.minute!):\(components.second!)"]
                    print("oldest date was: ", oldestDate)
                    print("latest exp id", latestExpID)
                    
                    if latestExpID.count >= 1{
                        self.REF_USERS.child(userID).child("last3").child(latestExpID).removeValue()
                    }
                    
                    
                    self.REF_USERS.child(userID).child("last3").child(act.expID).updateChildValues(userData)
                }
            }
        }
    }
    
    func getLast3Statuses(userID: String, handler: @escaping(_ statusesArray: [LastStatus]) ->() ){
        var statuses = [LastStatus]()
        REF_USERS.child(userID).child("last3").observeSingleEvent(of: .value){ (statusSnapshot) in
            guard let statusSnapshot = statusSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for each in statusSnapshot{
                let title = each.childSnapshot(forPath: "title").value as! String
                let status = each.childSnapshot(forPath: "status").value as! String
                let lastStatus = LastStatus(title: title, status: status)
                statuses.append(lastStatus)
            }
            handler(statuses )
        }
    }
    
    func getUserInfo(userID: String, handler: @escaping(_ volunteer: Volunteer) ->() ){
        REF_USERS.child(userID).observeSingleEvent(of: .value) { (volunteerSnapshot) in
            let name = volunteerSnapshot.childSnapshot(forPath: "fullName").value as! String
            let email = volunteerSnapshot.childSnapshot(forPath: "email").value as! String
            let date = volunteerSnapshot.childSnapshot(forPath: "DOB").value as! String
            let phone = volunteerSnapshot.childSnapshot(forPath: "phoneNumber").value as! String
            let city = volunteerSnapshot.childSnapshot(forPath: "city").value as! String
            let profileURL = volunteerSnapshot.childSnapshot(forPath: "profilePicture").value as! String
            
            let volunteerUser = Volunteer(name: name, email: email, date: date, phone: phone, city: city, profileURL: profileURL, ID: volunteerSnapshot.key)
            handler(volunteerUser)
        }
    }
    
    func updateUserInfo(uid: String, userData: Dictionary<String, Any>, userImage: UIImage){
        REF_USERS.child(uid).updateChildValues(userData)
        
        if let imageData = userImage.jpegData(compressionQuality: 1.0){
            let imageUID = NSUUID().uuidString
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            ST_USERS.child(uid).child(imageUID).putData(imageData, metadata: metadata, completion: { (metadata, error) in
                if error != nil{
                    print("Unable to upload image to Firebase storage: ", String(describing: error))
                }else{
                    print("Successfully uploaded image to Firebase")
                    if let url = metadata?.downloadURL()?.absoluteString{
                        self.REF_USERS.child(uid).child("profilePicture").setValue(url)
                    }
                }
            })
        }
        
    }
    
    func getNotifications(userID: String, handler: @escaping(_ notificationsArray: [ExperienceNotification]) ->() ){
        var notifications = [ExperienceNotification]()
        var numberOfNotifs = 0
        
        REF_NOTIFICATIONS.child(userID).observeSingleEvent(of: .value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
            numberOfNotifs = snapshot.count
            for eachNotific in snapshot{
                let date = eachNotific.childSnapshot(forPath: "date").value as! String
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
                let nsDate = dateFormatter.date(from: date)
                
                
                let status = eachNotific.childSnapshot(forPath: "status").value as! String
                let expID = eachNotific.childSnapshot(forPath: "experienceID").value as! String
                
                self.REF_EXPERIENCES.child(expID).child("title").observeSingleEvent(of: .value) { (expSnapshot) in
                    if let title = expSnapshot.value as? String{
                        let not = ExperienceNotification(status: status, date: date, title: title, expID: expID, nsDate: nsDate!)
                        notifications.append(not)
                    }
                    if notifications.count == numberOfNotifs{
                        handler(notifications)
                    }
                }
            }
            if numberOfNotifs == 0{
                handler(notifications)
            }
        }
    }
    
    func getActiveExperiencesHome(userID: String, handler: @escaping(_ experiencesArray: [RecruiterActiveExperience], _ pastArray: [RecruiterActiveExperience]) ->() ){
        var experiences = [RecruiterActiveExperience]()
        var pastExps = [RecruiterActiveExperience]()
        var neededExpIDs = [String]()
        REF_RECRUITERS.child(userID).child("activeExperiences").observeSingleEvent(of: .value) { (recruiterSnapshot) in
            guard let recruiterSnapshot = recruiterSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for each in recruiterSnapshot{
                neededExpIDs.append(each.key)
            }
            self.REF_EXPERIENCES.observeSingleEvent(of: .value) { (experienceSnapshot) in
                guard let experienceSnapshot = experienceSnapshot.children.allObjects as? [DataSnapshot] else {return}
                for eachExperience in experienceSnapshot{
                    if neededExpIDs.contains(eachExperience.key){
                        let title = eachExperience.childSnapshot(forPath: "title").value as! String
                        let date = eachExperience.childSnapshot(forPath: "date").value as! String
                        let imageURL = eachExperience.childSnapshot(forPath: "iconPhoto").value as! String
                        let expID = eachExperience.key
                        let time = eachExperience.childSnapshot(forPath: "time").value as! String
                        var pending = "0"
                        var accepted = "0"
                        
                        let preciseLocation = eachExperience.childSnapshot(forPath: "preciseLocation").value as! String
                        let ageGroup = eachExperience.childSnapshot(forPath: "ageGroup").value as! String
                        let bannerPhoto = eachExperience.childSnapshot(forPath: "bannerPhoto").value as! String
                        let rating = eachExperience.childSnapshot(forPath: "rating").value as! Double
                        let location = eachExperience.childSnapshot(forPath: "location").value as! String
                        let category = eachExperience.childSnapshot(forPath: "category").value as! String
                        let city = eachExperience.childSnapshot(forPath: "city").value as! String
                        let description = eachExperience.childSnapshot(forPath: "longDescription").value as! String

                        let dateString = "\(date) \(time)"
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
                        let fullDate = dateFormatter.date(from: dateString)
                        print(fullDate!)
                        
                    self.REF_RECRUITERS.child(userID).child("activeExperiences").child(eachExperience.key).child("pendingPeople").observeSingleEvent(of: .value) { (pendingSnapshot) in
                        guard let pendingSnapshot = pendingSnapshot.children.allObjects as? [DataSnapshot] else {return}
                        print("pending: ", pendingSnapshot.count)
                        pending = "\(pendingSnapshot.count)"
                        self.REF_RECRUITERS.child(userID).child("activeExperiences").child(eachExperience.key).child("acceptedPeople").observeSingleEvent(of: .value) { (acceptedSnapshot) in
                            guard let acceptedSnapshot = acceptedSnapshot.children.allObjects as? [DataSnapshot] else {return}
                            print("accepted: ", acceptedSnapshot.count)
                            accepted = "\(acceptedSnapshot.count)"
                            
                            let experience = RecruiterActiveExperience(title: title, date: date, time: time, accepted: accepted, pending: pending, imageURL: imageURL, expID: expID, organisation: location, bannerURL: bannerPhoto, rating: rating, age: ageGroup, location: preciseLocation, category: category, city: city, description: description)
                            
                            if fullDate! < Date(){
                                print("in the past: ", fullDate!)
                                pastExps.append(experience)
                            }else{
                                print("in the future: ", fullDate!)
                                experiences.append(experience)
                            }
                            
                            //experiences.append(experience)
                            if experiences.count+pastExps.count == neededExpIDs.count{
                                print("finishing")
                                print("exps: ")
                                handler(experiences, pastExps)
                                }
                            }
                        }
                    }
                }
                if neededExpIDs.count == 0{
                    handler(experiences, pastExps)
                }
            }
        }
    }
    
    func getPastExperiences(userID: String, handler: @escaping(_ experiencesArray: [RecruiterPastExperience]) ->() ){
        var experiences = [RecruiterPastExperience]()
        var neededExpIDs = [String]()
        var acceptedOnes = [String]()
        var index = 0
        
        REF_RECRUITERS.child(userID).child("pastExperiences").observeSingleEvent(of: .value) { (recruiterSnapshot) in
            guard let recruiterSnapshot = recruiterSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for recruiterEach in recruiterSnapshot{
                neededExpIDs.append(recruiterEach.key)
                let accepted = recruiterEach.childSnapshot(forPath: "accepted").value as! String
                acceptedOnes.append(accepted)
            }
                
                self.REF_EXPERIENCES.observeSingleEvent(of: .value){ (experienceSnapshot) in
                    guard let experienceSnapshot = experienceSnapshot.children.allObjects as? [DataSnapshot] else {return}
                    for eachExperience in experienceSnapshot{
                        if neededExpIDs.contains(eachExperience.key){
                            let title = eachExperience.childSnapshot(forPath: "title").value as! String
                            let date = eachExperience.childSnapshot(forPath: "date").value as! String
                            let imageURL = eachExperience.childSnapshot(forPath: "iconPhoto").value as! String
                            let expID = eachExperience.key
                            let time = eachExperience.childSnapshot(forPath: "time").value as! String
                            
                            let experience = RecruiterPastExperience(title: title, date: date, time: time, imageURL: imageURL, expID: expID, accepted: acceptedOnes[index])
                            experiences.append(experience)
                            index = index + 1
                        }
                    }
                    handler(experiences)
                }
        }
    }
    
    
    func getPendingPeople(userID: String, expID: String, handler: @escaping(_ pendingArray: [Volunteer], _ isEmpty: Bool) ->() ){
        var pendingPeople = [Volunteer]()
        var index = 0
        
        REF_RECRUITERS.child(userID).child("activeExperiences").child(expID).child("pendingPeople").observeSingleEvent(of: .value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
            for each in snapshot{
                index = index + 1
                self.REF_USERS.child(each.key).observeSingleEvent(of: .value) { (userSnapshot) in
                    //guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
                    print(each.key)
                    let name = userSnapshot.childSnapshot(forPath: "fullName").value as! String
                    print(name)
                    let email = userSnapshot.childSnapshot(forPath: "email").value as! String
                    let date = userSnapshot.childSnapshot(forPath: "DOB").value as! String
                    let phone = userSnapshot.childSnapshot(forPath: "phoneNumber").value as! String
                    let city = userSnapshot.childSnapshot(forPath: "city").value as! String
                    let profileURL = userSnapshot.childSnapshot(forPath: "profilePicture").value as! String
                    
                    let volunteerUser = Volunteer(name: name, email: email, date: date, phone: phone, city: city, profileURL: profileURL, ID: userSnapshot.key)
                    pendingPeople.append(volunteerUser)
                    if pendingPeople.count == index{
                        handler(pendingPeople, false)
                    }
                }
            }
            if index == 0{
                handler(pendingPeople, true)
            }
        }
    }
    
    
    func getAcceptedPeople(userID: String, expID: String, handler: @escaping(_ pendingArray: [Volunteer], _ isEmpty: Bool) ->() ){
        var pendingPeople = [Volunteer]()
        var index = 0
        
        REF_RECRUITERS.child(userID).child("activeExperiences").child(expID).child("acceptedPeople").observeSingleEvent(of: .value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
            for each in snapshot{
                index = index + 1
                self.REF_USERS.child(each.key).observeSingleEvent(of: .value) { (userSnapshot) in
                    //guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
                    print(each.key)
                    let name = userSnapshot.childSnapshot(forPath: "fullName").value as! String
                    print(name)
                    let email = userSnapshot.childSnapshot(forPath: "email").value as! String
                    let date = userSnapshot.childSnapshot(forPath: "DOB").value as! String
                    let phone = userSnapshot.childSnapshot(forPath: "phoneNumber").value as! String
                    let city = userSnapshot.childSnapshot(forPath: "city").value as! String
                    let profileURL = userSnapshot.childSnapshot(forPath: "profilePicture").value as! String
                    
                    let volunteerUser = Volunteer(name: name, email: email, date: date, phone: phone, city: city, profileURL: profileURL, ID: userSnapshot.key)
                    pendingPeople.append(volunteerUser)
                    if pendingPeople.count == index{
                        handler(pendingPeople, false)
                    }
                }
            }
            if index == 0{
                handler(pendingPeople, true)
            }
        }
    }
    
    
    func getDeclinedPeople(userID: String, expID: String, handler: @escaping(_ pendingArray: [Volunteer], _ isEmpty: Bool) ->() ){
        var pendingPeople = [Volunteer]()
        var index = 0
        
        REF_RECRUITERS.child(userID).child("activeExperiences").child(expID).child("declinedPeople").observeSingleEvent(of: .value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
            for each in snapshot{
                index = index + 1
                self.REF_USERS.child(each.key).observeSingleEvent(of: .value) { (userSnapshot) in
                    //guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
                    print(each.key)
                    let name = userSnapshot.childSnapshot(forPath: "fullName").value as! String
                    print(name)
                    let email = userSnapshot.childSnapshot(forPath: "email").value as! String
                    let date = userSnapshot.childSnapshot(forPath: "DOB").value as! String
                    let phone = userSnapshot.childSnapshot(forPath: "phoneNumber").value as! String
                    let city = userSnapshot.childSnapshot(forPath: "city").value as! String
                    let profileURL = userSnapshot.childSnapshot(forPath: "profilePicture").value as! String
                    
                    let volunteerUser = Volunteer(name: name, email: email, date: date, phone: phone, city: city, profileURL: profileURL, ID: userSnapshot.key)
                    pendingPeople.append(volunteerUser)
                    if pendingPeople.count == index{
                        handler(pendingPeople, true)
                    }
                }
            }
            if index == 0{
                handler(pendingPeople, false)
            }
        }
    }
    
    
    
    func activeMoveVolunteer(recruiterID: String, volunteerID: String, from: String, to: String, expID: String){
        REF_RECRUITERS.child(recruiterID).child("activeExperiences").child(expID).child(from).child(volunteerID).removeValue()
        REF_RECRUITERS.child(recruiterID).child("activeExperiences").child(expID).child(to).child(volunteerID).setValue(true)
        
        // from: pendingPeople, acceptedPeople, declinedPeople
        if from == "pendingPeople"{
            print("inside if pending", volunteerID, expID)
            REF_USERS.child(volunteerID).child("pendingExperiences").child(expID).removeValue()
            if to == "declinedPeople"{
                REF_USERS.child(volunteerID).child("declinedExperiences").child(expID).setValue(true)
            }else if to == "acceptedPeople"{
                print("under accepted")
                REF_USERS.child(volunteerID).child("acceptedExperiences").child(expID).setValue(true)
            }
        }
        
        if from == "declinedPeople"{
            REF_USERS.child(volunteerID).child("declinedExperiences").child(expID).removeValue()
            if to == "declinedPeople"{
                REF_USERS.child(volunteerID).child("declinedExperiences").child(expID).setValue(true)
            }else if to == "acceptedPeople"{
                REF_USERS.child(volunteerID).child("acceptedExperiences").child(expID).setValue(true)
            }
        }
        
        if from == "acceptedPeople"{
            REF_USERS.child(volunteerID).child("acceptedExperiences").child(expID).removeValue()
            if to == "declinedPeople"{
                REF_USERS.child(volunteerID).child("declinedExperiences").child(expID).setValue(true)
            }else if to == "acceptedPeople"{
                REF_USERS.child(volunteerID).child("acceptedExperiences").child(expID).setValue(true)
            }
        }
        
        

    }
    
    func getRecruiterInfo(userID: String, handler: @escaping(_ recruiter: Recruiter) ->() ){
        REF_RECRUITERS.child(userID).observeSingleEvent(of: .value) { (snapshot) in
            let organisation = snapshot.childSnapshot(forPath: "organization").value as! String
            let email = snapshot.childSnapshot(forPath: "email").value as! String
            let phoneNumber = snapshot.childSnapshot(forPath: "phoneNumber").value as! String
            let recruiter = snapshot.childSnapshot(forPath: "recruiter").value as! String
            let city = snapshot.childSnapshot(forPath: "city").value as! String
            
            let userRecruiter = Recruiter(organisation: organisation, email: email, phoneNumber: phoneNumber, recruiter: recruiter, city: city, ID: snapshot.key)
            handler(userRecruiter)
        }
    }
    
    func updateRecruiterInfo(userID: String, userData: Dictionary<String, Any>){
        REF_RECRUITERS.child(userID).updateChildValues(userData)
    }
    
    func deleteExperience(userID: String, expID: String){
        // Experiences
        REF_EXPERIENCES.child(expID).removeValue()
       
        // Reviews
        REF_REVIEWS.child(expID).removeValue()
       
        // Recruiters
        REF_RECRUITERS.child(userID).child("activeExperiences").child(expID).removeValue()
        REF_RECRUITERS.child(userID).child("pastExperiences").child(expID).removeValue()
       
        // Categories
        let categoryNames = ["ANIMAL", "CHILDREN", "COMMUNITY", "DISABILITY", "EDUCATION", "ENVIRONMENT", "HEALTH", "HOMELESS", "SENIOR"]
        for categoryIndex in categoryNames{
            REF_CATEGORIES.child(categoryIndex).child(expID).removeValue()
        }
        
        
        
        // Users
        REF_USERS.observeSingleEvent(of: .value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
            for each in snapshot{
                if expID == each.childSnapshot(forPath: "acceptedExperiences").childSnapshot(forPath: expID).key{
                    let userKey = each.key
                    self.REF_USERS.child(userKey).child("acceptedExperiences").child(expID).removeValue()
                }
                
                if expID == each.childSnapshot(forPath: "declinedExperiences").childSnapshot(forPath: expID).key{
                    let userKey = each.key
                    self.REF_USERS.child(userKey).child("declinedExperiences").child(expID).removeValue()
                }
                
                if expID == each.childSnapshot(forPath: "pendingExperiences").childSnapshot(forPath: expID).key{
                    let userKey = each.key
                    self.REF_USERS.child(userKey).child("pendingExperiences").child(expID).removeValue()
                }
            }
            
            // Notifications
            self.REF_NOTIFICATIONS.observeSingleEvent(of: .value, with: { (notificationSnapshot) in
                guard let notificationSnapshot = notificationSnapshot.children.allObjects as? [DataSnapshot] else {return}
                for each in notificationSnapshot{
                    guard let eachSnap = each.children.allObjects as? [DataSnapshot] else {return}
                    for eachNotific in eachSnap{
                        if expID == eachNotific.childSnapshot(forPath: "experienceID").value as! String{
                            self.REF_NOTIFICATIONS.child(each.key).child(eachNotific.key).removeValue()
                        }
                    }
                }
            })
            
            self.REF_CITIES.observeSingleEvent(of: .value, with: { (citySnapshot) in
                guard let citySnapshot = citySnapshot.children.allObjects as? [DataSnapshot] else {return}
                for each in citySnapshot{
                    self.REF_CITIES.child(each.key).child(expID).removeValue()
                }
            })
            
            
        }
        
    }
    
    func updateExperience(expID: String, userData: Dictionary<String, Any>, iconImage: UIImage, bannerImage: UIImage, oldCategory: String, newCategory: String, handler: @escaping() ->()){
        REF_EXPERIENCES.child(expID).updateChildValues(userData)
        REF_CATEGORIES.child(oldCategory.uppercased()).child(expID).removeValue()
        REF_CATEGORIES.child(newCategory.uppercased()).child(expID).setValue(true)
        
        if let imageData1 = iconImage.jpegData(compressionQuality: 0.2){
            let imageUID1 = NSUUID().uuidString
            let metadata1 = StorageMetadata()
            metadata1.contentType = "image/jpeg"
            
            self.ST_ICONS.child(imageUID1).putData(imageData1, metadata: metadata1, completion: { (metadata1, error1) in
                if error1 != nil{
                    print("Unable to upload image to Firebase storage: ", String(describing: error1))
                }else{
                    if let url1 = metadata1?.downloadURL()?.absoluteString{
                        self.REF_EXPERIENCES.child(expID).child("iconPhoto").setValue(url1)
                    }
                    
                    if let imageData2 = bannerImage.jpegData(compressionQuality: 0.2){
                        let imageUID2 = NSUUID().uuidString
                        let metadata2 = StorageMetadata()
                        metadata2.contentType = "image/jpeg"
                        
                        self.ST_BANNERS.child(imageUID2).putData(imageData2, metadata: metadata2, completion: { (metadata2, error2) in
                            if error2 != nil{
                                print("Unable to upload image to Firebase storage: ", String(describing: error2))
                            }else{
                                print("Successfully uploaded image to Firebase")
                                if let url2 = metadata2?.downloadURL()?.absoluteString{
                                    self.REF_EXPERIENCES.child(expID).child("bannerPhoto").setValue(url2)
                                }
                            }
                        })
                    }
                    
                }
            })
        }
        
        
        handler()
    }
    
    
    func getRecruiterNotifications(userID: String, handler: @escaping(_ notificationsArray: [RecruiterNotification]) ->() ){
        var notifications = [RecruiterNotification]()
        var numberOfNotifs = 0
        
        
        REF_NOTIFICATIONS.child(userID).observeSingleEvent(of: .value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
            numberOfNotifs = snapshot.count
            for eachNotific in snapshot{
                let date = eachNotific.childSnapshot(forPath: "date").value as! String
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
                let nsDate = dateFormatter.date(from: date)
                
                let expID = eachNotific.childSnapshot(forPath: "experienceID").value as! String
                let volunteer = eachNotific.childSnapshot(forPath: "volunteer").value as! String
                
                self.REF_EXPERIENCES.child(expID).child("title").observeSingleEvent(of: .value) { (expSnapshot) in
                    if let title = expSnapshot.value as? String{
                        let not = RecruiterNotification(title: title, date: date, expID: expID, volunteer: volunteer, nsDate: nsDate!)
                        notifications.append(not)
                    }
                    if notifications.count == numberOfNotifs{
                        handler(notifications)
                    }
                }
            }
            if numberOfNotifs == 0{
                handler(notifications)
            }
        }
    }
    
    func getActiveExperienceFromID(expID: String, handler: @escaping(_ experience: RecruiterActiveExperience) ->()){
        REF_EXPERIENCES.child(expID).observeSingleEvent(of: .value) { (snapshot) in
            guard let snapshot = snapshot.value as? NSDictionary else {return}
            let title = snapshot["title"] as! String
            let date = snapshot["date"] as! String
            let time = snapshot["time"] as! String
            let imageURL = snapshot["iconPhoto"] as! String
            let organisation = snapshot["location"] as! String
            let bannerURL = snapshot["bannerPhoto"] as! String
            let rating = snapshot["rating"] as! Double
            let location = snapshot["preciseLocation"] as! String
            let age = snapshot["ageGroup"] as! String
            let category = snapshot["category"] as! String
            let city = snapshot["city"] as! String
            let description = snapshot["longDescription"] as! String
            
            let experience = RecruiterActiveExperience(title: title, date: date, time: time, accepted: "0", pending: "0", imageURL: imageURL, expID: expID, organisation: organisation, bannerURL: bannerURL, rating: rating, age: age, location: location, category: category, city: city, description: description)
            
            handler(experience)
        }
    }
    
    func volunteerAppliesRecruiterNotify(recruiterID: String, volunteerID: String, expID: String){
        REF_USERS.child(volunteerID).observeSingleEvent(of: .value) { (snapshot) in
            guard let snapshot = snapshot.value as? NSDictionary else {return}
            let name = snapshot["fullName"] as! String
            var data = Dictionary<String, Any>()
            data["experienceID"] = expID
            data["volunteer"] = name
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
            let date = Date()
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second,], from: date)
            let latestDate = "\(components.day!).\(components.month!).\(components.year!) \(components.hour!):\(components.minute!):\(components.second!)"
            
            data["date"] = latestDate
            
            self.REF_NOTIFICATIONS.child(recruiterID).childByAutoId().setValue(data)
        }
    }
    
    func notifyVolunteer(expID: String, volunteerID: String, status: String){
        var data = Dictionary<String, Any>()
        data["experienceID"] = expID
        data["status"] = status
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second,], from: date)
        let latestDate = "\(components.day!).\(components.month!).\(components.year!) \(components.hour!):\(components.minute!):\(components.second!)"
        
        data["date"] = latestDate
        
        REF_NOTIFICATIONS.child(volunteerID).childByAutoId().setValue(data)
    }
    
    func getDateFromExpID(expID: String, handler: @escaping(_ date: Date) ->() ){
        REF_EXPERIENCES.child(expID).observeSingleEvent(of: .value) { (snapshot) in
            guard let snapshot = snapshot.value as? NSDictionary else {return}
            let dateString = "\(snapshot["date"] as! String) \(snapshot["time"] as! String)"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
            let fullDate = dateFormatter.date(from: dateString)
            print(dateString)
            handler(fullDate!)
        }
        
    }
    
    
    func createNewReview(expID: String, uid: String, desc: String, rating: Double, handler: @escaping() ->() ){
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yyyy"
        let dateString = formatter.string(from: Date())
        var userData = Dictionary<String, Any>()
        userData["date"] = dateString
        userData["rating"] = rating
        userData["reviewDescription"] = desc
        
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let snapshot = snapshot.value as? NSDictionary else {return}
            userData["reviewerName"] = snapshot["fullName"] as! String
            self.REF_REVIEWS.child(expID).childByAutoId().updateChildValues(userData)
            handler()
        }
    }
    
    func volunteerDescription(uid: String, expID: String, descr: String){
        REF_USERS.child(uid).child("descriptions").child(expID).child("descr").setValue(descr)
    }
    
    func getDescriptionFromUser(uid: String, expID: String, handler: @escaping(_ descr: String) ->() ){
        REF_USERS.child(uid).child("descriptions").child(expID).observeSingleEvent(of: .value) { (snapshot) in
            guard let snapshot = snapshot.value as? NSDictionary else {return}
            print(snapshot["descr"] as! String)
            handler(snapshot["descr"] as! String)
        }
    }
    
    func deleteUserApplication(uid: String, expID: String, recruiterID: String){
        REF_USERS.child(uid).child("acceptedExperiences").child(expID).removeValue()
        REF_USERS.child(uid).child("pendingExperiences").child(expID).removeValue()
        REF_USERS.child(uid).child("declinedExperiences").child(expID).removeValue()
        REF_USERS.child(uid).child("last3").child(expID).removeValue()
        
        
        REF_RECRUITERS.child(recruiterID).child("activeExperiences").observeSingleEvent(of: .value) { (snapshot) in
            guard let snapshot = snapshot.childSnapshot(forPath: expID).children.allObjects as? [DataSnapshot] else {return}
            for each in snapshot{
                guard let eachSnapshot = each.children.allObjects as? [DataSnapshot] else {return}
                print(each.key, " and count: ", eachSnapshot.count)
                for each3 in eachSnapshot{
                    print("sksksk KU: ", each3.key)
                    if each3.key == uid{
                        print("there are this mny peopels: ", eachSnapshot.count)
                        if eachSnapshot.count >= 2{
                            print(">2")
                            
                            self.REF_RECRUITERS.child(recruiterID).child("activeExperiences").child(expID).child(each.key).child(uid).removeValue()
                        }else{
                            print("none")
                            self.REF_RECRUITERS.child(recruiterID).child("activeExperiences").child(expID).child(each.key).child(uid).removeValue()
                            if snapshot.count == 1{
                                self.REF_RECRUITERS.child(recruiterID).child("activeExperiences").child(expID).setValue(true)
                            }
                        }
                    }
                }
                
//                if eachSnapshot.count >= 2{
//                    self.REF_RECRUITERS.child(recruiterID).child("activeExperiences").child(expID).child(each.key).child(uid).removeValue()
//                }else{
//                    for each2 in eachSnapshot{
//                        if each2.key == uid{
////                            self.REF_RECRUITERS.child(recruiterID).child("activeExperiences").child(expID).child(each.key).child(uid).removeValue()
////                            self.REF_RECRUITERS.child(recruiterID).child("activeExperiences").child(expID).setValue(true)
//                        }
//                    }
//                }
                
                
                
                
                
                
            }
        }
        
//        REF_RECRUITERS.observeSingleEvent(of: .value) { (snapshot) in
//            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
//            for each in snapshot{
//                if let snapshotEach = each.childSnapshot(forPath: "activeExperiences").children.allObjects as? [DataSnapshot] {
//                    for each2 in snapshotEach{
//                        print("each2 key: ", each2.key)
//                        let each2Snapshot = each2.children.allObjects as? [DataSnapshot]
//                        print("countitng starts: ", (each2Snapshot!.count))
//
//                        //self.REF_RECRUITERS.child(each.key).child("activeExperiences").child(expID).child("acceptedPeople").child(uid).removeValue()
//                        //self.REF_RECRUITERS.child(each.key).child("activeExperiences").child(expID).child("declinedPeople").child(uid).removeValue()
//                        //self.REF_RECRUITERS.child(each.key).child("activeExperiences").child(expID).child("pendingPeople").child(uid).removeValue()
//                    }
//                }
//            }
//        }
    }
    
    func isCityActive(city: String, handler: @escaping (_ isActive: Bool) ->() ){
        REF_CITIES.observeSingleEvent(of: .value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
            for each in snapshot{
                if city == each.key{
                    handler(true)
                    return
                }
            }
            handler(false)
        }
    }
    
    func supportedCities(handler: @escaping (_ cities: [String]) ->() ){
        var cities = [String]()
        REF_CITIES.observeSingleEvent(of: .value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
            for each in snapshot{
                cities.append(each.key)
            }
            handler(cities)
        }
    }
    
    func updateRating(expID: String, newRating: Double, handler: @escaping() ->() ){
        REF_EXPERIENCES.child(expID).child("rating").setValue(newRating)
        handler()
    }
    
    
    
    
    
    
    
    
    
    
}
