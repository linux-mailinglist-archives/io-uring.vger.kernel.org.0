Return-Path: <io-uring+bounces-11280-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C81DCD78B4
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 01:40:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E7A45306E95E
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 00:38:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1FCE21ADA7;
	Tue, 23 Dec 2025 00:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DiqNcBLT"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B5519C553;
	Tue, 23 Dec 2025 00:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766450305; cv=none; b=K8c2QLPU8IrUGfrcbpO0KN54TRxQTwiQZvG49B/iz5XENKoB2q+J69bVEw5SRZd4NSevEZFSfpTj8alataOoGEChDNtPNXiOptOSruVrBfovgfkeYM0JfSFWAfk2McbwtkbdNj/39K+cJNiHooBl4hl+E1AYwsuzuLezAEApA+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766450305; c=relaxed/simple;
	bh=pdkRZbbze5PitLsn2TZ3ArtkPSav3YI0ecXhhm56WPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dHJo+46bS8NtRyXf/FhAYns/zHROlRd0jzgtuo0Mh2uf1jzGpqGUBim/I/pJOaoFvVCU9t6Z4wIjDMfBdf/FQh8QQWy2Lip6TZGzl6u66B1exE+6SLIePCxNGynBMnZxeig0YX7ss2VZZbM5BJ9xBnQGgPupRAsyoN7p/ZQCN7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DiqNcBLT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=/a4MHlngQAkJvLl03ngVN9z/x28Ag05HwE+m65/BvgE=; b=DiqNcBLTL6jsEIeXOpPRLC+IQu
	C8bAKPZfsVrVipbMGTtZNOdUJLjcJJ1dOl5aYJWwAyTXcLjpygnPxc7ZVWfI66N11a+9l+3YHfdNP
	NmMiQgEN1wBifFyb5hNrw6ouQgyDzBcBVY38rhCBf1uoxPoimXRmZkLQbtmplaOgHfUKNoSHKLpCO
	NzE6XwzFGVqz5e5yawCK7adS8mL2H+DV0nSkHGvMXmaWF1Wfh1NSQ2ZZMOI6Ew6QebX+BdmAUbwtY
	BaK2aBndyF+40ZxfQ1npMutdJx0FUA7Le0yChxvjEoOKzY2XRghcY0+g6kH46pDM2vO3zyoZJwY8e
	XC+WicDw==;
Received: from s58.ghokkaidofl2.vectant.ne.jp ([202.215.7.58] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vXqPt-0000000EIm0-2quH;
	Tue, 23 Dec 2025 00:38:21 +0000
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
Subject: [PATCH 03/11] fs: exit early in generic_update_time when there is no work
Date: Tue, 23 Dec 2025 09:37:46 +0900
Message-ID: <20251223003756.409543-4-hch@lst.de>
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

Exit early if no attributes are to be updated, to avoid a spurious call
to __mark_inode_dirty which can turn into a fairly expensive no-op due to
the extra checks and locking.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
---
 fs/inode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/inode.c b/fs/inode.c
index 7eb28dd45a5a..876641a6e478 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2148,6 +2148,9 @@ int generic_update_time(struct inode *inode, int flags)
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


