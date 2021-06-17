//
//  CreateGiftViewController.swift
//  Gifts
//
//  Created by Rost Balanyuk on 15.06.2021.
//

import UIKit
import RxSwift

final class CreateGiftViewController: UIViewController {
	
	private var viewModel: CreateGiftViewModel
	private var nameTextField: UITextField = .init()
	private var priceTextField: UITextField = .init()
	private var doneBarButtonItem: UIBarButtonItem!
	private var cancellBarButtonItem: UIBarButtonItem!
	private let disposeBag = DisposeBag()
	
	init(viewModel: CreateGiftViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .white
		self.title = viewModel.title
		setupSubviews()
		setupBindings()
	}
	
	func setupSubviews() {
		view.addSubview(nameTextField)
		view.addSubview(priceTextField)
		nameTextField.snp.makeConstraints { make in
			make.left.right.equalToSuperview().inset(UIEdgeInsets(top: 16, left: 32, bottom: 0, right: 32))
			make.height.equalTo(40)
			make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
		}
		priceTextField.snp.makeConstraints { make in
			make.left.right.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 32))
			make.height.equalTo(40)
			make.top.equalTo(nameTextField.snp.bottom).offset(16)
		}
		
		nameTextField.placeholder = viewModel.giftTitlePlaceholder
		priceTextField.placeholder = viewModel.giftAmountPlaceholder
		priceTextField.keyboardType = .numberPad
		
		doneBarButtonItem = UIBarButtonItem(
			title: viewModel.createButtonTitle,
			style: .plain,
			target: self,
			action: #selector(doneAct)
		)
		doneBarButtonItem.isEnabled = false
		
		cancellBarButtonItem = UIBarButtonItem(
			title: viewModel.closeButtonTitle,
			style: .plain,
			target: self,
			action: #selector(cancellAct)
		)
		navigationItem.leftBarButtonItem = cancellBarButtonItem
		navigationItem.rightBarButtonItem = doneBarButtonItem
	}
	
	private func setupBindings() {
		nameTextField.rx.text.distinctUntilChanged().compactMap { $0 }.bind(to: viewModel.name).disposed(by: disposeBag)
		priceTextField.rx.text.distinctUntilChanged().compactMap { $0 }.bind(to: viewModel.amount).disposed(by: disposeBag)
		viewModel.isValid.subscribe(onNext: { [weak self] isValid in
			self?.doneBarButtonItem.isEnabled = isValid
		}).disposed(by: disposeBag)
	}
	
	@objc private func doneAct() {
		viewModel.create.onNext(())
	}
	
	@objc private func cancellAct() {
		viewModel.close.onNext(())
	}
}
