Return-Path: <io-uring+bounces-10475-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E649C43963
	for <lists+io-uring@lfdr.de>; Sun, 09 Nov 2025 07:38:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9D6734E17B9
	for <lists+io-uring@lfdr.de>; Sun,  9 Nov 2025 06:38:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E45BD25A2CF;
	Sun,  9 Nov 2025 06:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="rNvl8c97"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3401D1E8329;
	Sun,  9 Nov 2025 06:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762670271; cv=none; b=jNisbeW4tfPm/Ph1SPuoK8RuzORWLS3+L5DR/H30KfuTLKsiIR5PLLCX3vtS/4Aos1UFXY+R0ycH4LH2y34DtvPUOoNsKlBDxBaIZQxIXPIG+TrEunKEbwy2PsH0J4C3Pk1OdU4vi97FnMHqQogtaCq22GeoNAMYIkNP7SxxILw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762670271; c=relaxed/simple;
	bh=sMpauPvEJwGDtLBQG/iTx+xTGPghb3my1NHgM/6j9G0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZIq9NJ8bf4qgKqFdnUzElqCg6kuGkBP22pYX+UxzdBTqenFrvmZW+65cCjGMQmn8T2vU1nyGf52gDqaD90M5Y1acPCUwCTf0wmHvSUGMMhzZtPcvonDC7zj+/etLJM0vGM2DiAcLe1hVX1fC+dFXlTIZ3dmBIPnKL9SRR/XWiwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=rNvl8c97; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=r9RneWoJ2ADclp4gzk9Ex1aEKHWv5hbsuogQp9Vg4tc=; b=rNvl8c97MqobZCXsLDJT/ENqKl
	h7pUoHQZuoNxZmrrunQUnaFsdIrBhSEDxMfLxTLs6cfA7ofDO/34ruVncL9p+WmB+zv9cNh1hNtIU
	+89HdhpU19ZIR+kngIWhpaGbazocLyXgHPJ5XdvBH5YwoTY9eKglBMDayPu3wq/1K3FrBkkJ7uh4v
	ZS+8d8hJbGWc+pszpcl4Mx7suuA1kUJqD9NJlY/7S6Nx51rXuwi1SLy2bfoMf1uKWacWuBIhw3wvX
	fE+s7YE/ZH8NCxW6IjHagUKIvyYy+L8+GTyDU6zVy+HeXm2w9MGc+xWwjH0to6dJjPioY8EJpzKwK
	c7LMPcTQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vHz3a-00000008lcG-2Guj;
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
Subject: [RFC][PATCH 08/13] do_sys_truncate(): import pathname only once
Date: Sun,  9 Nov 2025 06:37:40 +0000
Message-ID: <20251109063745.2089578-9-viro@zeniv.linux.org.uk>
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
 fs/open.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/open.c b/fs/open.c
index e67baae339fc..eb2ff940393d 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -129,14 +129,16 @@ EXPORT_SYMBOL_GPL(vfs_truncate);
 int do_sys_truncate(const char __user *pathname, loff_t length)
 {
 	unsigned int lookup_flags = LOOKUP_FOLLOW;
+	struct filename *name;
 	struct path path;
 	int error;
 
 	if (length < 0)	/* sorry, but loff_t says... */
 		return -EINVAL;
 
+	name = getname(pathname);
 retry:
-	error = user_path_at(AT_FDCWD, pathname, lookup_flags, &path);
+	error = filename_lookup(AT_FDCWD, name, lookup_flags, &path, NULL);
 	if (!error) {
 		error = vfs_truncate(&path, length);
 		path_put(&path);
@@ -145,6 +147,7 @@ int do_sys_truncate(const char __user *pathname, loff_t length)
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
+	putname(name);
 	return error;
 }
 
-- 
2.47.3


