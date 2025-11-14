Return-Path: <io-uring+bounces-10620-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 89E30C5B8BB
	for <lists+io-uring@lfdr.de>; Fri, 14 Nov 2025 07:31:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 163A84F0561
	for <lists+io-uring@lfdr.de>; Fri, 14 Nov 2025 06:28:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FD522F290A;
	Fri, 14 Nov 2025 06:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZmoNinZl"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5FA62EBB84;
	Fri, 14 Nov 2025 06:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763101645; cv=none; b=l2k1+WmuO3aLSAB/7fZvivFmrzizJvAwBym67IY1yMwjBnqoHVIFMBXzWtdCbAx6cVV0WafMV9gC/Ie203ZJj/qF94josHq4lhqu3O2FLnQd3MknL1Ltz1iNSiSpntQkB9Zl0carDVEay2DMew0P9+tXmBvFP9RFxQjHmk1HYac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763101645; c=relaxed/simple;
	bh=t15qFWCq9irTgfjDDvoKBJbABaAY/CkNEet7MrAYI10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W5AGjYZaOwKfnSXR3WD0ZEekI7M45oEpWS35S8XVYrbccfQmCMlKvB3zEvYdCAlG3jWeCkt7GMi6A/qdKzWE6V43E4ltnVGPvuApa1rSPXKOx0ur5FzG3ZGdsQTHHggH3osJwmhtmDxV1FID4wJkRTGa+7/aQv8a5YVZZCDsSj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZmoNinZl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=IfhfPcSC5H0NO4Hie7VpjDmL7rxIihTNbd1xF+2YV4o=; b=ZmoNinZlVJAP5if+8+y0fb5bpG
	wRIj+KYls8MqNEFvIEcoBPajbL/ngXXPgEofhxtGOSVjGoyZnsm0ucF0Qkv0csuwtDR0wtimHtMUP
	OTYf1Fc1+X/AS2v5CNRbxc81y+01CwEPbyE2/9JA8+bj1J/ir0tlG51p1IW7J0ffewxXJ5+Xqo4wl
	rvyC1n9s4VrpephS3j1GCY/2h8vp2O79qFYIaJQeyCNBFrt61h4aux+B0mokuWTwccDRuye33qByZ
	JD4hVDiSLFmRABuO6BcqNydPP6gXE3Xa0X97P6RSxDtCYUpjptISH5wtAFwMc7vSOofpHbSTB54i9
	rvSHQvrw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJnHF-0000000BeZb-1hFt;
	Fri, 14 Nov 2025 06:27:21 +0000
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
Subject: [PATCH 05/14] fs: remove inode_update_time
Date: Fri, 14 Nov 2025 07:26:08 +0100
Message-ID: <20251114062642.1524837-6-hch@lst.de>
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

The only external user is gone now, open code it in the two VFS
callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/inode.c         | 23 ++++++++---------------
 include/linux/fs.h |  1 -
 2 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 24dab63844db..d3edcc5baec9 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2107,19 +2107,6 @@ int generic_update_time(struct inode *inode, int flags)
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
@@ -2187,7 +2174,10 @@ void touch_atime(const struct path *path)
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
@@ -2342,7 +2332,10 @@ static int file_update_time_flags(struct file *file, unsigned int flags)
 
 	if (mnt_get_write_access_file(file))
 		return 0;
-	ret = inode_update_time(inode, sync_mode);
+	if (inode->i_op->update_time)
+		ret = inode->i_op->update_time(inode, sync_mode);
+	else
+		generic_update_time(inode, sync_mode);
 	mnt_put_write_access_file(file);
 	return ret;
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c895146c1444..a09cebdb4881 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2665,7 +2665,6 @@ enum file_time_flags {
 
 extern bool atime_needs_update(const struct path *, struct inode *);
 extern void touch_atime(const struct path *);
-int inode_update_time(struct inode *inode, int flags);
 
 static inline void file_accessed(struct file *file)
 {
-- 
2.47.3


