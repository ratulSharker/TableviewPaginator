//
//  TableviewPaginator.swift
//
//  Created by ratul sharker on 7/31/18.
//

import UIKit

/// This protocol defines how the ui will be laid out
/// by the TableviewPaginator.
public protocol TableviewPaginatorUIProtocol: class {
    func getTableview() -> UITableView
    func shouldAddRefreshControl() -> Bool
    func getPaginatedLoadMoreCellHeight() -> CGFloat
    func getPaginatedLoadMoreCell() -> UITableViewCell
    func getRefreshControlTintColor() -> UIColor
}

/// This protocol allows TableviewPaginator to
/// acknowledge implementer the event of loading
/// various data operations
public protocol TableviewPaginatorProtocol: class {
    func loadPaginatedData(offset: Int, shouldAppend: Bool)
}

/// Class responsible for providing the pagination
/// operation. This class hides necessary details
/// from the user
public class TableviewPaginator {

    private struct PaginatorState {
        var offset: Int = 0
        var dataFetchingRunning: Bool = false
        var allDataFetchingCompleted: Bool = false
        var isAllRowSeeked: Bool = false
    }

    private var refreshControl: UIRefreshControl?
    private var state: PaginatorState = PaginatorState()
    private weak var paginatorUI: TableviewPaginatorUIProtocol?
    private weak var delegate: TableviewPaginatorProtocol?

    private static let defaultSections = 1
    private static let defaultRows = 0

    /// Instance initializer mehtod
    ///
    /// - Parameters:
    ///   - paginatorUI: an instance of TableviewPaginatorUIProtocol protocol implementor
    ///   - delegate: an instance of TableviewPaginatorProtocol protocol implementor
    required public init(paginatorUI: TableviewPaginatorUIProtocol, delegate: TableviewPaginatorProtocol) {
        self.delegate = delegate
        self.paginatorUI = paginatorUI
        setupRefreshControl()
        // initial loading
        refreshControlPulled()
    }

    /// This is an internal method, which setup
    /// the UIRefreshControl in the tableview
    /// configured by the TableviewPaginatorUIProtocol protocol
    private func setupRefreshControl() {
        if paginatorUI?.shouldAddRefreshControl() ?? false {
            let refreshControl = UIRefreshControl()
            refreshControl.tintColor = paginatorUI?.getRefreshControlTintColor()
            paginatorUI?.getTableview().addSubview(refreshControl)
            refreshControl.addTarget(self, action: #selector(refreshControlPulled), for: .valueChanged)
            self.refreshControl = refreshControl
        }
    }

    /// Callback which will be fired,
    /// if the UIRefreshControl is installed
    /// inside the tableview & Pulled
    @objc func refreshControlPulled() {
        state.dataFetchingRunning = true
        state.allDataFetchingCompleted = false
        state.offset = 0
        self.delegate?.loadPaginatedData(offset: state.offset, shouldAppend: false)
    }

    /// Call this method inside tableView(_ tableView: UITableView,
    /// numberOfRowsInSection section: Int). This method will return
    /// the number of LoadMoreCell in the given section. Add this number
    /// with your desire number of rows in that section.
    ///
    /// - Parameter section: For which the number of extra cell is asked.
    /// - Returns: The number of load more cell in the given section.
    public func rowsIn(section: Int) -> Int {
        return (isLastSection(section: section) && state.allDataFetchingCompleted == false) ? 1 : 0
    }

    /// Call this method inside tableView(_ tableView: UITableView,
    /// heightForRowAt indexPath: IndexPath). This method will return
    /// height for load more cell if the indexPath matches the last
    /// indexPath. By last indexPath here means that the indexPath.section
    /// is the last section and indexPath.row is the last row in that 
    /// section. If the passed indexPath is not the last indexPath then
    /// null is returned. Call this method, if null is returned then return
    /// your desired cell height, otherwise return the returned height for
    /// the indexPath
    ///
    /// - Parameter indexPath: indexPath passed into the heightForRowAt tableview delegate
    /// - Returns: if last indexpath, height of load more cell is returned otherwise nil
    public func heightForLoadMore(cell indexPath: IndexPath) -> CGFloat? {
        if  state.allDataFetchingCompleted == false,
            isLastSectionRow(indexPath: indexPath) {// it's the last row of this section
            return paginatorUI?.getPaginatedLoadMoreCellHeight()
        } else {
            return nil
        }
    }

    /// Call this method inside tableView(_ tableView: UITableView,
    /// cellForRowAt indexPath: IndexPath), check if this method
    /// returning any cell or not. If returning non-null then return
    /// this cell.
    ///
    /// - Parameter indexPath: passed indexPath in tableview datasource method
    /// - Returns: if load more cell needed to be shown for this indexPath then a cell is returned.
    public func cellForLoadMore(at indexPath: IndexPath) -> UITableViewCell? {
        if  state.allDataFetchingCompleted == false,
            isLastSectionRow(indexPath: indexPath) {// it's the last row of this section
            state.isAllRowSeeked = true
            return paginatorUI?.getPaginatedLoadMoreCell()
        } else {
            return nil
        }
    }

    /// This method needed to be called to TableviewPaginator work
    /// perfectly. Implement scrollViewDidScroll(_ scrollView: UIScrollView),
    /// inside from that call this method
    ///
    /// - Parameter scrollView: Pass scrollView from scrollViewDidScroll(_ scrollView: UIScrollView)
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let  height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height,
            state.dataFetchingRunning == false, state.allDataFetchingCompleted == false,
            state.isAllRowSeeked == true {
            state.dataFetchingRunning = true
            state.isAllRowSeeked = false
            self.delegate?.loadPaginatedData(offset: state.offset, shouldAppend: true)
        }
    }

    /// Call this method while next page's data is ready.
    ///
    /// - Parameter delta: Number of item, added in current page
    public func incrementOffsetBy(delta: Int) {
        state.offset += delta

        if delta == 0 {
            state.allDataFetchingCompleted = true
        }
    }

    /// Call this method while data fetching of one page is completed
    /// This method let paginator know that, your next page is already fetched.
    /// This method is kept separate for better granularity of the methods
    /// and give controller flexibility
    public func partialDataFetchingDone() {
        refreshControl?.endRefreshing()
        state.dataFetchingRunning = false
    }

    /// This method let controller know that the next page is loading or not
    /// Controller may show different status based on this.
    ///
    /// - Returns: Is next page data fetching is running or not
    public func isDataFetchRunning() -> Bool {
        return state.dataFetchingRunning
    }

    /// This method let controller know that the last page is reached or not.
    /// Controller may show different status based on this.
    ///
    /// - Returns: Is last page reached or not
    public func isAllDataFetchingCompleted() -> Bool {
        return state.allDataFetchingCompleted
    }

    /// This method determines that is the given indexPath is the
    /// last indexPath of tableview or not. It collect number of section
    /// and number of rows in section from tableview datasource. If 
    /// datasource does not implement the number of section it assume
    /// default number of section 1, as per as UITableviewDataSource
    /// implementation.
    ///
    ///
    /// - Parameter indexPath: Which needed to be test against last indexPath
    /// - Returns: true if parameter indexPath is last, otherwise false
    public func isLastSectionRow(indexPath: IndexPath) -> Bool {
        if let tableview = paginatorUI?.getTableview() {
            let lastSection = tableview.dataSource?.numberOfSections?(in: tableview)
                ?? TableviewPaginator.defaultSections
            let lastRow = tableview.dataSource?.tableView(tableview,
                                                          numberOfRowsInSection: indexPath.section)
                ?? TableviewPaginator.defaultRows

            return lastSection == (indexPath.section+1) && lastRow == (indexPath.row+1)
        } else {
            return false
        }
    }

    /// This method determines that is the given section is the last 
    /// section of tableview or not. It collect number of section from
    /// tableview data source, otherwise default number of section
    /// 1 assumed as per as implementation of UITableviewDataSource.
    ///
    /// - Parameter section: Which needed to be test against last section
    /// - Returns: true if parameter section is last, otherwise false
    public func isLastSection(section: Int) -> Bool {
        if let tableview = paginatorUI?.getTableview() {
            return ((section + 1) == tableview.dataSource?.numberOfSections?(in: tableview)
                ?? TableviewPaginator.defaultSections )
        } else {
            return false
        }
    }

}
