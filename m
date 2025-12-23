Return-Path: <io-uring+bounces-11286-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 067D3CD792A
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 01:48:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 75CEC301EFD4
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 00:47:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3233220F38;
	Tue, 23 Dec 2025 00:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="v6psm9/X"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1A22737E3;
	Tue, 23 Dec 2025 00:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766450337; cv=none; b=imyfVR6McW7gz/reTrHq7YVhciWP+N+L1STMji8IvFjZFGK/AL2svcGjL7264rRUy7KGFIGe65E5E+qBZf7SJFw77qIo1GODDV2GrKzJjkxxMyRgtT42r6O39dkzHoWQthxqEzQ0/GHUV41urxAaSsnzjeB2GZMxI1+RvRg6s6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766450337; c=relaxed/simple;
	bh=fwJVDhWjVtmtrB9DU1Y+fjs+N+c+yCQq91/249WWBzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hsE5FqvFGXcsV+fLMfVbxLhhNbl0i2EiO7bSwafj3Iahezsww8FEFc0o9qQJgueQVY5uEZ/R17PL5ZgeBx5Sgypx2seiiGQ8YLuqA1hXEaQrGjyTccp3QRZRZ3l2HSHRY748tuFJNrtrkaZCABUWTv34WTpC3MKSMhEUJwIU3Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=v6psm9/X; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=gVCRkx7vlWuwQsnUshb3HGpH6uZ7BmQ3C7+/R9dqKK4=; b=v6psm9/Xr5/zUOYyinQNeqQX0C
	7Nz7v48SWPTUIuZJMi3ra75vqkKqUrPaKiRfQ8mxxMlgB+uNTfzRp5XbGvyVlseIKgZObp8Wynilq
	PH00Qa0VO7xFEU5n+2aDCriAzeIqTwfTHx7sha2i5+UB/sFVbm/OoZHm3ShJ17dWZ46sCHvwWIhmq
	lZmWnod4u7d/AwsbNPrz9f+LqxFly56fAZl/X2Cex5riFgcr6jHhwSPcYhVxIV6+aLSZWIvozOmkC
	iuZA9zHa5VhiboXUTPyRBXVk08MhOtm7PlLPyV8btZnKK4jouhG0ba0ZkyehZivmt5gcYnft0NnN7
	9I27cA1Q==;
Received: from s58.ghokkaidofl2.vectant.ne.jp ([202.215.7.58] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vXqQO-0000000EJ5E-16w0;
	Tue, 23 Dec 2025 00:38:52 +0000
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
Subject: [PATCH 09/11] fat: enable non-blocking timestamp updates
Date: Tue, 23 Dec 2025 09:37:52 +0900
Message-ID: <20251223003756.409543-10-hch@lst.de>
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

As fat dosn't implement ->dirty_inode, nothing in fat_update_time can
block, and fat can thus trivially implement non-blocking timestamp
updates.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/fat/misc.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/fat/misc.c b/fs/fat/misc.c
index 5df3193c35f9..950da09f0961 100644
--- a/fs/fat/misc.c
+++ b/fs/fat/misc.c
@@ -346,9 +346,6 @@ int fat_update_time(struct inode *inode, int flags)
 	if (inode->i_ino == MSDOS_ROOT_INO)
 		return 0;
 
-	if (flags & S_NOWAIT)
-		return -EAGAIN;
-
 	if (flags & (S_ATIME | S_CTIME | S_MTIME)) {
 		fat_truncate_time(inode, NULL, flags);
 		if (inode->i_sb->s_flags & SB_LAZYTIME)
-- 
2.47.3


