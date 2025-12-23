Return-Path: <io-uring+bounces-11283-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DFEFCD7911
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 01:47:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3ECC13003123
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 00:46:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 654AB21C9F9;
	Tue, 23 Dec 2025 00:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PaGAZPaR"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924C421D3D2;
	Tue, 23 Dec 2025 00:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766450323; cv=none; b=W2ZZOPuLzMa0mG+ltjv7mUX1OGE02Iy/vpZT7PryX/T3R51Izf2TekLJaNrRms2L3X7ug5cO/195YRPQPTnStt9a8Gwowns5mpiQ9gzstUd4+LYmkDbIWh5v06seyQ5j9opnt3qwlYYwTYyGcHMGmfrCGc6kM+yjbGVyHKUeuXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766450323; c=relaxed/simple;
	bh=didO27RXHViH0uY5LSyo+GdvR1l9Ef55RCiduiddSQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LxlL5MPr/5+56qYwQpLA4gmo5gvVnmxbdyxmQiAgoQfzeeTcFt04odUkdywdT+3djXBeCvJNh1ei60xikjtT31y4mjLX/c3QPhBH8upD1zirs4uHmvMoW1rlqpkBHME4HBQTL/QXFK0zsC1PxLIN3gzxA66DqHigIqxcTnAMdb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PaGAZPaR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=+R1isTsRXSfmoSG3zACrsFRq0BNRcgPfdOIvWsRFAAY=; b=PaGAZPaRXVIOBe8ElDnZCrmFz7
	fSgxnSFFTBo62B+r4VVOm5XeLmTDgbxHQWKMUa6w49txgxrNDx7NDswXZcTG8xjnxxOw1H0TyAoj/
	dw2E/b7JLHqF+blk2zf52hOc3xmW58uC0J6JGBtOS1RXVa1sZKXxc4fz6JL5tKeYfBoPnQPTaTvUg
	jN7O4PWZsh2IEzg+tqnD3+NknRDoWb4z4BVmoXaF2RxLzf2qJtY7jUpj1mA+pyexK0zc7VUfK7nb0
	okFZ7uW2IoOa9ALh8XEHXvNJlRF4Lnx++fhrtpTmQbXIJvoKmuIBlfS6jTQQHTS5xdSCKxIQ0UEn9
	Cyo0S8KA==;
Received: from s58.ghokkaidofl2.vectant.ne.jp ([202.215.7.58] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vXqQ8-0000000EItA-2q08;
	Tue, 23 Dec 2025 00:38:37 +0000
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
	David Sterba <dsterba@suse.com>,
	Jan Kara <jack@suse.cz>,
	Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Carlos Maiolino <cem@kernel.org>,
	Stefan Roesch <shr@fb.com>,
	Jeff Layton <jlayton@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	gfs2@lists.linux.dev,
	io-uring@vger.kernel.org,
	devel@lists.orangefs.org,
	linux-unionfs@vger.kernel.org,
	linux-mtd@lists.infradead.org,
	linux-xfs@vger.kernel.org,
	linux-nfs@vger.kernel.org
Subject: [PATCH 06/11] fs: factor out a sync_lazytime helper
Date: Tue, 23 Dec 2025 09:37:49 +0900
Message-ID: <20251223003756.409543-7-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251223003756.409543-1-hch@lst.de>
References: <20251223003756.409543-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Centralize how we synchronize a lazytime update into the actual on-disk
timestamp into a single helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
---
 fs/fs-writeback.c                | 22 +++++++++++++++-------
 fs/inode.c                       |  5 +----
 fs/internal.h                    |  3 ++-
 fs/sync.c                        |  4 ++--
 include/trace/events/writeback.h |  6 ------
 5 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 6800886c4d10..3d68b757136c 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1711,6 +1711,16 @@ static void requeue_inode(struct inode *inode, struct bdi_writeback *wb,
 	}
 }
 
+bool sync_lazytime(struct inode *inode)
+{
+	if (!(inode_state_read_once(inode) & I_DIRTY_TIME))
+		return false;
+
+	trace_writeback_lazytime(inode);
+	mark_inode_dirty_sync(inode);
+	return true;
+}
+
 /*
  * Write out an inode and its dirty pages (or some of its dirty pages, depending
  * on @wbc->nr_to_write), and clear the relevant dirty flags from i_state.
@@ -1750,17 +1760,15 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 	}
 
 	/*
-	 * If the inode has dirty timestamps and we need to write them, call
-	 * mark_inode_dirty_sync() to notify the filesystem about it and to
-	 * change I_DIRTY_TIME into I_DIRTY_SYNC.
+	 * For data integrity writeback, or when the dirty interval expired,
+	 * ask the file system to propagata lazy timestamp updates into real
+	 * dirty state.
 	 */
 	if ((inode_state_read_once(inode) & I_DIRTY_TIME) &&
 	    (wbc->sync_mode == WB_SYNC_ALL ||
 	     time_after(jiffies, inode->dirtied_time_when +
-			dirtytime_expire_interval * HZ))) {
-		trace_writeback_lazytime(inode);
-		mark_inode_dirty_sync(inode);
-	}
+			dirtytime_expire_interval * HZ)))
+		sync_lazytime(inode);
 
 	/*
 	 * Get and clear the dirty flags from i_state.  This needs to be done
diff --git a/fs/inode.c b/fs/inode.c
index 59fffb1dbdeb..212dab5c65ad 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1979,11 +1979,8 @@ void iput(struct inode *inode)
 	if (atomic_add_unless(&inode->i_count, -1, 1))
 		return;
 
-	if ((inode_state_read_once(inode) & I_DIRTY_TIME) && inode->i_nlink) {
-		trace_writeback_lazytime_iput(inode);
-		mark_inode_dirty_sync(inode);
+	if (inode->i_nlink && sync_lazytime(inode))
 		goto retry;
-	}
 
 	spin_lock(&inode->i_lock);
 	if (unlikely((inode_state_read(inode) & I_DIRTY_TIME) && inode->i_nlink)) {
diff --git a/fs/internal.h b/fs/internal.h
index ab638d41ab81..18a062c1b5b0 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -214,7 +214,8 @@ bool in_group_or_capable(struct mnt_idmap *idmap,
 /*
  * fs-writeback.c
  */
-extern long get_nr_dirty_inodes(void);
+long get_nr_dirty_inodes(void);
+bool sync_lazytime(struct inode *inode);
 
 /*
  * dcache.c
diff --git a/fs/sync.c b/fs/sync.c
index 431fc5f5be06..4283af7119d1 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -183,8 +183,8 @@ int vfs_fsync_range(struct file *file, loff_t start, loff_t end, int datasync)
 
 	if (!file->f_op->fsync)
 		return -EINVAL;
-	if (!datasync && (inode_state_read_once(inode) & I_DIRTY_TIME))
-		mark_inode_dirty_sync(inode);
+	if (!datasync)
+		sync_lazytime(inode);
 	return file->f_op->fsync(file, start, end, datasync);
 }
 EXPORT_SYMBOL(vfs_fsync_range);
diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index 311a341e6fe4..7162d03e69a5 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -856,12 +856,6 @@ DEFINE_EVENT(writeback_inode_template, writeback_lazytime,
 	TP_ARGS(inode)
 );
 
-DEFINE_EVENT(writeback_inode_template, writeback_lazytime_iput,
-	TP_PROTO(struct inode *inode),
-
-	TP_ARGS(inode)
-);
-
 DEFINE_EVENT(writeback_inode_template, writeback_dirty_inode_enqueue,
 
 	TP_PROTO(struct inode *inode),
-- 
2.47.3


