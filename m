Return-Path: <io-uring+bounces-2847-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EAEA4958FC1
	for <lists+io-uring@lfdr.de>; Tue, 20 Aug 2024 23:34:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 293491C21C5F
	for <lists+io-uring@lfdr.de>; Tue, 20 Aug 2024 21:34:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F65718DF87;
	Tue, 20 Aug 2024 21:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="HDLMrEWM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE0B45008
	for <io-uring@vger.kernel.org>; Tue, 20 Aug 2024 21:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724189660; cv=none; b=JOmEBPSIHuv4ir+k9lXMGr4HHLLAunG8GQtw50Ebq/iXvnxz2JgiBlilpgvf/EThp+3SBVj3++qigKo9ZaUk5NxycscYrlmNExjOed5VZnI1fDin5BE3zS0vbMC80l0i9DIQUvaWfLy1CcJpc3gcGGpbKQiWPjy04LuduenoEzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724189660; c=relaxed/simple;
	bh=Sm5aUNvtrjLjd8elibSOrzFL+byq4Y4ClMpdzmRcAOA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Sk/iz+cB8Q1vQpCHM7ubdYXYyy7Eq7v9Qu2h3UdHUmdDaK5cckrsuJsEEJcB7sslIra1ImLx2NyTm/mgeg3vjO1VKtapJWUMgNY1XEgD4by3wvnso35S8Fi3ZayNmm/P9kQBqpxxwCY/zVjSIFz1uIUj9wExtiX7tFQsatRsLu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=HDLMrEWM; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-71423273c62so144982b3a.0
        for <io-uring@vger.kernel.org>; Tue, 20 Aug 2024 14:34:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724189657; x=1724794457; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yGkf69ZFupWydDWDllCh44WRC6k5E/eUgq1c7IGLuCc=;
        b=HDLMrEWMI9xvONi3DT1SjkaU2HHNq6EObYZFianlM+/iJjjZIzQII3csFN+I/5ntd0
         X1wClDDVb5zhHEV4aw6J8UTBaSm2CR0IB/8a6l/dbPygNIaBYwP2AFPm4XsCLGvl4/vO
         fw6fOvk/7kTlBILZcNC0JCbKWYRGbDEJFq29jlBemw6Ae7o859IX/qnLAO7IIf+Q3YNQ
         K+SA5Zyjnyk0aFf6KzoOq6qfoPJSTsHtuoOMX1fb195S8FONBJZ2HlIEr45XeWrn7UlK
         Xq0RCYLEs03jolagbttbpFTgGNzsG1kf3VvBYTyPb3znH32m3vNcdVZoSrXJJYT6Pbe1
         55zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724189657; x=1724794457;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yGkf69ZFupWydDWDllCh44WRC6k5E/eUgq1c7IGLuCc=;
        b=AYciQl7+VqmGmuh2Dby+Wy5CFab1h8jqkHEpkrGsE+kaCcPIe9ROhPUUjVPF9I1rE1
         86rRlp9LfqOO+tpRCDpBSUGQmiwz1uAhynQBCmCGjP7mZIW3TzdPKtCWQargcaAUA7BR
         9ruUJiFyWFtkWT5+tHHeJSGxLTElu2DV6RSXXs/4hp/QsS/sIQ+AUWqdKPZULhZzQqto
         WT4Pr1S1dvVY5Tm7UTqCz/0f+EQceCNf1HTOsgQjtTSqsUwNsF+5FQAQmSvIjntaMOiC
         Tk2GMWqvAJKAWUzX0+sGyLsUZ8jiWjrHWSkI1sA4DExkhxqOQREy2qf6TpMsCNc4FD2E
         ZTFg==
X-Forwarded-Encrypted: i=1; AJvYcCU5Wiuy6fLsy2TOK+XrodbMfSuJmGPXEzT/kfn4EL2pMkEA+fA4vCvY+mNRidYIMA/mlbK8c4jE1A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7XQzC173sSQH+i7vfAnItqBjD7ixsA7Li/WEuGRH4ptGnEaJm
	KNxDYNGee9wXNdffEWgAvg5dUTlz5imWI9O8vTtNoJzVedIjpx+pr51YxSpU9+k=
X-Google-Smtp-Source: AGHT+IFAACODqZxcQ8f5ZuMwF8FWsea/wMQeQxpSX1PV0U3ez1Mexh1t6uclKLOriAr8KqcAztv8Zg==
X-Received: by 2002:a05:6a00:9289:b0:70d:311b:8569 with SMTP id d2e1a72fcca58-7142356a5c9mr492465b3a.26.1724189657220;
        Tue, 20 Aug 2024 14:34:17 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7127add7cbcsm8955204b3a.14.2024.08.20.14.34.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Aug 2024 14:34:16 -0700 (PDT)
Message-ID: <cb79d5dd-3ff2-4cc3-ae0e-24c03d2729b3@kernel.dk>
Date: Tue, 20 Aug 2024 15:34:15 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] io_uring: implement our own schedule timeout handling
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org
References: <20240819233042.230956-1-axboe@kernel.dk>
 <20240819233042.230956-4-axboe@kernel.dk>
 <58a42e82-3742-4439-998e-c9389c5849bc@davidwei.uk>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <58a42e82-3742-4439-998e-c9389c5849bc@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/20/24 2:08 PM, David Wei wrote:
> On 2024-08-19 16:28, Jens Axboe wrote:
>> In preparation for having two distinct timeouts and avoid waking the
>> task if we don't need to.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  io_uring/io_uring.c | 41 ++++++++++++++++++++++++++++++++++++-----
>>  io_uring/io_uring.h |  2 ++
>>  2 files changed, 38 insertions(+), 5 deletions(-)
>>
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index 9e2b8d4c05db..ddfbe04c61ed 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -2322,7 +2322,7 @@ static int io_wake_function(struct wait_queue_entry *curr, unsigned int mode,
>>  	 * Cannot safely flush overflowed CQEs from here, ensure we wake up
>>  	 * the task, and the next invocation will do it.
>>  	 */
>> -	if (io_should_wake(iowq) || io_has_work(iowq->ctx))
>> +	if (io_should_wake(iowq) || io_has_work(iowq->ctx) || iowq->hit_timeout)
> 
> iowq->hit_timeout may be modified in a timer softirq context, while this
> wait_queue_func_t (AIUI) may get called from any context e.g.
> net_rx_softirq for sockets. Does this need a READ_ONLY()?

Yes probably not a bad idea to make it READ_ONCE().

>>  		return autoremove_wake_function(curr, mode, wake_flags, key);
>>  	return -1;
>>  }
>> @@ -2350,6 +2350,38 @@ static bool current_pending_io(void)
>>  	return percpu_counter_read_positive(&tctx->inflight);
>>  }
>>  
>> +static enum hrtimer_restart io_cqring_timer_wakeup(struct hrtimer *timer)
>> +{
>> +	struct io_wait_queue *iowq = container_of(timer, struct io_wait_queue, t);
>> +	struct io_ring_ctx *ctx = iowq->ctx;
>> +
>> +	WRITE_ONCE(iowq->hit_timeout, 1);
>> +	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
>> +		wake_up_process(ctx->submitter_task);
>> +	else
>> +		io_cqring_wake(ctx);
> 
> This is a bit different to schedule_hrtimeout_range_clock(). Why is
> io_cqring_wake() needed here for non-DEFER_TASKRUN?

That's how the wakeups work - for defer taskrun, the task isn't on a
waitqueue at all. Hence we need to wake the task itself. For any other
setup, they will be on the waitqueue, and we just call io_cqring_wake()
to wake up anyone waiting on the waitqueue. That will iterate the wake
queue and call handlers for each item. Having a separate handler for
that will allow to NOT wake up the task if we don't need to.
taskrun, the waker

-- 
Jens Axboe


