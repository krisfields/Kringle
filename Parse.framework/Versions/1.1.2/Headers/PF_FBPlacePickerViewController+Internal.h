/*
 * Copyright 2012 Facebook
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *    http://www.apache.org/licenses/LICENSE-2.0
 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <Foundation/Foundation.h>
#import "PF_FBPlacePickerViewController.h"
#import "PF_FBRequest.h"
#import "PF_FBGraphObjectTableDataSource.h"
#import "PF_FBSession.h"

// This is the cache identity used by both the view controller and cache descriptor objects
extern NSString *const PF_FBPlacePickerCacheIdentity;

extern const NSInteger defaultResultsLimit;
extern const NSInteger defaultRadius; 

@interface PF_FBPlacePickerViewController (Internal)

+ (PF_FBRequest*)requestForPlacesSearchAtCoordinate:(CLLocationCoordinate2D)coordinate
                                  radiusInMeters:(NSInteger)radius
                                    resultsLimit:(NSInteger)resultsLimit
                                      searchText:(NSString*)searchText
                                          fields:(NSSet*)fieldsForRequest
                                      datasource:(PF_FBGraphObjectTableDataSource*)datasource
                                         session:(PF_FBSession*)session; 
@end