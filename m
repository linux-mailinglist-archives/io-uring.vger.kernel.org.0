Return-Path: <io-uring+bounces-11687-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id BC1E0D1C5E7
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:34:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 1D2B4301CF8E
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:33:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D60BB33120B;
	Wed, 14 Jan 2026 04:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="BhCu35aR"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF1F322C99;
	Wed, 14 Jan 2026 04:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365120; cv=none; b=MjGl+Yr6AkMHY5Us1WDEXSztXNJu19VlkmF0Wo2Y1AVQuOT5Qot4wQQvODBbVZSDeVpz8yakInPJYV0AoU3FM7seNS8biKCXt9oZSWScrjCZo/8V8igxJn8gET6jRFwjVBP8JYEzUz44d8IBCSR4bBQ7U+45Te++tXLAyAOZexM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365120; c=relaxed/simple;
	bh=K04pMr7mpMxH0hiOJ7GtPBaHUbq5OaTNv0GMZ/FTQJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Um5VxxopX4kOeksAg3a6bedPXGMdIlO9DsU4k/H/2G6jqTguvEFKHR2PN/kPthFPkmRNJ2kTNRCHX0M3J4jXCiDX6ZzA8CmKFXOB6FM3iHJxa1cC3ZCArcP/iyf6kYDrA8q5vq8dcTzo5V/vZVEQ9esbBH5F01ABmZ1dUWAmhL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=BhCu35aR; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=tD6MOGL3HuIaHYd3IIjMnJPzHw93K5UTdELNOyBshkM=; b=BhCu35aRoRhIUPsZecco9D1qfn
	Xs8fcNxfycR6YzE2vi/Uxqh8b42+pswTEQZTZtXsNDyJKZezSWop0yVwRMxhJ8rDl9rgpnFbWxbvR
	+6WLhIj4FDarUXF/+2HrPIhu+QR0NivQPE99CCFtNTt9l6qc9kxmh/yuY8uq6LtGcpJBzLPcRXWzI
	LNIc6uIx8pR5KjsHOjIQWGmu/ePfZ1DGv53599TArGdV+UofwYQY/mwtZyDsSwVNSzQriXCMJSObw
	KDg8o7a+YTiMchREDEeNU2hr3Mbukc+v1kgw4MeeJLig8CdtuI1E5xx6cS27/6T8JIjjeQ4R6iSjr
	s5JpE3NQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZN-0000000GIzP-2WRl;
	Wed, 14 Jan 2026 04:33:21 +0000
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
Subject: [PATCH v5 61/68] chroot(2): switch to CLASS(filename)
Date: Wed, 14 Jan 2026 04:33:03 +0000
Message-ID: <20260114043310.3885463-62-viro@zeniv.linux.org.uk>
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
 fs/open.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 3c7081694326..4adfd7e1975a 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -592,11 +592,11 @@ SYSCALL_DEFINE1(chroot, const char __user *, filename)
 	struct path path;
 	int error;
 	unsigned int lookup_flags = LOOKUP_FOLLOW | LOOKUP_DIRECTORY;
-	struct filename *name = getname(filename);
+	CLASS(filename, name)(filename);
 retry:
 	error = filename_lookup(AT_FDCWD, name, lookup_flags, &path, NULL);
 	if (error)
-		goto out;
+		return error;
 
 	error = path_permission(&path, MAY_EXEC | MAY_CHDIR);
 	if (error)
@@ -606,19 +606,14 @@ SYSCALL_DEFINE1(chroot, const char __user *, filename)
 	if (!ns_capable(current_user_ns(), CAP_SYS_CHROOT))
 		goto dput_and_out;
 	error = security_path_chroot(&path);
-	if (error)
-		goto dput_and_out;
-
-	set_fs_root(current->fs, &path);
-	error = 0;
+	if (!error)
+		set_fs_root(current->fs, &path);
 dput_and_out:
 	path_put(&path);
 	if (retry_estale(error, lookup_flags)) {
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
-out:
-	putname(name);
 	return error;
 }
 
-- 
2.47.3


