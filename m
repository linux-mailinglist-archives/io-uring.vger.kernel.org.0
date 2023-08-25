Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB3D67889EE
	for <lists+io-uring@lfdr.de>; Fri, 25 Aug 2023 16:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245562AbjHYOB5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Aug 2023 10:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238644AbjHYOBj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Aug 2023 10:01:39 -0400
Received: from out-243.mta1.migadu.com (out-243.mta1.migadu.com [IPv6:2001:41d0:203:375::f3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF7C9270E;
        Fri, 25 Aug 2023 07:01:08 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1692972064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8gDZUIYfeApELVxpIbTdhBYkuCUYVAI89qfTIaKdMRE=;
        b=T5TsYuTvtADJBxiHqsewoSqqKK2UBuXMKNSoxaDNp/NJgc7Q8+g8JEetIByTzkVFCGvNzG
        tWnxRnfXklKMFPsrmWvd4eLQKArJQqjl9a4PVTfDC36l8fZblJzTpI0+nRJbIbwH5cYBhh
        1gSrwgjCBl1L9hu8cUoTezmUDMAfEak=
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
Subject: [PATCH 13/29] xfs: make xfs_trans_alloc() support nowait semantics
Date:   Fri, 25 Aug 2023 21:54:15 +0800
Message-Id: <20230825135431.1317785-14-hao.xu@linux.dev>
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

There are locks in xfs_trans_alloc(), spot them and apply trylock logic.
Make them return -EAGAIN when it would block. To achieve this, add
nowait parameter for those functions in the path. Besides, add a generic
transaction flag XFS_TRANS_NOWAIT to deliver nowait info.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/xfs/libxfs/xfs_shared.h |  2 ++
 fs/xfs/xfs_iops.c          |  3 ++-
 fs/xfs/xfs_trans.c         | 21 ++++++++++++++++++---
 3 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index c4381388c0c1..0ba3d6f53405 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -83,6 +83,8 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
  * made then this algorithm will eventually find all the space it needs.
  */
 #define XFS_TRANS_LOWMODE	0x100	/* allocate in low space mode */
+/* Transaction should follow nowait semantics */
+#define XFS_TRANS_NOWAIT		(1u << 9)
 
 /*
  * Field values for xfs_trans_mod_sb.
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 5fa391083de9..47b4fd5f8f5c 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1054,7 +1054,8 @@ xfs_vn_update_time(
 	if (nowait)
 		old_pflags = memalloc_noio_save();
 
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_fsyncts, 0, 0, 0, &tp);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_fsyncts, 0, 0,
+				nowait ? XFS_TRANS_NOWAIT : 0, &tp);
 	if (error)
 		goto out;
 
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 8c0bfc9a33b1..dbec685f4f4a 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -251,6 +251,9 @@ xfs_trans_alloc(
 	struct xfs_trans	*tp;
 	bool			want_retry = true;
 	int			error;
+	bool			nowait = flags & XFS_TRANS_NOWAIT;
+	gfp_t			gfp_flags = GFP_KERNEL |
+					    (nowait ? 0 : __GFP_NOFAIL);
 
 	/*
 	 * Allocate the handle before we do our freeze accounting and setting up
@@ -258,9 +261,21 @@ xfs_trans_alloc(
 	 * by doing GFP_KERNEL allocations inside sb_start_intwrite().
 	 */
 retry:
-	tp = kmem_cache_zalloc(xfs_trans_cache, GFP_KERNEL | __GFP_NOFAIL);
-	if (!(flags & XFS_TRANS_NO_WRITECOUNT))
-		sb_start_intwrite(mp->m_super);
+	tp = kmem_cache_zalloc(xfs_trans_cache, gfp_flags);
+	if (!tp)
+		return -EAGAIN;
+	if (!(flags & XFS_TRANS_NO_WRITECOUNT)) {
+		if (nowait) {
+			bool locked = sb_start_intwrite_trylock(mp->m_super);
+
+			if (!locked) {
+				xfs_trans_cancel(tp);
+				return -EAGAIN;
+			}
+		} else {
+			sb_start_intwrite(mp->m_super);
+		}
+	}
 	xfs_trans_set_context(tp);
 
 	/*
-- 
2.25.1

