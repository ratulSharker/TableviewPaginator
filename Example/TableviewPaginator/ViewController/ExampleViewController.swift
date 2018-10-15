//
//  ExampleViewController.swift
//  TableviewPaginator_Example
//
//  Created by ratul sharker on 8/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import TableviewPaginator

class ExampleViewController: UIViewController {

    @IBOutlet weak var mViewTableView: UITableView!

    // private
    private var viewModel: ExampleViewModel?
    private var tableviewPaginator: TableviewPaginator?
    private var limit = 3

    override func viewDidLoad() {

        viewModel = ExampleViewModel(delegate: self)
        tableviewPaginator = TableviewPaginator(paginatorUI: self, delegate: self)
    }

    @IBAction func onRefreshButtonPressed(_ sender: Any) {
        tableviewPaginator?.refresh()
    }

}

extension ExampleViewController: TableviewPaginatorUIProtocol {
    func getTableview() -> UITableView {
        return mViewTableView
    }

    func shouldAddRefreshControl() -> Bool {
        return true
    }

    func getPaginatedLoadMoreCellHeight() -> CGFloat {
        return 44
    }

    func getPaginatedLoadMoreCell() -> UITableViewCell {
        if let cell = mViewTableView.dequeueReusableCell(withIdentifier: "ExampleLoadMoreCell")
            as? ExampleLoadMoreCell {
            cell.mViewActivityIndicator.startAnimating()
            cell.mViewActivityIndicator.isHidden = false
            return cell
        } else {
            return UITableViewCell.init()
        }
    }

    func getRefreshControlTintColor() -> UIColor {
        return Constants.tintColor
    }

}

extension ExampleViewController: TableviewPaginatorProtocol {
    func loadPaginatedData(offset: Int, shouldAppend: Bool) {
       viewModel?.fetchUsers(offset: offset, limit: limit, shouldAppend: shouldAppend)
    }
}

extension ExampleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel?.numberOfRows() ?? 0) + (tableviewPaginator?.rowsIn(section: section) ?? 0)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableviewPaginator?.cellForLoadMore(at: indexPath) {
            return cell
        }

        if let cell = tableView.dequeueReusableCell(withIdentifier: "ExampleTableviewCell") as? ExampleTableviewCell {
            cell.customize(user: viewModel?.getUser(at: indexPath.row))
            return cell
        } else {
            return UITableViewCell.init()
        }
    }

}

extension ExampleViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tableviewPaginator?.scrollViewDidScroll(scrollView)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = tableviewPaginator?.heightForLoadMore(cell: indexPath) {
            return height
        }

        return 233
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ExampleViewController: ExampleViewModelProtocol {
    func userFetched(success: Bool, userCount: Int) {
        if success {
            tableviewPaginator?.incrementOffsetBy(delta: userCount)
        }
        tableviewPaginator?.partialDataFetchingDone()
        mViewTableView.reloadData()
    }
}
