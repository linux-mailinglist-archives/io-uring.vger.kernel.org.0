Return-Path: <io-uring+bounces-11278-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DF795CD7896
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 01:39:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E03523026508
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 00:38:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 135CC213E89;
	Tue, 23 Dec 2025 00:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pZ0ciDUO"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39BF1F3B87;
	Tue, 23 Dec 2025 00:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766450293; cv=none; b=crR6aU6kTaERM1DdEH9p6N2BhvKI1pxEQmcibli+4tBh0hN5VicEJg1cPPDvuo2WMv7p+lUU9Okt/b2NwES04WjF8ED4/kOWa/aFfV6ZyKtWtrbcCoCr4c8DATF9C2R2gtoA1ZLpukRlNenCFCjwBjaySH2CNB8GsmokBgYcCSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766450293; c=relaxed/simple;
	bh=keSbMfJuBW+VHM09C5A7N5d+oqdWnQFd1ohFfEibiLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tz/pA8NBZNOufCgdr95P7LIdKAcPcCkKCiTYUegOA370YLcNpOOkAIz0Od0loSl15Lfpkg5hg5EcFK806zwG3i+u+kBK/zxtc9iNsFjL+DC6SDFnOaeQ63DYvQ7ImU4S+h9zoG3q7V+rveAtkVCeTIbMBFPn8cY9loDzn8AlJss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pZ0ciDUO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=cfl0c3UMWYvaS3yIRfRnWwNXeoGpAnKPWNurXZs5J68=; b=pZ0ciDUOsLlbGIuwGyhxPF0NDL
	NmaM5YzllRtl3js9oWwFFn07QqUfNBus/MQy6/q3NffHnUqvJqRz49lMXxStOqyHpsb3iPKo175N8
	35W5hnSFDpWCF8d+keCOSfL37t4wKIHQTOJlosMZgNTUcVnHQ0vAcAEuKywkpLyPZnZFRX4E8WFDQ
	0Mfwbr8ZvmEEKy/DT7P6odmdJdDAEWpFNhD2zcZnbLqqteXU3cMXgD6ydRzbG/Med1cN8+otrKaFF
	YfdFLKoI+uaVZLAThpRnpJ8FFb1VXUtlrv5Zfpt/q2MgouOvcY/AIzfejwuSt8a5FrDV2skapx4lz
	t3hxrkjQ==;
Received: from s58.ghokkaidofl2.vectant.ne.jp ([202.215.7.58] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vXqPg-0000000EIiz-3hD7;
	Tue, 23 Dec 2025 00:38:09 +0000
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
Subject: [PATCH 01/11] fs: remove inode_update_time
Date: Tue, 23 Dec 2025 09:37:44 +0900
Message-ID: <20251223003756.409543-2-hch@lst.de>
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


