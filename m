Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7140E3D59AC
	for <lists+io-uring@lfdr.de>; Mon, 26 Jul 2021 14:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233859AbhGZMAX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Jul 2021 08:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233754AbhGZMAV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Jul 2021 08:00:21 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3ED2C061757
        for <io-uring@vger.kernel.org>; Mon, 26 Jul 2021 05:40:49 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id b7so10902027wri.8
        for <io-uring@vger.kernel.org>; Mon, 26 Jul 2021 05:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ppnRAg089Y7etkkxB+R3eTl+RxQx1nPBaVft0K7zoIk=;
        b=fKz3RR4OEii3+6I29YAf+jYDDyM+DcNpcKbylkpJuv7m9CKw9jg8Io4Km5bAx1FkqM
         heHLeyzlbM22U3AFvFWwNopsmivuHN/vxJjSXJZ5GuaOSDJKqF0TTd0T/Yt9MZbEBBNc
         /WBKcZLiWfarTwCBjzW5Rc0PqUqiREak7q2Udd89xnA25kK82Imr8zCuhW3Qn0kHJXnT
         lyC3Q12X/aPVK9BigwR9psh5yIlkmP8jyMX2HHv2sLepNAVrRPX1z4p10UzAqA/ya+ZZ
         MWpfGoSdWrDT9zIn1oWm2ZS94i1pdWQxPCLs45lPowOuBRX+BiTztsP4RFlAIRERuPnX
         Gvxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ppnRAg089Y7etkkxB+R3eTl+RxQx1nPBaVft0K7zoIk=;
        b=Qd1gmoBS3e/C/qDoGHIW3gd+uMjwCoT45HAPGfLxDhO7HIZv5/9VYBqP2mDD6GjU6E
         WuwvK5FjrzGysg4G95C8qrRUIsrTsZ8T49C8Lw86rOZyLFFB2TvvElPPNDoUdhAS9U0x
         QS5haAQfw8V4t3NFRI1mMzYZ2IkmLzfq2lFDP+0FtVMxmqmw3WudyUiFFHh1BAgAIUGm
         9DniybiG+bGfX5IwfFEArF21ms7dDlEVG912Ah7EpIg39tKZShV2Z5qC+5XVMy3IoEJF
         KhGEqV8W6fMjExVvu9iP/bPPeTUYnZxUVk8i23XvAsgglGgODFRB/asN2pATMCPcwWak
         5nXw==
X-Gm-Message-State: AOAM533R/NRSaNPzMaRyOErTxRFWLfvkZD8FwmCJ6PrBYLXvPUKL1uHr
        3+WIGuiiAMdRTNhUy19JxE0=
X-Google-Smtp-Source: ABdhPJxGuseI8N2pJYnnCbksf/e2DSlBbyo263KlmfjyoZqbj7Jtedscr4IzK0lbrLvO7XVW/7YW1Q==
X-Received: by 2002:a5d:6a4d:: with SMTP id t13mr18945236wrw.412.1627303248450;
        Mon, 26 Jul 2021 05:40:48 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.133.244])
        by smtp.gmail.com with ESMTPSA id l18sm4603677wmq.0.2021.07.26.05.40.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 05:40:47 -0700 (PDT)
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210723092227.137526-1-haoxu@linux.alibaba.com>
 <c628d5bc-ee34-bf43-c7bc-5b52cf983cb1@gmail.com>
 <824dcbe0-34da-a075-12eb-ce7529f3e3f7@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH io_uring-5.14 v2] io_uring: remove double poll wait entry
 for pure poll
Message-ID: <28ce8b3d-e9d2-2fed-e73c-fb09913eea78@gmail.com>
Date:   Mon, 26 Jul 2021 13:40:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <824dcbe0-34da-a075-12eb-ce7529f3e3f7@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/24/21 5:48 AM, Hao Xu wrote:
> 在 2021/7/23 下午10:31, Pavel Begunkov 写道:
>> On 7/23/21 10:22 AM, Hao Xu wrote:
>>> For pure poll requests, we should remove the double poll wait entry.
>>> And io_poll_remove_double() is good enough for it compared with
>>> io_poll_remove_waitqs().
>>
>> 5.14 in the subject hints me that it's a fix. Is it?
>> Can you add what it fixes or expand on why it's better?
> Hi Pavel, I found that for poll_add() requests, it doesn't remove the
> double poll wait entry when it's done, neither after vfs_poll() or in
> the poll completion handler. The patch is mainly to fix it.

Ok, sounds good. Please resend with updated description, and
let's add some tags.

Fixes: 88e41cf928a6 ("io_uring: add multishot mode for IORING_OP_POLL_ADD")
Cc: stable@vger.kernel.org # 5.13+

Also, I'd prefer the commit title to make more clear that it's a
fix. E.g. "io_uring: fix poll requests leaking second poll entries".

Btw, seems it should fix hangs in ./poll-mshot-update


>>
>>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>>> ---
>>>
>>> v1-->v2
>>>    delete redundant io_poll_remove_double()
>>>
>>>   fs/io_uring.c | 5 ++---
>>>   1 file changed, 2 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index f2fe4eca150b..c5fe8b9e26b4 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -4903,7 +4903,6 @@ static bool io_poll_complete(struct io_kiocb *req, __poll_t mask)
>>>       if (req->poll.events & EPOLLONESHOT)
>>>           flags = 0;
>>>       if (!io_cqring_fill_event(ctx, req->user_data, error, flags)) {
>>> -        io_poll_remove_waitqs(req);
> Currently I only see it does that with io_poll_remove_waitqs() when
> cqring overflow and then ocqe allocation failed. Using
> io_poll_remove_waitqs() here is not very suitable since (1) it calls
> __io_poll_remove_one() which set poll->cancelled = true, why do we set
> poll->cancelled and poll->done to true at the same time though I think
> that doesn't cause any problem. (2) it does
> list_del_init(&poll->wait.entry) and hash_del(&req->hash_node) which
> has been already done.
> Correct me if I'm wrong since I may misunderstand the code.
> 
> Regards,
> Hao
>>>           req->poll.done = true;
>>>           flags = 0;
>>>       }
>>> @@ -4926,6 +4925,7 @@ static void io_poll_task_func(struct io_kiocb *req)
>>>             done = io_poll_complete(req, req->result);
>>>           if (done) {
>>> +            io_poll_remove_double(req);
>>>               hash_del(&req->hash_node);
>>>           } else {
>>>               req->result = 0;
>>> @@ -5113,7 +5113,7 @@ static __poll_t __io_arm_poll_handler(struct io_kiocb *req,
>>>           ipt->error = -EINVAL;
>>>         spin_lock_irq(&ctx->completion_lock);
>>> -    if (ipt->error)
>>> +    if (ipt->error || (mask && (poll->events & EPOLLONESHOT)))
>>>           io_poll_remove_double(req);
>>>       if (likely(poll->head)) {
>>>           spin_lock(&poll->head->lock);
>>> @@ -5185,7 +5185,6 @@ static int io_arm_poll_handler(struct io_kiocb *req)
>>>       ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask,
>>>                       io_async_wake);
>>>       if (ret || ipt.error) {
>>> -        io_poll_remove_double(req);
>>>           spin_unlock_irq(&ctx->completion_lock);
>>>           if (ret)
>>>               return IO_APOLL_READY;
>>>
>>
> 

-- 
Pavel Begunkov
