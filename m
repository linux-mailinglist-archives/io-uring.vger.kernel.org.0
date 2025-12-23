Return-Path: <io-uring+bounces-11281-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 887B8CD78DB
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 01:42:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8484230813FA
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 00:38:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6F85222565;
	Tue, 23 Dec 2025 00:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nq3cINfN"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2178021C9F9;
	Tue, 23 Dec 2025 00:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766450310; cv=none; b=mjXPr6eOi41/Iq43EE6Azxs8dkttBAJpki0ttBYvgNvWKr+tlxokfM3HjkqnyJdHjnWkBgLCEqnBYTiMBdY9xEI0AyiMS/j+dZ8ebNKw+MbCcopzBsv1ebjrB7jv1X+fPgyr27DNQJ4GuRt3O9wvl2NKr0DK3FJ4qSBe06/yY9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766450310; c=relaxed/simple;
	bh=ZEJZl4fOjT6SEzFP+Xcr/ZzovcVdiVx5HImjV2sh5TQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sjfE6ihD1yAN+WmZElwvMhinFEInidqath1SgrO2H1202WLaek9LD1tUVVslECvAhQYNEGa1dJXRGipNNQH4VHWoJqADFGBQ4B7qYMyQCifhxUTlAabfySi4R/AU5Gg0uEZ05rumZKnWYANyZN7hiavZ3eQaz37J+ishcr5UWGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nq3cINfN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=hIGunBSpnUSg3NAOWdHaDxSAaXBUo1yaq1ErJmUnV1s=; b=nq3cINfNS+CDphSuAbiIHLjH5C
	umT4VsQKI28RUf296IZFygkfve4NK+BvJJLTUUxMJrLyBnToPn7XQwexzpiBYd7U3PBnaBH0ne/Ad
	3oa57sqg/CXSn5Ed52nyZaiIAsIYRxsn6YgZJp7MwalY4D3k7rlHkS3wfT+VtmKD1CefkUNQl2Wt+
	5PDeNw6CSgMURrdq2u4j1Sqi6rEIrx43mnGT1vyPFNGx54HBsmGo2Zd42g8htRa3sraRZpTvW6w+D
	2fyKKSwHKS1ErtgEcI7IuFkoNDyAp3r2gW+7Zrj0+HZqF+Any1cNzen0HgZZXZ/lIlnSvrv60tiBb
	KKiEYxug==;
Received: from s58.ghokkaidofl2.vectant.ne.jp ([202.215.7.58] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vXqPy-0000000EIoY-2kcy;
	Tue, 23 Dec 2025 00:38:26 +0000
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
Subject: [PATCH 04/11] fs: delay the actual timestamp updates in inode_update_timestamps
Date: Tue, 23 Dec 2025 09:37:47 +0900
Message-ID: <20251223003756.409543-5-hch@lst.de>
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

Perform the actual updates of the inode timestamp at the very end of
inode_update_timestamps after finishing all checks.  This prepares for
adding non-blocking timestamp updates where we might bail out instead of
performing this updates if the update would block.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/inode.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 876641a6e478..19f50bdb6f7d 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2109,10 +2109,8 @@ int inode_update_timestamps(struct inode *inode, int flags)
 		now = inode_set_ctime_current(inode);
 		if (!timespec64_equal(&now, &ctime))
 			updated |= S_CTIME;
-		if (!timespec64_equal(&now, &mtime)) {
-			inode_set_mtime_to_ts(inode, now);
+		if (!timespec64_equal(&now, &mtime))
 			updated |= S_MTIME;
-		}
 		if (IS_I_VERSION(inode) && inode_maybe_inc_iversion(inode, updated))
 			updated |= S_VERSION;
 	} else {
@@ -2122,11 +2120,14 @@ int inode_update_timestamps(struct inode *inode, int flags)
 	if (flags & S_ATIME) {
 		struct timespec64 atime = inode_get_atime(inode);
 
-		if (!timespec64_equal(&now, &atime)) {
-			inode_set_atime_to_ts(inode, now);
+		if (!timespec64_equal(&now, &atime))
 			updated |= S_ATIME;
-		}
 	}
+
+	if (updated & S_MTIME)
+		inode_set_mtime_to_ts(inode, now);
+	if (updated & S_ATIME)
+		inode_set_atime_to_ts(inode, now);
 	return updated;
 }
 EXPORT_SYMBOL(inode_update_timestamps);
-- 
2.47.3


