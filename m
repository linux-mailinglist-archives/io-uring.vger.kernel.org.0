Return-Path: <io-uring+bounces-11653-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id D9F7FD1C5ED
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:34:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 092B930762B5
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:32:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A386329365;
	Wed, 14 Jan 2026 04:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="PQehYD82"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92812E0401;
	Wed, 14 Jan 2026 04:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365115; cv=none; b=LQMNTV9xGSOPFE+yR1++GlxbwjHs1KU8K1IHkGf6os8V4u1xzRouoaroMffudlJ+Y+kkc2kQSNO8sqAQzQPDpBujeoZIt3C0B0MMKzIUuA3FwCwZxlfwRqolFzty+9txp/9LVL/rYdyn21Z4VkGiSeyQPZ8Gzg+pPsQ72/9KtvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365115; c=relaxed/simple;
	bh=XOQAkL5fM0vrcEb36ahezT4R//aAridj+jkPrP1FoXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j1y+4WaIj+CdK6s4CVCHMfviy19USfsGEGidobCmC93x6fpGC4uETXvohQElnTmjxwO2EcCQf1CaINSx000ZmjG1izboJZGolAKlUG4Oq00LkPQlMrpwvPXxOVtLZBCc+NJm+D5IutMiBfwwh9X+61SCwfRrW/+tyspZ6D1Dvwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=PQehYD82; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=hP44CEabDEpZai/lhIeuT6yG/oej0/lVskNP4hgr82c=; b=PQehYD821vacnONMQO66RSyrIa
	fBbK6yUJPD+O+D/kyTXsgvv7rb+mrIvfPt3Gao910Pm6umLTafN44C1QHgyE2l4Doj2AyPJfdQCYD
	2dsLr87E1NeM2Wz+PTwMYTNjg1tM3ZOI2uAVRUhU47JmSTpG9qPSLk+pQZTs2BzVh4zpIHRiLwVVl
	XeAuihqN9rM+RXRyoXnRde6w2tRGBKkSCQXg8x2tLq/CJaWP83Ksv+ZJh0a4Bf2SpZQt6OjzCb8+G
	EIYJMTgbq+SO2M2LHio6Chl6AzayKhVLdwAnh0Mm+ximzpOOJK/7+iNLcW53kvycCfDU4dD+jUOFc
	GIs0lfCQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZD-0000000GIn6-0HXh;
	Wed, 14 Jan 2026 04:33:11 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Jens Axboe <axboe@kernel.dk>,
	audit@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 04/68] init_link(): turn into a trivial wrapper for do_linkat()
Date: Wed, 14 Jan 2026 04:32:06 +0000
Message-ID: <20260114043310.3885463-5-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260114043310.3885463-1-viro@zeniv.linux.org.uk>
References: <20260114043310.3885463-1-viro@zeniv.linux.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Al Viro <viro@ftp.linux.org.uk>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/init.c | 33 ++-------------------------------
 1 file changed, 2 insertions(+), 31 deletions(-)

diff --git a/fs/init.c b/fs/init.c
index 27e149a4e8ce..da6500d2ee98 100644
--- a/fs/init.c
+++ b/fs/init.c
@@ -145,37 +145,8 @@ int __init init_mknod(const char *filename, umode_t mode, unsigned int dev)
 
 int __init init_link(const char *oldname, const char *newname)
 {
-	struct dentry *new_dentry;
-	struct path old_path, new_path;
-	struct mnt_idmap *idmap;
-	int error;
-
-	error = kern_path(oldname, 0, &old_path);
-	if (error)
-		return error;
-
-	new_dentry = start_creating_path(AT_FDCWD, newname, &new_path, 0);
-	error = PTR_ERR(new_dentry);
-	if (IS_ERR(new_dentry))
-		goto out;
-
-	error = -EXDEV;
-	if (old_path.mnt != new_path.mnt)
-		goto out_dput;
-	idmap = mnt_idmap(new_path.mnt);
-	error = may_linkat(idmap, &old_path);
-	if (unlikely(error))
-		goto out_dput;
-	error = security_path_link(old_path.dentry, &new_path, new_dentry);
-	if (error)
-		goto out_dput;
-	error = vfs_link(old_path.dentry, idmap, new_path.dentry->d_inode,
-			 new_dentry, NULL);
-out_dput:
-	end_creating_path(&new_path, new_dentry);
-out:
-	path_put(&old_path);
-	return error;
+	return do_linkat(AT_FDCWD, getname_kernel(oldname),
+			 AT_FDCWD, getname_kernel(newname), 0);
 }
 
 int __init init_symlink(const char *oldname, const char *newname)
-- 
2.47.3


