Return-Path: <io-uring+bounces-11137-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 44143CC6330
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 07:16:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4362930EF59A
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 06:11:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB20A2D6E75;
	Wed, 17 Dec 2025 06:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mng6MAWU"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E9062D5C67;
	Wed, 17 Dec 2025 06:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765951858; cv=none; b=jLvQ7zueJIRdB+xYwDEGQP7MdVxqTFRRH5K/xSe0/8U4B5SuoT/hshs8SJyS4/SXkKrvLuYLj9Uxsr2wFVlMqIm0+0ddBPwL/izAhCvQ6mKzUWDf16wskB0Vdv/UGC7FcZum2ZG944ioWrPZg3nPMiEYOl3HbovcPVZo1A+ah6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765951858; c=relaxed/simple;
	bh=xfXtzFbqNNeJoirl33XtH3Oj2xzhQ+QXL77oe/dHP4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MPvSGFzLr2hvkMT+OlJlUfIvlS96kQQH/5OkHkjXmz17uZ/E/YJhf+oSllY5+iOPHKTaiChZlFTvNgtNVhLytawhOtjmGN6ss7oI5Ul42ptG1/Kdgze0z2ylLpaNeqy0OoalNLT4VfJSdeMFgr7hLNrNGYcAyYGzQzICrTCi8SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mng6MAWU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=MApkxChD2Tpa8buj/DaoQKMyOMZdThEbXhJrdqGVZrI=; b=mng6MAWUzi4lampELZ92o+JKc+
	ogx1XJA4Wj3RsBHmZyp4kgKLLDRS1sDjYUQMNthNjinWUmnfBk3PK1GalpLZL8pPTjRxDN6w+bNIq
	kQRwQ6on7edrwf3b70FhPYBvJGXzSbU99+pU1le0IRJ9Qw6AvNUYHxd6KDpOvBzMNEYQ8hCaHafpl
	hPfcwKfKPDyYlsTw7G8pD91N6SY1UH81u040iTWlLT7mcoRKU3+0ZQCcLM4OmPqocrgNx4M6QdQ7l
	40PPkoy7w6abWxHTlAJbaZshHhfakqLX5jPdv/GCA4uy1hofCuByRQwPdMKLrNYUEgkzb5Ap7DaJh
	7MeFUzyg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vVkkQ-00000006DYH-2pOM;
	Wed, 17 Dec 2025 06:10:55 +0000
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
Subject: [PATCH 04/10] fs: factor out a mark_inode_dirty_time helper
Date: Wed, 17 Dec 2025 07:09:37 +0100
Message-ID: <20251217061015.923954-5-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251217061015.923954-1-hch@lst.de>
References: <20251217061015.923954-1-hch@lst.de>
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
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
---
 fs/fs-writeback.c  | 16 ++++++++++++++++
 fs/inode.c         | 14 +++-----------
 include/linux/fs.h |  3 ++-
 3 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 6800886c4d10..7870c158e4a2 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -2692,6 +2692,22 @@ void __mark_inode_dirty(struct inode *inode, int flags)
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
index 876641a6e478..17ecb7bb5067 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2145,17 +2145,9 @@ EXPORT_SYMBOL(inode_update_timestamps);
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
index fccb0a38cb74..66d3d18cf4e3 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2189,7 +2189,8 @@ static inline void kiocb_clone(struct kiocb *kiocb, struct kiocb *kiocb_src,
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


