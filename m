Return-Path: <io-uring+bounces-11383-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9135CCF71BA
	for <lists+io-uring@lfdr.de>; Tue, 06 Jan 2026 08:46:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 412FF301CD0E
	for <lists+io-uring@lfdr.de>; Tue,  6 Jan 2026 07:46:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29FA430AAD6;
	Tue,  6 Jan 2026 07:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CrCEOyhF"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A41A72E65D;
	Tue,  6 Jan 2026 07:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767685607; cv=none; b=eFrUfVQffImGrnC6MbS+DUigg843baoAtJNRQLbkK+QrM3LXcL/MqC4ipxruGG6kMu1ambYbiee5GmHmYcaSFED7Yw9hO5v6mUaAlTHs1suoyagb8d45E4DqSZ0eoQ8n2EeLdphjyuJdv3Dwkkb8W8mrF/y1ie7IpPvR/EMa8Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767685607; c=relaxed/simple;
	bh=keSbMfJuBW+VHM09C5A7N5d+oqdWnQFd1ohFfEibiLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SjEToZHR7g0zyJRMWiMs3maFT4TPYCSgfRPnb4CpkKPnwppFP1qV3UHjo1gTI53vNjI+5CkfnDJAKelQxyYrjQDSX1fJjD3fKeiTcn6pBFJ/ds2cE/zbJ0fBLtBD+0vcsrIHPgE0TauOSLN6vA5oum4mtvLCIo3aA/17/06QEJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CrCEOyhF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=cfl0c3UMWYvaS3yIRfRnWwNXeoGpAnKPWNurXZs5J68=; b=CrCEOyhFrDxokAgA0uiciNNm3I
	6GD+CASFp8lfydIyA77LGNilM+fwpRHCbphxCXN7VtEAKcDLDGelzAX410PpsQ8nFdGvDB9tKWJxO
	u3zsTo8bMuoHodx8lciw4zy7IGi+2/N72oKRL1Cto/eyK2oa6QLYr0iDvTiK2nCgHsDXGngHfw0Ho
	AGw/rvi1tu3tYwEh9yQ91E2jao/4G9vejQSjUO7BUlH8SNFKchaZb4Hx2mW81uNw4IJ0W2TNkvk/P
	Gx9InNDQvl+AR+3ZAgcWPgwGKDBv1Zbk6/Q0TJ2axspyz4eNQKkPud20MayLGZqxw2hJ9+NXYL5Ol
	85y2Y5lQ==;
Received: from [213.208.157.59] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vd1m6-0000000CXot-1cQS;
	Tue, 06 Jan 2026 07:46:42 +0000
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
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
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
Subject: [PATCH 01/11] fs: remove inode_update_time
Date: Tue,  6 Jan 2026 08:44:55 +0100
Message-ID: <20260106074628.1609575-2-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260106074628.1609575-1-hch@lst.de>
References: <20260106074628.1609575-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The only external user is gone now, open code it in the two VFS
callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
---
 fs/inode.c         | 23 ++++++++---------------
 include/linux/fs.h |  1 -
 2 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 521383223d8a..07effa0cb999 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2157,19 +2157,6 @@ int generic_update_time(struct inode *inode, int flags)
 }
 EXPORT_SYMBOL(generic_update_time);
 
-/*
- * This does the actual work of updating an inodes time or version.  Must have
- * had called mnt_want_write() before calling this.
- */
-int inode_update_time(struct inode *inode, int flags)
-{
-	if (inode->i_op->update_time)
-		return inode->i_op->update_time(inode, flags);
-	generic_update_time(inode, flags);
-	return 0;
-}
-EXPORT_SYMBOL(inode_update_time);
-
 /**
  *	atime_needs_update	-	update the access time
  *	@path: the &struct path to update
@@ -2237,7 +2224,10 @@ void touch_atime(const struct path *path)
 	 * We may also fail on filesystems that have the ability to make parts
 	 * of the fs read only, e.g. subvolumes in Btrfs.
 	 */
-	inode_update_time(inode, S_ATIME);
+	if (inode->i_op->update_time)
+		inode->i_op->update_time(inode, S_ATIME);
+	else
+		generic_update_time(inode, S_ATIME);
 	mnt_put_write_access(mnt);
 skip_update:
 	sb_end_write(inode->i_sb);
@@ -2392,7 +2382,10 @@ static int file_update_time_flags(struct file *file, unsigned int flags)
 
 	if (mnt_get_write_access_file(file))
 		return 0;
-	ret = inode_update_time(inode, sync_mode);
+	if (inode->i_op->update_time)
+		ret = inode->i_op->update_time(inode, sync_mode);
+	else
+		ret = generic_update_time(inode, sync_mode);
 	mnt_put_write_access_file(file);
 	return ret;
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f5c9cf28c4dc..ee623c16d835 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2246,7 +2246,6 @@ enum file_time_flags {
 
 extern bool atime_needs_update(const struct path *, struct inode *);
 extern void touch_atime(const struct path *);
-int inode_update_time(struct inode *inode, int flags);
 
 static inline void file_accessed(struct file *file)
 {
-- 
2.47.3


