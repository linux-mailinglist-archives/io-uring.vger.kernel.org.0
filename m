Return-Path: <io-uring+bounces-12723-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qLqIFP1IuWmK+QEAu9opvQ
	(envelope-from <io-uring+bounces-12723-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 13:28:45 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 53C1D2A9DC7
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 13:28:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 35EF6300C6F2
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 12:27:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A32A53C198A;
	Tue, 17 Mar 2026 12:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HfMU9bVf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD2A3C2782
	for <io-uring@vger.kernel.org>; Tue, 17 Mar 2026 12:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773750474; cv=none; b=ghswY0hPvQE9W5dZHW/+xswVsudVmHZ1FJOfoti5QuLk+CPr+3wx3kdojRwEZF8VsU18co61DG2/VcLmagFT7EhY3L97Fto34RHYDCxoq+rLPXBr0E2ZS3G5kVQIfOqlakEw/DyI7XOJKoHJh1tpitEQuixdtw0bIfV02XQ0GJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773750474; c=relaxed/simple;
	bh=hSU4unjK1ZW+CripGf5LqR38nE8HZJOSOgkHuztfUnc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H26OAY/tEd2Q3GG5WTgN5rLsdpdb4a3IMqcIouiTv09713bpZRtfrFYuKvka9p4IxJlBqNOwtCX1ksifbSYCZ0eYkjMRa6hwqciEXZFpxth12AxADYKUrWsvUyxY8K7l/xL44WR28W5jf0ohybjS27rt4hE1cuHhohhk6yk6kvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HfMU9bVf; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6611d20c026so8170489a12.1
        for <io-uring@vger.kernel.org>; Tue, 17 Mar 2026 05:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773750470; x=1774355270; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hjBlEBcPcBRPFGVKTeNXdljAIp3KfRjLsmadGgOckUQ=;
        b=HfMU9bVfQHPjPqkaLo8AefsG5/92FyeqMdl/Wb6G+cHyPTnP0qQPXU3XRqPDDkTeQU
         t1oQh8F3v1NOwsItV8AdvFJHHW8rEB1rsykkdfCiqLRwxH/sVsuz/GpWQc9kbWbM0/8H
         EYMphfrXLHCGBxN+7gURm+fP6XiDShfXi3+y/tmfbG08ng2TUCj6lnPoArtQjXLALUuW
         nP+pM5lWBeWHU4hjN9SzU36CFUrGR6FiXMoxzTle4cSwVcM9AF7tlkplKuFwJJ/yE0DZ
         bKXDKKC2Xl5kU2Mk/OtZHydyVT6AgavgEz0k0j1/ZUrKpMTGMANIHGHzWgXhOns2bZDJ
         /lKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773750470; x=1774355270;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hjBlEBcPcBRPFGVKTeNXdljAIp3KfRjLsmadGgOckUQ=;
        b=WNTohZTYVNvxpFvmp1ZYjGv2Gxa0dZsYw+07NffDCuRoFGvfcxuDmPjwtZ3N36hN5I
         kqKbfO6adunhIXU/jP2cs2Kg3VRduLnAvsXvP2EO9/YX/MH8pr8za2FaWxTYEPSczcLw
         zi95G4ReKall9ewZAvpAaK5G6xcaR5iNtm+6ushOD5qrpkxkxl+IHLiOf033g+TXtkB0
         noiG+pUyku+/qCfF0xz+89inYl1yUjeo7MimedoIoA+tWUxEAPvVJydsKuRDsoULrjQ6
         lxDbMzXdp1TSYhY0b3abufuHrim3mVYqjl0AInTzpSXQG7y1HTOS7RiEJi0i3/+7I6xK
         LHHw==
X-Forwarded-Encrypted: i=1; AJvYcCXZl5F2XEwRIYEjzQ8DjRaAYuwdyj9trKZpWSL/pobnucFn/N++1Ek3Mc7SQ8vADSqD0AYuM1S6Lg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzAIgVpP4StLkLeLqxW7OmkBZQG8DGC551O0suxzpg0fbjthIUp
	nCyImfnXRIgJDKXkPi7XU8txZNqTcznv5hzAw4Cjxrf6DUpW1Ey8S4xD97d8bg==
X-Gm-Gg: ATEYQzyiGtXQIqhuZV14/SWLLkXiM0frXO0UkWoNWCzKYI2S6FdL6mFrABtUJpvdmCn
	njz9gIdjDVlqzUzYLNsp+hkTOrEewvvon2caq/td2vAdYt7oHxcUOIQ3sMhCPlf7OLz12VWvjrS
	vDxr1rj7V2c0YgD+9wdYusYvWUYyCYKaoEV8SLSOSBQ+aNjizrmfAswQ3y8W3kv98LK83xKsJID
	YieGiQ3VckituHVfcOfeAazebZMYtQ3ZerW/vZ4FYllfxRINxkcEWnPwqc2F5e0mRjTTxYQjvZ8
	a0R8jVVD8gnpX/lxYdsC5MZ1cHSNwzsB9ndOYOUDW/+DGsgDa/EY/gHwUO5jfZ0qheU5mBmf246
	exRqZMr4pjFVHWRI/bX4iDMLYDUaMqSwQsylUIDWezKtgZHG1n73PH5stqPGS1pcJJ6X9g0sIaN
	BSZG+Qj1sc6aeQZRcAkbU+QQjv8SiQ/RacdVfZoP3OOe4yfjLjNpc2HuNM0aHCyW8jhgpf07nmJ
	ivMR34Jzl0OMbLCtshZ3V9yyo/Gec3a/qyQglyPHDO31QEScOs8HZ4=
X-Received: by 2002:a05:6402:3583:b0:666:1a76:2381 with SMTP id 4fb4d7f45d1cf-6661a7625d3mr3884934a12.12.1773750469719;
        Tue, 17 Mar 2026 05:27:49 -0700 (PDT)
Received: from [10.228.209.141] (82-132-214-97.dab.02.net. [82.132.214.97])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-663509919c9sm6742807a12.23.2026.03.17.05.27.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Mar 2026 05:27:48 -0700 (PDT)
Message-ID: <06a8b8a6-2cf0-4d1f-835f-06f4070402d9@gmail.com>
Date: Tue, 17 Mar 2026 12:27:53 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] io_uring/poll: fix multishot recv missing EOF on
 wakeup race
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Cc: Francis Brosseau <francis@malagauche.com>
References: <f39b5d6d-507c-4b2e-96e0-c5ba38aa2fe4@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <f39b5d6d-507c-4b2e-96e0-c5ba38aa2fe4@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12723-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TO_DN_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,kernel.dk:email]
X-Rspamd-Queue-Id: 53C1D2A9DC7
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/17/26 02:17, Jens Axboe wrote:
> When a socket send and shutdown() happen back-to-back, both fire
> wake-ups before the receiver's task_work has a chance to run. The first
> wake gets poll ownership (poll_refs=1), and the second bumps it to 2.
> When io_poll_check_events() runs, it calls io_poll_issue() which does a
> recv that reads the data and returns IOU_RETRY. The loop then drains all
> accumulated refs (atomic_sub_return(2) -> 0) and exits, even though only
> the first event was consumed. Since the shutdown is a persistent state
> change, no further wakeups will happen, and the multishot recv can hang
> forever.
> 
> Check specifically for HUP in the poll loop, and ensure that another
> loop is done to check for status if more than a single poll activation
> is pending. This ensures we don't lose the shutdown event.

Sounds fine with comments below.

Btw, did you look into whether it's a INQ issue? Polling expects
multishots to handle all those conditions, which usually goes in a
form of:

while (1) {
	ret = do_IO();
	if (ret == -EAGAIN)
		goto continue_poll;
	if (ret < 0)
		goto fail;
	if (ret == 0)
		goto terminate_req;
	...
	// partial progress, try again
}

and recv was following this pattern before, but maybe it's sth
like recv() returning some bytes, inq rightfully saying that there
are no more bytes left but forgets to check for terminators like
shutdown.

> Cc: stable@vger.kernel.org
> Fixes: dbc2564cfe0f ("io_uring: let fast poll support multishot")
> Reported-by: Francis Brosseau <francis@malagauche.com>
> Link: https://github.com/axboe/liburing/issues/1549
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> ---
> 
> V3: split mshot and !mshot cases, and simply use the number of refs
>      gotten in the beginning for gating retry. if one is dropped when
>      we want to retry, we'll loop again as we'd still have remaining
>      refs.
> 
> diff --git a/io_uring/poll.c b/io_uring/poll.c
> index aac4b3b881fb..a264d73a8cbd 100644
> --- a/io_uring/poll.c
> +++ b/io_uring/poll.c
> @@ -228,6 +228,19 @@ static inline void io_poll_execute(struct io_kiocb *req, int res)
>   		__io_poll_execute(req, res);
>   }
>   
> +static inline void io_mshot_check_retry(struct io_kiocb *req, int *v)
> +{
> +	/*
> +	 * Release all references, retry if someone tried to restart
> +	 * task_work while we were executing it.
> +	 */

This comment belongs to the atomic sub, not masking.

> +	*v &= IO_POLL_REF_MASK;

nit: seems like you can just do that inside the
"if (unlikely(v != 1)) { ... }" block.

> +
> +	/* multiple refs and HUP, ensure we loop once more */
> +	if ((req->cqe.res & (POLLHUP | POLLRDHUP)) && *v != 1)
> +		(*v)--;
> +}
> +
>   /*
>    * All poll tw should go through this. Checks for poll events, manages
>    * references, does rewait, etc.
> @@ -303,6 +316,7 @@ static int io_poll_check_events(struct io_kiocb *req, io_tw_token_t tw)
>   				io_req_set_res(req, mask, 0);
>   				return IOU_POLL_REMOVE_POLL_USE_RES;
>   			}
> +			v &= IO_POLL_REF_MASK;
>   		} else {
>   			int ret = io_poll_issue(req, tw);
>   
> @@ -312,16 +326,11 @@ static int io_poll_check_events(struct io_kiocb *req, io_tw_token_t tw)
>   				return IOU_POLL_REQUEUE;
>   			if (ret != IOU_RETRY && ret < 0)
>   				return ret;
> +			io_mshot_check_retry(req, &v);

Should go before io_poll_issue(), req->cqe.res might already be
invalid.

-- 
Pavel Begunkov


