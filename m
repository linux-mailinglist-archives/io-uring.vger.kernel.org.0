Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0293E3596DA
	for <lists+io-uring@lfdr.de>; Fri,  9 Apr 2021 09:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232181AbhDIHyn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Apr 2021 03:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbhDIHym (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Apr 2021 03:54:42 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C317EC061760
        for <io-uring@vger.kernel.org>; Fri,  9 Apr 2021 00:54:29 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id j20-20020a05600c1914b029010f31e15a7fso4188374wmq.1
        for <io-uring@vger.kernel.org>; Fri, 09 Apr 2021 00:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2cH2ZqlZQvoPVrGJtTmzu5pn0flyfBoub4TXTb3xyvs=;
        b=d7VsaMg5ezGfG1aHO5oAXA85uUAIjKF7lkgyDWt7FW4YRzWh8LQOEtIE7g/jRr73da
         O955xnkKADf84O9f8SJ8JeEk6HsVM5p1IbAStRL3Lv691olE3Lq0Oq/FI9RridceRLJf
         rRmaiNwDChBlwxy1gDyUTQCyktouImeJ1i2eCST++DijjxsvmZ/PgFkgbbWdeAJVak47
         CGbXdvzgAI3F5s26uxgjyZwM95eym1Ry0BKikTCLYHLEvW9GzS0uh5VI9MILD7Le/3R8
         pqDftpUAToEIs/+z/KaCMESCyOSYL7hXtJ77zYpjPEJd0qfgNhvFHf9D6IWr2fvMJXRr
         rEHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=2cH2ZqlZQvoPVrGJtTmzu5pn0flyfBoub4TXTb3xyvs=;
        b=BmSVe60OIjk6XxSqSvJykuQNPhE/xkhbqngdFaRxOvAkQ3UE8e7nlPHOwYkGviAxU8
         WHykwIz3m+0nTWre3GvUnzyhpSUT/H/WI5PHcaZ4OeRopqgx+fWfxGH/Q4tuqVDRLIkC
         5SDNSFhqZG8jQ/NhPB7eHNwSF09bn56IQG7MsOok59ouzsUsxShR9ykUBfwLkbd76WK9
         Fq0sS1X0ZTMs5rfDE3HjHcZJ2w1GExPI1456HqAUvXadSJtpWsFjvPZismnk61JeZGyH
         31hNj+dE/RZCxc8kEQEnu8JKwDDfcSLQiSQqYm5AwkSU+/JO7fDry+0vhCuwaFv5RzlC
         ZdUw==
X-Gm-Message-State: AOAM532m9+NBZFL5yjte8MM22OuQDDhmdjRgagnh0woECQCydZMUKeRw
        HTHrJaLOcyyd88UsAEw5+ZGd+hPhwUAuRw==
X-Google-Smtp-Source: ABdhPJyyFj2dEjscLoDuSEkFXXhn+Sy29OjGfeotCi0H6yo3eE9tP3Q+FfelYM9YJbqXJqqXjyaHww==
X-Received: by 2002:a7b:cbc4:: with SMTP id n4mr12883433wmi.153.1617954867886;
        Fri, 09 Apr 2021 00:54:27 -0700 (PDT)
Received: from [192.168.8.161] ([148.252.128.224])
        by smtp.gmail.com with ESMTPSA id n2sm3055525wrq.59.2021.04.09.00.54.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Apr 2021 00:54:27 -0700 (PDT)
Subject: Re: [PATCH 5.13 v2] io_uring: maintain drain requests' logic
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1617794605-35748-1-git-send-email-haoxu@linux.alibaba.com>
 <00898a9b-d2f2-1108-b9d9-2d6acea6e713@kernel.dk>
 <32f812e1-c044-d4b3-d26f-3721e4611a1d@linux.alibaba.com>
 <119436dd-5e55-9812-472c-7a257bda12fb@linux.alibaba.com>
 <826e199f-1cc0-f529-f200-5fa643a62bca@gmail.com>
 <19183813-6755-52bb-5391-4809a837ec5f@kernel.dk>
 <9fd3a4c0-488f-ca82-083a-78d448a1564e@linux.alibaba.com>
 <ba02965b-69e5-a72f-e9cf-a613af55c7b5@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <b56053a6-9aa1-f682-3079-0aeb32da8074@gmail.com>
Date:   Fri, 9 Apr 2021 08:50:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <ba02965b-69e5-a72f-e9cf-a613af55c7b5@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 09/04/2021 08:05, Hao Xu wrote:
> 在 2021/4/9 下午2:15, Hao Xu 写道:
>> 在 2021/4/9 上午12:18, Jens Axboe 写道:
>>> On 4/8/21 6:22 AM, Pavel Begunkov wrote:
>>>> On 08/04/2021 12:43, Hao Xu wrote:
>>>>> 在 2021/4/8 下午6:16, Hao Xu 写道:
>>>>>> 在 2021/4/7 下午11:49, Jens Axboe 写道:
>>>>>>> On 4/7/21 5:23 AM, Hao Xu wrote:
>>>>>>>> more tests comming, send this out first for comments.
>>>>>>>>
>>>>>>>> Hao Xu (3):
>>>>>>>>     io_uring: add IOSQE_MULTI_CQES/REQ_F_MULTI_CQES for multishot requests
>>>>>>>>     io_uring: maintain drain logic for multishot requests
>>>>>>>>     io_uring: use REQ_F_MULTI_CQES for multipoll IORING_OP_ADD
>>>>>>>>
>>>>>>>>    fs/io_uring.c                 | 34 +++++++++++++++++++++++++++++-----
>>>>>>>>    include/uapi/linux/io_uring.h |  8 +++-----
>>>>>>>>    2 files changed, 32 insertions(+), 10 deletions(-)
>>>>>>>
>>>>>>> Let's do the simple cq_extra first. I don't see a huge need to add an
>>>>>>> IOSQE flag for this, probably best to just keep this on a per opcode
>>>>>>> basis for now, which also then limits the code path to just touching
>>>>>>> poll for now, as nothing else supports multishot CQEs at this point.
>>>>>>>
>>>>>> gotcha.
>>>>>> a small issue here:
>>>>>>    sqe-->sqe(link)-->sqe(link)-->sqe(link, multishot)-->sqe(drain)
>>>>>>
>>>>>> in the above case, assume the first 3 single-shot reqs have completed.
>>>>>> then I think the drian request won't be issued now unless the multishot request in the linkchain has been issued. The trick is: a multishot req
>>>>>> in a linkchain consumes cached_sq_head when io_get_sqe(), which means it
>>>>>> is counted in seq, but we will deduct the sqe when it is issued if we
>>>>>> want to do the job per opcode not in the main code path.
>>>>>> before the multishot req issued:
>>>>>>        all_sqes(4) - multishot_sqes(0) == all_cqes(3) - multishot_cqes(0)
>>>>>> after the multishot req issued:
>>>>>>        all_sqes(4) - multishot_sqes(1) == all_cqes(3) - multishot_cqes(0)
>>>>>
>>>>> Sorry, my statement is wrong. It's not "won't be issued now unless the
>>>>> multishot request in the linkchain has been issued". Actually I now
>>>>> think the drain req won't be issued unless the multishot request in the
>>>>> linkchain has completed. Because we may first check req_need_defer()
>>>>> then issue(req->link), so:
>>>>>     sqe0-->sqe1(link)-->sqe2(link)-->sqe3(link, multishot)-->sqe4(drain)
>>>>>
>>>>>    sqe2 is completed:
>>>>>      call req_need_defer:
>>>>>      all_sqes(4) - multishot_sqes(0) == all_cqes(3) - multishot_cqes(0)
>>>>>    sqe3 is issued:
>>>>>      all_sqes(4) - multishot_sqes(1) == all_cqes(3) - multishot_cqes(0)
>>>>>    sqe3 is completed:
>>>>>      call req_need_defer:
>>>>>      all_sqes(4) - multishot_sqes(1) == all_cqes(3) - multishot_cqes(0)
>>>>>
>>>>> sqe4 shouldn't wait sqe3.
>>>>
>>>> Do you mean it wouldn't if the patch is applied? Because any drain
>>>> request must wait for all requests submitted before to complete. And
>>>> so before issuing sqe4 it must wait for sqe3 __request__ to die, and
>>>> so for all sqe3's CQEs.
>>>>
>>>> previously
>>>
>>> I think we need to agree on what multishot means for dependencies. Does
>>> it mean it just needs to trigger once? Or does it mean that it needs to
>>> be totally finished. The latter may obviously never happen, depending on
>>> the use case. Or it may be an expected condition because the caller will
>>> cancel it at some point.
>>>
>>> The most logical view imho is that multishot changes nothing wrt drain.
>>> If you ask for drain before something executes and you are using
>>> multishot, then you need to understand that the multishot request needs
>>> to fully complete before that condition is true and your dependency can
>>> execute.
>> This makes sense, and the implementation would be quite simpler. but we
>> really need to document it somewhere so that users easily get to know
>> that they cannot put a drain req after some multishot reqs if they don't
>> want it to wait for them. Otherwise I worry about wrong use of it since
>> the meaning of 'put a drain req after some multishot reqs' isn't so
>> obvious:
>>     - does it waits for those multishot reqs to complete once
>>     - or does it waits for those ones to fully complete
>>     - or does it ignore those ones at all
>>
> I realised that if a drain req has to wait for multishot reqs' fully
>  completion, then users have to explicitly cancel all the previous
> multishot reqs, otherwise it won't execute forever:
>     sqe0(multishot)-->sqe1(drain)-->sqe2(cancel multishot)    stuck

And it's not a new behaviour, e.g. read(pipe); drain(); where nobody
writes to the pipe will stuck as well.

I like that it currently provides a full barrier between requests, are
there other patterns used by someone?

-- 
Pavel Begunkov
