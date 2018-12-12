//
//  Recruiter.swift
//  Voluny
//


import Foundation

class Recruiter{
    private var _organisation: String
    private var _email: String
    private var _phoneNumber: String
    private var _recruiter: String
    private var _city: String
    private var _ID: String
    
    var organisation: String{
        return _organisation
    }
    
    var email: String{
        return _email
    }
    
    var phoneNumber: String{
        return _phoneNumber
    }
    
    var recruiter: String{
        return _recruiter
    }
    
    var city: String{
        return _city
    }
    
    var ID: String{
        return _ID
    }
    
    init(organisation: String, email: String, phoneNumber: String, recruiter: String, city: String, ID: String) {
        self._organisation = organisation
        self._email = email
        self._phoneNumber = phoneNumber
        self._recruiter = recruiter
        self._city = city
        self._ID = ID
    }
}



