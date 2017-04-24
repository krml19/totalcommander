//
//  SizeCell.swift
//  TotalCommander
//
//  Created by Marcin Karmelita on 24/04/17.
//  Copyright © 2017 Marcin Karmelita. All rights reserved.
//

import Cocoa

protocol ConfigurableCell {
    associatedtype ViewModel
    func configure(_ viewModel: ViewModel)
}

class SizeCell: TableCellView {

    @IBOutlet weak var progress: NSProgressIndicator!
    var viewModel: FileItem! {
        didSet {
            viewModel.hideProgress.subscribe(onNext: { [unowned self] hidden in
                self.progress.isHidden = hidden
                self.textField?.isHidden = !hidden
            }).addDisposableTo(disposeBag)
            viewModel.progressValue.subscribe(onNext: { [unowned self] value in
                self.progress.doubleValue = value * 100
            }).addDisposableTo(disposeBag)
            self.textField?.stringValue = viewModel.size
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
}

extension SizeCell: ConfigurableCell {
    typealias ViewModel = FileItem
    
    func configure(_ viewModel: ViewModel) {
        self.viewModel = viewModel
    }
}
