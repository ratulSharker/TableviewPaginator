//
//  ExampleTableViewController.swift
//  TableviewPaginator_Example
//
//  Created by ratul sharker on 8/2/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import TableviewPaginator

class ExampleTableViewController: UITableViewController {

    private var viewModel: ExampleViewModel?
    private var tableviewPaginator: TableviewPaginator?
    private let limit = 3

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = ExampleViewModel(delegate: self)
        tableviewPaginator = TableviewPaginator.init(paginatorUI: self, delegate: self)
    }

}

// UITableView Datasource
extension ExampleTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel?.numberOfRows() ?? 0) + (tableviewPaginator?.rowsIn(section: section) ?? 0)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

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

extension ExampleTableViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tableviewPaginator?.scrollViewDidScroll(scrollView)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = tableviewPaginator?.heightForLoadMore(cell: indexPath) {
            return height
        }

        return 233
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ExampleTableViewController: TableviewPaginatorUIProtocol {
    func getTableview(paginator: TableviewPaginator) -> UITableView {
        return tableView
    }

    func shouldAddRefreshControl(paginator: TableviewPaginator) -> Bool {
        return true
    }

    func getPaginatedLoadMoreCellHeight(paginator: TableviewPaginator) -> CGFloat {
        return 44
    }

    func getPaginatedLoadMoreCell(paginator: TableviewPaginator) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ExampleLoadMoreCell") as? ExampleLoadMoreCell {
            cell.mViewActivityIndicator.startAnimating()
            cell.mViewActivityIndicator.isHidden = false
            return cell
        } else {
            return UITableViewCell.init()
        }
    }

    func getRefreshControlTintColor(paginator: TableviewPaginator) -> UIColor {
        return Constants.tintColor
    }
}

extension ExampleTableViewController: TableviewPaginatorProtocol {
    func loadPaginatedData(offset: Int, shouldAppend: Bool, paginator: TableviewPaginator) {
        viewModel?.fetchUsers(offset: offset, limit: limit, shouldAppend: shouldAppend)
    }
}

extension ExampleTableViewController: ExampleViewModelProtocol {
    func userFetched(success: Bool, userCount: Int) {
        if success {
            tableviewPaginator?.incrementOffsetBy(delta: userCount)
        }

        tableviewPaginator?.partialDataFetchingDone()

        tableView.reloadData()
    }
}
