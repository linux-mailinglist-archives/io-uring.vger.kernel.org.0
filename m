Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 210CD78A184
	for <lists+io-uring@lfdr.de>; Sun, 27 Aug 2023 22:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbjH0UpZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 27 Aug 2023 16:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjH0UpR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 27 Aug 2023 16:45:17 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 892F8BF;
        Sun, 27 Aug 2023 13:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=b31OO6Xd9+jxzKw5QB3n4d33iA6sZ4nPi+nMylKSno4=; b=rh2eHyjfSChvP5M3GZFqng0djt
        iCSjqmEmDczFMnSTrKUt8mmVXGPGgbJ4oq2lIEXyRSbFH+YR4YMUxP/z9QQKohjOoCQZks3WE0IMK
        3S4hJ/QxWWGwrLIXBI8vnsgZg3HMNGIE+hIRemTa2iQvkDDHCCMd0yz1djBYQiyi1qOQAKg4GjHdy
        fEL5cINLesPqAO5iR1xTPAPnXU+iFHAHJEGUTx86DeTnZzv1uxgeaR21j4BV+7nscvIXdd9sVE/Si
        rCIGIbVvaskI417AUCK4HwQeBGpvqIcrg+ypempVGeBQFeEiZBUSg5QboubLY+HaM/1Y954EFPxgD
        hXmevJ/g==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qaMcv-00Dkeb-PH; Sun, 27 Aug 2023 20:44:53 +0000
Date:   Sun, 27 Aug 2023 21:44:53 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Hao Xu <hao.xu@linux.dev>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-cachefs@redhat.com,
        ecryptfs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-unionfs@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-btrfs@vger.kernel.org, codalist@coda.cs.cmu.edu,
        linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
        linux-mm@kvack.org, linux-nilfs@vger.kernel.org,
        devel@lists.orangefs.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-mtd@lists.infradead.org,
        Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH 02/11] xfs: add NOWAIT semantics for readdir
Message-ID: <ZOu1xYS6LRmPgEiV@casper.infradead.org>
References: <20230827132835.1373581-1-hao.xu@linux.dev>
 <20230827132835.1373581-3-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230827132835.1373581-3-hao.xu@linux.dev>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Aug 27, 2023 at 09:28:26PM +0800, Hao Xu wrote:
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -2643,16 +2643,32 @@ xfs_da_read_buf(
>  	struct xfs_buf_map	map, *mapp = &map;
>  	int			nmap = 1;
>  	int			error;
> +	int			buf_flags = 0;
>  
>  	*bpp = NULL;
>  	error = xfs_dabuf_map(dp, bno, flags, whichfork, &mapp, &nmap);
>  	if (error || !nmap)
>  		goto out_free;
>  
> +	/*
> +	 * NOWAIT semantics mean we don't wait on the buffer lock nor do we
> +	 * issue IO for this buffer if it is not already in memory. Caller will
> +	 * retry. This will return -EAGAIN if the buffer is in memory and cannot
> +	 * be locked, and no buffer and no error if it isn't in memory.  We
> +	 * translate both of those into a return state of -EAGAIN and *bpp =
> +	 * NULL.
> +	 */

I would not include this comment.

> +	if (flags & XFS_DABUF_NOWAIT)
> +		buf_flags |= XBF_TRYLOCK | XBF_INCORE;
>  	error = xfs_trans_read_buf_map(mp, tp, mp->m_ddev_targp, mapp, nmap, 0,
>  			&bp, ops);

what tsting did you do with this?  Because you don't actually _use_
buf_flags anywhere in this patch (presumably they should be the
sixth argument to xfs_trans_read_buf_map() instead of 0).  So I can only
conclude that either you didn't test, or your testing was inadequate.

>  	if (error)
>  		goto out_free;
> +	if (!bp) {
> +		ASSERT(flags & XFS_DABUF_NOWAIT);

I don't think this ASSERT is appropriate.

> @@ -391,10 +401,17 @@ xfs_dir2_leaf_getdents(
>  				bp = NULL;
>  			}
>  
> -			if (*lock_mode == 0)
> -				*lock_mode = xfs_ilock_data_map_shared(dp);
> +			if (*lock_mode == 0) {
> +				*lock_mode =
> +					xfs_ilock_data_map_shared_generic(dp,
> +					ctx->flags & DIR_CONTEXT_F_NOWAIT);
> +				if (!*lock_mode) {
> +					error = -EAGAIN;
> +					break;
> +				}
> +			}

'generic' doesn't seem like a great suffix to mean 'takes nowait flag'.
And this is far too far indented.

			xfs_dir2_lock(dp, ctx, lock_mode);

with:

STATIC void xfs_dir2_lock(struct xfs_inode *dp, struct dir_context *ctx,
		unsigned int lock_mode)
{
	if (*lock_mode)
		return;
	if (ctx->flags & DIR_CONTEXT_F_NOWAIT)
		return xfs_ilock_data_map_shared_nowait(dp);
	return xfs_ilock_data_map_shared(dp);
}

... which I think you can use elsewhere in this patch (reformat it to
XFS coding style, of course).  And then you don't need
xfs_ilock_data_map_shared_generic().

