//
//  DCTableReviewCell.m
//  DispatchCenter
//
//  Created by Hoang Truong Minh on 10/15/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCTableReviewCell.h"

#define INDEX_CELL_AVG_RATING           0
#define INDEX_CELL_KNOWS_HIS_JOB        1
#define INDEX_CELL_WAS_ON_TIME          2
#define INDEX_CELL_RIGHT_EQUIPMENT      3
#define INDEX_CELL_PRICING              4

#define STR_SERVER_NAMING_AVERAGE_RATING    @"Average Rating"
#define STR_SERVER_NAMING_KNOWING_JOB       @"Knows his job"
#define STR_SERVER_NAMING_ON_TIME           @"Was on time"
#define STR_SERVER_NAMING_RIGHT_EQUIPMENT   @"Had the right equipment"
#define STR_SERVER_NAMING_PRICING           @"Pricing"

@implementation DCTableReviewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setReviewInfoWithIndex:(NSInteger)index withTaskInfor:(DCTaskDetailWFInfo *)infor{

    switch (index) {
        case INDEX_CELL_AVG_RATING: {
            self.textReviewContent.text = NSLocalizedString(@"Average Rating",nil);
            [self setStarRatingWithValue:infor.review.avgScore];
//            [self setStarRatingWithValue:[NSNumber numberWithFloat:3.625]];
        }
            break;
        case INDEX_CELL_KNOWS_HIS_JOB: {
            self.textReviewContent.text = NSLocalizedString(@"Knows his job",nil);
            [self setStarRatingWithValue:[self scoreForStats:STR_SERVER_NAMING_KNOWING_JOB inTask:infor]];
//            [self setStarRatingWithValue:[NSNumber numberWithFloat:2.5]]; //dummy value for testing
        }
            break;
        case INDEX_CELL_WAS_ON_TIME: {
            self.textReviewContent.text = NSLocalizedString(@"Was on Time",nil);
            [self setStarRatingWithValue:[self scoreForStats:STR_SERVER_NAMING_ON_TIME inTask:infor]];
//            [self setStarRatingWithValue:[NSNumber numberWithFloat:4.5]]; //dummy value for testing
        }
            break;
        case INDEX_CELL_RIGHT_EQUIPMENT: {
            self.textReviewContent.text = NSLocalizedString(@"Had the right equipment",nil);
            [self setStarRatingWithValue:[self scoreForStats:STR_SERVER_NAMING_RIGHT_EQUIPMENT inTask:infor]];
            
        }
            break;
        case INDEX_CELL_PRICING: {
            self.textReviewContent.text = NSLocalizedString(@"Pricing",nil);
            [self setStarRatingWithValue:[self scoreForStats:STR_SERVER_NAMING_PRICING inTask:infor]];
        }
            break;
            
        default:
            break;
    }
}

- (NSNumber*)scoreForStats:(NSString*)statName inTask:(DCTaskDetailWFInfo*)infor {
    NSNumber *valueReturn = [[NSNumber alloc] init];
    for (id item in infor.review.details ) {
        if (item && [item isKindOfClass:[DCReviewDetail class]]) {
            DCReviewDetail *detailItem = (DCReviewDetail*)item;
            if ([detailItem.name isEqualToString:statName]) {
                valueReturn = detailItem.score;
                 NSLog(@"value return === %f with name %@ \n", [valueReturn floatValue], detailItem.name);
                return valueReturn;
                
            }
            
        }
    }
    NSLog(@"value return === %f", [valueReturn floatValue]);
    return valueReturn;
}

- (void)setStarRatingWithValue: (NSNumber*)value {
    /*
     Average Rating: Please show star follow up:
     1.000 - 1.249 => 1
     1.250 - 1.749 => 1.5
     1.750 - 2.249 => 2
     2.500 - 2.749 => 2.5
     2.750 - 3.249 => 3
     3.250 - 3.749 => 3.5
     3.750 - 4.249 => 4
     4.250 - 4.749 => 4.5
     4.750 - 5.000 => 5
     */
    
    if (value) {
        NSNumber *valueToRate = [NSNumber numberWithFloat:[self convertRatingPoint:[value floatValue]]];
        NSLog (@"value to rate === %f \n", [valueToRate floatValue]);
        NSLog(@"objecC Type of value to rate === %s \n",[valueToRate objCType]);
        if (strcmp([valueToRate objCType], @encode(float)) == 0 && [valueToRate floatValue] - [valueToRate integerValue] > 0) { //score is float value, in e.g 1.5, 3.5 ...
            for (int i = 0; i < [vwRateStars count]; i++) {
                if (i < (int)[valueToRate floatValue]) {
                    UIImageView *imgStar = (UIImageView*)[vwRateStars objectAtIndex:i];
                    [imgStar setImage:[UIImage imageNamed:@"ic_star_yellow"]];
                } else if ( i == (int)[valueToRate floatValue] ) {
                    UIImageView *imgStar = (UIImageView*)[vwRateStars objectAtIndex:i];
                    [imgStar setImage:[UIImage imageNamed:@"star-half"]];
                } else {
                    UIImageView *imgStar = (UIImageView*)[vwRateStars objectAtIndex:i];
                    [imgStar setImage:[UIImage imageNamed:@"ic_star_grey"]];
                }
            }
        } else if (strcmp([valueToRate objCType], @encode(float)) == 0 && [valueToRate floatValue] - [valueToRate integerValue] == 0) { //score is integer value, in e.g 2 4 ...
            for (int i = 0; i < [vwRateStars count]; i++) {
                if (i < [valueToRate integerValue]) {
                    UIImageView *imgStar = (UIImageView*)[vwRateStars objectAtIndex:i];
                    [imgStar setImage:[UIImage imageNamed:@"ic_star_yellow"]];
                } else {
                    UIImageView *imgStar = (UIImageView*)[vwRateStars objectAtIndex:i];
                    [imgStar setImage:[UIImage imageNamed:@"ic_star_grey"]];
                }
            }
        }    
    } else {
        //do nothing

    }
}

- (float)convertRatingPoint:(float)value {
    float outputNum = 0;
    float floatingNum = 0.0f;
    floatingNum = value - (int)value;
    
    if (floatingNum < 0.25) {
        outputNum = (int)value;
    } else if ( 0.25 <= floatingNum && floatingNum < 0.75) {
        outputNum = (int)value + 0.5;
    } else if (floatingNum >= 0.75) {
        outputNum = (int)value + 1;
    }
    
    return outputNum;
}
@end
