Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 698CB510C4B
	for <lists+io-uring@lfdr.de>; Wed, 27 Apr 2022 00:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235035AbiDZW5s (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 18:57:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237257AbiDZW5r (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 18:57:47 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AE53718E1BA;
        Tue, 26 Apr 2022 15:54:38 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-62-197.pa.nsw.optusnet.com.au [49.195.62.197])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 72EB210E5E0F;
        Wed, 27 Apr 2022 08:54:37 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1njU4q-004vMz-MN; Wed, 27 Apr 2022 08:54:36 +1000
Date:   Wed, 27 Apr 2022 08:54:36 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH v1 06/18] xfs: add iomap async buffered write support
Message-ID: <20220426225436.GQ1544202@dread.disaster.area>
References: <20220426174335.4004987-1-shr@fb.com>
 <20220426174335.4004987-7-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426174335.4004987-7-shr@fb.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=6268782d
        a=KhGSFSjofVlN3/cgq4AT7A==:117 a=KhGSFSjofVlN3/cgq4AT7A==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=FOH2dFAWAAAA:8 a=7-415B0cAAAA:8
        a=R3nUgBtQJk3RGZ7wdW8A:9 a=CjuIK1q_8ugA:10 a=L5iZDtUwO0cA:10
        a=i3VuKzQdj-NEYjvDI-p3:22 a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Apr 26, 2022 at 10:43:23AM -0700, Stefan Roesch wrote:
> This adds the async buffered write support to the iomap layer of XFS. If
> a lock cannot be acquired or additional reads need to be performed, the
> request will return -EAGAIN in case this is an async buffered write request.
> 
> Signed-off-by: Stefan Roesch <shr@fb.com>
> ---
>  fs/xfs/xfs_iomap.c | 33 +++++++++++++++++++++++++++++++--
>  1 file changed, 31 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index e552ce541ec2..80b6c48e88af 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -881,18 +881,28 @@ xfs_buffered_write_iomap_begin(
>  	bool			eof = false, cow_eof = false, shared = false;
>  	int			allocfork = XFS_DATA_FORK;
>  	int			error = 0;
> +	bool			no_wait = (flags & IOMAP_NOWAIT);
>  
>  	if (xfs_is_shutdown(mp))
>  		return -EIO;
>  
>  	/* we can't use delayed allocations when using extent size hints */
> -	if (xfs_get_extsz_hint(ip))
> +	if (xfs_get_extsz_hint(ip)) {
> +		if (no_wait)
> +			return -EAGAIN;
> +
>  		return xfs_direct_write_iomap_begin(inode, offset, count,
>  				flags, iomap, srcmap);

Why can't we do IOMAP_NOWAIT allocation here?
xfs_direct_write_iomap_begin() supports IOMAP_NOWAIT semantics just
fine - that's what the direct IO path uses...

> +	}
>  
>  	ASSERT(!XFS_IS_REALTIME_INODE(ip));
>  
> -	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +	if (no_wait) {
> +		if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL))
> +			return -EAGAIN;
> +	} else {
> +		xfs_ilock(ip, XFS_ILOCK_EXCL);
> +	}

handled by xfs_ilock_for_iomap().
>  
>  	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(&ip->i_df)) ||
>  	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
> @@ -902,6 +912,11 @@ xfs_buffered_write_iomap_begin(
>  
>  	XFS_STATS_INC(mp, xs_blk_mapw);
>  
> +	if (no_wait && xfs_need_iread_extents(XFS_IFORK_PTR(ip, XFS_DATA_FORK))) {
> +		error = -EAGAIN;
> +		goto out_unlock;
> +	}
> +

Also handled by xfs_ilock_for_iomap().

>  	error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
>  	if (error)
>  		goto out_unlock;
> @@ -933,6 +948,10 @@ xfs_buffered_write_iomap_begin(
>  	if (xfs_is_cow_inode(ip)) {
>  		if (!ip->i_cowfp) {
>  			ASSERT(!xfs_is_reflink_inode(ip));
> +			if (no_wait) {
> +				error = -EAGAIN;
> +				goto out_unlock;
> +			}
>  			xfs_ifork_init_cow(ip);
>  		}

Also handled by xfs_ilock_for_iomap().

>  		cow_eof = !xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb,
> @@ -956,6 +975,11 @@ xfs_buffered_write_iomap_begin(
>  			goto found_imap;
>  		}
>  
> +		if (no_wait) {
> +			error = -EAGAIN;
> +			goto out_unlock;
> +		}
> +

Won't get here because this is COW path, and xfs_ilock_for_iomap()
handles returning -EAGAIN for that case.

>  		xfs_trim_extent(&imap, offset_fsb, end_fsb - offset_fsb);
>  
>  		/* Trim the mapping to the nearest shared extent boundary. */
> @@ -993,6 +1017,11 @@ xfs_buffered_write_iomap_begin(
>  			allocfork = XFS_COW_FORK;
>  	}
>  
> +	if (no_wait) {
> +		error = -EAGAIN;
> +		goto out_unlock;
> +	}

Why? Delayed allocation doesn't block...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
