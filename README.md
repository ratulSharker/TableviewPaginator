<img src="https://github.com/ratulSharker/TableviewPaginator/blob/master/images/Banner.jpg?raw=true"></img>

[![CI Status](https://travis-ci.org/ratulSharker/TableviewPaginator.svg?branch=master)](https://travis-ci.org/ratulSharker/TableviewPaginator)
[![codebeat badge](https://codebeat.co/badges/e213907a-a6a3-4b9b-bca2-aad36067a9b7)](https://codebeat.co/projects/github-com-ratulsharker-tableviewpaginator-master)
[![Version](https://img.shields.io/cocoapods/v/TableviewPaginator.svg?style=flat)](https://cocoapods.org/pods/TableviewPaginator)
[![Carthage compatible](https://img.shields.io/badge/Carthage-Compatible-brightgreen.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/TableviewPaginator.svg?style=flat)](https://cocoapods.org/pods/TableviewPaginator)
[![Platform](https://img.shields.io/cocoapods/p/TableviewPaginator.svg?style=flat)](https://cocoapods.org/pods/TableviewPaginator)
[![Xcode](https://img.shields.io/badge/Xcode-9.4-blue.svg)](https://developer.apple.com/xcode)

## <a href="https://appetize.io/embed/7799zdgrhftqg8b2gpc73n4ct8?device=iphone6s&scale=75&orientation=portrait&osVersion=11.4">Live Demonstration</a>

## Example

To run the example project

```ruby
pod try TableviewPaginator
```

## Installation

<details>
<summary>CocoaPods</summary>
</br>
<p>TableviewPaginator is available through <a href="https://cocoapods.org">CocoaPods</a>. To install
it, simply add the following line to your <code>Podfile</code>:</p>

<pre>
<code class='ruby language-ruby'>pod 'TableviewPaginator' </code></pre>
</details>

<details>
<summary>Carthage</summary>
</br>
<p>TableviewPaginator is available throguh <a href="https://github.com/Carthage/Carthage">Carthage</a>, specify it in your <code>Cartfile</code>:</p>

<pre><code class="ogdl language-ogdl">github "ratulSharker/TableviewPaginator" ~&gt; 0.1.0
</code></pre>
</details>

<details>
<summary>Manually</summary>
</br>
<p>Add the <a href="https://github.com/ratulSharker/TableviewPaginator/blob/master/TableviewPaginator/Classes/TableviewPaginator.swift">TableviewPaginator.swift</a> file to your Xcode project and you are good to go.</p>
</details>

## Usage

<b>Step 1:</b> Import the `TableviewPaginator` module in swift.

```swift
import TableviewPaginator
```

<b>Step 2:</b> Take a reference to `TableviewPaginator` (say `tableviewPaginator`) into your controller. This example assumes that you use `UIViewController` as your controller.

```swift
private var tableviewPaginator: TableviewPaginator?
```

<b>Step 3:</b> Initialize the `tableviewPaginator` in your `viewDidLoad` callback. Note that, before doing `tableviewPaginator` initialization, initialize your viewModel classes (from where you supply the data to view controller).

```swift
override func viewDidLoad() {
  // do all you model setup before initializing the tableviewPaginator
  tableviewPaginator = TableviewPaginator.init(paginatorUI: self, delegate: self)
}
```

<b>Step 4:</b> Now we have to implement two protocol `TableviewPaginatorUIProtocol` & `TableviewPaginatorProtocol`. `TableviewPaginatorUIProtocol` is responsible for specifying the `tableview` to working on and some other UI stuffs. `TableviewPaginatorProtocol` is responsible for let you know when to load and which data segment to load. The reason behind putting them inside of two different protocol is that, you may introduce a new class which is responsible for implementing `TableviewPaginatorUIProtocol` and keep the `TableviewPaginatorProtocol` implementation in your controller.

Implementing `TableviewPaginatorUIProtocol`

```swift
extension YourViewController: TableviewPaginatorUIProtocol {
    func getTableview() -> UITableView {
        return yourTableview
    }

    func shouldAddRefreshControl() -> Bool {
        return true
    }

    func getPaginatedLoadMoreCellHeight() -> CGFloat {
        return 44
    }

    func getPaginatedLoadMoreCell() -> UITableViewCell {
        if let cell = yourTableview.dequeueReusableCell(withIdentifier: "YOUR_LOAD_MORE_CELL_IDENTIFIER") as? YourLoadMoreCell {
            // customize your load more cell
            // i.e start animating the UIActivityIndicator inside of the cell
            return cell
        } else {
            return UITableViewCell.init()
        }
    }

    func getRefreshControlTintColor() -> UIColor {
        return yourColorOfChoice
    }
}
```

Implementing `TableviewPaginatorProtocol`

```swift
extension YourViewController: TableviewPaginatorProtocol {
    func loadPaginatedData(offset: Int, shouldAppend: Bool) {
        // call your data populating method here
        // i.e given below
        yourViewModel?.fetchData(offset: offset, limit: yourDataFetchLimit, shouldAppend: shouldAppend)
    }
}
```

<b>Step 5:</b> Now you have to call some methods from `UITableViewDelegate`, `UITableViewDataSource` & your data fetched callbacks.

inside of `heightForRowAt` call `heightForLoadMore` as following.

```swift
override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    // if the current indexPath should show the Load more cell
    // then heightForLoadMore will return a valid height
    // height provided in the TableviewPaginatorUIProtocol
    if let height = tableviewPaginator?.heightForLoadMore(cell: indexPath) {
        return height
    }

    return yourCellHeight
}
```

inside of `scrollViewDidScroll` will look like follwoing. `scrollViewDidScroll` is inherited from `UIScrollViewDelegate`.

```swift
override func scrollViewDidScroll(_ scrollView: UIScrollView) {
      tableviewPaginator?.scrollViewDidScroll(scrollView)
  }
```

inside of `numberOfRowsInSection`, call `rowsIn` as following

```swift
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let yourCurrentNumberOfRows
    let tableviewPagiantorLoadeMoreCells = (tableviewPaginator?.rowsIn(section: section) ?? 0)
    return yourCurrentNumberOfRows + tableviewPagiantorLoadeMoreCells
}
```

inside of `cellForRowAt`, call `cellForLoadMore` as following
```swift
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    if let cell = tableviewPaginator?.cellForLoadMore(at: indexPath) {
        return cell
    }

    // write your own cell returning logic
}
```

All of this implementation was very straight forward. The last task is to, let `tableviewPaginator` know that you have successfully completed the data fetching. This requires a function call from your data fetch completion delegate / code block. Here i assume that, you provide a delegate by the `viewModel` & implement that delegate in your `viewController`. There must be a method saying that `dataFetched`. Implemetation will look like following

```swift
extension YourViewController: YourViewModelProtocol {
    func dataFetched(success: Bool, dataCount: Int) {
        if success {
            tableviewPaginator?.incrementOffsetBy(delta: userCount)
        }

        tableviewPaginator?.partialDataFetchingDone()

        yourTableView.reloadData()
    }
}
```
Here the `dataCount` parameter denoting the newly added number of data, more precisely newly added number of rows.

## Author

sharker.ratul.08@gmail.com

## License

TableviewPaginator is available under the MIT license. See the LICENSE file for more info.
