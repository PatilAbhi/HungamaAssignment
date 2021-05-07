//
//  DashboardPageViewController.swift
//  HungamaAssignment
//
//  Created by Shree on 06/05/21.
//

import UIKit
import AlamofireImage

class DashboardPageViewController: UIViewController
{

    let ApiKeyDomain = "c9d37e68525bb2d373707e558170668d"
    
    @IBOutlet weak var src_movie_search: UISearchBar!
    @IBOutlet weak var tbl_now_playing_movie_list: UITableView!
    var activityView: UIActivityIndicatorView?
    
    @IBOutlet weak var tbl_recently_searched: UITableView!
    @IBOutlet weak var hgt_tbl_recently_searched: NSLayoutConstraint!
    
    let movieImageMainURL = BaseURL.MovieImageURL
    let placeHolderImage = UIImage(named: "img_hungama")!
    
    var fetchID: Int = 0
    var fetchMovieName: String = ""
    
    private var listofMovies = [NowPlayingModel]()
    let maxtableviewHeight: CGFloat = 250
    let mintableviewHeight: CGFloat = 0
    
    var Arr_movieResult = [MovieResult]()
    
    var searchBarBoolean: Bool = false
    
    var searchedMovieResult = [MovieResult]()
    
    var Arr_Searched_Movie_List = [SearchedMovieArrayList]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tbl_now_playing_movie_list.separatorStyle = .none
        tbl_recently_searched.separatorStyle = .none
        src_movie_search.delegate = self
        title = "Movies Now Playing"
        self.showActivityIndicator()
        self.callAPIForNowPlayingMovies()
    }
    
    // MARK: - Call Api for Now playing Movies
    func callAPIForNowPlayingMovies()
    {
        let moviePlayingList = BaseURL.MovieCallingMainURL + "api_key=" + ApiKeyDomain + "&language=en-US"
        print(moviePlayingList)

        ServerCallManager.sharedInstance.dataRequest(with: moviePlayingList, objectType: NowPlayingModel.self) { (result: Result) in
            switch result
            {
            case .success(let list):
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                    
                    self.Arr_movieResult.removeAll()
                    
                    let getResults = list.results
                    
                    for singleMovie in getResults!
                    {
                        self.Arr_movieResult.append(singleMovie)
                    }

                    self.searchedMovieResult = self.Arr_movieResult
                    
                    self.tbl_now_playing_movie_list.reloadData()
                }
            case .failure(let err):
                print("Error \(err)")
            }
        }
    }
    
    // MARK: - Show Activity Indicator
    func showActivityIndicator()
    {
        activityView = UIActivityIndicatorView(style: .large)
        activityView?.center = self.view.center
        self.view.addSubview(activityView!)
        activityView?.startAnimating()
    }

    // MARK: - Hide Activity Indicator
    func hideActivityIndicator()
    {
        activityView?.stopAnimating()
    }
    
    // MARK: - Call Storyboard
    func callStoryboard()
    {
        let story: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsPageVC = story.instantiateViewController(identifier: "MovieDetailsPageViewController") as! MovieDetailsPageViewController
        detailsPageVC.getMovieID = fetchID
        detailsPageVC.getMovieName = fetchMovieName
        self.navigationController?.pushViewController(detailsPageVC, animated: true)
    }
    
    // MARK: - Show Read Only Data For First Time
    func showReadOnlySearchedData()
    {
        do
        {
            hgt_tbl_recently_searched.constant = maxtableviewHeight
            let userDefaults = UserDefaults.standard
            
            let decoded = userDefaults.data(forKey: "recentSearched")
            if decoded != nil
            {
                self.Arr_Searched_Movie_List.removeAll()
                var decodedValues = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded!) as! [SearchedMovieArrayList]
                print("Read Only decode value \(decodedValues.count)")

                self.Arr_Searched_Movie_List = decodedValues
                    
                self.tbl_recently_searched.reloadData()
            }
            else
            {
                print("Read Only Do Nothing")
                hgt_tbl_recently_searched.constant = mintableviewHeight
            }
        }
        catch (let err)
        {
            print("Read Only Error in show read only searched Data )\(err)")
        }
    }
    
    // MARK: - Show Searched Data
    func showSearchedData()
    {
        do
        {
            hgt_tbl_recently_searched.constant = maxtableviewHeight
            let userDefaults = UserDefaults.standard
            
            let decoded = userDefaults.data(forKey: "recentSearched")
            if decoded != nil
            {
                var decodedValues = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded!) as! [SearchedMovieArrayList]
                print("decode value \(decodedValues.count)")
                
                if decodedValues.count > 3
                {
                    decodedValues.removeFirst()
                    
                    for singleMovie in searchedMovieResult
                    {
                        if fetchID == singleMovie.id!
                        {
                            decodedValues.append(SearchedMovieArrayList(movieID: fetchID, movieTitle: fetchMovieName))
                        }
                    }
                    
                    do
                    {
                        let userDefaults = UserDefaults.standard
                        userDefaults.removeObject(forKey: "recentSearched")
                        
                        let encodedData: Data = try NSKeyedArchiver.archivedData(withRootObject: decodedValues, requiringSecureCoding: false)

                        userDefaults.set(encodedData, forKey: "recentSearched")
                        userDefaults.synchronize()
                        
                        self.callStoryboard()
                    }
                    catch(let err)
                    {
                        print("error encoding \(err)")
                    }
                }
                else
                {
                    self.addRemoveDataUserDefaults(selectedArray: decodedValues)
                }
            }
            else
            {
                print("Do Nothing")
                hgt_tbl_recently_searched.constant = mintableviewHeight
            }
        }
        catch (let err)
        {
            print("decode error \(err)")
        }
    }
    
    // MARK: - Add or Remove Data in UserDefaults
    func addRemoveDataUserDefaults(selectedArray: [SearchedMovieArrayList])
    {
        var newSelectedArray = [SearchedMovieArrayList]()
        
        newSelectedArray = selectedArray
        
        print(newSelectedArray)
        do
        {
            let userDefaults = UserDefaults.standard
            userDefaults.removeObject(forKey: "recentSearched")
            
            let encodedData: Data = try NSKeyedArchiver.archivedData(withRootObject: selectedArray, requiringSecureCoding: false)

            userDefaults.set(encodedData, forKey: "recentSearched")
            userDefaults.synchronize()
            
            self.Arr_Searched_Movie_List = newSelectedArray
            
            self.tbl_recently_searched.reloadData()
        }
        catch(let err)
        {
            print("error encoding \(err)")
        }
    }
}

// MARK: - Search bar Delegate Method
extension DashboardPageViewController: UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        hgt_tbl_recently_searched.constant = mintableviewHeight
        searchedMovieResult = searchText.isEmpty ? Arr_movieResult : Arr_movieResult.filter({ (items) -> Bool in
            
            return (items.originalTitle?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil)
            
        })
        searchBarBoolean = true
        tbl_now_playing_movie_list.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.text = ""
        searchedMovieResult = Arr_movieResult
        searchBar.endEditing(true)
        tbl_now_playing_movie_list.reloadData()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool
    {
        print("should end")
        hgt_tbl_recently_searched.constant = mintableviewHeight
        return true
    }
}

// MARK: - TableView Delegate Method
extension DashboardPageViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView == tbl_now_playing_movie_list
        {
            let getSelectedValue = searchedMovieResult[indexPath.row]
            fetchID = getSelectedValue.id!
            fetchMovieName = getSelectedValue.title!
            
            if searchBarBoolean == true
            {
                if self.Arr_Searched_Movie_List.count > 5
                {
                    print("More than 5 ")
                    self.showSearchedData()
                }
                else
                {
                    print("Less than 5 ")
                    for singleMovie in searchedMovieResult
                    {
                        if fetchID == singleMovie.id!
                        {
                            self.Arr_Searched_Movie_List.append(SearchedMovieArrayList(movieID: fetchID, movieTitle: fetchMovieName))
                        }
                    }
                    
                    do
                    {
                        let userDefaults = UserDefaults.standard
                        userDefaults.removeObject(forKey: "recentSearched")
                        let encodedData: Data = try NSKeyedArchiver.archivedData(withRootObject: self.Arr_Searched_Movie_List, requiringSecureCoding: false)
                        
                        userDefaults.set(encodedData, forKey: "recentSearched")
                        userDefaults.synchronize()
                        
                        self.callStoryboard()
                    }
                    catch(let err)
                    {
                        print("error encoding \(err)")
                    }
                }
            }
            else
            {
                print("it is false")
                
                self.callStoryboard()
            }
        }
        else if tableView == tbl_recently_searched
        {
            let getNames = Arr_Searched_Movie_List[indexPath.row]
            
            let story: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let detailsPageVC = story.instantiateViewController(identifier: "MovieDetailsPageViewController") as! MovieDetailsPageViewController
            detailsPageVC.getMovieID = getNames.movieID!
            detailsPageVC.getMovieName = getNames.movieTitle!
            self.navigationController?.pushViewController(detailsPageVC, animated: true)
        }
    }
}

// MARK: - TableView DataSource Method
extension DashboardPageViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if tableView == tbl_recently_searched
        {
            return "Recently Searched"
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == tbl_now_playing_movie_list
        {
            if searchedMovieResult.count == 0
            {
                return 0
            }
            else
            {
                return searchedMovieResult.count
            }
        }
        else if tableView == tbl_recently_searched
        {
            if Arr_Searched_Movie_List.count == 0
            {
                return 0
            }
            else
            {
                return Arr_Searched_Movie_List.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == tbl_now_playing_movie_list
        {
            let cells = tableView.dequeueReusableCell(withIdentifier: "NowPlayingMovieListTableViewCell") as! NowPlayingMovieListTableViewCell
            
            cells.selectionStyle = .none
            
            let getMovieListData = searchedMovieResult[indexPath.row]
            
            let getbackgroudnPoster = getMovieListData.backdropPath
            
            let fullBackgroundURL = movieImageMainURL + getbackgroudnPoster!
            let showBackgroundPosterURL = URL(string: fullBackgroundURL)!
            
            cells.img_backgroundPoster.af.setImage(withURL: showBackgroundPosterURL, placeholderImage: placeHolderImage)

            let getMoviePoster = getMovieListData.posterPath
            
            let fullMovieURL = movieImageMainURL + getMoviePoster!
            let showMoviePosterURL = URL(string: fullMovieURL)!
            
            cells.img_movie_poster.af.setImage(withURL: showMoviePosterURL, placeholderImage: placeHolderImage)
            
            cells.lbl_movie_name.text = getMovieListData.originalTitle
            
            cells.lbl_release_date.text = "Release Date : " + getMovieListData.releaseDate!
            
            return cells
        }
        else if tableView == tbl_recently_searched
        {
            let cells = tableView.dequeueReusableCell(withIdentifier: "RecentlySearchedTableViewCell") as! RecentlySearchedTableViewCell
            
            let getData = Arr_Searched_Movie_List[indexPath.row]
            
            cells.lbl_recently_searched.text = getData.movieTitle!
            
            return cells
        }
        return UITableViewCell()
    }
}
