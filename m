Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF5835897E
	for <lists+io-uring@lfdr.de>; Thu,  8 Apr 2021 18:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232258AbhDHQSx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Apr 2021 12:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231893AbhDHQSv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Apr 2021 12:18:51 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A79C061760
        for <io-uring@vger.kernel.org>; Thu,  8 Apr 2021 09:18:39 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id t20so1293317plr.13
        for <io-uring@vger.kernel.org>; Thu, 08 Apr 2021 09:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=93jAfYyln1KsbpfZkKRr65icniT3oHxmEeH1ecZDh8s=;
        b=yhApnqDqxbugy2/i4VHCQo7jZLPfuRQrP8qBxI3nCvgavJwMgpsqk8UadiJcELJF7o
         lFGP1r0ekzhT40bD46zM/KTmZPSs3qjs6uE9u/pDIyCiG8E0CNhNu3vRLALy+mAA4WYR
         CW5bn94+IM2cnEGjn5j20uuCCgYIfkBm39hy0dbdwBxM3LFCdvLa2Jb9me927lSv7mbz
         Beb8AnRI2QwWBtruZlHORnaObtQQ0u7L6+237EjmrF7K9kFDY3nl5983wrIhFPFD7YZb
         rJVmUjCPbZkkB8EFSIcR0NT3lCidt7pGrpcWzv1oBCEiHnL3FywICT3QmmMaEHjOFyXB
         /JNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=93jAfYyln1KsbpfZkKRr65icniT3oHxmEeH1ecZDh8s=;
        b=kn5J2DXp/CnTyVGtctes6Bd5m9oX2SyhinCP5iV1ZWm5DM9A3eDWeeAgdHnMCaK5Yh
         M/+7LTgiyl/FDvFDzUZU//rhxubfkoSaJm2PJohTbU8o4vJgwslePA0hrGPDc2o8X3fP
         pX9FFj16IsMgMFI1b4jHXTOnZOG6Y8hLEDohRUyyuuJ7w3myYbqPc2196LR8FfqSu31Q
         t1jeeh5Pd5ShWIfSjet/qRYwCRYOm3TgdyASzL4ivtRzYjdnXsdZXeXC9jdGp6AvquKj
         n55vGBi56uqcVmhbI3uIkBBVHoF1AXcPjRhjIYyxtEkagD6kWO3elnUs5BFsehRqtkpU
         z0TA==
X-Gm-Message-State: AOAM5302AuLEi0ddU7+Ph/4ezTsRCgQZ48vpMV7aF9JxvwoXrD9Y97el
        kcpAGZZDXFWClVbDZiqp/69La8Fw1pkI1A==
X-Google-Smtp-Source: ABdhPJw+i6IMmeQLsAfN9qiSJhebuOvFJzpCr+52hN/hTPgyCSNWt6VeRqn+mDe4WBkFjCZP5gRUOA==
X-Received: by 2002:a17:902:a9c7:b029:e8:de49:6a76 with SMTP id b7-20020a170902a9c7b02900e8de496a76mr8673337plr.63.1617898718256;
        Thu, 08 Apr 2021 09:18:38 -0700 (PDT)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id b10sm25318895pgm.76.2021.04.08.09.18.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Apr 2021 09:18:37 -0700 (PDT)
Subject: Re: [PATCH 5.13 v2] io_uring: maintain drain requests' logic
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1617794605-35748-1-git-send-email-haoxu@linux.alibaba.com>
 <00898a9b-d2f2-1108-b9d9-2d6acea6e713@kernel.dk>
 <32f812e1-c044-d4b3-d26f-3721e4611a1d@linux.alibaba.com>
 <119436dd-5e55-9812-472c-7a257bda12fb@linux.alibaba.com>
 <826e199f-1cc0-f529-f200-5fa643a62bca@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <19183813-6755-52bb-5391-4809a837ec5f@kernel.dk>
Date:   Thu, 8 Apr 2021 10:18:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <826e199f-1cc0-f529-f200-5fa643a62bca@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/8/21 6:22 AM, Pavel Begunkov wrote:
> On 08/04/2021 12:43, Hao Xu wrote:
>> 在 2021/4/8 下午6:16, Hao Xu 写道:
>>> 在 2021/4/7 下午11:49, Jens Axboe 写道:
>>>> On 4/7/21 5:23 AM, Hao Xu wrote:
>>>>> more tests comming, send this out first for comments.
>>>>>
>>>>> Hao Xu (3):
>>>>>    io_uring: add IOSQE_MULTI_CQES/REQ_F_MULTI_CQES for multishot requests
>>>>>    io_uring: maintain drain logic for multishot requests
>>>>>    io_uring: use REQ_F_MULTI_CQES for multipoll IORING_OP_ADD
>>>>>
>>>>>   fs/io_uring.c                 | 34 +++++++++++++++++++++++++++++-----
>>>>>   include/uapi/linux/io_uring.h |  8 +++-----
>>>>>   2 files changed, 32 insertions(+), 10 deletions(-)
>>>>
>>>> Let's do the simple cq_extra first. I don't see a huge need to add an
>>>> IOSQE flag for this, probably best to just keep this on a per opcode
>>>> basis for now, which also then limits the code path to just touching
>>>> poll for now, as nothing else supports multishot CQEs at this point.
>>>>
>>> gotcha.
>>> a small issue here:
>>>   sqe-->sqe(link)-->sqe(link)-->sqe(link, multishot)-->sqe(drain)
>>>
>>> in the above case, assume the first 3 single-shot reqs have completed.
>>> then I think the drian request won't be issued now unless the multishot request in the linkchain has been issued. The trick is: a multishot req
>>> in a linkchain consumes cached_sq_head when io_get_sqe(), which means it
>>> is counted in seq, but we will deduct the sqe when it is issued if we
>>> want to do the job per opcode not in the main code path.
>>> before the multishot req issued:
>>>       all_sqes(4) - multishot_sqes(0) == all_cqes(3) - multishot_cqes(0)
>>> after the multishot req issued:
>>>       all_sqes(4) - multishot_sqes(1) == all_cqes(3) - multishot_cqes(0)
>>
>> Sorry, my statement is wrong. It's not "won't be issued now unless the
>> multishot request in the linkchain has been issued". Actually I now
>> think the drain req won't be issued unless the multishot request in the
>> linkchain has completed. Because we may first check req_need_defer()
>> then issue(req->link), so:
>>    sqe0-->sqe1(link)-->sqe2(link)-->sqe3(link, multishot)-->sqe4(drain)
>>
>>   sqe2 is completed:
>>     call req_need_defer:
>>     all_sqes(4) - multishot_sqes(0) == all_cqes(3) - multishot_cqes(0)
>>   sqe3 is issued:
>>     all_sqes(4) - multishot_sqes(1) == all_cqes(3) - multishot_cqes(0)
>>   sqe3 is completed:
>>     call req_need_defer:
>>     all_sqes(4) - multishot_sqes(1) == all_cqes(3) - multishot_cqes(0)
>>
>> sqe4 shouldn't wait sqe3.
> 
> Do you mean it wouldn't if the patch is applied? Because any drain
> request must wait for all requests submitted before to complete. And
> so before issuing sqe4 it must wait for sqe3 __request__ to die, and
> so for all sqe3's CQEs.
> 
> previously 

I think we need to agree on what multishot means for dependencies. Does
it mean it just needs to trigger once? Or does it mean that it needs to
be totally finished. The latter may obviously never happen, depending on
the use case. Or it may be an expected condition because the caller will
cancel it at some point.

The most logical view imho is that multishot changes nothing wrt drain.
If you ask for drain before something executes and you are using
multishot, then you need to understand that the multishot request needs
to fully complete before that condition is true and your dependency can
execute.

-- 
Jens Axboe

