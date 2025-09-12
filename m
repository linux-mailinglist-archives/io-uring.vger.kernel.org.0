Return-Path: <io-uring+bounces-9777-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 83F5AB55385
	for <lists+io-uring@lfdr.de>; Fri, 12 Sep 2025 17:29:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0C5B7584FF9
	for <lists+io-uring@lfdr.de>; Fri, 12 Sep 2025 15:28:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40DDF30B527;
	Fri, 12 Sep 2025 15:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hgo2o+Dn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC2A314A95
	for <io-uring@vger.kernel.org>; Fri, 12 Sep 2025 15:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757690892; cv=none; b=kyRkCT9EtbPVfN9IPIZcU29OrvZPeaL3ZmkfECgjIjusSZhWXwt05D1sRGtEVQAzmGbIgwn6PuJbZTfPeEFC/lf9M1pWgwDAZDi2R6XsJWyWobed/gzIt6NwhQJzUwstfUuFL8/BDtsK34Z6AiV9KtOU5Y9+PbomyPzVw0qqTgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757690892; c=relaxed/simple;
	bh=K07NRUo9zqY4nN5kRcvIAFfqMj5VZl1mhqG/F4Xn2WE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RgVyuOmLX3jNMxXCXD9q9R3fYNd2B6d2sDCTgO3pM6Hd7cnNJMVzeLJXRemlkVPrAwWiJazMNTndDQWhTRuo7xYIk36ur45b7du8BHTZ+Gr5BeHl0wLs3SZHS6O7De0mVYA5t1KaJ6YchSMyKLvOaqkyKA6jx84XmEpNWVf5Dfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hgo2o+Dn; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7726c7ff7e5so1944887b3a.3
        for <io-uring@vger.kernel.org>; Fri, 12 Sep 2025 08:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757690890; x=1758295690; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GrAwY5JfDrvJYw4ViEeSxknJLuWu6wVTQX+QkSjS5Eg=;
        b=Hgo2o+DnMr+5tPskuljgFIWLRL2wCBJAJ5uP30eFL13LalqhFsozi3aD57rZ0F/m4x
         dcp9iUGcJdTUF9Nj5oHq8BuI4yVuBrcgA+wZnitPcta1NDUxErBmZtlMB1iqEBlW2rPE
         P36fyzI1v1ozjP1XomV8987HfulO1VrkCrDJtSilTCk2yFGvUbymRsbULkobmnD9maZv
         tIXraFGmYeHGE63DimZX3IsVGw9djkC5LkogYmJIe74eXZQ0+vQ1TGN0/rZ/ofs1onEY
         /giE46pbubMSp0JZ2wp40+9M4++uaXJynCPX6nztiuMA6/xM4imABXUV7LLhRtrUhUAm
         rY3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757690890; x=1758295690;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GrAwY5JfDrvJYw4ViEeSxknJLuWu6wVTQX+QkSjS5Eg=;
        b=KAbRvDozPBxcWtfYTUrB8PLLrE52UPKmv7g7OzwENU9hRItq9Iz2SzPwF4Lg4Fkwqt
         DdvuZ3PUZBj81c90WejIHFWaiFa2Gv33VX1pKSG6+niGMjLDbIHbi3StH5o8EeefkL+S
         aBLcmtciEzUcrQuX1BgjqW3/gJoAVAqVtp3W8v1wxiUwxvkz/dhA2wnbLC+zg4ukkaN9
         itaaNdeq1kAaq+8xJskaFWaJhAfAJAg580xklRGF/Vm5vdwEHTEabsV8uWYkO+3DsPlw
         d9DbxnC4f2Vc2dG097GqbhchxfYN8fC0KFIbSsME1SsAvRJ2tHNdLEZIK4vBxE7bZqom
         co5A==
X-Gm-Message-State: AOJu0Yw/JwAqVjNWLCgyNS/+NpbXfDKCdCcFgCuZ6sGCHidIItG+aUgj
	oXMrujIdqMXGIGLgOSe0oMsqp4wz8fLl7zIP1ZDG+jpdDzW+D33UmlNrUf2L1Zok
X-Gm-Gg: ASbGncspunTdArJGi+ZGIUg+1m8SWKh4zZ8uSXuOi1f9t4PDWmsQLNfcIkSiJEPgMin
	K+GkNx1FYFiGiVLe47Oh0ywrt2lBU8FWbeNk/OUVaT9w3eCqH8z5I1KNIgalETP0DBRKusac2am
	gQtSvmjE1ZOVMTvWXsRKVZKEIvqKXxuLT8obma/Y4ufOO9l9BEfj2rdIBNPiv16aAnzltVDlEJa
	Yea8PO81ByXnXYYbMliSa2wzh43mMaE5f0Fv+PS4U/PT3i1kopaeqiXp6VV28o/b/bUlo1n+eK9
	Hf42P7xy/X5UjU8/YPXMtD6KxE+wv7V1ytTkqlX1AdNQYZWr1IlF7U5FMTBegiE55SYvNPNiD6L
	ZMCZqf00EuPr+RlBS9ll2RGa4jnyfBKb4JDd7
X-Google-Smtp-Source: AGHT+IHXjF/YrVBz4mMGetnwhko7i25Vp3SjUA9r6o22PANiDSx6Iqp70TZfGVsCdF/6nIvuJ2zKUw==
X-Received: by 2002:a05:6a00:1883:b0:736:3ea8:4805 with SMTP id d2e1a72fcca58-77612060bc4mr4061361b3a.7.1757690889383;
        Fri, 12 Sep 2025 08:28:09 -0700 (PDT)
Received: from jicarita ([65.144.169.45])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7760944a9a9sm5436846b3a.78.2025.09.12.08.28.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 08:28:08 -0700 (PDT)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: io-uring@vger.kernel.org,
	axboe@kernel.dk,
	linux-fsdevel@vger.kernel.org,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	linux-nfs@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	cem@kernel.org,
	chuck.lever@oracle.com,
	jlayton@kernel.org,
	amir73il@gmail.com
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH v3 09/10] io_uring: add support for IORING_OP_OPEN_BY_HANDLE_AT
Date: Fri, 12 Sep 2025 09:28:54 -0600
Message-ID: <20250912152855.689917-10-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250912152855.689917-1-tahbertschinger@gmail.com>
References: <20250912152855.689917-1-tahbertschinger@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds support for open_by_handle_at(2) to io_uring.

First an attempt to do a non-blocking open by handle is made. If that
fails, for example, because the target inode is not cached, a blocking
attempt is made.

Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
 include/uapi/linux/io_uring.h |   1 +
 io_uring/opdef.c              |  15 +++++
 io_uring/openclose.c          | 111 ++++++++++++++++++++++++++++++++++
 io_uring/openclose.h          |   8 +++
 4 files changed, 135 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index a4aa83ad9527..c571929e7807 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -291,6 +291,7 @@ enum io_uring_op {
 	IORING_OP_WRITEV_FIXED,
 	IORING_OP_PIPE,
 	IORING_OP_NAME_TO_HANDLE_AT,
+	IORING_OP_OPEN_BY_HANDLE_AT,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 76306c9e0ecd..1aa36f3f30de 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -580,6 +580,15 @@ const struct io_issue_def io_issue_defs[] = {
 		.issue			= io_name_to_handle_at,
 #else
 		.prep			= io_eopnotsupp_prep,
+#endif
+	},
+	[IORING_OP_OPEN_BY_HANDLE_AT] = {
+#if defined(CONFIG_FHANDLE)
+		.prep			= io_open_by_handle_at_prep,
+		.issue			= io_open_by_handle_at,
+		.async_size		= sizeof(struct io_open_handle_async),
+#else
+		.prep			= io_eopnotsupp_prep,
 #endif
 	},
 };
@@ -835,6 +844,12 @@ const struct io_cold_def io_cold_defs[] = {
 	[IORING_OP_NAME_TO_HANDLE_AT] = {
 		.name			= "NAME_TO_HANDLE_AT",
 	},
+	[IORING_OP_OPEN_BY_HANDLE_AT] = {
+		.name			= "OPEN_BY_HANDLE_AT",
+#if defined(CONFIG_FHANDLE)
+		.cleanup		= io_open_by_handle_cleanup,
+#endif
+	}
 };
 
 const char *io_uring_get_opcode(u8 opcode)
diff --git a/io_uring/openclose.c b/io_uring/openclose.c
index 4da2afdb9773..289d61373567 100644
--- a/io_uring/openclose.c
+++ b/io_uring/openclose.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/kernel.h>
 #include <linux/errno.h>
+#include <linux/exportfs.h>
 #include <linux/fs.h>
 #include <linux/file.h>
 #include <linux/fdtable.h>
@@ -245,6 +246,116 @@ int io_name_to_handle_at(struct io_kiocb *req, unsigned int issue_flags)
 	io_req_set_res(req, ret, 0);
 	return IOU_COMPLETE;
 }
+
+int io_open_by_handle_at_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_open *open = io_kiocb_to_cmd(req, struct io_open);
+	struct io_open_handle_async *ah;
+	u64 flags;
+	int ret;
+
+	flags = READ_ONCE(sqe->open_flags);
+	open->how = build_open_how(flags, 0);
+
+	ret = __io_open_prep(req, sqe);
+	if (ret)
+		return ret;
+
+	ah = io_uring_alloc_async_data(NULL, req);
+	if (!ah)
+		return -ENOMEM;
+	memset(&ah->path, 0, sizeof(ah->path));
+	ah->handle = get_user_handle(u64_to_user_ptr(READ_ONCE(sqe->addr)));
+	if (IS_ERR(ah->handle))
+		return PTR_ERR(ah->handle);
+
+	req->flags |= REQ_F_NEED_CLEANUP;
+
+	return 0;
+}
+
+int io_open_by_handle_at(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_open *open = io_kiocb_to_cmd(req, struct io_open);
+	struct io_open_handle_async *ah = req->async_data;
+	bool nonblock_set = open->how.flags & O_NONBLOCK;
+	bool fixed = !!open->file_slot;
+	struct file *file;
+	struct open_flags op;
+	int ret;
+
+	ret = build_open_flags(&open->how, &op);
+	if (ret)
+		goto err;
+
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		ah->handle->handle_type |= FILEID_CACHED;
+	else
+		ah->handle->handle_type &= ~FILEID_CACHED;
+
+	if (!ah->path.dentry) {
+		/*
+		 * Handle has not yet been converted to path, either because
+		 * this is our first try, or because we tried previously with
+		 * IO_URING_F_NONBLOCK set, and failed.
+		 */
+		ret = handle_to_path(open->dfd, ah->handle, &ah->path, op.open_flag);
+		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
+			return -EAGAIN;
+
+		if (ret)
+			goto err;
+	}
+
+	if (!fixed) {
+		ret = __get_unused_fd_flags(open->how.flags, open->nofile);
+		if (ret < 0)
+			goto err;
+	}
+
+	if (issue_flags & IO_URING_F_NONBLOCK) {
+		WARN_ON_ONCE(io_openat_force_async(open));
+		op.lookup_flags |= LOOKUP_CACHED;
+		op.open_flag |= O_NONBLOCK;
+	}
+	file = do_file_handle_open(&ah->path, &op);
+
+	if (IS_ERR(file)) {
+		if (!fixed)
+			put_unused_fd(ret);
+		ret = PTR_ERR(file);
+		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
+			return -EAGAIN;
+		goto err;
+	}
+
+	if ((issue_flags & IO_URING_F_NONBLOCK) && !nonblock_set)
+		file->f_flags &= ~O_NONBLOCK;
+
+	if (!fixed)
+		fd_install(ret, file);
+	else
+		ret = io_fixed_fd_install(req, issue_flags, file,
+					  open->file_slot);
+
+err:
+	io_open_by_handle_cleanup(req);
+	req->flags &= ~REQ_F_NEED_CLEANUP;
+	if (ret < 0)
+		req_set_fail(req);
+	io_req_set_res(req, ret, 0);
+	return IOU_COMPLETE;
+}
+
+void io_open_by_handle_cleanup(struct io_kiocb *req)
+{
+	struct io_open_handle_async *ah = req->async_data;
+
+	if (ah->path.dentry)
+		path_put(&ah->path);
+
+	kfree(ah->handle);
+}
 #endif /* CONFIG_FHANDLE */
 
 int __io_close_fixed(struct io_ring_ctx *ctx, unsigned int issue_flags,
diff --git a/io_uring/openclose.h b/io_uring/openclose.h
index 2fc1c8d35d0b..f966859a8a92 100644
--- a/io_uring/openclose.h
+++ b/io_uring/openclose.h
@@ -10,9 +10,17 @@ void io_open_cleanup(struct io_kiocb *req);
 int io_openat2_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_openat2(struct io_kiocb *req, unsigned int issue_flags);
 
+struct io_open_handle_async {
+	struct file_handle		*handle;
+	struct path			path;
+};
+
 #if defined(CONFIG_FHANDLE)
 int io_name_to_handle_at_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_name_to_handle_at(struct io_kiocb *req, unsigned int issue_flags);
+int io_open_by_handle_at_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_open_by_handle_at(struct io_kiocb *req, unsigned int issue_flags);
+void io_open_by_handle_cleanup(struct io_kiocb *req);
 #endif /* CONFIG_FHANDLE */
 
 int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
-- 
2.51.0


