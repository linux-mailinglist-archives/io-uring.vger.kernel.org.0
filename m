Return-Path: <io-uring+bounces-10691-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 761F6C7270F
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 07:57:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id 55EA52EFAC
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 06:56:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEC8C3126B2;
	Thu, 20 Nov 2025 06:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tQLUcQQJ"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ECF031159C;
	Thu, 20 Nov 2025 06:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763621472; cv=none; b=DNaJQ4ebdkv68Tx9CM4tHGm86IMuCri96inYXuWHuTkkuN7lnozgWryzogILyBZ4C+8wLDxZGeY5IYIc1swG86BEHNnd02JEQoR1fp4dLqzGPSf613S0NTccRYUS9+vB5RuymBvUtghzwoNCxLxbPc0GCNRSFsjgpD5ax20GQZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763621472; c=relaxed/simple;
	bh=Y6h8Q9TXFwbvRM0+hxO3tgazKBGlWeeY0ClCxxMFfTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RY5aW6Do6LoipSFWiZgciBYerYcPr3xQ1Gu2xz/6OXjxpupJXGJ0YNV55gDkCOgzGiDftAzWjTCK/oLqiJJN/js/jG9M/DBlgbqLQ07CU6jnLK7xpjj+37H76xi5zNYR+rl+mniPg8LAy2/Mq18ThiRkpJZr0rfL0RDMn6kHCJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tQLUcQQJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=jL8ppRPVG8qcJHhQmbp4DPmP8cn7AIsquXUk29wQop8=; b=tQLUcQQJ1W2RF4lwvz6c39SYoW
	oAVJQh8Jg1PWDnuBSdgzA6xSvjrv2cXDB8992dhK/Wo8j5pOz8hONM4DYjQC45rFUIxZ1uh+fS+wA
	6oz2QgsNVoK4mzrp+wqKNccVYRqqZZVhynU70WUxWXMp5EV8+bQLnE/UgEqU2cT1soIizuUeyHupI
	55y1T5Mw7+9ML1dowISKgG+mEfS/1b6kTxYWDGDliPfMO04S6cDZkBh3MGUjfcG2R+DJwN2lk76Rb
	WMZc0sa7XtI/cNZ0i+E/4UPmHBXsMIto+s0O0EnjNrFASI86ptYLRQe3vj2jF4qjXDKmyf1Si2/ii
	TUdIGUBw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLyVW-00000006FY3-4B3w;
	Thu, 20 Nov 2025 06:51:08 +0000
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
Subject: [PATCH 16/16] xfs: enable non-blocking timestamp updates
Date: Thu, 20 Nov 2025 07:47:37 +0100
Message-ID: <20251120064859.2911749-17-hch@lst.de>
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

The lazytime path using the generic helpers can never block in XFS
because there is no ->dirty_inode method that could block.  Allow
non-blocking timestamp updates for this case by replacing
generic_update_times with the open coded version without the S_NOWAIT
check.

Fixes: 66fa3cedf16a ("fs: Add async write file modification handling.")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iops.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index bd0b7e81f6ab..57ff05be5700 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1195,16 +1195,24 @@ xfs_vn_update_time(
 
 	trace_xfs_update_time(ip);
 
-	if (flags & S_NOWAIT)
-		return -EAGAIN;
-
 	if (inode->i_sb->s_flags & SB_LAZYTIME) {
-		if (!((flags & S_VERSION) &&
-		      inode_maybe_inc_iversion(inode, false)))
-			return generic_update_time(inode, flags);
+		int updated = flags;
+
+		error = inode_update_timestamps(inode, &updated);
+		if (error)
+			return error;
+
+		if (!(updated & S_VERSION)) {
+			if (updated)
+				mark_inode_dirty_time(inode, updated);
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


