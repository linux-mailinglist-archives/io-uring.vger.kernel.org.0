Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 752183E9F25
	for <lists+io-uring@lfdr.de>; Thu, 12 Aug 2021 09:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232459AbhHLHDP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Aug 2021 03:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbhHLHDO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Aug 2021 03:03:14 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01529C061765;
        Thu, 12 Aug 2021 00:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=nbEowCMzfn1uHkokwchBvStpLX9C0dJPeeeoWzRrkWE=; b=dbZ2ijZPSIHuLzhXVAF53MpnVY
        G2IyKaWmRoqMEpsbtxwwSRB7iAaL6lf8C6Ih5y5QRvvQEvNaCsN13Kxdkk3x1PIF821AxYBLco92B
        oNjx3/tn/vj+SjOPKY7n7dF+YII+75SAo4a311DMlW4eHYMOpLoHpLQJW3j7qfbed3sMYx8+Xb74+
        nIibpkoQToCEtw166jXLlRKNMT4nop9dFGXdRqiOPjQ805kQJSKwuS1JKFUoheo0QQWnnCo8hIwpm
        8roAyToxf6IlbLfuTMg8KLnHsKZzqsGxPi39+UkE24P5QVYeEPpkbafIjoLOtQygKOZUgBzqg6gJ7
        5zGq95Ng==;
Received: from [2001:4bb8:184:6215:d7d:1904:40de:694d] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mE4if-00EGcK-3i; Thu, 12 Aug 2021 07:01:52 +0000
Date:   Thu, 12 Aug 2021 09:01:35 +0200
From:   Christoph Hellwig <hch@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        hch@infradead.org
Subject: Re: [PATCH 3/6] bio: add allocation cache abstraction
Message-ID: <YRTHTyz+tlRuGv2i@infradead.org>
References: <20210811193533.766613-1-axboe@kernel.dk>
 <20210811193533.766613-4-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811193533.766613-4-axboe@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Aug 11, 2021 at 01:35:30PM -0600, Jens Axboe wrote:
> +	struct bio *bio;
> +	unsigned int i;
> +
> +	i = 0;

Initialize at declaration time?

> +static inline bool __bio_put(struct bio *bio)
> +{
> +	if (!bio_flagged(bio, BIO_REFFED))
> +		return true;
> +
> +	BIO_BUG_ON(!atomic_read(&bio->__bi_cnt));
> +
> +	/*
> +	 * last put frees it
> +	 */
> +	return atomic_dec_and_test(&bio->__bi_cnt);
> +}

Please avoid this helper, we can trivially do the check inside of bio_put:

	if (bio_flagged(bio, BIO_REFFED)) {
		BIO_BUG_ON(!atomic_read(&bio->__bi_cnt));
		if (!atomic_dec_and_test(&bio->__bi_cnt))
			return;
	}

> -			bio_free(bio);
> +	if (bio_flagged(bio, BIO_PERCPU_CACHE)) {
> +		struct bio_alloc_cache *cache;
> +
> +		bio_uninit(bio);
> +		cache = per_cpu_ptr(bio->bi_pool->cache, get_cpu());
> +		bio_list_add_head(&cache->free_list, bio);
> +		cache->nr++;
> +		if (cache->nr > ALLOC_CACHE_MAX + ALLOC_CACHE_SLACK)

Folding the increment as a prefix here would make the increment and test
semantics a little more obvious.

> +struct bio *bio_alloc_kiocb(struct kiocb *kiocb, gfp_t gfp,
> +			    unsigned short nr_vecs, struct bio_set *bs)
> +{
> +	struct bio_alloc_cache *cache = NULL;
> +	struct bio *bio;
> +
> +	if (!(kiocb->ki_flags & IOCB_ALLOC_CACHE) || nr_vecs > BIO_INLINE_VECS)
> +		goto normal_alloc;
> +
> +	cache = per_cpu_ptr(bs->cache, get_cpu());
> +	bio = bio_list_pop(&cache->free_list);
> +	if (bio) {
> +		cache->nr--;
> +		put_cpu();
> +		bio_init(bio, nr_vecs ? bio->bi_inline_vecs : NULL, nr_vecs);
> +		bio_set_flag(bio, BIO_PERCPU_CACHE);
> +		return bio;
> +	}
> +	put_cpu();
> +normal_alloc:
> +	bio = bio_alloc_bioset(gfp, nr_vecs, bs);
> +	if (cache)
> +		bio_set_flag(bio, BIO_PERCPU_CACHE);
> +	return bio;

The goto here is pretty obsfucating and adds an extra patch to the fast
path.

Also I don't think we need the gfp argument here at all - it should
always be GFP_KERNEL.  In fact I plan to kill these arguments from much
of the block layer as the places that need NOIO of NOFS semantics can
and should move to set that in the per-thread context.

> -static inline struct bio *bio_list_pop(struct bio_list *bl)
> +static inline void bio_list_del_head(struct bio_list *bl, struct bio *head)
>  {
> -	struct bio *bio = bl->head;
> -
> -	if (bio) {
> +	if (head) {
>  		bl->head = bl->head->bi_next;
>  		if (!bl->head)
>  			bl->tail = NULL;
>  
> -		bio->bi_next = NULL;
> +		head->bi_next = NULL;
>  	}
> +}
> +
> +static inline struct bio *bio_list_pop(struct bio_list *bl)
> +{
> +	struct bio *bio = bl->head;
>  
> +	bio_list_del_head(bl, bio);
>  	return bio;
>  }

No need for this change.

>
>  
> @@ -699,6 +706,12 @@ struct bio_set {
>  	struct kmem_cache *bio_slab;
>  	unsigned int front_pad;
>  
> +	/*
> +	 * per-cpu bio alloc cache and notifier
> +	 */
> +	struct bio_alloc_cache __percpu *cache;
> +	struct hlist_node cpuhp_dead;
> +

I'd keep the hotplug list entry at the end instead of bloating the
cache line used in the fast path.
