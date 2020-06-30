Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7818120F86E
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2020 17:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389385AbgF3Pd2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Jun 2020 11:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389296AbgF3Pd2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Jun 2020 11:33:28 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1B80C061755
        for <io-uring@vger.kernel.org>; Tue, 30 Jun 2020 08:33:27 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id k5so54824pjg.3
        for <io-uring@vger.kernel.org>; Tue, 30 Jun 2020 08:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=tV90kEmS0zhwDrcxeH/v1cwVOiSoHoa2klebDw6RDkE=;
        b=kyznsznzF0sdayUbXim6KsEArryvFzCp4b7boJ6Y5jqrpH0Mj7i2n9vo4EN20n7vFO
         26B3XQ6PUsVcBK3iSfx+hKrJBwdVejSXEG8KuUH13Y8fnT0O3tF3EYTJu2xQ9QUEU5ne
         G1ZSlmh6QWWVKGah1PpxVVOPHayv4f6owRd36HUnR2LftKKVz1YQOY6iHJzkzHXfk1eV
         f6nT/wADe3ZMZhEmHxQH0wXffBHS5L1i3a7dl0vd8ge1GzLiBnIovqTtN7ZHe4/c8z5k
         2YJcGL2tfxmTk5+mpp0yv6n8cJagVBoXyhYrgysvKPFhABH9nZDKXR0B6ppZ6BLZu8HW
         S54w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tV90kEmS0zhwDrcxeH/v1cwVOiSoHoa2klebDw6RDkE=;
        b=XRHxDlUu55zDywHPW+hpzJNKIxoOZUnHm6PhJfX6GOufVZ/wrc/g0mxPHGO3URgvd2
         68a6S3tFGHXYSevynqHn6AI/T136JfpjxuYQAeufuxBDBJFlFCaASJxiUAKmUwoqnu4f
         S1/w2pXnp/MPgalmSt0hupGmX5HbneqJtJqvKlAbjq1Wena+ueX7skx0glHQGjPTUx51
         By7F0ZNj0PSJdSRr2tivKjnOAyx1r6U3UdYt125tjiP4eydiLbLjnoiklLORucmVRw3b
         58dAyi1WBpUlr6HJwXpbCGQn9BS4xv13QhLKUEhmZrgzXwMm4j1ZBGNiWId0HAALP9Cg
         6jDw==
X-Gm-Message-State: AOAM532gzWRtgj8CSiFwHlEUnwNqey1YA+2Mg7Prw7et9324dwwB6rYv
        xj8c/Efkylr1bGLQQB1POIaKr+hMtpquCw==
X-Google-Smtp-Source: ABdhPJwPvE4ag4hthSpT3Qp+xV2ZflkRoPBunEYBc/FBUwAO9bVUnm2PLKWAfK2gdNh3VUSXV1aDXA==
X-Received: by 2002:a17:90b:3809:: with SMTP id mq9mr22417240pjb.156.1593531207087;
        Tue, 30 Jun 2020 08:33:27 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:4113:50ea:3eb3:a39b? ([2605:e000:100e:8c61:4113:50ea:3eb3:a39b])
        by smtp.gmail.com with ESMTPSA id u20sm2945347pfm.152.2020.06.30.08.33.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2020 08:33:26 -0700 (PDT)
Subject: Re: [PATCH 2/8] io_uring: fix commit_cqring() locking in iopoll
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1593519186.git.asml.silence@gmail.com>
 <75e5bc4f60d751239afa5d7bf2ec9b49308651ac.1593519186.git.asml.silence@gmail.com>
 <65675178-365d-c859-426b-c0811a2647a3@kernel.dk>
 <6c499cf3-418d-2edf-d308-2bb5a8d1d007@gmail.com>
 <312bbba1-878c-5681-5e6c-b6de3f7feb55@kernel.dk>
 <63a8fab2-820f-d0c1-ad39-a3eb7af1d872@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c9843917-cfb7-328b-06f6-64893a7654ff@kernel.dk>
Date:   Tue, 30 Jun 2020 09:33:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <63a8fab2-820f-d0c1-ad39-a3eb7af1d872@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/30/20 9:00 AM, Pavel Begunkov wrote:
> On 30/06/2020 17:46, Jens Axboe wrote:
>> On 6/30/20 8:36 AM, Pavel Begunkov wrote:
>>> On 30/06/2020 17:04, Jens Axboe wrote:
>>>> On 6/30/20 6:20 AM, Pavel Begunkov wrote:
>>>>> Don't call io_commit_cqring() without holding the completion spinlock
>>>>> in io_iopoll_complete(), it can race, e.g. with async request failing.
>>>>
>>>> Can you be more specific?
>>>
>>> io_iopoll_complete()
>>> 	-> io_req_free_batch()
>>> 		-> io_queue_next()
>>> 			-> io_req_task_queue()
>>> 				-> task_work_add()
>>>
>>> if this task_work_add() fails, it will be redirected to io-wq manager task
>>> to do io_req_task_cancel() -> commit_cqring().
>>>
>>>
>>> And probably something similar will happen if a request currently in io-wq
>>> is retried with
>>> io_rw_should_retry() -> io_async_buf_func() -> task_work_add()
>>
>> For the IOPOLL setup, it should be protected by the ring mutex. Adding
>> the irq disable + lock for polling would be a nasty performance hit.
> 
> Ok. For what it worth, it would be easier to accidentally screw in the future.
> I'll try it out.
> 
> 
> BTW, if you're going to cherry-pick patches from this series, just push them
> into the branch. I'll check git.kernel.dk later and resend what's left.

Yep done, I'll push it out.

-- 
Jens Axboe

