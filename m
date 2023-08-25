Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 702D17889D3
	for <lists+io-uring@lfdr.de>; Fri, 25 Aug 2023 16:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245490AbjHYOBY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Aug 2023 10:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245548AbjHYOBI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Aug 2023 10:01:08 -0400
Received: from out-244.mta1.migadu.com (out-244.mta1.migadu.com [IPv6:2001:41d0:203:375::f4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD752729;
        Fri, 25 Aug 2023 07:00:41 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1692972039;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A8n142m+ckTq2ok9t7Tm2FnSZDGwRTGaDgQRQd0QVrs=;
        b=pz2+RJXny/FRc9X5ZHvo0v2sP0AhNIbG6GqEDC3f4IgSNhM3HBNVDwOESMUSOR4IEMUxcQ
        QeB+zNMG6saCP+3Ee3iNvTaLm94PmwVrh29h0zPxcQxdxo6uNrunXvw2MGBXff+gKAxGGD
        nCmOsY1G1aaOlGneScmRPtSGG9/rCYg=
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
Subject: [PATCH 12/29] xfs: enforce GFP_NOIO implicitly during nowait time update
Date:   Fri, 25 Aug 2023 21:54:14 +0800
Message-Id: <20230825135431.1317785-13-hao.xu@linux.dev>
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

Enforce GFP_NOIO logic implicitly by set pflags if we are in nowait
time update process. Nowait semantics means no waiting for IO,
therefore GFP_NOIO is needed.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/xfs/xfs_iops.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index bf1d4c31f009..5fa391083de9 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1037,6 +1037,8 @@ xfs_vn_update_time(
 	int			log_flags = XFS_ILOG_TIMESTAMP;
 	struct xfs_trans	*tp;
 	int			error;
+	int			old_pflags;
+	bool			nowait = flags & S_NOWAIT;
 
 	trace_xfs_update_time(ip);
 
@@ -1049,13 +1051,18 @@ xfs_vn_update_time(
 		log_flags |= XFS_ILOG_CORE;
 	}
 
+	if (nowait)
+		old_pflags = memalloc_noio_save();
+
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_fsyncts, 0, 0, 0, &tp);
 	if (error)
-		return error;
+		goto out;
 
-	if (flags & S_NOWAIT) {
-		if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL))
-			return -EAGAIN;
+	if (nowait) {
+		if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL)) {
+			error = -EAGAIN;
+			goto out;
+		}
 	} else {
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
 	}
@@ -1069,7 +1076,12 @@ xfs_vn_update_time(
 
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 	xfs_trans_log_inode(tp, ip, log_flags);
-	return xfs_trans_commit(tp);
+	error = xfs_trans_commit(tp);
+
+out:
+	if (nowait)
+		memalloc_noio_restore(old_pflags);
+	return error;
 }
 
 STATIC int
-- 
2.25.1

