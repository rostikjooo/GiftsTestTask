//
//  GiftsTotalView.swift
//  Gifts
//
//  Created by Rost Balanyuk on 15.06.2021.
//

import UIKit

final class GiftsTotalView: UIView {
	
	private let label: UILabel = UILabel()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .gray
		label.font = UIFont.systemFont(ofSize: 21, weight: .medium)
		label.textColor = .darkText
		label.textAlignment = .right
		label.setContentCompressionResistancePriority(.required, for: .vertical)
		addSubview(label)
		label.snp.makeConstraints { make in
			make.top.left.right.equalToSuperview().inset(UIEdgeInsets(top: 12, left: 32, bottom: 0, right: 32))
			make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(12)
		}
		setTotalPrice(0)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setTotalPrice(_ value: Int) {
		label.text = "\(value)/100 points"
	}
	
	func signalOverflow() {
		let midX = label.center.x
		let midY = label.center.y
		
		let animation = CABasicAnimation(keyPath: "position")
		animation.duration = 0.06
		animation.repeatCount = 4
		animation.autoreverses = true
		animation.fromValue = CGPoint(x: midX - 10, y: midY)
		animation.toValue = CGPoint(x: midX + 10, y: midY)
		label.layer.add(animation, forKey: "position")
	}
}
