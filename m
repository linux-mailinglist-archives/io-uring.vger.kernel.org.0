Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 024263EA76A
	for <lists+io-uring@lfdr.de>; Thu, 12 Aug 2021 17:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237171AbhHLPUS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Aug 2021 11:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235696AbhHLPUS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Aug 2021 11:20:18 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63E4C061756;
        Thu, 12 Aug 2021 08:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=r8cNJddWBoOtWaMWuMqZPq0UVdu3LyAnnoqeAE14WZc=; b=L79MeH8ZG+pOG5Dc7Fj9KUfud+
        al3ivecEC0IJBRLEObATA4XaWQB9b1VetWi6/DzluRkz9daeKlZbQzOpto1QjEF25QJlctQ37/h4K
        DpWURem/5Bd76NB4lIfI1jFHCfG44wb6JBuiEN0kn0NLKsCUQr7Tzsw7satwD8fkV1NqcilnkA1E2
        YK8VRLZDz/OfUnyFFMYkguSqH2Npj2lbC3v//Xud5gwF+z27LcMaYc2jkSG9IlVWXyo/AISdtEeI0
        X0azsGMCcNoE9Etks31F1pmeU6zUsHXz5GK02JdfOgMHkgCIsvbFfN0pBd/s8QA+ljlf9xKxrsTfj
        Sp+9a5Qg==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mECTn-00EhsB-9O; Thu, 12 Aug 2021 15:19:02 +0000
Date:   Thu, 12 Aug 2021 16:18:47 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@infradead.org>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: Re: [PATCH 3/6] bio: add allocation cache abstraction
Message-ID: <YRU713wjR0UBQ1uc@infradead.org>
References: <20210811193533.766613-1-axboe@kernel.dk>
 <20210811193533.766613-4-axboe@kernel.dk>
 <YRTHTyz+tlRuGv2i@infradead.org>
 <845afc13-448d-0cb1-f9f7-86ac91d27c0f@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <845afc13-448d-0cb1-f9f7-86ac91d27c0f@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Aug 12, 2021 at 09:08:29AM -0600, Jens Axboe wrote:
> >> +	cache = per_cpu_ptr(bs->cache, get_cpu());
> >> +	bio = bio_list_pop(&cache->free_list);
> >> +	if (bio) {
> >> +		cache->nr--;
> >> +		put_cpu();
> >> +		bio_init(bio, nr_vecs ? bio->bi_inline_vecs : NULL, nr_vecs);
> >> +		bio_set_flag(bio, BIO_PERCPU_CACHE);
> >> +		return bio;
> >> +	}
> >> +	put_cpu();
> >> +normal_alloc:
> >> +	bio = bio_alloc_bioset(gfp, nr_vecs, bs);
> >> +	if (cache)
> >> +		bio_set_flag(bio, BIO_PERCPU_CACHE);
> >> +	return bio;
> > 
> > The goto here is pretty obsfucating and adds an extra patch to the fast
> > path.
> 
> I don't agree, and it's not the fast path - the fast path is popping off
> a bio off the list, not hitting the allocator.

Oh, I see you special case the list pop return now.  Still seems much
easier to follow to avoid the goto, the cache initialization and the
conditional in the no bio found in the list case (see patch below).

diff --git a/block/bio.c b/block/bio.c
index 689335c00937..b42621cecbef 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1707,11 +1707,11 @@ EXPORT_SYMBOL(bioset_init_from_src);
 struct bio *bio_alloc_kiocb(struct kiocb *kiocb, gfp_t gfp,
 			    unsigned short nr_vecs, struct bio_set *bs)
 {
-	struct bio_alloc_cache *cache = NULL;
+	struct bio_alloc_cache *cache;
 	struct bio *bio;
 
 	if (!(kiocb->ki_flags & IOCB_ALLOC_CACHE) || nr_vecs > BIO_INLINE_VECS)
-		goto normal_alloc;
+		return bio_alloc_bioset(gfp, nr_vecs, bs);
 
 	cache = per_cpu_ptr(bs->cache, get_cpu());
 	bio = bio_list_pop(&cache->free_list);
@@ -1723,10 +1723,8 @@ struct bio *bio_alloc_kiocb(struct kiocb *kiocb, gfp_t gfp,
 		return bio;
 	}
 	put_cpu();
-normal_alloc:
 	bio = bio_alloc_bioset(gfp, nr_vecs, bs);
-	if (cache)
-		bio_set_flag(bio, BIO_PERCPU_CACHE);
+	bio_set_flag(bio, BIO_PERCPU_CACHE);
 	return bio;
 }
 
