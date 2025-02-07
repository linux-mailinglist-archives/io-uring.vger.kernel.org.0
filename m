Return-Path: <io-uring+bounces-6294-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CF658A2C2D9
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2025 13:38:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F34EF3A61F2
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2025 12:38:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B88217C68;
	Fri,  7 Feb 2025 12:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LkVn+wBk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6588A33EC;
	Fri,  7 Feb 2025 12:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738931924; cv=none; b=rdWndBRM5HyKKa9KcYD0VFGcv9kmxzJ1GCXrISz9ZIoF7XrqD4aXJacMaPbE1rIPvD/AgfzEj+3x1w7iu25rk6Ck3/j7ICdX0styZOvJ6xxWVqU0GcQtY0wdaTVyTGsFXtCVXq6Sk96zDhVvFibDIEJCT6zrJpdjUgd7LGR5hE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738931924; c=relaxed/simple;
	bh=MRbTbPFwH9hUAxmyGetO9VAyItOPs/KNcYoOmzm5J/w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Od/12cHmNNh2VBTz/IqBELY5NX/jlYUMsJ2U26Yq5599ngFpr9AGl1ETAHjc2fJpBhL8SvO7KYP3AQ+bgy54K7R+Th3oNoshyfyWUF/FzuLDh3stW0mnTpXGUGfi0CjTLz4JinXsrBVRNtHxmaEJ1CmsTeYiYv/+1l6/R1bvtrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LkVn+wBk; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-aa66c1345caso40280066b.3;
        Fri, 07 Feb 2025 04:38:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738931920; x=1739536720; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NRXFECRHhAWPRIcdZAWNt7kyqy4jeSNvv2ZN6DIzB1Q=;
        b=LkVn+wBkEk8tOqdnTeTZcvjPITaw44u4BfsaK0BKAuIfKWXoQ94Z3VFRstb7JC7W3E
         6dIWxGOjQdDNhJU47pe5w6B1OtwC6HBzUqs1u0IIqCzyIXyVp782LtFaj8ujic32IaEm
         sjf5pE2paLhyE4MGZ+EN5bOACQcZlylfN64h/wIgtd7qLngYtEhA2j/ghObaKWuumTnq
         B8uYqD0ouGbAdkUGjIiLxwsEZJG476woOaWl2C2dXerDjwHgaPlBqB5kWF72Tm20vmct
         5w3BBrMBH82RvQSYpB3bZrIGwha2e0cl+9hstVgar+xYovRjAfiEHaRLEiqobR/DpDgL
         lPpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738931920; x=1739536720;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NRXFECRHhAWPRIcdZAWNt7kyqy4jeSNvv2ZN6DIzB1Q=;
        b=UwvSBi//C+jOuXqqX5PKutucmh7SRcyGOQiVSeTcSLO/BwcKB9ndWCmEIV8I4ZpBZT
         LsMGlrtLX+AkGRkXOqPAvjAjRDLrUG82DwxOPSPVl0pgWeFVGWhqINl0ltc3cfZcaY4r
         x1xObiJtzUYPJdfMok6Wvg11HNjOo43vQiUXU35oVRgdel1F9mSv/o63SWE9MZCiZXB8
         5yXTklNhxMSlvceXbllhOj1UeJYcg7nRzQ8nzWybiTQYI/JXf9ph7hZePbcbJL75J8Z+
         MGAcp6IwgEGjXnD6V3TeqDg3meeVB68nJLqsM56++zjgF0rlxFohZ6T0pJT6wwOwzafi
         8agQ==
X-Forwarded-Encrypted: i=1; AJvYcCUkObTIxPh4KYh87CgMBvpmNIETMHHaOM+sPWMTR9mJthZsbsqyBKM0+e7Vb8HlSBUXR+XibOBEzA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwQSigTM3A37sQkwpa6uaH6xYv3kWSeD+aY0Pfc43rVJoHV8DdR
	riVnFHHp/FOZKMmjzm2Prxb9IV4OTZYbp0rMGBPlPe22pNGNk43s
X-Gm-Gg: ASbGncuUfuB+Fmw8g+mcACqh8d0BMx/H85zgnIEFlz9dedwWQDM7TvG6JRrDtmwQV3d
	AUvPYbC+8K270bA4sU39Jy1YwUwdqGrBAQp+bStHovKHlUvar2ePO1oQok0h0+/WZqTeN/LTkQp
	2Yucdj1LBX5P5e4nbJBFXUGEQ1AhEOVek3D59O+oIPDs7vVir7O4zFjnkvDH4/fPRx7lGPAwj0U
	Zg0f12kp0QqIRP7pcKRmW+wmh+TZwL6LnQRButuPAqfnE4OAm6TjCWq3SxJhVTwMM6zxyzItw8M
	ZXsZWH8iqg9/FgwgLI+AQP+JAvQURImhxDAR755Pk0zQ9xO2
X-Google-Smtp-Source: AGHT+IEvkzdc4DBthu3R+FesJexfkkHpD7pub6V0X3wRA+RwWxB26NzVoiPTLkbYv2hECl8cvWYadQ==
X-Received: by 2002:a17:907:6d1a:b0:ab6:f68c:746e with SMTP id a640c23a62f3a-ab789c3dcafmr336079466b.41.1738931920170;
        Fri, 07 Feb 2025 04:38:40 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:8e12])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab772fdb6bcsm260418366b.86.2025.02.07.04.38.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Feb 2025 04:38:39 -0800 (PST)
Message-ID: <a48b35ed-b509-40a3-ad00-4834872bb39c@gmail.com>
Date: Fri, 7 Feb 2025 12:38:45 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/11] io_uring/epoll: add support for
 IORING_OP_EPOLL_WAIT
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, brauner@kernel.org
References: <20250204194814.393112-1-axboe@kernel.dk>
 <20250204194814.393112-10-axboe@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250204194814.393112-10-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/4/25 19:46, Jens Axboe wrote:
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
...
> diff --git a/io_uring/epoll.c b/io_uring/epoll.c
> index 7848d9cc073d..5a47f0cce647 100644
> --- a/io_uring/epoll.c
> +++ b/io_uring/epoll.c
...
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
> +			if (v & IO_POLL_FINISH_FLAG)
> +				return;
> +		}
> +		v &= IO_POLL_REF_MASK;
> +	} while (atomic_sub_return(v, &req->poll_refs) & IO_POLL_REF_MASK);

I haven't looked deep into the set, but this loop looks very
suspicious. The entire purpose of the twin loop in poll.c is
not to lose events while doing processing, which is why the
processing happens before the decrement...

> +	io_req_task_submit(req, ts);

Maybe the issue is supposed to handle that, but this one is
not allowed unless you fully unhash all the polling. Once you
dropped refs the poll wait entry feels free to claim the request,
and, for example, queue a task work, and io_req_task_submit()
would decide to queue it as well. It's likely not the only
race that can happen.

> +}
> +
> +static int io_epoll_execute(struct io_kiocb *req)
> +{
> +	struct io_epoll_wait *iew = io_kiocb_to_cmd(req, struct io_epoll_wait);
> +
> +	list_del_init_careful(&iew->wait.entry);
> +	if (io_poll_get_ownership(req)) {
> +		req->io_task_work.func = io_epoll_retry;
> +		io_req_task_work_add(req);
> +	}
> +
> +	return 1;
> +}
...
> +int io_epoll_wait(struct io_kiocb *req, unsigned int issue_flags)
> +{
> +	struct io_epoll_wait *iew = io_kiocb_to_cmd(req, struct io_epoll_wait);
> +	struct io_ring_ctx *ctx = req->ctx;
> +	int ret;
> +
> +	io_ring_submit_lock(ctx, issue_flags);
> +
> +	ret = epoll_wait(req->file, iew->events, iew->maxevents, NULL, &iew->wait);
> +	if (ret == -EIOCBQUEUED) {
> +		if (hlist_unhashed(&req->hash_node))
> +			hlist_add_head(&req->hash_node, &ctx->epoll_list);
> +		io_ring_submit_unlock(ctx, issue_flags);
> +		return IOU_ISSUE_SKIP_COMPLETE;
> +	} else if (ret < 0) {
> +		req_set_fail(req);
> +	}
> +	hlist_del_init(&req->hash_node);
> +	io_ring_submit_unlock(ctx, issue_flags);
> +	io_req_set_res(req, ret, 0);
> +	return IOU_OK;
> +}
...
-- 
Pavel Begunkov


