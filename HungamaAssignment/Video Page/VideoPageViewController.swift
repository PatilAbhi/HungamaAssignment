//
//  VideoPageViewController.swift
//  HungamaAssignment
//
//  Created by Shree on 07/05/21.
//

import UIKit

class VideoPageViewController: UIViewController
{

    @IBOutlet weak var tbl_videos_list: UITableView!
    
    var fetchVideoList = [VideoResult]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tbl_videos_list.separatorStyle = .none
        
    }
}

extension VideoPageViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let getselectedValue = fetchVideoList[indexPath.row]
        
        print(getselectedValue.name)
        
        let story: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let oppenVideoVC = story.instantiateViewController(identifier: "VideoPlayerViewController") as! VideoPlayerViewController
        oppenVideoVC.getURL = getselectedValue.key!
        self.navigationController?.pushViewController(oppenVideoVC, animated: true)
    }
}

extension VideoPageViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return fetchVideoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let vcells = tableView.dequeueReusableCell(withIdentifier: "VideoMTableViewCell") as! VideoMTableViewCell
        
        vcells.selectionStyle = .none
        
        let getValues = fetchVideoList[indexPath.row]
        
        vcells.lbl_video_name.text = getValues.name!
        
        vcells.lbl_video_type.text = "Type : " + getValues.type!
        
        return vcells
    }
}
