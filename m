Return-Path: <io-uring+bounces-1291-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D918A89023A
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 15:49:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4C7321F2406A
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 14:49:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20D9480605;
	Thu, 28 Mar 2024 14:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="jvYq2+Wu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802707E772
	for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 14:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711637357; cv=none; b=QtTxJKMtC/pTxDUZ//Cwlob+CWyTeglYBKqY9Pprv6tbQZlaPPjP278jSyUjhGw86k/X1Dd2bKf3efTZtiVfqHlZsl0qVUdOOUHmCwtWieopQk9xCUSdM6wuJDSeDPsUHQxo9Sj5dVWDe7ssg+aw2BOypw1VhbuNJ3n3Xx0s9/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711637357; c=relaxed/simple;
	bh=zYFJBs8B8aS3VnOzpOEDawGXeQai3kVDuSDVz5/7Lgk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Mo+KIvtdWcdTNntbX+CmO4ldbSJHkr6DJcEBk72bT5EceKnm9Xrdmocx5Yo9xIQ+wzrYy2J5J7d72bsYTvPOBp1zyQmvcDErsKT7JrFSs5wrLqgpaATJKrnJ93MYgiWwpWzg+0AHMvHetmL51rbE1w7sqCIWNMiasLjznssWiJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=jvYq2+Wu; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1dde367a10aso1843295ad.0
        for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 07:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711637353; x=1712242153; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NIqP4tMl3G6I6BgPZ/ezwnwlIbDyOhEaS/1o5jeyfmo=;
        b=jvYq2+WuFzCXHnVHSeC4MzBjLz9X1J1+9iLOKVw2Lo4i9bMjqaA9UOpaKgV7Mby0+/
         QDp1sulBsCb+YBrKXwffj/DHYD4gManqDCSUKMk0J+nuc2+0qFMJ0zvTz5oweUcPRyae
         2UGOy2ZNqkcIPio3PwZPrLQ3EqGVUo4VMgpyt4wIGY6XLU2hLDmbweDHyyDgIrlPXsFM
         49Yp2oI9vv2K6z+X8rY6c6ANr2XUnmlhKUF/m+0RyWBiYEDzICSrx6EkLfvEjWhkjMvO
         qAf+H7NaYcNPdaWUTEJe2N1jNIxRdWNhBhDh5S1qLkzi+w/44FYOZFC2GLtBqb2TunLv
         vFcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711637353; x=1712242153;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NIqP4tMl3G6I6BgPZ/ezwnwlIbDyOhEaS/1o5jeyfmo=;
        b=AA7qg2TD3cA27bVyUDC22K/6kPz8nGTsshb9sRG9wYmskFSyPzut4tWZS9Kp2R6nLN
         W2Ij9WvnrHHHsu+YPgHxgi3j7jbYGPeKh9VqZFfn1AsN9jkVKxJxNDOHa91zGlAtkA/g
         2tTf9BSDLehcrdSAb3Mdh/BGJ56NBc15zB1gjOe18Du9DkoJUTJl5are652kMuZXcyF/
         nQmjAf6NB5newyPCDMBxQoG6iZLpAXT8ujJwnf8BRW2bARjTo6law/+7to8B9DZzfMDS
         XD30uCvrTK82AqXN9i1BSpCQvYswms/fKDFHKIR7M+TUggzV9glY6z3TFMlfQfT62yEx
         h7OQ==
X-Gm-Message-State: AOJu0YweYjeH5KxWQrqf4HxwTOxDqA1OrsVTmtEZXJZJEM5N+n7R0INE
	oTkve309K0pSQGRQPJQ0z94Ftj6vnmTbMHm6jc6uSUmWOZUNQOW6KtsnHhNMFbX7TDUKfk6S932
	a
X-Google-Smtp-Source: AGHT+IE7saHCtn63IadpHFhOb0vdN+y1GAj3ZzCWozppNWiHQowxYZ2de1FSGGpFAlIdn0uc7g6aNg==
X-Received: by 2002:a17:902:aa95:b0:1e2:b3d:8c67 with SMTP id d21-20020a170902aa9500b001e20b3d8c67mr2472709plr.6.1711637352774;
        Thu, 28 Mar 2024 07:49:12 -0700 (PDT)
Received: from [192.168.201.244] ([50.234.116.5])
        by smtp.gmail.com with ESMTPSA id k11-20020a170902760b00b001ddb4df7f70sm1657733pll.304.2024.03.28.07.49.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Mar 2024 07:49:12 -0700 (PDT)
Message-ID: <95412c0c-938d-4d99-b866-9608b2c0232b@kernel.dk>
Date: Thu, 28 Mar 2024 08:49:11 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/10] io_uring: get rid of remap_pfn_range() for mapping
 rings/sqes
Content-Language: en-US
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: io-uring@vger.kernel.org
References: <20240327191933.607220-1-axboe@kernel.dk>
 <20240327191933.607220-3-axboe@kernel.dk>
 <20240328140817.GB240869@cmpxchg.org>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240328140817.GB240869@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/28/24 8:08 AM, Johannes Weiner wrote:
> On Wed, Mar 27, 2024 at 01:13:37PM -0600, Jens Axboe wrote:
>> Rather than use remap_pfn_range() for this and manually free later,
>> switch to using vm_insert_pages() and have it Just Work.
>>
>> If possible, allocate a single compound page that covers the range that
>> is needed. If that works, then we can just use page_address() on that
>> page. If we fail to get a compound page, allocate single pages and use
>> vmap() to map them into the kernel virtual address space.
>>
>> This just covers the rings/sqes, the other remaining user of the mmap
>> remap_pfn_range() user will be converted separately. Once that is done,
>> we can kill the old alloc/free code.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> Overall this looks good to me.
> 
> Two comments below:
> 
>> @@ -2601,6 +2601,27 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
>>  	return READ_ONCE(rings->cq.head) == READ_ONCE(rings->cq.tail) ? ret : 0;
>>  }
>>  
>> +static void io_pages_unmap(void *ptr, struct page ***pages,
>> +			   unsigned short *npages)
>> +{
>> +	bool do_vunmap = false;
>> +
>> +	if (*npages) {
>> +		struct page **to_free = *pages;
>> +		int i;
>> +
>> +		/* only did vmap for non-compound and multiple pages */
>> +		do_vunmap = !PageCompound(to_free[0]) && *npages > 1;
>> +		for (i = 0; i < *npages; i++)
>> +			put_page(to_free[i]);
>> +	}
>> +	if (do_vunmap)
>> +		vunmap(ptr);
>> +	kvfree(*pages);
>> +	*pages = NULL;
>> +	*npages = 0;
>> +}
>> +
>>  void io_mem_free(void *ptr)
>>  {
>>  	if (!ptr)
>> @@ -2701,8 +2722,8 @@ static void *io_sqes_map(struct io_ring_ctx *ctx, unsigned long uaddr,
>>  static void io_rings_free(struct io_ring_ctx *ctx)
>>  {
>>  	if (!(ctx->flags & IORING_SETUP_NO_MMAP)) {
>> -		io_mem_free(ctx->rings);
>> -		io_mem_free(ctx->sq_sqes);
>> +		io_pages_unmap(ctx->rings, &ctx->ring_pages, &ctx->n_ring_pages);
>> +		io_pages_unmap(ctx->sq_sqes, &ctx->sqe_pages, &ctx->n_sqe_pages);
>>  	} else {
>>  		io_pages_free(&ctx->ring_pages, ctx->n_ring_pages);
>>  		ctx->n_ring_pages = 0;
>> @@ -2714,6 +2735,84 @@ static void io_rings_free(struct io_ring_ctx *ctx)
>>  	ctx->sq_sqes = NULL;
>>  }
>>  
>> +static void *io_mem_alloc_compound(struct page **pages, int nr_pages,
>> +				   size_t size, gfp_t gfp)
>> +{
>> +	struct page *page;
>> +	int i, order;
>> +
>> +	order = get_order(size);
>> +	if (order > MAX_PAGE_ORDER)
>> +		return NULL;
>> +	else if (order)
>> +		gfp |= __GFP_COMP;
>> +
>> +	page = alloc_pages(gfp, order);
>> +	if (!page)
>> +		return NULL;
>> +
>> +	/* add pages, grab a ref to tail pages */
>> +	for (i = 0; i < nr_pages; i++) {
>> +		pages[i] = page + i;
>> +		if (i)
>> +			get_page(pages[i]);
>> +	}
> 
> You don't need those extra refs.
> 
> __GFP_COMP makes a super page that acts like a single entity. The ref
> returned by alloc_pages() keeps the whole thing alive; you can then do
> a single put in io_pages_unmap() for the compound case as well.
> 
> [ vm_insert_pages() and munmap() still do gets and puts on the tail
>   pages as they are individually mapped and unmapped, but those calls
>   get implicitly redirected to the compound refcount maintained in the
>   head page. IOW, an munmap() of an individual tail page won't free
>   that tail as long as you hold the base ref from the alloc_pages(). ]

OK then, so I can just do something ala:

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index bf1527055679..d168752c206f 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -29,12 +29,8 @@ static void *io_mem_alloc_compound(struct page **pages, int nr_pages,
 	if (!page)
 		return NULL;
 
-	/* add pages, grab a ref to tail pages */
-	for (i = 0; i < nr_pages; i++) {
+	for (i = 0; i < nr_pages; i++)
 		pages[i] = page + i;
-		if (i)
-			get_page(pages[i]);
-	}
 
 	return page_address(page);
 }
@@ -100,8 +96,14 @@ void io_pages_unmap(void *ptr, struct page ***pages, unsigned short *npages,
 		struct page **to_free = *pages;
 		int i;
 
-		/* only did vmap for non-compound and multiple pages */
-		do_vunmap = !PageCompound(to_free[0]) && *npages > 1;
+		/*
+		 * Only did vmap for the non-compound multiple page case.
+		 * For the compound page, we just need to put the head.
+		 */
+		if (PageCompound(to_free[0]))
+			*npages = 1;
+		else if (*npages > 1)
+			do_vunmap = true;
 		for (i = 0; i < *npages; i++)
 			put_page(to_free[i]);
 	}

and not need any extra refs. I wish the compound page was a bit more
integrated, eg I could just do vm_inser_page() on a single compound page
and have it Just Work. But I have to treat it as separate pages there.

Thanks!


>> +static void *io_mem_alloc_single(struct page **pages, int nr_pages, size_t size,
>> +				 gfp_t gfp)
>> +{
>> +	void *ret;
>> +	int i;
>> +
>> +	for (i = 0; i < nr_pages; i++) {
>> +		pages[i] = alloc_page(gfp);
>> +		if (!pages[i])
>> +			goto err;
>> +	}
>> +
>> +	ret = vmap(pages, nr_pages, VM_MAP | VM_ALLOW_HUGE_VMAP, PAGE_KERNEL);
> 
> You can kill the VM_ALLOW_HUGE_VMAP.
> 
> It's a no-op in vmap(), since you're passing an array of order-0
> pages, which cannot be mapped by anything larger than PTEs.

Noted, will kill the VM_ALLOW_HUGE_VMAP.

-- 
Jens Axboe


