Return-Path: <io-uring+bounces-2862-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AA4719590B6
	for <lists+io-uring@lfdr.de>; Wed, 21 Aug 2024 00:54:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3A0DA1F220C4
	for <lists+io-uring@lfdr.de>; Tue, 20 Aug 2024 22:54:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D77D1C7B6B;
	Tue, 20 Aug 2024 22:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="S3Tl7ZHR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83DFF1C7B87
	for <io-uring@vger.kernel.org>; Tue, 20 Aug 2024 22:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724194482; cv=none; b=i97FM/UkIRIUYWPrzwzKuh+B5RhV24xcWLtry0cTZ4mVIcxgp6P33YB+51lLHiCyunqHd6h4saJCrumWD6lyCP2vpynoWupKhj5VAmI/7VxtaM17GBxlArrpax9IBS96RRzmD+E6KddYzlgE/fNATZJqkXO6YS9BBwBwhM7Hs4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724194482; c=relaxed/simple;
	bh=WRKqmGdZprR9vYTmGpBHtEgMU8PtxUkgY146WB1fgEI=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=ZGDoiCSDK+/oVdlEZfcVSDezXHLWggHUTbVLKTYi5z+S4vq/a9M9ZNoNyYHvDmv8W8293nG6Ua0pN/zwnoeBT0xDYwV4GelPVaWtUc+eP5TJhxGD58fyCd9lqHbkaDVLuIDoYH1T42xRA1KeKgMB4OhGrTcqpeWOqJZFUXrsgxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=S3Tl7ZHR; arc=none smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-27020fca39aso3519614fac.0
        for <io-uring@vger.kernel.org>; Tue, 20 Aug 2024 15:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724194478; x=1724799278; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OOhZCVL23k9GTEJSUM/ljxJRN7yxg5edcYYlHEZdqpw=;
        b=S3Tl7ZHRi0nZTzU3Y1+UuRCshmlrYTuyObak6UtrIZEzP1z0/78c+zxhuNrnjX7VaT
         0I+3eWigcBQXr1OsNa7BQa4KksjhFBwWPtVNbP4MpYioNLobCdB137DpMIBYJwGgFua2
         xw/et0GpACZ3fJQ0ExWMMnvvSVxzhy6Txzyz8G/PPzLHhaBEGREHpCp5AEDxHS768F9C
         /i1OB4FZhMFijw7tbwvSYQRcXmmQn7kj8lBOo5I/KrnB+CAIBalldKds39lmDqmmrocl
         cZoIM6FxIVoemJIHRJpRrQ+PCH0H0bSL38/UgD9y4wLc+80yk12pRZYxN0g3Q0hYtR+h
         Qh2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724194478; x=1724799278;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OOhZCVL23k9GTEJSUM/ljxJRN7yxg5edcYYlHEZdqpw=;
        b=Lm0zH6HUD8SnCnJ8DP692zIfWH/+17SoQUXcm9ama5vebm/FErrmW/uU35Z4uTVGow
         99f9essv2VqWOP6qPVieHms3Pe0I/ehOiEAd+5QXqloLR12jS3T0mzkJNtuegN+GCALp
         HPGiDdaZnH3RftxMPXYCSD9Ish+hvpUPLMShZmOrgVFlP4tlNcw7ePRcylL9uN2FEZMy
         za7jyr5vdmy0u0e6nrzFrGwBJePJ2/33Ug+BustRoThhHZguw7dzr4YxABbSpJpI/tfZ
         wvTXTstITPidUcfduVdnkiLJzDi19qIigQWQmeqYK9RDoDEBTuyNiVnH4x/EVa3g2+hf
         Eplw==
X-Forwarded-Encrypted: i=1; AJvYcCWc5aj5HgmsRrlA1yLDb99pDqp0w2yxQpKZMHnSDPHd1gVDFKbZHfuCdZ6/lF6hhVMX5lTaTf/X0Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw815t6YazKe2UqjdsV8GdQ37dc3vjv9KJHgULW7uf4t2qLRlzY
	czXC+hk2PckLEP5jKAljp6AajAGOVyLCnj31HjjbJdtYGBxfg7n2YS91ivsWeRA=
X-Google-Smtp-Source: AGHT+IGTnG0ws2AhUPY1JE6EBaOkVaQJu5T8vAP5Kk1T9BEXKYY8bjCVROeylee4C42tg5/27aoBbA==
X-Received: by 2002:a05:6871:328e:b0:254:b337:eebc with SMTP id 586e51a60fabf-2738be2cddemr398481fac.35.1724194478314;
        Tue, 20 Aug 2024 15:54:38 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7cd8ac66138sm1106a12.37.2024.08.20.15.54.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Aug 2024 15:54:37 -0700 (PDT)
Message-ID: <0ad17d2e-b8b5-4f70-93b5-921bf4229e24@kernel.dk>
Date: Tue, 20 Aug 2024 16:54:36 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] io_uring: implement our own schedule timeout handling
From: Jens Axboe <axboe@kernel.dk>
To: David Wei <dw@davidwei.uk>, Pavel Begunkov <asml.silence@gmail.com>,
 io-uring@vger.kernel.org
References: <20240819233042.230956-1-axboe@kernel.dk>
 <20240819233042.230956-4-axboe@kernel.dk>
 <58a42e82-3742-4439-998e-c9389c5849bc@davidwei.uk>
 <cb79d5dd-3ff2-4cc3-ae0e-24c03d2729b3@kernel.dk>
 <d1116971-a2f7-430d-97d8-03440befd38a@davidwei.uk>
 <a3285bfe-ddcb-4521-940c-2e59f774ec70@kernel.dk>
 <48359591-314d-42b0-8332-58f9f6041330@davidwei.uk>
 <4b0ed07b-1cb0-4564-9d13-44a7e6680190@gmail.com>
 <344d1781-0004-4623-9eb4-2c2f479267f4@davidwei.uk>
 <53474dc7-f4ee-4f21-a556-789c23df526e@kernel.dk>
 <f3561ab8-281e-42e1-b146-197b731c90c1@kernel.dk>
Content-Language: en-US
In-Reply-To: <f3561ab8-281e-42e1-b146-197b731c90c1@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/20/24 4:51 PM, Jens Axboe wrote:
> On 8/20/24 4:19 PM, Jens Axboe wrote:
>> On 8/20/24 4:14 PM, David Wei wrote:
>>> On 2024-08-20 15:13, Pavel Begunkov wrote:
>>>>>>>> On 8/20/24 2:08 PM, David Wei wrote:
>>>>>>> To rephase the question, why is the original code calling
>>>>>>> schedule_hrtimeout_range_clock() not needing to differentiate behaviour
>>>>>>> between defer taskrun and not?
>>>>>>
>>>>>> Because that part is the same, the task schedules out and goes to sleep.
>>>>>> That has always been the same regardless of how the ring is setup. Only
>>>>>> difference is that DEFER_TASKRUN doesn't add itself to ctx->wait, and
>>>>>> hence cannot be woken by a wake_up(ctx->wait). We have to wake the task
>>>>>> manually.
>>>>>>
>>>>>
>>>>> io_cqring_timer_wakeup() is the timer expired callback which calls
>>>>> wake_up_process() or io_cqring_wake() depending on DEFER_TASKRUN.
>>>>>
>>>>> The original code calling schedule_hrtimeout_range_clock() uses
>>>>> hrtimer_sleeper instead, which has a default timer expired callback set
>>>>> to hrtimer_wakeup().
>>>>>
>>>>> hrtimer_wakeup() only calls wake_up_process().
>>>>>
>>>>> My question is: why this asymmetry? Why does the new custom callback
>>>>> require io_cqring_wake()?
>>>>
>>>> That's what I'm saying, it doesn't need and doesn't really want it.
>>>> From the correctness point of view, it's ok since we wake up a
>>>> (unnecessarily) larger set of tasks.
>>>>
>>>
>>> Yeah your explanation that came in while I was writing the email
>>> answered it, thanks Pavel.
>>
>> Hah and now I see what you meant - yeah we can just remove the
>> distinction. I didn't see anything in testing, but I also didn't have
>> multiple tasks waiting on a ring, nor would you. So it doesn't really
>> matter, but I'll clean it up so there's no confusion.
> 
> Actually probably better to just leave it as-is, as we'd otherwise need
> to store a task in io_wait_queue. Which we of course could, and would
> remove a branch in there...

I guess I should actually look at the code first, we have it via
wq->private already. Hence:


diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ddfbe04c61ed..4ba5292137c3 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2353,13 +2353,9 @@ static bool current_pending_io(void)
 static enum hrtimer_restart io_cqring_timer_wakeup(struct hrtimer *timer)
 {
 	struct io_wait_queue *iowq = container_of(timer, struct io_wait_queue, t);
-	struct io_ring_ctx *ctx = iowq->ctx;
 
 	WRITE_ONCE(iowq->hit_timeout, 1);
-	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
-		wake_up_process(ctx->submitter_task);
-	else
-		io_cqring_wake(ctx);
+	wake_up_process(iowq->wq.private);
 	return HRTIMER_NORESTART;
 }
 

-- 
Jens Axboe


