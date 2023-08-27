Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34705789EE7
	for <lists+io-uring@lfdr.de>; Sun, 27 Aug 2023 15:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbjH0Nbb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 27 Aug 2023 09:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbjH0NbD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 27 Aug 2023 09:31:03 -0400
Received: from out-247.mta1.migadu.com (out-247.mta1.migadu.com [IPv6:2001:41d0:203:375::f7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0758BF
        for <io-uring@vger.kernel.org>; Sun, 27 Aug 2023 06:30:56 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1693143055;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hTZJGzowdwZotMVwWddSwVfC1FzrP/Lkz2Y0ayQQQXA=;
        b=L3dZ2wnhLl3MpFT8Fx3GtXFd2RCwphC3uDYko8Q0nKz7ONNiGRoAamaCC5cUw2SONEU+W+
        FNti/TRpT0IYzrVdjkthri+O6/3aV24bEu1xrJpC4BygFoLKHcj9ftj4kgaNqPcbLz1Ibc
        FihN2zv2jXx86v+rCxyuW2cfhV75bQE=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Dominique Martinet <asmadeus@codewreck.org>,
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
Subject: [PATCH 02/11] xfs: add NOWAIT semantics for readdir
Date:   Sun, 27 Aug 2023 21:28:26 +0800
Message-Id: <20230827132835.1373581-3-hao.xu@linux.dev>
In-Reply-To: <20230827132835.1373581-1-hao.xu@linux.dev>
References: <20230827132835.1373581-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

Implement NOWAIT semantics for readdir. Return EAGAIN error to the
caller if it would block, like failing to get locks, or going to
do IO.

Co-developed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Hao Xu <howeyxu@tencent.com>
[fixes deadlock issue, tweak code style]
---
 fs/xfs/libxfs/xfs_da_btree.c   | 16 +++++++++++
 fs/xfs/libxfs/xfs_da_btree.h   |  1 +
 fs/xfs/libxfs/xfs_dir2_block.c |  7 ++---
 fs/xfs/libxfs/xfs_dir2_priv.h  |  2 +-
 fs/xfs/scrub/dir.c             |  2 +-
 fs/xfs/scrub/readdir.c         |  2 +-
 fs/xfs/xfs_dir2_readdir.c      | 49 ++++++++++++++++++++++++++--------
 fs/xfs/xfs_inode.c             | 27 +++++++++++++++++++
 fs/xfs/xfs_inode.h             | 17 +++++++-----
 9 files changed, 99 insertions(+), 24 deletions(-)

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
index 9f3ceb461515..dcdbd26e0402 100644
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
+	if (ctx->flags & DIR_CONTEXT_F_NOWAIT)
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
-
-	error = xfs_iread_extents(args->trans, dp, XFS_DATA_FORK);
-	if (error)
-		goto out;
+	unsigned int		flags = 0;
+
+	if (ctx->flags & DIR_CONTEXT_F_NOWAIT) {
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
 
@@ -360,6 +369,7 @@ xfs_dir2_leaf_getdents(
 	int			byteoff;	/* offset in current block */
 	unsigned int		offset = 0;
 	int			error = 0;	/* error return value */
+	int			written = 0;
 
 	/*
 	 * If the offset is at or past the largest allowed value,
@@ -391,10 +401,17 @@ xfs_dir2_leaf_getdents(
 				bp = NULL;
 			}
 
-			if (*lock_mode == 0)
-				*lock_mode = xfs_ilock_data_map_shared(dp);
-			error = xfs_dir2_leaf_readbuf(args, bufsize, &curoff,
-					&rablk, &bp);
+			if (*lock_mode == 0) {
+				*lock_mode =
+					xfs_ilock_data_map_shared_generic(dp,
+					ctx->flags & DIR_CONTEXT_F_NOWAIT);
+				if (!*lock_mode) {
+					error = -EAGAIN;
+					break;
+				}
+			}
+			error = xfs_dir2_leaf_readbuf(args, ctx, bufsize,
+					&curoff, &rablk, &bp);
 			if (error || !bp)
 				break;
 
@@ -479,6 +496,7 @@ xfs_dir2_leaf_getdents(
 		 */
 		offset += length;
 		curoff += length;
+		written += length;
 		/* bufsize may have just been a guess; don't go negative */
 		bufsize = bufsize > length ? bufsize - length : 0;
 	}
@@ -492,6 +510,8 @@ xfs_dir2_leaf_getdents(
 		ctx->pos = xfs_dir2_byte_to_dataptr(curoff) & 0x7fffffff;
 	if (bp)
 		xfs_trans_brelse(args->trans, bp);
+	if (error == -EAGAIN && written > 0)
+		error = 0;
 	return error;
 }
 
@@ -514,6 +534,7 @@ xfs_readdir(
 	unsigned int		lock_mode;
 	bool			isblock;
 	int			error;
+	bool			nowait;
 
 	trace_xfs_readdir(dp);
 
@@ -531,7 +552,11 @@ xfs_readdir(
 	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL)
 		return xfs_dir2_sf_getdents(&args, ctx);
 
-	lock_mode = xfs_ilock_data_map_shared(dp);
+	nowait = ctx->flags & DIR_CONTEXT_F_NOWAIT;
+	lock_mode = xfs_ilock_data_map_shared_generic(dp, nowait);
+	if (!lock_mode)
+		return -EAGAIN;
+
 	error = xfs_dir2_isblock(&args, &isblock);
 	if (error)
 		goto out_unlock;
@@ -546,5 +571,7 @@ xfs_readdir(
 out_unlock:
 	if (lock_mode)
 		xfs_iunlock(dp, lock_mode);
+	if (error == -EAGAIN)
+		ASSERT(nowait);
 	return error;
 }
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 9e62cc500140..d088f7d0c23a 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -120,6 +120,33 @@ xfs_ilock_data_map_shared(
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
+int
+xfs_ilock_data_map_shared_generic(
+	struct xfs_inode	*dp,
+	bool			nowait)
+{
+	if (nowait)
+		return xfs_ilock_data_map_shared_nowait(dp);
+	return xfs_ilock_data_map_shared(dp);
+}
+
 uint
 xfs_ilock_attr_map_shared(
 	struct xfs_inode	*ip)
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 7547caf2f2ab..ea206a5a27df 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -490,13 +490,16 @@ int		xfs_rename(struct mnt_idmap *idmap,
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
+int		xfs_ilock_data_map_shared_generic(struct xfs_inode *ip,
+						  bool nowait);
+uint		xfs_ilock_attr_map_shared(struct xfs_inode *ip);
 
 uint		xfs_ip2xflags(struct xfs_inode *);
 int		xfs_ifree(struct xfs_trans *, struct xfs_inode *);
-- 
2.25.1

