Return-Path: <io-uring+bounces-2331-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 653129165AD
	for <lists+io-uring@lfdr.de>; Tue, 25 Jun 2024 13:01:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 87D141C22C74
	for <lists+io-uring@lfdr.de>; Tue, 25 Jun 2024 11:01:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5059D14BF9B;
	Tue, 25 Jun 2024 11:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JM1eg0Dw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6BC14AD24;
	Tue, 25 Jun 2024 11:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719313260; cv=none; b=Pj24ZXca6OGnWXsaWIVOz/smFmNciyI6zEhuGqwn6IvECRl6GaH7dWreHEqTxGXUfUSuxDUCBr3Pt2koLRKStAHesTNBsXTkK4X5trtzICsHFOETPTIctVzzX1LzRRuzuBvEOgNcrTeudx+b6pgS68nS2Rr+L6C2nk0aF5hLzqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719313260; c=relaxed/simple;
	bh=Qx9nn4N/0uGydqFiWspNCnMlo9JldIIWKGZCDF/mhZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MfURCKajDuZ0wGYD17BGD6PKzdl4GgOD7rX5n+Diujlh64CpfQ2lFFRt8DJlCtWw6hjb1BH4nVUJKzz8pcJlWsnuO9eNdS51s+yUKXOrMcMt9eyyNMX83Y1CZL9UTUuFJvvQ7+LMizIMMsVwGP4WEskJVCMJvjd/G/2sLdS9kIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JM1eg0Dw; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a724e067017so278147066b.0;
        Tue, 25 Jun 2024 04:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719313257; x=1719918057; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PDtwFciM4nTzlZf6ylZvaFvsdHMJWGfNAlLJgEeCQsA=;
        b=JM1eg0DwXecIN+t5QcPbnp5mU24AkoXVE9NFa3YetzmYuqdBOcpk/CSnnPs3Vb1eTc
         Dc1LO9jgu37Nhx6yRypxY63RNg6qtZkpqMy342BNAPjw2zHcjxKSWidO14wev7w30YG9
         BkQrzeqCocf/ENEUoBJk5Se1LAl710OfdXpMhEFdyH8R5R10GgHgbP4Jenm81Ue4/Y+d
         kFnFJjOPsbKkgNAEoa3ZiFJGr5QprAjqR9iNKGZdLa4YYoVcSb4oTlm3qd3FRV85YAFr
         v4c2Jh/PvrXP4yUhFIDVZWnGbH3sFGE8rP2h07Xa7/zqehljPJ8e5LK1oldQ3+M6ONJv
         gA/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719313257; x=1719918057;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PDtwFciM4nTzlZf6ylZvaFvsdHMJWGfNAlLJgEeCQsA=;
        b=JEqVThQ3ZKJN6rYF2eWILYR0ustO1JRTwnYo6m++1m8s90JO8fr+ttuSjj4bX9Wid3
         ElIrh/Srp/TpMwGBmhBcx9kIAN1J1IejczwURIywgmI5saiARgDZGYsToB1OreyRDMvG
         /h/DFvO56lF4pIAmJuSnaBT6bxpei9Pa60C0OTrJgPO4JXr+cGUEYLLY50hJB1Nwr1cZ
         nTE0PTgLBGAgaeOng6/4HPGy94s1KQzIgJ5J2fZs79waJqZ0dU0xaYgg2gRsV9mIgyBX
         p9tH7YxWxuP0yJ7RtuyOMu0JJr38erWm6OmIsBhL4vt4g8lTncj+k3oTaGkGoqYJf4qe
         YkwQ==
X-Forwarded-Encrypted: i=1; AJvYcCUUod9h1n/35ogJx0tLLdwylmNkeIh7rY7np2/UUHxdHAD99up1bBkyczLz0BZ3YzZ+QCjQIXHKEUBYgqoFmU3UxI3GkXCj5VLJZw61PnwQiNmDWFtSc6pmRJudenU5K/wapwYCfQ70nPE6L4rvWQsdMpp1+azCsP4ro6mF+j8TbBM2SIz/
X-Gm-Message-State: AOJu0YwOa92F8Wl6zZHZFXjuZFFGZHnvI4sAkiNPxbIZmq19T0nj5IFX
	SMFxUHXZfWyzhVnRIXFsl3g/O6lcu15igNDvVyPAtCsyU7OxlmHg
X-Google-Smtp-Source: AGHT+IFRTq88DKEIGsB/us3b8O3gHDEVsHBBdW8y2F64wmd0hTEryoAiUGyf/l8EJQYEkL/YHFmbDA==
X-Received: by 2002:a17:907:774b:b0:a6e:57ff:7700 with SMTP id a640c23a62f3a-a7245b8522bmr412104166b.42.1719313256623;
        Tue, 25 Jun 2024 04:00:56 -0700 (PDT)
Received: from f.. (cst-prg-81-171.cust.vodafone.cz. [46.135.81.171])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a724162f037sm337272566b.194.2024.06.25.04.00.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jun 2024 04:00:56 -0700 (PDT)
From: Mateusz Guzik <mjguzik@gmail.com>
To: brauner@kernel.org
Cc: viro@zeniv.linux.org.uk,
	jack@suse.cz,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org,
	axboe@kernel.dk,
	torvalds@linux-foundation.org,
	xry111@xry111.site,
	loongarch@lists.linux.dev,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: [PATCH 2/2] vfs: support statx(..., NULL, AT_EMPTY_PATH, ...)
Date: Tue, 25 Jun 2024 13:00:28 +0200
Message-ID: <20240625110029.606032-3-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240625110029.606032-1-mjguzik@gmail.com>
References: <20240625110029.606032-1-mjguzik@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The newly used helper also checks for 0-sized buffers.

This avoids path lookup code, lockref management, memory allocation and
in case of NULL path userspace memory access (which can be quite
expensive with SMAP on x86_64).

statx with AT_EMPTY_PATH paired with "" or NULL argument as appropriate
issued on Sapphire Rapids (ops/s):
stock:     4231237
0-check:   5944063 (+40%)
NULL path: 6601619 (+11%/+56%)

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---
 fs/internal.h    |  2 ++
 fs/stat.c        | 90 ++++++++++++++++++++++++++++++++++--------------
 io_uring/statx.c | 23 +++++++------
 3 files changed, 80 insertions(+), 35 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 1caa6a8f666f..0a018ebcaf49 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -244,6 +244,8 @@ extern const struct dentry_operations ns_dentry_operations;
 int getname_statx_lookup_flags(int flags);
 int do_statx(int dfd, struct filename *filename, unsigned int flags,
 	     unsigned int mask, struct statx __user *buffer);
+int do_statx_fd(int fd, unsigned int flags, unsigned int mask,
+		struct statx __user *buffer);
 
 /*
  * fs/splice.c:
diff --git a/fs/stat.c b/fs/stat.c
index 106684034fdb..1214826f3a36 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -214,6 +214,43 @@ int getname_statx_lookup_flags(int flags)
 	return lookup_flags;
 }
 
+static int vfs_statx_path(struct path *path, int flags, struct kstat *stat,
+			  u32 request_mask)
+{
+	int error = vfs_getattr(path, stat, request_mask, flags);
+
+	if (request_mask & STATX_MNT_ID_UNIQUE) {
+		stat->mnt_id = real_mount(path->mnt)->mnt_id_unique;
+		stat->result_mask |= STATX_MNT_ID_UNIQUE;
+	} else {
+		stat->mnt_id = real_mount(path->mnt)->mnt_id;
+		stat->result_mask |= STATX_MNT_ID;
+	}
+
+	if (path->mnt->mnt_root == path->dentry)
+		stat->attributes |= STATX_ATTR_MOUNT_ROOT;
+	stat->attributes_mask |= STATX_ATTR_MOUNT_ROOT;
+
+	/* Handle STATX_DIOALIGN for block devices. */
+	if (request_mask & STATX_DIOALIGN) {
+		struct inode *inode = d_backing_inode(path->dentry);
+
+		if (S_ISBLK(inode->i_mode))
+			bdev_statx_dioalign(inode, stat);
+	}
+
+	return error;
+}
+
+static int vfs_statx_fd(int fd, int flags, struct kstat *stat,
+			  u32 request_mask)
+{
+	CLASS(fd_raw, f)(fd);
+	if (!f.file)
+		return -EBADF;
+	return vfs_statx_path(&f.file->f_path, flags, stat, request_mask);
+}
+
 /**
  * vfs_statx - Get basic and extra attributes by filename
  * @dfd: A file descriptor representing the base dir for a relative filename
@@ -243,36 +280,13 @@ static int vfs_statx(int dfd, struct filename *filename, int flags,
 retry:
 	error = filename_lookup(dfd, filename, lookup_flags, &path, NULL);
 	if (error)
-		goto out;
-
-	error = vfs_getattr(&path, stat, request_mask, flags);
-
-	if (request_mask & STATX_MNT_ID_UNIQUE) {
-		stat->mnt_id = real_mount(path.mnt)->mnt_id_unique;
-		stat->result_mask |= STATX_MNT_ID_UNIQUE;
-	} else {
-		stat->mnt_id = real_mount(path.mnt)->mnt_id;
-		stat->result_mask |= STATX_MNT_ID;
-	}
-
-	if (path.mnt->mnt_root == path.dentry)
-		stat->attributes |= STATX_ATTR_MOUNT_ROOT;
-	stat->attributes_mask |= STATX_ATTR_MOUNT_ROOT;
-
-	/* Handle STATX_DIOALIGN for block devices. */
-	if (request_mask & STATX_DIOALIGN) {
-		struct inode *inode = d_backing_inode(path.dentry);
-
-		if (S_ISBLK(inode->i_mode))
-			bdev_statx_dioalign(inode, stat);
-	}
-
+		return error;
+	error = vfs_statx_path(&path, flags, stat, request_mask);
 	path_put(&path);
 	if (retry_estale(error, lookup_flags)) {
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
-out:
 	return error;
 }
 
@@ -677,6 +691,29 @@ int do_statx(int dfd, struct filename *filename, unsigned int flags,
 	return cp_statx(&stat, buffer);
 }
 
+int do_statx_fd(int fd, unsigned int flags, unsigned int mask,
+	     struct statx __user *buffer)
+{
+	struct kstat stat;
+	int error;
+
+	if (mask & STATX__RESERVED)
+		return -EINVAL;
+	if ((flags & AT_STATX_SYNC_TYPE) == AT_STATX_SYNC_TYPE)
+		return -EINVAL;
+
+	/* STATX_CHANGE_COOKIE is kernel-only for now. Ignore requests
+	 * from userland.
+	 */
+	mask &= ~STATX_CHANGE_COOKIE;
+
+	error = vfs_statx_fd(fd, flags, &stat, mask);
+	if (error)
+		return error;
+
+	return cp_statx(&stat, buffer);
+}
+
 /**
  * sys_statx - System call to get enhanced stats
  * @dfd: Base directory to pathwalk from *or* fd to stat.
@@ -696,6 +733,9 @@ SYSCALL_DEFINE5(statx,
 	int ret;
 	struct filename *name;
 
+	if (flags == AT_EMPTY_PATH && vfs_empty_path(dfd, filename))
+		return do_statx_fd(dfd, flags, mask, buffer);
+
 	name = getname_flags(filename, getname_statx_lookup_flags(flags), NULL);
 	ret = do_statx(dfd, name, flags, mask, buffer);
 	putname(name);
diff --git a/io_uring/statx.c b/io_uring/statx.c
index abb874209caa..fe967ecb1762 100644
--- a/io_uring/statx.c
+++ b/io_uring/statx.c
@@ -23,6 +23,7 @@ struct io_statx {
 int io_statx_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_statx *sx = io_kiocb_to_cmd(req, struct io_statx);
+	struct filename *filename;
 	const char __user *path;
 
 	if (sqe->buf_index || sqe->splice_fd_in)
@@ -36,15 +37,14 @@ int io_statx_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	sx->buffer = u64_to_user_ptr(READ_ONCE(sqe->addr2));
 	sx->flags = READ_ONCE(sqe->statx_flags);
 
-	sx->filename = getname_flags(path,
-				     getname_statx_lookup_flags(sx->flags),
-				     NULL);
-
-	if (IS_ERR(sx->filename)) {
-		int ret = PTR_ERR(sx->filename);
-
-		sx->filename = NULL;
-		return ret;
+	sx->filename = NULL;
+	if (!(sx->flags == AT_EMPTY_PATH && vfs_empty_path(sx->dfd, path))) {
+		filename = getname_flags(path,
+					 getname_statx_lookup_flags(sx->flags),
+					 NULL);
+		if (IS_ERR(filename))
+			return PTR_ERR(filename);
+		sx->filename = filename;
 	}
 
 	req->flags |= REQ_F_NEED_CLEANUP;
@@ -59,7 +59,10 @@ int io_statx(struct io_kiocb *req, unsigned int issue_flags)
 
 	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
 
-	ret = do_statx(sx->dfd, sx->filename, sx->flags, sx->mask, sx->buffer);
+	if (sx->filename == NULL)
+		ret = do_statx_fd(sx->dfd, sx->flags, sx->mask, sx->buffer);
+	else
+		ret = do_statx(sx->dfd, sx->filename, sx->flags, sx->mask, sx->buffer);
 	io_req_set_res(req, ret, 0);
 	return IOU_OK;
 }
-- 
2.43.0


