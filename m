Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B356623B45C
	for <lists+io-uring@lfdr.de>; Tue,  4 Aug 2020 07:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729178AbgHDFTH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Aug 2020 01:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbgHDFTG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Aug 2020 01:19:06 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A752FC06174A
        for <io-uring@vger.kernel.org>; Mon,  3 Aug 2020 22:19:06 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id q17so22192317pls.9
        for <io-uring@vger.kernel.org>; Mon, 03 Aug 2020 22:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=w34SB9i0ypxRHZk+SW7z8teWrdjDZ2ZtthoWiSnYAQQ=;
        b=0f4N1kjC5G5DNL8WoiVUZl3h6r4TGXLFw3xxsjwlOGXiLZ/+mANv92IfmKSRiJynpD
         Bnzy957vqktCBvPcqhoUhibSLzs6Q38g2efhr67H8P5q0yKo+pKn3lv+e6axYv5YjlH7
         d4Wejv31PgPayBwwTiiDXR+Z9ayVncRrEBgJO3LqWExiXFRW74oLD3zxFsD8hRbQoq2i
         /ahZzGZjjPNNa5kP8CfqaLCAszNnA+RoXRUCMcvG1aZj+xEcpF7qM4OctRvZprRY/Q/S
         rGIR22O3/6dEq76cFDQXgB1oeFXdrCxRljVkqmxY2BETOIUxu9MtOiF46oBnoh00Pkee
         PuCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w34SB9i0ypxRHZk+SW7z8teWrdjDZ2ZtthoWiSnYAQQ=;
        b=BnP9Vp5NsyApnj/PX/yolcPD/xB8MyBMurnS8VhuJ7woS5UgiXIiGj2fhASkhKcpbj
         OWPo0bFxjM+nX6wDT3FEIaNmLm/lSmRGL1xLxJ9AhGQyWPV3qwokxUG736CPDCLNyP/o
         HOwtCKlgs2e1+7RRH4tn+b/tCvAMLCenEiODeKOrf1R1Q/7C6cEawqhvzbmibJ3gQq8a
         fstL/FCqkowYh9r5Xsl+tEDVQ8DjxjDpPiPuFFGqphQwPg42yOkwX44JaIcDTA3Xofdi
         8xzrY2c8XaXr6YWyNz7bmVTwBzplRI1jTb481vKkA87wJqD/iGFS3U10C12BfFFecDi2
         IwvA==
X-Gm-Message-State: AOAM530sI32cNCszBH/rlPfbmWzl0Vlb0+tTpqVJc1gsnH4RmzijZ4BM
        xY4IbGDcsNuFx66l3JBJ5GtsDg==
X-Google-Smtp-Source: ABdhPJzyn78RQaB62rYdkEztvYl/uVnobXNBQtfa54LwJ6gNFI30WfcV7qc3yHGrIz54uFF1SMt6lA==
X-Received: by 2002:a17:90b:1a89:: with SMTP id ng9mr2643313pjb.202.1596518346094;
        Mon, 03 Aug 2020 22:19:06 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id d17sm1118163pjr.40.2020.08.03.22.19.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2020 22:19:05 -0700 (PDT)
Subject: Re: [PATCH liburing 1/2] io_uring_enter: add timeout support
To:     Jiufei Xue <jiufei.xue@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Stefan Metzmacher <metze@samba.org>
References: <1596017415-39101-1-git-send-email-jiufei.xue@linux.alibaba.com>
 <1596017415-39101-2-git-send-email-jiufei.xue@linux.alibaba.com>
 <0f6cdf31-fbec-d447-989d-969bb936838a@kernel.dk>
 <0002bd2c-1375-2b95-fe98-41ee0895141e@linux.alibaba.com>
 <252c29a9-9fb4-a61f-6899-129fd04db4a0@kernel.dk>
 <cc7dab04-9f19-5918-b1e6-e3d17bd0762f@linux.alibaba.com>
 <e542502e-7f8c-2dd2-053b-6e78d49b1f6a@kernel.dk>
 <ec69d835-ddca-88bc-a97e-8f0d4d621bda@linux.alibaba.com>
 <253b4df7-a35b-4d49-8cdc-c6fa24446bf9@kernel.dk>
 <fccac1a9-17b6-28ac-728d-3c6975111671@linux.alibaba.com>
 <6b635544-6cd0-742b-896f-2a6bf289189c@kernel.dk>
 <8be505f3-17fc-9a49-1e5e-286d61c435fa@linux.alibaba.com>
 <77f6f74d-fcf5-d669-52d8-5444929a980c@kernel.dk>
 <b5804943-103f-0dda-2bea-ac5d46ed4b56@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <472af206-299e-bde9-eb44-f9c956b18d9c@kernel.dk>
Date:   Mon, 3 Aug 2020 23:19:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <b5804943-103f-0dda-2bea-ac5d46ed4b56@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/3/20 11:04 PM, Jiufei Xue wrote:
> 
> 
> On 2020/8/4 下午12:50, Jens Axboe wrote:
>> On 8/3/20 7:29 PM, Jiufei Xue wrote:
>>>
>>> Hi Jens,
>>> On 2020/8/4 上午12:41, Jens Axboe wrote:
>>>> On 8/2/20 9:16 PM, Jiufei Xue wrote:
>>>>> Hi Jens,
>>>>>
>>>>> On 2020/7/31 上午11:57, Jens Axboe wrote:
>>>>>> Then why not just make the sqe-less timeout path flush existing requests,
>>>>>> if it needs to? Seems a lot simpler than adding odd x2 variants, which
>>>>>> won't really be clear.
>>>>>>
>>>>> Flushing the requests will access and modify the head of submit queue, that
>>>>> may race with the submit thread. I think the reap thread should not touch
>>>>> the submit queue when IORING_FEAT_GETEVENTS_TIMEOUT is supported.
>>>>
>>>> Ahhh, that's the clue I was missing, yes that's a good point!
>>>>
>>>>>> Chances are, if it's called with sq entries pending, the caller likely
>>>>>> wants those submitted. Either the caller was aware and relying on that
>>>>>> behavior, or the caller is simply buggy and has a case where it doesn't
>>>>>> submit IO before waiting for completions.
>>>>>>
>>>>>
>>>>> That is not true when the SQ/CQ handling are split in two different threads.
>>>>> The reaping thread is not aware of the submit queue. It should only wait for
>>>>> completion of the requests, such as below:
>>>>>
>>>>> submitting_thread:                   reaping_thread:
>>>>>
>>>>> io_uring_get_sqe()
>>>>> io_uring_prep_nop()     
>>>>>                                  io_uring_wait_cqe_timeout2()
>>>>> io_uring_submit()
>>>>>                                  woken if requests are completed or timeout
>>>>>
>>>>>
>>>>> And if the SQ/CQ handling are in the same thread, applications should use the
>>>>> old API if they do not want to submit the request themselves.
>>>>>
>>>>> io_uring_get_sqe
>>>>> io_uring_prep_nop
>>>>> io_uring_wait_cqe_timeout
>>>>
>>>> Thanks, yes it's all clear to me now. I do wonder if we can't come up with
>>>> something better than postfixing the functions with a 2, that seems kind of
>>>> ugly and doesn't really convey to anyone what the difference is.
>>>>
>>>> Any suggestions for better naming?
>>>>
>>> how about io_uring_wait_cqe_timeout_nolock()? That means applications can use
>>> the new APIs without synchronization.
>>
>> But even applications that don't share the ring across submit/complete
>> threads will want to use the new interface, if supported by the kernel.
>> Yes, if they share, they must use it - but even if they don't, it's
>> likely going to be a more logical interface for them.
>>
>> So I don't think that _nolock() really conveys that very well, but at
>> the same time I don't have any great suggestions.
>>
>> io_uring_wait_cqe_timeout_direct()? Or we could go simpler and just call
>> it io_uring_wait_cqe_timeout_r(), which is a familiar theme from libc
>> that is applied to thread safe implementations.
>>
>> I'll ponder this a bit...
>>
> 
> As suggested by Stefan, applications can pass a flag, say
> IORING_SETUP_GETEVENTS_TIMEOUT to initialize the ring to indicate they
> want to use the new feature. Function io_uring_wait_cqes() need to
> submit the timeout sqe neither the kernel is not supported nor
> applications do not want to use the new feature.

We should not add a private setup flag for this, as the kernel doesn't
really care, and hence the flag wouldn't even exist on the kernel side.
This is all liburing internals. We could have a function in liburing ala
io_uring_set_thread_shared() or something and mark it appropriately, and
then have the existing API do the right thing. We could even have it
return 0/-errno so that applications could handle the case where the
kernel doesn't support it. Should probably name it after what it is,
though, so io_uring_set_cqwait_timeout() or something like that.

We also need to consider what should happen if the app has asked for
this behavior, and wait_cqe() is called with pending submissions. Do we
return an error for this case, or just assume that's what the
applications wants? There's really two cases here:

1) liburing wants to use the newer timeout mechanism, but the
   application hasn't told us if it cares or not.

2) Application explicitly asked for the new behavior, as it relies on
   it. This is a trivial case, as we should not be looking at the SQ
   side at all for this one.

For #1, probably safest to just flush existing submissions and still use
the new API. If the app didn't ask for thread safe SQ/CQ, then it should
not care. And this is existing behavior, after all.

So maybe it'll work out OK. I guess the only remaining hurdle is the
change of struct io_uring, which we'll need to handle carefully.

-- 
Jens Axboe

