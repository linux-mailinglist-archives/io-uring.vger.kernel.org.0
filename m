Return-Path: <io-uring+bounces-11640-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FEAAD1C596
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:32:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 42275300EDBD
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:32:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B8EF318EF2;
	Wed, 14 Jan 2026 04:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="ghdvX/qX"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93412E06EA;
	Wed, 14 Jan 2026 04:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365113; cv=none; b=cnjNalMF6s+9IClUQxOQUdfcb+DEgqPR+8gRI/foRnB8oQroWmu3xCxRYPrmvbv5fGbodZ06YS6fFwsg7RffL7cNm4RBF4YOdaNR5TX8F+oAR5UdwdkObKeMveOnDiUIAf2zBigdemxUUDuDQmqou11irhZaJPH3C1vOPQV8M9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365113; c=relaxed/simple;
	bh=+/2fJOB1BO4S+MXr2Oiqwn2QXMarVYCqR7o31SP5sBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G2KEFK8m3WL0RzBW/0b97s0F3U4plJPO1uQTlEP8v4pWHttz1RQDCOc1LTFJZLal3mrKJpbbGF0iqwQjYt/DHxb2y4GpqhClVxWKvPfxwgHOhmC99YWaW5A1lMv46Pw0FoQYBoKdwFtypYTwvQFzVV8VYchlOaztEKMjx1+vOuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=ghdvX/qX; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=DaO+ZA83YcIa1UqEs5gSGH8vIlxyVTG0/Vk+SuN8d7U=; b=ghdvX/qXZbt5hXyxx8S+cQwRpC
	BHbRvqfzH0A5u2/hb6DCol9OQtymQVUC4M5YU7iyQkGNQx/QASvV8qgx3KiCKb3Krzf5F39XrDDed
	lUc/W9CBtbUQp9V9Vu5nupNLLn8UOgqt65tG4nTS2RRnKf2Z6f/wAl04it5lh2Yr+7UBHIJ8Ky6hk
	oFNxBjy0UsU2gzBCU0iVvexwmHyWd6HAD9ucFiYobERa0CRzuMzccad+oh80Av2YgRUMRr9uTQBZU
	S1rkN+8U/XsZGhd8yAMstmR6qOoTB3gcpitGOj1LynEP9ZA77qHm23m9EfdnWliuoZVnqvNXMyZiv
	g4E3JTDQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZC-0000000GIn1-3kmJ;
	Wed, 14 Jan 2026 04:33:10 +0000
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
Subject: [PATCH v5 02/68] init_mkdir(): turn into a trivial wrapper for do_mkdirat()
Date: Wed, 14 Jan 2026 04:32:04 +0000
Message-ID: <20260114043310.3885463-3-viro@zeniv.linux.org.uk>
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
 fs/init.c | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/fs/init.c b/fs/init.c
index 746d02628bc3..4b1fd7675095 100644
--- a/fs/init.c
+++ b/fs/init.c
@@ -202,24 +202,7 @@ int __init init_unlink(const char *pathname)
 
 int __init init_mkdir(const char *pathname, umode_t mode)
 {
-	struct dentry *dentry;
-	struct path path;
-	int error;
-
-	dentry = start_creating_path(AT_FDCWD, pathname, &path,
-				     LOOKUP_DIRECTORY);
-	if (IS_ERR(dentry))
-		return PTR_ERR(dentry);
-	mode = mode_strip_umask(d_inode(path.dentry), mode);
-	error = security_path_mkdir(&path, dentry, mode);
-	if (!error) {
-		dentry = vfs_mkdir(mnt_idmap(path.mnt), path.dentry->d_inode,
-				  dentry, mode, NULL);
-		if (IS_ERR(dentry))
-			error = PTR_ERR(dentry);
-	}
-	end_creating_path(&path, dentry);
-	return error;
+	return do_mkdirat(AT_FDCWD, getname_kernel(pathname), mode);
 }
 
 int __init init_rmdir(const char *pathname)
-- 
2.47.3


