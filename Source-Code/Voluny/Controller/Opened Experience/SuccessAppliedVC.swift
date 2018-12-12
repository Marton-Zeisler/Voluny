//
//  SuccessAppliedVC.swift
//  Voluny
//


import UIKit

class SuccessAppliedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    @IBAction func backTapped(_ sender: UIButton){
        backToHome()
    }
    
    func backToHome(){
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: HomeVC .self) || controller.isKind(of: CategoryVC .self){
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }


}
