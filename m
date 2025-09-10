Return-Path: <io-uring+bounces-9714-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B1C5B523C0
	for <lists+io-uring@lfdr.de>; Wed, 10 Sep 2025 23:47:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 20A28583AF0
	for <lists+io-uring@lfdr.de>; Wed, 10 Sep 2025 21:47:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 246AD2D77EF;
	Wed, 10 Sep 2025 21:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bwQ8yClQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0E0313E07;
	Wed, 10 Sep 2025 21:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757540816; cv=none; b=LHFzhM4UKId6/xnuHFkeO+iLadDS+ce/r4UHY6raPWrB5O+7XlqmvyrcyqgSEpv9+gdvO4t7Vex66d4fOqXWsFJ21SCPBOtTkIuBn+IVQuuc1MJA0+P2ePNonUfsziBIbgMmYN5Pl1v2JiU5p7uGZeXwZiK0fACAqHJWFOQIxIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757540816; c=relaxed/simple;
	bh=qstbrlRZcLg4CK/QOAsvqo3jABqjG/7g5bowEKFdKmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cyhu6xZwz35VQU5GwTX4fKb3NOjiS3Gk3fPOO99kszv/AHPDqyhDhwhoY/+kQ5ZCeaS+yp0umFIjk8j7HFUpV5TVIUfDZ2g2B6AcX0Qe9IMXwsD88cLqZ8Iy8eiKqZrBjvG+x0lUukls+iPJLdmpWSoAGyTpHsXOS2levIWrEm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bwQ8yClQ; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-772679eb358so65180b3a.1;
        Wed, 10 Sep 2025 14:46:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757540813; x=1758145613; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/SAThsSoUzBXNxEx0T9W5TOEY/YBqRxc+sgU4NHg5m4=;
        b=bwQ8yClQzk0RwmYZfSm8T3vNve3P9svCZlZIXcYMQSykrPsCnPUQakvvpgzPpCv3yG
         llLzOTLGOTGLNfaGxsNsQ2PIXTV73bbeGD04NSjVtWLIjmGea9y7XdhPNzoCJX6L68+S
         +W4jG0X7Zoj6CJP56jfz6nJgaOR590fsvpYpsseKjOBQy1KypmNxTlR6xYkZu3nTJIP4
         H2RPZmjOPoHgthNbPWCxpI6jTJwMpnhI1KSnNqOyYvwJgWRnVumJoNsO9PovPMw5jp9n
         5j9NMk6lUTa+mkEeuE05IxR/oO4j2fIXLkTuyKsh3fg39YyZLxurHqs1Vmqvo34Jhdpo
         iT6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757540813; x=1758145613;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/SAThsSoUzBXNxEx0T9W5TOEY/YBqRxc+sgU4NHg5m4=;
        b=DlyF6YcoNhh1yJQAZqtKxc88zxSywyaEi7bB3uE6amsx7eSY/LeR7u3e4v9xjD/V/S
         MJ4uTfv8+mr2X5x3YtRCKJ0q4ay7hE/bZebHqpTCEIZZoe5e9PaUMICdG0lJwuXbhb5a
         2YoGVEa21x85wyH9zeeCAjBHFiSd4+0J1MhaJWzp7D+WzwkglBJZ9yNfdlTrKydsb3Ut
         NdhA0xfumBEPGQkcS8wX081E3KkhqeGWWI45IvnkSrqGwO2zWjhVJY03marSLtkaQoRT
         k7JhurMJ6fYE71IcCr30jQPwjuO/xp4AzAvkHB2EYk+7A6CGqp2CkynaDngsBCWadl2q
         9EUA==
X-Forwarded-Encrypted: i=1; AJvYcCVPLN/6+ZNjaHwxF4IYxJKKq3QxskThkPRzdTYOj77wWsAXeS+8tFcALdo10mVuU0ASPA6zIDOnu7H2@vger.kernel.org, AJvYcCWuIyZYlBCsFkvVoMW8QDuPuzyPpNBoLHIZpHLnD3hKMq1Xap/TbfcXmOurM5rWyzrEtVI3SS7AgCuDPJ6G@vger.kernel.org
X-Gm-Message-State: AOJu0YzQMT6YQAM3mqJJoxBpxruSCwQHs5oa9lal8bq34KvMMJM7b1ha
	QPOIjb/U0RGZ46yiWxe1GprYBiJorIRSUbBeXL0AhHD9cwJrAOaP3NeSlHpmSSaJ
X-Gm-Gg: ASbGncs3kq7nzSo37anwT00K2+MjCFljzRNQYEcXGd0WvrGgMXPr0B7EqF7eSTHfqyd
	GNY2nsKVbvQzKUlNkW3ozkYAm7HfzXyRF5NuQk08BtU8wH0lqYaMMsMo2VycGAu29nEeoGupPJc
	1li4Q3oeVbcfQ/M7QJ2hkAC1BEygTE8zEz4B8aKmNMIsoEENZGoMqfMjWLeQDZ67qY3sQf/hNpv
	mtv07rJJen4bcs0rQY/z/PgGo5FVfEhqjCLjMEVB4sdBWK3hyI5PbTKR82K5SgLjsv5XCK60a4e
	x2KqCng3wQc4F+hzYYrPKonMVIFjioXdfxxRMPML0FkkfK9YeNVG6H6SKGAXJ/dWhoA2oYbdmpl
	Rd8WeXuqHm4sdUoKVBTwIdID/tg==
X-Google-Smtp-Source: AGHT+IEs8QmhTuDKzxv9b/j1lPgbDGWnQdCO47TYOeCKIUklJtjAIjostLfcoq/RvGXcB26gql/m7Q==
X-Received: by 2002:a05:6a20:2449:b0:250:9175:96e3 with SMTP id adf61e73a8af0-25343c5f51fmr26136408637.30.1757540813469;
        Wed, 10 Sep 2025 14:46:53 -0700 (PDT)
Received: from jicarita ([65.144.169.45])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-775fbbc3251sm2422516b3a.103.2025.09.10.14.46.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Sep 2025 14:46:52 -0700 (PDT)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: io-uring@vger.kernel.org,
	axboe@kernel.dk,
	linux-fsdevel@vger.kernel.org,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	linux-nfs@vger.kernel.org
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH 03/10] fhandle: helper for allocating, reading struct file_handle
Date: Wed, 10 Sep 2025 15:49:20 -0600
Message-ID: <20250910214927.480316-4-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910214927.480316-1-tahbertschinger@gmail.com>
References: <20250910214927.480316-1-tahbertschinger@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Pull the code for allocating and copying a struct file_handle from
userspace into a helper function get_user_handle() just for this.

do_handle_open() is updated to call get_user_handle() prior to calling
handle_to_path(), and the latter now takes a kernel pointer as a
parameter instead of a __user pointer.

This new helper, as well as handle_to_path(), are also exposed in
fs/internal.h. In a subsequent commit, io_uring will use these helpers
to support open_by_handle_at(2) in io_uring.

Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
 fs/fhandle.c  | 64 +++++++++++++++++++++++++++++----------------------
 fs/internal.h |  3 +++
 2 files changed, 40 insertions(+), 27 deletions(-)

diff --git a/fs/fhandle.c b/fs/fhandle.c
index 605ad8e7d93d..36e194dd4cb6 100644
--- a/fs/fhandle.c
+++ b/fs/fhandle.c
@@ -330,25 +330,45 @@ static inline int may_decode_fh(struct handle_to_path_ctx *ctx,
 	return 0;
 }
 
-static int handle_to_path(int mountdirfd, struct file_handle __user *ufh,
-		   struct path *path, unsigned int o_flags)
+struct file_handle *get_user_handle(struct file_handle __user *ufh)
 {
-	int retval = 0;
 	struct file_handle f_handle;
-	struct file_handle *handle __free(kfree) = NULL;
-	struct handle_to_path_ctx ctx = {};
-	const struct export_operations *eops;
+	struct file_handle *handle;
 
 	if (copy_from_user(&f_handle, ufh, sizeof(struct file_handle)))
-		return -EFAULT;
+		return ERR_PTR(-EFAULT);
 
 	if ((f_handle.handle_bytes > MAX_HANDLE_SZ) ||
 	    (f_handle.handle_bytes == 0))
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 
 	if (f_handle.handle_type < 0 ||
 	    FILEID_USER_FLAGS(f_handle.handle_type) & ~FILEID_VALID_USER_FLAGS)
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
+
+	handle = kmalloc(struct_size(handle, f_handle, f_handle.handle_bytes),
+			 GFP_KERNEL);
+	if (!handle) {
+		return ERR_PTR(-ENOMEM);
+	}
+
+	/* copy the full handle */
+	*handle = f_handle;
+	if (copy_from_user(&handle->f_handle,
+			   &ufh->f_handle,
+			   f_handle.handle_bytes)) {
+		return ERR_PTR(-EFAULT);
+	}
+
+	return handle;
+}
+
+int handle_to_path(int mountdirfd, struct file_handle *handle,
+		   struct path *path, unsigned int o_flags)
+{
+	int retval = 0;
+	struct handle_to_path_ctx ctx = {};
+	const struct export_operations *eops;
 
 	retval = get_path_anchor(mountdirfd, &ctx.root);
 	if (retval)
@@ -362,31 +382,16 @@ static int handle_to_path(int mountdirfd, struct file_handle __user *ufh,
 	if (retval)
 		goto out_path;
 
-	handle = kmalloc(struct_size(handle, f_handle, f_handle.handle_bytes),
-			 GFP_KERNEL);
-	if (!handle) {
-		retval = -ENOMEM;
-		goto out_path;
-	}
-	/* copy the full handle */
-	*handle = f_handle;
-	if (copy_from_user(&handle->f_handle,
-			   &ufh->f_handle,
-			   f_handle.handle_bytes)) {
-		retval = -EFAULT;
-		goto out_path;
-	}
-
 	/*
 	 * If handle was encoded with AT_HANDLE_CONNECTABLE, verify that we
 	 * are decoding an fd with connected path, which is accessible from
 	 * the mount fd path.
 	 */
-	if (f_handle.handle_type & FILEID_IS_CONNECTABLE) {
+	if (handle->handle_type & FILEID_IS_CONNECTABLE) {
 		ctx.fh_flags |= EXPORT_FH_CONNECTABLE;
 		ctx.flags |= HANDLE_CHECK_SUBTREE;
 	}
-	if (f_handle.handle_type & FILEID_IS_DIR)
+	if (handle->handle_type & FILEID_IS_DIR)
 		ctx.fh_flags |= EXPORT_FH_DIR_ONLY;
 	/* Filesystem code should not be exposed to user flags */
 	handle->handle_type &= ~FILEID_USER_FLAGS_MASK;
@@ -400,12 +405,17 @@ static int handle_to_path(int mountdirfd, struct file_handle __user *ufh,
 static long do_handle_open(int mountdirfd, struct file_handle __user *ufh,
 			   int open_flag)
 {
+	struct file_handle *handle __free(kfree) = NULL;
 	long retval = 0;
 	struct path path __free(path_put) = {};
 	struct file *file;
 	const struct export_operations *eops;
 
-	retval = handle_to_path(mountdirfd, ufh, &path, open_flag);
+	handle = get_user_handle(ufh);
+	if (IS_ERR(handle))
+		return PTR_ERR(handle);
+
+	retval = handle_to_path(mountdirfd, handle, &path, open_flag);
 	if (retval)
 		return retval;
 
diff --git a/fs/internal.h b/fs/internal.h
index c972f8ade52d..ab80f83ded47 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -363,4 +363,7 @@ void pidfs_get_root(struct path *path);
 long do_sys_name_to_handle_at(int dfd, const char __user *name,
 			      struct file_handle __user *handle,
 			      void __user *mnt_id, int flag, int lookup_flags);
+struct file_handle *get_user_handle(struct file_handle __user *ufh);
+int handle_to_path(int mountdirfd, struct file_handle *handle,
+		   struct path *path, unsigned int o_flags);
 #endif /* CONFIG_FHANDLE */
-- 
2.51.0


