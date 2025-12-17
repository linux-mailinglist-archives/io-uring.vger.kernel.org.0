Return-Path: <io-uring+bounces-11136-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 9714ACC62B8
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 07:10:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 7ADE13014BEB
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 06:10:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE4A82D6E55;
	Wed, 17 Dec 2025 06:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tZt5A0Na"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EEE42D6630;
	Wed, 17 Dec 2025 06:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765951852; cv=none; b=ZJgXQJ5EpkEwfk6bY5ZIT5BClfJGZmr+jNfKn/OkdGm/5oCUqL7B1Lo7RAdLORrvX+zXk7b5buN7R8o3qYnLVdsKzPnKm8doWTTpiHhHXOVoPaAUCjm237ll5KF+/UHqxbZSq1M4z6X74Br0MtrIaJqZMxNDTFldW5gtdYoO53k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765951852; c=relaxed/simple;
	bh=pdkRZbbze5PitLsn2TZ3ArtkPSav3YI0ecXhhm56WPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OsAr8+LU7XfkjluLhfWMS3vthTDWplj3se2qRZONm+vVXaPjJIlx8mmZ33vSa0PM6IYoZiCcr2st+dCaI3yL5LUnPAeYRxiMyNEHb30DHcOMnYRSqHCeS4nLMwUx7sjleQoOcFz4e+ujEG6hK+ZXugNf1E6edhzolxjUOP3ixz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tZt5A0Na; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=/a4MHlngQAkJvLl03ngVN9z/x28Ag05HwE+m65/BvgE=; b=tZt5A0NaMvWCi+AYKLKhNDmaO/
	Dq9lay8n8NU10T80F9s2IOqEbHt9pph96CYGit41m2QkQaTaK2yG+au2wXZydJ9e5qw/p7XlB3K7b
	0Qsb5AnJdHicAzk9/QUJoj/C3jsyAxbl8Wz/NUtGWvaMyPdMzi8vbs/qQlWqdwXUyIk0L6uV/M5fr
	33YZ1j0eKlwv7EzUrJKwpSlyAqlaOh8c9+SrmlLvqY4AUCIoxIba3L3TKGRMMwzLI+XqrN4sRv//D
	ZA51OQnhG1gmDIEBSuaVIuUwNEPrduyHD220vUQalF6TvR0D2oC7wBuQH3yDIp1ZUeZSrO4ycb4af
	SfzyEi2w==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vVkkJ-00000006DSK-2847;
	Wed, 17 Dec 2025 06:10:48 +0000
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
Subject: [PATCH 03/10] fs: exit early in generic_update_time when there is no work
Date: Wed, 17 Dec 2025 07:09:36 +0100
Message-ID: <20251217061015.923954-4-hch@lst.de>
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


