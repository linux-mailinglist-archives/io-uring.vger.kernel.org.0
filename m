Return-Path: <io-uring+bounces-10466-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F58BC4393D
	for <lists+io-uring@lfdr.de>; Sun, 09 Nov 2025 07:37:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C38DE3AD46A
	for <lists+io-uring@lfdr.de>; Sun,  9 Nov 2025 06:37:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEF6524887E;
	Sun,  9 Nov 2025 06:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="QRWiAEWb"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33FB21D63EF;
	Sun,  9 Nov 2025 06:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762670270; cv=none; b=Ed0WTosqXnRV7eZ2F0WkneFk6wS2ZMg22BT1UY9rLNLTZxhCBxk/3J55qM0sD/6wjxsf1dwGDUV8K/4bZPIYy40BK2b+haDbkFAyzQtinuLqutzosFKW+ytT0qiJhSbK5C/yn1r5w1zaiLThkK7Sk7mrtEmKRO4rLCDa9OVXX78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762670270; c=relaxed/simple;
	bh=xQ7El2M28M0wHx+P+g8Yo1qBcNgqMr0WmiWcFdzVu9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H7/GkYdgHn2d0YEIJ/05NqLPbXyCUEPhU2hIaWbM4fd4MV34I43GrKXqI/fPzdOgB7cjvroRPH3AR7A1aHVu104Rxsk04KXYHMCDZhKNBwQewROmIt/1/jIZ++EA7pvmOf2wh+1iX62bpV2dj/+bT5TXXsW3C48rBdIT194nddY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=QRWiAEWb; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=OSmE8RDttZ57sO3CJH0P4rRo3qRd5TrH+VcvqqudS9I=; b=QRWiAEWbTqDI0d8XXO+8WObLQY
	fjwkapBHYthSg3D0lol0ikoGX2YVObG1KuzxeCmqxkXoBJ7cDLsYQlDIm7KPtGH56MV+XHPalgkIB
	TyG8aCI/OUr+6DvWjWGWgqTyEQ82uYP/YxLw+unCXcxPcWpzzs4mOcAOMoNIOd57imxlXB22yrtGl
	RDesBe38i1tBf5BqfaJt2GHPmfQNBfqTfazUE42rXGrW57lg+pqC8XstzyPy3ZZLTHIJd1QYh4ztV
	bqwC6MTn5JThir4Nor1mqS2c9O5kslWKmi003lsS8aU99nNDia/ibvWiicZ4a47M1hRJNm/eCin/M
	/ptNBsbQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vHz3a-00000008lc2-1cfz;
	Sun, 09 Nov 2025 06:37:46 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org,
	brauner@kernel.org,
	jack@suse.cz,
	mjguzik@gmail.com,
	paul@paul-moore.com,
	axboe@kernel.dk,
	audit@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: [RFC][PATCH 06/13] chroot(2): import pathname only once
Date: Sun,  9 Nov 2025 06:37:38 +0000
Message-ID: <20251109063745.2089578-7-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251109063745.2089578-1-viro@zeniv.linux.org.uk>
References: <20251109063745.2089578-1-viro@zeniv.linux.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Al Viro <viro@ftp.linux.org.uk>

Convert the user_path_at() call inside a retry loop into getname_flags() +
filename_lookup() + putname() and leave only filename_lookup() inside
the loop.

In this case we never pass LOOKUP_EMPTY, so getname_flags() is equivalent
to plain getname().

The things could be further simplified by use of cleanup.h stuff, but
let's not clutter the patch with that.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/open.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/open.c b/fs/open.c
index 8bc2f313f4a9..e67baae339fc 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -603,8 +603,9 @@ SYSCALL_DEFINE1(chroot, const char __user *, filename)
 	struct path path;
 	int error;
 	unsigned int lookup_flags = LOOKUP_FOLLOW | LOOKUP_DIRECTORY;
+	struct filename *name = getname(filename);
 retry:
-	error = user_path_at(AT_FDCWD, filename, lookup_flags, &path);
+	error = filename_lookup(AT_FDCWD, name, lookup_flags, &path, NULL);
 	if (error)
 		goto out;
 
@@ -628,6 +629,7 @@ SYSCALL_DEFINE1(chroot, const char __user *, filename)
 		goto retry;
 	}
 out:
+	putname(name);
 	return error;
 }
 
-- 
2.47.3


