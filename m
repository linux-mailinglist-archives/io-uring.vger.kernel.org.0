Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFB244B59A7
	for <lists+io-uring@lfdr.de>; Mon, 14 Feb 2022 19:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237019AbiBNSOU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Feb 2022 13:14:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233083AbiBNSOS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Feb 2022 13:14:18 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FC3A65426;
        Mon, 14 Feb 2022 10:14:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gZk48DWl/X/wLqDnKuDw3FHoocPr0eoj6xn33SzKit0=; b=YkypXM1CO6rGTl6RzndZaQyJIq
        1YmFKeHUJGgQ7L8MgQYmJ6kiqenOXgl2nnO7iHq1+rg/IWqvAZa0PxVpbJ/Dzr1GTLRq4S1eYZQCp
        Z/0oJQ0XGONGmgwsTGWugqyIzHoYzucvwf7F90nCV91qB+FXlBcyHrkTPcK2G84H8ES47a9UIoJOX
        /X7RDgaqfrayRUjrf+lvdqWzX7A3A1j33rOv7F70YbnRZJNWnRsE/b3JdlIHnlhnLbl8yfARRhQyb
        aEXO+JxE06OBTJ3rrIiEqfwX85GYjwf9rwh3ZwATI1YaWwAtQs2YRBu+zFd1ATHKGarfgRnQp2HF0
        Cg8YRbjw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nJfrS-00D9EJ-5Q; Mon, 14 Feb 2022 18:14:06 +0000
Date:   Mon, 14 Feb 2022 18:14:06 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-block@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v1 07/14] fs: Add aop_flags parameter to
 create_page_buffers()
Message-ID: <Ygqb7j8PUIg8dU2v@casper.infradead.org>
References: <20220214174403.4147994-1-shr@fb.com>
 <20220214174403.4147994-8-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214174403.4147994-8-shr@fb.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Feb 14, 2022 at 09:43:56AM -0800, Stefan Roesch wrote:
> This adds the aop_flags parameter to the create_page_buffers function.
> When AOP_FLAGS_NOWAIT parameter is set, the atomic allocation flag is
> set. The AOP_FLAGS_NOWAIT flag is set, when async buffered writes are
> enabled.

Why is this better than passing in gfp flags directly?

> Signed-off-by: Stefan Roesch <shr@fb.com>
> ---
>  fs/buffer.c | 28 +++++++++++++++++++++-------
>  1 file changed, 21 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 948505480b43..5e3067173580 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1682,13 +1682,27 @@ static inline int block_size_bits(unsigned int blocksize)
>  	return ilog2(blocksize);
>  }
>  
> -static struct buffer_head *create_page_buffers(struct page *page, struct inode *inode, unsigned int b_state)
> +static struct buffer_head *create_page_buffers(struct page *page,
> +					struct inode *inode,
> +					unsigned int b_state,
> +					unsigned int aop_flags)
>  {
>  	BUG_ON(!PageLocked(page));
>  
> -	if (!page_has_buffers(page))
> -		create_empty_buffers(page, 1 << READ_ONCE(inode->i_blkbits),
> -				     b_state);
> +	if (!page_has_buffers(page)) {
> +		gfp_t gfp = GFP_NOFS | __GFP_ACCOUNT;
> +
> +		if (aop_flags & AOP_FLAGS_NOWAIT) {
> +			gfp |= GFP_ATOMIC | __GFP_NOWARN;
> +			gfp &= ~__GFP_DIRECT_RECLAIM;
> +		} else {
> +			gfp |= __GFP_NOFAIL;
> +		}
> +
> +		__create_empty_buffers(page, 1 << READ_ONCE(inode->i_blkbits),
> +				     b_state, gfp);
> +	}
> +
>  	return page_buffers(page);
>  }
>  
> @@ -1734,7 +1748,7 @@ int __block_write_full_page(struct inode *inode, struct page *page,
>  	int write_flags = wbc_to_write_flags(wbc);
>  
>  	head = create_page_buffers(page, inode,
> -					(1 << BH_Dirty)|(1 << BH_Uptodate));
> +					(1 << BH_Dirty)|(1 << BH_Uptodate), 0);
>  
>  	/*
>  	 * Be very careful.  We have no exclusion from __set_page_dirty_buffers
> @@ -2000,7 +2014,7 @@ int __block_write_begin_int(struct folio *folio, loff_t pos, unsigned len,
>  	BUG_ON(to > PAGE_SIZE);
>  	BUG_ON(from > to);
>  
> -	head = create_page_buffers(&folio->page, inode, 0);
> +	head = create_page_buffers(&folio->page, inode, 0, flags);
>  	blocksize = head->b_size;
>  	bbits = block_size_bits(blocksize);
>  
> @@ -2280,7 +2294,7 @@ int block_read_full_page(struct page *page, get_block_t *get_block)
>  	int nr, i;
>  	int fully_mapped = 1;
>  
> -	head = create_page_buffers(page, inode, 0);
> +	head = create_page_buffers(page, inode, 0, 0);
>  	blocksize = head->b_size;
>  	bbits = block_size_bits(blocksize);
>  
> -- 
> 2.30.2
> 
