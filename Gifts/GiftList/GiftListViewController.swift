//
//  ViewController.swift
//  Gifts
//
//  Created by Rost Balanyuk on 15.06.2021.
//

import UIKit
import SnapKit
import RxSwift

class GiftListViewController: UIViewController {
	
	private let cellReuseId = "giftCell"
	private let disposeBag = DisposeBag()
	private let viewModel: GiftListViewModel
	
	private var tableView: UITableView!
	private var plusBarButton: UIBarButtonItem!
	private var totalView: GiftsTotalView!
	
	init(viewModel: GiftListViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupSubviews()
		totalView.setTotalPrice(0)
		setupBindings()
	}
	
	func setupSubviews() {
		tableView = UITableView()
		self.view.addSubview(tableView)
		tableView.snp.makeConstraints { make in
			make.left.right.top.equalToSuperview()
		}
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(GiftTableViewCell.self, forCellReuseIdentifier: cellReuseId)
		tableView.allowsMultipleSelection = true
		tableView.separatorColor = .clear
		
		self.title = viewModel.title
		plusBarButton = UIBarButtonItem(
			image: UIImage.init(named: "plus-circle-fill"),
			style: .plain,
			target: self,
			action: #selector(plusTapped)
		)
		plusBarButton.tintColor = UIColor.darkText
		self.navigationItem.rightBarButtonItem = plusBarButton
		
		totalView = .init()
		view.addSubview(totalView)
		totalView.snp.makeConstraints { make in
			make.left.right.bottom.equalToSuperview()
			make.top.equalTo(tableView.snp.bottom)
		}
	}
	
	func setupBindings() {
		viewModel.reloadTable.subscribe { [weak self] _ in
			self?.tableView.reloadData()
		}.disposed(by: disposeBag)
		
		viewModel.totalPrice.subscribe { [weak self] totalPrice in
			self?.totalView.setTotalPrice(totalPrice)
		}.disposed(by: disposeBag)
		
		viewModel.overflow.subscribe { [weak self] _ in
			self?.totalView.signalOverflow()
		}.disposed(by: disposeBag)
		
	}
	
	@objc func plusTapped() {
		viewModel.addNewGift.onNext(())
	}
}

extension GiftListViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.cellViewModels.count
	}
	
	func tableView(
		_ tableView: UITableView,
		cellForRowAt indexPath: IndexPath
	) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(
			withIdentifier: cellReuseId,
			for: indexPath
		) as! GiftTableViewCell
		cell.viewModel = viewModel.cellViewModels[indexPath.row]
		
		return cell
	}
	
	func tableView(
		_ tableView: UITableView,
		commit editingStyle: UITableViewCell.EditingStyle,
		forRowAt indexPath: IndexPath
	) {
		if editingStyle == .delete {
			tableView.beginUpdates()
			tableView.deleteRows(at: [indexPath], with: .automatic)
			viewModel.itemDeleted.onNext(indexPath)
			tableView.endUpdates()
		}
	}
}
