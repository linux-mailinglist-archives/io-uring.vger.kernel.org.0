Return-Path: <io-uring+bounces-10629-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 24F61C5B960
	for <lists+io-uring@lfdr.de>; Fri, 14 Nov 2025 07:39:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1EF084F5785
	for <lists+io-uring@lfdr.de>; Fri, 14 Nov 2025 06:32:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AAB63016F5;
	Fri, 14 Nov 2025 06:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wDjPg/Hn"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8967A2F25FA;
	Fri, 14 Nov 2025 06:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763101710; cv=none; b=r46qDz5RXhXJD6V3Fw8Saj7fgbJhbS/seFbvctPx00YrKWbx0DWWGm77F0HeCV327jtmrqBiDB0EBe8h5IcgXBhjFVYTRAB7BgnBgjs+MUOfbWACtIAXpYurfEOdbTl6O0n0x3w/4/SyQ7IiMsroQ0jiZghhVCXYWXx1v2xuukE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763101710; c=relaxed/simple;
	bh=Px//exW9w+i1Xyx0n/Gu2ivv2DKbOfMBeouZxCEIvg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ml1BggoMyumwRgwONzKZtibJsqmCW2f5255RTbTy0mW71DJ4voNhxj1IOZuhYO+KBw6qja46EolEstDGRZ7XQl+uhnUUG9J2rlMJKELhgDceL4C97VD9tT22qgP+x8i8juf+lglPiL9I+hQPiQzoA6YH6TllK1RlZKvAKxS11p0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wDjPg/Hn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=wLYiunlc4HRKn1/cO6G76qMYBolsg+5Lse9an4ctyXI=; b=wDjPg/HnYNzaiMxT8G9jB6lS4A
	7iN7sM3Ekdm2Y6UeAx6yBrOE/02uZVIC5ITdC+LD0180UwMMnX5hOq0PIibCShC3MMzISsNP9XXq6
	VZylP7Zr9IdEEkPqJBNzqX/e8IRX6CyNdJRAlwfilDk+O1L30SGJbpNZ3WGlPVeVhQieOv13EAZ/k
	VUUjjD4BEOG8AOlr18JvaUhH3mHzKKKw3eoxHGMP7KThMLN3jr6kT/+L6kecdQKPoZnsfsFrkCbJT
	roucWpCkQe22oqYGzMwe2fB9AIYqy7GRKQJ9FZgDpboo8q0DRVtmvkZdsmVTuF/7bcn4x82tnhNmH
	fUvOZNGQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJnIJ-0000000BfCq-0DHz;
	Fri, 14 Nov 2025 06:28:27 +0000
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
Subject: [PATCH 14/14] xfs: enable non-blocking timestamp updates
Date: Fri, 14 Nov 2025 07:26:17 +0100
Message-ID: <20251114062642.1524837-15-hch@lst.de>
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

The lazytime path using generic_update_time can never block in XFS
because there is no ->dirty_inode method that could block.  Allow
non-blocking timestamp updates for this case.

Fixes: 66fa3cedf16a ("fs: Add async write file modification handling.")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iops.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index bd0b7e81f6ab..3d7b89ffacde 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1195,9 +1195,6 @@ xfs_vn_update_time(
 
 	trace_xfs_update_time(ip);
 
-	if (flags & S_NOWAIT)
-		return -EAGAIN;
-
 	if (inode->i_sb->s_flags & SB_LAZYTIME) {
 		if (!((flags & S_VERSION) &&
 		      inode_maybe_inc_iversion(inode, false)))
@@ -1207,6 +1204,9 @@ xfs_vn_update_time(
 		log_flags |= XFS_ILOG_CORE;
 	}
 
+	if (flags & S_NOWAIT)
+		return -EAGAIN;
+
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_fsyncts, 0, 0, 0, &tp);
 	if (error)
 		return error;
-- 
2.47.3


