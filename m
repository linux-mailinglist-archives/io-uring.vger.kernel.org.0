Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD02788B44
	for <lists+io-uring@lfdr.de>; Fri, 25 Aug 2023 16:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243278AbjHYOLw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Aug 2023 10:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343782AbjHYOLj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Aug 2023 10:11:39 -0400
Received: from out-247.mta1.migadu.com (out-247.mta1.migadu.com [IPv6:2001:41d0:203:375::f7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D3172D57;
        Fri, 25 Aug 2023 07:11:23 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1692972321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6/Nd9xxoGpB2Y5m9xwXDJRTcGKza/1aMnRr8dKaa6VQ=;
        b=KEbezTf0obDqS0d0+ZY03Au9A3+XAlHMaifao/gSyVuoHlKJlTUkwmI81DvHZmrTrUQaLF
        sGTDWP5rChj2LFxWYHnJBky5ZudbW2OzCc+00JgxX/lbJXlYqo7/5HQVTOk8DmfuG/wY54
        UCC6hfeA7Mu6K3Y30dgBdV885aCoMfc=
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
Subject: [PATCH 25/29] xfs: support nowait for xfs_buf_item_init()
Date:   Fri, 25 Aug 2023 21:54:27 +0800
Message-Id: <20230825135431.1317785-26-hao.xu@linux.dev>
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

support nowait for xfs_buf_item_init() and error out -EAGAIN to
_xfs_trans_bjoin() when it would block.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/xfs/xfs_buf_item.c         |  9 +++++++--
 fs/xfs/xfs_buf_item.h         |  2 +-
 fs/xfs/xfs_buf_item_recover.c |  2 +-
 fs/xfs/xfs_trans_buf.c        | 16 +++++++++++++---
 4 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 023d4e0385dd..b1e63137d65b 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -827,7 +827,8 @@ xfs_buf_item_free_format(
 int
 xfs_buf_item_init(
 	struct xfs_buf	*bp,
-	struct xfs_mount *mp)
+	struct xfs_mount *mp,
+	bool   nowait)
 {
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 	int			chunks;
@@ -847,7 +848,11 @@ xfs_buf_item_init(
 		return 0;
 	}
 
-	bip = kmem_cache_zalloc(xfs_buf_item_cache, GFP_KERNEL | __GFP_NOFAIL);
+	bip = kmem_cache_zalloc(xfs_buf_item_cache,
+				GFP_KERNEL | (nowait ? 0 : __GFP_NOFAIL));
+	if (!bip)
+		return -EAGAIN;
+
 	xfs_log_item_init(mp, &bip->bli_item, XFS_LI_BUF, &xfs_buf_item_ops);
 	bip->bli_buf = bp;
 
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index 4d8a6aece995..b1daf8988280 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -47,7 +47,7 @@ struct xfs_buf_log_item {
 	struct xfs_buf_log_format __bli_format;	/* embedded in-log header */
 };
 
-int	xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
+int	xfs_buf_item_init(struct xfs_buf *bp, struct xfs_mount *mp, bool nowait);
 void	xfs_buf_item_done(struct xfs_buf *bp);
 void	xfs_buf_item_relse(struct xfs_buf *);
 bool	xfs_buf_item_put(struct xfs_buf_log_item *);
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 43167f543afc..aa64d5a499d6 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -429,7 +429,7 @@ xlog_recover_validate_buf_type(
 		struct xfs_buf_log_item	*bip;
 
 		bp->b_flags |= _XBF_LOGRECOVERY;
-		xfs_buf_item_init(bp, mp);
+		xfs_buf_item_init(bp, mp, false);
 		bip = bp->b_log_item;
 		bip->bli_item.li_lsn = current_lsn;
 	}
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 016371f58f26..a1e4f2e8629a 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -57,13 +57,14 @@ xfs_trans_buf_item_match(
  * If the buffer does not yet have a buf log item associated with it,
  * then allocate one for it.  Then add the buf item to the transaction.
  */
-STATIC void
+STATIC int
 _xfs_trans_bjoin(
 	struct xfs_trans	*tp,
 	struct xfs_buf		*bp,
 	int			reset_recur)
 {
 	struct xfs_buf_log_item	*bip;
+	int ret;
 
 	ASSERT(bp->b_transp == NULL);
 
@@ -72,7 +73,11 @@ _xfs_trans_bjoin(
 	 * it doesn't have one yet, then allocate one and initialize it.
 	 * The checks to see if one is there are in xfs_buf_item_init().
 	 */
-	xfs_buf_item_init(bp, tp->t_mountp);
+	ret = xfs_buf_item_init(bp, tp->t_mountp,
+				tp->t_flags & XFS_TRANS_NOWAIT);
+	if (ret < 0)
+		return ret;
+
 	bip = bp->b_log_item;
 	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
 	ASSERT(!(bip->__bli_format.blf_flags & XFS_BLF_CANCEL));
@@ -92,6 +97,7 @@ _xfs_trans_bjoin(
 	xfs_trans_add_item(tp, &bip->bli_item);
 	bp->b_transp = tp;
 
+	return 0;
 }
 
 void
@@ -309,7 +315,11 @@ xfs_trans_read_buf_map(
 	}
 
 	if (tp) {
-		_xfs_trans_bjoin(tp, bp, 1);
+		error = _xfs_trans_bjoin(tp, bp, 1);
+		if (error) {
+			xfs_buf_relse(bp);
+			return error;
+		}
 		trace_xfs_trans_read_buf(bp->b_log_item);
 	}
 	ASSERT(bp->b_ops != NULL || ops == NULL);
-- 
2.25.1

