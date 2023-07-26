Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79F8D763378
	for <lists+io-uring@lfdr.de>; Wed, 26 Jul 2023 12:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233801AbjGZK0X (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Jul 2023 06:26:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233803AbjGZK0U (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Jul 2023 06:26:20 -0400
Received: from out-3.mta1.migadu.com (out-3.mta1.migadu.com [95.215.58.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 484692129
        for <io-uring@vger.kernel.org>; Wed, 26 Jul 2023 03:26:18 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1690367177;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5sGF3aDp5Ab6VJPIZgqoGrsmM2RUgLWSdrVdkpi2z8c=;
        b=xcrply0XV2HDyJsf7BcCe6bc9g/ddY1PH2ZmusoHEDQPxefX63K1P+9Tj0UN0hQij7rnz8
        cdGMIIM/s1NT7GLPngIqMjtLXWsb3vtqurFwjVh1T4zyqSCKl2W6O9xjKmTYE5Ds+NLjn9
        buPEIspqWwmb6CZmEVsFLk81/CHu2Zc=
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
Subject: [PATCH 1/7] iomap: merge iomap_seek_hole() and iomap_seek_data()
Date:   Wed, 26 Jul 2023 18:25:57 +0800
Message-Id: <20230726102603.155522-2-hao.xu@linux.dev>
In-Reply-To: <20230726102603.155522-1-hao.xu@linux.dev>
References: <20230726102603.155522-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

The two functions share almost same code, merge them together.
No functional change in this patch.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/ext4/file.c        |  9 ++-------
 fs/gfs2/inode.c       |  4 ++--
 fs/iomap/seek.c       | 40 ++++++++--------------------------------
 fs/xfs/xfs_file.c     |  5 ++---
 include/linux/iomap.h |  6 ++----
 5 files changed, 16 insertions(+), 48 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index c457c8517f0f..3d59993bce56 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -936,15 +936,10 @@ loff_t ext4_llseek(struct file *file, loff_t offset, int whence)
 		return generic_file_llseek_size(file, offset, whence,
 						maxbytes, i_size_read(inode));
 	case SEEK_HOLE:
-		inode_lock_shared(inode);
-		offset = iomap_seek_hole(inode, offset,
-					 &ext4_iomap_report_ops);
-		inode_unlock_shared(inode);
-		break;
 	case SEEK_DATA:
 		inode_lock_shared(inode);
-		offset = iomap_seek_data(inode, offset,
-					 &ext4_iomap_report_ops);
+		offset = iomap_seek(inode, offset, &ext4_iomap_report_ops,
+				    whence == SEEK_HOLE);
 		inode_unlock_shared(inode);
 		break;
 	}
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 17c994a0c0d0..628f9d014491 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -2111,7 +2111,7 @@ loff_t gfs2_seek_data(struct file *file, loff_t offset)
 	inode_lock_shared(inode);
 	ret = gfs2_glock_nq_init(ip->i_gl, LM_ST_SHARED, 0, &gh);
 	if (!ret)
-		ret = iomap_seek_data(inode, offset, &gfs2_iomap_ops);
+		ret = iomap_seek(inode, offset, &gfs2_iomap_ops, false);
 	gfs2_glock_dq_uninit(&gh);
 	inode_unlock_shared(inode);
 
@@ -2130,7 +2130,7 @@ loff_t gfs2_seek_hole(struct file *file, loff_t offset)
 	inode_lock_shared(inode);
 	ret = gfs2_glock_nq_init(ip->i_gl, LM_ST_SHARED, 0, &gh);
 	if (!ret)
-		ret = iomap_seek_hole(inode, offset, &gfs2_iomap_ops);
+		ret = iomap_seek(inode, offset, &gfs2_iomap_ops, true);
 	gfs2_glock_dq_uninit(&gh);
 	inode_unlock_shared(inode);
 
diff --git a/fs/iomap/seek.c b/fs/iomap/seek.c
index a845c012b50c..5e8641c5f0da 100644
--- a/fs/iomap/seek.c
+++ b/fs/iomap/seek.c
@@ -30,32 +30,6 @@ static loff_t iomap_seek_hole_iter(const struct iomap_iter *iter,
 	}
 }
 
-loff_t
-iomap_seek_hole(struct inode *inode, loff_t pos, const struct iomap_ops *ops)
-{
-	loff_t size = i_size_read(inode);
-	struct iomap_iter iter = {
-		.inode	= inode,
-		.pos	= pos,
-		.flags	= IOMAP_REPORT,
-	};
-	int ret;
-
-	/* Nothing to be found before or beyond the end of the file. */
-	if (pos < 0 || pos >= size)
-		return -ENXIO;
-
-	iter.len = size - pos;
-	while ((ret = iomap_iter(&iter, ops)) > 0)
-		iter.processed = iomap_seek_hole_iter(&iter, &pos);
-	if (ret < 0)
-		return ret;
-	if (iter.len) /* found hole before EOF */
-		return pos;
-	return size;
-}
-EXPORT_SYMBOL_GPL(iomap_seek_hole);
-
 static loff_t iomap_seek_data_iter(const struct iomap_iter *iter,
 		loff_t *hole_pos)
 {
@@ -77,7 +51,8 @@ static loff_t iomap_seek_data_iter(const struct iomap_iter *iter,
 }
 
 loff_t
-iomap_seek_data(struct inode *inode, loff_t pos, const struct iomap_ops *ops)
+iomap_seek(struct inode *inode, loff_t pos, const struct iomap_ops *ops,
+	   bool hole)
 {
 	loff_t size = i_size_read(inode);
 	struct iomap_iter iter = {
@@ -93,12 +68,13 @@ iomap_seek_data(struct inode *inode, loff_t pos, const struct iomap_ops *ops)
 
 	iter.len = size - pos;
 	while ((ret = iomap_iter(&iter, ops)) > 0)
-		iter.processed = iomap_seek_data_iter(&iter, &pos);
+		iter.processed = hole ? iomap_seek_hole_iter(&iter, &pos) :
+				 iomap_seek_data_iter(&iter, &pos);
 	if (ret < 0)
 		return ret;
-	if (iter.len) /* found data before EOF */
+	if (iter.len) /* found hole/data before EOF */
 		return pos;
-	/* We've reached the end of the file without finding data */
-	return -ENXIO;
+	/* We've reached the end of the file without finding hole/data */
+	return hole ? size : -ENXIO;
 }
-EXPORT_SYMBOL_GPL(iomap_seek_data);
+EXPORT_SYMBOL_GPL(iomap_seek);
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 4f502219ae4f..d7d37f8fb6bc 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1271,10 +1271,9 @@ xfs_file_llseek(
 	default:
 		return generic_file_llseek(file, offset, whence);
 	case SEEK_HOLE:
-		offset = iomap_seek_hole(inode, offset, &xfs_seek_iomap_ops);
-		break;
 	case SEEK_DATA:
-		offset = iomap_seek_data(inode, offset, &xfs_seek_iomap_ops);
+		offset = iomap_seek(inode, offset, &xfs_seek_iomap_ops,
+				    whence == SEEK_HOLE);
 		break;
 	}
 
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index e2b836c2e119..22d5f9b19a22 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -274,10 +274,8 @@ vm_fault_t iomap_page_mkwrite(struct vm_fault *vmf,
 			const struct iomap_ops *ops);
 int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		u64 start, u64 len, const struct iomap_ops *ops);
-loff_t iomap_seek_hole(struct inode *inode, loff_t offset,
-		const struct iomap_ops *ops);
-loff_t iomap_seek_data(struct inode *inode, loff_t offset,
-		const struct iomap_ops *ops);
+loff_t iomap_seek(struct inode *inode, loff_t offset,
+		  const struct iomap_ops *ops, bool hole);
 sector_t iomap_bmap(struct address_space *mapping, sector_t bno,
 		const struct iomap_ops *ops);
 
-- 
2.25.1

