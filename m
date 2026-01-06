Return-Path: <io-uring+bounces-11396-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 154B7CF739D
	for <lists+io-uring@lfdr.de>; Tue, 06 Jan 2026 09:07:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 93C303141C2B
	for <lists+io-uring@lfdr.de>; Tue,  6 Jan 2026 08:02:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15E55315D28;
	Tue,  6 Jan 2026 07:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rEjd772H"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B20230C35D;
	Tue,  6 Jan 2026 07:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767685896; cv=none; b=BPYlB708K+hfDW1XMnhrb7fdcgoqJY0kqdwpUwalweGKV4ldb/ke6E0jqnj4XWDDDXCXTpQ0D6WNUIdkpOxsPi7tXh6jBKwegMkVu1NYZh9lKpu/WMms8nvPnj4RYrZJnnxMd/Cz2EzVOdzXGHLIGIBO+dlnNtMb4x1yVe/ZzYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767685896; c=relaxed/simple;
	bh=EQt9QL3VEk68xKZzN1AqegifQfcO68LqNc1scbjpnFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qiHSvbg0sgSaeQrSeZZvyQppTLx006RYubBZFiE/Xfiqs5v5zGdK+/ciqbr+e+WZICDkYk1Ib7A2fsCYWVGLygijp6bDwVnJeu8PHTacxJwgqlLIBaSlii9ryNXodwyzY9vAI9DiY1RcmpM0TbghbyYGc1ITycntahTIOAzd1Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rEjd772H; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=r43mKSP3ZIwowd6KM3hrEay9XvhP30KhnhDuCR1AB4I=; b=rEjd772HRDV5L+IaBKvSsg8epd
	euVapp5lNNryq3JSEQRH9cqb6SzRUFRg0jMLB3QUdXAvw8+yve+xdey5xUjRVKwJB6hV+FgT8x8FA
	u2pqL01I/L1p7kgIhZuFAMorggtSBUiZi74gnQrCsD4mctyiaZfAGrX7ewRL8tY6rBYH4E+kvI9VT
	dMMiSLpwXAhSLyK+anzW1rLTeYyUPC4fBJUtyJbV6F9RfIEM3t3Q2anl2IqBpHBtq729yYfC1/Q2O
	Vk8TMkho+svzKSNqB6bxPR7fw8leY/CV9KSRA0Z59g4eaEWIaJa/UZINAMVzOqRV7/NRK/adPYIJy
	g/qN4WAw==;
Received: from [2001:4bb8:2af:87cb:5562:685f:c094:6513] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vd1ql-0000000CZ5u-3DNg;
	Tue, 06 Jan 2026 07:51:32 +0000
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
Date: Tue,  6 Jan 2026 08:50:03 +0100
Message-ID: <20260106075008.1610195-10-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260106075008.1610195-1-hch@lst.de>
References: <20260106075008.1610195-1-hch@lst.de>
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
---
 fs/inode.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 01e4f6b9b46e..d2bfe302e647 100644
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


