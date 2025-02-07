Return-Path: <io-uring+bounces-6296-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F390A2C4B6
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2025 15:11:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B3C3B188EAAF
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2025 14:09:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3E5D1FF1BA;
	Fri,  7 Feb 2025 14:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MrxOfN65"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8501FA26C;
	Fri,  7 Feb 2025 14:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738937217; cv=none; b=D96T3mw6ymAtBGiuD5+BSD2N0riW/lNmPfr+TlmIm7Vbmim1wXUq9I2foL+NlOPVs+aLg6/BB2cub5eTM1nyEaDXwh30DrDbkEFOu6Ts6lApFxVPLyXZFa3VTIs3W6kCzyvuW/wpW3+El9jpsL8NuOzwpc35RpH9yQXxtMR/80k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738937217; c=relaxed/simple;
	bh=fPWTilOrL7aPh85z0nXfD+x+D+4Yv1LN2RlZ4SMsXz8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rp/tYHDWCm6Sn88hDabQos06ZVlK1zrSB7LM4g4+CJIh0tWjNoh/4XWBzeBZ3sJXUtgmVlT7+xXi0wj/Z9tz+sjc6Cj1uIKYzhF7Fz+PeV3GytSo2LTxYWAvUlk4OlrSSBCmX80OVygooG/FlAC7cNrmXA19ysmQR0aMgnINLrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MrxOfN65; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE6E6C4CED1;
	Fri,  7 Feb 2025 14:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738937217;
	bh=fPWTilOrL7aPh85z0nXfD+x+D+4Yv1LN2RlZ4SMsXz8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MrxOfN65TeVdgDRtPciWuQIx37j00X6g1ManC7kBIkqdUMbFfngtUY7L4fc6V+Zd7
	 LS24zpvXvuy6zk4gBdHGQWthqecnswjgs9fUsOGRCyKjtOWsBNm7u1Z0DdfOSmy6SH
	 /uxnG+eIEQZxG4zo4LMbcSm5C8kHf7W4CL5sb+2zAcOb6/wIf7TkEhOQ4KYFBevQKp
	 Nlz92RUdj91yU8lMIGMxk98pPFKknzYUsQIjmjt7MQRIzxAnNawNo+Q51AbC3gZhJ+
	 YT713e89TbXqO4vSy4dothco3RV5bAUbgsnczKofMPjkCZdEmGFWb5qCOHemohoxW4
	 nKRrIrQ7DgRTw==
Date: Fri, 7 Feb 2025 07:06:54 -0700
From: Keith Busch <kbusch@kernel.org>
To: Ming Lei <ming.lei@redhat.com>
Cc: Keith Busch <kbusch@meta.com>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, axboe@kernel.dk,
	asml.silence@gmail.com
Subject: Re: [PATCH 0/6] ublk zero-copy support
Message-ID: <Z6YTfi29FcSQ1cSe@kbusch-mbp>
References: <20250203154517.937623-1-kbusch@meta.com>
 <Z6WDVdYxxQT4Trj8@fedora>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z6WDVdYxxQT4Trj8@fedora>

On Fri, Feb 07, 2025 at 11:51:49AM +0800, Ming Lei wrote:
> On Mon, Feb 03, 2025 at 07:45:11AM -0800, Keith Busch wrote:
> > 
> > The previous version from Ming can be viewed here:
> > 
> >   https://lore.kernel.org/linux-block/20241107110149.890530-1-ming.lei@redhat.com/
> > 
> > Based on the feedback from that thread, the desired io_uring interfaces
> > needed to be simpler, and the kernel registered resources need to behave
> > more similiar to user registered buffers.
> > 
> > This series introduces a new resource node type, KBUF, which, like the
> > BUFFER resource, needs to be installed into an io_uring buf_node table
> > in order for the user to access it in a fixed buffer command. The
> > new io_uring kernel API provides a way for a user to register a struct
> > request's bvec to a specific index, and a way to unregister it.
> > 
> > When the ublk server receives notification of a new command, it must
> > first select an index and register the zero copy buffer. It may use that
> > index for any number of fixed buffer commands, then it must unregister
> > the index when it's done. This can all be done in a single io_uring_enter
> > if desired, or it can be split into multiple enters if needed.
> 
> I suspect it may not be done in single io_uring_enter() because there
> is strict dependency among the three OPs(register buffer, read/write,
> unregister buffer).

The registration is synchronous. io_uring completes the SQE entirely
before it even looks at the read command in the next SQE.

The read or write is asynchronous, but it's prep takes a reference on
the node before moving on to the next SQE..

The unregister is synchronous, and clears the index node, but the
possibly inflight read or write has a reference on that node, so all
good.

> > +		ublk_get_sqe_three(q->ring_ptr, &reg, &read, &ureg);
> > +
> > +		io_uring_prep_buf_register(reg, 0, tag, q->q_id, tag);
> > +
> > +		io_uring_prep_read_fixed(read, 1 /*fds[1]*/,
> > +			0,
> > +			iod->nr_sectors << 9,
> > +			iod->start_sector << 9,
> > +			tag);
> > +		io_uring_sqe_set_flags(read, IOSQE_FIXED_FILE);
> > +		read->user_data = build_user_data(tag, ublk_op, 0, 1);
> 
> Does this interface support to read to partial buffer? Which is useful
> for stacking device cases.

Are you wanting to read into this buffer without copying in parts? As in
provide an offset and/or smaller length across multiple commands? If
that's what you mean, then yes, you can do that here.
 
> Also does this interface support to consume the buffer from multiple
> OPs concurrently? 

You can register as many kernel buffers from as many OPs as you have
space for in your table, and you can use them all concurrently. Pretty
much the same as user registered fixed buffers. The main difference from
user buffers is how you register them.

