Return-Path: <io-uring+bounces-5842-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EDBD6A0B9ED
	for <lists+io-uring@lfdr.de>; Mon, 13 Jan 2025 15:42:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B1ECC1886FA6
	for <lists+io-uring@lfdr.de>; Mon, 13 Jan 2025 14:41:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 354AA2500AD;
	Mon, 13 Jan 2025 14:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JkhSunHR"
X-Original-To: io-uring@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8872297F5;
	Mon, 13 Jan 2025 14:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736779123; cv=none; b=RXfGGxEiKL+UXAKOWbwMqsxx3Pn619UBn/WRfo1AwqlZJCEl5x77xakqA9Zuzfpa7QowOK85XssLJZxt94thIuNtJPtk3nqP3FOqY91I12DogZ0xMvicNkG0p3HiwDllBJ9Eca9dW04izOwqRW7zdimL1vd8GTLRFsTjZiwWEyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736779123; c=relaxed/simple;
	bh=6VcBT5BmEkguzCSXEUtcmywV1fHCL08uODN34PMkYEY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GjMOsDEmCvOkcQNU4Sq/AsAEriGYSIzr0qJgNg2SwCuXzWvg1/V997FSgb4mY0pazwQjBxZrDwarlEnLS5g8L2bRmefhzbDR3qilQnHQLkMLwO+Y7YP/4JZRapv6VHu0ZQKDt0wE5LiZik+AlRhIDCdI7ycEY+Akd6Hs9SpmUc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JkhSunHR; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=U2yw+pYTBj228nPAY550XJ5+HccT/mkT4awxgbvF1PQ=; b=JkhSunHRnnOQPNbxyMP/G2hgo6
	SLVx47sYzKa0AjBucgD5xT/EfJ9CEXhnkJDjK47gjyihE61g81TKxfq1w8IRqRR308O5GNeAk9yHt
	+jdeIyUERhe06CVvtxzHtoBvqHkIbFtsmOxsSCcn0XXUToNc1EoDnlC3rqsADL50P/lgpGxO5Kley
	k9nmepHgiJbNHs0Q2quFbtDeQphfhs0TD/HL0M/mGo3Cxhq/0Z11xsNDGcil1ZEkrlNtJ9w1Wk8WA
	NvUDmUj1fnYTf2LCEulePGQFIIIVURGqdH4SMkufCBtK7smVoqywf+SAFg0eRAQHaL4SjeNFAlFTv
	TGoJ+DsQ==;
Received: from 77-249-17-89.cable.dynamic.v4.ziggo.nl ([77.249.17.89] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tXLaL-0000000AIYM-3eH1;
	Mon, 13 Jan 2025 14:38:34 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id DF7B930057A; Mon, 13 Jan 2025 15:38:32 +0100 (CET)
Date: Mon, 13 Jan 2025 15:38:32 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Jann Horn <jannh@google.com>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Darren Hart <dvhart@infradead.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	=?iso-8859-1?Q?Andr=E9?= Almeida <andrealmeid@igalia.com>,
	kernel list <linux-kernel@vger.kernel.org>,
	Pavel Begunkov <asml.silence@gmail.com>,
	io-uring <io-uring@vger.kernel.org>
Subject: Re: futex+io_uring: futex_q::task can maybe be dangling (but is not
 actually accessed, so it's fine)
Message-ID: <20250113143832.GH5388@noisy.programming.kicks-ass.net>
References: <CAG48ez2HHU+vSCcurs5TsFXiEfUhLSXbEzcugBSTBZgBWkzpuA@mail.gmail.com>
 <3b78348b-a804-4072-b088-9519353edb10@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b78348b-a804-4072-b088-9519353edb10@kernel.dk>

On Fri, Jan 10, 2025 at 08:33:34PM -0700, Jens Axboe wrote:

> @@ -548,7 +549,7 @@ void __futex_queue(struct futex_q *q, struct futex_hash_bucket *hb)
>  
>  	plist_node_init(&q->list, prio);
>  	plist_add(&q->list, &hb->chain);
> -	q->task = current;
> +	q->task = task;
>  }
>  
>  /**

The alternative is, I suppose, to move the q->task assignment out to
these two callsites instead. Thomas, any opinions?

> @@ -303,7 +304,7 @@ extern int futex_unqueue(struct futex_q *q);
>  static inline void futex_queue(struct futex_q *q, struct futex_hash_bucket *hb)
>  	__releases(&hb->lock)
>  {
> -	__futex_queue(q, hb);
> +	__futex_queue(q, hb, current);
>  	spin_unlock(&hb->lock);
>  }
>  
> diff --git a/kernel/futex/pi.c b/kernel/futex/pi.c
> index d62cca5ed8f4..635c7d5d4222 100644
> --- a/kernel/futex/pi.c
> +++ b/kernel/futex/pi.c
> @@ -982,7 +982,7 @@ int futex_lock_pi(u32 __user *uaddr, unsigned int flags, ktime_t *time, int tryl
>  	/*
>  	 * Only actually queue now that the atomic ops are done:
>  	 */
> -	__futex_queue(&q, hb);
> +	__futex_queue(&q, hb, current);
>  
>  	if (trylock) {
>  		ret = rt_mutex_futex_trylock(&q.pi_state->pi_mutex);
> 
> -- 
> Jens Axboe

