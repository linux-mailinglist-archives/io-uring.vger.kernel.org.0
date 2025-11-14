Return-Path: <io-uring+bounces-10623-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 78D55C5B8D6
	for <lists+io-uring@lfdr.de>; Fri, 14 Nov 2025 07:32:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 42CAA350A7B
	for <lists+io-uring@lfdr.de>; Fri, 14 Nov 2025 06:29:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFA1F2F3C0A;
	Fri, 14 Nov 2025 06:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GXV7ebn9"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5492EB84E;
	Fri, 14 Nov 2025 06:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763101670; cv=none; b=p0EQZEAfA8rPbY4ZGR54YuwsTg+bYqkwWHRvJ3IKoluXvQxfaq2H5gxqBnApdEEDyxr+FaUHYC1N5Vg0vgb3C8hWORrcjNZXiCsfBBESJHAPsvQkVBbcfo1GRwBPQcpV+LEqsh3hVi1v8yEgBd24E9Dlfaqh9p6oD3pC0jTtrCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763101670; c=relaxed/simple;
	bh=bc+V/HF4fxqu9G00z+QeSER5aZdfvvskR1Ykg8vdOFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T+asX231EFJzgsb1Otaqci319jqZ8KINtY/LrvGoM9HfRESLbVRwqijvuqXCBJ2hrm7pxUSIsaAX5M+LUnwzHUbEaQHQIRkxE6DMXzjvghjnuxUZYQlaVuvrmrlHDEzWjVIKIibg1A1n5QOc6aG99KsJ1+t4jBDw7abj0Txwx60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GXV7ebn9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=K3auXHsfU5FdcS/1vnnbcT2J+LZm/vMNNg6pOKuKyIU=; b=GXV7ebn9UbU//FW2a5zPFt9mYB
	RstntwDtg/p9KAnUUrJw7fZZ3i67d2ym3tpE7bw5EsdUsXUzI7/e4SovYyq5jve2BNe3owL2DjyKf
	EoAfnjLGdBsBvHTOUEnzcnaptrPPXwUlPfsy9ip/RdeoWBHv/CLVQ0b3bh22/5SZHPWM3ovQT+mQJ
	0t9V6au+gisNbxNUKsfrmZ2UErJiNLQ1uEQsF4DJZ/lmgki5JLCxOpdC2Enxw3WoUnFXtqgKib79w
	5wvinHjDCKpdFUnMdebykVTVdL5pcQN0iY+sIXPlUtJc3oG6VdIdhebPbeHE/fvoMNAfP71z9POBi
	1HacyTiA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJnHd-0000000Beq0-3fVl;
	Fri, 14 Nov 2025 06:27:46 +0000
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
Subject: [PATCH 08/14] fs: exit early in generic_update_time when there is no work
Date: Fri, 14 Nov 2025 07:26:11 +0100
Message-ID: <20251114062642.1524837-9-hch@lst.de>
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

Exit early if not attributes are to be updated, to avoid a spurious call
to __mark_inode_dirty which can turn into a fairly expensive no-op due to
the extra checks and locking.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/inode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/inode.c b/fs/inode.c
index 74e672dd90aa..57c458ee548d 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2098,6 +2098,9 @@ int generic_update_time(struct inode *inode, int flags)
 	int updated = inode_update_timestamps(inode, flags);
 	int dirty_flags = 0;
 
+	if (!updated)
+		return 0;
+
 	if (updated & (S_ATIME|S_MTIME|S_CTIME))
 		dirty_flags = inode->i_sb->s_flags & SB_LAZYTIME ? I_DIRTY_TIME : I_DIRTY_SYNC;
 	if (updated & S_VERSION)
-- 
2.47.3


