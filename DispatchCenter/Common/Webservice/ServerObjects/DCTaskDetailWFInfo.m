//
//  DCTaskDetailWFInfo.m
//  DispatchCenter
//
//  Created by Hoang Truong Minh on 10/16/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCTaskDetailWFInfo.h"
@class DCProgressInfo;
@class DCProgressStatus;
@implementation DCProgressStatus
@end
@implementation DCProgressInfo
@end
@implementation DCTeamMember
@end
@implementation DCAddressInfor
@end
@implementation DCDistrict
@end
@implementation DCProvince
@end
@implementation DCSubdistrict
@end
@implementation DCTaskReview
@end
@implementation DCTaskTeam
@end
@implementation DCReviewDetail
@end

@implementation DCTaskDetailWFInfo


- (void)parseResponse:(NSDictionary *)response {
    if (response && [response isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = response;
        
        id iduID = [dict objectForKey:@"id"];
        if (iduID && [iduID isKindOfClass:[NSNumber class]]) {
            self.uID = iduID;
        }
        id summary = [dict objectForKey:@"summary"];
        if (summary && [summary isKindOfClass:[NSString class]]) {
            self.summaryText = summary;
        }
        
        self.task_no = [dict objectForKey:@"task_no"];
        
        // customer_qb_id
        self.mStrCustomer_qb_room_id = [dict stringForKey:@"customer_qb_room_id"] ?  : @"";
        self.mStrCustomer_qb_room_jId = [dict stringForKey:@"customer_qb_room_jid"] ? : @"";
        
        // due date
        id dueDate = [dict objectForKey:@"due_date"];
        self.due_date = dueDate;
        id createdDate = [dict objectForKey:@"created_date"];
        self.created_date = createdDate;
        
        self.amount_total = [dict stringForKey:@"amount_total"];
        self.amount_tax = [dict stringForKey:@"amount_tax"];
        self.amount_untaxed = [dict stringForKey:@"amount_untaxed"];
    
        
        //address
        id taskAddress = [dict objectForKey:@"address"];
        self.taskAddress = [[DCAddressInfor alloc] init];
        DCAddressInfor *addressInfo = [[DCAddressInfor alloc] init];
        if (taskAddress && [taskAddress isKindOfClass:[NSDictionary class]]) {
            self.taskAddress.address1 = [taskAddress stringForKey:@"address1"];
            self.taskAddress.address2 = [taskAddress stringForKey:@"address2"];
            id district = [taskAddress objectForKey:@"district"];
            if (district && [district isKindOfClass:[NSDictionary class]]) {
                DCDistrict *tempDisctrict = [[DCDistrict alloc] init];
                tempDisctrict.districtId = [district objectForKey:@"id"];
                tempDisctrict.districtName = [district stringForKey:@"name"];
                self.taskAddress.district = tempDisctrict;
            }
            
            id province = [taskAddress objectForKey:@"province"];
            if (province && [province isKindOfClass:[NSDictionary class]]) {
//                self.taskAddress.province = (DCProvince*)province;
                DCProvince *tempProvince = [[DCProvince alloc] init];
                tempProvince.provinceId = [province objectForKey:@"id"];
                tempProvince.provinceName = [province stringForKey:@"name"];
                self.taskAddress.province = tempProvince;
            }
            
            id subdistrict = [taskAddress objectForKey:@"subdistrict"];
            if (subdistrict && [subdistrict isKindOfClass:[NSDictionary class]]) {
//                self.taskAddress.subdistrict = (DCSubdistrict*)subdistrict;
                DCSubdistrict *tempSubDistrict = [[DCSubdistrict alloc] init];
                tempSubDistrict.subdistrictId = [subdistrict objectForKey:@"id"];
                tempSubDistrict.subdistrictName = [subdistrict stringForKey:@"name"];
                self.taskAddress.subdistrict = tempSubDistrict;
            }
            
            id zip = [taskAddress objectForKey:@"zip"];
            if (zip && [zip isKindOfClass:[NSString class]]) {
                self.taskAddress.zip = zip;
            }
            
            id geoCoordinate = [taskAddress objectForKey:@"geo_location"];
            if (geoCoordinate && [geoCoordinate isKindOfClass:[NSDictionary class]]) {
                CGFloat lat = [[geoCoordinate objectForKey:@"latitude"] floatValue];
                CGFloat longi = [[geoCoordinate objectForKey:@"longitude"] floatValue];
                self.taskAddress.geoLocation = CLLocationCoordinate2DMake(lat, longi);
            }
           
        }
//        self.taskAddress = addressInfo;
        //mobile
        self.mobileNum = [dict stringForKey:@"mobile"];
        self.operatorEndDate = [dict stringForKey:@"operator_end_date"];
        self.operatorStartDate = [dict stringForKey:@"operator_start_date"];
        
        //status
        id taskStatus = [dict objectForKey:@"status"];
        if (taskStatus && [taskStatus isKindOfClass:[NSDictionary class]]) {
            id sttCode = [taskStatus objectForKey:@"code"];
            if (sttCode && [sttCode isKindOfClass:[NSString class]]) {
                self.code = sttCode;
            }
            id sttName = [taskStatus objectForKey:@"name"];
            if (sttName && [sttName isKindOfClass:[NSString class]]) {
                self.name = sttName;
            }
        }
        //allow actions
        id allowActions = [dict objectForKey:@"allow_actions"];
        if (allowActions && [allowActions isKindOfClass:[NSDictionary class]]) {
            //customer array
            id customer = [allowActions objectForKey:@"customer"];
            if (customer && [customer isKindOfClass:[NSArray class]]) {
                NSMutableArray *tempArray = [[NSMutableArray alloc] init];
                for (int i = 0 ; i < [customer count]; i++) {
                    [tempArray addObject:[customer objectAtIndex:i]];
                }
                self.customer = [tempArray copy];
            }
            //workforce array
            id workforce = [allowActions objectForKey:@"workforce"];
            if (workforce && [workforce isKindOfClass:[NSArray class]]) {
                NSMutableArray *tempArr = [[NSMutableArray alloc] init];
                for (int i = 0; i < [workforce count]; i++) {
                    [tempArr addObject:[workforce objectAtIndex:i]];
                }
                self.workforce = [tempArr copy];
            }
        }
        
        
        //progress history
        id taskProgressHistory = [dict objectForKey:@"progress_history"];
        if (taskProgressHistory && [taskProgressHistory isKindOfClass:[NSArray class]]) {
            NSMutableArray *tempTaskHistory = [[NSMutableArray alloc] init];
            for (int i = 0; i < [taskProgressHistory count]; i++) {
                id progressInfo = [taskProgressHistory objectAtIndex:i];
                if (progressInfo && [progressInfo isKindOfClass:[NSDictionary class]]) {
                    DCProgressInfo *progInfo = [[DCProgressInfo alloc] init];
                    progInfo.code = [progressInfo objectForKey:@"code"];
                    progInfo.name = [progressInfo objectForKey:@"name"];
                    id status = [progressInfo objectForKey:@"status"];
                    if (status && [status isKindOfClass:[NSDictionary class]]) {
                        DCProgressStatus *stt = [[DCProgressStatus alloc] init];
                        stt.name = [status objectForKey:@"name"];
                        stt.code = [status objectForKey:@"code"];
                        progInfo.status = stt;
                    }
                    [tempTaskHistory addObject:progInfo];
                }
                
            }
            self.progressHistory = [tempTaskHistory copy];
        }
        
        
        //review
        id taskReview = [dict objectForKey:@"review"];
        self.review = [[DCTaskReview alloc] init];
        if (taskReview && [taskReview isKindOfClass:[NSDictionary class]]) {
            self.review.reviewId = [taskReview objectForKey:@"id"];
            self.review.templateId = [taskReview objectForKey:@"template_id"];
            self.review.avgScore = [taskReview objectForKey:@"avg_score"];
            self.review.comment = [taskReview objectForKey:@"comment"];
            id reviewDetails = [taskReview objectForKey:@"details"];
            NSMutableArray *tempDetailsArray = [[NSMutableArray alloc] init];
            if (reviewDetails && [reviewDetails isKindOfClass:[NSArray class]]) {
                for (int i = 0; i < [reviewDetails count]; i++) {
                    id detail = [reviewDetails objectAtIndex:i];
                    if (detail && [detail isKindOfClass:[NSDictionary class]]) {
                        DCReviewDetail *detailItem = [[DCReviewDetail alloc] init];
                        detailItem.detailId = [detail objectForKey:@"id"];
                        detailItem.name = [detail stringForKey:@"name"];
                        detailItem.score = [detail objectForKey:@"score"];
                        [tempDetailsArray addObject:detailItem];
                    }
                }
                self.review.details = [tempDetailsArray copy];
            }
        }
        
        //team info
        id teamInfo = [dict objectForKey:@"team"];
        if (teamInfo && [teamInfo isKindOfClass:[NSDictionary class]]) {
            self.team = [[DCTaskTeam alloc] init];
            id contact = [teamInfo objectForKey:@"contact"];
            if (contact && [contact isKindOfClass:[NSDictionary class]]) {
                id image = [contact objectForKey:@"image"];
                if (image && [image isKindOfClass:[NSString class]]) {
                    self.team.contactImage = image;
                }
                id mobile = [contact objectForKey:@"mobile"];
                if (mobile && [mobile isKindOfClass:[NSString class]]) {
                    self.team.contactMobile = mobile;
                }
                id name = [contact objectForKey:@"name"];
                if (name && [name isKindOfClass:[NSString class]]) {
                    self.team.contactName = name;
                }
                id enabledShareLocation = [contact stringForKey:@"share_location"];
                if (enabledShareLocation && [enabledShareLocation isEqualToString:@"enable"]) {
                    self.team.enabledShareLocation = YES;
                } else {
                    self.team.enabledShareLocation = NO;
                }
                id userQb = [contact objectForKey:@"user_qb"];
                if (userQb && [userQb isKindOfClass:[NSDictionary class]]) {
                    id idUserQb = [userQb stringForKey:@"user_id"];
                    if (idUserQb) {
                        self.team.idUserQB = idUserQb;
                    }
                }
            }
        }
        id teamId = [teamInfo objectForKey:@"id"];
        if (teamId && [teamId isKindOfClass:[NSString class]]) {
            self.team.teamId = [NSNumber numberWithInteger:[teamId integerValue]];
        }
        
        id members = [teamInfo objectForKey:@"members"];
        if (members && [members isKindOfClass:[NSArray class]]) {
            NSMutableArray *tempArr = [[NSMutableArray alloc] init];
            for (int i = 0 ; i < [members count]; i++) {
                DCTeamMember *mem = [[DCTeamMember alloc] init];
                mem.teamMemberImg = [[members objectAtIndex:i] stringForKey:@"image"];
                mem.teamMemberName = [[members objectAtIndex:i] stringForKey:@"name"];
                [tempArr addObject:mem];
            }
            self.team.teamMembers = [tempArr copy];
        }       
    }
}
@end
