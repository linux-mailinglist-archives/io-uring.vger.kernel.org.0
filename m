Return-Path: <io-uring+bounces-1326-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E987689214D
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 17:10:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 767F9B275E2
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 15:50:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D78DC51C2B;
	Fri, 29 Mar 2024 15:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yys06zaB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DAC125778
	for <io-uring@vger.kernel.org>; Fri, 29 Mar 2024 15:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711727430; cv=none; b=QyFUNePt2xNa0GVAzVWsOgEk1Ech2ffMQlDpxJkjwwkQ+4Zo+LW7cci+VVLu/R/V0h3NN4uSj82PrkOFVqXEm23mDFCKFX9UDnjaxGlZHcIHKwJdNmQTZcMzLE4jfk/QQCu1jwCARwRwCBNnnfrdHZHa4c5Rp3qunMp6j5MUEQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711727430; c=relaxed/simple;
	bh=Pvr1rt1IvnWtSGq67sc/+olkTaoNko9dws9tzldU3Xg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=jBD6Eefm2vP1Sik0nJv07azGPWKXOnwxItNmDwpPOnMZNTltWCTW9arn+I+UJiS9Z9pxf669i40T9x5G1uv9ei1HCtW22PDD1DRDTkrEGcs5XjKMJfTo3cf11bjPhf/GPKYotFZK1Vx4jaAd/SEkfgPUUt+3eQ5qVbITxoJfPyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yys06zaB; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a466e53f8c0so271124266b.1
        for <io-uring@vger.kernel.org>; Fri, 29 Mar 2024 08:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711727427; x=1712332227; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=E8c7rpC3MbNNObQsj1Vz/nftyLsDmnQUU3GteSs2qeE=;
        b=Yys06zaB6DUbwyn9zbhLFtAhLyD4atxboHW0Wb3g3ryvYUFir+ZeNgTCmOo+j9Y8Nw
         cNlhePxxBEpuFHekMqZQA/9/F6L5gLQailiH3k+NcV6tj0GY+Revr3pj8eHJaTV538JV
         B8TZsSmF7eZDpZkaYyL+pd3mkqIkrakDZhYg4uBlGo/qaJIiCqMBAsux95r/J58ejfQF
         41lvHJgZ9KOS3zj+F8oWJOP5LA/ThH3fyQ7RmT3Rj0lb7W26k5RR4w6+HPhuiQH1asFp
         vwUZfbMwhvDY98KBQjoG9jVtuyqKBzjXg30VqCnaOLy1qKORVl1rVgplCNltbGRWhwe/
         4kuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711727427; x=1712332227;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E8c7rpC3MbNNObQsj1Vz/nftyLsDmnQUU3GteSs2qeE=;
        b=TNqZa+bZcfTeY5gKh3vW7+CvCqWwVB8N0pnuPfq04s7TEbriiERhU5zouXFjEjfsiq
         xlVUpfYj2Qgypfb0/6SPXyfUR50LuILd932bVsvR4kRO53xybDgU1rnhAxDroJzj5xrS
         HDFhs4I36N0RZ5Foh+G1rCeHrCHXRsdWgvLq9ZrIwVnH0NS1Lz+mOy7lL0Alw9BY/jIR
         gYPIu7izYIcCU7xLIRRs2MUvG6+O9qBc/xaaNy7PgrOIKp/dGiyOq9V07KTuanxAvGPT
         e6bYY2xDu4exuovgi+FAwGrd3zB7P42B5FajgmwfaEZXCIQlrGRv2acIrA6YGFGr13ok
         aUPg==
X-Forwarded-Encrypted: i=1; AJvYcCUfkmR9SizKtdgYvg4cqh4dklAQEY7idKrN5hyyyp6ddjXkVMINXrpZ7kCldgg3oncItBn0a2NphNLA5ls/8e5DmXmNlmB4Ajo=
X-Gm-Message-State: AOJu0YxD5wtWnn9TW2i6rOedCKZzjV+cWVUP/JzyjrCF8+Tq9fqyng6b
	ChfPwW7+Ym7mMe4P5qpqHHUo/xomzOWO85ud85OgLLyMAfZvYzHTzTMPpeUE
X-Google-Smtp-Source: AGHT+IGZiQYiq8w+FU0Ob4x23DwEe+F9I4D/j9BtE0ZqYhDuOiqaSSIEMW4qdiZJh+9/968e1ElpPA==
X-Received: by 2002:a17:907:20b6:b0:a4d:f56a:19fc with SMTP id pw22-20020a17090720b600b00a4df56a19fcmr1820066ejb.13.1711727427031;
        Fri, 29 Mar 2024 08:50:27 -0700 (PDT)
Received: from [192.168.8.112] ([148.252.140.106])
        by smtp.gmail.com with ESMTPSA id n8-20020a170906118800b00a4a393518b6sm2053633eja.158.2024.03.29.08.50.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Mar 2024 08:50:26 -0700 (PDT)
Message-ID: <2245a85b-a190-4a1e-a8ab-cc93a789d994@gmail.com>
Date: Fri, 29 Mar 2024 15:50:23 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] io_uring: add remote task_work execution helper
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20240328185413.759531-1-axboe@kernel.dk>
 <20240328185413.759531-2-axboe@kernel.dk>
 <4e8b5815-322e-4511-b529-6db745e8d0e0@gmail.com>
 <8ca5b243-4214-4821-804c-5be72f6836ee@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <8ca5b243-4214-4821-804c-5be72f6836ee@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/29/24 13:31, Jens Axboe wrote:
> On 3/29/24 6:51 AM, Pavel Begunkov wrote:
>> On 3/28/24 18:52, Jens Axboe wrote:
>>> All our task_work handling is targeted at the state in the io_kiocb
>>> itself, which is what it is being used for. However, MSG_RING rolls its
>>> own task_work handling, ignoring how that is usually done.
>>>
>>> In preparation for switching MSG_RING to be able to use the normal
>>> task_work handling, add io_req_task_work_add_remote() which allows the
>>> caller to pass in the target io_ring_ctx and task.
>>>
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>> ---
>>>    io_uring/io_uring.c | 27 +++++++++++++++++++--------
>>>    io_uring/io_uring.h |  2 ++
>>>    2 files changed, 21 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>> index 9978dbe00027..609ff9ea5930 100644
>>> --- a/io_uring/io_uring.c
>>> +++ b/io_uring/io_uring.c
>>> @@ -1241,9 +1241,10 @@ void tctx_task_work(struct callback_head *cb)
>>>        WARN_ON_ONCE(ret);
>>>    }
>>>    -static inline void io_req_local_work_add(struct io_kiocb *req, unsigned tw_flags)
>>> +static inline void io_req_local_work_add(struct io_kiocb *req,
>>> +                     struct io_ring_ctx *ctx,
>>> +                     unsigned tw_flags)
>>>    {
>>> -    struct io_ring_ctx *ctx = req->ctx;
>>>        unsigned nr_wait, nr_tw, nr_tw_prev;
>>>        unsigned long flags;
>>>    @@ -1291,9 +1292,10 @@ static inline void io_req_local_work_add(struct io_kiocb *req, unsigned tw_flags
>>>        wake_up_state(ctx->submitter_task, TASK_INTERRUPTIBLE);
>>>    }
>>>    -static void io_req_normal_work_add(struct io_kiocb *req)
>>> +static void io_req_normal_work_add(struct io_kiocb *req,
>>> +                   struct task_struct *task)
>>>    {
>>> -    struct io_uring_task *tctx = req->task->io_uring;
>>> +    struct io_uring_task *tctx = task->io_uring;
>>>        struct io_ring_ctx *ctx = req->ctx;
>>>        unsigned long flags;
>>>        bool was_empty;
>>> @@ -1319,7 +1321,7 @@ static void io_req_normal_work_add(struct io_kiocb *req)
>>>            return;
>>>        }
>>>    -    if (likely(!task_work_add(req->task, &tctx->task_work, ctx->notify_method)))
>>> +    if (likely(!task_work_add(task, &tctx->task_work, ctx->notify_method)))
>>>            return;
>>>          io_fallback_tw(tctx, false);
>>> @@ -1328,9 +1330,18 @@ static void io_req_normal_work_add(struct io_kiocb *req)
>>>    void __io_req_task_work_add(struct io_kiocb *req, unsigned flags)
>>>    {
>>>        if (req->ctx->flags & IORING_SETUP_DEFER_TASKRUN)
>>> -        io_req_local_work_add(req, flags);
>>> +        io_req_local_work_add(req, req->ctx, flags);
>>> +    else
>>> +        io_req_normal_work_add(req, req->task);
>>> +}
>>> +
>>> +void io_req_task_work_add_remote(struct io_kiocb *req, struct task_struct *task,
>>> +                 struct io_ring_ctx *ctx, unsigned flags)
>>
>> Urgh, even the declration screams that there is something wrong
>> considering it _either_ targets @ctx or @task.
>>
>> Just pass @ctx, so it either use ctx->submitter_task or
>> req->task, hmm?
> 
> I actually since changed the above to use a common helper, so was
> scratching my head a bit over your comment as it can't really work in
> that setup without needing to check for whether ->submitter_task is set
> or not. But I do agree this would be nicer, so I'll just return to using
> the separate helpers for this and it should fall out nicely. The only
> odd caller is the MSG_RING side, so makes sense to have it a bit more
> separate rather than try and fold it in with the regular side of using
> task_work.
> 
>> A side note, it's a dangerous game, I told it before. At least
>> it would've been nice to abuse lockdep in a form of:
>>
>> io_req_task_complete(req, tw, ctx) {
>>      lockdep_assert(req->ctx == ctx);
>>      ...
>> }
>>
>> but we don't have @ctx there, maybe we'll add it to tw later.
> 
> Agree, but a separate thing imho.

It's not in a sense that condition couldn't have happened
before and the patch opening all possibilities.

We actually have @ctx via struct io_tctx_node, so considering
fallback it would probably be:

lockdep_assert(!current->io_uring ||
                current->io_uring->ctx == req->ctx);

-- 
Pavel Begunkov

