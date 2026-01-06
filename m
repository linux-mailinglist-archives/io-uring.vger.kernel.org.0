Return-Path: <io-uring+bounces-11398-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9563ACF7394
	for <lists+io-uring@lfdr.de>; Tue, 06 Jan 2026 09:07:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 88F8C313DF2A
	for <lists+io-uring@lfdr.de>; Tue,  6 Jan 2026 08:01:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 280DA31A555;
	Tue,  6 Jan 2026 07:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pUXMUre+"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23C231690E;
	Tue,  6 Jan 2026 07:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767685909; cv=none; b=sUGYFRNeTPo2Gyr99lKszhCfrYxvnlG4jwsUDg/0pBYAIjnSOUML62CSG3elZRet3fiR0MEgtrrqM02Jotd68Li+l781NSZRoHXgIaJq5aQOD/1o0ixH7PrEaC/TvCfq6ifTr2hfwMqD0UfIAsA79hzaOHtaJOlRZtogrB81+Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767685909; c=relaxed/simple;
	bh=5tJepZdBm4NT9tyjBB7PXASujyH9KkjsFzRaJR+9pl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=icT/pcfQACxGbyfLLP2T4oKL5LlvpXm01GloVlYWNZJuX1CXFCUVLxg0OV5+LXpM8NRLwHWIlQKGxVlsA9drnNEsyEvI9BiAAtVdRv75A8TK/BoIyw3ZJpHOEnARTtVz4VWOXlL3PWLtNVXOGLqGW8TpVAnhH8yciNwwSPJLtkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pUXMUre+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=dwwZ/yOU7SW1prK7b5bp9EkEBz6f02bqYmxcFFUDJQk=; b=pUXMUre+va1hMaurQBYYxYpC2k
	rYG8u4bkxTFvhEFnoHLFeykvqhXP6Yp2xY4fcy/yhQsLFyZH/b9KkE8iQqLOM/0nAxtKdK+z6MwGk
	si1jmVCl+E4pVnWhDiMY4RncGeQK6MWk5TnL+AnQZ0Bneec37rbg3sucHbkEvNrOBEh8eq/n3Zrlr
	wMVpQhCOeGzHP4OIOaA8esWszhjpfN3ORQYBvpdIqw8jmeaw+ZRJbZmYgfJ0GVBkJaFDEn/J4eXnJ
	uTpL0JncHiet+46ot9BlT1cuPx/KOoF8PYAb+uE7zW/ZfCyd4bdBpD8zBwkLoE5ATYJC/hyv4b8RD
	ExDRWklw==;
Received: from [2001:4bb8:2af:87cb:5562:685f:c094:6513] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vd1qz-0000000CZDD-1dBW;
	Tue, 06 Jan 2026 07:51:45 +0000
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
Subject: [PATCH 11/11] xfs: enable non-blocking timestamp updates
Date: Tue,  6 Jan 2026 08:50:05 +0100
Message-ID: <20260106075008.1610195-12-hch@lst.de>
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

The lazytime path using the generic helpers can never block in XFS
because there is no ->dirty_inode method that could block.  Allow
non-blocking timestamp updates for this case by replacing
generic_update_time with the open coded version without the S_NOWAIT
check.

Fixes: 66fa3cedf16a ("fs: Add async write file modification handling.")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
---
 fs/xfs/xfs_iops.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 338f3113f674..1cdd8a360510 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1195,16 +1195,22 @@ xfs_vn_update_time(
 
 	trace_xfs_update_time(ip);
 
-	if (flags & IOCB_NOWAIT)
-		return -EAGAIN;
-
 	if (inode->i_sb->s_flags & SB_LAZYTIME) {
-		if (type == FS_UPD_ATIME ||
-		    !inode_maybe_inc_iversion(inode, false))
-			return generic_update_time(inode, type, flags);
+		int dirty;
+
+		dirty = inode_update_time(inode, type, flags);
+		if (dirty <= 0)
+			return dirty;
+		if (dirty == I_DIRTY_TIME) {
+			__mark_inode_dirty(inode, I_DIRTY_TIME);
+			return 0;
+		}
 
 		/* Capture the iversion update that just occurred */
 		log_flags |= XFS_ILOG_CORE;
+	} else {
+		if (flags & IOCB_NOWAIT)
+			return -EAGAIN;
 	}
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_fsyncts, 0, 0, 0, &tp);
-- 
2.47.3


