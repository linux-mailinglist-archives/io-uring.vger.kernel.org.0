Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3B41535351
	for <lists+io-uring@lfdr.de>; Thu, 26 May 2022 20:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233606AbiEZSZr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 26 May 2022 14:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349685AbiEZSZl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 26 May 2022 14:25:41 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A9CB62A35;
        Thu, 26 May 2022 11:25:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6DDEBCE22CE;
        Thu, 26 May 2022 18:25:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5F89C385A9;
        Thu, 26 May 2022 18:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653589536;
        bh=MYNWgivGhGmmsbjTVz5uPvg0gyA0R4dUrcZQM07Dcqo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dc2AjXmO9dHGIz24yuTGtdzntHWgcM+7HyGWa2sDUjyNeGJZy2sGhlFvT04MalrpT
         qCxXjnTw565MQduk8+DLqbaeIclS5wGPfdnWlxJ4RI9ltkfrQJ20JtGAlsaI9ombVF
         GDF9+ImAlgHlmLYUOhGIMy+FLo1MunRPsZ4CXwrYpBqPQ+TQOBlwgrawyNdS4neP/Y
         cxAqdYmqc8NebWW5lT1DvAXOoPinUb5KGGqesQjs6+2iOt2RpEwOGi5AemRsAHRnA+
         DcwmTS7tfAu7idBI9MyAxXVlB8ay3LE7QJnu02RirfkZCpxVJsQalwoIRY0UBsLab1
         1uQHcrubSEK7g==
Date:   Thu, 26 May 2022 11:25:36 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org
Subject: Re: [PATCH v6 04/16] iomap: Add flags parameter to
 iomap_page_create()
Message-ID: <Yo/GIF1EoK7Acvmy@magnolia>
References: <20220526173840.578265-1-shr@fb.com>
 <20220526173840.578265-5-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220526173840.578265-5-shr@fb.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, May 26, 2022 at 10:38:28AM -0700, Stefan Roesch wrote:
> Add the kiocb flags parameter to the function iomap_page_create().
> Depending on the value of the flags parameter it enables different gfp
> flags.
> 
> No intended functional changes in this patch.
> 
> Signed-off-by: Stefan Roesch <shr@fb.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> ---
>  fs/iomap/buffered-io.c | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 8ce8720093b9..d6ddc54e190e 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -44,16 +44,21 @@ static inline struct iomap_page *to_iomap_page(struct folio *folio)
>  static struct bio_set iomap_ioend_bioset;
>  
>  static struct iomap_page *
> -iomap_page_create(struct inode *inode, struct folio *folio)
> +iomap_page_create(struct inode *inode, struct folio *folio, unsigned int flags)
>  {
>  	struct iomap_page *iop = to_iomap_page(folio);
>  	unsigned int nr_blocks = i_blocks_per_folio(inode, folio);
> +	gfp_t gfp = GFP_NOFS | __GFP_NOFAIL;
>  
>  	if (iop || nr_blocks <= 1)
>  		return iop;
>  
> +	if (flags & IOMAP_NOWAIT)
> +		gfp = GFP_NOWAIT;

Hmm.  GFP_NOWAIT means we don't wait for reclaim or IO or filesystem
callbacks, and NOFAIL means we retry indefinitely.  What happens in the
NOWAIT|NOFAIL case?  Does that imply that the kzalloc loops without
triggering direct reclaim until someone else frees enough memory?

--D

> +
>  	iop = kzalloc(struct_size(iop, uptodate, BITS_TO_LONGS(nr_blocks)),
> -			GFP_NOFS | __GFP_NOFAIL);
> +		      gfp);
> +
>  	spin_lock_init(&iop->uptodate_lock);
>  	if (folio_test_uptodate(folio))
>  		bitmap_fill(iop->uptodate, nr_blocks);
> @@ -226,7 +231,7 @@ static int iomap_read_inline_data(const struct iomap_iter *iter,
>  	if (WARN_ON_ONCE(size > iomap->length))
>  		return -EIO;
>  	if (offset > 0)
> -		iop = iomap_page_create(iter->inode, folio);
> +		iop = iomap_page_create(iter->inode, folio, iter->flags);
>  	else
>  		iop = to_iomap_page(folio);
>  
> @@ -264,7 +269,7 @@ static loff_t iomap_readpage_iter(const struct iomap_iter *iter,
>  		return iomap_read_inline_data(iter, folio);
>  
>  	/* zero post-eof blocks as the page may be mapped */
> -	iop = iomap_page_create(iter->inode, folio);
> +	iop = iomap_page_create(iter->inode, folio, iter->flags);
>  	iomap_adjust_read_range(iter->inode, folio, &pos, length, &poff, &plen);
>  	if (plen == 0)
>  		goto done;
> @@ -550,7 +555,7 @@ static int __iomap_write_begin(const struct iomap_iter *iter, loff_t pos,
>  		size_t len, struct folio *folio)
>  {
>  	const struct iomap *srcmap = iomap_iter_srcmap(iter);
> -	struct iomap_page *iop = iomap_page_create(iter->inode, folio);
> +	struct iomap_page *iop;
>  	loff_t block_size = i_blocksize(iter->inode);
>  	loff_t block_start = round_down(pos, block_size);
>  	loff_t block_end = round_up(pos + len, block_size);
> @@ -561,6 +566,8 @@ static int __iomap_write_begin(const struct iomap_iter *iter, loff_t pos,
>  		return 0;
>  	folio_clear_error(folio);
>  
> +	iop = iomap_page_create(iter->inode, folio, iter->flags);
> +
>  	do {
>  		iomap_adjust_read_range(iter->inode, folio, &block_start,
>  				block_end - block_start, &poff, &plen);
> @@ -1332,7 +1339,7 @@ iomap_writepage_map(struct iomap_writepage_ctx *wpc,
>  		struct writeback_control *wbc, struct inode *inode,
>  		struct folio *folio, u64 end_pos)
>  {
> -	struct iomap_page *iop = iomap_page_create(inode, folio);
> +	struct iomap_page *iop = iomap_page_create(inode, folio, 0);
>  	struct iomap_ioend *ioend, *next;
>  	unsigned len = i_blocksize(inode);
>  	unsigned nblocks = i_blocks_per_folio(inode, folio);
> -- 
> 2.30.2
> 
