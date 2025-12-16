Return-Path: <io-uring+bounces-11095-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 12BDBCC0C8D
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 04:56:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0B018303E4A4
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 03:55:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5197F32693A;
	Tue, 16 Dec 2025 03:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="F/5yebOA"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC1531329B;
	Tue, 16 Dec 2025 03:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765857296; cv=none; b=TRhtrjcxsqIIpb++7pKvnGehsd3Ye8z+2i8HBBg8/Kddu1PBgKd8c/1S2Yd/Rxb1uxaZdLDQai1UUkVLyignNNuWpaVtjOoK/b/D3OgUds2JAyOc/8H1gtr3CiGfuYuX6YLvBCXkccVZqUibzetx/pKExlXl+z0LR15zLkdH9o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765857296; c=relaxed/simple;
	bh=urAa3ZS6X7nMsa9ZRz2Pqn/hpkIvLTL3N56s9umZyt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JfiogYp3MnVUoFJqAdmBtySDeMBMUwkzwcjn1cwE2SzCxwF42VYv/jrdK/lL7tAfplEtzsm52t3XL3Et7X2YnXrm6/fDx+x+mAyfoNlF41rmnd7Grd/rcOflFypNL7Egdh0xHZKMy3EXfGB50nRhvor6xII63fQKT7Uo6U27Y9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=F/5yebOA; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=5+CNfJBBa99USZB4Xzhgo+c1jKCiUr7CLOmJPPMy31A=; b=F/5yebOABSkdX4KaD+TVbsIiAG
	18JF+8x4EoKXEBAw1px0hlGElp5+FKZfp861l+jWemj+zjero4wlIwviLoB70EKhlC9IiNri4ubhI
	eZss75gfgRkkQM+WJIa2uvf59eo9iDFknWdBIT/DwMs4L1rLqz5p61frYUNdn6788gU3tEnotWIZ9
	+XIiFU7wSJxKxoInaz4CX6lAB0W9Cxt27SJQcv6Y1fC5+TKdJ+4eW6nqwosESsqwSnEpav6IWI4Gg
	jQ1RWI80kamrDgG/IdoujKak4R9a/Z4mJhEE4OKa3jGqlFRW+YfPNzaDOX4e902Dq7CEClGLWWI8U
	8daa4Dpw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9i-0000000GwLw-2oLY;
	Tue, 16 Dec 2025 03:55:22 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org,
	brauner@kernel.org,
	jack@suse.cz,
	mjguzik@gmail.com,
	paul@paul-moore.com,
	axboe@kernel.dk,
	audit@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v3 39/59] chdir(2): unspaghettify a bit...
Date: Tue, 16 Dec 2025 03:54:58 +0000
Message-ID: <20251216035518.4037331-40-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216035518.4037331-1-viro@zeniv.linux.org.uk>
References: <20251216035518.4037331-1-viro@zeniv.linux.org.uk>
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
 fs/open.c | 27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 425c09d83d7f..bcaaf884e436 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -558,26 +558,19 @@ SYSCALL_DEFINE1(chdir, const char __user *, filename)
 	struct path path;
 	int error;
 	unsigned int lookup_flags = LOOKUP_FOLLOW | LOOKUP_DIRECTORY;
-	struct filename *name = getname(filename);
+	CLASS(filename, name)(filename);
 retry:
 	error = filename_lookup(AT_FDCWD, name, lookup_flags, &path, NULL);
-	if (error)
-		goto out;
-
-	error = path_permission(&path, MAY_EXEC | MAY_CHDIR);
-	if (error)
-		goto dput_and_out;
-
-	set_fs_pwd(current->fs, &path);
-
-dput_and_out:
-	path_put(&path);
-	if (retry_estale(error, lookup_flags)) {
-		lookup_flags |= LOOKUP_REVAL;
-		goto retry;
+	if (!error) {
+		error = path_permission(&path, MAY_EXEC | MAY_CHDIR);
+		if (!error)
+			set_fs_pwd(current->fs, &path);
+		path_put(&path);
+		if (retry_estale(error, lookup_flags)) {
+			lookup_flags |= LOOKUP_REVAL;
+			goto retry;
+		}
 	}
-out:
-	putname(name);
 	return error;
 }
 
-- 
2.47.3


