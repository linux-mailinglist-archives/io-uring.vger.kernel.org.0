Return-Path: <io-uring+bounces-3849-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BC3C9A6D81
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 17:02:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C19CB1C220DB
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 15:02:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A7E345005;
	Mon, 21 Oct 2024 15:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eHx0tdqc"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231C5433BB;
	Mon, 21 Oct 2024 15:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729522955; cv=none; b=oHKVer0I6Vch6cTiCOiBJGrnMTyPcYBhBzfVT7qspIUceVnVzvLtpKUv6qZVJkv7T4CFg1i98yus66BR5ibsZktpZIja6G9pnWoN4U4PNtNNTS36s6nksP81f8SMzzRcKi/PYwhNXToLbbdFEtXZiB/BDmSf0t9LB9OTH3V/V64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729522955; c=relaxed/simple;
	bh=ivc/NfFpIbuGRB4e7IdO3MFJVP/dJCSBQVsvP8nDRjQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yf9x8rWxKjIB3mk/6X0vMQnKw0s2tFfn1KxqMyDWvmLUamDvq0PTPFGVw5+2fizeY1K7aAsU9nE9KHFpoJi+0i/fxOaw6gFqOxcXdQkL8Jg1A/K0O8BHn+Ws2990Wl+zEgSk7HDkg3aVa9sD+XYYDoh2FkIlUjUH0WMw0G9rhQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eHx0tdqc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4832EC4CEC3;
	Mon, 21 Oct 2024 15:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729522954;
	bh=ivc/NfFpIbuGRB4e7IdO3MFJVP/dJCSBQVsvP8nDRjQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eHx0tdqcLsCN6ZYjBhiW2ta6o+5/39EOcU5LbPsZdTPJDcBWiIY023jVthh2WAV1L
	 c+lE3wKMeTbMobExWq41ouI/1r5ArXwUeDzDTwrFmuTlVb2RuEoOC6oMHJv2ctoTKS
	 7b0BpYbjaBZ8Ddg8whr8WxaXj5pgJqstJkXO+B9BjAkg2Zv7i7Fu6Ok1HD5tWVJ1ob
	 PoAhcqKnZWM1AsuzHmS/84+vB3B8kypDbYsoXvRipatkmbfIB5UHdkXFPJWnf3A0Z+
	 rHIyCkNVPY79YXzNAKdoYQ3f5TiVmRN14ECBeL9G5uLsU82JNfTAlt0fbpK7pGbDiw
	 V9PZqczIRrdXw==
Date: Mon, 21 Oct 2024 09:02:32 -0600
From: Keith Busch <kbusch@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, axboe@kernel.dk, hch@lst.de,
	io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	joshi.k@samsung.com, javier.gonz@samsung.com
Subject: Re: [PATCHv8 3/6] block: introduce max_write_hints queue limit
Message-ID: <ZxZtCFNvPlIE8xgV@kbusch-mbp>
References: <20241017160937.2283225-1-kbusch@meta.com>
 <20241017160937.2283225-4-kbusch@meta.com>
 <57798ab7-fc67-4606-900e-d221e028bd8f@acm.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57798ab7-fc67-4606-900e-d221e028bd8f@acm.org>

On Fri, Oct 18, 2024 at 09:18:34AM -0700, Bart Van Assche wrote:
> On 10/17/24 9:09 AM, Keith Busch wrote:
> > Drivers with hardware that support write hints need a way to export how
> > many are available so applications can generically query this.
> 
> Something is missing from this patch, namely a change for the SCSI disk
> (sd) driver that sets max_write_hints to sdkp->permanent_stream_count.

Shouldn't someone who cares about scsi do that? I certainly don't care,
nor have I been keeping up with what's happening there, so I'm also
unqualified.
 
> > +What:		/sys/block/<disk>/queue/max_write_hints
> > +Date:		October 2024
> > +Contact:	linux-block@vger.kernel.org
> > +Description:
> > +		[RO] Maximum number of write hints supported, 0 if not
> > +		supported. If supported, valid values are 1 through
> > +		max_write_hints, inclusive.
> 
> That's a bit short. I think it would help to add a reference to the
> aspects of the standards related to this attribute: permanent streams
> for SCSI and FDP for NVMe.

The specs regarding write hints have not historically been stable, so
I'd rather not tie kernel docs to volatile external specifications.

> > diff --git a/block/blk-settings.c b/block/blk-settings.c
> > index a446654ddee5e..921fb4d334fa4 100644
> > --- a/block/blk-settings.c
> > +++ b/block/blk-settings.c
> > @@ -43,6 +43,7 @@ void blk_set_stacking_limits(struct queue_limits *lim)
> >   	lim->seg_boundary_mask = BLK_SEG_BOUNDARY_MASK;
> >   	/* Inherit limits from component devices */
> > +	lim->max_write_hints = USHRT_MAX;
> >   	lim->max_segments = USHRT_MAX;
> >   	lim->max_discard_segments = USHRT_MAX;
> >   	lim->max_hw_sectors = UINT_MAX;
> > @@ -544,6 +545,8 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
> >   	t->max_segment_size = min_not_zero(t->max_segment_size,
> >   					   b->max_segment_size);
> > +	t->max_write_hints = min(t->max_write_hints, b->max_write_hints);
> > +
> >   	alignment = queue_limit_alignment_offset(b, start);
> 
> I prefer that lim->max_write_hints is initialized to zero in
> blk_set_stacking_limits() and that blk_stack_limits() uses
> min_not_zero().

How is a device supposed to report it doesn't support a write hint if 0
gets overridden?

