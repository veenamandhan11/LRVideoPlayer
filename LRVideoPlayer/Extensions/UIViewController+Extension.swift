//
//  UIViewController+Extension.swift
//  LRVideoPlayer
//
//  Created by Veena on 15/12/24.
//

import UIKit

extension UIViewController {
    func showToast(_ message: String) {
        let toastContainer = UIView(frame: CGRect())
        toastContainer.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastContainer.alpha = 0.0
        toastContainer.layer.cornerRadius = 10
        toastContainer.clipsToBounds = true

        let toastLabel = UILabel(frame: CGRect())
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font.withSize(12.0)
        toastLabel.text = message
        toastLabel.clipsToBounds = true
        toastLabel.numberOfLines = 0

        toastContainer.addSubview(toastLabel)
        view.addSubview(toastContainer)

        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            toastLabel.leadingAnchor.constraint(equalTo: toastContainer.leadingAnchor, constant: 15),
            toastLabel.trailingAnchor.constraint(equalTo: toastContainer.trailingAnchor, constant: -15),
            toastLabel.bottomAnchor.constraint(equalTo: toastContainer.bottomAnchor, constant: -15),
            toastLabel.topAnchor.constraint(equalTo: toastContainer.topAnchor, constant: 15),
            
            toastContainer.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 30),
            toastContainer.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -30),
            toastContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            toastContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            toastContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100)
        ])

        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.4, delay: 1.8, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        })
    }
}
