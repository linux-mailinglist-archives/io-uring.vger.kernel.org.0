Return-Path: <io-uring+bounces-1321-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7757A891F85
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 16:06:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E3FF51F30F76
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 15:06:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0172137765;
	Fri, 29 Mar 2024 13:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Nf0stdVW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB3014387E
	for <io-uring@vger.kernel.org>; Fri, 29 Mar 2024 13:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711719124; cv=none; b=ow2fsCf+Fg0xhJ8nFfjDSTSNFrHTmKZxTLM7+U01xng7NeEm34IehgNokQAfbOTFXsW9sXzZtQtMQ+wxqz6CUxootQm5V3CqJe6aIYLmp4kQHqbsgUkpILf1LtfvsCaRLVF6DClpaLAwIrt9xMyj6Y0edT4i9xQhEXI4OuNJC4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711719124; c=relaxed/simple;
	bh=9+4M0trNlWI6OSN1Bq2oTZL+y4TlpFpljiyqjrPT0cU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=FPsydkmk+A8PCTraQaD6qQAgcSsyq9e3WY915ngYyh5Ip47lWOOAgQJZ/m6mXkB8fiQ3pMu0BfNWTkOQFuhL1zwpxNO6DogDEBLyiYDoOM2GdO56JCxmGUmg2ERxzgtkYKsp2ouaVq6AHERjFQCZwiXbzPcT7sX7FCLy7i2DuPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Nf0stdVW; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6e6ca65edc9so501483b3a.0
        for <io-uring@vger.kernel.org>; Fri, 29 Mar 2024 06:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711719120; x=1712323920; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WITlaB1Xwz7zvzD2p6o1GBTT8vCtat2dWeOzztKpCwI=;
        b=Nf0stdVWMXZ4tq8DHjtKMwt212ke/qw89BpE/IhX9RzHvz/Q24uDVRXaYTbIzo5I5E
         mUTNNX0magOKMEVQMZ6xh7bLGqIdgZWvAr9wqrDf8fyipi75Y5rk/5dxCkJDS+GERDpw
         hYmOW1QepqbOxbGAldMuQuHSihngHVJ4TOZZET8xL9jTu6VGVj7Y8vM9oIj/58DLs21X
         kubInw/lBCSg52TV23GFGqVl6sPgA+1QKo3UN5amdgDQFDF8e6DzHDTVVNCneg8zgGmo
         +3DRrY8pnl5nA6YlCUQkoGQNDyD9ON7rP20zYfPhm4vFzJsahLxE7JooZoZm37uc+GiP
         njdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711719120; x=1712323920;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WITlaB1Xwz7zvzD2p6o1GBTT8vCtat2dWeOzztKpCwI=;
        b=F5YbkKOxEpWEzNZIaYc9mX76wMvrLNTAsF5hfUOSYhFtJaIgycc9w5btfmTXn3PJMr
         wmyU1c4UEZX50quvPBUOreF93zNAEiiT/4ULwSr+hGCjUyJ3Npe1rprwMgwSVluac/xq
         QyHsWPzjGXBRAg+6rB1h/LhOr/VhQVgEXSUWizGg5LggARMTJZeHXGH1jBZKyddBQsTG
         /9gJcAxw+5Um7fEv61eZlqNQMHAFgiDd+DpMILr9bpjaMWwhYBnxI/cxLDM/6SbTfvQZ
         hRdXS3BC/XYguWRPX0Eu8mcT62RztVfKvKSsAGex92MW1C3uJBdXnW/j5rcd++1G27RK
         lIAQ==
X-Forwarded-Encrypted: i=1; AJvYcCWey3stwFwqiI4A7dU9d+hYrvazscp97QN3GDUB/ii8Z+APdla9Wwltn0J7dmGQXQ0DZpH65UeLdVtD0OSUI4KZaslwH591TBc=
X-Gm-Message-State: AOJu0YzAM6VRrBkj93tIsDuKb6dd3gE+1mI7ybVGn6tKLfJyCIV1KaXu
	jrB3djEJyVvTRU66S5HYYKrRYAJenBH4JgWGvz8sZ+fvKqSw82zUuCQguWpKYxFsIYprWA9mUAc
	j
X-Google-Smtp-Source: AGHT+IFkwqYMqRK53/gJMw+jRwUee/Km5jZDFsQ42lsB95SE/YKDk2v3BChB03WAUyxXjlD9v7gv0w==
X-Received: by 2002:a17:902:c255:b0:1de:e8ce:9d7a with SMTP id 21-20020a170902c25500b001dee8ce9d7amr2365160plg.5.1711719119605;
        Fri, 29 Mar 2024 06:31:59 -0700 (PDT)
Received: from [192.168.201.244] ([50.234.116.5])
        by smtp.gmail.com with ESMTPSA id c12-20020a170902d48c00b001e0b5d49fc7sm3413770plg.161.2024.03.29.06.31.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Mar 2024 06:31:58 -0700 (PDT)
Message-ID: <8ca5b243-4214-4821-804c-5be72f6836ee@kernel.dk>
Date: Fri, 29 Mar 2024 07:31:58 -0600
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
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <4e8b5815-322e-4511-b529-6db745e8d0e0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/29/24 6:51 AM, Pavel Begunkov wrote:
> On 3/28/24 18:52, Jens Axboe wrote:
>> All our task_work handling is targeted at the state in the io_kiocb
>> itself, which is what it is being used for. However, MSG_RING rolls its
>> own task_work handling, ignoring how that is usually done.
>>
>> In preparation for switching MSG_RING to be able to use the normal
>> task_work handling, add io_req_task_work_add_remote() which allows the
>> caller to pass in the target io_ring_ctx and task.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>   io_uring/io_uring.c | 27 +++++++++++++++++++--------
>>   io_uring/io_uring.h |  2 ++
>>   2 files changed, 21 insertions(+), 8 deletions(-)
>>
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index 9978dbe00027..609ff9ea5930 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -1241,9 +1241,10 @@ void tctx_task_work(struct callback_head *cb)
>>       WARN_ON_ONCE(ret);
>>   }
>>   -static inline void io_req_local_work_add(struct io_kiocb *req, unsigned tw_flags)
>> +static inline void io_req_local_work_add(struct io_kiocb *req,
>> +                     struct io_ring_ctx *ctx,
>> +                     unsigned tw_flags)
>>   {
>> -    struct io_ring_ctx *ctx = req->ctx;
>>       unsigned nr_wait, nr_tw, nr_tw_prev;
>>       unsigned long flags;
>>   @@ -1291,9 +1292,10 @@ static inline void io_req_local_work_add(struct io_kiocb *req, unsigned tw_flags
>>       wake_up_state(ctx->submitter_task, TASK_INTERRUPTIBLE);
>>   }
>>   -static void io_req_normal_work_add(struct io_kiocb *req)
>> +static void io_req_normal_work_add(struct io_kiocb *req,
>> +                   struct task_struct *task)
>>   {
>> -    struct io_uring_task *tctx = req->task->io_uring;
>> +    struct io_uring_task *tctx = task->io_uring;
>>       struct io_ring_ctx *ctx = req->ctx;
>>       unsigned long flags;
>>       bool was_empty;
>> @@ -1319,7 +1321,7 @@ static void io_req_normal_work_add(struct io_kiocb *req)
>>           return;
>>       }
>>   -    if (likely(!task_work_add(req->task, &tctx->task_work, ctx->notify_method)))
>> +    if (likely(!task_work_add(task, &tctx->task_work, ctx->notify_method)))
>>           return;
>>         io_fallback_tw(tctx, false);
>> @@ -1328,9 +1330,18 @@ static void io_req_normal_work_add(struct io_kiocb *req)
>>   void __io_req_task_work_add(struct io_kiocb *req, unsigned flags)
>>   {
>>       if (req->ctx->flags & IORING_SETUP_DEFER_TASKRUN)
>> -        io_req_local_work_add(req, flags);
>> +        io_req_local_work_add(req, req->ctx, flags);
>> +    else
>> +        io_req_normal_work_add(req, req->task);
>> +}
>> +
>> +void io_req_task_work_add_remote(struct io_kiocb *req, struct task_struct *task,
>> +                 struct io_ring_ctx *ctx, unsigned flags)
> 
> Urgh, even the declration screams that there is something wrong
> considering it _either_ targets @ctx or @task.
> 
> Just pass @ctx, so it either use ctx->submitter_task or
> req->task, hmm?

I actually since changed the above to use a common helper, so was
scratching my head a bit over your comment as it can't really work in
that setup without needing to check for whether ->submitter_task is set
or not. But I do agree this would be nicer, so I'll just return to using
the separate helpers for this and it should fall out nicely. The only
odd caller is the MSG_RING side, so makes sense to have it a bit more
separate rather than try and fold it in with the regular side of using
task_work.

> A side note, it's a dangerous game, I told it before. At least
> it would've been nice to abuse lockdep in a form of:
> 
> io_req_task_complete(req, tw, ctx) {
>     lockdep_assert(req->ctx == ctx);
>     ...
> }
> 
> but we don't have @ctx there, maybe we'll add it to tw later.

Agree, but a separate thing imho.

-- 
Jens Axboe


