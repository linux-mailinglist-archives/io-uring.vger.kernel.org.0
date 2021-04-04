Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D14EC353A1D
	for <lists+io-uring@lfdr.de>; Mon,  5 Apr 2021 01:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbhDDXHq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 4 Apr 2021 19:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbhDDXHq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 4 Apr 2021 19:07:46 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4100C061756
        for <io-uring@vger.kernel.org>; Sun,  4 Apr 2021 16:07:40 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id q6-20020a17090a4306b02900c42a012202so4955605pjg.5
        for <io-uring@vger.kernel.org>; Sun, 04 Apr 2021 16:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fV8JkO5prrA4CPUyRccSuL+jZkNl9aRpdUmiSPloxO8=;
        b=fgS6BLS4jjpJUsn8uWq7lFbuxgrrhosCFZI94Jqh9SbdZcWT4gMtxxAPmI1zW0Ri3v
         7v34IC8lziQIWOQjwkrwOaFQ3pD0ORyDE2CR3DBP09dKmyWI+EXP8CeU4I8Wgxgr+gKg
         srxjJe3wtuK3wt+qv3j7QVLIcxODUCA7ZykKUMB5044wGijk3EXgjCkKsbqxTZ4KgfVt
         ss9jWayeLbsqiNhmdKwe0NdbvD0Cx6uTjOnbEjX8c1rvM7gWJ1EvFl/uHSAa+f+WjwkM
         3RqdfDt6PIB4l5BBmrDf1I8L8hCIJM67Rhu7hzjecgBtZ2BwsU3PJmThn0b8jIbjoyWG
         1kdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fV8JkO5prrA4CPUyRccSuL+jZkNl9aRpdUmiSPloxO8=;
        b=s7c2EdGgrN35UiR/I8Accr+Fv0sGnfYAP/l5tY8WEnkoG09TQNGUQ97dODP+i9CPjO
         8VQdlXwvQDKV4Jj4EJR3jxyLTsig+bM6ogJrsiG01Tsum+ue9CMwentR6P1KRvBw9F6+
         TiuVmzdkk4t4LQtqEfgcYoWr50Bl+4S91d8k//dmelLXuw3pXrHFUl0O5SJfNMfbR8vQ
         N3hzO07gKIDv7BGoBH0+1ZzSpPwfs7nIDh53/t+IrT0Ysx7KSsK3bT9AMYVHf0/qCnsP
         JKMfOBfeBRqMlDA7e6CQ4UIPi4yhlCXHmdmgpUSs+f5wXLdU466Q6UXqkvMSwlvDYi0x
         BH5g==
X-Gm-Message-State: AOAM531KPn3lBGnb7B/nkxThjH1Hd/GQwmsEb2dqfhUIdjTo8jQky4zV
        vbb0D6zPkptqG/38cu1UCHrOqUy6nJZSig==
X-Google-Smtp-Source: ABdhPJzpsDAxuOzHDARoY6O+rFV2h6xbvlclMn+ZB1sjhevE+z8bqhhVbxT/VCuT5eMPjTlAtMHexw==
X-Received: by 2002:a17:90a:3e49:: with SMTP id t9mr23612086pjm.9.1617577660056;
        Sun, 04 Apr 2021 16:07:40 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 12sm13527879pgw.18.2021.04.04.16.07.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Apr 2021 16:07:39 -0700 (PDT)
Subject: Re: [PATCH for-5.13] io_uring: maintain drain requests' logic
To:     Hao Xu <haoxu@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1617181262-66724-1-git-send-email-haoxu@linux.alibaba.com>
 <55b29f0f-967d-fc91-a959-60e01acc55a3@gmail.com>
 <652e4b3b-4b98-54db-a86c-31478ca33355@linux.alibaba.com>
 <b3db5da8-1bce-530b-5542-c6f9b589a191@gmail.com>
 <49152a6e-6d8a-21f1-fd9c-8b764c21b2d3@linux.alibaba.com>
 <59d15355-4317-99af-c7c4-364d0e7c1682@gmail.com>
 <bc90166c-99ce-46c5-da7e-462dee896ad7@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <dc62f2aa-3f08-2f6f-e2bc-274ea8b3910c@kernel.dk>
Date:   Sun, 4 Apr 2021 17:07:38 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <bc90166c-99ce-46c5-da7e-462dee896ad7@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/3/21 12:58 AM, Hao Xu wrote:
> 在 2021/4/2 上午6:29, Pavel Begunkov 写道:
>> On 01/04/2021 15:55, Hao Xu wrote:
>>> 在 2021/4/1 下午6:25, Pavel Begunkov 写道:
>>>> On 01/04/2021 07:53, Hao Xu wrote:
>>>>> 在 2021/4/1 上午6:06, Pavel Begunkov 写道:
>>>>>>
>>>>>>
>>>>>> On 31/03/2021 10:01, Hao Xu wrote:
>>>>>>> Now that we have multishot poll requests, one sqe can emit multiple
>>>>>>> cqes. given below example:
>>>>>>>        sqe0(multishot poll)-->sqe1-->sqe2(drain req)
>>>>>>> sqe2 is designed to issue after sqe0 and sqe1 completed, but since sqe0
>>>>>>> is a multishot poll request, sqe2 may be issued after sqe0's event
>>>>>>> triggered twice before sqe1 completed. This isn't what users leverage
>>>>>>> drain requests for.
>>>>>>> Here a simple solution is to ignore all multishot poll cqes, which means
>>>>>>> drain requests  won't wait those request to be done.
>>>>>>>
>>>>>>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>>>>>>> ---
>>>>>>>     fs/io_uring.c | 9 +++++++--
>>>>>>>     1 file changed, 7 insertions(+), 2 deletions(-)
>>>>>>>
>>>>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>>>>> index 513096759445..cd6d44cf5940 100644
>>>>>>> --- a/fs/io_uring.c
>>>>>>> +++ b/fs/io_uring.c
>>>>>>> @@ -455,6 +455,7 @@ struct io_ring_ctx {
>>>>>>>         struct callback_head        *exit_task_work;
>>>>>>>           struct wait_queue_head        hash_wait;
>>>>>>> +    unsigned                        multishot_cqes;
>>>>>>>           /* Keep this last, we don't need it for the fast path */
>>>>>>>         struct work_struct        exit_work;
>>>>>>> @@ -1181,8 +1182,8 @@ static bool req_need_defer(struct io_kiocb *req, u32 seq)
>>>>>>>         if (unlikely(req->flags & REQ_F_IO_DRAIN)) {
>>>>>>>             struct io_ring_ctx *ctx = req->ctx;
>>>>>>>     -        return seq != ctx->cached_cq_tail
>>>>>>> -                + READ_ONCE(ctx->cached_cq_overflow);
>>>>>>> +        return seq + ctx->multishot_cqes != ctx->cached_cq_tail
>>>>>>> +            + READ_ONCE(ctx->cached_cq_overflow);
>>>>>>>         }
>>>>>>>           return false;
>>>>>>> @@ -4897,6 +4898,7 @@ static bool io_poll_complete(struct io_kiocb *req, __poll_t mask, int error)
>>>>>>>     {
>>>>>>>         struct io_ring_ctx *ctx = req->ctx;
>>>>>>>         unsigned flags = IORING_CQE_F_MORE;
>>>>>>> +    bool multishot_poll = !(req->poll.events & EPOLLONESHOT);
>>>>>>>           if (!error && req->poll.canceled) {
>>>>>>>             error = -ECANCELED;
>>>>>>> @@ -4911,6 +4913,9 @@ static bool io_poll_complete(struct io_kiocb *req, __poll_t mask, int error)
>>>>>>>             req->poll.done = true;
>>>>>>>             flags = 0;
>>>>>>>         }
>>>>>>> +    if (multishot_poll)
>>>>>>> +        ctx->multishot_cqes++;
>>>>>>> +
>>>>>>
>>>>>> We need to make sure we do that only for a non-final complete, i.e.
>>>>>> not killing request, otherwise it'll double account the last one.
>>>>> Hi Pavel, I saw a killing request like iopoll_remove or async_cancel call io_cqring_fill_event() to create an ECANCELED cqe for the original poll request. So there could be cases like(even for single poll request):
>>>>>     (1). add poll --> cancel poll, an ECANCELED cqe.
>>>>>                                                     1sqe:1cqe   all good
>>>>>     (2). add poll --> trigger event(queued to task_work) --> cancel poll,            an ECANCELED cqe --> task_work runs, another ECANCELED cqe.
>>>>>                                                     1sqe:2cqes
>>>>
>>>> Those should emit a CQE on behalf of the request they're cancelling
>>>> only when it's definitely cancelled and not going to fill it
>>>> itself. E.g. if io_poll_cancel() found it and removed from
>>>> all the list and core's poll infra.
>>>>
>>>> At least before multi-cqe it should have been working fine.
>>>>
>>> I haven't done a test for this, but from the code logic, there could be
>>> case below:
>>>
>>> io_poll_add()                         | io_poll_remove
>>> (event happen)io_poll_wake()          | io_poll_remove_one
>>>                                        | io_poll_remove_waitqs
>>>                                        | io_cqring_fill_event(-ECANCELED)
>>>                                        |
>>> task_work run(io_poll_task_func)      |
>>> io_poll_complete()                    |
>>> req->poll.canceled is true, \         |
>>> __io_cqring_fill_event(-ECANCELED)    |
>>>
>>> two ECANCELED cqes, is there anything I missed?
>>
>> Definitely may be be, but need to take a closer look
>>
> I'll do some test to test if this issue exists, and make some change if 
> it does.

How about something like this? Seems pointless to have an extra
variable for this, when we already track if we're going to do more
completions for this event or not. Also places the variable where
it makes the most sense, and plenty of pad space there too.

Warning: totally untested. Would be great if you could, and hoping
you're going to send out a v2.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index f94b32b43429..1eea4998ad9b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -423,6 +423,7 @@ struct io_ring_ctx {
 		unsigned		cq_mask;
 		atomic_t		cq_timeouts;
 		unsigned		cq_last_tm_flush;
+		unsigned		cq_extra;
 		unsigned long		cq_check_overflow;
 		struct wait_queue_head	cq_wait;
 		struct fasync_struct	*cq_fasync;
@@ -1183,8 +1184,8 @@ static bool req_need_defer(struct io_kiocb *req, u32 seq)
 	if (unlikely(req->flags & REQ_F_IO_DRAIN)) {
 		struct io_ring_ctx *ctx = req->ctx;
 
-		return seq != ctx->cached_cq_tail
-				+ READ_ONCE(ctx->cached_cq_overflow);
+		return seq + ctx->cq_extra != ctx->cached_cq_tail
+			+ READ_ONCE(ctx->cached_cq_overflow);
 	}
 
 	return false;
@@ -4894,6 +4895,9 @@ static bool io_poll_complete(struct io_kiocb *req, __poll_t mask, int error)
 		req->poll.done = true;
 		flags = 0;
 	}
+	if (flags & IORING_CQE_F_MORE)
+		ctx->cq_extra++;
+
 	io_commit_cqring(ctx);
 	return !(flags & IORING_CQE_F_MORE);
 }

-- 
Jens Axboe

