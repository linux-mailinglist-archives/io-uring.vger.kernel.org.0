Return-Path: <io-uring+bounces-6301-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B77D7A2C746
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2025 16:33:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ACEFE7A3654
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2025 15:32:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DD03238D50;
	Fri,  7 Feb 2025 15:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ElbOKM7x"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D3E238D30;
	Fri,  7 Feb 2025 15:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738942423; cv=none; b=rPgkhazWdmqLEh5xZPM6nOjE+Xss7Q/igOStNUOkIs+7qV1kvXlo9qnxDgHNwJkQbolACOe2nTXUXRwYFPV+y2HMOZokkQ0cKczJYYJRo8Gex/17U0mG9fLyVfrkfamH0WcMdHholjGqHfDlMGA8WZ1bKT5o+ZVMkUilNNsqOZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738942423; c=relaxed/simple;
	bh=H1BNwtjaWX8L4WPZsskzlctwJBjjbFpwX/Uw6xucKyo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dEZtmol/+7vFzQr0SQo7yhJJ2uLLrZwZ7r0xyeLw6VJdi3m72yMGEMZ+TBL27r8pDVVen7kwu9PFbOVQEQhztDP9DmeECcjmaFqjxw9slBNOi0mkyOwjI7muSis5tsnxJRoTLxKQIiProqmY32+y5h2ZNer0VCAH5cp0n2DHVww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ElbOKM7x; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D01C4CED1;
	Fri,  7 Feb 2025 15:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738942423;
	bh=H1BNwtjaWX8L4WPZsskzlctwJBjjbFpwX/Uw6xucKyo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ElbOKM7x2T1SKrlde+70WWmO8FcR4THqeBCQT1NDMcAzONUxlBmLIA9fSPVPDanB0
	 iYqtR07ITx0Qu3HqMRw2foQ8a8227S92kBH5e5/H3oi4pB6rJd5gbWglPhATyf1IdO
	 uga7t2I5V6gz8tn6/+Fhy1//Q6d/djxETnwgIj8Sd7mArB9wsgPV7YCmIIfyU9S/7B
	 6Hppqjqn+cVqZ8wVDLu7TMlksfPyCEFhBl590a+1WHj0rKG5VLwG2lIPSiC+S5Fczr
	 i4Cgnmc1NVALGprv+YeSK3/h83DRP+skMjx62Ff3swhQhZk73BR0gCHLprlAaph5Vz
	 obRLeNGBlIGOA==
Date: Fri, 7 Feb 2025 08:33:40 -0700
From: Keith Busch <kbusch@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Keith Busch <kbusch@meta.com>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, ming.lei@redhat.com, axboe@kernel.dk
Subject: Re: [PATCH 6/6] io_uring: cache nodes and mapped buffers
Message-ID: <Z6Yn1GOPlMfpZqsf@kbusch-mbp>
References: <20250203154517.937623-1-kbusch@meta.com>
 <20250203154517.937623-7-kbusch@meta.com>
 <a6845bcf-8881-4b92-acc0-0aab8d98cba9@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6845bcf-8881-4b92-acc0-0aab8d98cba9@gmail.com>

On Fri, Feb 07, 2025 at 12:41:17PM +0000, Pavel Begunkov wrote:
> On 2/3/25 15:45, Keith Busch wrote:
> > From: Keith Busch <kbusch@kernel.org>
> > 
> > Frequent alloc/free cycles on these is pretty costly. Use an io cache to
> > more efficiently reuse these buffers.
> > 
> > Signed-off-by: Keith Busch <kbusch@kernel.org>
> > ---
> >   include/linux/io_uring_types.h |  16 ++---
> >   io_uring/filetable.c           |   2 +-
> >   io_uring/rsrc.c                | 108 ++++++++++++++++++++++++---------
> >   io_uring/rsrc.h                |   2 +-
> >   4 files changed, 92 insertions(+), 36 deletions(-)
> > 
> > diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> > index aa661ebfd6568..c0e0c1f92e5b1 100644
> > --- a/include/linux/io_uring_types.h
> > +++ b/include/linux/io_uring_types.h
> > @@ -67,8 +67,17 @@ struct io_file_table {
> >   	unsigned int alloc_hint;
> >   };
> > +struct io_alloc_cache {
> > +	void			**entries;
> > +	unsigned int		nr_cached;
> > +	unsigned int		max_cached;
> > +	size_t			elem_size;
> > +};
> > +
> >   struct io_buf_table {
> >   	struct io_rsrc_data	data;
> > +	struct io_alloc_cache	node_cache;
> > +	struct io_alloc_cache	imu_cache;
> 
> We can avoid all churn if you kill patch 5/6 and place put the
> caches directly into struct io_ring_ctx. It's a bit better for
> future cache improvements and we can even reuse the node cache
> for files.
> 
> ...
> > diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> > index 864c2eabf8efd..5434b0d992d62 100644
> > --- a/io_uring/rsrc.c
> > +++ b/io_uring/rsrc.c
> > @@ -117,23 +117,39 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
> >   				unpin_user_page(imu->bvec[i].bv_page);
> >   		if (imu->acct_pages)
> >   			io_unaccount_mem(ctx, imu->acct_pages);
> > -		kvfree(imu);
> > +		if (struct_size(imu, bvec, imu->nr_bvecs) >
> > +				ctx->buf_table.imu_cache.elem_size ||
> 
> It could be quite a large allocation, let's not cache it if
> it hasn't came from the cache for now. We can always improve
> on top.

Eh? This already skips inserting into the cache if it wasn't allocated
out of the cache.

I picked an arbitrary size, 512b, as the threshold for caching. If you
need more bvecs than fit in that, it falls back to a kvmalloc/kvfree.
The allocation overhead is pretty insignificant when you're transferring
large payloads like that, and 14 vectors was chosen as the tipping point
because it fits in a nice round number.
 
> And can we invert how it's calculated? See below. You'll have
> fewer calculations in the fast path, and I don't really like
> users looking at ->elem_size when it's not necessary.
> 
> 
> #define IO_CACHED_BVEC_SEGS	N

Yah, that's fine.

