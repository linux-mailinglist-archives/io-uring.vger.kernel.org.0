Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F094253537A
	for <lists+io-uring@lfdr.de>; Thu, 26 May 2022 20:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232994AbiEZSm3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 26 May 2022 14:42:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231529AbiEZSm3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 26 May 2022 14:42:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C69F52E09B;
        Thu, 26 May 2022 11:42:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89192B82176;
        Thu, 26 May 2022 18:42:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A765C385A9;
        Thu, 26 May 2022 18:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653590545;
        bh=k+dBOhzwdWTL8bGFMa/Yqn35ITMFnJvwwucQeBP5VEg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k9Di1lZt8U8OMba1LmXnJfX1IeZITEbUz+YKeoGVJ8MNplCfeVQzGtZiPAxnfaTaA
         y1i2wXtzhDvirHVFiprIcRGoMQSeY8lXGrA1Peulp0Rn1DyIsfyp+Cga9xIWf/bOjM
         lvjy0uYAZeWuD/tknHYNevdZKZRzruDXiJuIbuFTJrdpUy4sBNZppSuFZfg8XPlX3F
         RPoGvmIYYmnK/qC+3jYe2ZLjySCfX+Zqf3Vcpm0eLD669bkwAbqQZQRjJ71Ahx6Zp2
         uKbG+XRPp4ywDh4kpodfOgnGQAilkwZvrnlKagYhDWp6ehR1/+x+rcqFM1A70fPriJ
         72+g4c1LVKfHQ==
Date:   Thu, 26 May 2022 11:42:24 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org
Subject: Re: [PATCH v6 05/16] iomap: Add async buffered write support
Message-ID: <Yo/KEFfqcl3H4+q/@magnolia>
References: <20220526173840.578265-1-shr@fb.com>
 <20220526173840.578265-6-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220526173840.578265-6-shr@fb.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, May 26, 2022 at 10:38:29AM -0700, Stefan Roesch wrote:
> This adds async buffered write support to iomap.
> 
> This replaces the call to balance_dirty_pages_ratelimited() with the
> call to balance_dirty_pages_ratelimited_flags. This allows to specify if
> the write request is async or not.
> 
> In addition this also moves the above function call to the beginning of
> the function. If the function call is at the end of the function and the
> decision is made to throttle writes, then there is no request that
> io-uring can wait on. By moving it to the beginning of the function, the
> write request is not issued, but returns -EAGAIN instead. io-uring will
> punt the request and process it in the io-worker.
> 
> By moving the function call to the beginning of the function, the write
> throttling will happen one page later.

It does?  I would have thought that moving it before iomap_write_begin
call would make the throttling happen one page sooner?  Sorry if I'm
being dense here...

> Signed-off-by: Stefan Roesch <shr@fb.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> ---
>  fs/iomap/buffered-io.c | 31 +++++++++++++++++++++++++++----
>  1 file changed, 27 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index d6ddc54e190e..2281667646d2 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -559,6 +559,7 @@ static int __iomap_write_begin(const struct iomap_iter *iter, loff_t pos,
>  	loff_t block_size = i_blocksize(iter->inode);
>  	loff_t block_start = round_down(pos, block_size);
>  	loff_t block_end = round_up(pos + len, block_size);
> +	unsigned int nr_blocks = i_blocks_per_folio(iter->inode, folio);
>  	size_t from = offset_in_folio(folio, pos), to = from + len;
>  	size_t poff, plen;
>  
> @@ -567,6 +568,8 @@ static int __iomap_write_begin(const struct iomap_iter *iter, loff_t pos,
>  	folio_clear_error(folio);
>  
>  	iop = iomap_page_create(iter->inode, folio, iter->flags);
> +	if ((iter->flags & IOMAP_NOWAIT) && !iop && nr_blocks > 1)
> +		return -EAGAIN;
>  
>  	do {
>  		iomap_adjust_read_range(iter->inode, folio, &block_start,
> @@ -584,7 +587,12 @@ static int __iomap_write_begin(const struct iomap_iter *iter, loff_t pos,
>  				return -EIO;
>  			folio_zero_segments(folio, poff, from, to, poff + plen);
>  		} else {
> -			int status = iomap_read_folio_sync(block_start, folio,
> +			int status;
> +
> +			if (iter->flags & IOMAP_NOWAIT)
> +				return -EAGAIN;
> +
> +			status = iomap_read_folio_sync(block_start, folio,
>  					poff, plen, srcmap);
>  			if (status)
>  				return status;
> @@ -613,6 +621,9 @@ static int iomap_write_begin(const struct iomap_iter *iter, loff_t pos,
>  	unsigned fgp = FGP_LOCK | FGP_WRITE | FGP_CREAT | FGP_STABLE | FGP_NOFS;
>  	int status = 0;
>  
> +	if (iter->flags & IOMAP_NOWAIT)
> +		fgp |= FGP_NOWAIT;

FGP_NOWAIT can cause __filemap_get_folio to return a NULL folio, which
makes iomap_write_begin return -ENOMEM.  If nothing has been written
yet, won't that cause the ENOMEM to escape to userspace?  Why do we want
that instead of EAGAIN?

> +
>  	BUG_ON(pos + len > iter->iomap.offset + iter->iomap.length);
>  	if (srcmap != &iter->iomap)
>  		BUG_ON(pos + len > srcmap->offset + srcmap->length);
> @@ -750,6 +761,8 @@ static loff_t iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
>  	loff_t pos = iter->pos;
>  	ssize_t written = 0;
>  	long status = 0;
> +	struct address_space *mapping = iter->inode->i_mapping;
> +	unsigned int bdp_flags = (iter->flags & IOMAP_NOWAIT) ? BDP_ASYNC : 0;
>  
>  	do {
>  		struct folio *folio;
> @@ -762,6 +775,11 @@ static loff_t iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
>  		bytes = min_t(unsigned long, PAGE_SIZE - offset,
>  						iov_iter_count(i));
>  again:
> +		status = balance_dirty_pages_ratelimited_flags(mapping,
> +							       bdp_flags);
> +		if (unlikely(status))
> +			break;
> +
>  		if (bytes > length)
>  			bytes = length;
>  
> @@ -770,6 +788,10 @@ static loff_t iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
>  		 * Otherwise there's a nasty deadlock on copying from the
>  		 * same page as we're writing to, without it being marked
>  		 * up-to-date.
> +		 *
> +		 * For async buffered writes the assumption is that the user
> +		 * page has already been faulted in. This can be optimized by
> +		 * faulting the user page in the prepare phase of io-uring.

I don't think this pattern is unique to async writes with io_uring --
gfs2 also wanted this "try as many pages as you can until you hit a page
fault and then return a short write to caller so it can fault in the
rest" behavior.

--D

>  		 */
>  		if (unlikely(fault_in_iov_iter_readable(i, bytes) == bytes)) {
>  			status = -EFAULT;
> @@ -781,7 +803,7 @@ static loff_t iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
>  			break;
>  
>  		page = folio_file_page(folio, pos >> PAGE_SHIFT);
> -		if (mapping_writably_mapped(iter->inode->i_mapping))
> +		if (mapping_writably_mapped(mapping))
>  			flush_dcache_page(page);
>  
>  		copied = copy_page_from_iter_atomic(page, offset, bytes, i);
> @@ -806,8 +828,6 @@ static loff_t iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
>  		pos += status;
>  		written += status;
>  		length -= status;
> -
> -		balance_dirty_pages_ratelimited(iter->inode->i_mapping);
>  	} while (iov_iter_count(i) && length);
>  
>  	return written ? written : status;
> @@ -825,6 +845,9 @@ iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *i,
>  	};
>  	int ret;
>  
> +	if (iocb->ki_flags & IOCB_NOWAIT)
> +		iter.flags |= IOMAP_NOWAIT;
> +
>  	while ((ret = iomap_iter(&iter, ops)) > 0)
>  		iter.processed = iomap_write_iter(&iter, i);
>  	if (iter.pos == iocb->ki_pos)
> -- 
> 2.30.2
> 
