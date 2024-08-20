Return-Path: <io-uring+bounces-2844-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E761958F06
	for <lists+io-uring@lfdr.de>; Tue, 20 Aug 2024 22:08:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 09FAA1F23912
	for <lists+io-uring@lfdr.de>; Tue, 20 Aug 2024 20:08:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A17193FB9F;
	Tue, 20 Aug 2024 20:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="kr6Ajr9T"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E0318E34A
	for <io-uring@vger.kernel.org>; Tue, 20 Aug 2024 20:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724184521; cv=none; b=MfpBwrUHc6AXq7IYBkbgzjKHrbyQ7exv/JHuYvx75C72QtiagCcvw0G+6GQSaoXnUmYOKX/ZpwRNHfZRXsj9Zgt6ldu3VgQBVTj44jkCFPTbiJY15GLASvPaeJnFN0IwrVSdQPx7yzRqya/gYSs6X1D291bDvSCXOFAm00t8aa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724184521; c=relaxed/simple;
	bh=P9kRRyje8RtZrUzMp0irj8+5jUaJEifsvLUloSVFXYU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=MRqYBYpoto+xOeMIyP7K7zDHi1blPwdGnpkDGDtZy+k0S3YsVZekVERMLGZ9IQIDLtqMFa3Bjntdiunjvp6ZsXJGoQVKw6y8jn7kEX6YLKjQTuXPXQCMEByC3tslooqtQ9QhavnsTry0q3opPuPyPsP3uo9paQvz3oIBPvn5XvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=kr6Ajr9T; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-7a115c427f1so3653720a12.0
        for <io-uring@vger.kernel.org>; Tue, 20 Aug 2024 13:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1724184519; x=1724789319; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F3bOJsU1zXmBHsibF/thcBh2YIaMzACizTMcYYAxyuQ=;
        b=kr6Ajr9TwRBgzsBhZMKQrWd9pzqeKPbP4KMrWBFZWxGnUhJo1/7vWlL60OftcO9oez
         MP132fxjB2NGtVZjhiLlMT6FwcZ0CiSyk6RCmTM22rqqremFf8g6UeMoiexx5eX4vwoT
         +SPCdf0n81guOyixl0qDAoqhhdl30TQmWhXIqlMw7dtzqqbiPTIvMoLzGALLxZU9RAPb
         MByMWzIhNHCGtXwH8e1vwPZ4VDDLDKXu31VP1cSgkN8HpgK4mdgsHrN2gM3MpQ15EPy8
         4k3ZmOZloHubi3uYw92mLADX4NnwQgHYytDpDiZKBacym+1JReOJqyqvWWSS6VgtbiPZ
         zllg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724184519; x=1724789319;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F3bOJsU1zXmBHsibF/thcBh2YIaMzACizTMcYYAxyuQ=;
        b=EoRWH/0KX9B5BbJRF/ZXiorxPstZ0yvU5JG0il1BDkvIgGe68HOY6tsLfn2lrw5Ne7
         cNk5OLevpoxBMpwOdIIuUa5bo7vs91Y7Vv7z55Mcs4tC9YKyIynmhoOrL+bqrxD+6MZB
         RDo6mxWyaNzdtWPfZ8iJPfX2BNrpNXRWhNeqts02nyOxNjfKAcG6FYJlLWjJK80upHF+
         8bT02ECafLphLUnbChKDyelMR+8wMeOhXYd+ApMwSaa0pwj10vBDnpHEXJR2vUorxyXe
         NFRFS+Z8hmFMj95mqjDi0NG81DfW0THoYda5B201DM6baiZCwj9zZeWwG46Tuzp1kFeB
         4Ndw==
X-Forwarded-Encrypted: i=1; AJvYcCUHp64kNEWXukhC/Eb0kpclASRG26NJGr3KNQdf2MIIG68Ie4nJQKzj+6nrIWrtsTNuoKU1UFh8WQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxqt16l/SH6PIv8vzStq2c4Gg4Up8tyGX18//Yg6gmd+2SzOBOX
	42a73iPwBnceiCm0suOQrFa2KG4ijS2Bj8o9s7YHaYmekaGDjaL83ZDlkOR2XFzJMmhzAdRsFcg
	z8wM=
X-Google-Smtp-Source: AGHT+IEKWSKqCaLCVfti7B7yIGXZXBEeVT/V0ZizxEuph3i3QHAF955u+VWpY869fyWpnn7YcgQx2g==
X-Received: by 2002:a05:6a21:3103:b0:1c8:b336:4022 with SMTP id adf61e73a8af0-1cad8352b8emr593548637.36.1724184519124;
        Tue, 20 Aug 2024 13:08:39 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1256:1:80c:c984:f4f1:951f? ([2620:10d:c090:500::5:2f5b])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7127af1e3e3sm8926721b3a.179.2024.08.20.13.08.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Aug 2024 13:08:38 -0700 (PDT)
Message-ID: <58a42e82-3742-4439-998e-c9389c5849bc@davidwei.uk>
Date: Tue, 20 Aug 2024 13:08:36 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] io_uring: implement our own schedule timeout handling
Content-Language: en-GB
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20240819233042.230956-1-axboe@kernel.dk>
 <20240819233042.230956-4-axboe@kernel.dk>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <20240819233042.230956-4-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024-08-19 16:28, Jens Axboe wrote:
> In preparation for having two distinct timeouts and avoid waking the
> task if we don't need to.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  io_uring/io_uring.c | 41 ++++++++++++++++++++++++++++++++++++-----
>  io_uring/io_uring.h |  2 ++
>  2 files changed, 38 insertions(+), 5 deletions(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 9e2b8d4c05db..ddfbe04c61ed 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -2322,7 +2322,7 @@ static int io_wake_function(struct wait_queue_entry *curr, unsigned int mode,
>  	 * Cannot safely flush overflowed CQEs from here, ensure we wake up
>  	 * the task, and the next invocation will do it.
>  	 */
> -	if (io_should_wake(iowq) || io_has_work(iowq->ctx))
> +	if (io_should_wake(iowq) || io_has_work(iowq->ctx) || iowq->hit_timeout)

iowq->hit_timeout may be modified in a timer softirq context, while this
wait_queue_func_t (AIUI) may get called from any context e.g.
net_rx_softirq for sockets. Does this need a READ_ONLY()?

>  		return autoremove_wake_function(curr, mode, wake_flags, key);
>  	return -1;
>  }
> @@ -2350,6 +2350,38 @@ static bool current_pending_io(void)
>  	return percpu_counter_read_positive(&tctx->inflight);
>  }
>  
> +static enum hrtimer_restart io_cqring_timer_wakeup(struct hrtimer *timer)
> +{
> +	struct io_wait_queue *iowq = container_of(timer, struct io_wait_queue, t);
> +	struct io_ring_ctx *ctx = iowq->ctx;
> +
> +	WRITE_ONCE(iowq->hit_timeout, 1);
> +	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
> +		wake_up_process(ctx->submitter_task);
> +	else
> +		io_cqring_wake(ctx);

This is a bit different to schedule_hrtimeout_range_clock(). Why is
io_cqring_wake() needed here for non-DEFER_TASKRUN?

> +	return HRTIMER_NORESTART;
> +}
> +
> +static int io_cqring_schedule_timeout(struct io_wait_queue *iowq,
> +				      clockid_t clock_id)
> +{
> +	iowq->hit_timeout = 0;
> +	hrtimer_init_on_stack(&iowq->t, clock_id, HRTIMER_MODE_ABS);
> +	iowq->t.function = io_cqring_timer_wakeup;
> +	hrtimer_set_expires_range_ns(&iowq->t, iowq->timeout, 0);
> +	hrtimer_start_expires(&iowq->t, HRTIMER_MODE_ABS);
> +
> +	if (!READ_ONCE(iowq->hit_timeout))
> +		schedule();
> +
> +	hrtimer_cancel(&iowq->t);
> +	destroy_hrtimer_on_stack(&iowq->t);
> +	__set_current_state(TASK_RUNNING);
> +
> +	return READ_ONCE(iowq->hit_timeout) ? -ETIME : 0;
> +}
> +
>  static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
>  				     struct io_wait_queue *iowq)
>  {
> @@ -2362,11 +2394,10 @@ static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
>  	 */
>  	if (current_pending_io())
>  		current->in_iowait = 1;
> -	if (iowq->timeout == KTIME_MAX)
> +	if (iowq->timeout != KTIME_MAX)
> +		ret = io_cqring_schedule_timeout(iowq, ctx->clockid);
> +	else
>  		schedule();
> -	else if (!schedule_hrtimeout_range_clock(&iowq->timeout, 0,
> -						 HRTIMER_MODE_ABS, ctx->clockid))
> -		ret = -ETIME;
>  	current->in_iowait = 0;
>  	return ret;
>  }
> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
> index 9935819f12b7..f95c1b080f4b 100644
> --- a/io_uring/io_uring.h
> +++ b/io_uring/io_uring.h
> @@ -40,7 +40,9 @@ struct io_wait_queue {
>  	struct io_ring_ctx *ctx;
>  	unsigned cq_tail;
>  	unsigned nr_timeouts;
> +	int hit_timeout;
>  	ktime_t timeout;
> +	struct hrtimer t;
>  
>  #ifdef CONFIG_NET_RX_BUSY_POLL
>  	ktime_t napi_busy_poll_dt;

