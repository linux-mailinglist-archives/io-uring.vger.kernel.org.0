Return-Path: <io-uring+bounces-1079-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49EC687E1E4
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 02:49:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 68DB01C212A6
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 01:49:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D63F1BF3F;
	Mon, 18 Mar 2024 01:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gVNvpeTh"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FBFF18029
	for <io-uring@vger.kernel.org>; Mon, 18 Mar 2024 01:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710726560; cv=none; b=MGKFw88tiYZlZUYAlwhIvyP6D8eFtvSvCanfTuOxuWYWJ82/15yWfjVvbbp7zBrLqkzh58pZFICnzuP6vDFkfIrPO7/Sz9eAVFrsw+YuF9XLplBwCp/SR/V3j2BWq2IFIRnuWhWiqY1PzSkcn2u7zCCgn3Zzv9UZAwMilkpSU/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710726560; c=relaxed/simple;
	bh=jG3xS6FB14/BqpnkTLu7XTnaVi6tPktlEZIbV9PseDA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CQGZ6AAdBpOL7pVqlkmhwWQu2tCB/V+QGnMINFraqskk2ZXpQ6HrlTTFK9SC5S28OTIDo4kPZgZB9pT1tkTgczhvE+2WlSiFR47b85qi7wcxxT94WaDUsLwrCbH9BJCPhEJbog3+VDyhmk3hZvm8uh7ndqxjhwoLctPBUntsguQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gVNvpeTh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710726556;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+ctfX1Pcy3C62ECD/GzywN9cG0bYGgeVBmlLdHU0fSU=;
	b=gVNvpeThAf3UXLCPN43UhwagNMvSKg6iHKwVrZdqBwb+udAdva18Cl9WNPftQvVoZx5XGQ
	BZPiSLhbWxRhU+VlntLpZxWPQZ94MU/OXMsZ/ZRySmv8oHKKKuLcPzaqaR5kZ52lptg3o/
	9acG6ccxh/Y7aQ9pGfKFX2yPjhe5VqY=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-170-tvWW_aEPMSuIUPvXf4YhQw-1; Sun,
 17 Mar 2024 21:49:12 -0400
X-MC-Unique: tvWW_aEPMSuIUPvXf4YhQw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A9D11285F99C;
	Mon, 18 Mar 2024 01:49:11 +0000 (UTC)
Received: from fedora (unknown [10.72.116.15])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9D8E8112132A;
	Mon, 18 Mar 2024 01:49:08 +0000 (UTC)
Date: Mon, 18 Mar 2024 09:49:00 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: (subset) [PATCH 00/11] remove aux CQE caches
Message-ID: <ZfedjMPDXp7q8t/D@fedora>
References: <e25412ba-916c-4de7-8ed2-18268f656731@kernel.dk>
 <d3beeb72-c4cf-4fad-80bc-10ca1f035fff@gmail.com>
 <4787bb12-bb89-490a-9d30-40b4f54a19ad@kernel.dk>
 <6dea0285-254d-4985-982b-39f3897bf064@gmail.com>
 <2091c056-d5ed-44e3-a163-b95680cece27@gmail.com>
 <d016a590-d7a9-405f-a2e4-d7c4ffa80fce@kernel.dk>
 <4c47f80f-df74-4b27-b1e7-ce30d5c959f9@kernel.dk>
 <4320d059-0308-42c3-b01f-18107885ffbd@kernel.dk>
 <ZfeHmNtoTo9nvTaV@fedora>
 <1e05aee5-4166-4e5d-9b76-94e1d833ab17@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e05aee5-4166-4e5d-9b76-94e1d833ab17@kernel.dk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

On Sun, Mar 17, 2024 at 07:34:30PM -0600, Jens Axboe wrote:
> On 3/17/24 6:15 PM, Ming Lei wrote:
> > On Sun, Mar 17, 2024 at 04:24:07PM -0600, Jens Axboe wrote:
> >> On 3/17/24 4:07 PM, Jens Axboe wrote:
> >>> On 3/17/24 3:51 PM, Jens Axboe wrote:
> >>>> On 3/17/24 3:47 PM, Pavel Begunkov wrote:
> >>>>> On 3/17/24 21:34, Pavel Begunkov wrote:
> >>>>>> On 3/17/24 21:32, Jens Axboe wrote:
> >>>>>>> On 3/17/24 3:29 PM, Pavel Begunkov wrote:
> >>>>>>>> On 3/17/24 21:24, Jens Axboe wrote:
> >>>>>>>>> On 3/17/24 2:55 PM, Pavel Begunkov wrote:
> >>>>>>>>>> On 3/16/24 13:56, Ming Lei wrote:
> >>>>>>>>>>> On Sat, Mar 16, 2024 at 01:27:17PM +0000, Pavel Begunkov wrote:
> >>>>>>>>>>>> On 3/16/24 11:52, Ming Lei wrote:
> >>>>>>>>>>>>> On Fri, Mar 15, 2024 at 04:53:21PM -0600, Jens Axboe wrote:
> >>>>>>>>>>>
> >>>>>>>>>>> ...
> >>>>>>>>>>>
> >>>>>>>>>>>>> The following two error can be triggered with this patchset
> >>>>>>>>>>>>> when running some ublk stress test(io vs. deletion). And not see
> >>>>>>>>>>>>> such failures after reverting the 11 patches.
> >>>>>>>>>>>>
> >>>>>>>>>>>> I suppose it's with the fix from yesterday. How can I
> >>>>>>>>>>>> reproduce it, blktests?
> >>>>>>>>>>>
> >>>>>>>>>>> Yeah, it needs yesterday's fix.
> >>>>>>>>>>>
> >>>>>>>>>>> You may need to run this test multiple times for triggering the problem:
> >>>>>>>>>>
> >>>>>>>>>> Thanks for all the testing. I've tried it, all ublk/generic tests hang
> >>>>>>>>>> in userspace waiting for CQEs but no complaints from the kernel.
> >>>>>>>>>> However, it seems the branch is buggy even without my patches, I
> >>>>>>>>>> consistently (5-15 minutes of running in a slow VM) hit page underflow
> >>>>>>>>>> by running liburing tests. Not sure what is that yet, but might also
> >>>>>>>>>> be the reason.
> >>>>>>>>>
> >>>>>>>>> Hmm odd, there's nothing in there but your series and then the
> >>>>>>>>> io_uring-6.9 bits pulled in. Maybe it hit an unfortunate point in the
> >>>>>>>>> merge window -git cycle? Does it happen with io_uring-6.9 as well? I
> >>>>>>>>> haven't seen anything odd.
> >>>>>>>>
> >>>>>>>> Need to test io_uring-6.9. I actually checked the branch twice, both
> >>>>>>>> with the issue, and by full recompilation and config prompts I assumed
> >>>>>>>> you pulled something in between (maybe not).
> >>>>>>>>
> >>>>>>>> And yeah, I can't confirm it's specifically an io_uring bug, the
> >>>>>>>> stack trace is usually some unmap or task exit, sometimes it only
> >>>>>>>> shows when you try to shutdown the VM after tests.
> >>>>>>>
> >>>>>>> Funky. I just ran a bunch of loops of liburing tests and Ming's ublksrv
> >>>>>>> test case as well on io_uring-6.9 and it all worked fine. Trying
> >>>>>>> liburing tests on for-6.10/io_uring as well now, but didn't see anything
> >>>>>>> the other times I ran it. In any case, once you repost I'll rebase and
> >>>>>>> then let's see if it hits again.
> >>>>>>>
> >>>>>>> Did you run with KASAN enabled
> >>>>>>
> >>>>>> Yes, it's a debug kernel, full on KASANs, lockdeps and so
> >>>>>
> >>>>> And another note, I triggered it once (IIRC on shutdown) with ublk
> >>>>> tests only w/o liburing/tests, likely limits it to either the core
> >>>>> io_uring infra or non-io_uring bugs.
> >>>>
> >>>> Been running on for-6.10/io_uring, and the only odd thing I see is that
> >>>> the test output tends to stall here:
> >>>>
> >>>> Running test read-before-exit.t
> >>>>
> >>>> which then either leads to a connection disconnect from my ssh into that
> >>>> vm, or just a long delay and then it picks up again. This did not happen
> >>>> with io_uring-6.9.
> >>>>
> >>>> Maybe related? At least it's something new. Just checked again, and yeah
> >>>> it seems to totally lock up the vm while that is running. Will try a
> >>>> quick bisect of that series.
> >>>
> >>> Seems to be triggered by the top of branch patch in there, my poll and
> >>> timeout special casing. While the above test case runs with that commit,
> >>> it'll freeze the host.
> >>
> >> Had a feeling this was the busy looping off cancelations, and flushing
> >> the fallback task_work seems to fix it. I'll check more tomorrow.
> >>
> >>
> >> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> >> index a2cb8da3cc33..f1d3c5e065e9 100644
> >> --- a/io_uring/io_uring.c
> >> +++ b/io_uring/io_uring.c
> >> @@ -3242,6 +3242,8 @@ static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
> >>  	ret |= io_kill_timeouts(ctx, task, cancel_all);
> >>  	if (task)
> >>  		ret |= io_run_task_work() > 0;
> >> +	else if (ret)
> >> +		flush_delayed_work(&ctx->fallback_work);
> >>  	return ret;
> >>  }
> > 
> > Still can trigger the warning with above patch:
> > 
> > [  446.275975] ------------[ cut here ]------------
> > [  446.276340] WARNING: CPU: 8 PID: 731 at kernel/fork.c:969 __put_task_struct+0x10c/0x180
> 
> And this is running that test case you referenced? I'll take a look, as
> it seems related to the poll kill rather than the other patchset.

Yeah, and now I am running 'git bisect' on Pavel's V2.

thanks,
Ming


