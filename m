Return-Path: <io-uring+bounces-2462-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 94B5892A93A
	for <lists+io-uring@lfdr.de>; Mon,  8 Jul 2024 20:48:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4BA6328226C
	for <lists+io-uring@lfdr.de>; Mon,  8 Jul 2024 18:48:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF97F145FEF;
	Mon,  8 Jul 2024 18:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dDi6WSpO"
X-Original-To: io-uring@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A7614D719;
	Mon,  8 Jul 2024 18:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720464502; cv=none; b=I2WYKD9w/TNn4OS5qkQbPF4LmOxLu9ZNiZAtdBBZXnD3kbitxR2jGt3rFKRz9uj12AWcK3T1P+GRmuTpejwYNo7MlTqsDWlVIA6ETd6v579nGR8YRR5qvWvQv1dviI2s4zv2OfBdL/mPa8q1I50iGRZ1e2U5XFGTRgh5ZCr2t7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720464502; c=relaxed/simple;
	bh=mWnrxFzxRxRPZXsKclXyaLzr4JzxLzVBGfeEsqZzZd0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pKexjjPfmcnZUniZ2lKRAMhiGssVSHZ8qUEOaxwOyCbDY6tfriwX9W+aRHjDGOeJdShCN6RLFnxrbe6ccrlHxOAcSUBSSOJwRX/KKDW+MBqi4Q5tLn6SaHEuVNEJreXrSigYw4sz1nrr7v4X3dB9wiJA2gxvk6GWuLczfuoM1j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dDi6WSpO; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FN0xHQUi1wWiU1wm9z2Xelr6TBiXkz9A1M2VlZ8zZZE=; b=dDi6WSpOtb1mlx2n4FI5sO9Bqt
	jF9BBvQr+AIxjPamFcI8QgMj/NPk62vMlxHNC44+bzLW6qXAGF018j+GQKY6guEmJK3deBYUDGErm
	SxA+zZRxjlqM2iK8vSDvZ4SNL+9X0foBjwogUyjL8FgSOG1w3AtWmlusidb8r1eD4K2jdgY1UnqaT
	Vr8vptPnlTEZLoRy+SM47Sw8W8aApYL9AAmNxvJGMOoFpqhRytzFfVnnXscjxx4DTHLgKF9BY9JTp
	aplF1S1tAih/J/pkGEFkAr+4kto1cAwN7QhW2W0brjvJOHa/SGPHrtAR2xRWCasyFxHYmOh9F34xq
	b5O/BnCA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sQtPL-000000074iU-49y0;
	Mon, 08 Jul 2024 18:48:16 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 0E90C300694; Mon,  8 Jul 2024 20:48:15 +0200 (CEST)
Date: Mon, 8 Jul 2024 20:48:14 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, io-uring@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Tycho Andersen <tandersen@netflix.com>,
	Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
	Julian Orth <ju.orth@gmail.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] kernel: rerun task_work while freezing in
 get_signal()
Message-ID: <20240708184814.GD27299@noisy.programming.kicks-ass.net>
References: <cover.1720368770.git.asml.silence@gmail.com>
 <1d935e9d87fd8672ef3e8a9a0db340d355ea08b4.1720368770.git.asml.silence@gmail.com>
 <20240708104221.GA18761@redhat.com>
 <62c11b59-c909-4c60-8370-77729544ec0a@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62c11b59-c909-4c60-8370-77729544ec0a@gmail.com>

On Mon, Jul 08, 2024 at 04:40:07PM +0100, Pavel Begunkov wrote:

> > > --- a/kernel/signal.c
> > > +++ b/kernel/signal.c
> > > @@ -2694,6 +2694,10 @@ bool get_signal(struct ksignal *ksig)
> > >   	try_to_freeze();
> > >   relock:
> > > +	clear_notify_signal();
> > > +	if (unlikely(task_work_pending(current)))
> > > +		task_work_run();
> > > +
> > >   	spin_lock_irq(&sighand->siglock);
> > 
> > Well, but can't we kill the same code at the start of get_signal() then?
> > Of course, in this case get_signal() should check signal_pending(), not
> > task_sigpending().
> 
> Should be fine, but I didn't want to change the
> try_to_freeze() -> __refrigerator() path, which also reschedules.
> 
> > Or perhaps something like the patch below makes more sense? I dunno...
> 
> It needs a far backporting, I'd really prefer to keep it
> lean and without more side effects if possible, unless
> there is a strong opinion on that.

It's been a minute since I dug my way through the signal code, but I
think I slightly favour Oleg's version for not duplicating that
task_work_run().


> > diff --git a/kernel/signal.c b/kernel/signal.c
> > index 1f9dd41c04be..e2ae85293fbb 100644
> > --- a/kernel/signal.c
> > +++ b/kernel/signal.c
> > @@ -2676,6 +2676,7 @@ bool get_signal(struct ksignal *ksig)
> >   	struct signal_struct *signal = current->signal;
> >   	int signr;
> > +start:
> >   	clear_notify_signal();
> >   	if (unlikely(task_work_pending(current)))
> >   		task_work_run();
> > @@ -2760,10 +2761,11 @@ bool get_signal(struct ksignal *ksig)
> >   			if (current->jobctl & JOBCTL_TRAP_MASK) {
> >   				do_jobctl_trap();
> >   				spin_unlock_irq(&sighand->siglock);
> > +				goto relock;
> >   			} else if (current->jobctl & JOBCTL_TRAP_FREEZE)
> >   				do_freezer_trap();
> > -
> > -			goto relock;
> > +				goto start;
> > +			}
> >   		}
> >   		/*
> > 
> 
> -- 
> Pavel Begunkov

