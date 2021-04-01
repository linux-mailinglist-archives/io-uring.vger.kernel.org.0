Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2FA3513A1
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 12:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbhDAKaM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 06:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233780AbhDAK3y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Apr 2021 06:29:54 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D60EC061788
        for <io-uring@vger.kernel.org>; Thu,  1 Apr 2021 03:29:53 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id z2so1290421wrl.5
        for <io-uring@vger.kernel.org>; Thu, 01 Apr 2021 03:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qd9VxSBmc0bvQwYLibQ6aAsJWDwqaI6Jz5d6zOv0/t8=;
        b=tCByimWgkaBFsuHskRf6J2Js+ZVLicb250poZULo5CLqjqyiQyHEOfjmn2+5Rm7cD0
         CNwRBk7eV83VrmRvFcKKnlwxdlzTH+C/Nnnf00T7gn6E7Zy+8Q2+ElgGDc/4py4z/EZ/
         8GZBh3crTjDSfUjlHxra69OZ3B5nf6Q3UTiXFjIQaa8wY9ReU4DXrAN7gpBPJJS9/5AL
         xNgZkO+PzsDoCjKq8wV5g1l6oFJivyXoZbI5qW3SySrdPHzjM+GE7L905+xDVFOCTbWS
         rAchP614j1bmAMpZk0az4VSSDSAI7BnQKY1ejv4YZVAlm7TNr5BVOTvxpvEuJ5SBd/a0
         Ug7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=qd9VxSBmc0bvQwYLibQ6aAsJWDwqaI6Jz5d6zOv0/t8=;
        b=tLaJzCLlwT7qcAuqa5e3F9kd1p8mhofzjzClf9SKzl4Wto5baFLwYD4piU8VQ2vlkJ
         /I/sKzgyvJ82dkjtUoXeCaNM5cIuiAtWYo9Wx0C/E/IVvBc60uJIbh1Kx77kJ2FFzpx+
         CsPnZpUApdJUahRIPhFiAij9BhV78dgjF/YXPyHrqYNFNBjiyU6Ei5GnhAa7HjbtRa6t
         h8YH8q6QPHaEkTGOA9NCeXVncOPLIdKt7Ai679CwnOppWfZ6cMzFMjrvaWHJroxthEfb
         XmvBgZ1oULm5v+3l8coX5KWttwwtmPN9wjatdb6jOdoGDGdU53wEIl59U+vef1xqi4y2
         6D5w==
X-Gm-Message-State: AOAM5302pSBVc7lczQidI+kJmGIUOoKNzZNVUHgl7lmAXX+U6U0/uH4b
        wOvbDj6MHpgTRZZPQFjeAWQ=
X-Google-Smtp-Source: ABdhPJw5fH42TxrsZzLSG+lOEizJjkzfYSc2/iY22cLkUpFjSP3ZhRtNAZnThpnrR413+WYkImyfgA==
X-Received: by 2002:adf:e108:: with SMTP id t8mr8649062wrz.371.1617272992378;
        Thu, 01 Apr 2021 03:29:52 -0700 (PDT)
Received: from [192.168.8.122] ([148.252.132.152])
        by smtp.gmail.com with ESMTPSA id j6sm7278335wmq.16.2021.04.01.03.29.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Apr 2021 03:29:51 -0700 (PDT)
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1617181262-66724-1-git-send-email-haoxu@linux.alibaba.com>
 <55b29f0f-967d-fc91-a959-60e01acc55a3@gmail.com>
 <652e4b3b-4b98-54db-a86c-31478ca33355@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH for-5.13] io_uring: maintain drain requests' logic
Message-ID: <b3db5da8-1bce-530b-5542-c6f9b589a191@gmail.com>
Date:   Thu, 1 Apr 2021 11:25:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <652e4b3b-4b98-54db-a86c-31478ca33355@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 01/04/2021 07:53, Hao Xu wrote:
> 在 2021/4/1 上午6:06, Pavel Begunkov 写道:
>>
>>
>> On 31/03/2021 10:01, Hao Xu wrote:
>>> Now that we have multishot poll requests, one sqe can emit multiple
>>> cqes. given below example:
>>>      sqe0(multishot poll)-->sqe1-->sqe2(drain req)
>>> sqe2 is designed to issue after sqe0 and sqe1 completed, but since sqe0
>>> is a multishot poll request, sqe2 may be issued after sqe0's event
>>> triggered twice before sqe1 completed. This isn't what users leverage
>>> drain requests for.
>>> Here a simple solution is to ignore all multishot poll cqes, which means
>>> drain requests  won't wait those request to be done.
>>>
>>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>>> ---
>>>   fs/io_uring.c | 9 +++++++--
>>>   1 file changed, 7 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index 513096759445..cd6d44cf5940 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -455,6 +455,7 @@ struct io_ring_ctx {
>>>       struct callback_head        *exit_task_work;
>>>         struct wait_queue_head        hash_wait;
>>> +    unsigned                        multishot_cqes;
>>>         /* Keep this last, we don't need it for the fast path */
>>>       struct work_struct        exit_work;
>>> @@ -1181,8 +1182,8 @@ static bool req_need_defer(struct io_kiocb *req, u32 seq)
>>>       if (unlikely(req->flags & REQ_F_IO_DRAIN)) {
>>>           struct io_ring_ctx *ctx = req->ctx;
>>>   -        return seq != ctx->cached_cq_tail
>>> -                + READ_ONCE(ctx->cached_cq_overflow);
>>> +        return seq + ctx->multishot_cqes != ctx->cached_cq_tail
>>> +            + READ_ONCE(ctx->cached_cq_overflow);
>>>       }
>>>         return false;
>>> @@ -4897,6 +4898,7 @@ static bool io_poll_complete(struct io_kiocb *req, __poll_t mask, int error)
>>>   {
>>>       struct io_ring_ctx *ctx = req->ctx;
>>>       unsigned flags = IORING_CQE_F_MORE;
>>> +    bool multishot_poll = !(req->poll.events & EPOLLONESHOT);
>>>         if (!error && req->poll.canceled) {
>>>           error = -ECANCELED;
>>> @@ -4911,6 +4913,9 @@ static bool io_poll_complete(struct io_kiocb *req, __poll_t mask, int error)
>>>           req->poll.done = true;
>>>           flags = 0;
>>>       }
>>> +    if (multishot_poll)
>>> +        ctx->multishot_cqes++;
>>> +
>>
>> We need to make sure we do that only for a non-final complete, i.e.
>> not killing request, otherwise it'll double account the last one.
> Hi Pavel, I saw a killing request like iopoll_remove or async_cancel call io_cqring_fill_event() to create an ECANCELED cqe for the original poll request. So there could be cases like(even for single poll request):
>   (1). add poll --> cancel poll, an ECANCELED cqe.
>                                                   1sqe:1cqe   all good
>   (2). add poll --> trigger event(queued to task_work) --> cancel poll,            an ECANCELED cqe --> task_work runs, another ECANCELED cqe.
>                                                   1sqe:2cqes

Those should emit a CQE on behalf of the request they're cancelling
only when it's definitely cancelled and not going to fill it
itself. E.g. if io_poll_cancel() found it and removed from
all the list and core's poll infra.

At least before multi-cqe it should have been working fine.

> I suggest we shall only emit one ECANCELED cqe.
> Currently I only account cqe through io_poll_complete(), so ECANCELED cqe from io_poll_remove or async_cancel etc are not counted in.
>> E.g. is failed __io_cqring_fill_event() in io_poll_complete() fine?
>> Other places?
> a failed __io_cqring_fill_event() doesn't produce a cqe but increment ctx->cached_cq_overflow, as long as a cqe is produced or cached_cq_overflow is +=1, it is ok.

Not claiming that the case is broken, but cached_cq_overflow is
considered in req_need_defer() as well, so from its perspective there
is no much difference between succeed fill_event() or not.

>>
>> Btw, we can use some tests :)
> I'll do more tests.

Perfect!

>>
>>
>>>       io_commit_cqring(ctx);
>>>       return !(flags & IORING_CQE_F_MORE);
>>>   }
>>>
>>
> 

-- 
Pavel Begunkov
