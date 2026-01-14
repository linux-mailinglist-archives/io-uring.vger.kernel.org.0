Return-Path: <io-uring+bounces-11662-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 99CADD1C5B8
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:33:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 50B853015DC7
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:32:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EF6532B982;
	Wed, 14 Jan 2026 04:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="lVEYg53Z"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83DF2DF130;
	Wed, 14 Jan 2026 04:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365116; cv=none; b=priQqF5mH+XJda+UpIry6JT15W0uvL5MAF/JLeDs6Yjcz037gP4qj0mB8wmWvPm19EEhdeO+c1aFNJqJCrUxfMnarXK6aIFcxc0b0JlOlu7lAIsBaV3C5uaT05WWq+vkLiVAwUwidjONr7W5XAGo9N4rAtBDVSEDmzZkTy6LICY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365116; c=relaxed/simple;
	bh=Vckd/KSh8BcFemlenjz8zinNKk9silZ2lRrclnwH30A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sl+Z70U0A9fJFViNTvBHDw3OtiYYtEgpq3UowCLg7nsJsN5dEiSSPcgl2+PaCaI5v2Ih91HAY1zUW1gC4DxkOBbYVJSlf/LsfqJYF/0FuARnCq3J1rYFZ1KzGjhFqE+wmW9BWuO/FwSSzFFzu0k1uexSGHT8dbCw5eciL/kzol0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=lVEYg53Z; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=rdnjXjUxXalP43yg2z/xbhkExF8mK2XEAoj37zKqADM=; b=lVEYg53ZJPpiQNEMJFpmiI355f
	xxbfTgpuG2NZps83ovj8s5TEtescqiNmSXCYpaYF52D/QYeCQ2zOFqxupjLfoIIt4DvynynqNRMh+
	IEhCBi9BUdT6gJLxhtb9p9hcuWWiEfHy7Nj8X0XDEpEOv2hC/vFj3MvhY9LzVCv56wq2Cl2vt0jwy
	Nmd9/diKCcq16oTiV3mMfhrvkaHQt9vmCX2oICEANomDC/a23FvfupPMSdBMlf/YSsNJrcevwyCMo
	FxbOJYsrPjqn4Y+4bzc3faa2acRwU8pDQtEAdtEs3wg7LeDGzN4s9JDdUI7bmUHBS5sTVkW8FpV36
	AtAJj5Tw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZG-0000000GIoI-1bjn;
	Wed, 14 Jan 2026 04:33:14 +0000
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
Subject: [PATCH v5 31/68] rename do_filp_open() to do_file_open()
Date: Wed, 14 Jan 2026 04:32:33 +0000
Message-ID: <20260114043310.3885463-32-viro@zeniv.linux.org.uk>
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
index c7a34412399e..4c4d2733c47a 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -190,7 +190,7 @@ struct open_flags {
 	int intent;
 	int lookup_flags;
 };
-extern struct file *do_filp_open(int dfd, struct filename *pathname,
+extern struct file *do_file_open(int dfd, struct filename *pathname,
 		const struct open_flags *op);
 extern struct file *do_file_open_root(const struct path *,
 		const char *, const struct open_flags *);
diff --git a/fs/namei.c b/fs/namei.c
index 659c92a6d52c..65a06fb312af 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4864,7 +4864,7 @@ static struct file *path_openat(struct nameidata *nd,
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


