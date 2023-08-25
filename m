Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30579788930
	for <lists+io-uring@lfdr.de>; Fri, 25 Aug 2023 15:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233387AbjHYN4A (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Aug 2023 09:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245376AbjHYNzp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Aug 2023 09:55:45 -0400
Received: from out-242.mta1.migadu.com (out-242.mta1.migadu.com [95.215.58.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D31352689
        for <io-uring@vger.kernel.org>; Fri, 25 Aug 2023 06:55:40 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1692971737;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T0rAQ2m4NCOjyQSS+sDl9LbRcvD63qBgcFke1LvzwG4=;
        b=FhWBDojlb1xYVHNahPbh8JswlNyJ/7jP1EQwNTm7cO8OehSugwUDArDmc1mbqA0BkMNMvY
        d5QJXx+UI3kBCUhvBoGQg8tDI16sv1k0yhgjUCPvI7yY9h5j0N5DBUGFQcYH7e2p4/SYF7
        drCs2jVg1zT9ErcXMBzhoggf+SCjkYU=
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
Subject: [PATCH 02/29] xfs: rename XBF_TRYLOCK to XBF_NOWAIT
Date:   Fri, 25 Aug 2023 21:54:04 +0800
Message-Id: <20230825135431.1317785-3-hao.xu@linux.dev>
In-Reply-To: <20230825135431.1317785-1-hao.xu@linux.dev>
References: <20230825135431.1317785-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

XBF_TRYLOCK means we need lock but don't block on it, we can use it to
stand for not waiting for memory allcation. Rename XBF_TRYLOCK to
XBF_NOWAIT, which is more generic.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/xfs/libxfs/xfs_alloc.c       | 2 +-
 fs/xfs/libxfs/xfs_attr_remote.c | 2 +-
 fs/xfs/libxfs/xfs_btree.c       | 2 +-
 fs/xfs/scrub/repair.c           | 2 +-
 fs/xfs/xfs_buf.c                | 6 +++---
 fs/xfs/xfs_buf.h                | 4 ++--
 fs/xfs/xfs_dquot.c              | 2 +-
 7 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 3069194527dd..a75b9298faa8 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3183,7 +3183,7 @@ xfs_alloc_read_agf(
 	ASSERT((flags & (XFS_ALLOC_FLAG_FREEING | XFS_ALLOC_FLAG_TRYLOCK)) !=
 			(XFS_ALLOC_FLAG_FREEING | XFS_ALLOC_FLAG_TRYLOCK));
 	error = xfs_read_agf(pag, tp,
-			(flags & XFS_ALLOC_FLAG_TRYLOCK) ? XBF_TRYLOCK : 0,
+			(flags & XFS_ALLOC_FLAG_TRYLOCK) ? XBF_NOWAIT : 0,
 			&agfbp);
 	if (error)
 		return error;
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index d440393b40eb..2ccb0867824c 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -661,7 +661,7 @@ xfs_attr_rmtval_invalidate(
 			return error;
 		if (XFS_IS_CORRUPT(args->dp->i_mount, nmap != 1))
 			return -EFSCORRUPTED;
-		error = xfs_attr_rmtval_stale(args->dp, &map, XBF_TRYLOCK);
+		error = xfs_attr_rmtval_stale(args->dp, &map, XBF_NOWAIT);
 		if (error)
 			return error;
 
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 6a6503ab0cd7..77c4f1d83475 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1343,7 +1343,7 @@ xfs_btree_read_buf_block(
 	int			error;
 
 	/* need to sort out how callers deal with failures first */
-	ASSERT(!(flags & XBF_TRYLOCK));
+	ASSERT(!(flags & XBF_NOWAIT));
 
 	error = xfs_btree_ptr_to_daddr(cur, ptr, &d);
 	if (error)
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index ac6d8803e660..9312cf3b20e2 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -460,7 +460,7 @@ xrep_invalidate_block(
 
 	error = xfs_buf_incore(sc->mp->m_ddev_targp,
 			XFS_FSB_TO_DADDR(sc->mp, fsbno),
-			XFS_FSB_TO_BB(sc->mp, 1), XBF_TRYLOCK, &bp);
+			XFS_FSB_TO_BB(sc->mp, 1), XBF_NOWAIT, &bp);
 	if (error)
 		return 0;
 
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 15d1e5a7c2d3..9f84bc3b802c 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -228,7 +228,7 @@ _xfs_buf_alloc(
 	 * We don't want certain flags to appear in b_flags unless they are
 	 * specifically set by later operations on the buffer.
 	 */
-	flags &= ~(XBF_UNMAPPED | XBF_TRYLOCK | XBF_ASYNC | XBF_READ_AHEAD);
+	flags &= ~(XBF_UNMAPPED | XBF_NOWAIT | XBF_ASYNC | XBF_READ_AHEAD);
 
 	atomic_set(&bp->b_hold, 1);
 	atomic_set(&bp->b_lru_ref, 1);
@@ -543,7 +543,7 @@ xfs_buf_find_lock(
 	struct xfs_buf          *bp,
 	xfs_buf_flags_t		flags)
 {
-	if (flags & XBF_TRYLOCK) {
+	if (flags & XBF_NOWAIT) {
 		if (!xfs_buf_trylock(bp)) {
 			XFS_STATS_INC(bp->b_mount, xb_busy_locked);
 			return -EAGAIN;
@@ -886,7 +886,7 @@ xfs_buf_readahead_map(
 	struct xfs_buf		*bp;
 
 	xfs_buf_read_map(target, map, nmaps,
-		     XBF_TRYLOCK | XBF_ASYNC | XBF_READ_AHEAD, &bp, ops,
+		     XBF_NOWAIT | XBF_ASYNC | XBF_READ_AHEAD, &bp, ops,
 		     __this_address);
 }
 
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 549c60942208..8cd307626939 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -45,7 +45,7 @@ struct xfs_buf;
 
 /* flags used only as arguments to access routines */
 #define XBF_INCORE	 (1u << 29)/* lookup only, return if found in cache */
-#define XBF_TRYLOCK	 (1u << 30)/* lock requested, but do not wait */
+#define XBF_NOWAIT	 (1u << 30)/* mem/lock requested, but do not wait */
 #define XBF_UNMAPPED	 (1u << 31)/* do not map the buffer */
 
 
@@ -68,7 +68,7 @@ typedef unsigned int xfs_buf_flags_t;
 	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
 	/* The following interface flags should never be set */ \
 	{ XBF_INCORE,		"INCORE" }, \
-	{ XBF_TRYLOCK,		"TRYLOCK" }, \
+	{ XBF_NOWAIT,		"NOWAIT" }, \
 	{ XBF_UNMAPPED,		"UNMAPPED" }
 
 /*
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 7f071757f278..5bc01ed4b2d7 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1233,7 +1233,7 @@ xfs_qm_dqflush(
 	 * Get the buffer containing the on-disk dquot
 	 */
 	error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp, dqp->q_blkno,
-				   mp->m_quotainfo->qi_dqchunklen, XBF_TRYLOCK,
+				   mp->m_quotainfo->qi_dqchunklen, XBF_NOWAIT,
 				   &bp, &xfs_dquot_buf_ops);
 	if (error == -EAGAIN)
 		goto out_unlock;
-- 
2.25.1

