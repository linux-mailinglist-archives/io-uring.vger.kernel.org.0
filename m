Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C303B45DCFD
	for <lists+io-uring@lfdr.de>; Thu, 25 Nov 2021 16:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239065AbhKYPO7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Nov 2021 10:14:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349048AbhKYPM6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Nov 2021 10:12:58 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A336C061761
        for <io-uring@vger.kernel.org>; Thu, 25 Nov 2021 07:09:47 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id m25-20020a7bcb99000000b0033aa12cdd33so1106494wmi.1
        for <io-uring@vger.kernel.org>; Thu, 25 Nov 2021 07:09:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=RoRxDpjGNXLBXB6uq4lhdnX3xKOtcXEO9Z9sv3sol4Y=;
        b=EpXJ8imGcgMWbQ0SJRaMwvozJxm5BY0D0lBJPHzTl3G5Az7HXPXPlcWk4p8lWEqDRK
         7NFwhsztT2TBiioIgMIppXXdek/DcfUz219WQZT7YcC0yeG3qyqUc9a1Q8oIMoX3WKVL
         Za68plzmgQWeSTtC0Mddj9euAAe/DjhEcxlVoKeeUdN+8YBV/fhKmaHz6JUDrAfAzq8G
         hQEjcavacYegwVUEZTkfzR2Vj4oMsjESOLvdBzapttE4ZwF5tMv6RAr9/nGpsJRHaaKo
         8uNdTOG9tMkgsFbFga8s8YOgQ+n4wSRSYTD8h2IUlO2VHIAy5NjlWanuvHERm5H8mqBw
         l/EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RoRxDpjGNXLBXB6uq4lhdnX3xKOtcXEO9Z9sv3sol4Y=;
        b=JXW3dZrpsQ4t8nV54itQlyIuTkJizy9qfluMh2hXJufuYVSTnV4fcy3jKTK9m8J4tb
         iBzDlKlKJVyg+AYxjCR04E+bCAXGzvFigNzWRT5KkVBIJpWpdA5nxiKqwWYlPgS55OC2
         oovNO+F436+Dyf/esap15TYEGsjTpmDDoic4E/6HNViUoLDqGqA7VxVOHw6Fo+9Qwkl0
         OdV68UZ98l2lkcRzc2SVi75Vl0/zuDogiDDWpIXQcQy6RuzQO4I+tV2yA2K6EnxOdoy/
         kbXBsxUBUhOnocykzUNSfhYfuyc7DZq3bEQQk1yaL+yy8iyjk4kfaNqOCLiEcT1G0q1C
         St0w==
X-Gm-Message-State: AOAM5316NclPtCZ3ovGwr9a17kYzJDTc8eMDbhPxiGGU+ujujrzdclZM
        tDZsE5e4aYCbcuUXC729q3jq4jjDdo4=
X-Google-Smtp-Source: ABdhPJwWimbPwlpvFCUBQpTo4ROzEsMRJJbQ4/hIuWEJhWFYm4Bn99E2j4ycgt/LDOpJQKwNhDT0mA==
X-Received: by 2002:a7b:cd96:: with SMTP id y22mr7937447wmj.121.1637852985970;
        Thu, 25 Nov 2021 07:09:45 -0800 (PST)
Received: from [192.168.43.77] (82-132-229-54.dab.02.net. [82.132.229.54])
        by smtp.gmail.com with ESMTPSA id t189sm3154757wma.8.2021.11.25.07.09.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Nov 2021 07:09:45 -0800 (PST)
Message-ID: <a8bbe4e1-9017-76a4-eddb-d6a6676f7290@gmail.com>
Date:   Thu, 25 Nov 2021 15:09:28 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [RFC 0/9] fixed worker: a new way to handle io works
Content-Language: en-US
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211124044648.142416-1-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20211124044648.142416-1-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/24/21 04:46, Hao Xu wrote:
> There is big contension in current io-wq implementation. Introduce a new
> type io-worker called fixed-worker to solve this problem. it is also a
> new way to handle works. In this new system, works are dispatched to
> different private queues rather than a long shared queue.

It's really great to temper the contention here, even though it looks
we are stepping onto the path of reinventing all the optimisations
solved long ago in other thread pools. Work stealing is probably
the next, but guess it's inevitable :)

First four patchhes sound like a good idea, they will probably go
first. However, IIUC, the hashing is crucial and it's a must have.
Are you planning to add it? If not, is there an easy way to leave
hashing working even if hashed reqs not going through those new
per-worker queues? E.g. (if it's not already as this...)

if (hashed) {
	// fixed workers don't support hashing, so go through the
	// old path and place into the shared queue.
	enqueue_shared_queue();
} else
	enqueue_new_path();

And last note, just fyi, it's easier to sell patches if you put
numbers in the cover letter


> Hao Xu (9):
>    io-wq: decouple work_list protection from the big wqe->lock
>    io-wq: reduce acct->lock crossing functions lock/unlock
>    io-wq: update check condition for lock
>    io-wq: use IO_WQ_ACCT_NR rather than hardcoded number
>    io-wq: move hash wait entry to io_wqe_acct
>    io-wq: add infra data structure for fix workers
>    io-wq: implement fixed worker logic
>    io-wq: batch the handling of fixed worker private works
>    io-wq: small optimization for __io_worker_busy()
> 
>   fs/io-wq.c | 415 ++++++++++++++++++++++++++++++++++++++---------------
>   fs/io-wq.h |   5 +
>   2 files changed, 308 insertions(+), 112 deletions(-)
> 

-- 
Pavel Begunkov
