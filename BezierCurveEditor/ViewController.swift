//
//  ViewController.swift
//  BezierCurveEditor
//
//  Created by Cem Olcay on 8/2/23.
//

import UIKit

class ViewController: UIViewController {
    var curveView = BezierCurveView(curve: .init())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(curveView)
        curveView.translatesAutoresizingMaskIntoConstraints = false
        curveView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        curveView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        curveView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        curveView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
    }
}
