Return-Path: <io-uring+bounces-2191-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CFF4690577C
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 17:55:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 827731F28AEC
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 15:55:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E927017FAA4;
	Wed, 12 Jun 2024 15:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tBfOSzNs"
X-Original-To: io-uring@vger.kernel.org
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BFD517F505
	for <io-uring@vger.kernel.org>; Wed, 12 Jun 2024 15:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718207712; cv=none; b=mmUIqQpy3xskAaqVmVjS1Sb0rCr9h//vLMqIQkFMsAM0PwUKhCXwLJBLYLiPgy5tPsia+AI+5OQPjZiT3yaXprvme3RSLDRtfB4Wh7qSePCSu3TIfNl1tAnPsrg0wYg31vqUzW27Oy+U5KocpIx1lSE5ofyBvHe77XgZ1C/TfEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718207712; c=relaxed/simple;
	bh=tQ6eaUMy/U4jhIuannuweep0uBcOKLnG1LqdwHEAHeA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qd07USDww8IedLdoTWZLmBZWH1yphZ97Qx2kbyvv4N1YHKwImffr01cYtA1CYCc8YMGRkX2+er2z3j1CGNLyuJDOdcmN371XOqRXBfX2FYJpPcuX6uUgqrtclP0OilHGk+foP80IAKnOHV0FxmOkPasNxu2rL/8wj/IEmzjmY44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tBfOSzNs; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: bschubert@ddn.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718207708;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AvL1Mr0Fm0dZcOgqN+9E74/tJ0v+sK2Qs50nD6yxG/I=;
	b=tBfOSzNsZtHuam2LcfyThM1Q7QYdjTEHsJ+upKwR+o01BtIwjefYnW2l8sf0lsdEvqF4n9
	qheOfzV5uZffa+YyyKdgv7hc8pkSAp+UaKILQWP4YSRBhhSHszgcqN0NHEQaUSWace0JSo
	pSarQHVvr7YBAoBr/hL2cMkf4WQk+sE=
X-Envelope-To: bernd.schubert@fastmail.fm
X-Envelope-To: miklos@szeredi.hu
X-Envelope-To: amir73il@gmail.com
X-Envelope-To: linux-fsdevel@vger.kernel.org
X-Envelope-To: akpm@linux-foundation.org
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: mingo@redhat.com
X-Envelope-To: peterz@infradead.org
X-Envelope-To: avagin@google.com
X-Envelope-To: io-uring@vger.kernel.org
Date: Wed, 12 Jun 2024 11:55:03 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Bernd Schubert <bschubert@ddn.com>
Cc: Bernd Schubert <bernd.schubert@fastmail.fm>, 
	Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrei Vagin <avagin@google.com>, 
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Re: [PATCH RFC v2 00/19] fuse: fuse-over-io-uring
Message-ID: <hhkehi7qlcjulhyvtd5j25cl3xw764cjk7tbsakf3ueerdhp3j@6d2nka5oalzn>
References: <20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com>
 <CAJfpegurSNV3Tw1oKWL1DgnR-tST-JxSAxvTuK2jirm+L-odeQ@mail.gmail.com>
 <99d13ae4-8250-4308-b86d-14abd1de2867@fastmail.fm>
 <CAJfpegu7VwDEBsUG_ERLsN58msXUC14jcxRT_FqL53xm8FKcdg@mail.gmail.com>
 <62ecc4cf-97c8-43e6-84a1-72feddf07d29@fastmail.fm>
 <im6hqczm7qpr3oxndwupyydnclzne6nmpidln6wee4cer7i6up@hmpv4juppgii>
 <a5ab3ea8-f730-4087-a9ea-b3ac4c8e7919@fastmail.fm>
 <olaitdmh662osparvdobr267qgjitygkl7lt7zdiyyi6ee6jlc@xaashssdxwxm>
 <4e5a84ab-4aa5-4d8b-aa12-625082d92073@ddn.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e5a84ab-4aa5-4d8b-aa12-625082d92073@ddn.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jun 12, 2024 at 03:40:14PM GMT, Bernd Schubert wrote:
> On 6/12/24 16:19, Kent Overstreet wrote:
> > On Wed, Jun 12, 2024 at 03:53:42PM GMT, Bernd Schubert wrote:
> >> I will definitely look at it this week. Although I don't like the idea
> >> to have a new kthread. We already have an application thread and have
> >> the fuse server thread, why do we need another one?
> > 
> > Ok, I hadn't found the fuse server thread - that should be fine.
> > 
> >>>
> >>> The next thing I was going to look at is how you guys are using splice,
> >>> we want to get away from that too.
> >>
> >> Well, Ming Lei is working on that for ublk_drv and I guess that new approach
> >> could be adapted as well onto the current way of io-uring.
> >> It _probably_ wouldn't work with IORING_OP_READV/IORING_OP_WRITEV.
> >>
> >> https://lore.gnuweeb.org/io-uring/20240511001214.173711-6-ming.lei@redhat.com/T/
> >>
> >>>
> >>> Brian was also saying the fuse virtio_fs code may be worth
> >>> investigating, maybe that could be adapted?
> >>
> >> I need to check, but really, the majority of the new additions
> >> is just to set up things, shutdown and to have sanity checks.
> >> Request sending/completing to/from the ring is not that much new lines.
> > 
> > What I'm wondering is how read/write requests are handled. Are the data
> > payloads going in the same ringbuffer as the commands? That could work,
> > if the ringbuffer is appropriately sized, but alignment is a an issue.
> 
> That is exactly the big discussion Miklos and I have. Basically in my
> series another buffer is vmalloced, mmaped and then assigned to ring entries.
> Fuse meta headers and application payload goes into that buffer.
> In both kernel/userspace directions. io-uring only allows 80B, so only a
> really small request would fit into it.

Well, the generic ringbuffer would lift that restriction.

> Legacy /dev/fuse has an alignment issue as payload follows directly as the fuse
> header - intrinsically fixed in the ring patches.

*nod*

That's the big question, put the data inline (with potential alignment
hassles) or manage (and map) a separate data structure.

Maybe padding could be inserted to solve alignment?

A separate data structure would only really be useful if it enabled zero
copy, but that should probably be a secondary enhancement.

> I will now try without mmap and just provide a user buffer as pointer in the 80B
> section.
> 
> 
> > 
> > We just looked up the device DMA requirements and with modern NVME only
> > 4 byte alignment is required, but the block layer likely isn't set up to
> > handle that.
> 
> I think existing fuse headers have and their data have a 4 byte alignment.
> Maybe even 8 byte, I don't remember without looking through all request types.
> If you try a simple O_DIRECT read/write to libfuse/example_passthrough_hp
> without the ring patches it will fail because of alignment. Needs to be fixed
> in legacy fuse and would also avoid compat issues we had in libfuse when the
> kernel header was updated.
> 
> > 
> > So - prearranged buffer? Or are you using splice to get pages that
> > userspace has read into into the kernel pagecache?
> 
> I didn't even try to use splice yet, because for the DDN (my employer) use case
> we cannot use  zero copy, at least not without violating the rule that one
> cannot access the application buffer in userspace.

DDN - lustre related?

> 
> I will definitely look into Mings work, as it will be useful for others.
> 
> 
> Cheers,
> Bernd

