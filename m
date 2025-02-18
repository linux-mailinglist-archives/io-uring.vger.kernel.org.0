Return-Path: <io-uring+bounces-6515-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 70BA1A3A874
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 21:12:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5F6CF188D370
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 20:12:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 160EC1C8622;
	Tue, 18 Feb 2025 20:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gy09Pyp1"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFD61BD017;
	Tue, 18 Feb 2025 20:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739909562; cv=none; b=lD2wvEsgWpJVi3fFdiI0I5wtggby/VTVHT50ggyPR1x7Hxyd5oQmqyoDwSyYmFlTcpidTqyCjozegCkGJSJlWLjxdn5GILRyvZy0yga1Im7vtW0D8ny21m763FXE+V0VIiKOME2kjyAmnDh70IT874xdDgz4bC9ZmX0E5NBwJ2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739909562; c=relaxed/simple;
	bh=cduoBDkcRVdy9/fwUecZLB4Wfm/9MJKCczW2QEMrK1M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=igO/2CwiTYcdBjZhZs8zO8a13njeBsR2cmjS4+yQ2GtSD5/YYB5zespGuqCjW5azTfQB3+yC8ADC2qzYT9IIjfFGvKFEjveoX+vKN3Yip1ZtFBZLXcOcIqBUjLmtLc3p1DlQfpA8jVB7TY18n+nMjxMuZKMwG+8xi4VAFDSk4Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gy09Pyp1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB822C4CEE2;
	Tue, 18 Feb 2025 20:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739909560;
	bh=cduoBDkcRVdy9/fwUecZLB4Wfm/9MJKCczW2QEMrK1M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Gy09Pyp1HO6oMUfxKvrhJQzwzPVOhZAB9Ax/mGVP+4wmiyz9i8E0HixrNh02cCM4l
	 NIqEz4lMgwprG7DQoJ1oFOVfEg/6boF4MfbxZJW/7/OfZfUAXYNOjuAudRFTs+gTqk
	 QdpDHxUIFbQDUzkIAHOfXvm5yec4eIAHNz5ihl+aPBEGGwgLjT3VBlz4tF9z+kv2c7
	 8KHHcbQALnr+f611gpdMLdU0TLc4K1ky3KPB8xge6QcdcgCevKhByjzj9qo6gZmsFF
	 44aepBjzeVZtT9d7ZuSsGoZkE+6SBXYwjuqe1fVDPq6egAjqAXYihkG92ASUGPMkhh
	 RSZfsv9Kw02IQ==
Date: Tue, 18 Feb 2025 13:12:37 -0700
From: Keith Busch <kbusch@kernel.org>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com,
	asml.silence@gmail.com, axboe@kernel.dk,
	linux-block@vger.kernel.org, io-uring@vger.kernel.org,
	bernd@bsbernd.com
Subject: Re: [PATCHv3 5/5] io_uring: cache nodes and mapped buffers
Message-ID: <Z7TptdubsPCFulfV@kbusch-mbp>
References: <20250214154348.2952692-1-kbusch@meta.com>
 <20250214154348.2952692-6-kbusch@meta.com>
 <CADUfDZpM-TXBYQy0B4xRnKjT=-OfX+AYo+6HGA7e7pyT39LxEA@mail.gmail.com>
 <CADUfDZrfmpy3hxD5z0ADxCUkWPbU0aZDMiqpyPE+AZbeDSgZ=g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADUfDZrfmpy3hxD5z0ADxCUkWPbU0aZDMiqpyPE+AZbeDSgZ=g@mail.gmail.com>

On Sun, Feb 16, 2025 at 02:43:40PM -0800, Caleb Sander Mateos wrote:
> > > +       io_alloc_cache_free(&table->imu_cache, kfree);
> > > +}
> > > +
> > >  int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
> > >  {
> > >         if (!ctx->buf_table.data.nr)
> > >                 return -ENXIO;
> > > -       io_rsrc_data_free(ctx, &ctx->buf_table.data);
> > > +       io_rsrc_buffer_free(ctx, &ctx->buf_table);
> > >         return 0;
> > >  }
> > >
> > > @@ -716,6 +767,15 @@ bool io_check_coalesce_buffer(struct page **page_array, int nr_pages,
> > >         return true;
> > >  }
> > >
> > > +static struct io_mapped_ubuf *io_alloc_imu(struct io_ring_ctx *ctx,
> > > +                                          int nr_bvecs)
> > > +{
> > > +       if (nr_bvecs <= IO_CACHED_BVECS_SEGS)
> > > +               return io_cache_alloc(&ctx->buf_table.imu_cache, GFP_KERNEL);
> >
> > If there is no entry available in the cache, this will heap-allocate
> > one with enough space for all IO_CACHED_BVECS_SEGS bvecs. Consider
> > using io_alloc_cache_get() instead of io_cache_alloc(), so the
> > heap-allocated fallback uses the minimal size.
> >
> > Also, where are these allocations returned to the imu_cache? Looks
> > like kvfree(imu) in io_buffer_unmap() and io_sqe_buffer_register()
> > needs to try io_alloc_cache_put() first.
> 
> Another issue I see is that io_alloc_cache elements are allocated with
> kmalloc(), so they can't be freed with kvfree(). 

You actually can kvfree(kmalloc()); Here's the kernel doc for it:

  kvfree frees memory allocated by any of vmalloc(), kmalloc() or kvmalloc()

> When the imu is
> freed, we could check nr_bvecs <= IO_CACHED_BVECS_SEGS to tell whether
> to call io_alloc_cache_put() (with a fallback to kfree()) or kvfree().

But you're right, it shouldn't even hit this path because it's supposed
to try to insert the imu into the cache if that's where it was allocated
from.

