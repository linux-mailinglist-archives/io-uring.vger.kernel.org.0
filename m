Return-Path: <io-uring+bounces-4905-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B1FBB9D44B7
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 00:55:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 827B32839FE
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 23:55:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A82C71AAE00;
	Wed, 20 Nov 2024 23:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IoQY4p2P"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5F91E4A4
	for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 23:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732146925; cv=none; b=iZATyh1XCRJIH5azGeISMgmjfS2WrDw/fMhg4q4J2opZSx4jhFk4kOhX8s2blQf61pLGmmqIvtz2NswrKAjtdNw1FpiJS/BivPaYQQhxe8IR18zF9iAhNhoT3YCHjcEdNu916UKoeHao9WfCoa+aRW3y692Nyb1yyTRjt7UwN6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732146925; c=relaxed/simple;
	bh=qMUfpzLKbD0lpeV0LTX52pYgbNhOruWpD2bWWbGnsBM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QwR3/9MP87SDvBN00MTYbjna9dFMCzK43gsBBlXv0Vs4coofIMh/2+k4Ph3C2k45Eb3dP8O9jL2jPf91iAyaD2CSnbWXOj7Y80wi5i8cdOyTcxtgzwmqtyI5efwFAGy0hbQtA4kNtxpMjaNtcDp3BhST18pAE/rg7HJx/NAyhGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IoQY4p2P; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3823e45339bso228999f8f.0
        for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 15:55:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732146922; x=1732751722; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=09Y4QrrOXymtblpB1pYqw9jG7c1ClUXjln1tOpLQ5z4=;
        b=IoQY4p2PB1at0rm5JLtz5CquoWO9sAt8Xc6KsKsj1G1aFzejj2XClG4VqW9Fj9KH2D
         V4AtO1PIC8qAptHsq+YLS3U3eZXmFbeOqlUy+TzPyOJAcN3odGZlo20YsnP398s2W63S
         z6GUf8uT9EAZm8ENH/Mh5AckC+JMS9qN3XMTRmPoOKBIM2FlhLkNDz3j51dMQEv56yh1
         Hdi4o78YZ4B9rP1bEy1jYGoA3fTmzmRxet5iKsY4GbBl1h7d8ke6MymFmscSEtZJwoMH
         njctaL80odpQpMN4WNgfZB3/cQOAoFroxogOvrjtTb0X+sE06hQ9o8Sb5cwhgwdS4Rqf
         xxmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732146922; x=1732751722;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=09Y4QrrOXymtblpB1pYqw9jG7c1ClUXjln1tOpLQ5z4=;
        b=U6BMhzHBPkUlv5Ij4DwG3RV9jzkk4Hp6+PdbM+5ojxSrkU65rtzlq7ynAah2MM4Jhl
         jsw9hWF6dWCNKh91Y+4xWKUNLscS7NKTSCRVfX4zNEv7Bp4rw/oNPFX5W0MGLBsuxZms
         S70hM+OExn65AP1qvv3MrUzCz3pdbjXe02+SMcvsJv/vbsWms0tQK2iPbCQ/eFAtMGVp
         dy74bXRZOqlUCEqGoLD6/ZEbXfOz9c+mrhfzAHhP4R0EsHXtX5QY2/CwF/EWLeVf6VUo
         eVhx9AS/xPQSem1wxAhs7gI6Tl0DFrcmjlfRXMkMKT/QI8t2NHXVbMl+ERwX0FfGPwz1
         6x8w==
X-Forwarded-Encrypted: i=1; AJvYcCUPlTLM/OEv9scILrevUsO0MFk3mz/GoKPKGNCh/P5OSHs6szF2POQT1QpY2OEWQcMBxqDF0LeZ6w==@vger.kernel.org
X-Gm-Message-State: AOJu0YyKLQpsQE5YAVRjRlgMejktn16xKvOTo+ifQIRQUIEprJMJzIuv
	uzP6tRA+KNoUklzHg+D/l6E9vLHpbeL2HiUBGGd2eYIYIlsG1wI3
X-Gm-Gg: ASbGncsdOUbNvgcfESWeeTEe/k1he1zfV21hdXkQttbLRE31d/fIp72i4VcJ2ED1EnT
	992E2ci90KQLIMD6vZPbC/KlT2OJ622YGGfVzITyLW07T1/4jNgOgoyJZq5nOLgN5mag+nIE4Qf
	DO122fBZQpUZWP/4s30LKRag3OAyT3Q4+J/GQUd97msF2JTph7RcolsXtUI0oj8D68BCHLBPZss
	tnrVSLdcsjdwjAFlxcO92rvr5X2GnHTg3nMTOmXsIlCaD2NBSkIrAUXIaoO
X-Google-Smtp-Source: AGHT+IHnnGSQUGEbVBE0bYYNiPgeh2onr0wlqJP4TF5T6ebcilt3NQheYuFNoSPMCZvDVvcFwEdAxg==
X-Received: by 2002:a05:6000:186f:b0:381:b716:2470 with SMTP id ffacd0b85a97d-38254b21a88mr3954531f8f.40.1732146921887;
        Wed, 20 Nov 2024 15:55:21 -0800 (PST)
Received: from [192.168.42.89] ([148.252.141.165])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa4f43800e0sm13129966b.195.2024.11.20.15.55.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Nov 2024 15:55:21 -0800 (PST)
Message-ID: <f32b768f-e4a4-4b8c-a4f8-0cdf0a506713@gmail.com>
Date: Wed, 20 Nov 2024 23:56:15 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH next v1 2/2] io_uring: limit local tw done
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
References: <20241120221452.3762588-1-dw@davidwei.uk>
 <20241120221452.3762588-3-dw@davidwei.uk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241120221452.3762588-3-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/20/24 22:14, David Wei wrote:
> Instead of eagerly running all available local tw, limit the amount of
> local tw done to the max of IO_LOCAL_TW_DEFAULT_MAX (20) or wait_nr. The
> value of 20 is chosen as a reasonable heuristic to allow enough work
> batching but also keep latency down.
> 
> Add a retry_llist that maintains a list of local tw that couldn't be
> done in time. No synchronisation is needed since it is only modified
> within the task context.
> 
> Signed-off-by: David Wei <dw@davidwei.uk>
> ---
>   include/linux/io_uring_types.h |  1 +
>   io_uring/io_uring.c            | 43 +++++++++++++++++++++++++---------
>   io_uring/io_uring.h            |  2 +-
>   3 files changed, 34 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index 593c10a02144..011860ade268 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -336,6 +336,7 @@ struct io_ring_ctx {
>   	 */
>   	struct {
>   		struct llist_head	work_llist;
> +		struct llist_head	retry_llist;

Fwiw, probably doesn't matter, but it doesn't even need
to be atomic, it's queued and spliced while holding
->uring_lock, the pending check is also synchronised as
there is only one possible task doing that.

>   		unsigned long		check_cq;
>   		atomic_t		cq_wait_nr;
>   		atomic_t		cq_timeouts;
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 83bf041d2648..c3a7d0197636 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -121,6 +121,7 @@
...
>   static int __io_run_local_work(struct io_ring_ctx *ctx, struct io_tw_state *ts,
>   			       int min_events)
>   {
>   	struct llist_node *node;
>   	unsigned int loops = 0;
> -	int ret = 0;
> +	int ret, limit;
>   
>   	if (WARN_ON_ONCE(ctx->submitter_task != current))
>   		return -EEXIST;
>   	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
>   		atomic_andnot(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
> +	limit = max(IO_LOCAL_TW_DEFAULT_MAX, min_events);
>   again:
> +	ret = __io_run_local_work_loop(&ctx->retry_llist.first, ts, limit);
> +	if (ctx->retry_llist.first)
> +		goto retry_done;
> +
>   	/*
>   	 * llists are in reverse order, flip it back the right way before
>   	 * running the pending items.
>   	 */
>   	node = llist_reverse_order(llist_del_all(&ctx->work_llist));
> -	while (node) {
> -		struct llist_node *next = node->next;
> -		struct io_kiocb *req = container_of(node, struct io_kiocb,
> -						    io_task_work.node);
> -		INDIRECT_CALL_2(req->io_task_work.func,
> -				io_poll_task_func, io_req_rw_complete,
> -				req, ts);
> -		ret++;
> -		node = next;
> -	}
> +	ret = __io_run_local_work_loop(&node, ts, ret);

One thing that is not so nice is that now we have this handling and
checks in the hot path, and __io_run_local_work_loop() most likely
gets uninlined.

I wonder, can we just requeue it via task_work again? We can even
add a variant efficiently adding a list instead of a single entry,
i.e. local_task_work_add(head, tail, ...);

I'm also curious what's the use case you've got that is hitting
the problem?

-- 
Pavel Begunkov

