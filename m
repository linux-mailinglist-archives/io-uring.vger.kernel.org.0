Return-Path: <io-uring+bounces-6302-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C5976A2C831
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2025 17:01:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4EB871889D14
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2025 16:00:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C18A923C8CA;
	Fri,  7 Feb 2025 15:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IdUD3nyk"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99BE616C687;
	Fri,  7 Feb 2025 15:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738943969; cv=none; b=UeG4VqCBnLvasQnk6KVET/ETrzeeycrF6AbZbwnjzrBIwinqu7DpkBNEqR6lE2gCN1p9VJ3b8otwgy+7nikd1ZhUqEH95y8i8Mie6+cxIAHgv9xMS/dLUKjyY+TbX9pMLNvg3SzLXnWJNydLSx+Rc9uXcQUGd0vt0S939hw/OCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738943969; c=relaxed/simple;
	bh=LJOiLSWAK0vaWYv7KAnaLQW7l9bCOqNVj1TJAVX8q1Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W2zpe7s8o7HhYWDdiz2XmoPWtZFSmg9YNVEY13aaknOQmgExeDjLHbjVm0vLSvEvAwquWwAOk06EXaMUphfkTbn6hc6J4xuoSYNoc7tvIFVnpis7wKFvaPgqDlR9qsqAMIYMnFHzypPtTwNt4rpXylGsoZstxdB/k6JgMo5m7Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IdUD3nyk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EF7EC4CEE2;
	Fri,  7 Feb 2025 15:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738943969;
	bh=LJOiLSWAK0vaWYv7KAnaLQW7l9bCOqNVj1TJAVX8q1Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IdUD3nykJTsFyCEPFFvDAJDdfwkgZwOmHV0MRc4qG//A9Tssb7zCOXuTnT2jgzMyZ
	 cz2r0mgbHAxnbH3xwoncx76RNP0AVKGxIXhovOPJZMNPZQy2EwMUZlhg71zvZFVUC5
	 rOe9MkV0Eb0wJJuKYKNnC2x9p0McuX50Jqc4GoOdpbgY1qBbeoYFAeMkSzdKRAoPEQ
	 cwWAWQwtxYOTTuyEGcCIQ20Q8QO1SEUOzI72fY98b2gE8nxVzKW9KSycDRef7Al6Tr
	 eZQi+LpeQKgkjiJh5CZeAr5PPv2H8UNpRWMd1Qi/1HO95Srgg8kZK1kx2ND04LgSYK
	 3M7z8Id477+FQ==
Date: Fri, 7 Feb 2025 08:59:26 -0700
From: Keith Busch <kbusch@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Keith Busch <kbusch@meta.com>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, ming.lei@redhat.com, axboe@kernel.dk
Subject: Re: [PATCH 6/6] io_uring: cache nodes and mapped buffers
Message-ID: <Z6Yt3o7LKtVdFx32@kbusch-mbp>
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

I had this that way in an earlier version. The cache is tightly
connected to the buf table, though, so splitting them up makes for some
awkward cleanup. Grouping them together makes it clear their lifetimes
are as a single unit.

The filetable could have moved its bitmap into io_ring_ctx too, but it's
in its own structure like this, and it conceptually makes sense. This is
following in that same pattern.

