Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63BCE23B44C
	for <lists+io-uring@lfdr.de>; Tue,  4 Aug 2020 06:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729658AbgHDEu2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Aug 2020 00:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbgHDEu1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Aug 2020 00:50:27 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F48C06174A
        for <io-uring@vger.kernel.org>; Mon,  3 Aug 2020 21:50:27 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id kr4so1321919pjb.2
        for <io-uring@vger.kernel.org>; Mon, 03 Aug 2020 21:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9POfZDLIBxlIfDoC/ZJdltW/SoYvRzgXK4DdlL6UmqA=;
        b=q68isjQejFxbHApxmWYhYrgYq4Z+ah8Z9NHkqlNqSR3GX8IHKJwdXMxvfMN0ERddOP
         Zw6V1r0mCKZt2b9lvTi+9koKgAPe2mUgbZwpFkTyTA7YmQXDXT/Gff36uLnDgGLllQ2G
         Engwwbbjqsjmjr0xRmSJ05YGdy4sc0/9duxQprk3MYiwttY6WgC8Lh4hwdUZN1wzoxax
         F1/uwEv3mDbsvBrQKkTchr6HaVd8i6rMfFJy8ssWIw3oda1sj5Hjfc5Kya1gHA6szXl2
         IDyyKXM14oWmcaySD/twQudFAZU/g76KfyCei5Lf3o1wsTCuQ7iINsy/D0lzkOCEpTur
         4fBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9POfZDLIBxlIfDoC/ZJdltW/SoYvRzgXK4DdlL6UmqA=;
        b=EyO5tKWfUdtsnT2Rx3uHBavrIZpWt1Vm0mDqmO7JlVZrFz5ybrmNodT945UTtJETj5
         pcvlGDe+gWbFYUisVrongURcevPT+SCgr69icvCt7cXqKiEKBcfceHgwH3gIPi+QYUjJ
         k4sWP5DAjiVgQHdNnpqn0pEUAUOUQ6nDQx5hBuGJ3isz9wDyhIX+vhT7I8uV5w2enJvX
         yWAmuqAV8rCFhoKt5nj+CnhzJHRHRT8fkwV1rffnNa0LyjDcQ7otAxPGzJQ3ZNN3Wg9w
         Cl/94AcC7eICqbyjyJ9fpFdlS9ecXIuRZJ2j0VwKbUk49bFzEuoRe8wpQkUcQuHtKhuK
         VdeQ==
X-Gm-Message-State: AOAM531D6BeW7AR6/PNbjMbFlwzH8703pWduovnoY4kgtG88JovE9SKo
        6ZkDleNmmBYBBnEwfPWjiY/sSs8xa+g=
X-Google-Smtp-Source: ABdhPJy3Yy+TbiuFFnFY3UygnynZcNw7wS1miNNxegDRWM8XH8XiXLO6JAC/V2O1YitiGEtyYZSUWg==
X-Received: by 2002:a17:90a:14a5:: with SMTP id k34mr2701456pja.37.1596516626744;
        Mon, 03 Aug 2020 21:50:26 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 12sm20695376pfn.173.2020.08.03.21.50.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2020 21:50:25 -0700 (PDT)
Subject: Re: [PATCH liburing 1/2] io_uring_enter: add timeout support
To:     Jiufei Xue <jiufei.xue@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org
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
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <77f6f74d-fcf5-d669-52d8-5444929a980c@kernel.dk>
Date:   Mon, 3 Aug 2020 22:50:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <8be505f3-17fc-9a49-1e5e-286d61c435fa@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/3/20 7:29 PM, Jiufei Xue wrote:
> 
> Hi Jens,
> On 2020/8/4 上午12:41, Jens Axboe wrote:
>> On 8/2/20 9:16 PM, Jiufei Xue wrote:
>>> Hi Jens,
>>>
>>> On 2020/7/31 上午11:57, Jens Axboe wrote:
>>>> Then why not just make the sqe-less timeout path flush existing requests,
>>>> if it needs to? Seems a lot simpler than adding odd x2 variants, which
>>>> won't really be clear.
>>>>
>>> Flushing the requests will access and modify the head of submit queue, that
>>> may race with the submit thread. I think the reap thread should not touch
>>> the submit queue when IORING_FEAT_GETEVENTS_TIMEOUT is supported.
>>
>> Ahhh, that's the clue I was missing, yes that's a good point!
>>
>>>> Chances are, if it's called with sq entries pending, the caller likely
>>>> wants those submitted. Either the caller was aware and relying on that
>>>> behavior, or the caller is simply buggy and has a case where it doesn't
>>>> submit IO before waiting for completions.
>>>>
>>>
>>> That is not true when the SQ/CQ handling are split in two different threads.
>>> The reaping thread is not aware of the submit queue. It should only wait for
>>> completion of the requests, such as below:
>>>
>>> submitting_thread:                   reaping_thread:
>>>
>>> io_uring_get_sqe()
>>> io_uring_prep_nop()     
>>>                                  io_uring_wait_cqe_timeout2()
>>> io_uring_submit()
>>>                                  woken if requests are completed or timeout
>>>
>>>
>>> And if the SQ/CQ handling are in the same thread, applications should use the
>>> old API if they do not want to submit the request themselves.
>>>
>>> io_uring_get_sqe
>>> io_uring_prep_nop
>>> io_uring_wait_cqe_timeout
>>
>> Thanks, yes it's all clear to me now. I do wonder if we can't come up with
>> something better than postfixing the functions with a 2, that seems kind of
>> ugly and doesn't really convey to anyone what the difference is.
>>
>> Any suggestions for better naming?
>>
> how about io_uring_wait_cqe_timeout_nolock()? That means applications can use
> the new APIs without synchronization.

But even applications that don't share the ring across submit/complete
threads will want to use the new interface, if supported by the kernel.
Yes, if they share, they must use it - but even if they don't, it's
likely going to be a more logical interface for them.

So I don't think that _nolock() really conveys that very well, but at
the same time I don't have any great suggestions.

io_uring_wait_cqe_timeout_direct()? Or we could go simpler and just call
it io_uring_wait_cqe_timeout_r(), which is a familiar theme from libc
that is applied to thread safe implementations.

I'll ponder this a bit...

-- 
Jens Axboe

