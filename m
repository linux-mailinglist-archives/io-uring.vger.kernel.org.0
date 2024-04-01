Return-Path: <io-uring+bounces-1356-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D1AA089449C
	for <lists+io-uring@lfdr.de>; Mon,  1 Apr 2024 20:02:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 426691F22577
	for <lists+io-uring@lfdr.de>; Mon,  1 Apr 2024 18:02:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34BF74AEE4;
	Mon,  1 Apr 2024 18:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="H6kpvQTc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1CB5481C6
	for <io-uring@vger.kernel.org>; Mon,  1 Apr 2024 18:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711994556; cv=none; b=e+mYq9/yVQ61pr/cBKLoYXMztpTpNmd7bE/VWh1O3Vds+CqsKCpWrbDTQYqEpJ7dbZF5jWXKOJQeRzgpR9IcJCRnmLzh2RyzluX/JNzcHrk5dw/2s+CNuXy7+aXQm9346+TP82dMIDmTfg0boVfu2D6dxwQP4m1k9J+ciSZl3xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711994556; c=relaxed/simple;
	bh=ZNJAyt8ov4D6VFYZZkbL4/hk73o/fsDejDexjLynSK0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=dw5jD9eI10tzas4YkGj+zBRCBctyQTLdBjEaMjXlNYkJHyTa/cvAYmnrhjVyS1XuTmt34lPpTpty87H4e9i/uWUUZ5+D9chBuozTB4+BsLqmR3NV0GCh4wST4IcaTmiK7drDLxoavC81uYP+yhqxlnrn5o3zZ6GPNLZTr08lN5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=H6kpvQTc; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3685acaa878so6190155ab.1
        for <io-uring@vger.kernel.org>; Mon, 01 Apr 2024 11:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711994554; x=1712599354; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ApPWGtsaEeAYY2L8UwrYWHKtTd0pb1XKUV9dPZTAzJE=;
        b=H6kpvQTc18gtrrZ1nMWSlM2IGFVXwd3tFkDRD9UCZfBfPBdBsu0LZ04O2ZYQ8z1otc
         5lpATXPbBZsrtdYqop1Zl5AXtXSO3t9qQbR2+kmttJszlkoQ//3+4mWgxZFYFAhaA6JG
         dOw7szsU2nx8q2pieY4FvlSudvHe/USnjBAgVvJnL9YjYRiQQent65LsFLD+33Ytci/Y
         GM28V52UM/aCMagN81C7u11cDcm577dWz58fcoAzxUF+jC1pM821ejO27yZdYCPAXY34
         npgoAzdzWykx8pLoyoD7+e2IFnk8hfo62YvKsdO+X7hZf9lsGcUIt4A0n7Ps0AfjyNNj
         1Qcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711994554; x=1712599354;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ApPWGtsaEeAYY2L8UwrYWHKtTd0pb1XKUV9dPZTAzJE=;
        b=DhQKyLQvCUWodYRed+IXoMlQNb8DNtmoIupGYF/VSocVJ6+koUETcbyGPyGKFGu28i
         sbxRmC0HYh25SoQL1STRLXQ90D8spfNYdM5e58OooOHL+t80cO8a8WhgjXz1qtOYwROe
         59IEajyxCET1aEf2YdwKF0qYWR4Q+IB8Ft0/Wggsu31MitPx6g/MW41jxmskNnWMF48A
         yLoK5G+ux8gmh/AS4Vwo0ZaLNWdF3mwMwo291Z3ukd+8HBK3kWphfZgAJdN9d+UXqxsB
         dlYfR2DUOOvmpmXkZG+O6SZa0Ruhc4xLUNxbQ0XAJ/MqflFGr4oUUpPobibb+IvNkIXa
         tUOg==
X-Forwarded-Encrypted: i=1; AJvYcCXySn3nHGvi0GSLZykz92c3BR9uZIucWGmn4y3ci6Pa5rEEptX+ubjGsI7sl61UCsd2H4CWj9HMysGA6kTqAgDFq2r4PkUOE0M=
X-Gm-Message-State: AOJu0YyJMeA52rEl+zkZ2i7vypplUPpp9xkrXHuyakJsqL2KOR2adSOj
	thr8wJid1dD/jCsvgpt5wGbZIhDoc6ectrayYhQh+KiluNWCYTuqVJUkWaseA3e3xxkaw1dhelh
	5
X-Google-Smtp-Source: AGHT+IH6YeegrNZxgtby0aaiZNrF1m0oZcawqwk8uR32A4Q66AQ6X+HCMs2V+g8mvRJWU52TvFnVTg==
X-Received: by 2002:a05:6e02:108:b0:366:b0bd:3a1a with SMTP id t8-20020a056e02010800b00366b0bd3a1amr10320718ilm.1.1711994553857;
        Mon, 01 Apr 2024 11:02:33 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id b2-20020a92c842000000b003698dbf5d96sm1783564ilq.64.2024.04.01.11.02.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Apr 2024 11:02:33 -0700 (PDT)
Message-ID: <18528ba8-4739-450b-b820-7d41c0e1e50b@kernel.dk>
Date: Mon, 1 Apr 2024 12:02:26 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] io_uring: add remote task_work execution helper
Content-Language: en-US
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org
References: <20240329201241.874888-1-axboe@kernel.dk>
 <20240329201241.874888-2-axboe@kernel.dk>
 <4787f55e-b9c3-46d6-a183-53ba2fd21445@davidwei.uk>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <4787f55e-b9c3-46d6-a183-53ba2fd21445@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/1/24 11:30 AM, David Wei wrote:
> On 2024-03-29 13:09, Jens Axboe wrote:
>> All our task_work handling is targeted at the state in the io_kiocb
>> itself, which is what it is being used for. However, MSG_RING rolls its
>> own task_work handling, ignoring how that is usually done.
>>
>> In preparation for switching MSG_RING to be able to use the normal
>> task_work handling, add io_req_task_work_add_remote() which allows the
>> caller to pass in the target io_ring_ctx.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  io_uring/io_uring.c | 30 ++++++++++++++++++++++--------
>>  io_uring/io_uring.h |  2 ++
>>  2 files changed, 24 insertions(+), 8 deletions(-)
>>
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index fddaefb9cbff..a311a244914b 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -1232,9 +1232,10 @@ void tctx_task_work(struct callback_head *cb)
>>  	WARN_ON_ONCE(ret);
>>  }
>>  
>> -static inline void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
>> +static inline void io_req_local_work_add(struct io_kiocb *req,
>> +					 struct io_ring_ctx *ctx,
>> +					 unsigned flags)
>>  {
>> -	struct io_ring_ctx *ctx = req->ctx;
>>  	unsigned nr_wait, nr_tw, nr_tw_prev;
>>  	struct llist_node *head;
>>  
>> @@ -1300,9 +1301,10 @@ static inline void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
>>  	wake_up_state(ctx->submitter_task, TASK_INTERRUPTIBLE);
>>  }
>>  
>> -static void io_req_normal_work_add(struct io_kiocb *req)
>> +static void io_req_normal_work_add(struct io_kiocb *req,
>> +				   struct task_struct *task)
>>  {
>> -	struct io_uring_task *tctx = req->task->io_uring;
>> +	struct io_uring_task *tctx = task->io_uring;
>>  	struct io_ring_ctx *ctx = req->ctx;
>>  
>>  	/* task_work already pending, we're done */
>> @@ -1321,7 +1323,7 @@ static void io_req_normal_work_add(struct io_kiocb *req)
>>  		return;
>>  	}
>>  
>> -	if (likely(!task_work_add(req->task, &tctx->task_work, ctx->notify_method)))
>> +	if (likely(!task_work_add(task, &tctx->task_work, ctx->notify_method)))
>>  		return;
>>  
>>  	io_fallback_tw(tctx, false);
>> @@ -1331,10 +1333,22 @@ void __io_req_task_work_add(struct io_kiocb *req, unsigned flags)
>>  {
>>  	if (req->ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
>>  		rcu_read_lock();
>> -		io_req_local_work_add(req, flags);
>> +		io_req_local_work_add(req, req->ctx, flags);
>> +		rcu_read_unlock();
>> +	} else {
>> +		io_req_normal_work_add(req, req->task);
> 
> Why does this not require a READ_ONCE() like
> io_req_task_work_add_remote()?

One is the req->task side, which is serialized as it's setup at install
time. For the ctx submitter_task, in _theory_ that isn't, hence
read/write once must be used for those. In practice, I don't think the
latter solves anything outside of perhaps KCSAN complaining.

-- 
Jens Axboe


