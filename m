Return-Path: <io-uring+bounces-11082-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A20E6CC0CBD
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 04:57:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0D99B3070C03
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 03:55:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6F64320CC2;
	Tue, 16 Dec 2025 03:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="wiFae3i2"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A203331282E;
	Tue, 16 Dec 2025 03:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765857295; cv=none; b=A6BPVBNRqMIUhSrq5EtI+D16DYae5UHpiiEyB5scutwcJJ7H3T0AsGYM09ict+RM5I58kAp6i2EBwYARYbOzoq2Gu/sjITVFeiLBZxswL1agTwK8dAVniy9C0DfqnBm/BhGBVaU8G+QW1eUEez2dgbQw9DQXda3iJvCos7gnVR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765857295; c=relaxed/simple;
	bh=vjvo+k64W7ElGUEZkimf09BlPWP0vtIGNHy4LOBhMWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p79jGvlW/XUX0lLRVVqgZQb6+9Pd1BmwuBzwSp0oe4YEyBTeQ5y73GL8wrAminPEw8Z9An9X3vleI7XuDidHTbcs6nsWIdpv787ac/fkvy4MTc2Gwyh91x2hf3L4gDpfLWMqIq+4pJcNj1+qhDNb4vH+fWxercn682b3q1go/6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=wiFae3i2; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=z8Xh2rzqJWEtazMX5hjsiMAeLADvZxxnPoSk2BC2U/8=; b=wiFae3i20xsupWHVSApsixREGR
	4VZmxawpsSpUu5bHa8E7OZniHPVOsnNroZmkqa+EgHcUv4o+1TFzRZjlmPwT+vdFZ2eaF8uge3Ksj
	YJydiAFBqTey+0yinySFLfNQSINc1Z72qtZr+6pB7Jzpa+DGAHPYaKCEgRnhRPkKDvhaWjgB/p+Ak
	JNGRfAbMt1AgB3676g+17AWZHWmULEd5YcRc+ISZOqHCFXyeBicCJ9nN5eEX/9IlQlB4I/PgaA2zb
	FDne30LtuIHd4XEZOb+FSexJwzEOZRqJp8DR9ylXvGfN4vQr/3LQVN/lJb6hqe87NT3rGzI5qhkBp
	XlX9D1rg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9h-0000000GwKh-18YG;
	Tue, 16 Dec 2025 03:55:21 +0000
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
Subject: [RFC PATCH v3 26/59] rename do_filp_open() to do_file_open()
Date: Tue, 16 Dec 2025 03:54:45 +0000
Message-ID: <20251216035518.4037331-27-viro@zeniv.linux.org.uk>
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
index af7fd253a712..f6b5d6a657da 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4858,7 +4858,7 @@ static struct file *path_openat(struct nameidata *nd,
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
index 95ba8c5b5fc8..95fcb612ad9c 100644
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


