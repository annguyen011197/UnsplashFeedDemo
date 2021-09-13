//
//  MainViewController.swift
//  UnsplashFeed
//
//  Created by An Nguyen on 12/09/2021.
//

import UIKit

class MainViewController: UIViewController {
//    lazy var viewModel = MainViewVM()
//    private let viewDidLoadTrigger: PublishSubject<Void> = PublishSubject<Void>()
    override func viewDidLoad() {
        super.viewDidLoad()

//        let input = MainViewVM.Input(viewDidLoad: viewDidLoadTrigger)
//        let output = viewModel.transform(input)

        // Do any additional setup after loading the view.
        
        let network = NetworkServiceImpl()
        network.fetchImageList { result in
            print(result)
        }
    }

    @IBAction func next(_ sender: Any) {
        let vc = SecondViewController()
        self.present(vc, animated: true, completion: nil)
    }
}
