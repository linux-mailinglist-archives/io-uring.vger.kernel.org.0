Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA10468159B
	for <lists+io-uring@lfdr.de>; Mon, 30 Jan 2023 16:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236700AbjA3PyE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 Jan 2023 10:54:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235825AbjA3PyC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 Jan 2023 10:54:02 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE9657681
        for <io-uring@vger.kernel.org>; Mon, 30 Jan 2023 07:54:00 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id j4so1675773iog.8
        for <io-uring@vger.kernel.org>; Mon, 30 Jan 2023 07:54:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UqqBgmL5UDK40GB4kRlt9YAfXxuhYzki0hGY6ZYQAoo=;
        b=Y+sh5+7tGYNEtQ3YStpX+dvzulyPX4Lhb48ZB8B+9QR9afy9Wfk3lD1tGEwt1Vw9wk
         pRdP3uTkWtfegGaoN1Z4tjHQUhVMC4a0+pC3pwWbhCTRYOb4oKwIIJ1PfMYYlhBU6wLr
         K/Uzt9qKAfKElipBegQCybtLk3i45LY/z7RKaFLdfUWnzpmQ2Hb0eUetA+Vb3OKjDIoj
         psSyDuxA8VLb+hceC3KCvNVCGWNxGWAYhw+7iGsuIyeqixgDYil0YHep1G1J7baTDnTK
         9/RU8OvSFW6jNBNMHhc+GSHkO0oI2xPhxEvg47kovrqWz34l4qmGdIKQXrtsrYUfXlba
         pWnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UqqBgmL5UDK40GB4kRlt9YAfXxuhYzki0hGY6ZYQAoo=;
        b=iOwpgSSGb2oMffp9yOxBglx+MiGEIBk4Y8bt0v7AJzw0GM21UmO46r9wMbw1v2A1F8
         iFuIaMkMLv06zrgidAX4cOyABNBzlB95BTNHsV52VuGq1fLSbA5GDCUSP8fFH480oKbD
         sFnBYGAg9qbYYPmFYezo5ESv7GzvHygEUX09tHh+UmLLJuIwt41KeGQ5xgJ0474vsuOd
         m7LRgHDqe3zcKerEFFQnS9iV4gwht0k6Lu640kp84Fdz5j1UOlSyJsHLTpxVT/DDW5tt
         p5r1ruGbeADrcN6UGIBS5nBbnhkdxx1kz6uNbOd0YT/DUg+VJKSN+Icc0BhEbqgiFRMd
         ms5Q==
X-Gm-Message-State: AO0yUKVYCgIHKUp0aLix7lvfFmdJenXkLiqRaBSpq8fhIaRnTM3AZTkh
        Q2XdXRhQzOv4xuturm7aI9RQeA==
X-Google-Smtp-Source: AK7set8j27LvXNprP1zIx7OdW87aRjj/fLJDrfDQzM3jGNtIIhm+hWWx5sosJRGCenPbG04zzOCfDg==
X-Received: by 2002:a6b:3f43:0:b0:720:6919:fee7 with SMTP id m64-20020a6b3f43000000b007206919fee7mr8254ioa.0.1675094040076;
        Mon, 30 Jan 2023 07:54:00 -0800 (PST)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id m12-20020a056638224c00b003748d3552e1sm3725538jas.154.2023.01.30.07.53.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jan 2023 07:53:59 -0800 (PST)
Message-ID: <6cff07bb-1a3f-873f-2873-7060b0907c1c@kernel.dk>
Date:   Mon, 30 Jan 2023 08:53:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH for-next 1/4] io_uring: if a linked request has
 REQ_F_FORCE_ASYNC then run it async
Content-Language: en-US
To:     Dylan Yudaken <dylany@meta.com>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>
Cc:     Kernel Team <kernel-team@meta.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <20230127135227.3646353-1-dylany@meta.com>
 <20230127135227.3646353-2-dylany@meta.com>
 <297ad988-9537-c953-d49a-8b891204b0f0@kernel.dk>
 <aa6c75e2-5c39-713a-e5c2-8a50a4687b11@kernel.dk>
 <e12d8f56e8ee14b70f6f5e7b1f08ce5baf06f8ec.camel@meta.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <e12d8f56e8ee14b70f6f5e7b1f08ce5baf06f8ec.camel@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/30/23 3:45 AM, Dylan Yudaken wrote:
> On Sun, 2023-01-29 at 16:17 -0700, Jens Axboe wrote:
>> On 1/29/23 3:57 PM, Jens Axboe wrote:
>>> On 1/27/23 6:52?AM, Dylan Yudaken wrote:
>>>> REQ_F_FORCE_ASYNC was being ignored for re-queueing linked
>>>> requests. Instead obey that flag.
>>>>
>>>> Signed-off-by: Dylan Yudaken <dylany@meta.com>
>>>> ---
>>>>  io_uring/io_uring.c | 8 +++++---
>>>>  1 file changed, 5 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>> index db623b3185c8..980ba4fda101 100644
>>>> --- a/io_uring/io_uring.c
>>>> +++ b/io_uring/io_uring.c
>>>> @@ -1365,10 +1365,12 @@ void io_req_task_submit(struct io_kiocb
>>>> *req, bool *locked)
>>>>  {
>>>>         io_tw_lock(req->ctx, locked);
>>>>         /* req->task == current here, checking PF_EXITING is safe
>>>> */
>>>> -       if (likely(!(req->task->flags & PF_EXITING)))
>>>> -               io_queue_sqe(req);
>>>> -       else
>>>> +       if (unlikely(req->task->flags & PF_EXITING))
>>>>                 io_req_defer_failed(req, -EFAULT);
>>>> +       else if (req->flags & REQ_F_FORCE_ASYNC)
>>>> +               io_queue_iowq(req, locked);
>>>> +       else
>>>> +               io_queue_sqe(req);
>>>>  }
>>>>  
>>>>  void io_req_task_queue_fail(struct io_kiocb *req, int ret)
>>>
>>> This one causes a failure for me with test/multicqes_drain.t, which
>>> doesn't quite make sense to me (just yet), but it is a reliable
>>> timeout.
>>
>> OK, quick look and I think this is a bad assumption in the test case.
>> It's assuming that a POLL_ADD already succeeded, and hence that a
>> subsequent POLL_REMOVE will succeed. But now it's getting ENOENT as
>> we can't find it just yet, which means the cancelation itself isn't
>> being done. So we just end up waiting for something that doesn't
>> happen.
>>
>> Or could be an internal race with lookup/issue. In any case, it's
>> definitely being exposed by this patch.
>>
> 
> That is a bit of an unpleasasnt test.
> Essentially it triggers a pipe, and reads from the pipe immediately
> after. The test expects to see a CQE for that trigger, however if
> anything ran asynchronously then there is a race between the read and
> the poll logic running.
> 
> The attached patch fixes the test, but the reason my patches trigger it
> is a bit weird.
> 
> This occurs on the second loop of the test, after the initial drain.
> Essentially ctx->drain_active is still true when the second set of
> polls are added, since drain_active is only cleared inside the next
> io_drain_req. So then the first poll will have REQ_F_FORCE_ASYNC set.
> 
> Previously those FORCE_ASYNC's were being ignored, but now with
> "io_uring: if a linked request has REQ_F_FORCE_ASYNC then run it async"
> they get sent to the work thread, which causes the race. 
> 
> I wonder if drain_active should actually be cleared earlier? perhaps
> before setting the REQ_F_FORCE_ASYNC flag?
> The drain logic is pretty complex though, so I am not terribly keen to
> start changing it if it's not generally useful.

Pavel, any input on the drain logic? I think you know that part the
best.

-- 
Jens Axboe


