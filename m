Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 672163767DA
	for <lists+io-uring@lfdr.de>; Fri,  7 May 2021 17:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233366AbhEGPY2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 May 2021 11:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231540AbhEGPY2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 May 2021 11:24:28 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F8BDC061574
        for <io-uring@vger.kernel.org>; Fri,  7 May 2021 08:23:28 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id l19so7945483ilk.13
        for <io-uring@vger.kernel.org>; Fri, 07 May 2021 08:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nYmZijPTuHcWe90T+xLl7uj5gatpTl7obY/jBP1kijI=;
        b=QwYr6pTdhNLunbThrkfi89NRfFyc4jErTWijQZFoUOpFzzDyf70OvWwvjQ6J3Q2GFb
         xYEw3mwqBR7X4FQLJPmgF9sMZ/FRVeXkcUlhGnUL4Q+i8MArG49W1QaWwpZvcevejpqH
         C6UNcXQU9NgPdmNBbEmkhqRcj17FBatB5QD1PtkPqI5YAoGrmI8N80icJwwLn3WFftW2
         WTOTlh0zQpXl54efM6llOy6AR1srXjm61HiNGdX4eyRu9Gyi1TPnIKSrniGKOt4tLHw3
         4LLBOzoYZw/LTSrtxN7ZyLVz8AUTiTjACY1kNnypzwB47z11ihtrBMNWdk9X2NWHxDbk
         u90g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nYmZijPTuHcWe90T+xLl7uj5gatpTl7obY/jBP1kijI=;
        b=sqlC1Wcn4r0wGj6RJH3dfdtvJoT/QtUnh8YuZoZJ5xY8kvkixTsMkA4G+G2sA+Z8t3
         pvwgg9UNPCHc02c/+SAql/Qmeou+BHPJfMVkXfNHUqVfkKtXafvMfhs9BQUhQhkG5R1p
         ytV8T3WMNoq+OcIxGy6/vjgZso7dpL4Y5oRGamraQpw2XDrLUL2pcMFNHvjLK3Mhqz8+
         8X8WwvX0FXMRPNoA3Eq85pQYgmvhagdl9wUB0urSpck7NPBruU+y4Z4KZX6g4SEldxK9
         Iotmpb+4jOoAxA+9CYUSy+D8ob4v6AoeI6R5Kvsp4LRSySdbpTQn3K654xfn68Tlbuu8
         Matw==
X-Gm-Message-State: AOAM533A9YsxewptbCh0GTVQgrLEuwKAdIJFLre17uVo4JqBksDzorv4
        reGu2TkHfjmkk/VrqWGLMR89fF7jcHp/Vg==
X-Google-Smtp-Source: ABdhPJxINlGgaVUuf1QfVunLQHpzDyCJSNzAuO53KMLomDfLGDmowR537UJ6F70Axlt5z3hiEBUo1Q==
X-Received: by 2002:a92:d3c4:: with SMTP id c4mr9141878ilh.50.1620401007852;
        Fri, 07 May 2021 08:23:27 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id j2sm2934608ila.2.2021.05.07.08.23.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 May 2021 08:23:27 -0700 (PDT)
Subject: Re: [PATCH RFC 5.13] io_uring: add IORING_REGISTER_PRIORITY
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1620311593-46083-1-git-send-email-haoxu@linux.alibaba.com>
 <38e587bb-a484-24dc-1ea9-cc252b1639ba@kernel.dk>
 <92da0bd6-3de9-eedd-fca7-87d8ad99ba70@linux.alibaba.com>
 <31f6454f-7de8-97b4-4042-b9e7a3e121da@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <db68521b-7a69-682d-80eb-60fb379afaa5@kernel.dk>
Date:   Fri, 7 May 2021 09:23:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <31f6454f-7de8-97b4-4042-b9e7a3e121da@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/7/21 9:19 AM, Pavel Begunkov wrote:
> On 5/6/21 8:20 PM, Hao Xu wrote:
>> 在 2021/5/7 上午1:10, Jens Axboe 写道:
>>> On 5/6/21 8:33 AM, Hao Xu wrote:
>>>> Users may want a higher priority for sq_thread or io-worker. Provide a
>>>> way to change the nice value(for SCHED_NORMAL) or scheduling policy.
>>>
>>> Silly question - why is this needed for sqpoll? With the threads now
>>> being essentially user threads, why can't we just modify nice and
>>> scheduler class from userspace instead? That should work now. I think
>>> this is especially true for sqpoll where it's persistent, and argument
>>> could be made for the io-wq worker threads that we'd need io_uring
>>> support for that, as they come and go and there's no reliable way to
>>> find and tweak the thread scheduler settings for that particular use
>>> case.
>>>
>>> It may be more convenient to support this through io_uring, and that is
>>> a valid argument. I do think that the better way would then be to simply
>>> pass back the sqpoll pid after ring setup, because then it'd almost be
>>> as simple to do it from the app itself using the regular system call
>>> interfaces for that.
>>>> It's my bad. I didn't realize this until I almost completed the patch,
>> then I looked into io_uring_param, found just __u32 resv[3] can be
>> leveraged. Not sure if it's neccessary to occupy one to do this, so I
>> still sent this patch for comments.
> 
> io_uring_param is not a problem, can be extended.
> 
>>> In summary, I do think this _may_ make sense for the worker threads,
>>> being able to pass in this information and have io-wq worker thread
>>> setup perform the necessary tweaks when a thread is created, but it does
>> I'm working on this(for the io-wq worker), have done part of it.
> 
> I'm not sure the io-wq part makes much sense,
> 
> 1) they are per thread, so an instance not related to some particular
> ring, and so should not be controlled by it. E.g. what if a ring
> has two different rings and sets different schedulers?
> 
> 2) io-wq is slow path in any case, don't think it's worth trinking
> with it.

Right, it's normally slow path, so perhaps you'd want to nice it down
or use a different scheduler class for it. I'm not personally seeing
a strong need, but willing to entertain use cases if valid.

>>> seem a bit silly to add this for sqpoll where it could just as easily be
>>> achieved from the application itself without needing to add this
>> It's beyond my knowledge, correct me if I'm wrong: if we do
>> it from application, we have to search the pid of sq_thread by it's name
>> which is iou-sqp-`sqd->task_pid`, and may be cut off because of
>> TASK_COMM_LEN(would this macro value be possibly changed in the
>> future?). And set_task_comm() is called when sq_thread runs, so there is
>> very small chance(but there is) that set_task_comm() hasn't been called
>> when application try to get the command name of sq_thread. Based on this
>> (if it is not wrong...) I think return pid of sq_thread in io_uring
>> level may be a better choice.
> 
> Right, we may return some id of sqpoll task back in io_uring_param,
> though we need to be careful with namespaces.

Yep

-- 
Jens Axboe

