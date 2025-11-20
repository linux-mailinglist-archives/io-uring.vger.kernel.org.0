Return-Path: <io-uring+bounces-10690-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9748CC726E8
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 07:56:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id 539162F6E1
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 06:56:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25A6930FC3A;
	Thu, 20 Nov 2025 06:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WmIfMXFh"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768A9304BBD;
	Thu, 20 Nov 2025 06:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763621471; cv=none; b=qO/qagTHAy8kuej4A2xv/HRdPA4duDtoPZsO1Fqg+8iEabJjLOaBrSPzdU6NCkPf3LIP5Bv/7Uj71ECrys2OFydMaTQXLsD15LbhtXI00+lCIQYR2c6rh0gBcbHiINRfBZUikIkyiFZMeeJPltn2M/lcohjdIwnKhj5RauA8uNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763621471; c=relaxed/simple;
	bh=19q68EHogM82UeTMNBDGn2F5Gwkf2Vw3G0103YH6Ba0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JexP75QTOM57hXhqbc4YRA2kqJA42BZvUoHvmeNS4h8adbgLKonMBAkz0bqbF61hln6kIW6Ti33cxI0Wwzj++e/IoCAD1BU2A/zrzMpa8BF8j+cYrm1EHDrcmQuiaj0zHQT3Ifa+KNOa2/kcGJZ2/SztDfEW2H9GJ9rkZOmvbZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WmIfMXFh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Xdr8t0pgQn0fMenmTNQClFxCV0ZWOGY6pkY70dZOg1o=; b=WmIfMXFhola4G+Kju5ErWy0+GS
	gu5vDUvxmMn/+DDFHlxoTP3k6FzNwIH9ad4v1y821idJQKlxc2hAQS8QWJej318+HFV3ftJIsiNu/
	6JcuXaEF3jvvgTgBNRjoBzK8QYKE9l14J6FoiMdt94iJ91R7u/byDAwR361UgwvDKzBuvYPtZ7fhz
	iJMFPUuJurHQ1yMjmGMI0JlzsPkqLIeDEzOOpaI6Sh1vbukoj8Ozfrki73/mMOdudyHq8NJpM22HO
	AatsTEXPEtbGzzHeyQy5pPqDzBNwnjGsJbVItJUTjaGIPa2ao206zUbah6i3kg054xOtlJFSzNcFS
	JnuMIeFg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLyVO-00000006FSk-3XdL;
	Thu, 20 Nov 2025 06:50:59 +0000
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
Subject: [PATCH 15/16] xfs: implement ->sync_lazytime
Date: Thu, 20 Nov 2025 07:47:36 +0100
Message-ID: <20251120064859.2911749-16-hch@lst.de>
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

Switch to the new explicit lazytime syncing method instead of trying
to second guess what could be a lazytime update in ->dirty_inode.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
---
 fs/xfs/xfs_iops.c  | 20 ++++++++++++++++++++
 fs/xfs/xfs_super.c | 29 -----------------------------
 2 files changed, 20 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index da055dade25f..bd0b7e81f6ab 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1227,6 +1227,22 @@ xfs_vn_update_time(
 	return xfs_trans_commit(tp);
 }
 
+static void
+xfs_vn_sync_lazytime(
+	struct inode		*inode)
+{
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
+
+	if (xfs_trans_alloc(mp, &M_RES(mp)->tr_fsyncts, 0, 0, 0, &tp))
+		return;
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_TIMESTAMP);
+	xfs_trans_commit(tp);
+}
+
 STATIC int
 xfs_vn_fiemap(
 	struct inode		*inode,
@@ -1270,6 +1286,7 @@ static const struct inode_operations xfs_inode_operations = {
 	.listxattr		= xfs_vn_listxattr,
 	.fiemap			= xfs_vn_fiemap,
 	.update_time		= xfs_vn_update_time,
+	.sync_lazytime		= xfs_vn_sync_lazytime,
 	.fileattr_get		= xfs_fileattr_get,
 	.fileattr_set		= xfs_fileattr_set,
 };
@@ -1296,6 +1313,7 @@ static const struct inode_operations xfs_dir_inode_operations = {
 	.setattr		= xfs_vn_setattr,
 	.listxattr		= xfs_vn_listxattr,
 	.update_time		= xfs_vn_update_time,
+	.sync_lazytime		= xfs_vn_sync_lazytime,
 	.tmpfile		= xfs_vn_tmpfile,
 	.fileattr_get		= xfs_fileattr_get,
 	.fileattr_set		= xfs_fileattr_set,
@@ -1323,6 +1341,7 @@ static const struct inode_operations xfs_dir_ci_inode_operations = {
 	.setattr		= xfs_vn_setattr,
 	.listxattr		= xfs_vn_listxattr,
 	.update_time		= xfs_vn_update_time,
+	.sync_lazytime		= xfs_vn_sync_lazytime,
 	.tmpfile		= xfs_vn_tmpfile,
 	.fileattr_get		= xfs_fileattr_get,
 	.fileattr_set		= xfs_fileattr_set,
@@ -1334,6 +1353,7 @@ static const struct inode_operations xfs_symlink_inode_operations = {
 	.setattr		= xfs_vn_setattr,
 	.listxattr		= xfs_vn_listxattr,
 	.update_time		= xfs_vn_update_time,
+	.sync_lazytime		= xfs_vn_sync_lazytime,
 	.fileattr_get		= xfs_fileattr_get,
 	.fileattr_set		= xfs_fileattr_set,
 };
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index bc71aa9dcee8..094f257eff15 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -712,34 +712,6 @@ xfs_fs_destroy_inode(
 	xfs_inode_mark_reclaimable(ip);
 }
 
-static void
-xfs_fs_dirty_inode(
-	struct inode			*inode,
-	int				flags)
-{
-	struct xfs_inode		*ip = XFS_I(inode);
-	struct xfs_mount		*mp = ip->i_mount;
-	struct xfs_trans		*tp;
-
-	if (!(inode->i_sb->s_flags & SB_LAZYTIME))
-		return;
-
-	/*
-	 * Only do the timestamp update if the inode is dirty (I_DIRTY_SYNC)
-	 * and has dirty timestamp (I_DIRTY_TIME). I_DIRTY_TIME can be passed
-	 * in flags possibly together with I_DIRTY_SYNC.
-	 */
-	if ((flags & ~I_DIRTY_TIME) != I_DIRTY_SYNC || !(flags & I_DIRTY_TIME))
-		return;
-
-	if (xfs_trans_alloc(mp, &M_RES(mp)->tr_fsyncts, 0, 0, 0, &tp))
-		return;
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_TIMESTAMP);
-	xfs_trans_commit(tp);
-}
-
 /*
  * Slab object creation initialisation for the XFS inode.
  * This covers only the idempotent fields in the XFS inode;
@@ -1304,7 +1276,6 @@ xfs_fs_show_stats(
 static const struct super_operations xfs_super_operations = {
 	.alloc_inode		= xfs_fs_alloc_inode,
 	.destroy_inode		= xfs_fs_destroy_inode,
-	.dirty_inode		= xfs_fs_dirty_inode,
 	.drop_inode		= xfs_fs_drop_inode,
 	.evict_inode		= xfs_fs_evict_inode,
 	.put_super		= xfs_fs_put_super,
-- 
2.47.3


