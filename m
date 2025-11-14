Return-Path: <io-uring+bounces-10625-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 34936C5B8A9
	for <lists+io-uring@lfdr.de>; Fri, 14 Nov 2025 07:31:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 009093BE710
	for <lists+io-uring@lfdr.de>; Fri, 14 Nov 2025 06:31:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AC072FC880;
	Fri, 14 Nov 2025 06:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DhGQXd8f"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11DCC2FC014;
	Fri, 14 Nov 2025 06:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763101686; cv=none; b=FlKuzKkGOqHneBPl1Y8x4SMuPydpBxaq+j+hqETGh+/8+iJBK5Uns/csXb4Ony5zym/7eGCRhIilBl5KT25eiDEgCmpYEgdDXi2WSyjFb9pGFEBCFJBWBahf2TCBMAoRLU0HcpAoh70I/eW0bht4cHoixIlLEirEsD3lhuXZUkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763101686; c=relaxed/simple;
	bh=lwKCFmpPatDt49rB785xvrfTHb17bbXMl8g/2KqS80s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UO3Mwy6I8yRhBWrSdoLUQ5a0UFcMIwNRbv6SriSL0qdLVS6bli42bmZN8MraJSbpcQ45Be8V6Di28o+IuPXT9y55pIs2leGJnALiVP5h4vB7NGal1ujdF5Rq+ummp/4Xu6ON+B4x02340N3iw6sukl6Cro/v8+jdPXfHE9OmRaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DhGQXd8f; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=MN6qJJquI6ksv20Gwx/qYUN1l6uKK9ZC9UPz03EXlgY=; b=DhGQXd8fc3GM0ABfY6H6EoPnxj
	okXGHQ83kf1DeB7jSyEAVCufv6nQSYfywSXZD4bSKaAgVsT+1zU53ENYOLigi93SPYoN9jrC5mBtn
	gUbZNMsvzHJ1CSKmfSNwrhDObvVNHnOa2DQYlKg6JYAsQM/XFKIFcUN2ffhBsB6tYT0lf9ymigd4o
	nWGajqeEadmUFmmCHRmJAoSt6qCfLTaEayr7WirjjzA9G4PtFWyjaa7FDQRUWc67S2IFgpJel3FtM
	qNh3DTiBZIj2PFd1qNs05hrOBeTF6Xhc9tApsxce0WUFzFz6eG3UmwQqPBveC0wkkuEOrZS6qd9+4
	X3dM8I0w==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJnHu-0000000BezH-2qvR;
	Fri, 14 Nov 2025 06:28:03 +0000
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
	gfs2@lists.linux.dev,
	io-uring@vger.kernel.org,
	devel@lists.orangefs.org,
	linux-unionfs@vger.kernel.org,
	linux-mtd@lists.infradead.org,
	linux-xfs@vger.kernel.org,
	linux-nfs@vger.kernel.org
Subject: [PATCH 10/14] fs: factor out a sync_lazytime helper
Date: Fri, 14 Nov 2025 07:26:13 +0100
Message-ID: <20251114062642.1524837-11-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251114062642.1524837-1-hch@lst.de>
References: <20251114062642.1524837-1-hch@lst.de>
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
---
 fs/fs-writeback.c                | 27 +++++++++++++++++----------
 fs/inode.c                       |  5 +----
 fs/internal.h                    |  3 ++-
 fs/sync.c                        |  4 ++--
 include/trace/events/writeback.h |  6 ------
 5 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 930697f39153..ae6d1f1ccc71 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1693,6 +1693,16 @@ static void requeue_inode(struct inode *inode, struct bdi_writeback *wb,
 	}
 }
 
+bool sync_lazytime(struct inode *inode)
+{
+	if (!(inode->i_state & I_DIRTY_TIME))
+		return false;
+
+	trace_writeback_lazytime(inode);
+	mark_inode_dirty_sync(inode);
+	return false;
+}
+
 /*
  * Write out an inode and its dirty pages (or some of its dirty pages, depending
  * on @wbc->nr_to_write), and clear the relevant dirty flags from i_state.
@@ -1732,17 +1742,14 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 	}
 
 	/*
-	 * If the inode has dirty timestamps and we need to write them, call
-	 * mark_inode_dirty_sync() to notify the filesystem about it and to
-	 * change I_DIRTY_TIME into I_DIRTY_SYNC.
+	 * For data integrity writeback, or when the dirty interval expired,
+	 * ask the file system to propagata lazy timestamp updates into real
+	 * dirty state.
 	 */
-	if ((inode->i_state & I_DIRTY_TIME) &&
-	    (wbc->sync_mode == WB_SYNC_ALL ||
-	     time_after(jiffies, inode->dirtied_time_when +
-			dirtytime_expire_interval * HZ))) {
-		trace_writeback_lazytime(inode);
-		mark_inode_dirty_sync(inode);
-	}
+	if (wbc->sync_mode == WB_SYNC_ALL ||
+	    time_after(jiffies, inode->dirtied_time_when +
+			dirtytime_expire_interval * HZ))
+		sync_lazytime(inode);
 
 	/*
 	 * Get and clear the dirty flags from i_state.  This needs to be done
diff --git a/fs/inode.c b/fs/inode.c
index 559ce5c07188..34d572c99313 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1942,11 +1942,8 @@ void iput(struct inode *inode)
 	if (atomic_add_unless(&inode->i_count, -1, 1))
 		return;
 
-	if ((inode->i_state & I_DIRTY_TIME) && inode->i_nlink) {
-		trace_writeback_lazytime_iput(inode);
-		mark_inode_dirty_sync(inode);
+	if (inode->i_nlink && sync_lazytime(inode))
 		goto retry;
-	}
 
 	spin_lock(&inode->i_lock);
 	if (unlikely((inode->i_state & I_DIRTY_TIME) && inode->i_nlink)) {
diff --git a/fs/internal.h b/fs/internal.h
index 9b2b4d116880..da6e62f1183f 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -211,7 +211,8 @@ bool in_group_or_capable(struct mnt_idmap *idmap,
 /*
  * fs-writeback.c
  */
-extern long get_nr_dirty_inodes(void);
+long get_nr_dirty_inodes(void);
+bool sync_lazytime(struct inode *inode);
 
 /*
  * dcache.c
diff --git a/fs/sync.c b/fs/sync.c
index 2955cd4c77a3..a86395e266b1 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -182,8 +182,8 @@ int vfs_fsync_range(struct file *file, loff_t start, loff_t end, int datasync)
 
 	if (!file->f_op->fsync)
 		return -EINVAL;
-	if (!datasync && (inode->i_state & I_DIRTY_TIME))
-		mark_inode_dirty_sync(inode);
+	if (!datasync)
+		sync_lazytime(inode);
 	return file->f_op->fsync(file, start, end, datasync);
 }
 EXPORT_SYMBOL(vfs_fsync_range);
diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index c08aff044e80..75eae86798ba 100644
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


