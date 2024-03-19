Return-Path: <io-uring+bounces-1141-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 73ACF88003F
	for <lists+io-uring@lfdr.de>; Tue, 19 Mar 2024 16:09:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 23C051F2331C
	for <lists+io-uring@lfdr.de>; Tue, 19 Mar 2024 15:09:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22D516519D;
	Tue, 19 Mar 2024 15:09:03 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [185.203.201.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C29657AE
	for <io-uring@vger.kernel.org>; Tue, 19 Mar 2024 15:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.203.201.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710860943; cv=none; b=BPqHGqHH68FPyKlgtosNpDarjd/pzGiOUGwm803GB+FjzFxp46M2fy9X/fqPTpHwq0ogai+OxK0tturB6eLzp30AfjLeMiEInG6Z8/p5v1WdcteGzG69IG1oSEyw5JEFvbbgBYuAcevLhbiix2SAWCwepue2VTbgH5vMreRalUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710860943; c=relaxed/simple;
	bh=pWmA2TjVOlEO2nDeuR5LcVwVNFWlctcOHf43FvjyzdM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A2aR6ptV5f6ipJ1N7O1MUCusshSXadQm3FuDql5fRvFAH3eVNlHHMMIKtJMo/hqjyjppEq+2ERLK5AkXEYrOsa57XOGRHInqkXEfDP8A882Dk2ORvNAMF0VWK1+OVaS7kSD+W8+eNrsPwjm0ouiQPPLXcHehoMrRxPH4y7wWj7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de; spf=pass smtp.mailfrom=pengutronix.de; arc=none smtp.client-ip=185.203.201.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pengutronix.de
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <sha@pengutronix.de>)
	id 1rmb59-0000Nj-9F; Tue, 19 Mar 2024 16:08:51 +0100
Received: from [2a0a:edc0:2:b01:1d::c5] (helo=pty.whiteo.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <sha@pengutronix.de>)
	id 1rmb58-007Ifk-GO; Tue, 19 Mar 2024 16:08:50 +0100
Received: from sha by pty.whiteo.stw.pengutronix.de with local (Exim 4.96)
	(envelope-from <sha@pengutronix.de>)
	id 1rmb58-0074Jh-1M;
	Tue, 19 Mar 2024 16:08:50 +0100
Date: Tue, 19 Mar 2024 16:08:50 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: netdev@vger.kernel.org, kernel@pengutronix.de,
	linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
	Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: Re: [PATCH] net: Do not break out of sk_stream_wait_memory() with
 TIF_NOTIFY_SIGNAL
Message-ID: <ZfmqgvKqBtKr54Li@pengutronix.de>
References: <20240315100159.3898944-1-s.hauer@pengutronix.de>
 <7b82679f-9b69-4568-a61d-03eb1e4afc18@gmail.com>
 <ZfgvNjWP8OYMIa3Y@pengutronix.de>
 <0a556650-9627-48ee-9707-05d7cab33f0f@gmail.com>
 <Zflt3EVf744LOA6i@pengutronix.de>
 <bfc6afa9-501f-40b6-929a-3aa8c0298265@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bfc6afa9-501f-40b6-929a-3aa8c0298265@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: io-uring@vger.kernel.org

On Tue, Mar 19, 2024 at 01:55:21PM +0000, Pavel Begunkov wrote:
> On 3/19/24 10:50, Sascha Hauer wrote:
> > On Mon, Mar 18, 2024 at 01:19:19PM +0000, Pavel Begunkov wrote:
> > > On 3/18/24 12:10, Sascha Hauer wrote:
> > > > On Fri, Mar 15, 2024 at 05:02:05PM +0000, Pavel Begunkov wrote:
> > > > > On 3/15/24 10:01, Sascha Hauer wrote:
> > > > > > It can happen that a socket sends the remaining data at close() time.
> > > > > > With io_uring and KTLS it can happen that sk_stream_wait_memory() bails
> > > > > > out with -512 (-ERESTARTSYS) because TIF_NOTIFY_SIGNAL is set for the
> > > > > > current task. This flag has been set in io_req_normal_work_add() by
> > > > > > calling task_work_add().
> > > > > 
> > > > > The entire idea of task_work is to interrupt syscalls and let io_uring
> > > > > do its job, otherwise it wouldn't free resources it might be holding,
> > > > > and even potentially forever block the syscall.
> > > > > 
> > > > > I'm not that sure about connect / close (are they not restartable?),
> > > > > but it doesn't seem to be a good idea for sk_stream_wait_memory(),
> > > > > which is the normal TCP blocking send path. I'm thinking of some kinds
> > > > > of cases with a local TCP socket pair, the tx queue is full as well
> > > > > and the rx queue of the other end, and io_uring has to run to receive
> > > > > the data.
> > > 
> > > There is another case, let's say the IO is done via io-wq
> > > (io_uring's worker thread pool) and hits the waiting. Now the
> > > request can't get cancelled, which is done by interrupting the
> > > task with TIF_NOTIFY_SIGNAL. User requested request cancellations
> > > is one thing, but we'd need to check if io_uring can ever be closed
> > > in this case.
> > > 
> > > 
> > > > > If interruptions are not welcome you can use different io_uring flags,
> > > > > see IORING_SETUP_COOP_TASKRUN and/or IORING_SETUP_DEFER_TASKRUN.
> > > > 
> > > > I tried with different combinations of these flags. For example
> > > > IORING_SETUP_TASKRUN_FLAG | IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN
> > > > makes the issue less likely, but nevertheless it still happens.
> > > > 
> > > > However, reading the documentation of these flags, they shall provide
> > > > hints to the kernel for optimizations, but it should work without these
> > > > flags, right?
> > > 
> > > That's true, and I guess there are other cases as well, like
> > > io-wq and perhaps even a stray fput.
> > > 
> > > 
> > > > > Maybe I'm missing something, why not restart your syscall?
> > > > 
> > > > The problem comes with TLS. Normally with synchronous encryption all
> > > > data on a socket is written during write(). When asynchronous
> > > > encryption comes into play, then not all data is written during write(),
> > > > but instead the remaining data is written at close() time.
> > > 
> > > Was it considered to do the final cleanup in workqueue
> > > and only then finalising the release?
> > 
> > No, but I don't really understand what you mean here. Could you
> > elaborate?
> 
> The suggestion is instead of executing the release and that final
> flush off of the context you're in, namely userspace task,
> you can spin up a kernel task (they're not getting any signals)
> and execute it from there.
> 
> void deferred_release_fn(struct work_struct *work)
> {
> 	do_release();
> 	...
> }
> 
> struct work_struct work;
> INIT_WORK(&work, deferred_release_fn);
> queue_work(system_unbound_wq, &work);
> 
> 
> There is a catch. Even though close() is not obliged to close
> the file / socket immediately, but it still not nice when you
> drop the final ref but port and other bits are not released
> until some time after. So, you might want to wait for that
> deferred release to complete before returning to the
> userspace.
> 
> I'm assuming it's fine to run it by a kernel task since
> IIRC fput might delay release to it anyway, but it's better
> to ask net maintainers. In theory it shouldn't need
> mm,fs,etc that user task would hold.

Ok, I'll have a look into it. Thanks for your input.

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

