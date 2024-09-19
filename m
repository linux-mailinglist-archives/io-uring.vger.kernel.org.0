Return-Path: <io-uring+bounces-3232-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 788BF97C7DF
	for <lists+io-uring@lfdr.de>; Thu, 19 Sep 2024 12:22:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB0FE1C23BF7
	for <lists+io-uring@lfdr.de>; Thu, 19 Sep 2024 10:22:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF97B168BD;
	Thu, 19 Sep 2024 10:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mqgpy7Fu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D8633D8
	for <io-uring@vger.kernel.org>; Thu, 19 Sep 2024 10:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726741343; cv=none; b=R9Bmf9pbLDwwrA3HRHe/5yHGdftBwOJmkQIbzub5w2jcI6BYHWKpR9mTZGvc7TaUHeWpKuaVqiyFHje999hImrD52G3dbcUSHiQFYZnHK2RjAyO/HzkRYjUnpQZnEPtyWJwaK/1VXk/caB/l+bCc1PWSuWrtcMJU2ygNhqnkipM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726741343; c=relaxed/simple;
	bh=ae2sK6gbFdzWrLur0NhRU0vkG1HPguYkfuoTNPVOFSU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=C7D99/sxdWl0/dBInA4h38ymkKys/VkpDSJEbUJk8jmPXD84seVw9SZ3RLxkIeYF/vwmriNSA84cjyCRQwoy32w9yHxr/AG+tXfPA8QUnBvEeK3mn4+Gtlwa9A8WSHtz/zDT/HtE6PMSiwaZLWsr6VxQKd/KAiVkEkmvWYcdG/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mqgpy7Fu; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5c42bd0386cso890724a12.2
        for <io-uring@vger.kernel.org>; Thu, 19 Sep 2024 03:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726741340; x=1727346140; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tbLB5tJsjEtMyazIOcNA/W1/4WBDV33MJC/I0dVyEpQ=;
        b=Mqgpy7FuN9Mf+0sBZBgLmBwHLiA6rd6tMPWdN7LzK5Dy00L4SadJFT5WJI3JaJRFYx
         HdP1xDs6vnKf7OfKTEJo1rtl1GpehwJxQ1MGguZvnk6BiybCNNxy+z/PVl9imRwgr2mv
         QtkuW+d/rCbf7agMFCATU9IKcvXM7uGC+ehoP9KA+3qIJ2HFuKusWanLh8tr7HddN2Yt
         ZYUxKAwT6iZFm9dh2e4N803tXWK/2S8zg/55Smb1io/tA4u9Yba5aWsghsrAigRzgpqO
         Fz9poSM6TtdRvkS4K5MPFamwztfE2U0CXSFKbDfNPq421G7JkCA5ZynHbQy66624F+gC
         g+kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726741340; x=1727346140;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tbLB5tJsjEtMyazIOcNA/W1/4WBDV33MJC/I0dVyEpQ=;
        b=xK2NYfjdXZtizFOJebJfcBt9PJzAiZ6pZLzKV8/MnfuqlmVnOE02Ld1r/2Yv2+SJ9Y
         9BoDvkRnlGhHcvVf7Wwpc5JJFNwDwZ0xGY1WUNCyAiRGIzbd/y90k6VNmYIKIWWBgJbD
         /9vp/UKpfdz44Zw9GKqo/gP4rwkqpZ2sJOK1suO1usck1PH9gNpke3eQZ1552F310FPF
         ryz0o0xH23z/e66aqO4Rn5mI2WiIM8gJdEk/zD+ROj7WrOYKehVSU2U1rqxKHxLgmmjo
         YBTPv9OSC24NaLKAi2/2R46U5T3T2NlcV0l0sSFvYYPPlIv8UaaeNrLG5/XOlCL1cQOU
         DmJw==
X-Forwarded-Encrypted: i=1; AJvYcCWp9cPeLPQy+PoB1HajFjoD3GHhslLuWrZgl2TTIENF7aN26rjx9SGSuZXRmSwh6uY21nteAfrqwQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YykXV6s8NfX2AOZWRoXlaYDvsXE0SqKzVfO48f/l4AOpvdFLBw7
	m+6KQcCydDVl4Wnmc1o6OzQvGM9kB/8bRPRpZfB8UumMWiueV6W+wPVBvnvP
X-Google-Smtp-Source: AGHT+IEDXLgBO4w4Q6Pr0kxFRMEcy976iTcrClG1d3EtYKKYDSC2wQ2eqCm/Z931Nv4YCS/ryoraHg==
X-Received: by 2002:a17:906:730d:b0:a7a:a46e:dc3f with SMTP id a640c23a62f3a-a90296eabc9mr2907500766b.45.1726741340158;
        Thu, 19 Sep 2024 03:22:20 -0700 (PDT)
Received: from [192.168.42.125] ([62.218.223.254])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a906133049csm698645266b.205.2024.09.19.03.22.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Sep 2024 03:22:19 -0700 (PDT)
Message-ID: <6e445fe1-9a75-4e50-aa70-514937064e64@gmail.com>
Date: Thu, 19 Sep 2024 11:22:57 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: run normal task_work AFTER local work
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <8e3894e3-2609-4233-83df-1633fba7d4dd@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <8e3894e3-2609-4233-83df-1633fba7d4dd@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/18/24 19:03, Jens Axboe wrote:
> io_cqring_wait() doesn't run normal task_work after the local work, and
> it's the only location to do it in that order. Normally this doesn't
> matter, except if:
> 
> 1) The ring is setup with DEFER_TASKRUN
> 2) The local work item may generate normal task_work
> 
> For condition 2, this can happen when closing a file and it's the final
> put of that file, for example. This can cause stalls where a task is
> waiting to make progress, but there's nothing else that will wake it up.

TIF_NOTIFY_SIGNAL from normal task_work should prevent the task
from sleeping until it processes task works, that should make
the waiting loop make another iteration and get to the task work
execution again (if it continues to sleep). I don't understand how
the patch works, but if it's legit sounds we have a bigger problem,
e.g. what if someone else queue up a work right after that tw
execution block.

> Link: https://github.com/axboe/liburing/issues/1235
> Cc: stable@vger.kernel.org
> Fixes: 846072f16eed ("io_uring: mimimise io_cqring_wait_schedule")
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> ---
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 1aca501efaf6..d6a2cd351525 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -2568,9 +2568,9 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
>   		 * If we got woken because of task_work being processed, run it
>   		 * now rather than let the caller do another wait loop.
>   		 */
> -		io_run_task_work();
>   		if (!llist_empty(&ctx->work_llist))
>   			io_run_local_work(ctx, nr_wait);
> +		io_run_task_work();
>   
>   		/*
>   		 * Non-local task_work will be run on exit to userspace, but

-- 
Pavel Begunkov

