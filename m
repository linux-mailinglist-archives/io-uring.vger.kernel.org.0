Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9793F47E493
	for <lists+io-uring@lfdr.de>; Thu, 23 Dec 2021 15:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348841AbhLWOjk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Dec 2021 09:39:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232183AbhLWOjk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Dec 2021 09:39:40 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A05EC061401
        for <io-uring@vger.kernel.org>; Thu, 23 Dec 2021 06:39:40 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id j6so4400545ila.4
        for <io-uring@vger.kernel.org>; Thu, 23 Dec 2021 06:39:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=s3f+TQ9iLWlS/aXZfN59r6gQT00y4xqFdXItiX16uEA=;
        b=ligSn8AupJaRrFczpGV4q6H/3/bTv6/7LQtPLnL9PG1Dx9KMWzQinPejWuyzkHup20
         2rNFqCXjmAKhfV5oUiROfqMWxqbQ9FfTTXOFw3sip0m9Mmd6Qi1H5zrwRNo9ovbDOjnp
         auDJ8fqrIJbV52V7Gbi5p55W91fX3OhUo4E7jIEGUrmiOAt28jwN0jVTl8R2UPyjrqTj
         FHWyNrmrRiMRu81z0g0IFbemqeB5IvkZrawXq9kUDaJZAejoRsvTqKBV8loJszYXhuh/
         Ip+Zsmuv29fBKbGVbxzLlpGjsr4/XTn179onNRk2Md0KSsqHYKSXpGtvZEq957+dzq2f
         ALAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s3f+TQ9iLWlS/aXZfN59r6gQT00y4xqFdXItiX16uEA=;
        b=ooGdh8IKJ3PVonnWH1Nii+lHMCNI3sdRQYFZv+e1mI+XSCKFxRM+C6PhjP8LxW3m9c
         L3v/2r0g4s/Ky5r3ZgU1kiaMBAj01z9IV/WGaoiKb8XUHFP0hI5xixfdVpv9hfBDTLzh
         XgVHyGHAtKM2BECOBZhs7sUr9oessBGdNDVkTjxdoC27VIQvyosobuBbazFlgjxbvUql
         ogwYJWu9V87H1/iBrOyBrnojO2/Wymc6+vZ701FNYjD+Ih7jh9UJ2L+9KaJ1w7AO1RHD
         Z7arQEYhW7gyjjN3CzJqvsHyQ6MVYjswiX3FelfVnakq2lGrqk6LMjIV/r0agZadFIJI
         amIQ==
X-Gm-Message-State: AOAM5321ZysZVfjrTFgA4kK8hCco6iVOtn7run+X662RVTAOFYcjZf+t
        oYxiuYzGZ2KTKxgTH2XhmHSzew==
X-Google-Smtp-Source: ABdhPJxZrSZe4H7uidNIV+/qoXI6tri4TEfxgw2ZcdRaSrBlm4uyt0hNGEWTRJ767v1Ee2Z8kdxEFw==
X-Received: by 2002:a05:6e02:1546:: with SMTP id j6mr1148273ilu.310.1640270378743;
        Thu, 23 Dec 2021 06:39:38 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id r1sm2653450ilo.38.2021.12.23.06.39.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Dec 2021 06:39:38 -0800 (PST)
Subject: Re: [PATCH v6 0/5] io_uring: add xattr support
To:     Christian Brauner <christian.brauner@ubuntu.com>,
        Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kernel-team@fb.com, torvalds@linux-foundation.org
References: <20211222210127.958902-1-shr@fb.com>
 <20211223110453.zbyah76jpc3ivjfp@wittgenstein>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <35dcdd4b-8bf3-bd67-d045-bd99ea524777@kernel.dk>
Date:   Thu, 23 Dec 2021 07:39:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211223110453.zbyah76jpc3ivjfp@wittgenstein>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/23/21 4:04 AM, Christian Brauner wrote:
> On Wed, Dec 22, 2021 at 01:01:22PM -0800, Stefan Roesch wrote:
>> This adds the xattr support to io_uring. The intent is to have a more
>> complete support for file operations in io_uring.
>>
>> This change adds support for the following functions to io_uring:
>> - fgetxattr
>> - fsetxattr
>> - getxattr
>> - setxattr
>>
>> Patch 1: fs: split off do_user_path_at_empty from user_path_at_empty()
>>   This splits off a new function do_user_path_at_empty from
>>   user_path_at_empty that is based on filename and not on a
>>   user-specified string.
>>
>> Patch 2: fs: split off setxattr_setup function from setxattr
>>   Split off the setup part of the setxattr function.
>>
>> Patch 3: fs: split off do_getxattr from getxattr
>>   Split of the do_getxattr part from getxattr. This will
>>   allow it to be invoked it from io_uring.
>>
>> Patch 4: io_uring: add fsetxattr and setxattr support
>>   This adds new functions to support the fsetxattr and setxattr
>>   functions.
>>
>> Patch 5: io_uring: add fgetxattr and getxattr support
>>   This adds new functions to support the fgetxattr and getxattr
>>   functions.
>>
>>
>> There are two additional patches:
>>   liburing: Add support for xattr api's.
>>             This also includes the tests for the new code.
>>   xfstests: Add support for io_uring xattr support.
>>
>>
>> V6: - reverted addition of kname array to xattr_ctx structure
>>       Adding the kname array increases the io_kiocb beyond 64 bytes
>>       (increases it to 224 bytes). We try hard to limit it to 64 bytes.
>>       Keeping the original interface also is a bit more efficient.
>>     - rebased on for-5.17/io_uring-getdents64
>> V5: - add kname array to xattr_ctx structure
>> V4: - rebased patch series
>> V3: - remove req->file checks in prep functions
>>     - change size parameter in do_xattr
>> V2: - split off function do_user_path_empty instead of changing
>>       the function signature of user_path_at
>>     - Fix datatype size problem in do_getxattr
>>
>>
>>
>> Stefan Roesch (5):
>>   fs: split off do_user_path_at_empty from user_path_at_empty()
>>   fs: split off setxattr_setup function from setxattr
>>   fs: split off do_getxattr from getxattr
>>   io_uring: add fsetxattr and setxattr support
>>   io_uring: add fgetxattr and getxattr support
>>
>>  fs/internal.h                 |  23 +++
>>  fs/io_uring.c                 | 318 ++++++++++++++++++++++++++++++++++
>>  fs/namei.c                    |  10 +-
>>  fs/xattr.c                    | 107 ++++++++----
>>  include/linux/namei.h         |   2 +
>>  include/uapi/linux/io_uring.h |   8 +-
>>  6 files changed, 428 insertions(+), 40 deletions(-)
>>
>>
>> base-commit: b4518682080d3a1cdd6ea45a54ff6772b8b2797a
> 
> Jens, please keep me in the loop once this series lands.

You bet, and thanks for the reviews!

> I maintain a large vfs testsuite for idmapped mounts (It's actually a
> generic testsuite which also tests idmapped mounts.) and it currently
> already has tests for io_uring:
> 
> https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git/tree/src/idmapped-mounts/idmapped-mounts.c#n6942
> 
> Once this lands we need to expand it to test xattr support for io_uring
> as well (It should probably also include mkdir/link/mknod that we added
> last cycle.).

There are a few basic tests here:

https://git.kernel.dk/cgit/liburing/log/?h=xattr

as well, but more of a sanity kind of checking, would be great if tests
were added to the VFS suite as well.

With the last few kinks ironed out, I hope to queue the next version
posted for 5.17.

-- 
Jens Axboe

