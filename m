Return-Path: <io-uring+bounces-11143-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D8609CC639D
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 07:22:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8E63930BA4C7
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 06:18:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4BCF2E11DC;
	Wed, 17 Dec 2025 06:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fukiHv2S"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BDCA2D7D59;
	Wed, 17 Dec 2025 06:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765951906; cv=none; b=JqIupl4UAipgLq5sk9iz4skLjQwhhlVe5JQKryH48JwLXghDD2LtCApYWL2GofgXoug63v47d4ZtkzQd2Mme0iWkDev2qi5DBTEZzsUrCu687pxb1iZc4z9iRoF9ZsX0foybRpEa5SFB/EYHZv55byHomx3DgmA3VAvr6j6r8NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765951906; c=relaxed/simple;
	bh=SrA7qsD1ZHCG6NpygoKeYJhfW6+gPDS881cuKnQ9DtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gugJ7gmGeVclnv+3eFYRtVu8J22OsaHtX+0bhqti7ibvUpnZExmA6BVRkPX7tWoItOgxGOsVlIIFpEZltnKe3/HE46HQ9dv75w1xQFNiTNVlxCyikbu9XPkumDJbRAxyBsVPjyFsERWFgEXZrl2/f8GhicJCm244Ts1u5NjqO1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fukiHv2S; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=k3MKL94CqBOtbHrV9HTrqEtgonR+Dmw6W5Z34uX7xSQ=; b=fukiHv2Sx7+LWvTgtx6FV6JF/L
	lDw11PwhtR12JQZZn6hFFhedENF10/NlrWisUiJBbF2Ry2j7SVDWcmYgoSNgtfRYUdIkRpHHVLtOd
	+9KsBGMXBVLMN7wOMD70KN2ZmoYfdi/k8Mdve6k0/RDxVpEVfKpEmqJgu+DwPs+G1YmHX2EJBZ3OY
	zUi8RMoiMPEblNMX2k22DTa1oC1f6Hi/SprYgFZFCmIW9dj0f06gTvDdCVfzoNS0vUGYyvuWY3hQ/
	DIamRgfunUBt3ovzB3etmj8CK9H50D8pTvpb8JBN1dQYGsP9pl44oj0XWLi55M0jFn0tSdWD5ZLbW
	pH5C86kQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vVklD-00000006E7T-1Ptj;
	Wed, 17 Dec 2025 06:11:43 +0000
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
Subject: [PATCH 10/10] xfs: enable non-blocking timestamp updates
Date: Wed, 17 Dec 2025 07:09:43 +0100
Message-ID: <20251217061015.923954-11-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251217061015.923954-1-hch@lst.de>
References: <20251217061015.923954-1-hch@lst.de>
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
Reviewed-by: Jeff Layton <jlayton@kernel.org>
---
 fs/xfs/xfs_iops.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index e12c6e6d313e..7b6aa438cebc 100644
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


