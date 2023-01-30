Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 213A6681638
	for <lists+io-uring@lfdr.de>; Mon, 30 Jan 2023 17:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbjA3QWV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 Jan 2023 11:22:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbjA3QWU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 Jan 2023 11:22:20 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13044A5FF
        for <io-uring@vger.kernel.org>; Mon, 30 Jan 2023 08:22:19 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id r2so11602379wrv.7
        for <io-uring@vger.kernel.org>; Mon, 30 Jan 2023 08:22:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=s0Y08EDicnqmMAmRyoSndpRwuih0ur6RJkd9mNNYWZY=;
        b=I8ChCik/HQzAelBsB/Ako8PY07Y3Szs3Fip+hDKdxq+RVDfqdU5Cg1fiBfv9BxxPzi
         tNSQe4aSqO7NOT6f37lAXrKb0u7WJ4IAG8ODuQDrSLn9y3MS4TFOSsEIA70YjmjMLSfp
         t4CFx/fn7IIyYQU2WFuaeac4OI5LQs6JQfq1YTIxqn+rNE6BIF/jk/nkKa6CQ/NQjtPf
         cdn6Chkb0Ws1WwSi25ZbLbGKhj7Bghlg4yLMeqtdGm4yECpJBRPkSLe/IHmDTeqvEKJl
         SFbG4waFhwDhwY/fwdFyRu/4wU6LRpb6RuIX+Pthx/U13hUiMlEgGnYJ5bmFMk8zm2te
         K8/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s0Y08EDicnqmMAmRyoSndpRwuih0ur6RJkd9mNNYWZY=;
        b=zOpFyUttqT4SANSRG9g44tzyxCjFTk6OUsSphndB6MB+fMscMSngHOO/7Cc4iNeLex
         ZcdvAxEl4cymuIlcHDb+OM0gHXImWRhiWYRsNnlr6RzNKxPF+zCtPMYpco10lB9euqth
         7D+3fKfoaQK3hf7HCOkG9z4ByzWOq26WUSdbd2OPxKtsr+Zi6V481lC//ChMEXiVZOVl
         itAckA5xd4+80HEEGaO5PZTecg+1ZRUzfM40DDbgAm2ycETGXc3ydHjfyc5HYRhg/ow0
         z02YcBSNapJMuI8b1fbwIVLxl8K5H8HIJLAVHicF+s1xOySDkLS38Vt+uMX5zJnhYZ1+
         UVmw==
X-Gm-Message-State: AO0yUKUQGsOxDOk73dt9lcgQEcxI0XlcFhiZeuXp8wJuBwApc0O/AHh+
        0iO7Mn3mlNGIU2yK8xeJrCxkHdRce/Y=
X-Google-Smtp-Source: AK7set+xN5x08m1J6OKvtAcpwTvkR5hrUOZmGlEfW3I16iBILcqgAi0adDJC341lxnPyUDwPC/O7JQ==
X-Received: by 2002:adf:f10a:0:b0:2bf:b503:4e5a with SMTP id r10-20020adff10a000000b002bfb5034e5amr19370648wro.49.1675095737507;
        Mon, 30 Jan 2023 08:22:17 -0800 (PST)
Received: from [192.168.8.100] (94.196.83.65.threembb.co.uk. [94.196.83.65])
        by smtp.gmail.com with ESMTPSA id v11-20020adff68b000000b002bfb8f829eesm12080020wrp.71.2023.01.30.08.22.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jan 2023 08:22:17 -0800 (PST)
Message-ID: <f97a8aba-cf73-a8b5-faac-d704f5084290@gmail.com>
Date:   Mon, 30 Jan 2023 16:21:21 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATCH for-next 1/4] io_uring: if a linked request has
 REQ_F_FORCE_ASYNC then run it async
To:     Jens Axboe <axboe@kernel.dk>, Dylan Yudaken <dylany@meta.com>
Cc:     Kernel Team <kernel-team@meta.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <20230127135227.3646353-1-dylany@meta.com>
 <20230127135227.3646353-2-dylany@meta.com>
 <297ad988-9537-c953-d49a-8b891204b0f0@kernel.dk>
 <aa6c75e2-5c39-713a-e5c2-8a50a4687b11@kernel.dk>
 <e12d8f56e8ee14b70f6f5e7b1f08ce5baf06f8ec.camel@meta.com>
 <6cff07bb-1a3f-873f-2873-7060b0907c1c@kernel.dk>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <6cff07bb-1a3f-873f-2873-7060b0907c1c@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/30/23 15:53, Jens Axboe wrote:
> On 1/30/23 3:45 AM, Dylan Yudaken wrote:
>> On Sun, 2023-01-29 at 16:17 -0700, Jens Axboe wrote:
>>> On 1/29/23 3:57 PM, Jens Axboe wrote:
>>>> On 1/27/23 6:52?AM, Dylan Yudaken wrote:
>>>>> REQ_F_FORCE_ASYNC was being ignored for re-queueing linked
>>>>> requests. Instead obey that flag.
>>>>>
>>>>> Signed-off-by: Dylan Yudaken <dylany@meta.com>
>>>>> ---
>>>>>   io_uring/io_uring.c | 8 +++++---
>>>>>   1 file changed, 5 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>>> index db623b3185c8..980ba4fda101 100644
>>>>> --- a/io_uring/io_uring.c
>>>>> +++ b/io_uring/io_uring.c
>>>>> @@ -1365,10 +1365,12 @@ void io_req_task_submit(struct io_kiocb
>>>>> *req, bool *locked)
>>>>>   {
>>>>>          io_tw_lock(req->ctx, locked);
>>>>>          /* req->task == current here, checking PF_EXITING is safe
>>>>> */
>>>>> -       if (likely(!(req->task->flags & PF_EXITING)))
>>>>> -               io_queue_sqe(req);
>>>>> -       else
>>>>> +       if (unlikely(req->task->flags & PF_EXITING))
>>>>>                  io_req_defer_failed(req, -EFAULT);
>>>>> +       else if (req->flags & REQ_F_FORCE_ASYNC)
>>>>> +               io_queue_iowq(req, locked);
>>>>> +       else
>>>>> +               io_queue_sqe(req);
>>>>>   }
>>>>>   
>>>>>   void io_req_task_queue_fail(struct io_kiocb *req, int ret)
>>>>
>>>> This one causes a failure for me with test/multicqes_drain.t, which
>>>> doesn't quite make sense to me (just yet), but it is a reliable
>>>> timeout.
>>>
>>> OK, quick look and I think this is a bad assumption in the test case.
>>> It's assuming that a POLL_ADD already succeeded, and hence that a
>>> subsequent POLL_REMOVE will succeed. But now it's getting ENOENT as
>>> we can't find it just yet, which means the cancelation itself isn't
>>> being done. So we just end up waiting for something that doesn't
>>> happen.
>>>
>>> Or could be an internal race with lookup/issue. In any case, it's
>>> definitely being exposed by this patch.
>>>
>>
>> That is a bit of an unpleasasnt test.
>> Essentially it triggers a pipe, and reads from the pipe immediately
>> after. The test expects to see a CQE for that trigger, however if
>> anything ran asynchronously then there is a race between the read and
>> the poll logic running.
>>
>> The attached patch fixes the test, but the reason my patches trigger it
>> is a bit weird.
>>
>> This occurs on the second loop of the test, after the initial drain.
>> Essentially ctx->drain_active is still true when the second set of
>> polls are added, since drain_active is only cleared inside the next
>> io_drain_req. So then the first poll will have REQ_F_FORCE_ASYNC set.
>>
>> Previously those FORCE_ASYNC's were being ignored, but now with
>> "io_uring: if a linked request has REQ_F_FORCE_ASYNC then run it async"
>> they get sent to the work thread, which causes the race.

And that sounds like a userspace problem, any request might be executed
async on an io_uring whim.

>> I wonder if drain_active should actually be cleared earlier? perhaps
>> before setting the REQ_F_FORCE_ASYNC flag?
>> The drain logic is pretty complex though, so I am not terribly keen to
>> start changing it if it's not generally useful.

No, that won't work. As a drain request forces the ring to delay all
future requests until all previous requests are completed we can't
skip draining checks based on state of currently prepared request.

Draining is currently out of hot paths, and I'm happy about it. There
might be some ways, we can use a new flag instead of REQ_F_FORCE_ASYNC
to force it into the slow path and return the request back to the normal
path if the draining is not needed, but we don't care and really should
not care. I'd argue even further, it's time to mark DRAIN deprecated,
it's too slow, doesn't fit io_uring model well and has edge case
behaviour problems.

> Pavel, any input on the drain logic? I think you know that part the
> best.

-- 
Pavel Begunkov
