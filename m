Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED9E56F2F0D
	for <lists+io-uring@lfdr.de>; Mon,  1 May 2023 09:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbjEAHQM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 May 2023 03:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232131AbjEAHQL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 May 2023 03:16:11 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A461EE79
        for <io-uring@vger.kernel.org>; Mon,  1 May 2023 00:16:08 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-63b5c4c76aaso1507595b3a.2
        for <io-uring@vger.kernel.org>; Mon, 01 May 2023 00:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1682925368; x=1685517368;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7Bo+TuW79a2MAd9lHX9ZeRTSgsQeGMfP8roInaACgXs=;
        b=dIRI2GxpukSjnWR8uN8DOYVda99Re6+g/Q4/oZWO3H7PqRQ8PQIS845K6Y/C4IgXN6
         h07qBUFBTkagwE04CZYTObdwSjgDPP8JfZd+Cf8Cf/K5CikburiZUPM06DRDTrbUmhNf
         JIgtLAT4QFGsAmvHXV39ZDJqOEzAxoiNRLQkn2Lj1dVc4r8XE0D2/VR2VFr4DxsdDaQ5
         j6KTT1yejGktLDk46gpPVb6jzSztNGcUDD5wQRc/lsEi/Tx55n60ad1GwzSkad4H/ZPF
         EYPkVi9WnvLqghf29HIJDZURJnskIiPj1fAWB54oREXE+1GU8VyRgkKXCbith8TZqveL
         ubLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682925368; x=1685517368;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7Bo+TuW79a2MAd9lHX9ZeRTSgsQeGMfP8roInaACgXs=;
        b=XUt7Acj3On8WcbR7SEsnpz50AERe7bzoD7ofqkkCp2ytdGcxOpo5j9hc8WW74VsARu
         M9AB45WB2vre9bbXA94ALeJDVtzUhkIz7JCgOH17In/xmbJUuFoOayXoJhMYUJ/UUTYb
         7oIR519KJdI/1MCL25t/or/Ap7Mvhn0dVraa9lNc0rY+NCrFBQWjiK1f6x6dbXFZi+dN
         h5+/7u8L6XhZyg0Z0k16YXTmqYX5c2pXT6iNkzN6L3cigDr7ka0WQxCRNqhMeJTPQgvZ
         k9MJKVVUSchhxAXlRlxSZV4gmMalbOh9OSvlu7wh54ZWhWt6Mw8BPXBct8Mc7vxN2RAp
         kpMg==
X-Gm-Message-State: AC+VfDzWqygWwSGYw1BW0rV6P7Iaw8N5nA13yAMYOk6+esNqIBMgy8xe
        QF/Qmm1HWJumUTh0UkplJqE5hw==
X-Google-Smtp-Source: ACHHUZ6NPS85lZJzOCW/a5W/4mgMCQCFokTuSdLnIvCeTStnVjFXAGOlFE5zyfG5A5rRI56F4Lz2aA==
X-Received: by 2002:a05:6a20:8e08:b0:f8:1101:c06d with SMTP id y8-20020a056a208e0800b000f81101c06dmr17397460pzj.48.1682925368031;
        Mon, 01 May 2023 00:16:08 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-88-204.pa.nsw.optusnet.com.au. [49.181.88.204])
        by smtp.gmail.com with ESMTPSA id ls17-20020a17090b351100b0023a9564763bsm18603000pjb.29.2023.05.01.00.16.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 May 2023 00:16:07 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ptNlT-009yHM-Nk; Mon, 01 May 2023 17:16:03 +1000
Date:   Mon, 1 May 2023 17:16:03 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Roesch <shr@fb.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH RFC 2/2] io_uring: add support for getdents
Message-ID: <20230501071603.GE2155823@dread.disaster.area>
References: <20230422-uring-getdents-v1-0-14c1db36e98c@codewreck.org>
 <20230422-uring-getdents-v1-2-14c1db36e98c@codewreck.org>
 <20230423224045.GS447837@dread.disaster.area>
 <ZEXChAJfCRPv9vbs@codewreck.org>
 <20230428050640.GA1969623@dread.disaster.area>
 <ZEtkXJ1vMsFR3tkN@codewreck.org>
 <ZEzQRLUnlix1GvbA@codewreck.org>
 <20230430233241.GC2155823@dread.disaster.area>
 <ZE8Mm-9PikpFSjLp@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZE8Mm-9PikpFSjLp@codewreck.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, May 01, 2023 at 09:49:31AM +0900, Dominique Martinet wrote:
> Dave Chinner wrote on Mon, May 01, 2023 at 09:32:41AM +1000:
> > > I've had a second look and I still don't see anything obvious though;
> > > I'd rather avoid adding a new variant of iterate()/iterate_shared() --
> > > we could use that as a chance to add a flag to struct file_operation
> > > instead? e.g., something like mmap_supported_flags:
> > 
> > I don't think that makes sense - the eventual goal is to make
> > ->iterate() go away entirely and all filesystems use
> > ->iterate_shared(). Hence I think adding flags to select iterate vs
> > iterate_shared and the locking that is needed is the wrong place to
> > start from here.
> 
> (The flag could just go away when all filesystems not supporting it are
> gone, and it could be made the other way around (e.g. explicit
> NOT_SHARED to encourage migrations), so I don't really see the problem
> with this but next point makes this moot anyway)
> 
> > Whether the filesystem supports non-blocking ->iterate_shared() or
> > not is a filesystem implementation option and io_uring needs that
> > information to be held on the struct file for efficient
> > determination of whether it should use non-blocking operations or
> > not.
> 
> Right, sorry. I was thinking that since it's fs/op dependant it made
> more sense to keep next to the iterate operation, but that'd be a
> layering violation to look directly at the file_operation vector
> directly from the uring code... So having it in the struct file is
> better from that point of view.
> 
> > We already set per-filesystem file modes via the ->open method,
> > that's how we already tell io_uring that it can do NOWAIT IO, as
> > well as async read/write IO for regular files. And now we also use
> > it for FMODE_DIO_PARALLEL_WRITE, too.
> > 
> > See __io_file_supports_nowait()....
> > 
> > Essentially, io_uring already cwhas the mechanism available to it
> > to determine if it should use NOWAIT semantics for getdents
> > operations; we just need to set FMODE_NOWAIT correctly for directory
> > files via ->open() on the filesystems that support it...
> 
> Great, I wasn't aware of FMODE_NOWAIT; things are starting to fall in
> place.
> I'll send a v2 around Wed or Thurs (yay national holidays)
> 
> > [ Hmmmm - we probably need to be more careful in XFS about what
> > types of files we set those flags on.... ]
> 
> Yes, FMODE_NOWAIT will be set on directories as xfs_dir_open calls
> xfs_file_open which sets it inconditionally... So I got to check other
> filesystems don't do something similar as a bonus, but it looks like
> none that set FMODE_NOWAIT on regular files share the file open path,
> so at least that shouldn't be too bad.
> Happy to also fold the xfs fix as a prerequisite patch of this series or
> to let you do it, just tell me.

Yeah, we need to audit all the ->open() calls to ensure they do the
right thing - I think what XFS does is a harmless oversight at this
point, we can simple split xfs_file_open() and xfs_dir_open() as
appropriate.

Also, the nowait enabled ->iterate_shared() method for XFS will look
something like the patch below. It's not tested in any way, I just
wrote it quickly to demonstrate the relative simplicity of
converting all the locking and IO interfaces in the xfs_readdir()
for NOWAIT operation. Making it asynchronous (equivalent of
FMODE_BUF_RASYNC) is a lot more work, but I'm not sure that is
necessary given the async readahead that gets issued...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: NOWAIT semantics for readdir

From: Dave Chinner <dchinner@redhat.com>

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_da_btree.c   | 16 +++++++++++++
 fs/xfs/libxfs/xfs_da_btree.h   |  1 +
 fs/xfs/libxfs/xfs_dir2_block.c |  7 +++---
 fs/xfs/libxfs/xfs_dir2_priv.h  |  2 +-
 fs/xfs/scrub/dir.c             |  2 +-
 fs/xfs/scrub/readdir.c         |  2 +-
 fs/xfs/xfs_dir2_readdir.c      | 54 ++++++++++++++++++++++++++++++++++--------
 fs/xfs/xfs_inode.c             | 17 +++++++++++++
 fs/xfs/xfs_inode.h             | 15 ++++++------
 include/linux/fs.h             |  1 +
 10 files changed, 94 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index e576560b46e9..7a1a0af24197 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -2643,16 +2643,32 @@ xfs_da_read_buf(
 	struct xfs_buf_map	map, *mapp = &map;
 	int			nmap = 1;
 	int			error;
+	int			buf_flags = 0;
 
 	*bpp = NULL;
 	error = xfs_dabuf_map(dp, bno, flags, whichfork, &mapp, &nmap);
 	if (error || !nmap)
 		goto out_free;
 
+	/*
+	 * NOWAIT semantics mean we don't wait on the buffer lock nor do we
+	 * issue IO for this buffer if it is not already in memory. Caller will
+	 * retry. This will return -EAGAIN if the buffer is in memory and cannot
+	 * be locked, and no buffer and no error if it isn't in memory.  We
+	 * translate both of those into a return state of -EAGAIN and *bpp =
+	 * NULL.
+	 */
+	if (flags & XFS_DABUF_NOWAIT)
+		buf_flags |= XBF_TRYLOCK | XBF_INCORE;
 	error = xfs_trans_read_buf_map(mp, tp, mp->m_ddev_targp, mapp, nmap, 0,
 			&bp, ops);
 	if (error)
 		goto out_free;
+	if (!bp) {
+		ASSERT(flags & XFS_DABUF_NOWAIT);
+		error = -EAGAIN;
+		goto out_free;
+	}
 
 	if (whichfork == XFS_ATTR_FORK)
 		xfs_buf_set_ref(bp, XFS_ATTR_BTREE_REF);
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index ffa3df5b2893..32e7b1cca402 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -205,6 +205,7 @@ int	xfs_da3_node_read_mapped(struct xfs_trans *tp, struct xfs_inode *dp,
  */
 
 #define XFS_DABUF_MAP_HOLE_OK	(1u << 0)
+#define XFS_DABUF_NOWAIT	(1u << 1)
 
 int	xfs_da_grow_inode(xfs_da_args_t *args, xfs_dablk_t *new_blkno);
 int	xfs_da_grow_inode_int(struct xfs_da_args *args, xfs_fileoff_t *bno,
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 00f960a703b2..59b24a594add 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -135,13 +135,14 @@ int
 xfs_dir3_block_read(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
+	unsigned int		flags,
 	struct xfs_buf		**bpp)
 {
 	struct xfs_mount	*mp = dp->i_mount;
 	xfs_failaddr_t		fa;
 	int			err;
 
-	err = xfs_da_read_buf(tp, dp, mp->m_dir_geo->datablk, 0, bpp,
+	err = xfs_da_read_buf(tp, dp, mp->m_dir_geo->datablk, flags, bpp,
 				XFS_DATA_FORK, &xfs_dir3_block_buf_ops);
 	if (err || !*bpp)
 		return err;
@@ -380,7 +381,7 @@ xfs_dir2_block_addname(
 	tp = args->trans;
 
 	/* Read the (one and only) directory block into bp. */
-	error = xfs_dir3_block_read(tp, dp, &bp);
+	error = xfs_dir3_block_read(tp, dp, 0, &bp);
 	if (error)
 		return error;
 
@@ -695,7 +696,7 @@ xfs_dir2_block_lookup_int(
 	dp = args->dp;
 	tp = args->trans;
 
-	error = xfs_dir3_block_read(tp, dp, &bp);
+	error = xfs_dir3_block_read(tp, dp, 0, &bp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index 7404a9ff1a92..7d4cf8a0f15b 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -51,7 +51,7 @@ extern int xfs_dir_cilookup_result(struct xfs_da_args *args,
 
 /* xfs_dir2_block.c */
 extern int xfs_dir3_block_read(struct xfs_trans *tp, struct xfs_inode *dp,
-			       struct xfs_buf **bpp);
+			       unsigned int flags, struct xfs_buf **bpp);
 extern int xfs_dir2_block_addname(struct xfs_da_args *args);
 extern int xfs_dir2_block_lookup(struct xfs_da_args *args);
 extern int xfs_dir2_block_removename(struct xfs_da_args *args);
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 0b491784b759..5cc51f201bd7 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -313,7 +313,7 @@ xchk_directory_data_bestfree(
 		/* dir block format */
 		if (lblk != XFS_B_TO_FSBT(mp, XFS_DIR2_DATA_OFFSET))
 			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
-		error = xfs_dir3_block_read(sc->tp, sc->ip, &bp);
+		error = xfs_dir3_block_read(sc->tp, sc->ip, 0, &bp);
 	} else {
 		/* dir data format */
 		error = xfs_dir3_data_read(sc->tp, sc->ip, lblk, 0, &bp);
diff --git a/fs/xfs/scrub/readdir.c b/fs/xfs/scrub/readdir.c
index e51c1544be63..f0a727311632 100644
--- a/fs/xfs/scrub/readdir.c
+++ b/fs/xfs/scrub/readdir.c
@@ -101,7 +101,7 @@ xchk_dir_walk_block(
 	unsigned int		off, next_off, end;
 	int			error;
 
-	error = xfs_dir3_block_read(sc->tp, dp, &bp);
+	error = xfs_dir3_block_read(sc->tp, dp, 0, &bp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 9f3ceb461515..e5fcd3786599 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -149,6 +149,7 @@ xfs_dir2_block_getdents(
 	struct xfs_da_geometry	*geo = args->geo;
 	unsigned int		offset, next_offset;
 	unsigned int		end;
+	unsigned int		flags = 0;
 
 	/*
 	 * If the block number in the offset is out of range, we're done.
@@ -156,7 +157,9 @@ xfs_dir2_block_getdents(
 	if (xfs_dir2_dataptr_to_db(geo, ctx->pos) > geo->datablk)
 		return 0;
 
-	error = xfs_dir3_block_read(args->trans, dp, &bp);
+	if (ctx->nowait)
+		flags |= XFS_DABUF_NOWAIT;
+	error = xfs_dir3_block_read(args->trans, dp, flags, &bp);
 	if (error)
 		return error;
 
@@ -240,6 +243,7 @@ xfs_dir2_block_getdents(
 STATIC int
 xfs_dir2_leaf_readbuf(
 	struct xfs_da_args	*args,
+	struct dir_context	*ctx,
 	size_t			bufsize,
 	xfs_dir2_off_t		*cur_off,
 	xfs_dablk_t		*ra_blk,
@@ -258,10 +262,15 @@ xfs_dir2_leaf_readbuf(
 	struct xfs_iext_cursor	icur;
 	int			ra_want;
 	int			error = 0;
+	unsigned int		flags = 0;
 
-	error = xfs_iread_extents(args->trans, dp, XFS_DATA_FORK);
-	if (error)
-		goto out;
+	if (ctx->nowait) {
+		flags |= XFS_DABUF_NOWAIT;
+	} else {
+		error = xfs_iread_extents(args->trans, dp, XFS_DATA_FORK);
+		if (error)
+			goto out;
+	}
 
 	/*
 	 * Look for mapped directory blocks at or above the current offset.
@@ -280,7 +289,7 @@ xfs_dir2_leaf_readbuf(
 	new_off = xfs_dir2_da_to_byte(geo, map.br_startoff);
 	if (new_off > *cur_off)
 		*cur_off = new_off;
-	error = xfs_dir3_data_read(args->trans, dp, map.br_startoff, 0, &bp);
+	error = xfs_dir3_data_read(args->trans, dp, map.br_startoff, flags, &bp);
 	if (error)
 		goto out;
 
@@ -337,6 +346,16 @@ xfs_dir2_leaf_readbuf(
 	goto out;
 }
 
+static inline int
+xfs_ilock_for_readdir(
+	struct xfs_inode	*dp,
+	bool			nowait)
+{
+	if (nowait)
+		return xfs_ilock_data_map_shared_nowait(dp);
+	return xfs_ilock_data_map_shared(dp);
+}
+
 /*
  * Getdents (readdir) for leaf and node directories.
  * This reads the data blocks only, so is the same for both forms.
@@ -360,6 +379,7 @@ xfs_dir2_leaf_getdents(
 	int			byteoff;	/* offset in current block */
 	unsigned int		offset = 0;
 	int			error = 0;	/* error return value */
+	int			written = 0;
 
 	/*
 	 * If the offset is at or past the largest allowed value,
@@ -391,10 +411,16 @@ xfs_dir2_leaf_getdents(
 				bp = NULL;
 			}
 
-			if (*lock_mode == 0)
-				*lock_mode = xfs_ilock_data_map_shared(dp);
-			error = xfs_dir2_leaf_readbuf(args, bufsize, &curoff,
-					&rablk, &bp);
+			if (*lock_mode == 0) {
+				*lock_mode = xfs_ilock_for_readdir(dp,
+						ctx->nowait);
+				if (!*lock_mode) {
+					error = -EAGAIN;
+					break;
+				}
+			}
+			error = xfs_dir2_leaf_readbuf(args, ctx, bufsize,
+					&curoff, &rablk, &bp);
 			if (error || !bp)
 				break;
 
@@ -479,6 +505,7 @@ xfs_dir2_leaf_getdents(
 		 */
 		offset += length;
 		curoff += length;
+		written += length;
 		/* bufsize may have just been a guess; don't go negative */
 		bufsize = bufsize > length ? bufsize - length : 0;
 	}
@@ -492,6 +519,8 @@ xfs_dir2_leaf_getdents(
 		ctx->pos = xfs_dir2_byte_to_dataptr(curoff) & 0x7fffffff;
 	if (bp)
 		xfs_trans_brelse(args->trans, bp);
+	if (error == -EAGAIN && written > 0)
+		error = 0;
 	return error;
 }
 
@@ -528,10 +557,13 @@ xfs_readdir(
 	args.geo = dp->i_mount->m_dir_geo;
 	args.trans = tp;
 
+	lock_mode = xfs_ilock_for_readdir(dp, ctx->nowait);
+	if (!lock_mode)
+		return -EAGAIN;
+
 	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL)
 		return xfs_dir2_sf_getdents(&args, ctx);
 
-	lock_mode = xfs_ilock_data_map_shared(dp);
 	error = xfs_dir2_isblock(&args, &isblock);
 	if (error)
 		goto out_unlock;
@@ -546,5 +578,7 @@ xfs_readdir(
 out_unlock:
 	if (lock_mode)
 		xfs_iunlock(dp, lock_mode);
+	if (error == -EAGAIN)
+		ASSERT(ctx->nowait);
 	return error;
 }
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 5808abab786c..c0d5f3f06270 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -120,6 +120,23 @@ xfs_ilock_data_map_shared(
 	return lock_mode;
 }
 
+/*
+ * Similar to xfs_ilock_data_map_shared(), except that it will only try to lock
+ * the inode in shared mode if the extents are already in memory. If it fails to
+ * get the lock or has to do IO to read the extent list, fail the operation by
+ * returning 0 as the lock mode.
+ */
+uint
+xfs_ilock_data_map_shared_nowait(
+	struct xfs_inode	*ip)
+{
+	if (xfs_need_iread_extents(&ip->i_df))
+		return 0;
+	if (!xfs_ilock_nowait(ip, XFS_ILOCK_SHARED))
+		return 0;
+	return XFS_ILOCK_SHARED;
+}
+
 uint
 xfs_ilock_attr_map_shared(
 	struct xfs_inode	*ip)
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 69d21e42c10a..f766e1a41d90 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -490,13 +490,14 @@ int		xfs_rename(struct mnt_idmap *idmap,
 			   struct xfs_name *target_name,
 			   struct xfs_inode *target_ip, unsigned int flags);
 
-void		xfs_ilock(xfs_inode_t *, uint);
-int		xfs_ilock_nowait(xfs_inode_t *, uint);
-void		xfs_iunlock(xfs_inode_t *, uint);
-void		xfs_ilock_demote(xfs_inode_t *, uint);
-bool		xfs_isilocked(struct xfs_inode *, uint);
-uint		xfs_ilock_data_map_shared(struct xfs_inode *);
-uint		xfs_ilock_attr_map_shared(struct xfs_inode *);
+void		xfs_ilock(struct xfs_inode *ip, uint lockmode);
+int		xfs_ilock_nowait(struct xfs_inode *ip, uint lockmode);
+void		xfs_iunlock(struct xfs_inode *ip, uint lockmode);
+void		xfs_ilock_demote(struct xfs_inode *ip, uint lockmode);
+bool		xfs_isilocked(struct xfs_inode *ip, uint lockmode);
+uint		xfs_ilock_data_map_shared(struct xfs_inode *ip);
+uint		xfs_ilock_data_map_shared_nowait(struct xfs_inode *ip);
+uint		xfs_ilock_attr_map_shared(struct xfs_inode *ip);
 
 uint		xfs_ip2xflags(struct xfs_inode *);
 int		xfs_ifree(struct xfs_trans *, struct xfs_inode *);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 67495ef79bb2..26c91812ca48 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1702,6 +1702,7 @@ typedef bool (*filldir_t)(struct dir_context *, const char *, int, loff_t, u64,
 struct dir_context {
 	filldir_t actor;
 	loff_t pos;
+	bool nowait;
 };
 
 /*
