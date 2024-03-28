Return-Path: <io-uring+bounces-1290-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EF6B890142
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 15:09:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6F599B2106E
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 14:09:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24F6212D1E0;
	Thu, 28 Mar 2024 14:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg-org.20230601.gappssmtp.com header.i=@cmpxchg-org.20230601.gappssmtp.com header.b="hd33Ega1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804F680630
	for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 14:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711634908; cv=none; b=QykrfZbqgH9laPRCBOg6+LD5WvDZv29X3uasEy4Fi8QgeTh8tRrQjWrkfHj7+b77AwzelknYieVgTV/0LnjKtv2G6SIVJBmuDdgAB0R0LUoGK3ziDhcIr33OJCkHkTiRglllZCDYcUPdM8UNq9qJ0EPE8/RDvEEfeF2o1nzcBuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711634908; c=relaxed/simple;
	bh=WP6K6igvvm8jmxRE5IeDaGGGM8wLVWFNYzE4MJaGku0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jCCGn2t0qpJuLFztGVYBkfnpRGHcwCvWsdvX9ECWXtOBPSbfGhbrpKEFkHzrUPV1qMUJra+mEr9DJF0vtD7GRht41G2/gce/Z8GkFS0XpW5+UcAe3w/4drDxSEMVz5/8W9NV0/3arvsjbKBhmUpPCWDPgdRNwIFgavn2KRne6JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg-org.20230601.gappssmtp.com header.i=@cmpxchg-org.20230601.gappssmtp.com header.b=hd33Ega1; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-78a26803f1aso61153585a.3
        for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 07:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1711634903; x=1712239703; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5fQDXhI6GEg+epaV6CxB8V5pwDRiBCxMRX1pVTXle+Q=;
        b=hd33Ega18oN5/h6D7zs2+pWsewCogsF9lEvOhbvTeJRXAXFbwqhw+gvTmLDuh3nIT8
         MYK5cmAt9sk+Q0jzibQPcoOX6tctjp6kQUoxnEqB+2g2UGTTWO78OLxrs1jN621huBqb
         HAWh0mOZCdbfaphyyXAJrE9xbjCnTErbkd4hyKGm2Ud/abovKaBSN98UWe7YHjd4Jqwt
         NY1zkh/78HKUzTMkSp72H8lfIeABCxTYYfh61H8O/fd0xXA/g4mXu2LcfRqNy5pHa5Tk
         H5VL6SjEUNPh3lczHHH48YcCd3v3EyRdu5fDakAUm5Wh5nIfa3F4SCbOe22gfBCqj5Yz
         vJfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711634903; x=1712239703;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5fQDXhI6GEg+epaV6CxB8V5pwDRiBCxMRX1pVTXle+Q=;
        b=XTxjV72ho2VbjW6GED8YgQixxKpMc+KkI+5OZ6lzYKAM0H/j9hDGrW2W5SX+r4p2K4
         ehxnuBhjNtdm4qnG1v4nYBf2zvDANFtdhYjUoZrynFmo0mn2aarkADcMv6eK9tcMNrGi
         X+WwPloOZqEmsLHpQAojOGraW/UGkrKV2Y1q1PgrM+Bi23v983Gm8f7U/nxwJi0k78Cn
         GowG2FSV4YjdbKGgZ2+zHes+TGNzZQOo8oRAWpTYbs7/IMH3TIvWxzE2jhR47DhIoClD
         mtAw9GCjdHO+QjiP3W6fAmdwQc5pI3wj7Yu4OXnQ+dKB3eOTw3aqAQ94slTZqHX+QUdo
         zlQQ==
X-Gm-Message-State: AOJu0YyuIcx5kCOo/+aUmoInMYVPpFrsqR2SbT3lNzCtLaLEyAlszV60
	mk3sw7Js0EfahfAn3K14ZYFIDbT9dTWG14U7Pxh4NbCq9XTyv14XLuo5Brqr21c=
X-Google-Smtp-Source: AGHT+IFkPP/zOKz0XbpkTBcGXW0O6V9mh0R5lHS3lpBC/x0IAxXs8H6I3I3NB4UzLQXRuZUfuQRAYg==
X-Received: by 2002:ac8:5913:0:b0:431:3df7:ce48 with SMTP id 19-20020ac85913000000b004313df7ce48mr3079149qty.12.1711634903281;
        Thu, 28 Mar 2024 07:08:23 -0700 (PDT)
Received: from localhost ([2620:10d:c091:400::5:bb1f])
        by smtp.gmail.com with ESMTPSA id w27-20020a05622a191b00b00431662b2309sm636260qtc.62.2024.03.28.07.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 07:08:22 -0700 (PDT)
Date: Thu, 28 Mar 2024 10:08:17 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH 02/10] io_uring: get rid of remap_pfn_range() for mapping
 rings/sqes
Message-ID: <20240328140817.GB240869@cmpxchg.org>
References: <20240327191933.607220-1-axboe@kernel.dk>
 <20240327191933.607220-3-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240327191933.607220-3-axboe@kernel.dk>

On Wed, Mar 27, 2024 at 01:13:37PM -0600, Jens Axboe wrote:
> Rather than use remap_pfn_range() for this and manually free later,
> switch to using vm_insert_pages() and have it Just Work.
> 
> If possible, allocate a single compound page that covers the range that
> is needed. If that works, then we can just use page_address() on that
> page. If we fail to get a compound page, allocate single pages and use
> vmap() to map them into the kernel virtual address space.
> 
> This just covers the rings/sqes, the other remaining user of the mmap
> remap_pfn_range() user will be converted separately. Once that is done,
> we can kill the old alloc/free code.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Overall this looks good to me.

Two comments below:

> @@ -2601,6 +2601,27 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
>  	return READ_ONCE(rings->cq.head) == READ_ONCE(rings->cq.tail) ? ret : 0;
>  }
>  
> +static void io_pages_unmap(void *ptr, struct page ***pages,
> +			   unsigned short *npages)
> +{
> +	bool do_vunmap = false;
> +
> +	if (*npages) {
> +		struct page **to_free = *pages;
> +		int i;
> +
> +		/* only did vmap for non-compound and multiple pages */
> +		do_vunmap = !PageCompound(to_free[0]) && *npages > 1;
> +		for (i = 0; i < *npages; i++)
> +			put_page(to_free[i]);
> +	}
> +	if (do_vunmap)
> +		vunmap(ptr);
> +	kvfree(*pages);
> +	*pages = NULL;
> +	*npages = 0;
> +}
> +
>  void io_mem_free(void *ptr)
>  {
>  	if (!ptr)
> @@ -2701,8 +2722,8 @@ static void *io_sqes_map(struct io_ring_ctx *ctx, unsigned long uaddr,
>  static void io_rings_free(struct io_ring_ctx *ctx)
>  {
>  	if (!(ctx->flags & IORING_SETUP_NO_MMAP)) {
> -		io_mem_free(ctx->rings);
> -		io_mem_free(ctx->sq_sqes);
> +		io_pages_unmap(ctx->rings, &ctx->ring_pages, &ctx->n_ring_pages);
> +		io_pages_unmap(ctx->sq_sqes, &ctx->sqe_pages, &ctx->n_sqe_pages);
>  	} else {
>  		io_pages_free(&ctx->ring_pages, ctx->n_ring_pages);
>  		ctx->n_ring_pages = 0;
> @@ -2714,6 +2735,84 @@ static void io_rings_free(struct io_ring_ctx *ctx)
>  	ctx->sq_sqes = NULL;
>  }
>  
> +static void *io_mem_alloc_compound(struct page **pages, int nr_pages,
> +				   size_t size, gfp_t gfp)
> +{
> +	struct page *page;
> +	int i, order;
> +
> +	order = get_order(size);
> +	if (order > MAX_PAGE_ORDER)
> +		return NULL;
> +	else if (order)
> +		gfp |= __GFP_COMP;
> +
> +	page = alloc_pages(gfp, order);
> +	if (!page)
> +		return NULL;
> +
> +	/* add pages, grab a ref to tail pages */
> +	for (i = 0; i < nr_pages; i++) {
> +		pages[i] = page + i;
> +		if (i)
> +			get_page(pages[i]);
> +	}

You don't need those extra refs.

__GFP_COMP makes a super page that acts like a single entity. The ref
returned by alloc_pages() keeps the whole thing alive; you can then do
a single put in io_pages_unmap() for the compound case as well.

[ vm_insert_pages() and munmap() still do gets and puts on the tail
  pages as they are individually mapped and unmapped, but those calls
  get implicitly redirected to the compound refcount maintained in the
  head page. IOW, an munmap() of an individual tail page won't free
  that tail as long as you hold the base ref from the alloc_pages(). ]

> +
> +	return page_address(page);
> +}
> +
> +static void *io_mem_alloc_single(struct page **pages, int nr_pages, size_t size,
> +				 gfp_t gfp)
> +{
> +	void *ret;
> +	int i;
> +
> +	for (i = 0; i < nr_pages; i++) {
> +		pages[i] = alloc_page(gfp);
> +		if (!pages[i])
> +			goto err;
> +	}
> +
> +	ret = vmap(pages, nr_pages, VM_MAP | VM_ALLOW_HUGE_VMAP, PAGE_KERNEL);

You can kill the VM_ALLOW_HUGE_VMAP.

It's a no-op in vmap(), since you're passing an array of order-0
pages, which cannot be mapped by anything larger than PTEs.

