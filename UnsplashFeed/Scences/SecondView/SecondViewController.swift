//
//  SecondViewController.swift
//  UnsplashFeed
//
//  Created by An Nguyen on 12/09/2021.
//

import UIKit

class SecondViewController: UIViewController {
    lazy var viewModel = MainViewVM()
//    private let viewDidLoadTrigger: Observable<Void> = Observable<Void>(())
    override func viewDidLoad() {
        super.viewDidLoad()
//
//        let input = MainViewVM.Input(viewDidLoad: viewDidLoadTrigger)
//        let output = viewModel.transform(input)
//        output.loaded.bind = { value in
//            print(value)
//        }
//        
//        viewDidLoadTrigger.value = ()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
