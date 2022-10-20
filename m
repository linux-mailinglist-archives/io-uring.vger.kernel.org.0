Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 696166059CC
	for <lists+io-uring@lfdr.de>; Thu, 20 Oct 2022 10:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbiJTIbr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Oct 2022 04:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbiJTIbp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Oct 2022 04:31:45 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6756E15F300;
        Thu, 20 Oct 2022 01:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=CiTIzenZZmk7uPE6Az6q81BtgMmAxpSFtivPUoqj25k=; b=wX7LfYDty6UXHOE/DVJRPjnil9
        BEq1wb2ggqc0qjufuzzWevD6uqrKlNmI5TXK/lxAojYtpYRty2anESHLFjhXAmAWvTAgiR7atuffN
        hoLAOfBWkwWZveYAs5x1knJHAmhJgm1lHy+Ut0GVag+vMiomJBertn1L5siNxpJ7qd/OmjUw1Ma7N
        lUW6vKo7GKMq/q2PNIO9Xx8r9wC5F3abeYPz9u/sCFw1oIZQ2rc9kKd/ZaljOnhPQ4/D2hm3a4i9n
        AutU2/s4LYmHnhC8Re9nUmWcqbayLj7fkhBPsnSW8A68+Hj8a3ZGIOHwEyvSZ1Z08n2F39rjwDbp1
        LHK8tvFQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1olQxr-00CEMs-8z; Thu, 20 Oct 2022 08:31:43 +0000
Date:   Thu, 20 Oct 2022 01:31:43 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [RFC for-next v2 3/4] block/bio: add pcpu caching for
 non-polling bio_put
Message-ID: <Y1EHb36rQgqwbsXD@infradead.org>
References: <cover.1666122465.git.asml.silence@gmail.com>
 <9fd04486d972c1f3ef273fa26b4b6bf51a5e4270.1666122465.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9fd04486d972c1f3ef273fa26b4b6bf51a5e4270.1666122465.git.asml.silence@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> +	unsigned long flags;
>  
>  	cache = per_cpu_ptr(bio->bi_pool->cache, get_cpu());
>  	bio_uninit(bio);
> @@ -737,12 +776,15 @@ static inline void bio_put_percpu_cache(struct bio *bio)
>  		cache->free_list = bio;
>  		cache->nr++;
>  	} else {
> -		put_cpu();
> -		bio_free(bio);
> -		return;
> +		local_irq_save(flags);
> +		bio->bi_next = cache->free_list_irq;
> +		cache->free_list_irq = bio;
> +		cache->nr_irq++;
> +		local_irq_restore(flags);
>  	}

Ok, I guess with that my previous comments don't make quite
as much sense any more.  I think youcan keep flags local in
the branch here, though.
