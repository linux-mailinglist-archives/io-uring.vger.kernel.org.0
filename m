Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB31763381
	for <lists+io-uring@lfdr.de>; Wed, 26 Jul 2023 12:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233839AbjGZK0h (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Jul 2023 06:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233815AbjGZK0c (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Jul 2023 06:26:32 -0400
Received: from out-23.mta1.migadu.com (out-23.mta1.migadu.com [95.215.58.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87F182683
        for <io-uring@vger.kernel.org>; Wed, 26 Jul 2023 03:26:30 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1690367188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XG23bwIETsfnqj7ej3G1Pf4FjZCp41aRmz5oYSwWIns=;
        b=psDaZVP3FSX50i9dl1HeTai8ASW5mklXthDlZcFCReJ1g80/nsQphphuQ91+icR5gMOESL
        vuV7A/r0N87q5CwVUvJFtmCY2rlHrvyu4UHp77lN4e/Vma/g8iBeU95bPIOShs865DRJPh
        Uav4hF6uSWQvrtJWZJFwiQ9xkYjh2Uc=
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
        linux-ext4@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH 3/7] add nowait parameter for iomap_seek()
Date:   Wed, 26 Jul 2023 18:25:59 +0800
Message-Id: <20230726102603.155522-4-hao.xu@linux.dev>
In-Reply-To: <20230726102603.155522-1-hao.xu@linux.dev>
References: <20230726102603.155522-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_SBL_CSS,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

Add a nowait parameter for iomap_seek(), later IOMAP_NOWAIT is set
according to this parameter's value.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/ext4/file.c        | 2 +-
 fs/gfs2/inode.c       | 4 ++--
 fs/iomap/seek.c       | 4 +++-
 fs/xfs/xfs_file.c     | 2 +-
 include/linux/iomap.h | 2 +-
 5 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 3d59993bce56..c6c38c34148b 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -939,7 +939,7 @@ loff_t ext4_llseek(struct file *file, loff_t offset, int whence)
 	case SEEK_DATA:
 		inode_lock_shared(inode);
 		offset = iomap_seek(inode, offset, &ext4_iomap_report_ops,
-				    whence == SEEK_HOLE);
+				    whence == SEEK_HOLE, false);
 		inode_unlock_shared(inode);
 		break;
 	}
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 628f9d014491..5d6e7471cb07 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -2111,7 +2111,7 @@ loff_t gfs2_seek_data(struct file *file, loff_t offset)
 	inode_lock_shared(inode);
 	ret = gfs2_glock_nq_init(ip->i_gl, LM_ST_SHARED, 0, &gh);
 	if (!ret)
-		ret = iomap_seek(inode, offset, &gfs2_iomap_ops, false);
+		ret = iomap_seek(inode, offset, &gfs2_iomap_ops, false, false);
 	gfs2_glock_dq_uninit(&gh);
 	inode_unlock_shared(inode);
 
@@ -2130,7 +2130,7 @@ loff_t gfs2_seek_hole(struct file *file, loff_t offset)
 	inode_lock_shared(inode);
 	ret = gfs2_glock_nq_init(ip->i_gl, LM_ST_SHARED, 0, &gh);
 	if (!ret)
-		ret = iomap_seek(inode, offset, &gfs2_iomap_ops, true);
+		ret = iomap_seek(inode, offset, &gfs2_iomap_ops, true, false);
 	gfs2_glock_dq_uninit(&gh);
 	inode_unlock_shared(inode);
 
diff --git a/fs/iomap/seek.c b/fs/iomap/seek.c
index 5e8641c5f0da..319ea19fa90d 100644
--- a/fs/iomap/seek.c
+++ b/fs/iomap/seek.c
@@ -52,7 +52,7 @@ static loff_t iomap_seek_data_iter(const struct iomap_iter *iter,
 
 loff_t
 iomap_seek(struct inode *inode, loff_t pos, const struct iomap_ops *ops,
-	   bool hole)
+	   bool hole, bool nowait)
 {
 	loff_t size = i_size_read(inode);
 	struct iomap_iter iter = {
@@ -66,6 +66,8 @@ iomap_seek(struct inode *inode, loff_t pos, const struct iomap_ops *ops,
 	if (pos < 0 || pos >= size)
 		return -ENXIO;
 
+	if (nowait)
+		iter.flags |= IOMAP_NOWAIT;
 	iter.len = size - pos;
 	while ((ret = iomap_iter(&iter, ops)) > 0)
 		iter.processed = hole ? iomap_seek_hole_iter(&iter, &pos) :
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index d7d37f8fb6bc..73adc0aee2ff 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1273,7 +1273,7 @@ xfs_file_llseek(
 	case SEEK_HOLE:
 	case SEEK_DATA:
 		offset = iomap_seek(inode, offset, &xfs_seek_iomap_ops,
-				    whence == SEEK_HOLE);
+				    whence == SEEK_HOLE, nowait);
 		break;
 	}
 
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 22d5f9b19a22..f99769d4fc42 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -275,7 +275,7 @@ vm_fault_t iomap_page_mkwrite(struct vm_fault *vmf,
 int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		u64 start, u64 len, const struct iomap_ops *ops);
 loff_t iomap_seek(struct inode *inode, loff_t offset,
-		  const struct iomap_ops *ops, bool hole);
+		  const struct iomap_ops *ops, bool hole, bool nowait);
 sector_t iomap_bmap(struct address_space *mapping, sector_t bno,
 		const struct iomap_ops *ops);
 
-- 
2.25.1

