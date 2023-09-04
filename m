Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEE03790F7E
	for <lists+io-uring@lfdr.de>; Mon,  4 Sep 2023 03:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350287AbjIDBC6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Sep 2023 21:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350258AbjIDBC5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Sep 2023 21:02:57 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 225D2CC0
        for <io-uring@vger.kernel.org>; Sun,  3 Sep 2023 18:02:37 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1bf7a6509deso1973805ad.3
        for <io-uring@vger.kernel.org>; Sun, 03 Sep 2023 18:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1693789356; x=1694394156; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7SkjlWpTOnFF4QpgAAxUR7lqv3IHtXsX9Ov+YWVrmXw=;
        b=qC164uBpiTqMDgXCvRgiQKt4Gh699N5mZOL/vYt7en0Jbwz76nMzEY83UKBVSQIW6l
         aeb79T1fQrqEYwAnWqEg0BUEVogsLmyDn7Er7QB5MMmb3evyGFkJ31LnyaFbCd66DWcw
         2rEqHGNd94yLw2873vPlsxfffzMVRPFxi+gQvuhDp/nt+kHeFVOC7RU50NpTqz237x8d
         0EgVDl7W9L5GKWAUtPLGkVf3nghZNwTKtocs80JusMNZMyy2xNrwPVPtVOWAc9Ov7Ec+
         l+Jy4wlPaRYKxlaBf+eoyU6yz7sgMqtArlqAkIUtWnDR1tDFWMVYywwL0pwAGBUewBHm
         OWuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693789356; x=1694394156;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7SkjlWpTOnFF4QpgAAxUR7lqv3IHtXsX9Ov+YWVrmXw=;
        b=bU54/4QIQvNBGFZ5u5QmbY7VUWzt9EyKhfpuGIyy3GgaDi8XKrQtLR/OU8/BRTSGJr
         cccVsNIQl0WU8MTHmjYQ/G0wM7YM1tjdHLnMppZrV9Squzjei36uVfDee5WjXN1D9/Y8
         +NH8HC4zpbWnpkknBjcn04jgx2ozANlp3pPa9evYLRLwDEMDELcOmv6HQdy2ADtRkH4z
         7s5nlxC9Hw4P3gIxWqbo1Vdd0TK+BW8KDnp2PLRSynXfza65PuX/DkkLJ/gyeA2c0Gqi
         0ikh6kI3xSnjWa0FN9Vt7QxeK74cBupsRcT/tZaqG9jblrSr0GEHoXFrRsZhuv/o8tOb
         Kv2Q==
X-Gm-Message-State: AOJu0YwlAZMEwewFu6rK2Qe1BcwOaTSXebymSgUtyxj1bg+Xg3yH2kV8
        +WscIWN/35VQN/mNUfU0bM8Czg==
X-Google-Smtp-Source: AGHT+IGGrky2P+bBuH4AKgWBeYdqXOP6u+qaOJyeKMBTbWb7BRdsdnk0jjxmGVwySX0sZe8eaRNDcw==
X-Received: by 2002:a17:902:ecc8:b0:1c1:fe97:bf34 with SMTP id a8-20020a170902ecc800b001c1fe97bf34mr8040994plh.24.1693789355853;
        Sun, 03 Sep 2023 18:02:35 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id d4-20020a170902c18400b001bdcafcf8d3sm6351806pld.69.2023.09.03.18.02.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Sep 2023 18:02:35 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qcxz6-00AVA9-2L;
        Mon, 04 Sep 2023 11:02:32 +1000
Date:   Mon, 4 Sep 2023 11:02:32 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Hao Xu <hao.xu@linux.dev>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
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
Message-ID: <ZPUsqGfeUwupdlLE@dread.disaster.area>
References: <20230827132835.1373581-1-hao.xu@linux.dev>
 <20230827132835.1373581-3-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230827132835.1373581-3-hao.xu@linux.dev>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Aug 27, 2023 at 09:28:26PM +0800, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> Implement NOWAIT semantics for readdir. Return EAGAIN error to the
> caller if it would block, like failing to get locks, or going to
> do IO.
> 
> Co-developed-by: Dave Chinner <dchinner@redhat.com>

Not really.

"Co-developed" implies equal development input between all the
parties, which is not the case here - this patch is based on
prototype I wrote, whilst you're doing the refining, testing and
correctness work.

In these cases with XFS code, we add a line in the commit message to
say:

"This is based on a patch originally written by Dave Chinner."


> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Hao Xu <howeyxu@tencent.com>
> [fixes deadlock issue, tweak code style]

With a signoff chain like you already have.

In the end you'll also get a RVB from me, which seems rather wrong
to me if I've apparently been "co-developing" the code....

....

> @@ -156,7 +157,9 @@ xfs_dir2_block_getdents(
>  	if (xfs_dir2_dataptr_to_db(geo, ctx->pos) > geo->datablk)
>  		return 0;
>  
> -	error = xfs_dir3_block_read(args->trans, dp, &bp);
> +	if (ctx->flags & DIR_CONTEXT_F_NOWAIT)
> +		flags |= XFS_DABUF_NOWAIT;
> +	error = xfs_dir3_block_read(args->trans, dp, flags, &bp);
>  	if (error)
>  		return error;
>  

Given we do this same check in both block and leaf formats to set
XFS_DABUF_NOWAIT, and we do the DIR_CONTEXT_F_NOWAIT check in
xfs_readdir() as well, we should probably do this check once at the
higher level and pass flags down from there with XFS_DABUF_NOWAIT
already set.

> @@ -240,6 +243,7 @@ xfs_dir2_block_getdents(
>  STATIC int
>  xfs_dir2_leaf_readbuf(
>  	struct xfs_da_args	*args,
> +	struct dir_context	*ctx,
>  	size_t			bufsize,
>  	xfs_dir2_off_t		*cur_off,
>  	xfs_dablk_t		*ra_blk,
> @@ -258,10 +262,15 @@ xfs_dir2_leaf_readbuf(
>  	struct xfs_iext_cursor	icur;
>  	int			ra_want;
>  	int			error = 0;
> -
> -	error = xfs_iread_extents(args->trans, dp, XFS_DATA_FORK);
> -	if (error)
> -		goto out;
> +	unsigned int		flags = 0;
> +
> +	if (ctx->flags & DIR_CONTEXT_F_NOWAIT) {
> +		flags |= XFS_DABUF_NOWAIT;
> +	} else {
> +		error = xfs_iread_extents(args->trans, dp, XFS_DATA_FORK);
> +		if (error)
> +			goto out;
> +	}

Especially as, in hindsight, this doesn't make a whole lot of sense.
If XFS_DABUF_NOWAIT is set, we keep going until
xfs_ilock_data_map_shared_nowait() where we call
xfs_need_iread_extents() to see if we need to read the extents in
and abort at that point.

So, really, we shouldn't get this far with nowait semantics if
we haven't read the extents in yet - we're supposed to already have
the inode locked here and so we should have already checked this
condition before we bother locking the inode...

i.e. all we should be doing here is this:

	if (!(flags & XFS_DABUF_NOWAIT)) {
		error = xfs_iread_extents(args->trans, dp, XFS_DATA_FORK);
		if (error)
			goto out;
	}

And then we don't need to pass the VFS dir_context down into low
level XFS functions unnecessarily.


>  
>  	/*
>  	 * Look for mapped directory blocks at or above the current offset.
> @@ -280,7 +289,7 @@ xfs_dir2_leaf_readbuf(
>  	new_off = xfs_dir2_da_to_byte(geo, map.br_startoff);
>  	if (new_off > *cur_off)
>  		*cur_off = new_off;
> -	error = xfs_dir3_data_read(args->trans, dp, map.br_startoff, 0, &bp);
> +	error = xfs_dir3_data_read(args->trans, dp, map.br_startoff, flags, &bp);
>  	if (error)
>  		goto out;
>  
> @@ -360,6 +369,7 @@ xfs_dir2_leaf_getdents(
>  	int			byteoff;	/* offset in current block */
>  	unsigned int		offset = 0;
>  	int			error = 0;	/* error return value */
> +	int			written = 0;
>  
>  	/*
>  	 * If the offset is at or past the largest allowed value,
> @@ -391,10 +401,17 @@ xfs_dir2_leaf_getdents(
>  				bp = NULL;
>  			}
>  
> -			if (*lock_mode == 0)
> -				*lock_mode = xfs_ilock_data_map_shared(dp);
> -			error = xfs_dir2_leaf_readbuf(args, bufsize, &curoff,
> -					&rablk, &bp);
> +			if (*lock_mode == 0) {
> +				*lock_mode =
> +					xfs_ilock_data_map_shared_generic(dp,
> +					ctx->flags & DIR_CONTEXT_F_NOWAIT);
> +				if (!*lock_mode) {
> +					error = -EAGAIN;
> +					break;
> +				}
> +			}
> +			error = xfs_dir2_leaf_readbuf(args, ctx, bufsize,
> +					&curoff, &rablk, &bp);

int
xfs_ilock_readdir(
	struct xfs_inode	*ip,
	int			flags)
{
	if (flags & XFS_DABUF_NOWAIT) {
		if (!xfs_ilock_nowait(dp, XFS_ILOCK_SHARED))
			return -EAGAIN;
		return XFS_ILOCK_SHARED;
	}
	return xfs_ilock_data_map_shared(dp);
}

And then this code simply becomes:

			if (*lock_mode == 0)
				*lock_mode = xfs_ilock_readdir(ip, flags);


>  			if (error || !bp)
>  				break;
>  
> @@ -479,6 +496,7 @@ xfs_dir2_leaf_getdents(
>  		 */
>  		offset += length;
>  		curoff += length;
> +		written += length;
>  		/* bufsize may have just been a guess; don't go negative */
>  		bufsize = bufsize > length ? bufsize - length : 0;
>  	}
> @@ -492,6 +510,8 @@ xfs_dir2_leaf_getdents(
>  		ctx->pos = xfs_dir2_byte_to_dataptr(curoff) & 0x7fffffff;
>  	if (bp)
>  		xfs_trans_brelse(args->trans, bp);
> +	if (error == -EAGAIN && written > 0)
> +		error = 0;
>  	return error;
>  }
>  
> @@ -514,6 +534,7 @@ xfs_readdir(
>  	unsigned int		lock_mode;
>  	bool			isblock;
>  	int			error;
> +	bool			nowait;
>  
>  	trace_xfs_readdir(dp);
>  
> @@ -531,7 +552,11 @@ xfs_readdir(
>  	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL)
>  		return xfs_dir2_sf_getdents(&args, ctx);
>  
> -	lock_mode = xfs_ilock_data_map_shared(dp);
> +	nowait = ctx->flags & DIR_CONTEXT_F_NOWAIT;
> +	lock_mode = xfs_ilock_data_map_shared_generic(dp, nowait);
> +	if (!lock_mode)
> +		return -EAGAIN;
> +

Given what I said above:

	if (ctx->flags & DIR_CONTEXT_F_NOWAIT) {
		/*
		 * If we need to read extents, then we must do IO
		 * and we must use exclusive locking. We don't want
		 * to do either of those things, so just bail if we
		 * have to read extents. Doing this check explicitly
		 * here means we don't have to do it anywhere else
		 * in the XFS_DABUF_NOWAIT path.
		 */
		if (xfs_need_iread_extents(&ip->i_df))
			return -EAGAIN;
		flags |= XFS_DABUF_NOWAIT;
	}
	lock_mode = xfs_ilock_readdir(dp, flags);

And with this change, we probably should be marking the entire
operation as having nowait semantics. i.e. using args->op_flags here
and only use XFS_DABUF_NOWAIT for the actual IO. ie.

		args->op_flags |= XFS_DA_OP_NOWAIT;

This makes it clear that the entire directory op should run under
NOWAIT constraints, and it avoids needing to pass an extra flag
through the stack.  That then makes the readdir locking function
look like this:

/*
 * When we are locking an inode for readdir, we need to ensure that
 * the extents have been read in first. This requires the inode to
 * be locked exclusively across the extent read, but otherwise we
 * want to use shared locking.
 *
 * For XFS_DA_OP_NOWAIT operations, we do an up-front check to see
 * if the extents have been read in, so all we need to do in this
 * case is a shared try-lock as we never need exclusive locking in
 * this path.
 */
static int
xfs_ilock_readdir(
	struct xfs_da_args	*args)
{
	if (args->op_flags & XFS_DA_OP_NOWAIT) {
		if (!xfs_ilock_nowait(args->dp, XFS_ILOCK_SHARED))
			return -EAGAIN;
		return XFS_ILOCK_SHARED;
	}
	return xfs_ilock_data_map_shared(args->dp);
}

> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 9e62cc500140..d088f7d0c23a 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -120,6 +120,33 @@ xfs_ilock_data_map_shared(
>  	return lock_mode;
>  }
>  
> +/*
> + * Similar to xfs_ilock_data_map_shared(), except that it will only try to lock
> + * the inode in shared mode if the extents are already in memory. If it fails to
> + * get the lock or has to do IO to read the extent list, fail the operation by
> + * returning 0 as the lock mode.
> + */
> +uint
> +xfs_ilock_data_map_shared_nowait(
> +	struct xfs_inode	*ip)
> +{
> +	if (xfs_need_iread_extents(&ip->i_df))
> +		return 0;
> +	if (!xfs_ilock_nowait(ip, XFS_ILOCK_SHARED))
> +		return 0;
> +	return XFS_ILOCK_SHARED;
> +}
> +
> +int
> +xfs_ilock_data_map_shared_generic(
> +	struct xfs_inode	*dp,
> +	bool			nowait)
> +{
> +	if (nowait)
> +		return xfs_ilock_data_map_shared_nowait(dp);
> +	return xfs_ilock_data_map_shared(dp);
> +}

And all this "generic" locking stuff goes away.

FWIW, IMO, "generic" is a poor name for an XFS function as there's
nothing "generic" in XFS.  We tend name the functions after what
they do, not some abstract concept. Leave "generic" as a keyword for
widely used core infrastructure functions, not niche, one-off use
cases like this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
