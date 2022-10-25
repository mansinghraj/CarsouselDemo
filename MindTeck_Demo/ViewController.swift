//
//  ViewController.swift
//  MindTeck_Demo
//
//  Created by Man Singh Rajbhar on 22/10/22.
//

import UIKit

class ViewController: UIViewController ,UISearchBarDelegate{
    
    @IBOutlet weak var tbleView: UITableView!
    @IBOutlet weak var colectionView_outLet: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var pageControl: UIPageControl!
    var searchNameArray = [NameSearchModel]()
    var searchActive = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.delegate = self
         pageControl.numberOfPages = 20
        
    }
    //MARK: HERE IS DELEGATE METHOD OF SEARCH BAR
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
        {
            self.searchBar.endEditing(true)
        }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true

        if searchBar.text?.count == 0 {
            searchActive = false
        }
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
           searchActive = true
        if searchText.count == 0 {
            searchNameArray.removeAll()
            searchActive = false;
            tbleView.reloadData()
            searchBar.resignFirstResponder()
        }else{
            searchNameArray.removeAll()
            for nameStr in ListNameModel().nameArray{
                if nameStr.contains(searchText){
                    searchNameArray.append(NameSearchModel(name:nameStr))
                }
            }
            DispatchQueue.main.async {
                self.tbleView.reloadData()
            }
        }
    }
    }

extension ViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive{
            return searchNameArray.count
        }else{
           return ListNameModel().nameArray.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tbleView.dequeueReusableCell(withIdentifier: CellTitle.CellIdentifier,for: indexPath) as? NameListCell else {
            return UITableViewCell()
        }
        if searchActive{
            cell.lbl_name.text = searchNameArray[indexPath.row].name
        }else{
            cell.lbl_name.text = ListNameModel().nameArray[indexPath.row]
        }
        return cell
    }
}

extension ViewController:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collectionCell = colectionView_outLet.dequeueReusableCell(withReuseIdentifier: CellTitle.CellCollectionIdentifier, for: indexPath) as? CarouselCell else{
            return UICollectionViewCell()
        }
        return collectionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: colectionView_outLet.frame.width/2, height: colectionView_outLet.frame.height - 5)
        }
    
    func updateCellsScale(centerX: CGFloat) {
        
        for cell in colectionView_outLet.visibleCells {
            cell.transform = CGAffineTransform.identity
            var scaleX: CGFloat = 1.2
            if centerX < cell.frame.origin.x || centerX > cell.frame.origin.x + cell.frame.size.width {
                scaleX = 1.0
            }
            cell.transform = CGAffineTransform(scaleX: scaleX, y: scaleX)
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollOffsetX = scrollView.contentOffset.x
        let scrollWidth = scrollView.bounds.size.width
        let scrollHeight = scrollView.bounds.size.height
        let centerPoint = CGPoint(x: scrollOffsetX + (scrollWidth / 2), y: scrollHeight / 2)
        updateCellsScale(centerX: centerPoint.x)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()

        visibleRect.origin = colectionView_outLet.contentOffset
        visibleRect.size = colectionView_outLet.bounds.size

        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)

        guard let indexPath = colectionView_outLet.indexPathForItem(at: visiblePoint) else { return }
        pageControl.currentPage = indexPath.row
    }
    
    
    
}

