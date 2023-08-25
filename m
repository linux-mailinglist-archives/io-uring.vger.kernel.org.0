Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 234607889F6
	for <lists+io-uring@lfdr.de>; Fri, 25 Aug 2023 16:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245550AbjHYOB6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Aug 2023 10:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245590AbjHYOBr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Aug 2023 10:01:47 -0400
Received: from out-249.mta1.migadu.com (out-249.mta1.migadu.com [95.215.58.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01D1E2728;
        Fri, 25 Aug 2023 07:01:22 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1692972081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q7GJNVQ0Y96opNfJhfWJzC+SabxuYOtwTQfKCmbWXKc=;
        b=j54ewDh2CRDqfk/+h1q/85e0wp1lISfhgPRb5rHWHTlFySJ45nMdNr3rimnyqzcUlx54Dm
        1Iv+GJ+fa2J/Cn+NCS092MkLu4BW3Xiql1+sxKLKb2TiHKwHVsneMm/7FSrPTTHc2KwWos
        w1EYET3XCov0zpVmPbiOAtQWe7vzjrk=
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
Subject: [PATCH 14/29] xfs: support nowait for xfs_log_reserve()
Date:   Fri, 25 Aug 2023 21:54:16 +0800
Message-Id: <20230825135431.1317785-15-hao.xu@linux.dev>
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

Support nowait logic for xfs_log_reserve(), including add a nowait
boolean parameter and error out -EAGAIN for ticket allocation.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/xfs/xfs_log.c      | 18 +++++++++++++-----
 fs/xfs/xfs_log.h      |  5 +++--
 fs/xfs/xfs_log_cil.c  |  2 +-
 fs/xfs/xfs_log_priv.h |  2 +-
 fs/xfs/xfs_trans.c    |  5 +++--
 5 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 79004d193e54..90fbb1c0eca2 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -462,7 +462,8 @@ xfs_log_reserve(
 	int			unit_bytes,
 	int			cnt,
 	struct xlog_ticket	**ticp,
-	bool			permanent)
+	bool			permanent,
+	bool			nowait)
 {
 	struct xlog		*log = mp->m_log;
 	struct xlog_ticket	*tic;
@@ -475,7 +476,9 @@ xfs_log_reserve(
 	XFS_STATS_INC(mp, xs_try_logspace);
 
 	ASSERT(*ticp == NULL);
-	tic = xlog_ticket_alloc(log, unit_bytes, cnt, permanent);
+	tic = xlog_ticket_alloc(log, unit_bytes, cnt, permanent, nowait);
+	if (!tic)
+		return -EAGAIN;
 	*ticp = tic;
 
 	xlog_grant_push_ail(log, tic->t_cnt ? tic->t_unit_res * tic->t_cnt
@@ -974,7 +977,7 @@ xlog_unmount_write(
 	struct xlog_ticket	*tic = NULL;
 	int			error;
 
-	error = xfs_log_reserve(mp, 600, 1, &tic, 0);
+	error = xfs_log_reserve(mp, 600, 1, &tic, 0, false);
 	if (error)
 		goto out_err;
 
@@ -3527,12 +3530,17 @@ xlog_ticket_alloc(
 	struct xlog		*log,
 	int			unit_bytes,
 	int			cnt,
-	bool			permanent)
+	bool			permanent,
+	bool			nowait)
 {
 	struct xlog_ticket	*tic;
 	int			unit_res;
 
-	tic = kmem_cache_zalloc(xfs_log_ticket_cache, GFP_NOFS | __GFP_NOFAIL);
+	gfp_t			gfp_flags = GFP_NOFS |
+					    (nowait ? 0 : __GFP_NOFAIL);
+	tic = kmem_cache_zalloc(xfs_log_ticket_cache, gfp_flags);
+	if (!tic)
+		return NULL;
 
 	unit_res = xlog_calc_unit_res(log, unit_bytes, &tic->t_iclog_hdrs);
 
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 2728886c2963..ba515df443c3 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -139,8 +139,9 @@ void	xfs_log_mount_cancel(struct xfs_mount *);
 xfs_lsn_t xlog_assign_tail_lsn(struct xfs_mount *mp);
 xfs_lsn_t xlog_assign_tail_lsn_locked(struct xfs_mount *mp);
 void	xfs_log_space_wake(struct xfs_mount *mp);
-int	xfs_log_reserve(struct xfs_mount *mp, int length, int count,
-			struct xlog_ticket **ticket, bool permanent);
+int	xfs_log_reserve(struct xfs_mount *mp, int length,
+			int count, struct xlog_ticket **ticket,
+			bool permanent, bool nowait);
 int	xfs_log_regrant(struct xfs_mount *mp, struct xlog_ticket *tic);
 void	xfs_log_unmount(struct xfs_mount *mp);
 bool	xfs_log_writable(struct xfs_mount *mp);
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index eccbfb99e894..f17c1799b3c4 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -37,7 +37,7 @@ xlog_cil_ticket_alloc(
 {
 	struct xlog_ticket *tic;
 
-	tic = xlog_ticket_alloc(log, 0, 1, 0);
+	tic = xlog_ticket_alloc(log, 0, 1, 0, false);
 
 	/*
 	 * set the current reservation to zero so we know to steal the basic
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 1bd2963e8fbd..41edaa0ae869 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -503,7 +503,7 @@ extern __le32	 xlog_cksum(struct xlog *log, struct xlog_rec_header *rhead,
 
 extern struct kmem_cache *xfs_log_ticket_cache;
 struct xlog_ticket *xlog_ticket_alloc(struct xlog *log, int unit_bytes,
-		int count, bool permanent);
+		int count, bool permanent, bool nowait);
 
 void	xlog_print_tic_res(struct xfs_mount *mp, struct xlog_ticket *ticket);
 void	xlog_print_trans(struct xfs_trans *);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index dbec685f4f4a..7988b4c7f36e 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -155,6 +155,7 @@ xfs_trans_reserve(
 	struct xfs_mount	*mp = tp->t_mountp;
 	int			error = 0;
 	bool			rsvd = (tp->t_flags & XFS_TRANS_RESERVE) != 0;
+	bool			nowait = tp->t_flags & XFS_TRANS_NOWAIT;
 
 	/*
 	 * Attempt to reserve the needed disk blocks by decrementing
@@ -192,8 +193,8 @@ xfs_trans_reserve(
 			error = xfs_log_regrant(mp, tp->t_ticket);
 		} else {
 			error = xfs_log_reserve(mp, resp->tr_logres,
-						resp->tr_logcount,
-						&tp->t_ticket, permanent);
+						resp->tr_logcount, &tp->t_ticket,
+						permanent, nowait);
 		}
 
 		if (error)
-- 
2.25.1

