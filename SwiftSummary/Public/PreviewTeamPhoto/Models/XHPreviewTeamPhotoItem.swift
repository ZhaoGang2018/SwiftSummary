//
//  XHPreviewTeamPhotoItem.swift
//  XCamera
//
//  Created by jing_mac on 2020/9/9.
//  Copyright © 2020 xhey. All rights reserved.
//

import UIKit
import HandyJSON

// 工作圈照片的视频信息
class XHTeamPhotoVideoInfoModel: Codable, HandyJSON {
    
    var duration: Int = 0 // 时长(秒)
    var width: Int = 0
    var height: Int = 0
    var fileSize: Int = 0 // 文件大小(byte)
    
    required init() {}
}


class XHPreviewTeamPhotoItem: XHPreviewImageOrVideoModel {
    
    var photoId: String?
    var largeUrl: String?
    var smallUrl: String?
    var latitude: String? // 纬度: "31.727576"
    var longitude: String? // 经度: "113.288957"
    // "location_type": 4, // 0未知; 1 定位失败之定位权限关闭 2 定位失败之关闭手机的定位服务；3 定位失败之其他原因；4 定位成功
    var locationType: Int?
    
    // 以下字段是V2.9.50版本添加的
    // 照片作者的userId
    var authorUserId: String?
    // 照片作者的nickname
    var authorNickname: String?
    // 照片作者的头像url
    var authorHeadImage: String?
    // 团队id
    var groupId: String?
    // 当前用户在团队的角色
    var groupRole: Int?
    // 是否有删除的权限
    var deletePermission: Bool?
    
    // V2.9.75版本添加
    var mediaType: Int = 0
    var videoURL: String?
    var videoInfo: XHTeamPhotoVideoInfoModel?
    
    convenience init(photoId: String?, largeUrl: String?, smallUrl: String?, latitude: String?, longitude: String?, locationType: Int?, authorUserId: String?, authorNickname: String?, authorHeadImage: String?, groupId: String?, groupRole: Int?, deletePermission: Bool?, mediaType: Int, videoURL: String?, videoInfo: XHTeamPhotoVideoInfoModel?) {
        
        self.init()
        
        self.type = (mediaType == 1) ? .video : .image
        self.imageUrlStr = largeUrl
        self.videoUrlStr = videoURL
        self.placeholderUrlStr = largeUrl
        
        self.photoId = photoId
        self.largeUrl = largeUrl
        self.smallUrl = smallUrl
        self.latitude = latitude
        self.longitude = longitude
        self.locationType = locationType
        self.authorUserId = authorUserId
        self.authorNickname = authorNickname
        self.authorHeadImage = authorHeadImage
        self.groupId = groupId
        self.groupRole = groupRole
        self.deletePermission = deletePermission
        
        self.mediaType = mediaType
        self.videoURL = videoURL
        self.videoInfo = videoInfo
    }
    
    /*
    // 团队相册的model
    static func buildModel(_ pModel: XHTeamAlbumPhotoItemModel, groupId: String?, groupRole: Int?, placeholderImage: UIImage?) -> XHPreviewTeamPhotoItem {
        
        let item = XHPreviewTeamPhotoItem(photoId: pModel.id, largeUrl: pModel.largeurl, smallUrl: pModel.smallurl, latitude: pModel.lat, longitude: pModel.lng, locationType: Int(pModel.locationType ?? "0"), authorUserId: pModel.userID, authorNickname: pModel.nickname, authorHeadImage: pModel.headimgURL, groupId: groupId, groupRole: groupRole, deletePermission: pModel.canDelete, mediaType: pModel.mediaType, videoURL: pModel.videoURL, videoInfo: pModel.videoInfo)
        item.type = (pModel.mediaType == 1) ? .video : .image
        item.placeholderImage = placeholderImage
        
        return item
    }
    
    // 工作圈主页
    static func buildModel(_ pModel: XHTeamPhotoModel, authorUserId: String?, nickname: String?, headimgurl: String?, groupId: String?, groupRole: Int?, placeholderImage: UIImage?) -> XHPreviewTeamPhotoItem {
        
        let del_perm = groupRole == 1 || groupRole == 2
        let item = XHPreviewTeamPhotoItem(photoId: pModel.photoID, largeUrl: pModel.largeurl, smallUrl: pModel.smallurl, latitude: pModel.lat, longitude: pModel.lng, locationType: Int(pModel.locationType ?? ""), authorUserId: authorUserId, authorNickname: nickname, authorHeadImage: headimgurl, groupId: groupId, groupRole: groupRole, deletePermission: del_perm, mediaType: pModel.mediaType, videoURL: pModel.videoURL, videoInfo: pModel.videoInfo)
        item.type = (pModel.mediaType == 1) ? .video : .image
        item.placeholderImage = placeholderImage
        
        return item
    }
    
    // 用户主页
    static func buildModel(_ pModel: WorkgroupPhotoModel, authorUserId: String?, nickname: String?, headimgurl: String?, groupId: String?, groupRole: Int?, deletePermission: Bool?, placeholderImage: UIImage?) -> XHPreviewTeamPhotoItem {
        
        let item = XHPreviewTeamPhotoItem(photoId: "\(pModel.photo_id)", largeUrl: pModel.large_url, smallUrl: pModel.small_url, latitude: pModel.lat, longitude: pModel.lng, locationType: pModel.location_type, authorUserId: authorUserId, authorNickname: nickname, authorHeadImage: headimgurl, groupId: groupId, groupRole: groupRole, deletePermission: deletePermission, mediaType: pModel.mediaType, videoURL: pModel.videoURL, videoInfo: pModel.videoInfo)
        item.type = (pModel.mediaType == 1) ? .video : .image
        item.placeholderImage = placeholderImage
        
        return item
    }
 */
}

