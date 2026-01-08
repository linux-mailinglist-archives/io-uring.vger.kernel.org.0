Return-Path: <io-uring+bounces-11524-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 41EA0D035FF
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 15:35:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 523CA301996D
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 14:35:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 454835022D1;
	Thu,  8 Jan 2026 14:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="O4GGMH2m"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97865022C0;
	Thu,  8 Jan 2026 14:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767882089; cv=none; b=TTCAonaekT+lQGahyKIR8UiZofKXoHb2rJrqrTZgDf7hIieuCZ3Mk+sl0b+fsRx076Qm6gElQuMXCY3sAUongN7jiTVYJgrihooI02FeMvMJ/zOk75mjXss9jf+V1dCLoP3J+iKJyxFs9RNuNlaCksQghZs8HVa3ZwTDYcF6M8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767882089; c=relaxed/simple;
	bh=QVO6GIAI5bef2rjBSslHDnVXYfGzPjXnXi2n76hCKdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CIhsUgozgJaUgk+psd4CmFFSW/2P+BRbIyk/dtzuMHx/mlg9PSMjOX7OiZjnyolxyKiUgnDroWtRDXYNJVT/UkH/LYAsefksgNTCRW9Wn3S/ZT5FMZYBDBwsVIm9J3Ca48ClgC28StnH2v6B3LUJbZf42223r+E/3hV3mJzPpg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=O4GGMH2m; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=MgeJN1HYsWBItquTZTAptgj5CPWaMeoDf4FQODjPsNk=; b=O4GGMH2msXZSuzWTSD8xBPbXql
	77JVCrKrDNorWjwLIkPK7G/+6Tro99XwsfON1eTsADGZRoOBmviZCGdYMqZWh8OfFsD7OjvpqnY4c
	2WhJr1kp0M73XR93ytS7zcSXR1V78XYSdE/YmtSRaknkOpootiQS+/V5+Z1XhmXWZhsdsK4cjjfv/
	r96/ERAZ8up+jIolwdmOKaVrIQze3Tz84v2N708ppfr5C+tfCAqnN+VRU3GbQHuzJILbLkShCZYtV
	YiYEip7+PefLnVYqMX8HKMcH5rzpu8gzaNrrY5HG2/IilPgD7TXT1P9oJ2a0kTvND8xUn84xixvS2
	GT3oeIGg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vdqtA-0000000HJu3-2paW;
	Thu, 08 Jan 2026 14:21:25 +0000
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
	linux-nfs@vger.kernel.org
Subject: [PATCH 09/11] fs: refactor file_update_time_flags
Date: Thu,  8 Jan 2026 15:19:09 +0100
Message-ID: <20260108141934.2052404-10-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260108141934.2052404-1-hch@lst.de>
References: <20260108141934.2052404-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Split all the inode timestamp flags into a helper.  This not only
makes the code a bit more readable, but also optimizes away the
further checks as soon as know we need an update.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
---
 fs/inode.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index cd3ca98e8355..5913e1993e4a 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2378,31 +2378,30 @@ struct timespec64 current_time(struct inode *inode)
 }
 EXPORT_SYMBOL(current_time);
 
+static inline bool need_cmtime_update(struct inode *inode)
+{
+	struct timespec64 now = current_time(inode), ts;
+
+	ts = inode_get_mtime(inode);
+	if (!timespec64_equal(&ts, &now))
+		return true;
+	ts = inode_get_ctime(inode);
+	if (!timespec64_equal(&ts, &now))
+		return true;
+	return IS_I_VERSION(inode) && inode_iversion_need_inc(inode);
+}
+
 static int file_update_time_flags(struct file *file, unsigned int flags)
 {
 	struct inode *inode = file_inode(file);
-	struct timespec64 now, ts;
-	bool need_update = false;
-	int ret = 0;
+	int ret;
 
 	/* First try to exhaust all avenues to not sync */
 	if (IS_NOCMTIME(inode))
 		return 0;
 	if (unlikely(file->f_mode & FMODE_NOCMTIME))
 		return 0;
-
-	now = current_time(inode);
-
-	ts = inode_get_mtime(inode);
-	if (!timespec64_equal(&ts, &now))
-		need_update = true;
-	ts = inode_get_ctime(inode);
-	if (!timespec64_equal(&ts, &now))
-		need_update = true;
-	if (IS_I_VERSION(inode) && inode_iversion_need_inc(inode))
-		need_update = true;
-
-	if (!need_update)
+	if (!need_cmtime_update(inode))
 		return 0;
 
 	flags &= IOCB_NOWAIT;
-- 
2.47.3


