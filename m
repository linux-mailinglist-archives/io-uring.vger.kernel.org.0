Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41C1F5295A3
	for <lists+io-uring@lfdr.de>; Tue, 17 May 2022 01:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349477AbiEPX7I (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 May 2022 19:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347881AbiEPX7E (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 May 2022 19:59:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8A424093F;
        Mon, 16 May 2022 16:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=G2Pe5+/hZMZdxaHVnXju12u+Hh3e4wdzfN1LtoLlNGw=; b=vAuCHK0X/vS7yYqaqctkRFawfv
        t5zXLjdkNZ7efdtw/qXq6wgYjJ3ct1QChKD/5LIvAqWZYEiObflzCHg2iizO1leCqwTcj+5Edrntz
        Z+8gJq1gU1heFcKi/c2olMt9T0rWOZuvwzg/MLXZKWqNBvZmtwkAgEe5SAH9WczLotuKK7v/B5vPw
        rRWZsnQwQAH7ld1b5t6nK0RPdD3saDu/p/JGG8UCo5HMDAkrFcwUtBxPQBVCWJDA+vZcZndBbBBrS
        UYAgvDPtyzP1n+lqbfoKxGS7X+UtaCJHuTM4Y+rtiPAkbIGtgtfxVIlyNqeSSv1H57BqAEd3kah9b
        yeQLnUeA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nqkc7-00ALvq-1l; Mon, 16 May 2022 23:58:59 +0000
Date:   Tue, 17 May 2022 00:58:59 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz
Subject: Re: [RFC PATCH v2 03/16] iomap: use iomap_page_create_gfp() in
 __iomap_write_begin
Message-ID: <YoLlQ+lyko2Xr8Y1@casper.infradead.org>
References: <20220516164718.2419891-1-shr@fb.com>
 <20220516164718.2419891-4-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516164718.2419891-4-shr@fb.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, May 16, 2022 at 09:47:05AM -0700, Stefan Roesch wrote:
> This change uses the new iomap_page_create_gfp() function in the
> function __iomap_write_begin().
> 
> No intended functional changes in this patch.

But there is one.  I don't know if it's harmful or not.

>  	const struct iomap *srcmap = iomap_iter_srcmap(iter);
> -	struct iomap_page *iop = iomap_page_create(iter->inode, folio);
> +	struct iomap_page *iop = to_iomap_page(folio);
>  	loff_t block_size = i_blocksize(iter->inode);
>  	loff_t block_start = round_down(pos, block_size);
>  	loff_t block_end = round_up(pos + len, block_size);
> +	unsigned int nr_blocks = i_blocks_per_folio(iter->inode, folio);
>  	size_t from = offset_in_folio(folio, pos), to = from + len;
>  	size_t poff, plen;
> +	gfp_t  gfp = GFP_NOFS | __GFP_NOFAIL;

For the case where the folio is already uptodate, would need an iop to
be written back (ie nr_blocks > 1) but doesn't have an iop, we used to
create one here, and now we don't.

How much testing has this seen with blocksize < 4k?

>  	if (folio_test_uptodate(folio))
>  		return 0;
>  	folio_clear_error(folio);
>  
> +	if (!iop && nr_blocks > 1)
> +		iop = iomap_page_create_gfp(iter->inode, folio, nr_blocks, gfp);
> +
>  	do {
>  		iomap_adjust_read_range(iter->inode, folio, &block_start,
>  				block_end - block_start, &poff, &plen);
> -- 
> 2.30.2
> 
> 
