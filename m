Return-Path: <io-uring+bounces-49-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C06EC7E4791
	for <lists+io-uring@lfdr.de>; Tue,  7 Nov 2023 18:48:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7938B280DD9
	for <lists+io-uring@lfdr.de>; Tue,  7 Nov 2023 17:48:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A272A347D2;
	Tue,  7 Nov 2023 17:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c4QM0RT0"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DFE321B3
	for <io-uring@vger.kernel.org>; Tue,  7 Nov 2023 17:48:52 +0000 (UTC)
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6627910E7
	for <io-uring@vger.kernel.org>; Tue,  7 Nov 2023 09:48:51 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-53d9f001b35so10064058a12.2
        for <io-uring@vger.kernel.org>; Tue, 07 Nov 2023 09:48:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699379330; x=1699984130; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:subject:from:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eofP2v7PaIaBFcVRDhXIhga4VI0/5JTxXK9IxAmCH5Y=;
        b=c4QM0RT0FGaxCyHpbNmmLUJN+G7+RayZ6vRLlUbAUiDdaf1dSXpqCV0ysDHbwTHAcz
         p199I3tMoBVKZW0g2nl7wJszHM77XG/DSMJSS1cqHVOPmecBRfmjxNlLJzAgTP9GUR6C
         ODAOPuTIr5kwSPPjcEOFnxKAL6sXmiHrPb+96oe8+L1mTMKSYevUg5cj/+WnUDeAKeJN
         bKv1xPTHMNJwd4wroXUsGvSQjBbrG//13IAaJjOfByQHuapJGnraFrX6IhcCRQ7KRxQU
         p4ZjaQl1naISS08bCPlxCgi1CoUy83564EAkqLaPKVjKEj0x+WYgBn0sQEBsZ7/7nAo3
         1gpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699379330; x=1699984130;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eofP2v7PaIaBFcVRDhXIhga4VI0/5JTxXK9IxAmCH5Y=;
        b=FEib5Xr4tNyZ5Ep4zxt6KjQi85UqpsfXfKsPQzL6gvuOLyIk7YkHdyohVUTvotVOyV
         JShEpLhI3srmoBx4gstq3UYsUhzNWBj4hh7enVcfhXwQfjIpMbnIJorqsNDE67s2pZir
         DSML8K7RT3deM9FQGAWj4pHtdc8XnCp2s7P4FASNsSljWEx7gdUQTtu9O7VxMyG5cn4p
         F+o4ypRJjC/AVCmkhlRVtIDtTxQ2w7vuGKHj/Vqf5CjEjkbPBB8pR59dtsrxWVK/M7/j
         UHT/SLqPwi0uR6kbQsVedXDhe0L77md40XkTY9qTtf8SABuVk1t9nlfJdyLSMvbq0rki
         N2mA==
X-Gm-Message-State: AOJu0YxG0OswImrpSKXoAlPMExUYv/iVLIwWLjjKhEguHbxQtKSvec2n
	oOsN1Acu47zzuWbpnfIIC+hfnxs1ioI=
X-Google-Smtp-Source: AGHT+IH0JRP2XicLmCUGokY+xhodepVNuGFbGFkg3BgaWXNFdn5Ibn5ANtgUJU3CLe/BNH8Nkd4jZw==
X-Received: by 2002:a17:907:c24:b0:9bf:20e0:bfe9 with SMTP id ga36-20020a1709070c2400b009bf20e0bfe9mr20359380ejc.15.1699379329550;
        Tue, 07 Nov 2023 09:48:49 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:310::22ef? ([2620:10d:c092:600::2:3009])
        by smtp.gmail.com with ESMTPSA id i22-20020a17090671d600b009929d998abcsm1275559ejk.209.2023.11.07.09.48.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Nov 2023 09:48:49 -0800 (PST)
Message-ID: <55fe5c04-f3c2-5d39-0ff3-e086bf4a13cc@gmail.com>
Date: Tue, 7 Nov 2023 17:47:40 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH] io_uring/poll: use IOU_F_TWQ_LAZY_WAKE for wakeups
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <e6bcdcb4-8a3d-48a1-8301-623cd30430e6@kernel.dk>
Content-Language: en-US
In-Reply-To: <e6bcdcb4-8a3d-48a1-8301-623cd30430e6@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/19/23 14:01, Jens Axboe wrote:
> With poll triggered retries, each event trigger will cause a task_work
> item to be added for processing. If the ring is setup with
> IORING_SETUP_DEFER_TASKRUN and a task is waiting on multiple events to
> complete, any task_work addition will wake the task for processing these
> items. This can cause more context switches than we would like, if the
> application is deliberately waiting on multiple items to increase
> efficiency.

I'm a bit late here. The reason why I didn't enable it for polling is
because it changes the behaviour. Let's think of a situation where we
want to accept 2 sockets, so we send a multishot accept and do
cq_wait(nr=2). It was perfectly fine before, but now it'll hung as
there's only 1 request and so 1 tw queued. And same would happen with
multishot recv even though it's more relevant to packet based protocols
like UDP.

It might be not specific to multishots:
listen(backlog=1), queue N oneshot accepts and cq_wait(N).

Now we get the first connection in the queue to accept.

	[IORING_OP_ACCEPT] = {
		.poll_exclusive		= 1,
	}

Due to poll_exclusive (I assume) it wakes only one accept. That
will try to queue up a tw for it, but it'll not be executed
because it's just one item. No other connection can be queued
up because of the backlog limit => presumably no other request
will be woken up => that first tw never runs. It's more subtle
and timing specific than the previous example, but nevertheless
it's concerning we might step on sth like that.


> For example, if an application has receive multishot armed for sockets
> and wants to wait for N to complete within M usec of time, we should not
> be waking up and processing these items until we have all the events we
> asked for. By switching the poll trigger to lazy wake, we'll process
> them when they are all ready, in one swoop, rather than wake multiple
> times only to process one and then go back to sleep.
> 
> At some point we probably want to look at just making the lazy wake
> the default, but for now, let's just selectively enable it where it
> makes sense.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> ---
> 
> diff --git a/io_uring/poll.c b/io_uring/poll.c
> index 4c360ba8793a..d38d05edb4fa 100644
> --- a/io_uring/poll.c
> +++ b/io_uring/poll.c
> @@ -370,7 +370,7 @@ static void __io_poll_execute(struct io_kiocb *req, int mask)
>   	req->io_task_work.func = io_poll_task_func;
>   
>   	trace_io_uring_task_add(req, mask);
> -	io_req_task_work_add(req);
> +	__io_req_task_work_add(req, IOU_F_TWQ_LAZY_WAKE);
>   }
>   
>   static inline void io_poll_execute(struct io_kiocb *req, int res)
> 

-- 
Pavel Begunkov

