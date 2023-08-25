Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD37D7889C2
	for <lists+io-uring@lfdr.de>; Fri, 25 Aug 2023 16:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245446AbjHYOAx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Aug 2023 10:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245456AbjHYOAZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Aug 2023 10:00:25 -0400
Received: from out-244.mta1.migadu.com (out-244.mta1.migadu.com [IPv6:2001:41d0:203:375::f4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62CA32137;
        Fri, 25 Aug 2023 06:59:58 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1692971991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WRD02daxOp9FNChzaFYS1lXdVleuK5a0no8X9tPyoYM=;
        b=KOUX30U5aMel7ZOrU6vyW+bfFawd12zc010HOkye0FIA5XwWQ8KuInrnnmEFvcM8/s51Q/
        AaOybn5P1rP9UUeek73yc4I2uwInaXUHDAuF9iPRuAYZ+C8EXUIDSwZm4Bf0ZiLG750HKq
        BEWS22oRahJI/f4a4TxHtu+cFMHMdVg=
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
Subject: [PATCH 10/29] vfs: add S_NOWAIT for nowait time update
Date:   Fri, 25 Aug 2023 21:54:12 +0800
Message-Id: <20230825135431.1317785-11-hao.xu@linux.dev>
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

Add a new time flag S_NOWAIT to support nowait time update. Deliver it
to specific filesystem and error out -EAGAIN when it would block.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/inode.c         | 9 +++++----
 fs/xfs/xfs_iops.c  | 8 +++++++-
 include/linux/fs.h | 1 +
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index e83b836f2d09..eb3db34a3e6e 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1966,12 +1966,13 @@ int touch_atime(const struct path *path, bool nowait)
 	struct vfsmount *mnt = path->mnt;
 	struct inode *inode = d_inode(path->dentry);
 	struct timespec64 now;
+	int ret = 0;
 
 	if (!atime_needs_update(path, inode))
-		return 0;
+		return ret;
 
 	if (!sb_start_write_trylock(inode->i_sb))
-		return 0;
+		return ret;
 
 	if (__mnt_want_write(mnt) != 0)
 		goto skip_update;
@@ -1985,11 +1986,11 @@ int touch_atime(const struct path *path, bool nowait)
 	 * of the fs read only, e.g. subvolumes in Btrfs.
 	 */
 	now = current_time(inode);
-	inode_update_time(inode, &now, S_ATIME);
+	ret = inode_update_time(inode, &now, S_ATIME | (nowait ? S_NOWAIT : 0));
 	__mnt_drop_write(mnt);
 skip_update:
 	sb_end_write(inode->i_sb);
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(touch_atime);
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 24718adb3c16..bf1d4c31f009 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1053,7 +1053,13 @@ xfs_vn_update_time(
 	if (error)
 		return error;
 
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	if (flags & S_NOWAIT) {
+		if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL))
+			return -EAGAIN;
+	} else {
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
+	}
+
 	if (flags & S_CTIME)
 		inode->i_ctime = *now;
 	if (flags & S_MTIME)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index ed60b3d70d1e..f8c267ee5cb7 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2198,6 +2198,7 @@ enum file_time_flags {
 	S_MTIME = 2,
 	S_CTIME = 4,
 	S_VERSION = 8,
+	S_NOWAIT = 16,
 };
 
 extern bool atime_needs_update(const struct path *, struct inode *);
-- 
2.25.1

