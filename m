Return-Path: <io-uring+bounces-10624-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 23CE4C5B8DE
	for <lists+io-uring@lfdr.de>; Fri, 14 Nov 2025 07:33:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 6747535A80E
	for <lists+io-uring@lfdr.de>; Fri, 14 Nov 2025 06:30:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 362CE2FABE7;
	Fri, 14 Nov 2025 06:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vs2DPFyO"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0EC2F49EC;
	Fri, 14 Nov 2025 06:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763101678; cv=none; b=uMMrql9pSnAi5mqLI02u/0LSc7ZTyhmjConZpV4ddXIOJEebuT9MRh3Ast4g2JmKJ/IBspWfg0Qi35X8HUEpkIqfB/magRJBNWScBbbNHnYko6vn346f/MBId3NDAChXTTHnFh4uEcGtzMD8lj5FhCKUrMJ/is96reyb5QK0i0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763101678; c=relaxed/simple;
	bh=+HvY9Vkj5Oe1ULBa/Y9HAibjOeKAZD0xeFC1eXbpVc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GQYmEdWivXLxL9uXkGaqmbY+8abJijq3PnP38Sr0FAH+zoOVFuR3lr/iZEot85IWY/0xhb9My5Knxwth+GTC067D5Z6pv5Gk7G0lyVozrsFMvc3q7sxasdwfBOBJBJC3cfZ8DSMil51IVVCq0WTXBtO4GZEq9pgHW6cbGnVcrBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vs2DPFyO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Bcn3RFC5EgRaoKCXOU5FYMHOy+hI8yGoVE/EKUQ6dXM=; b=vs2DPFyOOdhQyetbPVdCsQRi1h
	hNYE1evOSN7xpx97m5VC6AKrR1qnAwphXnF5RzbVr5nCNko2trIhzDdZ+mrtt9hUxsiY4HlSqlDN6
	jTnAvgxreKdgyo3I0pNuI6ItvkY+e0VTE4YN02GzjGWoH1pXcVkcZW4BH0CqS/RFDBQtw3Ly841J+
	4HyDB9qX3/KNFqDuQi656ZUBkk0e9uDj+suOH8/F6XnWrMkIgCeo2SCyNQbx3/wzFsSxQtjCsw936
	mgT5t7qycfuYAsEblbNrIPbvu9JcMeT323CSO6GmT6vtmN49tZFsYITjA8AL6KYKE58NwZHPL32yF
	rDzD6YNw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJnHm-0000000BeuX-0LKR;
	Fri, 14 Nov 2025 06:27:54 +0000
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
Subject: [PATCH 09/14] fs: factor out a mark_inode_dirty_time helper
Date: Fri, 14 Nov 2025 07:26:12 +0100
Message-ID: <20251114062642.1524837-10-hch@lst.de>
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

Factor out the inode dirtying vs lazytime logic from generic_update_time
into a new helper so that it can be reused in file system methods.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/fs-writeback.c  | 15 +++++++++++++++
 fs/inode.c         | 14 +++-----------
 include/linux/fs.h |  3 ++-
 3 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 2b35e80037fe..930697f39153 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -2671,6 +2671,21 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 }
 EXPORT_SYMBOL(__mark_inode_dirty);
 
+void mark_inode_dirty_time(struct inode *inode, unsigned int flags)
+{
+	if (inode->i_sb->s_flags & SB_LAZYTIME) {
+		int dirty_flags = 0;
+
+		if (flags & (S_ATIME | S_MTIME | S_CTIME))
+			dirty_flags = I_DIRTY_TIME;
+		if (flags & S_VERSION)
+			dirty_flags |= I_DIRTY_SYNC;
+		__mark_inode_dirty(inode, dirty_flags);
+	} else {
+		mark_inode_dirty_sync(inode);
+	}
+}
+
 /*
  * The @s_sync_lock is used to serialise concurrent sync operations
  * to avoid lock contention problems with concurrent wait_sb_inodes() calls.
diff --git a/fs/inode.c b/fs/inode.c
index 57c458ee548d..559ce5c07188 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2095,17 +2095,9 @@ EXPORT_SYMBOL(inode_update_timestamps);
  */
 int generic_update_time(struct inode *inode, int flags)
 {
-	int updated = inode_update_timestamps(inode, flags);
-	int dirty_flags = 0;
-
-	if (!updated)
-		return 0;
-
-	if (updated & (S_ATIME|S_MTIME|S_CTIME))
-		dirty_flags = inode->i_sb->s_flags & SB_LAZYTIME ? I_DIRTY_TIME : I_DIRTY_SYNC;
-	if (updated & S_VERSION)
-		dirty_flags |= I_DIRTY_SYNC;
-	__mark_inode_dirty(inode, dirty_flags);
+	flags = inode_update_timestamps(inode, flags);
+	if (flags)
+		mark_inode_dirty_time(inode, flags);
 	return 0;
 }
 EXPORT_SYMBOL(generic_update_time);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c1077ae7c6b2..5c762d80b8a8 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2608,7 +2608,8 @@ static inline void kiocb_clone(struct kiocb *kiocb, struct kiocb *kiocb_src,
 	};
 }
 
-extern void __mark_inode_dirty(struct inode *, int);
+void mark_inode_dirty_time(struct inode *inode, unsigned int flags);
+void __mark_inode_dirty(struct inode *inode, int flags);
 static inline void mark_inode_dirty(struct inode *inode)
 {
 	__mark_inode_dirty(inode, I_DIRTY);
-- 
2.47.3


