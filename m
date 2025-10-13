Return-Path: <io-uring+bounces-9967-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 261A7BD1521
	for <lists+io-uring@lfdr.de>; Mon, 13 Oct 2025 05:25:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 976083BE53C
	for <lists+io-uring@lfdr.de>; Mon, 13 Oct 2025 03:25:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F39CF1DDC1D;
	Mon, 13 Oct 2025 03:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xKqmaYxe"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A325117A2FB;
	Mon, 13 Oct 2025 03:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760325898; cv=none; b=tUrwTYEbBll+kmpTlEYyzNUm0LvAWPX3kg6c3xWi1PybOaJNk9FIVj+YuNY/BX3Sx/6EqXFjsS+NT7ktssgtg5ijJqdeiEDS3bnAQnF28V4f+bOKno33XuuR3m6lN7IlU1AauFsucoHCZTxpb4k92e8tUIWhlFpANiewC9mpEIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760325898; c=relaxed/simple;
	bh=50dS+0y+6FY2yD3kd/3EeJU4s/xR6yAIQs/bi9vgnaQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DuNORoUoyHmo9LrakEEBFDf1M9Oodbebf9r5VerilI27UGBkP/KKHcGtu4O9TjGkMOYsKeDq/nvpw6nqrdCynUnY4jynOndS1NL2mnJ2WPWO7cIhVO8aQmUpKRZFgiTYdy1k23TZoiSEfvGnm8pXcmVrokuNCPdqX2z7jZA/VIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xKqmaYxe; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qOaNuHQTU+ztL3RFVtOr9Vvm14VlAtgrXtrwZtrsN7U=; b=xKqmaYxeNyS/sTBLsfrN0ZwnUg
	YvvpgeqHtj8tiGblShgqzzNG3f8FN6cU/WyuQnFTQwhlCNdJRkgps/cr4LOrx/1npVCGPijMCK12S
	smQRgQMazwXgbKypHchcgGLEHl0xVBbX8lE0nc/H0PZvNYdhV5JgWvlKPH1zbJYm0VeHa49YMJFVl
	XWpXMgkQOyNoAuRw7NFtxN43UmcRfIBfiqS5KhkJ9r6sQoCoN8rQb4KZjoqzYnqAHyBvgxkHRPAtV
	dfGwbD0iqkSV2txadKK7n1vxY8wU83xk/0BRwSNcBJ2LTC8R8ER+NLwKZejFSo9BZttjaVT2FCw+B
	+vB7wJ+g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v89B7-0000000C9wP-37SV;
	Mon, 13 Oct 2025 03:24:53 +0000
Date: Sun, 12 Oct 2025 20:24:53 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Fengnan Chang <changfengnan@bytedance.com>
Cc: axboe@kernel.dk, viro@zeniv.linux.org.uk, brauner@kernel.org,
	jack@suse.cz, asml.silence@gmail.com, willy@infradead.org,
	djwong@kernel.org, hch@infradead.org, ritesh.list@gmail.com,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] block: enable per-cpu bio cache by default
Message-ID: <aOxxBS8075_gMXgy@infradead.org>
References: <20251011013312.20698-1-changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251011013312.20698-1-changfengnan@bytedance.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sat, Oct 11, 2025 at 09:33:12AM +0800, Fengnan Chang wrote:
> +	opf |= REQ_ALLOC_CACHE;
> +	if (bs->cache && nr_vecs <= BIO_INLINE_VECS) {
> +		bio = bio_alloc_percpu_cache(bdev, nr_vecs, opf,
> +					     gfp_mask, bs);
> +		if (bio)
> +			return bio;
> +		/*
> +		 * No cached bio available, bio returned below marked with
> +		 * REQ_ALLOC_CACHE to participate in per-cpu alloc cache.
> +		 */
> +	} else

> +		opf &= ~REQ_ALLOC_CACHE;

Just set the req flag in the branch instead of unconditionally setting
it and then clearing it.  

> +	/*
> +	 * Even REQ_ALLOC_CACHE is enabled by default, we still need this to
> +	 * mark bio is allocated by bio_alloc_bioset.
> +	 */
>  	if (rq->cmd_flags & REQ_ALLOC_CACHE && (nr_vecs <= BIO_INLINE_VECS)) {

I can't really parse the comment, can you explain what you mean?


