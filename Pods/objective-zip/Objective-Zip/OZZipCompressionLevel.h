//
//  OZZipCompressionLevel.h
//  Objective-Zip v. 1.0.3
//
//  Created by Gianluca Bertani on 27/08/15.
//  Copyright 2009-2015 Gianluca Bertani. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions
//  are met:
//
//  * Redistributions of source code must retain the above copyright notice,
//    this list of conditions and the following disclaimer.
//  * Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.
//  * Neither the name of Gianluca Bertani nor the names of its contributors
//    may be used to endorse or promote products derived from this software
//    without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//

#ifndef Objective_Zip_OZZipCompressionLevel_h
#define Objective_Zip_OZZipCompressionLevel_h


/**
 @brief Compression level to be used to compress new files added to the zip
 file.
 */
typedef NS_ENUM(NSInteger, OZZipCompressionLevel) {
    
    /**
     @brief Compression level that compresses the new file somewhere inbetween
     OZZipCompressionLevelBest and OZZipCompressionLevelFastest.
     */
    OZZipCompressionLevelDefault= -1,
    
    /**
     @brief Compression level that does not compress the new file, it is
     stored as is.
     */
    OZZipCompressionLevelNone= 0,
    
    /**
     @brief Compression level that compresses the new file as fast as
     possible, corresponding to the least compression.
     */
    OZZipCompressionLevelFastest= 1,
    
    /**
     @brief Compression level that compresses the new file as much as
     possible, corresponding to the slowest compression.
     */
    OZZipCompressionLevelBest= 9
};


#endif
