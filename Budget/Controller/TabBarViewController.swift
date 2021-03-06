//
//  TabBarViewController.swift
//  Budget
//
//  Created by nono chan  on 2020/12/2.
//

import UIKit

class TabBarViewController: UITabBarController {
    let customButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        tabBar.barTintColor = .systemGray6
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.title == "新紀錄" {
            customButton.backgroundColor = .systemGray5
        } else {
            customButton.backgroundColor = .white
        }
    }
    func setupButton() {
        let image = UIImage(named: "Navigation_Add")
        customButton.setImage(image, for: .normal)
        customButton.frame.size = CGSize(width: 70, height: 70)
        customButton.center = CGPoint(x: tabBar.bounds.midX, y: tabBar.bounds.midY - customButton.frame.height / 5)
        customButton.backgroundColor = .white
        customButton.layer.cornerRadius = 35
        customButton.layer.borderColor = UIColor.darkGray.cgColor
        customButton.layer.borderWidth = 3
        customButton.clipsToBounds = true
        customButton.adjustsImageWhenHighlighted = false
        customButton.addTarget(self, action: #selector(showViewController), for: .touchDown)
        tabBar.addSubview(customButton)
    }
    @objc func showViewController() {
        customButton.backgroundColor = .white
        self.selectedIndex = 2
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { (touch) in
            let position = touch.location(in: tabBar)
            let offset = customButton.frame.height / 5
            if customButton.frame.minX <= position.x && position.x <= customButton.frame.maxX {
                if customButton.frame.minY - offset <= position.y && position.y <= customButton.frame.maxY - offset {
                    showViewController()
                }
            }
        }
    }
}
