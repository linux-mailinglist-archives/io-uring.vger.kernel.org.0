Return-Path: <io-uring+bounces-2500-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A164792F50A
	for <lists+io-uring@lfdr.de>; Fri, 12 Jul 2024 07:26:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 55A8D1F20010
	for <lists+io-uring@lfdr.de>; Fri, 12 Jul 2024 05:26:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFBC718EB8;
	Fri, 12 Jul 2024 05:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YKOzWjRU"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A58D28370;
	Fri, 12 Jul 2024 05:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720761633; cv=none; b=fxyIULY3Wpa/qeQMyqIrqHgmzQMbekvWCnUAuLdrBnjtXCWTlSU9h8uLzAftsxHso7Dcr2wn8EOkxllQgTdMfQygRbK6bLd0Dt5udjzGnHBIhCojqOo12nbrTZeVncirwpyr2nTdrAJnhoueWl3QtHoQxHqPM88Nk7V+XZC8rfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720761633; c=relaxed/simple;
	bh=nYjlKwhIX1L0qtnjhzKtgns8Ws95fvv+IWSXmNEJmT0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q1VzMPvBUQRc+0NpN4QZoaZFWR1lbBZl8ZXbNRhDKJ/gz55RdJSweyQwt7kiJcjtQ+BdeK20NPLJjGFgUH08ZPQQeeY/K/CPYGVgLxL1F7yUNRjM7SkTu1VNXXbVIEaNAXG9D2OQGx3wPEDIwxXZzS4sTX02TS5oPKf3T78rrTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YKOzWjRU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=hvC/5AkHO/OeeJro5Mw7Jxkxmq3vhHmUumiCck6LtWE=; b=YKOzWjRUhpSVw5NUTTXHlN48sV
	eKqZ3lcm3RnVbq7pkowyf30yrp56LKf/k212lkbMQalmr5lhNgdcV7L6tdMwtAKYSMXMPahxZ19BC
	iOKqMvn7zUbhjNQ6G2qIWalgJEM8nYK69yq/X0huoqLWL9yF258gqDp1oj6S8CG/3obGFyp4oE2P4
	347gc2lFXs1s1e6zKoeNfuX5tRgJY+es/iEBVmXg2pNFLIhmpPj3L0L24rpRqXZrs9Skp1eL1Igf+
	bx7AEfioIIVA4Y0iKmVmysybW5LBVc6dZA+QT9SDUC0x7qDUym5dW6JeJT5WMbFLbBuYV7uXJbBtw
	JknaPJHQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sS8hr-0000000GUnG-17id;
	Fri, 12 Jul 2024 05:20:31 +0000
Date: Thu, 11 Jul 2024 22:20:31 -0700
From: Christoph Hellwig <hch@infradead.org>
To: hexue <xue01.he@samsung.com>
Cc: axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] io_uring: Avoid polling configuration errors
Message-ID: <ZpC9HxJnokkbjKAO@infradead.org>
References: <CGME20240711082438epcas5p3732ee8528964d2334f5670e36b0c3f10@epcas5p3.samsung.com>
 <20240711082430.609597-1-xue01.he@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240711082430.609597-1-xue01.he@samsung.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jul 11, 2024 at 04:24:30PM +0800, hexue wrote:
> +	if (!ctx->check_poll_queue) {
> +		struct block_device *bdev;
> +		struct request_queue *q;
> +		struct inode *inode = req->file->f_inode;
> +
> +		if (inode->i_rdev) {
> +			bdev = blkdev_get_no_open(inode->i_rdev);
> +			q = bdev->bd_queue;
> +			if (!test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
> +				pr_warn("the device does't configured with poll queues\n");
> +		}
> +		ctx->check_poll_queue = true;
> +	}

This is wrong for multiple reasons.  One is that we can't simply poke
into block device internals like this in a higher layer like io_uring.
Second blkdev_get_no_open is in no way available for use outside the
block layer.  The fact that the even exist as separate helpers that
aren't entirely hidden is a decade old layering violation in blk-cgroup.

If you want to advertize this properly we'll need a flag in struct
file or something similar.


