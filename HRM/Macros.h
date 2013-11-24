//
//  Macros.h
//  heartrate
//
//  Created by Jonathan Grana on 11/23/13.
//  Copyright (c) 2013 Dev Marvel LLC. All rights reserved.
//

#ifndef heartrate_Macros_h
#define heartrate_Macros_h

#define BLUETOOTH !TARGET_IPHONE_SIMULATOR

#define SHARED_SINGLETON_HEADER(_class) \
+ (_class *)shared;

#define SHARED_SINGLETON_IMPLEMENTATION(_class) \
+ (_class *)shared { \
static dispatch_once_t once; \
static _class *sharedInstance = nil; \
dispatch_once(&once, ^{ \
sharedInstance = [[self alloc] init]; \
}); \
return sharedInstance; \
}


#define WEAK(_obj) \
__weak __typeof__(_obj) weak_ ## _obj = _obj

#endif
