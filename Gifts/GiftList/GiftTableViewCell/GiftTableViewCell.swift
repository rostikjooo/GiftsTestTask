//
//  GiftTableViewCell.swift
//  Gifts
//
//  Created by Rost Balanyuk on 15.06.2021.
//

import UIKit
import RxSwift

final class GiftTableViewCell: UITableViewCell {
	
	var viewModel: GiftTableViewCellViewModel? {
		didSet {
			setup()
		}
	}
	private var disposeBag = DisposeBag()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(switchSelection))
		addGestureRecognizer(tapGesture)
		textLabel?.numberOfLines = 0
		textLabel?.lineBreakMode = .byWordWrapping
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		disposeBag = DisposeBag()
	}
	
	@objc private func switchSelection() {
		let newIsSelected: Bool = !(viewModel?.currentSelectionValue ?? false)
		makeSelected(newIsSelected)
		viewModel?.isSelected.onNext(newIsSelected)
	}
	
	private func makeSelected(_ selected: Bool) {
		textLabel?.font = UIFont.systemFont(ofSize: 17, weight: selected ? .bold : .regular)
		accessoryType = selected ? .checkmark : .none
	}
	
	private func setup() {
		selectionStyle = .none
		textLabel?.text = viewModel?.title
		detailTextLabel?.text = viewModel?.subtitle
		makeSelected(viewModel?.currentSelectionValue ?? false)
		viewModel?.isSelected.subscribe(onNext: { [weak self] isSelected in
			self?.makeSelected(isSelected)
		}).disposed(by: disposeBag)
	}
}



