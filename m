Return-Path: <io-uring+bounces-1331-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6160289214C
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 17:10:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 842251C2393B
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 16:10:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C9F91C0DE3;
	Fri, 29 Mar 2024 16:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="yJcasl1s"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24641C0DD0
	for <io-uring@vger.kernel.org>; Fri, 29 Mar 2024 16:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711728620; cv=none; b=cXszgFjp1NUrF7HgyFJrxy99TBwl37CkA5SPBBYy9gH2HEs1Eqn1Q91LlYsXExZoVr74W+P1G9mtWvX1WMIrge/wkrbmV6z2Yq34XL1nRa4YZoFQ2uhoCTUaQjMbYG5ZURUyAiHBz3QMD8jKDs6iLMLSvozyNB2Wt8vl3UCBHQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711728620; c=relaxed/simple;
	bh=pjAVu2jX7klq4PRYfUS+10V+1i/85zqmjIVVOk4Ay74=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=RcgKIdpZOb3CCchc8wfv5u37Ujlc1H5cOmmyZuYMH6KBA7pWW7Y8WcfOngdPP1lr97CAW7nwkKNwsVrFIrLaWSqNT7SEzLR3pYbfrQdmwKyHxDzFEAag06nwC8sI2xSxs+MO13Sbw/Y6bRLUCZDMsr9fc872bAJAHgj/xR/A2r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=yJcasl1s; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6e694337fffso427521b3a.1
        for <io-uring@vger.kernel.org>; Fri, 29 Mar 2024 09:10:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711728618; x=1712333418; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=s7HgsRTxfg4PHKoWhwS/cY9DIJZls+41/d+n7Gj4M5g=;
        b=yJcasl1s0eICl0j8y2EGuXR4icRssaZ0OtUb24Q8gzzYcbK8oIh+FXiAubVlifcPhn
         6Zu2PQjM8VvGAT+k/k1wYk3XYz35NMv4QYURhnvoFLaaMkSO9UG3VblsRwJWFBYlvceZ
         ItMFZ4obOtTbHwgHnvKetbCniSqCaJwJsIy7GBv548T1WrDTV/ybMiS32HsYC1X5oU8B
         AYlYWK57nr7Zrzh30PTdxVNNNh1e7GXLwXJpV7Ydf98APFsbqg4XAjRZrxcMGGUXOPYA
         CmWQ0smjfeuMRu9+zZZNJ0zmofSjjJ3Jqs6ySl+kr4/mnBMBWvmrVyJqqSgYqKTb+SjR
         gZSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711728618; x=1712333418;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s7HgsRTxfg4PHKoWhwS/cY9DIJZls+41/d+n7Gj4M5g=;
        b=ocxnxhTIpAs2QqEOqPSMKUKqnpya952k6r/o7fqu/4sPiHvBa8cEUuTjzyFGfgYR4V
         QCI7uJzhm7enS9KmhDdSd862r2OSeTWLOAS0APfhctkAK8SEM15nKdixleSp9vrsK8tk
         BwWG/vsULK1ImUZU9pmwbXjz3FoVDEt0G37NR5DUvN2eGt6gi7ugZq/1PTN0h2a0jWrN
         GAh+MyBMGQP7O7UxOaLr2UQbF3IbbY0qJ3n1eUdt9U2aiTClItqrZueMHj4q22plXF0z
         8hNguO33u5fjUBGGvwIc5/yBsPYCnpE+3E1C7ERbr1klBRWhua/jRqIB/HKizbPqGsDB
         ZgGw==
X-Forwarded-Encrypted: i=1; AJvYcCV4PSt6b82Sid83Ifs2bQlehXkb3HMvQxOjiOhTh0JPj6nf2ho69edhHQNHBOPio0VemWwpDhr2+Qmqu752ZvyLR/r+GF+Q07Q=
X-Gm-Message-State: AOJu0Yzj+5fOPxrNT7TyAgcGoiA47JE11BfkUwMNKjHPzB/gJRe5xH5e
	7J14YdBx3UzfH6rCG4cJmZEJ8MFaDzGnkJviCQmXomOWu42Q5Y6/Cb4nFR1QKA9SiWL5nXbIOCn
	w
X-Google-Smtp-Source: AGHT+IFDzLy7WTvrMvJJOTijd4j9BRaOFXwcwBJlDJ9AYMBNX6GzxInw8M15NLOf3yLGrczz/6T1cw==
X-Received: by 2002:a05:6a20:6a1b:b0:1a7:199:8ac5 with SMTP id p27-20020a056a206a1b00b001a701998ac5mr875816pzk.4.1711728618135;
        Fri, 29 Mar 2024 09:10:18 -0700 (PDT)
Received: from [192.168.201.244] ([50.234.116.5])
        by smtp.gmail.com with ESMTPSA id ls29-20020a056a00741d00b006ead792b6a0sm3286568pfb.93.2024.03.29.09.10.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Mar 2024 09:10:17 -0700 (PDT)
Message-ID: <32d38aa1-8225-4cdb-820c-54e331283e21@kernel.dk>
Date: Fri, 29 Mar 2024 10:10:17 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] io_uring: add remote task_work execution helper
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20240328185413.759531-1-axboe@kernel.dk>
 <20240328185413.759531-2-axboe@kernel.dk>
 <4e8b5815-322e-4511-b529-6db745e8d0e0@gmail.com>
 <8ca5b243-4214-4821-804c-5be72f6836ee@kernel.dk>
 <2245a85b-a190-4a1e-a8ab-cc93a789d994@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2245a85b-a190-4a1e-a8ab-cc93a789d994@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/29/24 9:50 AM, Pavel Begunkov wrote:
> On 3/29/24 13:31, Jens Axboe wrote:
>> On 3/29/24 6:51 AM, Pavel Begunkov wrote:
>>> On 3/28/24 18:52, Jens Axboe wrote:
>>>> All our task_work handling is targeted at the state in the io_kiocb
>>>> itself, which is what it is being used for. However, MSG_RING rolls its
>>>> own task_work handling, ignoring how that is usually done.
>>>>
>>>> In preparation for switching MSG_RING to be able to use the normal
>>>> task_work handling, add io_req_task_work_add_remote() which allows the
>>>> caller to pass in the target io_ring_ctx and task.
>>>>
>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>> ---
>>>>    io_uring/io_uring.c | 27 +++++++++++++++++++--------
>>>>    io_uring/io_uring.h |  2 ++
>>>>    2 files changed, 21 insertions(+), 8 deletions(-)
>>>>
>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>> index 9978dbe00027..609ff9ea5930 100644
>>>> --- a/io_uring/io_uring.c
>>>> +++ b/io_uring/io_uring.c
>>>> @@ -1241,9 +1241,10 @@ void tctx_task_work(struct callback_head *cb)
>>>>        WARN_ON_ONCE(ret);
>>>>    }
>>>>    -static inline void io_req_local_work_add(struct io_kiocb *req, unsigned tw_flags)
>>>> +static inline void io_req_local_work_add(struct io_kiocb *req,
>>>> +                     struct io_ring_ctx *ctx,
>>>> +                     unsigned tw_flags)
>>>>    {
>>>> -    struct io_ring_ctx *ctx = req->ctx;
>>>>        unsigned nr_wait, nr_tw, nr_tw_prev;
>>>>        unsigned long flags;
>>>>    @@ -1291,9 +1292,10 @@ static inline void io_req_local_work_add(struct io_kiocb *req, unsigned tw_flags
>>>>        wake_up_state(ctx->submitter_task, TASK_INTERRUPTIBLE);
>>>>    }
>>>>    -static void io_req_normal_work_add(struct io_kiocb *req)
>>>> +static void io_req_normal_work_add(struct io_kiocb *req,
>>>> +                   struct task_struct *task)
>>>>    {
>>>> -    struct io_uring_task *tctx = req->task->io_uring;
>>>> +    struct io_uring_task *tctx = task->io_uring;
>>>>        struct io_ring_ctx *ctx = req->ctx;
>>>>        unsigned long flags;
>>>>        bool was_empty;
>>>> @@ -1319,7 +1321,7 @@ static void io_req_normal_work_add(struct io_kiocb *req)
>>>>            return;
>>>>        }
>>>>    -    if (likely(!task_work_add(req->task, &tctx->task_work, ctx->notify_method)))
>>>> +    if (likely(!task_work_add(task, &tctx->task_work, ctx->notify_method)))
>>>>            return;
>>>>          io_fallback_tw(tctx, false);
>>>> @@ -1328,9 +1330,18 @@ static void io_req_normal_work_add(struct io_kiocb *req)
>>>>    void __io_req_task_work_add(struct io_kiocb *req, unsigned flags)
>>>>    {
>>>>        if (req->ctx->flags & IORING_SETUP_DEFER_TASKRUN)
>>>> -        io_req_local_work_add(req, flags);
>>>> +        io_req_local_work_add(req, req->ctx, flags);
>>>> +    else
>>>> +        io_req_normal_work_add(req, req->task);
>>>> +}
>>>> +
>>>> +void io_req_task_work_add_remote(struct io_kiocb *req, struct task_struct *task,
>>>> +                 struct io_ring_ctx *ctx, unsigned flags)
>>>
>>> Urgh, even the declration screams that there is something wrong
>>> considering it _either_ targets @ctx or @task.
>>>
>>> Just pass @ctx, so it either use ctx->submitter_task or
>>> req->task, hmm?
>>
>> I actually since changed the above to use a common helper, so was
>> scratching my head a bit over your comment as it can't really work in
>> that setup without needing to check for whether ->submitter_task is set
>> or not. But I do agree this would be nicer, so I'll just return to using
>> the separate helpers for this and it should fall out nicely. The only
>> odd caller is the MSG_RING side, so makes sense to have it a bit more
>> separate rather than try and fold it in with the regular side of using
>> task_work.
>>
>>> A side note, it's a dangerous game, I told it before. At least
>>> it would've been nice to abuse lockdep in a form of:
>>>
>>> io_req_task_complete(req, tw, ctx) {
>>>      lockdep_assert(req->ctx == ctx);
>>>      ...
>>> }
>>>
>>> but we don't have @ctx there, maybe we'll add it to tw later.
>>
>> Agree, but a separate thing imho.
> 
> It's not in a sense that condition couldn't have happened
> before and the patch opening all possibilities.
> 
> We actually have @ctx via struct io_tctx_node, so considering
> fallback it would probably be:
> 
> lockdep_assert(!current->io_uring ||
>                current->io_uring->ctx == req->ctx);

That's not a bad idea. I did run all the testing verifying the ctx, and
it all appears fine. But adding the check is a good idea in general.
Want to send it?

-- 
Jens Axboe


