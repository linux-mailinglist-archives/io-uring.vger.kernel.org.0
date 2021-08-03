Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB573DF47D
	for <lists+io-uring@lfdr.de>; Tue,  3 Aug 2021 20:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237779AbhHCSOw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Aug 2021 14:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237621AbhHCSOv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Aug 2021 14:14:51 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78ED3C061757
        for <io-uring@vger.kernel.org>; Tue,  3 Aug 2021 11:14:39 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id mz5-20020a17090b3785b0290176ecf64922so5048750pjb.3
        for <io-uring@vger.kernel.org>; Tue, 03 Aug 2021 11:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Vtdf6k+5wkiplKyD8p8I4Z7Z6Ja9eBh3YLP78UYkVMQ=;
        b=m6dKmiY7pqiEa41ZW0F+pC2lA1G2lLIQ9HdjLzHA4gQ1wtGW9sZbujvcCB3J20m4MM
         /mNVJ2TGREKXv/waXCqtpIGAbQRnAkxW6Gqij8tTuCt9yvMFhIYtN1j7coJDMMVj0kbw
         8DEXERHlTkE0yJxybJNYcbCOApejr2sjj10QYesOAd9cPz0VaGTQQhW7JQaUjRbmoTmI
         t+dJexqTJDKZLrmtM4Aliqh2OIOFZXTH0+1np+Y+9pMZdtUukSdV3QbuTy6v+kolV1fw
         FN3XkbVGeylilIO+jZ/4XyrBYeNCG5fmlklRPUUfKzzkEpHg3Xa0K9Vfdo5Iqohiv4yK
         CClQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Vtdf6k+5wkiplKyD8p8I4Z7Z6Ja9eBh3YLP78UYkVMQ=;
        b=DDHjAHquDOg8qGDXb6WyhEya/ZhyXQOgb9O2kk7wuczhNJ+gn0PVuiq+hUsO3DcxuL
         pAq6feTbN2Xd+rH6M3ox3YwvbAQUhDE85UtQzFn2Ng2/CTzL5dHUTX//ePn4q8xqQHht
         crzS9IU0ADTjvpqr+r2QGvKrHA+TsJtMEbXVagS/MGU7GJv+ByFCGnhodxbiROXgoTm1
         2oyNAbfnY2+3utEHufGBLpAJ2l3owW0aqcAY4xTAozhb6T7Tjp+T510/jJQrtKnfaHvo
         hyI0IQPdBb4KMaiFwsvU/y5dt70zd3bmeXQcxoegJA+0GIEGM5QGerJiF36nDNtjfXSS
         HDzw==
X-Gm-Message-State: AOAM533liq+pZGakqafO5gBKyEYiI8V+3kZWmKifEE0l3DGkhqrrU7iO
        Xu1cp+1dBM9+hPLvXiUUSUrEGg==
X-Google-Smtp-Source: ABdhPJy3X+8m0ubASlVKjZQ7jr5Xm/IcdgyR42MJ8L+8wt/ri6GfwJEFyO6QtDY5MTX6JC4bK3G/Yg==
X-Received: by 2002:a17:902:7144:b029:12b:24ce:a83c with SMTP id u4-20020a1709027144b029012b24cea83cmr19606567plm.54.1628014478975;
        Tue, 03 Aug 2021 11:14:38 -0700 (PDT)
Received: from [192.168.1.116] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id m1sm17166779pfc.36.2021.08.03.11.14.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 11:14:38 -0700 (PDT)
Subject: Re: Race between io_wqe_worker() and io_wqe_wake_worker()
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     io-uring@vger.kernel.org, Hao Xu <haoxu@linux.alibaba.com>
References: <BFF746C0-FEDE-4646-A253-3021C57C26C9@gmail.com>
 <5bc88410-6423-2554-340d-ef83f1ba9844@kernel.dk>
 <c6ef9d6c-3127-090f-88a2-a1ffd432bbef@kernel.dk>
 <3CEF2AD7-AD8B-478D-91ED-488E8441988F@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <612d19fd-a59d-e058-b0bd-1f693bbf647d@kernel.dk>
Date:   Tue, 3 Aug 2021 12:14:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <3CEF2AD7-AD8B-478D-91ED-488E8441988F@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/3/21 12:04 PM, Nadav Amit wrote:
> 
> 
>> On Aug 3, 2021, at 7:37 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 8/3/21 7:22 AM, Jens Axboe wrote:
>>> On 8/2/21 7:05 PM, Nadav Amit wrote:
>>>> Hello Jens,
>>>>
>>>> I encountered an issue, which appears to be a race between
>>>> io_wqe_worker() and io_wqe_wake_worker(). I am not sure how to address
>>>> this issue and whether I am missing something, since this seems to
>>>> occur in a common scenario. Your feedback (or fix ;-)) would be
>>>> appreciated.
>>>>
>>>> I run on 5.13 a workload that issues multiple async read operations
>>>> that should run concurrently. Some read operations can not complete
>>>> for unbounded time (e.g., read from a pipe that is never written to).
>>>> The problem is that occasionally another read operation that should
>>>> complete gets stuck. My understanding, based on debugging and the code
>>>> is that the following race (or similar) occurs:
>>>>
>>>>
>>>>  cpu0					cpu1
>>>>  ----					----
>>>> 					io_wqe_worker()
>>>> 					 schedule_timeout()
>>>> 					 // timed out
>>>>  io_wqe_enqueue()
>>>>   io_wqe_wake_worker()
>>>>    // work_flags & IO_WQ_WORK_CONCURRENT
>>>>    io_wqe_activate_free_worker()
>>>> 					 io_worker_exit()
>>>>
>>>>
>>>> Basically, io_wqe_wake_worker() can find a worker, but this worker is
>>>> about to exit and is not going to process further work. Once the
>>>> worker exits, the concurrency level decreases and async work might be
>>>> blocked by another work. I had a look at 5.14, but did not see
>>>> anything that might address this issue.
>>>>
>>>> Am I missing something?
>>>>
>>>> If not, all my ideas for a solution are either complicated (track
>>>> required concurrency-level) or relaxed (span another worker on
>>>> io_worker_exit if work_list of unbounded work is not empty).
>>>>
>>>> As said, feedback would be appreciated.
>>>
>>> You are right that there's definitely a race here between checking the
>>> freelist and finding a worker, but that worker is already exiting. Let
>>> me mull over this a bit, I'll post something for you to try later today.
>>
>> Can you try something like this? Just consider it a first tester, need
>> to spend a bit more time on it to ensure we fully close the gap.
> 
> Thanks for the quick response.
> 
> I tried you version. It works better, but my workload still gets stuck
> occasionally (less frequently though). It is pretty obvious that the
> version you sent still has a race, so I didn’t put the effort into
> debugging it.

All good, thanks for testing! Is it a test case you can share? Would
help with confidence in the final solution.

> I should note that I have an ugly hack that does make my test pass. I
> include it, although it is obviously not the right solution.

Thanks, I'll take a look.

-- 
Jens Axboe

