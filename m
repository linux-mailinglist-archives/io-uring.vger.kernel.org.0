Return-Path: <io-uring+bounces-6332-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CDB7A2D9AD
	for <lists+io-uring@lfdr.de>; Sun,  9 Feb 2025 00:27:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8B0D91888A74
	for <lists+io-uring@lfdr.de>; Sat,  8 Feb 2025 23:27:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF4AB24338E;
	Sat,  8 Feb 2025 23:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ciZDEbPO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B546D243365;
	Sat,  8 Feb 2025 23:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739057232; cv=none; b=Q73WOWl92GXccxLDYdrvRPl4EMzjkLwIhRam4Hc9oc4D7hRg+qM7uGV5hU2p/wTcDLGOx4uebCJqwW6t9oni1G5KIX4JkccGj0xwiU9HNm41+IbiwmwR4/s7ID4NQttqoRtPvnArexR3+Pn1zgGQ2fEAXaGcgyUy8Jo86x9Ob+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739057232; c=relaxed/simple;
	bh=hDXabqWC5YUCpFVHDpxjs+4nvwAeLhL8VKKHEsKJoME=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F0Ugqur1q6zKUce7nx4vlv1a56cEp9mgSrJDt5Gwn1hhYb/n3nPtt2FppMUciBBE3EN/Bz37+rQfs48jjJjD8pLpz5sGULrRK94bxwqaEOANas5XyR3XbKrfO2O0Ro19S5kbLmkjqv1NyyKGTvmJZKTQZaaL+LUMgLwQiUuYbuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ciZDEbPO; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5de51a735acso2970369a12.0;
        Sat, 08 Feb 2025 15:27:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739057228; x=1739662028; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nmS8+CfVXDyz2zlVONlEnZrIcLkjYuZ2bhqSNOUYqOc=;
        b=ciZDEbPOef+ZmbNXI00pjOxX0SHU4iGtCKr/CiwGTpjhH1N3L1TF58qYcVenav/oze
         NPtvW/qT55kF/VypXjxjjQDLy8VSYMXtjNj98N+BJBDRdl40FQTpDm8mXINJD79hG1ax
         542x4LiubpraA1NfNs+WTJP78rz+ug7k9x1AKg1VspAAz+HAlmDELGiOKxvxhQ3FGCrm
         UmiZiJvFOpmVa8InE9XkOuXBn/J/bWK/w7yAEMZ/aDK/u4b7r7RHM0TzQ37fNuMY4ABc
         vnn1wyy4ILIp+iGZFNTC1igxvBJq9wXYNeyp0qaFGx0I9oP2VLhbsDVtcOADfpRZQQRL
         QIbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739057228; x=1739662028;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nmS8+CfVXDyz2zlVONlEnZrIcLkjYuZ2bhqSNOUYqOc=;
        b=J4DTPbHKxfKUepwWQTSlIMThAGoRVqyioaxLSjrK2upwkkKYKAbe0R5mjQdcZLw+SG
         pm+Bt9pX2yQjki3dzmFemhJ4XIi/cY4wrgs21gPxvIsl9MswlhddgFOLNG0188KfYts0
         2RShRcvuf3zf5OoBaEWqeRB1TIvEwC+yZCTXW+GuWbyquh0rGIphDWHuX4B3dbuzCz3H
         tZS98SnP4U+iuDtxmoKzq+iYWGmgiJzkGb11xNbI0S0yN0ddeopkAIZgsqUv5PoBO0tz
         WDR4ZqRyJEbceVfujPbCZ2yvSYw5kq1fZx/oKdKLp4MsxGxGY4wRFPrWszITLlcCos/A
         Y7ZA==
X-Forwarded-Encrypted: i=1; AJvYcCVFFrc84pFwJzDqmljLdL30p6ClOjADVr3houmcOupUQK+hhvtYZUw4EvEXeAzBdRv2VJ7ofvh2AQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxD4BpFswiJkz95h1PGdjFsj23oSIxCV7gaf6MZ4AjUBLhXbF44
	D9AZDuGEzzouDaUijdVHIl53XIyMd6PwAwUjh7S//1KPpKDz714d
X-Gm-Gg: ASbGnct44wCKg2dQfgqnBgLTY+Nc/YVGROva4rtEon2cOjF/YGoROTRX1AXgkgd/a5g
	7GTIToSeEyMzcj7oANZEaMXxZ4TmTXuuozx+tbiPqKoQQIfDcVwlI0WMe00PGQQsSaBrC9+NyOd
	8mA3UoCaUELnTiNRDWD32UCieDgzNwb3iw1LKRaMSjYRK5YEUMcWX4e3gpu6Y4TozbitH3KmEgh
	GJdHa/TESZpW77VkKqRQKd6epHG1qBoDE0dL/kDHuarOQBtpMEOC1hbIhYbPvFqGoyWb60jsl0m
	MbL87U/V8hfoUTnOM1VLCnWF+w==
X-Google-Smtp-Source: AGHT+IGxKG1lqvBeP6kiuW3N2wA2ryRQ67SAeqbExhFA54LJl6YzS8q1ImQumDHUg/PXuGTtTwFi1g==
X-Received: by 2002:a05:6402:2390:b0:5db:f26d:fff8 with SMTP id 4fb4d7f45d1cf-5de4508dcc3mr6334421a12.22.1739057227768;
        Sat, 08 Feb 2025 15:27:07 -0800 (PST)
Received: from [192.168.8.100] ([148.252.133.220])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5de5b2e4497sm2344747a12.47.2025.02.08.15.27.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Feb 2025 15:27:06 -0800 (PST)
Message-ID: <48bb1b42-b196-4f17-aeee-7b7112fbb30c@gmail.com>
Date: Sat, 8 Feb 2025 23:27:08 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] io_uring/epoll: add support for IORING_OP_EPOLL_WAIT
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, brauner@kernel.org
References: <20250207173639.884745-1-axboe@kernel.dk>
 <20250207173639.884745-8-axboe@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250207173639.884745-8-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/7/25 17:32, Jens Axboe wrote:
> For existing epoll event loops that can't fully convert to io_uring,
> the used approach is usually to add the io_uring fd to the epoll
> instance and use epoll_wait() to wait on both "legacy" and io_uring
> events. While this work, it isn't optimal as:
> 
> 1) epoll_wait() is pretty limited in what it can do. It does not support
>     partial reaping of events, or waiting on a batch of events.
> 
> 2) When an io_uring ring is added to an epoll instance, it activates the
>     io_uring "I'm being polled" logic which slows things down.
> 
> Rather than use this approach, with EPOLL_WAIT support added to io_uring,
> event loops can use the normal io_uring wait logic for everything, as
> long as an epoll wait request has been armed with io_uring.
> 
> Note that IORING_OP_EPOLL_WAIT does NOT take a timeout value, as this
> is an async request. Waiting on io_uring events in general has various
> timeout parameters, and those are the ones that should be used when
> waiting on any kind of request. If events are immediately available for
> reaping, then This opcode will return those immediately. If none are
> available, then it will post an async completion when they become
> available.
> 
> cqe->res will contain either an error code (< 0 value) for a malformed
> request, invalid epoll instance, etc. It will return a positive result
> indicating how many events were reaped.
> 
> IORING_OP_EPOLL_WAIT requests may be canceled using the normal io_uring
> cancelation infrastructure. The poll logic for managing ownership is
> adopted to guard the epoll side too.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   include/linux/io_uring_types.h |   4 +
>   include/uapi/linux/io_uring.h  |   1 +
>   io_uring/cancel.c              |   5 ++
>   io_uring/epoll.c               | 143 +++++++++++++++++++++++++++++++++
>   io_uring/epoll.h               |  22 +++++
>   io_uring/io_uring.c            |   5 ++
>   io_uring/opdef.c               |  14 ++++
>   7 files changed, 194 insertions(+)
> 
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index e2fef264ff8b..031ba708a81d 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -369,6 +369,10 @@ struct io_ring_ctx {
...
> +bool io_epoll_wait_remove_all(struct io_ring_ctx *ctx, struct io_uring_task *tctx,
> +			      bool cancel_all)
> +{
> +	return io_cancel_remove_all(ctx, tctx, &ctx->epoll_list, cancel_all, __io_epoll_wait_cancel);
> +}
> +
> +int io_epoll_wait_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
> +			 unsigned int issue_flags)
> +{
> +	return io_cancel_remove(ctx, cd, issue_flags, &ctx->epoll_list, __io_epoll_wait_cancel);
> +}
> +
> +static void io_epoll_retry(struct io_kiocb *req, struct io_tw_state *ts)
> +{
> +	int v;
> +
> +	do {
> +		v = atomic_read(&req->poll_refs);
> +		if (unlikely(v != 1)) {
> +			if (WARN_ON_ONCE(!(v & IO_POLL_REF_MASK)))
> +				return;
> +			if (v & IO_POLL_CANCEL_FLAG) {
> +				__io_epoll_cancel(req);
> +				return;
> +			}
> +		}
> +		v &= IO_POLL_REF_MASK;
> +	} while (atomic_sub_return(v, &req->poll_refs) & IO_POLL_REF_MASK);

I actually looked up the epoll code this time. If we disregard
cancellations, you have only 1 wait entry, which should've been removed
from the queue by io_epoll_wait_fn(), in which case the entire loop is
doing nothing as there is no one to race with. ->hash_node is the only
shared part, but it's sync'ed by the mutex.

As for cancellation, epoll_wait_remove() also removes the entry, and
you can rely on it to tell if the entry was removed inside, from
which you derive if you're the current owner.

Maybe this handling might be useful for the multishot mode, perhaps
along the lines of:

io_epoll_retry()
{
	do {
		res = epoll_get_events();
		if (one_shot || cancel) {
			wq_remove();
			unhash();
			complete_req(res);
			return;
		}

		post_cqe(res);

		// now recheck if new events came while we were processing
		// the previous batch.
	} while (refs_drop(req->poll_refs));
}

epoll_issue(issue_flags) {
	queue_poll();
	return;
}

But it might be better to just poll the epoll fd, reuse all the
io_uring polling machinery, and implement IO_URING_F_MULTISHOT for
the epoll opcode.

epoll_issue(issue_flags) {
	if (!(flags & IO_URING_F_MULTISHOT))
		return -EAGAIN;

	res = epoll_check_events();
	post_cqe(res);
	etc.
}

I think that would make this patch quite trivial, including
the multishot mode.

-- 
Pavel Begunkov


