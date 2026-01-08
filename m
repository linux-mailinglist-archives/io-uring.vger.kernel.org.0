Return-Path: <io-uring+bounces-11479-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F1D4D01880
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 09:13:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id F1AA230CBA07
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 07:58:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CB1634251D;
	Thu,  8 Jan 2026 07:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="Lg6rBNqB"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E5C032779D;
	Thu,  8 Jan 2026 07:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857819; cv=none; b=PJ75WrivT6QT0tmBqv4QzpywIfetTddbOgEbKHr05b1XRJ7hzvXK+eSaiIU11PXBxyzNfRAYffq+AAvlyMww/G2hsGiZeQItrpTY9lqnUzFnUNkVRgtpJOkVX46c/U4x7Z30K5EJcJ2ggcsZGl+XJX6Rdi3MwrX6Ve9CJ40896g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857819; c=relaxed/simple;
	bh=ATaHNvEGkj455ZapmLUWkmm24/ySdUOMeuI8hvb1u0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TtbQaBO4Wu6mTqag3yd849KUeDCF4boFT8MjQwD1xEHWBxB4VYRxTGzDgyh6+qqtUHDW0XX09xSSSCYRs9G6TGxK6tz5/0ly7qNEIkpmWiQwvDQsjoU2sfXiz1UwEDYVs3aMxb1Md2HojO470FEA0RF13vWSahGJq7iC4r4dOfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=Lg6rBNqB; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=CeV5xnu6YraY0E36YYd9v6GG4gssIj1+wOjZCBNOAG4=; b=Lg6rBNqBsPGYgzeiPQvhqstelK
	3KC049nSgy7RGc1zcGAR9FirEwhCjaZpvyeFqq99fmkGoDrO7NxGzoHYRLIcH3LtST2pHFI+WLjvN
	MjKr3QzCH9B12iTwYPdQ6GAjzcJ5qoNOo//1lf4hNvb7GO7eFIWnS6Bt6hVCT2JHGaEiIYbJAMf4G
	BLun1rmHqAPMEXYkp5tZ+dHu3MOY4rASAp04zrLJfLQQs7PNcoFjh8b7DeZCb4OXiUuDibWRVD6Sg
	uXvrqoteHXVutRq09vy5NDonJPety/BQI6c7sYcWx3SPOvJH3gyI6ff1xKSpVgc8YFYXdf/5f4vao
	t6kwLagA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkau-00000001mmL-2eCn;
	Thu, 08 Jan 2026 07:38:08 +0000
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
Subject: [PATCH v4 27/59] rename do_filp_open() to do_file_open()
Date: Thu,  8 Jan 2026 07:37:31 +0000
Message-ID: <20260108073803.425343-28-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260108073803.425343-1-viro@zeniv.linux.org.uk>
References: <20260108073803.425343-1-viro@zeniv.linux.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Al Viro <viro@ftp.linux.org.uk>

"filp" thing never made sense; seeing that there are exactly 4 callers
in the entire tree (and it's neither exported nor even declared in
linux/*/*.h), there's no point keeping that ugliness.

FWIW, the 'filp' thing did originate in OSD&I; for some reason Tanenbaum
decided to call the object representing an opened file 'struct filp',
the last letter standing for 'position'.  In all Unices, Linux included,
the corresponding object had always been 'struct file'...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/exec.c            | 2 +-
 fs/internal.h        | 2 +-
 fs/namei.c           | 2 +-
 fs/open.c            | 4 ++--
 io_uring/openclose.c | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 9d5ebc9d15b0..b7d8081d12ea 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -780,7 +780,7 @@ static struct file *do_open_execat(int fd, struct filename *name, int flags)
 	if (flags & AT_EMPTY_PATH)
 		open_exec_flags.lookup_flags |= LOOKUP_EMPTY;
 
-	file = do_filp_open(fd, name, &open_exec_flags);
+	file = do_file_open(fd, name, &open_exec_flags);
 	if (IS_ERR(file))
 		return file;
 
diff --git a/fs/internal.h b/fs/internal.h
index e44146117a42..5c3e4eac34f2 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -189,7 +189,7 @@ struct open_flags {
 	int intent;
 	int lookup_flags;
 };
-extern struct file *do_filp_open(int dfd, struct filename *pathname,
+extern struct file *do_file_open(int dfd, struct filename *pathname,
 		const struct open_flags *op);
 extern struct file *do_file_open_root(const struct path *,
 		const char *, const struct open_flags *);
diff --git a/fs/namei.c b/fs/namei.c
index c8410dc6c0c6..9beb667f0307 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4855,7 +4855,7 @@ static struct file *path_openat(struct nameidata *nd,
 	return ERR_PTR(error);
 }
 
-struct file *do_filp_open(int dfd, struct filename *pathname,
+struct file *do_file_open(int dfd, struct filename *pathname,
 		const struct open_flags *op)
 {
 	struct nameidata nd;
diff --git a/fs/open.c b/fs/open.c
index 2fea68991d42..3d2e2a2554c5 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -1382,7 +1382,7 @@ struct file *file_open_name(struct filename *name, int flags, umode_t mode)
 	int err = build_open_flags(&how, &op);
 	if (err)
 		return ERR_PTR(err);
-	return do_filp_open(AT_FDCWD, name, &op);
+	return do_file_open(AT_FDCWD, name, &op);
 }
 
 /**
@@ -1436,7 +1436,7 @@ static int do_sys_openat2(int dfd, const char __user *filename,
 	if (IS_ERR(tmp))
 		return PTR_ERR(tmp);
 
-	return FD_ADD(how->flags, do_filp_open(dfd, tmp, &op));
+	return FD_ADD(how->flags, do_file_open(dfd, tmp, &op));
 }
 
 int do_sys_open(int dfd, const char __user *filename, int flags, umode_t mode)
diff --git a/io_uring/openclose.c b/io_uring/openclose.c
index aa3acb06247f..c09dd14108ed 100644
--- a/io_uring/openclose.c
+++ b/io_uring/openclose.c
@@ -138,7 +138,7 @@ int io_openat2(struct io_kiocb *req, unsigned int issue_flags)
 			goto err;
 	}
 
-	file = do_filp_open(open->dfd, name, &op);
+	file = do_file_open(open->dfd, name, &op);
 	if (IS_ERR(file)) {
 		/*
 		 * We could hang on to this 'fd' on retrying, but seems like
-- 
2.47.3


