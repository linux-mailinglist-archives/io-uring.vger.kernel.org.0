Return-Path: <io-uring+bounces-8608-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C1D9AFB66C
	for <lists+io-uring@lfdr.de>; Mon,  7 Jul 2025 16:48:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4A2E01AA4653
	for <lists+io-uring@lfdr.de>; Mon,  7 Jul 2025 14:48:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63E362E0B55;
	Mon,  7 Jul 2025 14:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vzhIjGyG"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988F42BE637;
	Mon,  7 Jul 2025 14:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751899697; cv=none; b=q4WXi0sFy0yY6YvxAT1YWEidQYm/wc7vaG4yvHr/9D7FRZsyv2w3ADx2BARhQv4B+0hVr+xG7r18xZUrMhy5R6GN7IhiVQvM9Y7hc4yzhCItTq1H+YEHsvTfSZJrp8ihm6/hRDHjZoqS6GiUtWiCjVMft3DTxEirX1+z3Zp7U+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751899697; c=relaxed/simple;
	bh=eyJc7ltXb4xa1fzSCf8uydRCyaShHbLmR3n3ESKoEJQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mTY+PiJ7D3vULw6VjqW92UeTxOdNUuTawOyk167hDIkqPrnKW1qvRN33TtEVrlKHK/i9RVQDwXtVrQxPBZ0uuib9ZnUYNWAnZsIayvv/BsqoIq0mRZG3B6WIiAjkedc2p8aQpw9s7Ctc1EgpBd1Qw+yjeFuXtxQjPWBzLNUCfIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vzhIjGyG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=sTDalUrNw2z9g3DokIxyhkW5+/gPhyhfQxHkWbiU65A=; b=vzhIjGyGUqrxKd96M1rnYuIasN
	mLdtFY51oEfHvGMGVUtIzQqW1kUQJOUYeqe3ezaVOoa6DpicP+NPj5A5N2+rO/4OZcOh9sR6rqluf
	1Gs5PrJ24DJA4u7kdlGCxVKohrf9Px8qncVfTfoDLSfPOX/A/x4zAeJpB48Q9yoqmk6DQ8pj3+/gm
	XIM8bEIJluQLaCrfSEfoFkhhkRk9N6OmbVQ9PEVWNdkYA5XxV7o0VasxtP1nTnbR32VbvAO219LKY
	qRUj1M23/JtRsiEHW+LWPH7wLXOfexcdxd8/i7ghcrNZEX4ad7O1jSmtMu+lFiUa2jL1EZKwvTdeF
	7S8LtUEg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uYn8g-00000002kzX-3wAk;
	Mon, 07 Jul 2025 14:48:14 +0000
Date: Mon, 7 Jul 2025 07:48:14 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
	David Wei <dw@davidwei.uk>, Vishal Verma <vishal1.verma@intel.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org
Subject: Re: [RFC 00/12] io_uring dmabuf read/write support
Message-ID: <aGveLlLDcsyCBKuU@infradead.org>
References: <cover.1751035820.git.asml.silence@gmail.com>
 <aGaSb5rpLD9uc1IK@infradead.org>
 <f2216c30-6540-4b1a-b798-d9a3f83547b2@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2216c30-6540-4b1a-b798-d9a3f83547b2@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jul 07, 2025 at 12:15:54PM +0100, Pavel Begunkov wrote:
> > to attach to / detach from a dma_buf, and then have an iter that
> > specifies a dmabuf and offsets into.  That way the code behind the
> > file operations can forward the attachment to all the needed
> > devices (including more/less while it remains attached to the file)
> > and can pick the right dma address for each device.
> 
> By "iter that specifies a dmabuf" do you mean an opaque file-specific
> structure allocated inside the new fop?

I mean a reference the actual dma_buf (probably indirect through the file
* for it, but listen to the dma_buf experts for that and not me).

> Akin to what Keith proposed back
> then. That sounds good and has more potential for various optimisations.
> My concern would be growing struct iov_iter by an extra pointer:

> struct iov_iter {
> 	union {
> 		struct iovec *iov;
> 		struct dma_seg *dmav;
> 		...
> 	};
> 	void *dma_token;	
> };
> 
> But maybe that's fine. It's 40B -> 48B,

Alternatively we could the union point to a struct that has the dma buf
pointer and a variable length array of dma_segs. Not sure if that would
create a mess in the callers, though.

> and it'll get back to
> 40 when / if xarray_start / ITER_XARRAY is removed.

Would it?  At least for 64-bit architectures nr_segs is the same size.


