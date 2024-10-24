Return-Path: <io-uring+bounces-3986-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 325C09AEB69
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 18:06:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 559371C2236A
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 16:06:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E008E1F76BE;
	Thu, 24 Oct 2024 16:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fkgo90sr"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156A01E1311;
	Thu, 24 Oct 2024 16:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729785989; cv=none; b=edAAL6hfSBWxrt7tc2VeyvkfNNnvKFwjvi9QPgOFpvwDKpKQisfRO3KgF6jJlserbpGtYRzeggetB5mr1wbgHBFtAJpF0+WtUEBbKR8LFyBnFMurnoQ3oFOaO8VH0UM+4EoViecQFU7v4PTsfqvGx3/n+SQ3l5NQBOxO4m8k074=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729785989; c=relaxed/simple;
	bh=0KowH7y85XE2y6KJuU7Ce+c+Q3jHPqfm80LQl3MvVKI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FD/j8djBV5ML7SdmWPOXfF0QgjyWpI6LYx8kGN58XUab6RWLjPeZYfEc6oUjjoyxV5ULFfIrc2TucVJUIwxjKkl4MxMfkKosCZ3QDstPIuKu4W19Ndri05fgnJLb09jBzljKl6JNDRD80+FjwPCVZaFbXHmWP8N0EbhSmcr4lGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fkgo90sr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pz4GWBtGnvEHYFjo2q7F/eFxvtdN8k9+uNnzymMDFd4=; b=fkgo90sryavSyc6EEDHCRt3vCP
	QaskRnxELYWmWYn3cM3/SS2VCOX7oSf8r7Udb/Y5LB2gAdfGBIXJFjCFBjguoFr0ocrcsMkh9Kv5q
	HLmes+C0NbTOKtgSbCPvQUcM64Frr5aE/Xvt4nxsSMP6B4b0hoFxVBI2fW1/fWHSGCb2l/yZjblAK
	TIkFSvccNqfp8z45xyMOLBBViW0mQsvfvTC5j5T0UFM8sxLoLogTDW/b8xS4bGboTNamNlTHp55ls
	TU08yt8CLrWP6a2jNcKm4q3yp2KfLxHZEFhQVMFS9HqOG3WqZRsjeAQrd+S6xbn+I6FqsBRYHbupT
	FrPm947w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t40Lx-000000012DI-005E;
	Thu, 24 Oct 2024 16:06:25 +0000
Date: Thu, 24 Oct 2024 09:06:24 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, David Wei <dw@davidwei.uk>,
	io-uring@vger.kernel.org, netdev@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <stfomichev@gmail.com>,
	Joe Damato <jdamato@fastly.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org
Subject: Re: [PATCH v6 02/15] net: generalise net_iov chunk owners
Message-ID: <ZxpwgLRNsrTBmJEr@infradead.org>
References: <20241016185252.3746190-1-dw@davidwei.uk>
 <20241016185252.3746190-3-dw@davidwei.uk>
 <ZxijxiqNGONin3IY@infradead.org>
 <264c8f95-2a69-4d49-8af6-d035fa890ef1@gmail.com>
 <ZxoSBhC6sMEbXQi8@infradead.org>
 <a6864bf1-dd88-4ae0-bc67-b88bb4c17b44@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6864bf1-dd88-4ae0-bc67-b88bb4c17b44@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Oct 24, 2024 at 03:23:06PM +0100, Pavel Begunkov wrote:
> > That's not what this series does.  It adds the new memory_provider_ops
> > set of hooks, with once implementation for dmabufs, and one for
> > io_uring zero copy.
> 
> First, it's not a _new_ abstraction over a buffer as you called it
> before, the abstraction (net_iov) is already merged.

Umm, it is a new ops vector.

> Second, you mention devmem TCP, and it's not just a page pool with
> "dmabufs", it's a user API to use it and other memory agnostic
> allocation logic. And yes, dmabufs there is the least technically
> important part. Just having a dmabuf handle solves absolutely nothing.

It solves a lot, becaue it provides a proper abstraction.

> > So you are precluding zero copy RX into anything but your magic
> > io_uring buffers, and using an odd abstraction for that.
> 
> Right io_uring zero copy RX API expects transfer to happen into io_uring
> controlled buffers, and that's the entire idea. Buffers that are based
> on an existing network specific abstraction, which are not restricted to
> pages or anything specific in the long run, but the flow of which from
> net stack to user and back is controlled by io_uring. If you worry about
> abuse, io_uring can't even sanely initialise those buffers itself and
> therefore asking the page pool code to do that.

No, I worry about trying to io_uring for not good reason. This
pre-cludes in-kernel uses which would be extremly useful for
network storage drivers, and it precludes device memory of all
kinds.

> I'm even more confused how that would help. The user API has to
> be implemented and adding a new dmabuf gives nothing, not even
> mentioning it's not clear what semantics of that beast is
> supposed to be.
>

The dma-buf maintainers already explained to you last time
that there is absolutely no need to use the dmabuf UAPI, you
can use dma-bufs through in-kernel interfaces just fine.


