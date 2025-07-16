Return-Path: <io-uring+bounces-8693-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EBF2DB07466
	for <lists+io-uring@lfdr.de>; Wed, 16 Jul 2025 13:14:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5FE44188AFEF
	for <lists+io-uring@lfdr.de>; Wed, 16 Jul 2025 11:14:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D77D2C15B9;
	Wed, 16 Jul 2025 11:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LL1/fcFv"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95802AE96;
	Wed, 16 Jul 2025 11:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752664448; cv=none; b=MB61LSw0TLFr27aMufVYj+i2ocPExD0VBNrXYK+7UP+Ep1V2Xa0AMvuYUBIcA3pNJ4T33VAUtqQnhWCaLrvAl5k+l0mCWKjgBC4FjwPysLbJDCBDfIRzHjjApOS+924TJTQdkpemV9CxqIat1OzUoXIEdQ4nsRA83HWQuasaih4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752664448; c=relaxed/simple;
	bh=J66qs/SXX72p0d4K0uZpcaeSmTq3Scy3eqJBX7RqLig=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j5NCJUkbplUTpG65mpRYfjRQNUvcKXBm9cVACr3+X4cD3Y3zYogVRxMEYPOtVQt02j/XC4VCk3UNNVWw6D14Q1ADD3YX2sQRNqV2Fs2kfD3G5Xzts5sKYz8TxhoiuhlIkBwUZWq781/JorsXdSrZhCnplC00xyeCZZ4ntQfD018=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LL1/fcFv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=cQP4FEYOudQe7oSNdm7jEn1TS7UAD20Psswd1K+XjMM=; b=LL1/fcFvUFVMocHUtmyWpc25s/
	tJlzwnIzZxP1lqD7JyrMcihcByFCdWwNaPkUIOrzDJB/IHCbcB0EhCKFhf/l5RCZysIm7HFrPp2VQ
	MLKDQ7r5Op4YLsGLCpqddEuZhQQW16zSZLfwYqGa2n81Qj1WwHdc0xBFNI5tZRtX5TgEv8PV1D1C0
	W5HPmRjpy99HkJYeioS5l7lB6CN2vCUvM6zCEzvrsQNpArOUbOlmy3mHjwNnOyM3zF1SrxnLqVIR6
	yCV7jMkMYoOfaIeAlrSUnRZB/kmMYuuuT7Djr2Ke8hXjn3zR0z5PTc8DPVAuuZqI7oN++C7a0n6CN
	M9NSriHw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uc05M-00000007WqV-1Cwh;
	Wed, 16 Jul 2025 11:14:04 +0000
Date: Wed, 16 Jul 2025 04:14:04 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>, Jens Axboe <axboe@kernel.dk>,
	parav@nvidia.com, Cosmin Ratio <cratiu@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Mina Almasry <almasrymina@google.com>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net: Allow SF devices to be used for ZC DMA
Message-ID: <aHeJfLYpkmwDvvN8@infradead.org>
References: <20250711092634.2733340-2-dtatulea@nvidia.com>
 <20250714181136.7fd53312@kernel.org>
 <aHXbgr67d1l5atW8@infradead.org>
 <20250715060649.03b3798c@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250715060649.03b3798c@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jul 15, 2025 at 06:06:49AM -0700, Jakub Kicinski wrote:
> On Mon, 14 Jul 2025 21:39:30 -0700 Christoph Hellwig wrote:
> > > LGTM, but we need a better place for this function. netdevice.h is
> > > included directly by 1.5k files, and indirectly by probably another 5k.
> > > It's not a great place to put random helpers with 2 callers. 
> > > Maybe net/netdev_rx_queue.h and net/core/netdev_rx_queue.c?
> > > I don't think it needs to be a static inline either.  
> > 
> > The whole concept is also buggy.  Trying to get a dma-able device by
> > walking down from an upper level construct like the netdevice can't work
> > reliably.  You'll need to explicitly provide the dma_device using either
> > a method or a pointer to it instead of this guesswork.
> 
> Yeah, I'm pretty sure we'll end up with a method in queue ops.
> But it's not that deep, an easy thing to change.

Why not get this right now instead of adding more of the hacky parent
walking?

