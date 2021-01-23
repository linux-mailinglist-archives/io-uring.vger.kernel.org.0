Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC76301793
	for <lists+io-uring@lfdr.de>; Sat, 23 Jan 2021 19:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbhAWSXS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 Jan 2021 13:23:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726249AbhAWSXP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 Jan 2021 13:23:15 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 243AAC06174A
        for <io-uring@vger.kernel.org>; Sat, 23 Jan 2021 10:22:32 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id q2so2366151plk.4
        for <io-uring@vger.kernel.org>; Sat, 23 Jan 2021 10:22:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Om8lBnTeC8/y59N0vdmo+IqmU216IV5ocYAsBqf2YOw=;
        b=mY0id1iWYZ3tQP4kJz1DOCYcOfFgzQPtJKmBljhuMT2RsPVeEjmS3FspRxfLa1kS0p
         /Ih7rfNmBSC3D2nBzKmEkpZFyOlzrOtrSLbeZnl3iAp4I2jqWpx1DH1f4WSNQ/W67NdG
         F8J1qBUdUTaVjyttcEGawEjpIZr6LQZ7MyXbV4yMUHiSkMZbfp6MeXWytOvjP8VRW+MB
         IaibktyFls7IO6qF9tydGJ3EsXyc3NrXtMNhHib1ePR3j6tzN7DcHJ4bEDyh41KeV/iy
         Jf3zNqVAeB13aTZ4Xu7vE+9PtlAJ064MXpW+LIBGOUTOlh35sScxDEcXQeYWm+hdVJMc
         Wuww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Om8lBnTeC8/y59N0vdmo+IqmU216IV5ocYAsBqf2YOw=;
        b=PE+xktQjDGdh3Wzy4Bmy+N+xAGFs5RFXrCdHa4lnDtTJX0ls5VEYuGmAHZGDnAwBTn
         jPBR26u+l/gvxQHADpJuL/5F7P1/ODhnou5YU5kXw+bVdkDr9rbsL3SJma6urLxBu+Tn
         9zVUlr/L6Wxtvut8+wRP8m6jZof+TE1vwI1TWpxajArAvOkqK891l5NYHwAgz4XQVTSu
         +wJm/L8e0RyKCm1RwpS3wuvD5vVIUWbrR+W316DwTvuy2bayMq7bXzy1j/PzlOyTLaUh
         +agJOisrTTUrQZTpE+9GEUoh2JnVZkuX4kW5vJpK1/EkwlOv8m0o9Qug2hlnr1RTtm+Z
         E6FQ==
X-Gm-Message-State: AOAM532tXF/neHnx0oQZicHw27+wKIJx9vYqCdHmspU3ZV/5xodR3KnU
        fSp4WayxDKpeVGpneTn3lBmInA==
X-Google-Smtp-Source: ABdhPJxxQqYh+q9DyqJ90Eb00WPmVpcYv+/3ChKV1cwG81HHwntzkxGk1KNdiR2dA1n351A8raHfvw==
X-Received: by 2002:a17:902:b986:b029:df:e5d6:cd71 with SMTP id i6-20020a170902b986b02900dfe5d6cd71mr2306377pls.42.1611426151621;
        Sat, 23 Jan 2021 10:22:31 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id g17sm12360210pfk.184.2021.01.23.10.22.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Jan 2021 10:22:31 -0800 (PST)
Subject: Re: [RFC PATCH] io_uring: add support for IORING_OP_GETDENTS64
To:     Lennert Buytenhek <buytenh@wantstofly.org>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <20210123114152.GA120281@wantstofly.org>
 <b5b978ee-1a56-ead7-43bc-83ae2398b160@kernel.dk>
 <20210123181636.GA121842@wantstofly.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <fe842ed5-bcef-b40b-f06e-4a33abf16160@kernel.dk>
Date:   Sat, 23 Jan 2021 11:22:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210123181636.GA121842@wantstofly.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/23/21 11:16 AM, Lennert Buytenhek wrote:
> On Sat, Jan 23, 2021 at 10:37:25AM -0700, Jens Axboe wrote:
> 
>>> IORING_OP_GETDENTS64 behaves like getdents64(2) and takes the same
>>> arguments.
>>>
>>> Signed-off-by: Lennert Buytenhek <buytenh@wantstofly.org>
>>> ---
>>> This seems to work OK, but I'd appreciate a review from someone more
>>> familiar with io_uring internals than I am, as I'm not entirely sure
>>> I did everything quite right.
>>>
>>> A dumb test program for IORING_OP_GETDENTS64 is available here:
>>>
>>> 	https://krautbox.wantstofly.org/~buytenh/uringfind.c
>>>
>>> This does more or less what find(1) does: it scans recursively through
>>> a directory tree and prints the names of all directories and files it
>>> encounters along the way -- but then using io_uring.  (The uring version
>>> prints the names of encountered files and directories in an order that's
>>> determined by SQE completion order, which is somewhat nondeterministic
>>> and likely to differ between runs.)
>>>
>>> On a directory tree with 14-odd million files in it that's on a
>>> six-drive (spinning disk) btrfs raid, find(1) takes:
>>>
>>> 	# echo 3 > /proc/sys/vm/drop_caches 
>>> 	# time find /mnt/repo > /dev/null
>>>
>>> 	real    24m7.815s
>>> 	user    0m15.015s
>>> 	sys     0m48.340s
>>> 	#
>>>
>>> And the io_uring version takes:
>>>
>>> 	# echo 3 > /proc/sys/vm/drop_caches 
>>> 	# time ./uringfind /mnt/repo > /dev/null
>>>
>>> 	real    10m29.064s
>>> 	user    0m4.347s
>>> 	sys     0m1.677s
>>> 	#
>>>
>>> These timings are repeatable and consistent to within a few seconds.
>>>
>>> (btrfs seems to be sending most metadata reads to the same drive in the
>>> array during this test, even though this filesystem is using the raid1c4
>>> profile for metadata, so I suspect that more drive-level parallelism can
>>> be extracted with some btrfs tweaks.)
>>>
>>> The fully cached case also shows some speedup for the io_uring version:
>>>
>>> 	# time find /mnt/repo > /dev/null
>>>
>>> 	real    0m5.223s
>>> 	user    0m1.926s
>>> 	sys     0m3.268s
>>> 	#
>>>
>>> vs:
>>>
>>> 	# time ./uringfind /mnt/repo > /dev/null
>>>
>>> 	real    0m3.604s
>>> 	user    0m2.417s
>>> 	sys     0m0.793s
>>> 	#
>>>
>>> That said, the point of this patch isn't primarily to enable
>>> lightning-fast find(1) or du(1), but more to complete the set of
>>> filesystem I/O primitives available via io_uring, so that applications
>>> can do all of their filesystem I/O using the same mechanism, without
>>> having to manually punt some of their work out to worker threads -- and
>>> indeed, an object storage backend server that I wrote a while ago can
>>> run with a pure io_uring based event loop with this patch.
>>
>> The results look nice for sure.
> 
> Thanks!  And thank you for having a look.
> 
> 
>> Once concern is that io_uring generally
>> guarantees that any state passed in is stable once submit is done. For
>> the below implementation, that doesn't hold as the linux_dirent64 isn't
>> used until later in the process. That means if you do:
>>
>> submit_getdents64(ring)
>> {
>> 	struct linux_dirent64 dent;
>> 	struct io_uring_sqe *sqe;
>>
>> 	sqe = io_uring_get_sqe(ring);
>> 	io_uring_prep_getdents64(sqe, ..., &dent);
>> 	io_uring_submit(ring);
>> }
>>
>> other_func(ring)
>> {
>> 	struct io_uring_cqe *cqe;
>>
>> 	submit_getdents64(ring);
>> 	io_uring_wait_cqe(ring, &cqe);
>> 	
>> }
>>
>> then the kernel side might get garbage by the time the sqe is actually
>> submitted. This is true because you don't use it inline, only from the
>> out-of-line async context. Usually this is solved by having the prep
>> side copy in the necessary state, eg see io_openat2_prep() for how we
>> make filename and open_how stable by copying them into kernel memory.
>> That ensures that if/when these operations need to go async and finish
>> out-of-line, the contents are stable and there's no requirement for the
>> application to keep them valid once submission is done.
>>
>> Not sure how best to solve that, since the vfs side relies heavily on
>> linux_dirent64 being a user pointer...
> 
> No data is passed into the kernel on a getdents64(2) call via user
> memory, i.e. getdents64(2) only ever writes into the supplied
> linux_dirent64 user pointer, it never reads from it.  The only things
> that we need to keep stable here are the linux_dirent64 pointer itself
> and the 'count' argument and those are both passed in via the SQE, and
> we READ_ONCE() them from the SQE in the prep function.  I think that's
> probably the source of confusion here?

Good point, in fact even if we did read from it as well, the fact that
we write to it already means that it must be stable until completion
on the application side anyway. So I guess there's no issue here!

For the "real" patch, I'd split the vfs prep side into a separate one,
and then have patch 2 be the io_uring side only. Then we'll need a
test case that can be added to liburing as well (and necessary changes
on the liburing side, like op code and prep helper).

-- 
Jens Axboe

