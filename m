Return-Path: <io-uring+bounces-10685-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C5659C72688
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 07:53:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id 344A72A894
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 06:53:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E8C33019AD;
	Thu, 20 Nov 2025 06:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TBUENn5d"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2ADF26E16C;
	Thu, 20 Nov 2025 06:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763621430; cv=none; b=dv42gdI0WIC0SwDVdjIhAvHmZYXggWmeQh6dGYjA9P4ApC1TbXWVtL4y3tLcGgOm9C9eXLE9+iR+qyRiBtbwaCbMlLWPdYFLvHviQyQ/6Awpnqw8JTTtSRUNRDREKINX2wZIZ+yjYtEhBtL5TW//huFQ3sAwixtLH7TRrbqXDnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763621430; c=relaxed/simple;
	bh=euXPIXGXEjhjHg+V8O4D43k5cjckRWdz9UVYBhRYcao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ptllylz6dQpm8dE6PaKo8G4p4I6005ZF4LBajDhs8ApqeIXhspV14dO8lgA9DzjpDnnh0vdwRCuvkMAkw380vFy68BpiSjYN/WiMJnt6LKeMx6V2fW2LrWY6pmR3FFGmV2cAYeZ2ZfqZ6bqd9LHKiyrP+4hS8pbNJjvGD0s7e3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TBUENn5d; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=uqvGbopcI0FUMaYHiSMj2651zGHZwWSoiXglN220H3g=; b=TBUENn5dftht0HPxO7isoYHoOp
	PmalUNDfeG8EX3zsmTMha2vAsB+eQiGCu64laoRE5I4EHwFm+sb/rqHUar8PaISkUnMrr7I6TmJtf
	hJc3WlulUgmxgzgP1hAGU5+mBOrLVSIRvfjrMJ0q1IwEbGQ1J9c9+sB/O9TTOcpsdPhmu/Xw/JprW
	mIVJqBKkvo0jxlFfGa1yekZ6MrUKDC6diQjMtFteV+AuGOrnKtzSDBSGVgw0lypRo64iH2PEJi5IN
	MDTeHBSaL9vllzWBqJo9msZp2A1vXXSmk3PHj6u8WvQPnYD51igNWmGmOlo9CMmoGlp5f1Mo55BCe
	Mlt52GVQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLyUq-00000006F6J-16rS;
	Thu, 20 Nov 2025 06:50:26 +0000
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
	linux-nfs@vger.kernel.org,
	Chaitanya Kulkarni <kch@nvidia.com>
Subject: [PATCH 10/16] fs: factor out a mark_inode_dirty_time helper
Date: Thu, 20 Nov 2025 07:47:31 +0100
Message-ID: <20251120064859.2911749-11-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251120064859.2911749-1-hch@lst.de>
References: <20251120064859.2911749-1-hch@lst.de>
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
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
---
 fs/fs-writeback.c  | 16 ++++++++++++++++
 fs/inode.c         | 14 +++-----------
 include/linux/fs.h |  3 ++-
 3 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 2b35e80037fe..a115e26e0139 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -2671,6 +2671,22 @@ void __mark_inode_dirty(struct inode *inode, int flags)
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
+EXPORT_SYMBOL_GPL(mark_inode_dirty_time);
+
 /*
  * The @s_sync_lock is used to serialise concurrent sync operations
  * to avoid lock contention problems with concurrent wait_sb_inodes() calls.
diff --git a/fs/inode.c b/fs/inode.c
index cda78f76e1dd..edbc24a489ca 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2107,17 +2107,9 @@ EXPORT_SYMBOL(inode_update_timestamps);
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
index 4759aa61cb14..b4d82e5c6c32 100644
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


