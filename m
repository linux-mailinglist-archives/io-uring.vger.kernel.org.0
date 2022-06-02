Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A611F53BC75
	for <lists+io-uring@lfdr.de>; Thu,  2 Jun 2022 18:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237010AbiFBQ0P (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Jun 2022 12:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237029AbiFBQ0O (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Jun 2022 12:26:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D84292B07CD;
        Thu,  2 Jun 2022 09:26:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90344B81F38;
        Thu,  2 Jun 2022 16:26:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49649C385A5;
        Thu,  2 Jun 2022 16:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654187171;
        bh=ve6OJtlopmJml1gTqLA69PVfn0m5mZ9eSDCyxk/zWoc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uCvlSDNurNkKWRcyCbTVUell/I+DnhnsXW2m+IIms7hjc44ilA8zFKkmj/N1Y3cxD
         GgRTk+oZ1Id40406QZE7sYKojGnnRFKopHBt5W79FLUTIiSBHxmB5pXdYUrOsTZQjM
         WKURYy1jTNknmW5d4SK8ChLkPrBhnTMDafuLuauR7IqXKJQdbidxPo+7Du2UOH8C3D
         ustpy9OEmoQL3sfQFmYx3GWm87ZcviIhTEKmGHnE6sUafRi46HkUVnzYYjHKhFFDMA
         Ji9Gm+aUZ7lx6rAR+bDKLS785X62hnxwnetjN+ZYwyvXeXjo/8RZ/47v4FHP1+x1Eo
         U/+xyRbGQMORQ==
Date:   Thu, 2 Jun 2022 09:26:10 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org,
        axboe@kernel.dk, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v7 04/15] iomap: Add flags parameter to
 iomap_page_create()
Message-ID: <YpjkotBv/WmoHcEy@magnolia>
References: <20220601210141.3773402-1-shr@fb.com>
 <20220601210141.3773402-5-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220601210141.3773402-5-shr@fb.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jun 01, 2022 at 02:01:30PM -0700, Stefan Roesch wrote:
> Add the kiocb flags parameter to the function iomap_page_create().
> Depending on the value of the flags parameter it enables different gfp
> flags.
> 
> No intended functional changes in this patch.
> 
> Signed-off-by: Stefan Roesch <shr@fb.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/iomap/buffered-io.c | 21 +++++++++++++++------
>  1 file changed, 15 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index d2a9f699e17e..705f80cd2d4e 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -44,16 +44,23 @@ static inline struct iomap_page *to_iomap_page(struct folio *folio)
>  static struct bio_set iomap_ioend_bioset;
>  
>  static struct iomap_page *
> -iomap_page_create(struct inode *inode, struct folio *folio)
> +iomap_page_create(struct inode *inode, struct folio *folio, unsigned int flags)
>  {
>  	struct iomap_page *iop = to_iomap_page(folio);
>  	unsigned int nr_blocks = i_blocks_per_folio(inode, folio);
> +	gfp_t gfp;
>  
>  	if (iop || nr_blocks <= 1)
>  		return iop;
>  
> +	if (flags & IOMAP_NOWAIT)
> +		gfp = GFP_NOWAIT;
> +	else
> +		gfp = GFP_NOFS | __GFP_NOFAIL;

Thanks for changing this!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +
>  	iop = kzalloc(struct_size(iop, uptodate, BITS_TO_LONGS(nr_blocks)),
> -			GFP_NOFS | __GFP_NOFAIL);
> +		      gfp);
> +
>  	spin_lock_init(&iop->uptodate_lock);
>  	if (folio_test_uptodate(folio))
>  		bitmap_fill(iop->uptodate, nr_blocks);
> @@ -226,7 +233,7 @@ static int iomap_read_inline_data(const struct iomap_iter *iter,
>  	if (WARN_ON_ONCE(size > iomap->length))
>  		return -EIO;
>  	if (offset > 0)
> -		iop = iomap_page_create(iter->inode, folio);
> +		iop = iomap_page_create(iter->inode, folio, iter->flags);
>  	else
>  		iop = to_iomap_page(folio);
>  
> @@ -264,7 +271,7 @@ static loff_t iomap_readpage_iter(const struct iomap_iter *iter,
>  		return iomap_read_inline_data(iter, folio);
>  
>  	/* zero post-eof blocks as the page may be mapped */
> -	iop = iomap_page_create(iter->inode, folio);
> +	iop = iomap_page_create(iter->inode, folio, iter->flags);
>  	iomap_adjust_read_range(iter->inode, folio, &pos, length, &poff, &plen);
>  	if (plen == 0)
>  		goto done;
> @@ -547,7 +554,7 @@ static int __iomap_write_begin(const struct iomap_iter *iter, loff_t pos,
>  		size_t len, struct folio *folio)
>  {
>  	const struct iomap *srcmap = iomap_iter_srcmap(iter);
> -	struct iomap_page *iop = iomap_page_create(iter->inode, folio);
> +	struct iomap_page *iop;
>  	loff_t block_size = i_blocksize(iter->inode);
>  	loff_t block_start = round_down(pos, block_size);
>  	loff_t block_end = round_up(pos + len, block_size);
> @@ -558,6 +565,8 @@ static int __iomap_write_begin(const struct iomap_iter *iter, loff_t pos,
>  		return 0;
>  	folio_clear_error(folio);
>  
> +	iop = iomap_page_create(iter->inode, folio, iter->flags);
> +
>  	do {
>  		iomap_adjust_read_range(iter->inode, folio, &block_start,
>  				block_end - block_start, &poff, &plen);
> @@ -1329,7 +1338,7 @@ iomap_writepage_map(struct iomap_writepage_ctx *wpc,
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
