Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7C3E535619
	for <lists+io-uring@lfdr.de>; Fri, 27 May 2022 00:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244696AbiEZWhM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 26 May 2022 18:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiEZWhM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 26 May 2022 18:37:12 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E228E70374;
        Thu, 26 May 2022 15:37:10 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id E45DD10E6BB6;
        Fri, 27 May 2022 08:37:07 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nuM6M-00GnCd-05; Fri, 27 May 2022 08:37:06 +1000
Date:   Fri, 27 May 2022 08:37:05 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jack@suse.cz, hch@infradead.org
Subject: Re: [PATCH v6 05/16] iomap: Add async buffered write support
Message-ID: <20220526223705.GJ1098723@dread.disaster.area>
References: <20220526173840.578265-1-shr@fb.com>
 <20220526173840.578265-6-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220526173840.578265-6-shr@fb.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62900114
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=FOH2dFAWAAAA:8 a=7-415B0cAAAA:8
        a=DCuWCNatROCtz0WyV-QA:9 a=CjuIK1q_8ugA:10 a=i3VuKzQdj-NEYjvDI-p3:22
        a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
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

Won't it happen one page sooner? I.e. on single page writes we'll
end up throttling *before* we dirty the page, not *after* we dirty
the page. IOWs, we can't wait for the page that we just dirtied to
be cleaned to make progress and so this now makes the loop dependent
on pages dirtied by other writers being cleaned to guarantee
forwards progress?

That seems like a subtle but quite significant change of
algorithm...

> Signed-off-by: Stefan Roesch <shr@fb.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
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

Hmmm. I see a what looks to be an undesirable pattern here...

1. Memory allocation failure here on the second page of a write.

> @@ -806,8 +828,6 @@ static loff_t iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
>  		pos += status;
>  		written += status;
>  		length -= status;
> -
> -		balance_dirty_pages_ratelimited(iter->inode->i_mapping);
>  	} while (iov_iter_count(i) && length);
>  
>  	return written ? written : status;

2. we break and return 4kB from the first page copied.

> @@ -825,6 +845,9 @@ iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *i,
>  	};
>  	int ret;
>  
> +	if (iocb->ki_flags & IOCB_NOWAIT)
> +		iter.flags |= IOMAP_NOWAIT;
> +
>  	while ((ret = iomap_iter(&iter, ops)) > 0)
>  		iter.processed = iomap_write_iter(&iter, i);

3. This sets iter.processed = 4kB, and we call iomap_iter() again.
This sees iter.processed > 0 and there's still more to write, so
it returns 1, and go around the loop again.

Hence spurious memory allocation failures in the IOMAP_NOWAIT will
not cause this buffered write loop to exit. Worst case, we fail
allocation on every second __iomap_write_begin() call and so the
write takes much longer and consume lots more CPU hammering memory
alocation because no single memory allocation will cause the write
to return a short write to the caller.

This seems undesirable to me. If we are failing memory allocations,
we need to back off, not hammer memory allocation harder without
allowing reclaim to make progress...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
