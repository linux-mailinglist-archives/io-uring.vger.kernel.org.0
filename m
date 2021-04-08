Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9BAE35833F
	for <lists+io-uring@lfdr.de>; Thu,  8 Apr 2021 14:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbhDHM1R (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Apr 2021 08:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbhDHM1Q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Apr 2021 08:27:16 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEADFC061760
        for <io-uring@vger.kernel.org>; Thu,  8 Apr 2021 05:27:03 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id w7-20020a1cdf070000b0290125f388fb34so336833wmg.0
        for <io-uring@vger.kernel.org>; Thu, 08 Apr 2021 05:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kSm+JyaY4d62aowT8XOE88nrxRH3nD+KF8uujA3R90E=;
        b=l+LkPmjnt3e6kaFshoKRvQiOXviWi4k2AIFZnY3IqL/8CeNHTlU+Ynj1BPY3PCOx2D
         oVRZVp8bBKx9kgohWGB8z11ND/1braQPJ+xZ5mG1ixpvqRLjIzdvshO7aJzolRnH0z3D
         5FmsogI6M55HAKi53hXYYYofud8NbZ143DErNViieWemTxCkK0P6KWFjy3Wf+qKhEwZt
         wZfWdirFetbfVHTA52sH+fpkRqAJoW3nJzJNP8bJ9FQaeIim4luePoBGkB+xkSgUFAS7
         trPdhO/F1KdtgQZAtHmkNidE82YeIFrCZ3tylA9atrnUb0JiD0xPR+rEXmDNfUK6Bnve
         E63g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=kSm+JyaY4d62aowT8XOE88nrxRH3nD+KF8uujA3R90E=;
        b=a7R9Jqj6TtUH/KljnyK32MG9akmVjPIGX0kV+BHH11kctPJhFJKPvxhhsL8/MlFy+n
         D2DAHO2O0xa02oxAx6LR15bYWCuH+eVUS/dyjdf6ppOZ9mQjjuc0941lLexdLCy6DNMR
         RhwAJ6Y3fX3HF4hL4aCANVk5vMezcmI60RsRCAk0X0OKcpQRe2rOmfxRLNJP5Fw9q8qE
         dkDBgfU/Mu2UhXURIKJC/F1ZzB0Y/eJJLjePbtqSDhEffrrM+4+J/wvhvjyhenzVwdmt
         LxYWsxjW0/V4+Re960Gnhz/IZkLjA2vzpbA6rf41pUZAGMeorB8Q9HzUDGLBIPA6xNlF
         Joug==
X-Gm-Message-State: AOAM531gg9tnxr8tuK6u2J8/d0a9dbBPlyDYhT9oJnpgwUab0OtC9+S5
        ZzYk07miu9A4Rs7zlEk9UuaLqf9IMy7++A==
X-Google-Smtp-Source: ABdhPJyAWZILEfUiBVgZzEx/AZdAhBblM23xtAR8C6DbK5eBopyWvxiF2Cay8WLYpyvZHnngci1gLQ==
X-Received: by 2002:a05:600c:2f9a:: with SMTP id t26mr7847940wmn.111.1617884822759;
        Thu, 08 Apr 2021 05:27:02 -0700 (PDT)
Received: from [192.168.8.156] ([148.252.128.224])
        by smtp.gmail.com with ESMTPSA id m5sm31058956wrx.83.2021.04.08.05.27.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Apr 2021 05:27:02 -0700 (PDT)
Subject: Re: [PATCH 5.13 v2] io_uring: maintain drain requests' logic
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1617794605-35748-1-git-send-email-haoxu@linux.alibaba.com>
 <00898a9b-d2f2-1108-b9d9-2d6acea6e713@kernel.dk>
 <32f812e1-c044-d4b3-d26f-3721e4611a1d@linux.alibaba.com>
 <119436dd-5e55-9812-472c-7a257bda12fb@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <826e199f-1cc0-f529-f200-5fa643a62bca@gmail.com>
Date:   Thu, 8 Apr 2021 13:22:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <119436dd-5e55-9812-472c-7a257bda12fb@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 08/04/2021 12:43, Hao Xu wrote:
> 在 2021/4/8 下午6:16, Hao Xu 写道:
>> 在 2021/4/7 下午11:49, Jens Axboe 写道:
>>> On 4/7/21 5:23 AM, Hao Xu wrote:
>>>> more tests comming, send this out first for comments.
>>>>
>>>> Hao Xu (3):
>>>>    io_uring: add IOSQE_MULTI_CQES/REQ_F_MULTI_CQES for multishot requests
>>>>    io_uring: maintain drain logic for multishot requests
>>>>    io_uring: use REQ_F_MULTI_CQES for multipoll IORING_OP_ADD
>>>>
>>>>   fs/io_uring.c                 | 34 +++++++++++++++++++++++++++++-----
>>>>   include/uapi/linux/io_uring.h |  8 +++-----
>>>>   2 files changed, 32 insertions(+), 10 deletions(-)
>>>
>>> Let's do the simple cq_extra first. I don't see a huge need to add an
>>> IOSQE flag for this, probably best to just keep this on a per opcode
>>> basis for now, which also then limits the code path to just touching
>>> poll for now, as nothing else supports multishot CQEs at this point.
>>>
>> gotcha.
>> a small issue here:
>>   sqe-->sqe(link)-->sqe(link)-->sqe(link, multishot)-->sqe(drain)
>>
>> in the above case, assume the first 3 single-shot reqs have completed.
>> then I think the drian request won't be issued now unless the multishot request in the linkchain has been issued. The trick is: a multishot req
>> in a linkchain consumes cached_sq_head when io_get_sqe(), which means it
>> is counted in seq, but we will deduct the sqe when it is issued if we
>> want to do the job per opcode not in the main code path.
>> before the multishot req issued:
>>       all_sqes(4) - multishot_sqes(0) == all_cqes(3) - multishot_cqes(0)
>> after the multishot req issued:
>>       all_sqes(4) - multishot_sqes(1) == all_cqes(3) - multishot_cqes(0)
> 
> Sorry, my statement is wrong. It's not "won't be issued now unless the
> multishot request in the linkchain has been issued". Actually I now
> think the drain req won't be issued unless the multishot request in the
> linkchain has completed. Because we may first check req_need_defer()
> then issue(req->link), so:
>    sqe0-->sqe1(link)-->sqe2(link)-->sqe3(link, multishot)-->sqe4(drain)
> 
>   sqe2 is completed:
>     call req_need_defer:
>     all_sqes(4) - multishot_sqes(0) == all_cqes(3) - multishot_cqes(0)
>   sqe3 is issued:
>     all_sqes(4) - multishot_sqes(1) == all_cqes(3) - multishot_cqes(0)
>   sqe3 is completed:
>     call req_need_defer:
>     all_sqes(4) - multishot_sqes(1) == all_cqes(3) - multishot_cqes(0)
> 
> sqe4 shouldn't wait sqe3.

Do you mean it wouldn't if the patch is applied? Because any drain
request must wait for all requests submitted before to complete. And
so before issuing sqe4 it must wait for sqe3 __request__ to die, and
so for all sqe3's CQEs.

previously 


-- 
Pavel Begunkov
