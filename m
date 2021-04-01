Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 370663522CB
	for <lists+io-uring@lfdr.de>; Fri,  2 Apr 2021 00:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234287AbhDAWdz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 18:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233789AbhDAWdz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Apr 2021 18:33:55 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80924C0613E6
        for <io-uring@vger.kernel.org>; Thu,  1 Apr 2021 15:33:53 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id u5-20020a7bcb050000b029010e9316b9d5so1594086wmj.2
        for <io-uring@vger.kernel.org>; Thu, 01 Apr 2021 15:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0lRHXlbmvY9u4UItc7vjOJQez3+GGyDs33ZZLuGKsKQ=;
        b=ZzyFJXM/B/uEvv7WeZ0uKGv9WtRHdr9gJsrT5m7QGP29jhOksev64D0HM88/GHN1sw
         1S9TIW4LvJacRlVW3354ahO3T2wsvLTFxDdTrNLvv/yaC5R5alQMI4HmBjo/GNBzrFVf
         rJgkQlI09RtIBmxzZxHiz6B7ZGNJSD2Vt1h2UM4lP3m6CSzu5Lm9+NC1lwmmRXf0/1AQ
         AYgN0ol+MAovGVvI3y13uWOhzrlQZUo7EnGycbHC7MUZ1+4WTFcGskHX/ZtZkUdmyMpW
         PUodAy8pwxi8mdHFMQnhWwkVtTk1+Q+XsjF+1a5y3XbmEZCDIeZFnIHem775wO6E35Rj
         40fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=0lRHXlbmvY9u4UItc7vjOJQez3+GGyDs33ZZLuGKsKQ=;
        b=jd4YV9kH1wOUD9ApCGb5CHPbGCpatdWcBG/HzJsHoN0RnzvHbpJlZI7x5L1Qyu/Fbb
         1mUHR8Usw2kl341ZhvWuLVEP+HSTHA0d6D3D4OeOS830t10QM3q8Ya3EupDILXFen5rC
         Xk+2bwmO+WGf63XXg2zd8HCYEyw+7aoSkmHpFWH0WwlK6vtKLP5v+YBPj56jfMLOWPha
         2GUG88oJXS7wXWAGtk/DJUdvHEprQQthaaVZI9kWDea7RXkxe08VHVvOkBGXof+E45jD
         +gMiJ+LvLGh42UB7XmqXgU3HcvQrEj1TSfodHXBHPlHSBSwuW6v5SOcHgOtJjG/z8YfY
         CALw==
X-Gm-Message-State: AOAM532Qg0MzuXAbswPJ5jumYetFFEM7A7pbalWiLUx2bg+IK9EsFdpp
        j37Oy3yGfagYJIRmyJ6KD47EnKTgLzdaqA==
X-Google-Smtp-Source: ABdhPJxCzXtpdQUDlvv7ET6gKHpL5QYd20KyvtAHp3C3dV+L6WgXI2G14XMWUcDjsi6NC2gxME0cNw==
X-Received: by 2002:a7b:cd15:: with SMTP id f21mr9822544wmj.43.1617316432135;
        Thu, 01 Apr 2021 15:33:52 -0700 (PDT)
Received: from [192.168.8.131] ([148.252.132.152])
        by smtp.gmail.com with ESMTPSA id g5sm11848021wrq.30.2021.04.01.15.33.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Apr 2021 15:33:51 -0700 (PDT)
Subject: Re: [PATCH for-5.13] io_uring: maintain drain requests' logic
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1617181262-66724-1-git-send-email-haoxu@linux.alibaba.com>
 <55b29f0f-967d-fc91-a959-60e01acc55a3@gmail.com>
 <652e4b3b-4b98-54db-a86c-31478ca33355@linux.alibaba.com>
 <b3db5da8-1bce-530b-5542-c6f9b589a191@gmail.com>
 <49152a6e-6d8a-21f1-fd9c-8b764c21b2d3@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <59d15355-4317-99af-c7c4-364d0e7c1682@gmail.com>
Date:   Thu, 1 Apr 2021 23:29:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <49152a6e-6d8a-21f1-fd9c-8b764c21b2d3@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 01/04/2021 15:55, Hao Xu wrote:
> 在 2021/4/1 下午6:25, Pavel Begunkov 写道:
>> On 01/04/2021 07:53, Hao Xu wrote:
>>> 在 2021/4/1 上午6:06, Pavel Begunkov 写道:
>>>>
>>>>
>>>> On 31/03/2021 10:01, Hao Xu wrote:
>>>>> Now that we have multishot poll requests, one sqe can emit multiple
>>>>> cqes. given below example:
>>>>>       sqe0(multishot poll)-->sqe1-->sqe2(drain req)
>>>>> sqe2 is designed to issue after sqe0 and sqe1 completed, but since sqe0
>>>>> is a multishot poll request, sqe2 may be issued after sqe0's event
>>>>> triggered twice before sqe1 completed. This isn't what users leverage
>>>>> drain requests for.
>>>>> Here a simple solution is to ignore all multishot poll cqes, which means
>>>>> drain requests  won't wait those request to be done.
>>>>>
>>>>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>>>>> ---
>>>>>    fs/io_uring.c | 9 +++++++--
>>>>>    1 file changed, 7 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>>> index 513096759445..cd6d44cf5940 100644
>>>>> --- a/fs/io_uring.c
>>>>> +++ b/fs/io_uring.c
>>>>> @@ -455,6 +455,7 @@ struct io_ring_ctx {
>>>>>        struct callback_head        *exit_task_work;
>>>>>          struct wait_queue_head        hash_wait;
>>>>> +    unsigned                        multishot_cqes;
>>>>>          /* Keep this last, we don't need it for the fast path */
>>>>>        struct work_struct        exit_work;
>>>>> @@ -1181,8 +1182,8 @@ static bool req_need_defer(struct io_kiocb *req, u32 seq)
>>>>>        if (unlikely(req->flags & REQ_F_IO_DRAIN)) {
>>>>>            struct io_ring_ctx *ctx = req->ctx;
>>>>>    -        return seq != ctx->cached_cq_tail
>>>>> -                + READ_ONCE(ctx->cached_cq_overflow);
>>>>> +        return seq + ctx->multishot_cqes != ctx->cached_cq_tail
>>>>> +            + READ_ONCE(ctx->cached_cq_overflow);
>>>>>        }
>>>>>          return false;
>>>>> @@ -4897,6 +4898,7 @@ static bool io_poll_complete(struct io_kiocb *req, __poll_t mask, int error)
>>>>>    {
>>>>>        struct io_ring_ctx *ctx = req->ctx;
>>>>>        unsigned flags = IORING_CQE_F_MORE;
>>>>> +    bool multishot_poll = !(req->poll.events & EPOLLONESHOT);
>>>>>          if (!error && req->poll.canceled) {
>>>>>            error = -ECANCELED;
>>>>> @@ -4911,6 +4913,9 @@ static bool io_poll_complete(struct io_kiocb *req, __poll_t mask, int error)
>>>>>            req->poll.done = true;
>>>>>            flags = 0;
>>>>>        }
>>>>> +    if (multishot_poll)
>>>>> +        ctx->multishot_cqes++;
>>>>> +
>>>>
>>>> We need to make sure we do that only for a non-final complete, i.e.
>>>> not killing request, otherwise it'll double account the last one.
>>> Hi Pavel, I saw a killing request like iopoll_remove or async_cancel call io_cqring_fill_event() to create an ECANCELED cqe for the original poll request. So there could be cases like(even for single poll request):
>>>    (1). add poll --> cancel poll, an ECANCELED cqe.
>>>                                                    1sqe:1cqe   all good
>>>    (2). add poll --> trigger event(queued to task_work) --> cancel poll,            an ECANCELED cqe --> task_work runs, another ECANCELED cqe.
>>>                                                    1sqe:2cqes
>>
>> Those should emit a CQE on behalf of the request they're cancelling
>> only when it's definitely cancelled and not going to fill it
>> itself. E.g. if io_poll_cancel() found it and removed from
>> all the list and core's poll infra.
>>
>> At least before multi-cqe it should have been working fine.
>>
> I haven't done a test for this, but from the code logic, there could be
> case below:
> 
> io_poll_add()                         | io_poll_remove
> (event happen)io_poll_wake()          | io_poll_remove_one
>                                       | io_poll_remove_waitqs
>                                       | io_cqring_fill_event(-ECANCELED)
>                                       |
> task_work run(io_poll_task_func)      |
> io_poll_complete()                    |
> req->poll.canceled is true, \         |
> __io_cqring_fill_event(-ECANCELED)    |
> 
> two ECANCELED cqes, is there anything I missed?

Definitely may be be, but need to take a closer look


>>> I suggest we shall only emit one ECANCELED cqe.
>>> Currently I only account cqe through io_poll_complete(), so ECANCELED cqe from io_poll_remove or async_cancel etc are not counted in.
>>>> E.g. is failed __io_cqring_fill_event() in io_poll_complete() fine?
>>>> Other places?
>>> a failed __io_cqring_fill_event() doesn't produce a cqe but increment ctx->cached_cq_overflow, as long as a cqe is produced or cached_cq_overflow is +=1, it is ok.
>>
>> Not claiming that the case is broken, but cached_cq_overflow is
>> considered in req_need_defer() as well, so from its perspective there
>> is no much difference between succeed fill_event() or not.
>>
>>>>
>>>> Btw, we can use some tests :)
>>> I'll do more tests.
>>
>> Perfect!
>>
>>>>
>>>>
>>>>>        io_commit_cqring(ctx);
>>>>>        return !(flags & IORING_CQE_F_MORE);
>>>>>    }

-- 
Pavel Begunkov
