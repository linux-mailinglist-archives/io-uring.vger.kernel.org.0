Return-Path: <io-uring+bounces-9925-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 50376BC3673
	for <lists+io-uring@lfdr.de>; Wed, 08 Oct 2025 07:56:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1A2BE4E70C8
	for <lists+io-uring@lfdr.de>; Wed,  8 Oct 2025 05:56:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 938D32EA49E;
	Wed,  8 Oct 2025 05:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lmszr0oj"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F33E14A09C;
	Wed,  8 Oct 2025 05:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759902972; cv=none; b=AbHUbSliu/YcxMOffBlHdEeQbBWI0koy9paHrvKiZ1TqjhfbdeR1vdoHCEhpn+ggGiGwXdSVxL1nuIrwpGorhaXn1brOySj+/hVFbVlLD8fAyxd7hB6Ptuhf2qrG/Cr2UmeH8OAKXXlQKCuFsr/jMFy46Hj4bdyK1HclPQQDZQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759902972; c=relaxed/simple;
	bh=F38Mt2goSKLUsaf0mqFqP8niI3l76+ZAo94FJ+L4YVU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cwgfq/TwtmVYcKE+ErLeNM+fKmwSBcmHE1I6AKVjBWcVv6k45R6tpk9sTMh3untlRwDgHxV8heLiu/w1nLgZ05ZatYHSreui1i/Xocifk2BBQWbcu2m5LoInVWac3dSFThjX2ePSuqI360O0FLvMQBs2lzSonGUMEeVZIkaT3Ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lmszr0oj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/X26947JAoSSaLr+voBnU4Dp3KYTt3aLBJ6Xsf1gpD0=; b=lmszr0ojI9mQdYgfTYqnyaoeHV
	9ZDvvcG3tOTjG4m5X+YgY2l+cotTuwVfNFCSJ0oY3t4t6nuMw3e4jIUbAaw3+UFeDdb4vYLIY1w80
	1NsL6VX0phUO20oqAkI3GLSsAEctWdqAz6Fzw17jbq1yyEhomCwDI18NSeD3QTjfX2bPO7kA/V6ZQ
	vfHiHgIpY6hUSUxD5QWSGLRjPvP1h6pleDH5NuufJKKDU3pcr+n/7/E9ca4jaYM+bq67TktXyxzQV
	g9A11TCh5ni3ICAnfs8oZ4I8GNg6QJfM4GvvV+I/d6WYARHXzXBuSoqAFu8fuOEBGm9a/2Sdmfx7r
	qy8odKEw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v6N9d-00000003Ez0-18fd;
	Wed, 08 Oct 2025 05:56:01 +0000
Date: Tue, 7 Oct 2025 22:56:01 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
	Zhaoyang Huang <zhaoyang.huang@unisoc.com>,
	Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: Re: [PATCH V4 6/6] loop: add hint for handling aio via IOCB_NOWAIT
Message-ID: <aOX88d7GrbhBkC51@infradead.org>
References: <20250928132927.3672537-1-ming.lei@redhat.com>
 <20250928132927.3672537-7-ming.lei@redhat.com>
 <aN92BCY1GQZr9YB-@infradead.org>
 <aOPPpEPnClM-4CSy@fedora>
 <aOS0LdM6nMVcLPv_@infradead.org>
 <aOUESdhW-joMHvyW@fedora>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aOUESdhW-joMHvyW@fedora>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Oct 07, 2025 at 08:15:05PM +0800, Ming Lei wrote:
> NOWAIT is obviously interface provided by FS, here loop just wants to try
> NOWAIT first in block layer dispatch context for avoiding the extra wq
> schedule latency.

Yes.

> But for write on sparse file, trying NOWAIT first may bring extra retry
> cost, that is why the hint is added. It is very coarse, but potential
> regression can be avoided.

And that is absolutely not a property of loop, and loop should not have
to know about.  So this logic needs to be in common code, preferably
triggered by a fs flag.  Note that this isn't about holes - it is about
allocating blocks.  For most file systems filling holes or extending
past i_size is what requires allocating blocks.  But for a out of place
write file systems like btrfs, or zoned xfs we always need to allocate
blocks for now.  But I have work that I need to finish off that allows
for non-blocking block allocation in zoned XFS, at which point you
don't need this.  I think some of this might be true for network file
systems already.

> 
> > rather have a flag similar FOP_DIO_PARALLEL_WRITE that makes this
> > limitation clear rather then opencoding it in the loop driver while
> 
> What is the limitation?

See above.

> > leabing the primary user of RWF_NOWAIT out in the cold.
> 
> FOP_DIO_PARALLEL_WRITE is one static FS feature,

It actually isn't :( I need to move it to be a bit more dynamic on a
per-file basis.

> but here it is FS
> runtime behavior, such as if the write can be blocked because of space
> allocation, so it can't be done by one static flag.

Yes, that's why you want a flag to indicate that a file, or maybe file
operations instance can do non-blocking fill of blocks.  But that's
for the future, for now I just want your logic lifted to common code
and shared with io_uring so that we don't have weird hardcoded
assumptions about file system behavior inside the loop driver.

> io-uring shares nothing with loop in this area, it is just one policy wrt.
> use NOWAIT or not. I don't understand why you insist on covering both
> from FS internal...

It's really about all IOCB_NOWAIT users, io_uring being the prime one,
and the one that we can actually easily write tests for.


