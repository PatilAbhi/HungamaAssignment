//
//  MovieDetailsPageViewController.swift
//  HungamaAssignment
//
//  Created by Shree on 07/05/21.
//

import UIKit
import AlamofireImage

class MovieDetailsPageViewController: UIViewController
{

    let ApiKeyDomain = "c9d37e68525bb2d373707e558170668d"
    let movieImageMainURL = BaseURL.MovieImageURL
    let placeHolderImage = UIImage(named: "img_hungama")!
    
    var activityView: UIActivityIndicatorView?
    
    var getMovieID: Int = 0
    var getMovieName: String = ""
    
    var str_movieid: String = ""
    
    let minHeight: CGFloat = 0
    let maxHeight: CGFloat = 255
    
    // MARK: - Movie Synopsis
    @IBOutlet weak var img_movie_poster: DesignCustomImages!
    @IBOutlet weak var lbl_movie_names: UILabel!
    @IBOutlet weak var lbl_movie_release_notes: UILabel!
    @IBOutlet weak var lbl_languages: UILabel!
    @IBOutlet weak var lbl_genres: UILabel!
    @IBOutlet weak var lbl_synopsis_overviews: UILabel!
    
    // MARK: - Cast View
    @IBOutlet weak var vw_cast_view: UIView!
    @IBOutlet weak var hgt_cast_view_height: NSLayoutConstraint!
    
    @IBOutlet weak var header_name_cast: UILabel!
    @IBOutlet weak var col_cast_collectionview: UICollectionView!
    var Arr_cast = [Cast]()
    
    // MARK: - Crew view
    @IBOutlet weak var vw_crew_view: UIView!
    @IBOutlet weak var hgt_crew_view_height: NSLayoutConstraint!
    
    @IBOutlet weak var header_name_crew: UILabel!
    @IBOutlet weak var col_crew_collectionview: UICollectionView!
    var Arr_crew = [Crew]()
    
    // MARK: - Similar Movie List
    @IBOutlet weak var vw_similar_movies_list_view: UIView!
    @IBOutlet weak var hgt_similar_movies_view_height: NSLayoutConstraint!
    
    @IBOutlet weak var header_name_similar_movies: UILabel!
    @IBOutlet weak var col_similar_movies_collectionview: UICollectionView!
    var Arr_similarMovies = [SimilarMovieList]()
    
    // MARK: - Video Button
    @IBOutlet weak var ot_play_button: UIButton!
    var Arr_MoviesVideos = [VideoResult]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.designElement()
    }
    
    func designElement()
    {
        print("Movie ID \(getMovieID), Movie Name \(getMovieName)")
        title = getMovieName
        str_movieid = String(getMovieID)
        ot_play_button.isHidden = true
        
        self.hiddenMinHeight()
        // MARK: - API Calling Methods
        self.callforSynopsis()
        self.callforCastCrewview()
        self.callforSimilarMovieList()
        self.callApiforVideoAPI()
    }
    
    // MARK: - Hide All Elements
    func hiddenMinHeight()
    {
        self.cast_hideMinHeight()
        self.crew_hideMinHeight()
        self.similar_hideMinHeight()
    }
    
    // MARK: - Hide Cast
    func cast_hideMinHeight()
    {
        self.hgt_cast_view_height.constant = minHeight
        self.header_name_cast.isHidden = true
        self.col_cast_collectionview.isHidden = true
    }
    
    // MARK: - Hide Crew
    func crew_hideMinHeight()
    {
        self.hgt_crew_view_height.constant = minHeight
        self.header_name_crew.isHidden = true
        self.col_crew_collectionview.isHidden = true
    }
    
    // MARK: - Hide Similar Movies
    func similar_hideMinHeight()
    {
        self.hgt_similar_movies_view_height.constant = minHeight
        self.header_name_similar_movies.isHidden = true
        self.col_similar_movies_collectionview.isHidden = true
    }
    
    // MARK: - Show Cast
    func cast_showMaxHeight()
    {
        self.hgt_cast_view_height.constant = maxHeight
        self.header_name_cast.isHidden = false
        self.col_cast_collectionview.isHidden = false
    }
    
    // MARK: - Show Crew
    func crew_showMaxHeight()
    {
        self.hgt_crew_view_height.constant = maxHeight
        self.header_name_crew.isHidden = false
        self.col_crew_collectionview.isHidden = false
    }
    
    // MARK: - Show Similar Movies
    func similar_showMaxHeight()
    {
        self.hgt_similar_movies_view_height.constant = maxHeight
        self.header_name_similar_movies.isHidden = false
        self.col_similar_movies_collectionview.isHidden = false
    }
    
    // MARK: - Api call for synopsis
    func callforSynopsis()
    {
        //https://api.themoviedb.org/3/movie/460465?api_key=c9d37e68525bb2d373707e558170668d
        let movieSynopsisURL = BaseURL.MovieSynopsis + str_movieid + "?api_key=" + ApiKeyDomain
        print(movieSynopsisURL)
        
        ServerCallManager.sharedInstance.dataRequest(with: movieSynopsisURL, objectType: MovieSynopsis.self) { (result: Result) in
            switch result
            {
            case .success(let synopsis):
                DispatchQueue.main.async {
                    print(synopsis)
                    let getbackgroundImage = synopsis.backdropPath
                    
                    let fullBackgroundURL = self.movieImageMainURL + getbackgroundImage!
                    let showBackgroundURL = URL(string: fullBackgroundURL)!
                    
                    self.img_movie_poster.af.setImage(withURL: showBackgroundURL, placeholderImage: self.placeHolderImage)
                    
                    let moviename = synopsis.title!
                    
                    self.lbl_movie_names.text = moviename
                    
                    let releaseDate = synopsis.releaseDate!
                    
                    self.lbl_movie_release_notes.text = "Release Date : " + releaseDate
                    
                    let getGenres = synopsis.genres!
                    
                    var testArray = [String]()
                    for values in getGenres
                    {
                        testArray.append(values.name!)
                    }
                    
                    let joinedValue = testArray.joined(separator: ", ")
                    print("Genres \(joinedValue)")
                    
                    self.lbl_genres.text = "Genres : \(joinedValue)"
                    
                    let fetchMovieDetails = synopsis.overview
                    self.lbl_synopsis_overviews.text = fetchMovieDetails
                }
            case .failure(let err):
                print("Synopsis Error \(err)")
            }
        }
    }
    
    // MARK: - Api call for Similar Movie List
    func callforSimilarMovieList()
    {
        //https://api.themoviedb.org/3/movie/460465/similar?api_key=c9d37e68525bb2d373707e558170668d
        let similarMovieURL = BaseURL.MovieSimilarMovies + str_movieid + "/similar?api_key=" + ApiKeyDomain
        print(similarMovieURL)
        
        ServerCallManager.sharedInstance.dataRequest(with: similarMovieURL, objectType: MovieSimilarMovies.self) { (result: Result) in
            switch result
            {
            case .success(let similarmovielist):
                DispatchQueue.main.async {
                    self.Arr_similarMovies.removeAll()
                    
                    let getList = similarmovielist.results!
                    
                    for singleList in getList
                    {
                        self.Arr_similarMovies.append(singleList)
                    }
                    
                    if self.Arr_similarMovies.count != 0
                    {
                        self.similar_showMaxHeight()
                        self.col_similar_movies_collectionview.reloadData()
                    }
                    else
                    {
                        self.similar_hideMinHeight()
                    }
                }
            case .failure(let err):
                print("Error in Similar Movie List \(err)")
            }
        }
    }
    
    // MARK: - Api call for Cast and Crew
    func callforCastCrewview()
    {
        //https://api.themoviedb.org/3/movie/460465/credits?api_key=c9d37e68525bb2d373707e558170668d
        let movieCastCrewURL = BaseURL.MovieCastCredits + str_movieid + "/credits?api_key=" + ApiKeyDomain
        
        ServerCallManager.sharedInstance.dataRequest(with: movieCastCrewURL, objectType: MovieCastCrew.self ) { (result: Result) in
            switch result
            {
            case .success(let castcrew):
                DispatchQueue.main.async {
                    self.Arr_cast.removeAll()
                    self.Arr_crew.removeAll()
                    
                    let getCastList = castcrew.cast!
                    
                    for singleCast in getCastList
                    {
                        self.Arr_cast.append(singleCast)
                    }
                    
                    if self.Arr_cast.count != 0
                    {
                        self.cast_showMaxHeight()
                        self.col_cast_collectionview.reloadData()
                    }
                    else
                    {
                        self.cast_hideMinHeight()
                    }
                    
                    let getCrewList = castcrew.crew!
                    
                    for singleCrew in getCrewList
                    {
                        self.Arr_crew.append(singleCrew)
                    }
                    
                    if self.Arr_crew.count != 0
                    {
                        self.crew_showMaxHeight()
                        self.col_crew_collectionview.reloadData()
                    }
                    else
                    {
                        self.crew_hideMinHeight()
                    }
                }
            case .failure(let err):
                print("Failure in Cast Crew \(err)")
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
    
    // MARK: - API for Video Open
    func callApiforVideoAPI()
    {
        //https://api.themoviedb.org/3/movie/804435/videos?api_key=c9d37e68525bb2d373707e558170668d
        let videoURL = BaseURL.MoviesVideo + str_movieid + "/videos?api_key=" + ApiKeyDomain
        print("bVideo URL \(videoURL)")
        
        ServerCallManager.sharedInstance.dataRequest(with: videoURL, objectType: MovieVideoModel.self) { (result: Result) in
            switch result
            {
            case .success(let videos):
                DispatchQueue.main.async {
                    self.Arr_MoviesVideos.removeAll()
                    
                    let getList = videos.results!
                    
                    for singleValue in getList
                    {
                        self.Arr_MoviesVideos.append(singleValue)
                    }
                    
                    if self.Arr_MoviesVideos.count != 0
                    {
                        self.ot_play_button.isHidden = false
                    }
                    else
                    {
                        self.ot_play_button.isHidden = true
                    }
                }
            case .failure(let err):
                print("Video error \(err)")
            }
        }
    }
    
    // MARK: - Play Button Value
    @IBAction func btn_playBtn(_ sender: UIButton)
    {
        let story: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let videovc = story.instantiateViewController(identifier: "VideoPageViewController") as! VideoPageViewController
        videovc.fetchVideoList = self.Arr_MoviesVideos
        self.navigationController?.pushViewController(videovc, animated: true)
    }
    
}

// MARK: - Collection View DataSource Methods
extension MovieDetailsPageViewController: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == col_cast_collectionview
        {
            return Arr_cast.count
        }
        else if collectionView == col_crew_collectionview
        {
            return Arr_crew.count
        }
        else if collectionView == col_similar_movies_collectionview
        {
            return Arr_similarMovies.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView == col_cast_collectionview
        {
            let castCells = collectionView.dequeueReusableCell(withReuseIdentifier: "CastCollectionViewCell", for: indexPath) as! CastCollectionViewCell
            
            let getCastList = Arr_cast[indexPath.row]
            
            let castImageURL = getCastList.profilePath
            
            if castImageURL != nil
            {
                let fullCastURL = self.movieImageMainURL + castImageURL!
                let showCastURL = URL(string: fullCastURL)!
                
                castCells.img_cast_image.af.setImage(withURL: showCastURL, placeholderImage: placeHolderImage)
            }
            else
            {
                castCells.img_cast_image.image = placeHolderImage
            }
            
            
            let castRealName = getCastList.originalName!
            let castCharacterName = getCastList.character!
            
            let fullName = castRealName + "\n" + "( " + castCharacterName + " )"
            
            castCells.lbl_cast_name.text = fullName
            
            return castCells
        }
        else if collectionView == col_crew_collectionview
        {
            let crewCells = collectionView.dequeueReusableCell(withReuseIdentifier: "CrewCollectionViewCell", for: indexPath) as! CrewCollectionViewCell
            
            let getCrewList = Arr_crew[indexPath.row]
            
            let crewImageURL = getCrewList.profilePath
            
            if crewImageURL != nil
            {
                let fullCrewURL = self.movieImageMainURL + crewImageURL!
                let showCrewURL = URL(string: fullCrewURL)!
                
                crewCells.img_crew_image.af.setImage(withURL: showCrewURL, placeholderImage: placeHolderImage)
            }
            else
            {
                crewCells.img_crew_image.image = placeHolderImage
            }
            
            
            let crewJobName = getCrewList.department!
            let crewOriginalname = getCrewList.name!
            
            let fullName = crewOriginalname + "\n" + "( " + crewJobName + " )"
            
            crewCells.lbl_crew_names.text = fullName
            
            return crewCells
        }
        else if collectionView == col_similar_movies_collectionview
        {
            let similarMovieCells = collectionView.dequeueReusableCell(withReuseIdentifier: "SimilarMovieCollectionViewCell", for: indexPath) as! SimilarMovieCollectionViewCell
            
            let getSimilarMovieList = Arr_similarMovies[indexPath.row]
            
            let similarImageURL = getSimilarMovieList.posterPath
            
            if similarImageURL != nil
            {
                let fullSimilarURL = self.movieImageMainURL + similarImageURL!
                let showSimilarURL = URL(string: fullSimilarURL)!
                
                similarMovieCells.img_similar_movie_image.af.setImage(withURL: showSimilarURL, placeholderImage: placeHolderImage)
            }
            else
            {
                similarMovieCells.img_similar_movie_image.image = placeHolderImage
            }
            
            similarMovieCells.lbl_similar_movie_name.text = getSimilarMovieList.originalTitle
            
            return similarMovieCells
        }
        return UICollectionViewCell()
    }
    
    
}

// MARK: - Collection View Delegate Flow Layout
extension MovieDetailsPageViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if collectionView == col_cast_collectionview
        {
            let size = col_cast_collectionview.frame.size
            return CGSize(width: size.width / 2.5, height: size.height)
        }
        else if collectionView == col_crew_collectionview
        {
            let size = col_crew_collectionview.frame.size
            return CGSize(width: size.width / 2.5, height: size.height)
        }
        else if collectionView == col_similar_movies_collectionview
        {
            let size = col_similar_movies_collectionview.frame.size
            return CGSize(width: size.width / 2.5, height: size.height)
        }
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        if collectionView == col_cast_collectionview
        {
            return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        }
        else if collectionView == col_crew_collectionview
        {
            return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        }
        else if collectionView == col_similar_movies_collectionview
        {
            return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        }
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        if collectionView == col_cast_collectionview
        {
            return 5.0
        }
        else if collectionView == col_crew_collectionview
        {
            return 5.0
        }
        else if collectionView == col_similar_movies_collectionview
        {
            return 5.0
        }
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        if collectionView == col_cast_collectionview
        {
            return 0.0
        }
        else if collectionView == col_crew_collectionview
        {
            return 0.0
        }
        else if collectionView == col_similar_movies_collectionview
        {
            return 0.0
        }
        return 0.0
    }
}

extension MovieDetailsPageViewController: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if collectionView == col_cast_collectionview
        {
            let getName = Arr_cast[indexPath.row]
            
            print("selected Cast Name \(getName)")
        }
        else if collectionView == col_crew_collectionview
        {
            let getSelectedName = Arr_crew[indexPath.row]
            
            print("selected Crew Name \(getSelectedName)")
        }
        else if collectionView == col_similar_movies_collectionview
        {
            let getSelectedName = Arr_similarMovies[indexPath.row]
            
            print("selected similar movie \(getSelectedName)")
        }
    }
}
