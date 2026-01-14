Return-Path: <io-uring+bounces-11683-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id DEBBAD1C68C
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:38:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 675D030BB18D
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:33:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAC06331223;
	Wed, 14 Jan 2026 04:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="rzeQQkWj"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C12F318EF3;
	Wed, 14 Jan 2026 04:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365119; cv=none; b=p1i5P8xgjMNyxNMW3GYrf239FPia6bBNkt8ASzYm9jo8GkvkW/a6dBfviWzZ0MRaZwAUcZBVnP1QFEJxkPqtWN5O52P3BpTvGY41nIDfSE6M9ph+Tb1A4RnU8b1LvHG54hW2MeHPoFq2HPhERcWRjQGFkxv2Ruwzfoo/aiqi1x4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365119; c=relaxed/simple;
	bh=KjxmbCW5MCRM6nC5+XrdGJEnUTN01oaui7yoMjFi/e4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GR+Ur6coF8A6fsFChNBCx1F5n+uuKZ+E1BiLPmdgsvByQVvUwezJcW7NqIkt8d6Bzcb80+lTD2NNgQQnFrtTQ3EAA7BM6FCoSU7Q8+vCJXG3YT9nJ+mj3Ep1I+mvoNP6L+IMIFADSIv4Qv/kMkzBPIA5xhGIcE96iLqUxPJr2wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=rzeQQkWj; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=f3Tq4dg4vJ+g4m/HKj2ZnXxW+2fjFXXLL87/JSOPfnU=; b=rzeQQkWjhI1z3Omdp4OrPo5aO3
	eeOJNz/9tDzuV234STBKH7/3scGRHuPUELpKM206pCyzGYYqg6mNZ1HOIQ37kS3w9zpzZ4d/Oq+y6
	f78BDTaK0mh9TBmxUiVmRW3PFvfTmdQxYLQYy6v1kcceaQaDZ3/RolUq20/brqVz1db60bLxJOo/E
	T0z+hrbQHUAhrYqY71M6559taWvrUDXexQa6lCukwyVlVymYcPs2SlFXpy2XfCiiBbmW6bgWWH2BY
	ctXqWMISU+a78n1lkOB1ohdogQD0teOrT3+lxCuE4RkWmjO4CsfQl2lxJdrGeehv1QUd/XYcxV2lS
	vpgzUMJw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZM-0000000GIyn-43pk;
	Wed, 14 Jan 2026 04:33:20 +0000
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
Subject: [PATCH v5 58/68] namei.c: switch user pathname imports to CLASS(filename{,_flags})
Date: Wed, 14 Jan 2026 04:33:00 +0000
Message-ID: <20260114043310.3885463-59-viro@zeniv.linux.org.uk>
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

filename_flags is used by user_path_at().  I suspect that mixing
LOOKUP_EMPTY with real lookup flags had been a mistake all along; the
former belongs to pathname import, the latter - to pathwalk.  Right now
none of the remaining in-tree callers of user_path_at() are getting
LOOKUP_EMPTY in flags, so user_path_at() could probably be switched
to CLASS(filename)...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/namei.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 1158beb9a399..25c786ab0542 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3031,11 +3031,8 @@ struct dentry *start_removing_user_path_at(int dfd,
 					   const char __user *name,
 					   struct path *path)
 {
-	struct filename *filename = getname(name);
-	struct dentry *res = __start_removing_path(dfd, filename, path);
-
-	putname(filename);
-	return res;
+	CLASS(filename, filename)(name);
+	return __start_removing_path(dfd, filename, path);
 }
 EXPORT_SYMBOL(start_removing_user_path_at);
 
@@ -3613,11 +3610,8 @@ int path_pts(struct path *path)
 int user_path_at(int dfd, const char __user *name, unsigned flags,
 		 struct path *path)
 {
-	struct filename *filename = getname_flags(name, flags);
-	int ret = filename_lookup(dfd, filename, flags, path, NULL);
-
-	putname(filename);
-	return ret;
+	CLASS(filename_flags, filename)(name, flags);
+	return filename_lookup(dfd, filename, flags, path, NULL);
 }
 EXPORT_SYMBOL(user_path_at);
 
@@ -4976,11 +4970,8 @@ inline struct dentry *start_creating_user_path(
 	int dfd, const char __user *pathname,
 	struct path *path, unsigned int lookup_flags)
 {
-	struct filename *filename = getname(pathname);
-	struct dentry *res = filename_create(dfd, filename, path, lookup_flags);
-
-	putname(filename);
-	return res;
+	CLASS(filename, filename)(pathname);
+	return filename_create(dfd, filename, path, lookup_flags);
 }
 EXPORT_SYMBOL(start_creating_user_path);
 
-- 
2.47.3


