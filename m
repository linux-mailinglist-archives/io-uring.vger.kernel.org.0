Return-Path: <io-uring+bounces-10454-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 20870C4245E
	for <lists+io-uring@lfdr.de>; Sat, 08 Nov 2025 03:05:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C79D71896327
	for <lists+io-uring@lfdr.de>; Sat,  8 Nov 2025 02:05:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9338420FAB2;
	Sat,  8 Nov 2025 02:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eEV7lI2v"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6372D249EB;
	Sat,  8 Nov 2025 02:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762567495; cv=none; b=E68LOJo5lMKSdBYmFXbH+cEGgRKYQVP4BoPYYm9AHeaHxlRZPMaiEVCq2ROg78T+FMqTxHSTG5xw/TNtR7wOFkg6SR0+VNRD3EtLrAwTHppL61/MgeAdAqkBopduKxkGDdcVzAl1Pat4Z+yhKfJBcG/EmFxNTKUpZX6j8upnDxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762567495; c=relaxed/simple;
	bh=A3pw3Uws4FZADY+XV/OyRYWDL7iOaTifPSKlNij7irY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nFImNn4KnPiRZ79jyxRdt1q1s2fVrSIVJLJoMRegtcpA+Fk6vscMcuMcU3qOA+lFLiyA9wxFwhfJ4/fBcOcjSwPrV16vH59zJORlZsuxS48n68D6jbhtMtc5otwwt3GHjD3XTTrNeH3b+krJ3r/VaRsR+5CAj8XUL/MAtWH/2os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eEV7lI2v; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43482C19422;
	Sat,  8 Nov 2025 02:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762567495;
	bh=A3pw3Uws4FZADY+XV/OyRYWDL7iOaTifPSKlNij7irY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=eEV7lI2vd9vmThz2VkxS0lgZgpOPpnE4n6Xf69h83jIdSo4O9Um4w/9ITyIh81bYo
	 sgjGTq+rCn87XjDmDzLJE2sDT3Sjnj1sx4R1kDpVp/MQp8pearKzNZ72aE/CVrxw3v
	 rH7FBNnvqQ1I0P16AN9k0sy6qWJRyR2CxMsXhUwolfLJo1IZflM+eH2G3b/moiDZ+Z
	 ic4WUqvQ9lGmStcjUSqrSz07IUJo1e8BjHZH4CHV9kKKA4WpzQUC3bG3CG7mUFyO06
	 /rhHqDdwKoziT52hrtqjhOutQQFU95WQZll/lktGyuNbb+6UMz9obpzI8cM0hQZ9rK
	 AuRLaC/9qSCnw==
Date: Fri, 7 Nov 2025 18:04:53 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: Mina Almasry <almasrymina@google.com>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, Joshua Washington <joshwash@google.com>,
 Harshitha Ramamurthy <hramamurthy@google.com>, Andrew Lunn
 <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Jesper
 Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas
 <ilias.apalodimas@linaro.org>, Simon Horman <horms@kernel.org>, Willem de
 Bruijn <willemb@google.com>, ziweixiao@google.com, Vedant Mathur
 <vedantmathur@google.com>, io-uring@vger.kernel.org, David Wei
 <dw@davidwei.uk>
Subject: Re: [PATCH net v1 2/2] gve: use max allowed ring size for ZC
 page_pools
Message-ID: <20251107180453.17f0ed39@kernel.org>
In-Reply-To: <k3h635mirxo3wichhpxosw4hxvfu67khqs2jyna3muhhj5pmvm@4t2gypnckuri>
References: <20251105200801.178381-1-almasrymina@google.com>
	<20251105200801.178381-2-almasrymina@google.com>
	<20251105171142.13095017@kernel.org>
	<CAHS8izNg63A9W5GkGVgy0_v1U6_rPgCj1zu2_5QnUKcR9eTGFg@mail.gmail.com>
	<20251105182210.7630c19e@kernel.org>
	<CAHS8izP0y1t4LU3nBj4h=3zw126dMtMNHUiXASuqDNyVuyhFYQ@mail.gmail.com>
	<qhi7uuq52irirmviv3xex6h5tc4w4x6kcjwhqh735un3kpcx5x@2phgy3mnmg4p>
	<20251106171833.72fe18a9@kernel.org>
	<k3h635mirxo3wichhpxosw4hxvfu67khqs2jyna3muhhj5pmvm@4t2gypnckuri>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 7 Nov 2025 13:35:44 +0000 Dragos Tatulea wrote:
> On Thu, Nov 06, 2025 at 05:18:33PM -0800, Jakub Kicinski wrote:
> > On Thu, 6 Nov 2025 17:25:43 +0000 Dragos Tatulea wrote:  
> > > I see a similar issue with io_uring as well: for a 9K MTU with 4K ring
> > > size there are ~1% allocation errors during a simple zcrx test.
> > > 
> > > mlx5 calculates 16K pages and the io_uring zcrx buffer matches exactly
> > > that size (16K * 4K). Increasing the buffer doesn't help because the
> > > pool size is still what the driver asked for (+ also the
> > > internal pool limit). Even worse: eventually ENOSPC is returned to the
> > > application. But maybe this error has a different fix.  
> > 
> > Hm, yes, did you trace it all the way to where it comes from?
> > page pool itself does not have any ENOSPC AFAICT. If the cache
> > is full we free the page back to the provider via .release_netmem
> >  
> Yes I did. It happens in io_cqe_cache_refill() when there are no more
> CQEs:
> https://elixir.bootlin.com/linux/v6.17.7/source/io_uring/io_uring.c#L775
> 
> Looking at the code in zcrx I see that the amount of RQ entries and CQ
> entries is 4K, which matches the device ring size, but doesn't match the
> amount of pages available in the buffer:
> https://github.com/isilence/liburing/blob/zcrx/rx-buf-len/examples/zcrx.c#L410
> https://github.com/isilence/liburing/blob/zcrx/rx-buf-len/examples/zcrx.c#L176
> 
> Doubling the CQs (or both RQ and CQ size) makes the ENOSPC go away.
> 
> > > Adapting the pool size to the io_uring buffer size works very well. The
> > > allocation errors are gone and performance is improved.
> > > 
> > > AFAIU, a page_pool with underlying pre-allocated memory is not really a
> > > cache. So it is useful to be able to adapt to the capacity reserved by
> > > the application.
> > > 
> > > Maybe one could argue that the zcrx example from liburing could also be
> > > improved. But one thing is sure: aligning the buffer size to the
> > > page_pool size calculated by the driver based on ring size and MTU
> > > is a hassle. If the application provides a large enough buffer, things
> > > should "just work".  
> > 
> > Yes, there should be no ENOSPC. I think io_uring is more thorough
> > in handling the corner cases so what you're describing is more of 
> > a concern..
> 
> Is this error something that io_uring should fix or is this similar to
> EAGAIN where the application has to retry?

Not sure.. let me CC them.

> > Keep in mind that we expect multiple page pools from one provider.
> > We want the pages to flow back to the MP level so other PPs can grab
> > them.
> >  
> Oh, right, I forgot... And this can happen now only for devmem though,
> right?

Right, tho I think David is also working on some queue sharing?

> Still, this is an additional reason to give more control to the MP
> over the page_pool config, right?

This one I'm really not sure needs to be exposed via MP vs just
netdev-nl. But yes, I'd imagine the driver default may be sub-optimal
in either direction so giving user control over the sizing would be
good.

