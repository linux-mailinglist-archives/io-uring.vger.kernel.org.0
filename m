Return-Path: <io-uring+bounces-6514-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 70C93A3A868
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 21:10:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 727BF1889EE9
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 20:10:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2170D1BCA11;
	Tue, 18 Feb 2025 20:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lIzyM+gE"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1B81B87D7;
	Tue, 18 Feb 2025 20:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739909396; cv=none; b=CGoOPNrWP1jiO+w9w6U3MIHEEPQV/Xu/yllys4uHDHlbqD6BChBHG803yPKSdNaYiuEK/okNCiIUWpHL6xtsMbK+OsUzVB+mb+VZAYnPJ4SeU7egsDk2qhalSmVUluTpbXkByk3b4JVgyoSB8JXtyen58LnR1iqCxVUTZHYGqKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739909396; c=relaxed/simple;
	bh=gZ321uCPRrV5RtLeOm/+PofUPPCbIorajnIjh4B9gS8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ORzrCA7mZHzMzY4laTciY0uVYUai9/ym5TNMqEFhPMZK9zvBh2zgfRIwZ2rrIVt2zZz+YLIJxdsxu6MIZQSkE4Dlug5zMh7Q5uPepKr4SSp5C1kOwBwfh4ILao1l0rOymnAYGT/gRPFZjU1ip71A6CWWm7XgG7LSqht+g+rM4K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lIzyM+gE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF925C4CEE4;
	Tue, 18 Feb 2025 20:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739909395;
	bh=gZ321uCPRrV5RtLeOm/+PofUPPCbIorajnIjh4B9gS8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lIzyM+gEu6ukt++ni28DsN49qccZ1bEpQe12+IzWyk+S6k2lpUe+3wDoTW/o9QBsW
	 /A6T6JF2vfY6f4bavu8IiPe6l1BvYhkWLbK1dFWhK4FZJ4DUb/SAXnuCvK7mEEzNyO
	 dHDeRUTW5ABQbvtYVZEPZ2pq03qnrb5abkWK/l1rlosLrTQLVL3bkrqZd6tr007Y9K
	 Yz7dlUAbPPYxyVsDqobJnYhpEcuVzA3RteuGvchewRgH9Ql5XVyaQ8PrNx8IN8iDGC
	 8Yxedoc/YWOAR6r1Jlvx9SHRZJSm2a5ZLNMDlCc9kbFMR5jOItR323vF6QE+L6LNLq
	 H/5WqK/WlAe/w==
Date: Tue, 18 Feb 2025 13:09:52 -0700
From: Keith Busch <kbusch@kernel.org>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com,
	asml.silence@gmail.com, axboe@kernel.dk,
	linux-block@vger.kernel.org, io-uring@vger.kernel.org,
	bernd@bsbernd.com
Subject: Re: [PATCHv3 5/5] io_uring: cache nodes and mapped buffers
Message-ID: <Z7TpEEEubC5a5t6K@kbusch-mbp>
References: <20250214154348.2952692-1-kbusch@meta.com>
 <20250214154348.2952692-6-kbusch@meta.com>
 <CADUfDZpM-TXBYQy0B4xRnKjT=-OfX+AYo+6HGA7e7pyT39LxEA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADUfDZpM-TXBYQy0B4xRnKjT=-OfX+AYo+6HGA7e7pyT39LxEA@mail.gmail.com>

On Fri, Feb 14, 2025 at 06:22:09PM -0800, Caleb Sander Mateos wrote:
> > +static struct io_mapped_ubuf *io_alloc_imu(struct io_ring_ctx *ctx,
> > +                                          int nr_bvecs)
> > +{
> > +       if (nr_bvecs <= IO_CACHED_BVECS_SEGS)
> > +               return io_cache_alloc(&ctx->buf_table.imu_cache, GFP_KERNEL);
> 
> If there is no entry available in the cache, this will heap-allocate
> one with enough space for all IO_CACHED_BVECS_SEGS bvecs. 

The cache can only have fixed size objects in them, so we have to pick
some kind of trade off. The cache starts off empty and fills up on
demand, so whatever we allocate needs to be of that cache's element
size.

> Consider
> using io_alloc_cache_get() instead of io_cache_alloc(), so the
> heap-allocated fallback uses the minimal size.

We wouldn't be able to fill the cache with the new dynamic object if we
did that.

> Also, where are these allocations returned to the imu_cache? Looks
> like kvfree(imu) in io_buffer_unmap() and io_sqe_buffer_register()
> needs to try io_alloc_cache_put() first.

Oops. I kind of rushed this series last Friday as I needed to shut down
very early in the day.

Thanks for the comments. Will take my time for the next version.

