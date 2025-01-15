Return-Path: <io-uring+bounces-5872-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 54474A11F12
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 11:20:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DAE727A05D8
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 10:20:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52ADD1E7C3A;
	Wed, 15 Jan 2025 10:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="Wk5y4P5L";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="EEOFwqw3"
X-Original-To: io-uring@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7DE51DB138;
	Wed, 15 Jan 2025 10:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736936421; cv=none; b=SmN/Os0WJXY0FXhMFZFjUDwB0P2uu6sd2iO2sxhmW6bMdPqqF1uXDW12jM6Z/RsuzMaiX+KUkgCUre2fzOzSmyy16fyr9A60hjy7E8Ui94vExvNAbydjJbJ7EFLULuW2WHEoadl649T3AjySwRpQE2M+cNlHZ0OwJMiN99Wq3SI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736936421; c=relaxed/simple;
	bh=Y0or7/8tzk48diYGJj30iKKvQT6l5W9TsksC08Pubrg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=DsSWJy6WfGwhFz6jfYoOkpbIT8MOLyuVl4tdcLFfgFCt5thZTAB/Oio4owuaq1Nzpq3mxoWCK28akrFW2dCuC62lKJT0p+fVUzTRkICQilCtHMOIFRgJWFWmv/XfOt7imcTtvdS0WBLkzpSiPQH2bfjF9T/gKrfJdtgJR/Ba0yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=Wk5y4P5L; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=EEOFwqw3; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1736936417;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DYAdghFWryxhhOmYuAiL9vh2ANqpxi52Spuw5tailW4=;
	b=Wk5y4P5Lh2PIfpF16vk0CYtb54T/c9Bw6jjfCOF8oeO1ZUDwDk+ZGqCBwezm+vKu3ZpMEe
	6f2i6AoS6RqVRuby0Y8dvE2vggpJ5KAOMzRqeVEexs5cDxvXCcu/CQDgN5UolwMQRret4w
	DNfLQQyDTntSexQuqkFyT9s64s10GgGiui3u0P9K+JOG0NWZK0RVbBqkjAFtH7EOQm/oCp
	4jH0cOk2k0JBq38b0FkuRACPfdoKHkZpmcMWINN49VjxJLcwSAg5KQxYMRUtCZ8palUxlx
	vY2Ugvdr7yd+9LxYmBsQhOVXoo0oahFXFhDyDinCf6bE8I7TCgjLJr42gE7Diw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1736936417;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DYAdghFWryxhhOmYuAiL9vh2ANqpxi52Spuw5tailW4=;
	b=EEOFwqw3TZqY4T0wVPn57iR1Jt3845RLYV8II8DB9IoF64VzJoBcImjcLbXEJt7uOiMlD5
	SzulT8DObroa7VBA==
To: Peter Zijlstra <peterz@infradead.org>, Jens Axboe <axboe@kernel.dk>
Cc: Jann Horn <jannh@google.com>, Ingo Molnar <mingo@redhat.com>, Darren
 Hart <dvhart@infradead.org>, Davidlohr Bueso <dave@stgolabs.net>,
 =?utf-8?Q?Andr=C3=A9?=
 Almeida <andrealmeid@igalia.com>, kernel list
 <linux-kernel@vger.kernel.org>, Pavel Begunkov <asml.silence@gmail.com>,
 io-uring <io-uring@vger.kernel.org>
Subject: Re: futex+io_uring: futex_q::task can maybe be dangling (but is not
 actually accessed, so it's fine)
In-Reply-To: <20250113143832.GH5388@noisy.programming.kicks-ass.net>
References: <CAG48ez2HHU+vSCcurs5TsFXiEfUhLSXbEzcugBSTBZgBWkzpuA@mail.gmail.com>
 <3b78348b-a804-4072-b088-9519353edb10@kernel.dk>
 <20250113143832.GH5388@noisy.programming.kicks-ass.net>
Date: Wed, 15 Jan 2025 11:20:17 +0100
Message-ID: <877c6wcra6.ffs@tglx>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Mon, Jan 13 2025 at 15:38, Peter Zijlstra wrote:
> On Fri, Jan 10, 2025 at 08:33:34PM -0700, Jens Axboe wrote:
>
>> @@ -548,7 +549,7 @@ void __futex_queue(struct futex_q *q, struct futex_hash_bucket *hb)
>>  
>>  	plist_node_init(&q->list, prio);
>>  	plist_add(&q->list, &hb->chain);
>> -	q->task = current;
>> +	q->task = task;
>>  }
>>  
>>  /**
>
> The alternative is, I suppose, to move the q->task assignment out to
> these two callsites instead. Thomas, any opinions?

That's fine as long as hb->lock is held, but the explicit argument makes
all of this simpler to understand.

Though I'm not really a fan of this part:

> +		__futex_queue(&ifd->q, hb, NULL);
> +		spin_unlock(&hb->lock);

Can we please add that @task argument to futex_queue() and keep the
internals in the futex code instead of pulling more stuff into io_uring?

Thanks,

        tglx



