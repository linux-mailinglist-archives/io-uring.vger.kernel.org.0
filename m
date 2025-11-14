Return-Path: <io-uring+bounces-10616-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 189E7C5B855
	for <lists+io-uring@lfdr.de>; Fri, 14 Nov 2025 07:28:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id F35FD34CFA9
	for <lists+io-uring@lfdr.de>; Fri, 14 Nov 2025 06:27:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8E242F2916;
	Fri, 14 Nov 2025 06:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Hwyyt42O"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4892F261F;
	Fri, 14 Nov 2025 06:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763101618; cv=none; b=ggnc+yTKSK9EmMHl7oU2PkS8VdxIvOmUvaB8BZxzmJs0pIBvBp1CdqYvCFWshyU0/nYYgzqPrlAv56CgSk/xV5/tl2asjTTGUuaIXHwA5s5r5R8U4aY0ysPeKmvQkaXkT2IX0BQolJ6BOrDudriwMB6LOEgr1wkxF8ydYWVG0qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763101618; c=relaxed/simple;
	bh=ekg0XYpGbInXbJk6is1Th2M0Fp3iELHNcCfrbrWC5lM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zh8sL1HPCVuTrU6a8h+VyWo/5kaI0s71MXlCo5RtMgGmwnOEb+6qD6crJ+gNVhdtsuBSbPEM+WVEyXMVnp9KR5N1R+J3f3yk61lLLwjWpptF7x1Iet9wf1jWCMXoJsvKiFqocIlj4ZOvOQzA4ZNe02XgEfrq/5UGQv1A+KQh6h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Hwyyt42O; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=xpbkortMlOM/LbuSWGrf+KVQmqeGEArI2P7ASCSc+zk=; b=Hwyyt42OZZWYUapS/buUriFDrj
	qsf+BpApDzvv7nLO/q2SwIa3jlx71qfNikcY3i7HgU1WN7Szrsmdpoxw4fM/Dv5TqIuNCTA41DyaV
	W8p8jg1A4LjtnHW0EnLOw3Y+aS3RtCQwMUSl1HtBhlsT/GhQLDlMpfuQoVNr7aKOS0m0mOGR4Ym8L
	U/F6dOEbEtQ5FtTOz9oLxCePzrtSBaEqW4ZbbpBdmA1RtaHyQjkb+X6DQ7OS4tQ+stjvHFAWld7wA
	Wewyzo6e0alDl0iSW3YX4c7VBS5UgCreZjzU0kQmSY+Cjeoh9+HZ80fafzNBZtIvMJ/RKRdW4L9LC
	I5zknjoA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJnGn-0000000BeQ9-1uwk;
	Fri, 14 Nov 2025 06:26:53 +0000
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
Subject: [PATCH 01/14] fs: refactor file timestamp update logic
Date: Fri, 14 Nov 2025 07:26:04 +0100
Message-ID: <20251114062642.1524837-2-hch@lst.de>
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

Currently the two high-level APIs use two helper functions to implement
almost all of the logic.  Refactor the two helpers and the common logic
into a new file_update_time_flags routine that gets the iocb flags or
0 in case of file_update_time passed so that the entire logic is
contained in a single function and can be easily understood and modified.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/inode.c | 54 +++++++++++++++++-------------------------------------
 1 file changed, 17 insertions(+), 37 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index ec9339024ac3..4884ffa931e7 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2310,10 +2310,12 @@ struct timespec64 current_time(struct inode *inode)
 }
 EXPORT_SYMBOL(current_time);
 
-static int inode_needs_update_time(struct inode *inode)
+static int file_update_time_flags(struct file *file, unsigned int flags)
 {
+	struct inode *inode = file_inode(file);
 	struct timespec64 now, ts;
-	int sync_it = 0;
+	int sync_mode = 0;
+	int ret = 0;
 
 	/* First try to exhaust all avenues to not sync */
 	if (IS_NOCMTIME(inode))
@@ -2323,29 +2325,23 @@ static int inode_needs_update_time(struct inode *inode)
 
 	ts = inode_get_mtime(inode);
 	if (!timespec64_equal(&ts, &now))
-		sync_it |= S_MTIME;
-
+		sync_mode |= S_MTIME;
 	ts = inode_get_ctime(inode);
 	if (!timespec64_equal(&ts, &now))
-		sync_it |= S_CTIME;
-
+		sync_mode |= S_CTIME;
 	if (IS_I_VERSION(inode) && inode_iversion_need_inc(inode))
-		sync_it |= S_VERSION;
+		sync_mode |= S_VERSION;
 
-	return sync_it;
-}
-
-static int __file_update_time(struct file *file, int sync_mode)
-{
-	int ret = 0;
-	struct inode *inode = file_inode(file);
+	if (!sync_mode)
+		return 0;
 
-	/* try to update time settings */
-	if (!mnt_get_write_access_file(file)) {
-		ret = inode_update_time(inode, sync_mode);
-		mnt_put_write_access_file(file);
-	}
+	if (flags & IOCB_NOWAIT)
+		return -EAGAIN;
 
+	if (mnt_get_write_access_file(file))
+		return 0;
+	ret = inode_update_time(inode, sync_mode);
+	mnt_put_write_access_file(file);
 	return ret;
 }
 
@@ -2365,14 +2361,7 @@ static int __file_update_time(struct file *file, int sync_mode)
  */
 int file_update_time(struct file *file)
 {
-	int ret;
-	struct inode *inode = file_inode(file);
-
-	ret = inode_needs_update_time(inode);
-	if (ret <= 0)
-		return ret;
-
-	return __file_update_time(file, ret);
+	return file_update_time_flags(file, 0);
 }
 EXPORT_SYMBOL(file_update_time);
 
@@ -2394,7 +2383,6 @@ EXPORT_SYMBOL(file_update_time);
 static int file_modified_flags(struct file *file, int flags)
 {
 	int ret;
-	struct inode *inode = file_inode(file);
 
 	/*
 	 * Clear the security bits if the process is not being run by root.
@@ -2403,17 +2391,9 @@ static int file_modified_flags(struct file *file, int flags)
 	ret = file_remove_privs_flags(file, flags);
 	if (ret)
 		return ret;
-
 	if (unlikely(file->f_mode & FMODE_NOCMTIME))
 		return 0;
-
-	ret = inode_needs_update_time(inode);
-	if (ret <= 0)
-		return ret;
-	if (flags & IOCB_NOWAIT)
-		return -EAGAIN;
-
-	return __file_update_time(file, ret);
+	return file_update_time_flags(file, flags);
 }
 
 /**
-- 
2.47.3


