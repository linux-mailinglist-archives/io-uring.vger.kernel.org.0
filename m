Return-Path: <io-uring+bounces-11288-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E5FF8CD7962
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 01:50:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 90976309A6DF
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 00:46:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E3232C11E9;
	Tue, 23 Dec 2025 00:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oXZJEA/h"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF49A2BE02A;
	Tue, 23 Dec 2025 00:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766450346; cv=none; b=qK8tkF6yNjVFSf0Bwv/y31+fzUvkEATk74BUy1gkp7S6YBGVEO0PRVxtIa9siYicF999UR6NpX55kqjFSlOEMjh4Et3L1oCd1yLC8s/CBtytYArUh+TdIIa9cCpwkYFsEk+LKlvL+i4MIA9YPIQETeYYA27aP4upUqeUdqT+vbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766450346; c=relaxed/simple;
	bh=IfaqT1FwkkPlvNK+9vGxPt7qaaBRmNYbdSrLiNl4lts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pa/lfHHeaNQsE4fOt7A5O5Ep6SkVC6NVRcRLKi+b15bjPCtLV0KH2+lxTsQDBsWIZ+3WA8WFYVNK9AlvFKF7FFqv5S/W1XtqYdl+SuOkBYGwRTAgEY3ac26x+8VXolsS9IlUl+uuc5w08WWGMnWZwgIgyHqfOgQmhBw2ClLAkaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oXZJEA/h; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Lz/gfojNOQEzMThjbhxxwMo5vvQbozdveVwLBNNNNnk=; b=oXZJEA/hdSIzf0iL/xwwzU2XeN
	y6JNAEkZaTdObxRLRp8qxhRgWk0aodtccieMOE9EVHp3l0zdFfDYvY5aVaRFmvTtwk/xnjdFnt0Dr
	zjpnn7bJ7AvJ+zwtZHUEOdLt24kYLHGabI/dgIwidLsTlkuX5yTFemkdjVxfVQTtoAoxbUyQim7vK
	TddAydZ471UHgfhGtmKLX2iBlJfdlF9+/hORm53QKBi5hYBYCdxZxzLw3FBpFlS/ur7NcR65Aj1xU
	EtzqFzaU91OeX+9ULM2Pn9lOE9IpAtNZZL/M4my9/GauNm+lzY79VeTweMsG++ZTZ8DmgCVwzKuYA
	KnTHZB7w==;
Received: from s58.ghokkaidofl2.vectant.ne.jp ([202.215.7.58] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vXqQY-0000000EJD0-2O8m;
	Tue, 23 Dec 2025 00:39:02 +0000
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
	linux-nfs@vger.kernel.org
Subject: [PATCH 11/11] xfs: enable non-blocking timestamp updates
Date: Tue, 23 Dec 2025 09:37:54 +0900
Message-ID: <20251223003756.409543-12-hch@lst.de>
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

The lazytime path using the generic helpers can never block in XFS
because there is no ->dirty_inode method that could block.  Allow
non-blocking timestamp updates for this case by replacing
generic_update_time with the open coded version without the S_NOWAIT
check.

Fixes: 66fa3cedf16a ("fs: Add async write file modification handling.")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
---
 fs/xfs/xfs_iops.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index e12c6e6d313e..1fba10281e54 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1195,16 +1195,23 @@ xfs_vn_update_time(
 
 	trace_xfs_update_time(ip);
 
-	if (flags & S_NOWAIT)
-		return -EAGAIN;
-
 	if (inode->i_sb->s_flags & SB_LAZYTIME) {
-		if (!((flags & S_VERSION) &&
-		      inode_maybe_inc_iversion(inode, false)))
-			return generic_update_time(inode, flags);
+		int dirty_flags;
+
+		error = inode_update_timestamps(inode,
+				flags | S_CAN_NOWAIT_LAZYTIME, &dirty_flags);
+		if (error)
+			return error;
+		if (dirty_flags == I_DIRTY_TIME) {
+			__mark_inode_dirty(inode, I_DIRTY_TIME);
+			return 0;
+		}
 
 		/* Capture the iversion update that just occurred */
 		log_flags |= XFS_ILOG_CORE;
+	} else {
+		if (flags & S_NOWAIT)
+			return -EAGAIN;
 	}
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_fsyncts, 0, 0, 0, &tp);
-- 
2.47.3


