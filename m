Return-Path: <io-uring+bounces-1137-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D813587FC2E
	for <lists+io-uring@lfdr.de>; Tue, 19 Mar 2024 11:50:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 781271F2303D
	for <lists+io-uring@lfdr.de>; Tue, 19 Mar 2024 10:50:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEDB37E56F;
	Tue, 19 Mar 2024 10:50:15 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [185.203.201.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8DA7E115
	for <io-uring@vger.kernel.org>; Tue, 19 Mar 2024 10:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.203.201.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710845415; cv=none; b=cXlAS4Wokh3UMex6SyAwcZ4FKZuwc9CUFACcbilhYuL+IqTjbaxKQ9gIrqpPFwsx2nD1ggrMuL7WQqphUM7EiMpI5azl0UZ4gny2BLRQqBzmc8mHoy/s5Kx0ZNTnOQGvw9/gpS0JKDw10YPda1gNJQfq4fLVxem6SY44jQuh8Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710845415; c=relaxed/simple;
	bh=xqv4EgS8mHvM2qs+1DYNGILQWcWFrc1cXZ0pMI0SaDU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nCj1h3f57NI5+GHQlAllUU5JGnwQh82kTYBjtIxSoCzFP3ICX6T90jaTqR+RmszJhw7Zx5uLTgu9ZHNhrZZar1Jkwo8/EjNndCKOPha+jVxaEgip3aYDBAb/ZNEFGCpbWTBwlpnWPoblFuDGihdHdISSA2RgnksIldqFX9EYvKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de; spf=pass smtp.mailfrom=pengutronix.de; arc=none smtp.client-ip=185.203.201.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pengutronix.de
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <sha@pengutronix.de>)
	id 1rmX2i-0001N5-V2; Tue, 19 Mar 2024 11:50:04 +0100
Received: from [2a0a:edc0:2:b01:1d::c5] (helo=pty.whiteo.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <sha@pengutronix.de>)
	id 1rmX2i-007FuF-7o; Tue, 19 Mar 2024 11:50:04 +0100
Received: from sha by pty.whiteo.stw.pengutronix.de with local (Exim 4.96)
	(envelope-from <sha@pengutronix.de>)
	id 1rmX2i-0070ad-0V;
	Tue, 19 Mar 2024 11:50:04 +0100
Date: Tue, 19 Mar 2024 11:50:04 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: netdev@vger.kernel.org, kernel@pengutronix.de,
	linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
	Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: Re: [PATCH] net: Do not break out of sk_stream_wait_memory() with
 TIF_NOTIFY_SIGNAL
Message-ID: <Zflt3EVf744LOA6i@pengutronix.de>
References: <20240315100159.3898944-1-s.hauer@pengutronix.de>
 <7b82679f-9b69-4568-a61d-03eb1e4afc18@gmail.com>
 <ZfgvNjWP8OYMIa3Y@pengutronix.de>
 <0a556650-9627-48ee-9707-05d7cab33f0f@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a556650-9627-48ee-9707-05d7cab33f0f@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: io-uring@vger.kernel.org

On Mon, Mar 18, 2024 at 01:19:19PM +0000, Pavel Begunkov wrote:
> On 3/18/24 12:10, Sascha Hauer wrote:
> > On Fri, Mar 15, 2024 at 05:02:05PM +0000, Pavel Begunkov wrote:
> > > On 3/15/24 10:01, Sascha Hauer wrote:
> > > > It can happen that a socket sends the remaining data at close() time.
> > > > With io_uring and KTLS it can happen that sk_stream_wait_memory() bails
> > > > out with -512 (-ERESTARTSYS) because TIF_NOTIFY_SIGNAL is set for the
> > > > current task. This flag has been set in io_req_normal_work_add() by
> > > > calling task_work_add().
> > > 
> > > The entire idea of task_work is to interrupt syscalls and let io_uring
> > > do its job, otherwise it wouldn't free resources it might be holding,
> > > and even potentially forever block the syscall.
> > > 
> > > I'm not that sure about connect / close (are they not restartable?),
> > > but it doesn't seem to be a good idea for sk_stream_wait_memory(),
> > > which is the normal TCP blocking send path. I'm thinking of some kinds
> > > of cases with a local TCP socket pair, the tx queue is full as well
> > > and the rx queue of the other end, and io_uring has to run to receive
> > > the data.
> 
> There is another case, let's say the IO is done via io-wq
> (io_uring's worker thread pool) and hits the waiting. Now the
> request can't get cancelled, which is done by interrupting the
> task with TIF_NOTIFY_SIGNAL. User requested request cancellations
> is one thing, but we'd need to check if io_uring can ever be closed
> in this case.
> 
> 
> > > If interruptions are not welcome you can use different io_uring flags,
> > > see IORING_SETUP_COOP_TASKRUN and/or IORING_SETUP_DEFER_TASKRUN.
> > 
> > I tried with different combinations of these flags. For example
> > IORING_SETUP_TASKRUN_FLAG | IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN
> > makes the issue less likely, but nevertheless it still happens.
> > 
> > However, reading the documentation of these flags, they shall provide
> > hints to the kernel for optimizations, but it should work without these
> > flags, right?
> 
> That's true, and I guess there are other cases as well, like
> io-wq and perhaps even a stray fput.
> 
> 
> > > Maybe I'm missing something, why not restart your syscall?
> > 
> > The problem comes with TLS. Normally with synchronous encryption all
> > data on a socket is written during write(). When asynchronous
> > encryption comes into play, then not all data is written during write(),
> > but instead the remaining data is written at close() time.
> 
> Was it considered to do the final cleanup in workqueue
> and only then finalising the release?

No, but I don't really understand what you mean here. Could you
elaborate?

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

