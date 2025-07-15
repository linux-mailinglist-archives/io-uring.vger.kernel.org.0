Return-Path: <io-uring+bounces-8674-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D5AB4B05062
	for <lists+io-uring@lfdr.de>; Tue, 15 Jul 2025 06:39:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 13EAC3A3606
	for <lists+io-uring@lfdr.de>; Tue, 15 Jul 2025 04:39:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 417E02D12E9;
	Tue, 15 Jul 2025 04:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xs6k6/Pk"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B0322129E;
	Tue, 15 Jul 2025 04:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752554377; cv=none; b=b146jhdP89orn9V6VYZ7oolXRwb7WcqPXpb3EOd9fCRjnk4pfc++han7l8a4/m9hVDorEqN0Zq9FM5p5ycRrPiC07PY1gp2g6kzhjGOV5ftydkLKhyAnrjYaXrH6Ka0Lz4T9fvxVfnlAab/uLSc6a2V4pdySBre19w+JOCBM2Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752554377; c=relaxed/simple;
	bh=lJw8vz1SW2vDWE1YFZRy4dIq8k+EPE779FMC38M1vHA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZiI0zZ4TfyWXcX14OpPbSA3YQIXb8lm7/VNs1v/pH/0Ttn3J6SeppjU8PVOzu/rlHtJsJJSs9zfbgNzkUWoSwodBCCR4/6NL60nd4jaiVJbnGSaLWfZqYDwFS/5IYq98uIsgQHDV/OagKjolA1ELOt0r1z/qTE1xztLYLZm1TmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xs6k6/Pk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=J+GVUJovTGLheWJo9RsseTUzw5AT5FZdGzH9Pyx6H7A=; b=xs6k6/PkChQ1ZJIV/Y6jeq3dST
	qJwzZ9uUHFnkjewyujcASeULgV/YCcryRGLbz2PlNu8uvbMT8rIfGRlLqfziq6/q4OB5+qXeqclOW
	pFi95+NlN5SSZoat5aMIoeN+R+WZZZLpMgKxokw5Q7v26FXN/cdChyYK/uB9YdhcuGD9AggyZF8db
	KIPBXizi0wowtmKD7gNintVz1kuR+X9emvt6UyNreBwZ7FGDxE0MahpoecPDg4alFEdcJFUlGhuZ/
	jhGXnnUFqszTXaAfSA1oDM2wBd0SQxXHQhA8FIvOHCaq/jRDM9WQ0ZU3SkFun+X+to9roA3DMKC1Z
	RsUfTeUw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ubXRy-000000041rO-1Ac2;
	Tue, 15 Jul 2025 04:39:30 +0000
Date: Mon, 14 Jul 2025 21:39:30 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Dragos Tatulea <dtatulea@nvidia.com>,
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
Message-ID: <aHXbgr67d1l5atW8@infradead.org>
References: <20250711092634.2733340-2-dtatulea@nvidia.com>
 <20250714181136.7fd53312@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250714181136.7fd53312@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jul 14, 2025 at 06:11:36PM -0700, Jakub Kicinski wrote:
> > +static inline struct device *netdev_get_dma_dev(const struct net_device *dev)
> > +{
> > +	struct device *dma_dev = dev->dev.parent;
> > +
> > +	if (!dma_dev)
> > +		return NULL;
> > +
> > +	/* Common case: dma device is parent device of netdev. */
> > +	if (dma_dev->dma_mask)
> > +		return dma_dev;
> > +
> > +	/* SF netdevs have an auxdev device as parent, the dma device being the
> > +	 * grandparent.
> > +	 */
> > +	dma_dev = dma_dev->parent;
> > +	if (dma_dev && dma_dev->dma_mask)
> > +		return dma_dev;
> > +
> > +	return NULL;
> > +}
> 
> LGTM, but we need a better place for this function. netdevice.h is
> included directly by 1.5k files, and indirectly by probably another 5k.
> It's not a great place to put random helpers with 2 callers. 
> Maybe net/netdev_rx_queue.h and net/core/netdev_rx_queue.c?
> I don't think it needs to be a static inline either.

The whole concept is also buggy.  Trying to get a dma-able device by
walking down from an upper level construct like the netdevice can't work
reliably.  You'll need to explicitly provide the dma_device using either
a method or a pointer to it instead of this guesswork.


