Return-Path: <io-uring+bounces-10922-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 08E75C9D715
	for <lists+io-uring@lfdr.de>; Wed, 03 Dec 2025 01:39:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 2155C4E4D02
	for <lists+io-uring@lfdr.de>; Wed,  3 Dec 2025 00:38:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E75C26980F;
	Wed,  3 Dec 2025 00:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DvszAPzg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B422609C5
	for <io-uring@vger.kernel.org>; Wed,  3 Dec 2025 00:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764722237; cv=none; b=APLr7JK52LQoYoVC5qmtNzOEm/tUDcMSHcVluew9SjqrAfb71Z27itKRhNcF9CkAGehgbrcS1CoDA2Bt9OQtg2q6YeXa4xKLfhU0oLwjRIaukQsTU6Xa1oNk7GyA+Em79SLZtqX+sWkabcLJzY5Dul3aG/vdINFkVW8vDfHa89M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764722237; c=relaxed/simple;
	bh=3fpkpiTJHdrZxc2y4ONX2+1WcazqUMMlvL1L1ouR/Bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PJbQP7LwyXUCJiGCTZ3qAEp+p8xLw2UppzLm5Tx9ssM2hle8WUum7D7raFISu866M+rniLGXY3HvrRfAuA7IBeKEC8TSpulxlBAOLKGObBeia0thPJSiKVx1doD37D2C75nrmPKR8SYoHikT+m9eVr7Czv+Ezl6FmbR1QnNRj5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DvszAPzg; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2980d9b7df5so72246395ad.3
        for <io-uring@vger.kernel.org>; Tue, 02 Dec 2025 16:37:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764722235; x=1765327035; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AYXb2uAkh8VPDgfdTv5sNYyezVHslaxZWi/My/NXKY0=;
        b=DvszAPzgmi5PVjIb6SQh/qY8TnWog+/rXujWqgvXj02h50c/TSYLjtSHjY1EkbEXLU
         kt4EF/PkIevr1RkxBI7OIyYVrklPQmjm23BCbpWrMdfIYCSYV1K0NlgX5pdoqUvRrMrJ
         DUljHmpIv4e5f3LrTv/GUz03K1kXU6BUNqDLRqANo1BI+9nY8HHNV0yw92CFOCuHIb7O
         a64Jx8iRokq+POulncOTwbhEgCZ/6VVHs7sugtAty3i12fwgymLlfceDBi4HsFHCpzVF
         +phdHINRkFXjaKimifkjNhdmO4iOHLuVjl6kyDBR0tJl3Y+Y1pdfUNreJeUeOBgpmhTE
         iKQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764722235; x=1765327035;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AYXb2uAkh8VPDgfdTv5sNYyezVHslaxZWi/My/NXKY0=;
        b=LdxUZytqHkfXiPfg9khre8IIjo/JJk/PcG4lSp9QYyoyFyttd8SX6TQG79gBoUh3RL
         irfjXayEnoPF4Re/oo963PpEXpD9pVbrtqaNRl9Y/9B5zAo2UMzRwHJ1t1pHZ2PFaEdR
         41t1oVvOj+4GX1HmnrOik/lNvGEA6gNgSojt/Z/0v8ToUTTs2sVxai/CdY5UZUilczcA
         WnqLsvL3vxGCKk6OJ7/S7VDRp+vphNGAzMVo7CmVev8ZnEyGfg11kSx7d0rTJ6u1tj1j
         4jsKMrE7Ax0SSCTj6LmR9I8iVTQ0ove7HVs6jAQ6h2FNEh8fTHntSipNy00TJi7SYpig
         VYxA==
X-Forwarded-Encrypted: i=1; AJvYcCUQ16xtUgdIttxTr4vA+pokmv+BEh85LoKZvhkSNe0SeFhjTWZbgefwJhjqdUwmH+ZF2sdJw6jXUA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyQCXggHsua3YWUBwvaRuRkdC40Z5f//slFn/awqV4/SzF0bojn
	x5iZEUmcMwfh+J/tSpzkOiJG8iXPJZxrPhrIylma1gh/M479t/Ofasdy
X-Gm-Gg: ASbGnctLthVnev6t6bZbH0ONkCxecxpJYYVcIh2IiQbXoVADWx59LOIi9nulB2jtPgH
	MTgF9BvBoJXjb4JCPMzbOjGddgF61IeuFHoz6PSW0kQnKQBxuhcCWSHyxDYSohYlkjewL35rhan
	12oxd4LX7ZCzTokJVfUyS+Wg8DNVYOKzNx4fYu0Edgb2ZQDdv9u//FCZoFsGana+nFgZC2f3Fxu
	KblHLQ2ppk/CN8Gb5TLZttrOSrSpeG7JP/g7iZhQUoftEGRnJ2bwUy9BnNkoxgFVD/n0fNo277Z
	PGJSc2FoiGcvx8PNY3/RD5CHgL2KRS7tFkiF5qL3tjaIBzMlKOtghKt6E/7PL0S6/R15rL6RwtO
	TsuGL8o5Is9xQzTATKq4ljYGcf8aDcPj/5zyaQM3zpB2lWz+jy+Bi551JLVaKy9Ysu5mSJh681v
	WnqKhsV2NgAxGuymMzLQ==
X-Google-Smtp-Source: AGHT+IFcqcCU0EY873imCcT0eRPEwTemwJq0y3Y5AQuWaomgOEuUsFFPp8UDaA7ip/0FsWHnSn6DjQ==
X-Received: by 2002:a17:902:d482:b0:297:c0f0:42b3 with SMTP id d9443c01a7336-29d68312c47mr6481695ad.25.1764722234813;
        Tue, 02 Dec 2025 16:37:14 -0800 (PST)
Received: from localhost ([2a03:2880:ff:53::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29bd96307ebsm141191735ad.36.2025.12.02.16.37.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 16:37:14 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v1 27/30] fuse: rename fuse_set_zero_arg0() to fuse_zero_in_arg0()
Date: Tue,  2 Dec 2025 16:35:22 -0800
Message-ID: <20251203003526.2889477-28-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251203003526.2889477-1-joannelkoong@gmail.com>
References: <20251203003526.2889477-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The fuse_set_zero_arg0() function is used for setting a no-op header for
in args but to support fuse io-uring zero-copy, the first parameter of
outargs will also need to be set to a no-op header if the request
contains payload but no out heeader.

Rename fuse_set_zero_arg0() to fuse_zero_in_arg0() to indicate this is
for the in arg header. Later, fuse_zero_out_arg0() will be added.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/fuse/dax.c    | 2 +-
 fs/fuse/dev.c    | 2 +-
 fs/fuse/dir.c    | 8 ++++----
 fs/fuse/fuse_i.h | 2 +-
 fs/fuse/xattr.c  | 2 +-
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/fuse/dax.c b/fs/fuse/dax.c
index ac6d4c1064cc..b4bf586d1fd1 100644
--- a/fs/fuse/dax.c
+++ b/fs/fuse/dax.c
@@ -240,7 +240,7 @@ static int fuse_send_removemapping(struct inode *inode,
 	args.opcode = FUSE_REMOVEMAPPING;
 	args.nodeid = fi->nodeid;
 	args.in_numargs = 3;
-	fuse_set_zero_arg0(&args);
+	fuse_zero_in_arg0(&args);
 	args.in_args[1].size = sizeof(*inargp);
 	args.in_args[1].value = inargp;
 	args.in_args[2].size = inargp->count * sizeof(*remove_one);
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 820d02f01b47..7d39c80da554 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1943,7 +1943,7 @@ static int fuse_retrieve(struct fuse_mount *fm, struct inode *inode,
 	}
 	ra->inarg.offset = outarg->offset;
 	ra->inarg.size = total_len;
-	fuse_set_zero_arg0(args);
+	fuse_zero_in_arg0(args);
 	args->in_args[1].size = sizeof(ra->inarg);
 	args->in_args[1].value = &ra->inarg;
 	args->in_args[2].size = total_len;
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index ecaec0fea3a1..b79be8bbbaf8 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -176,7 +176,7 @@ static void fuse_lookup_init(struct fuse_conn *fc, struct fuse_args *args,
 	args->opcode = FUSE_LOOKUP;
 	args->nodeid = nodeid;
 	args->in_numargs = 3;
-	fuse_set_zero_arg0(args);
+	fuse_zero_in_arg0(args);
 	args->in_args[1].size = name->len;
 	args->in_args[1].value = name->name;
 	args->in_args[2].size = 1;
@@ -943,7 +943,7 @@ static int fuse_symlink(struct mnt_idmap *idmap, struct inode *dir,
 
 	args.opcode = FUSE_SYMLINK;
 	args.in_numargs = 3;
-	fuse_set_zero_arg0(&args);
+	fuse_zero_in_arg0(&args);
 	args.in_args[1].size = entry->d_name.len + 1;
 	args.in_args[1].value = entry->d_name.name;
 	args.in_args[2].size = len;
@@ -1008,7 +1008,7 @@ static int fuse_unlink(struct inode *dir, struct dentry *entry)
 	args.opcode = FUSE_UNLINK;
 	args.nodeid = get_node_id(dir);
 	args.in_numargs = 2;
-	fuse_set_zero_arg0(&args);
+	fuse_zero_in_arg0(&args);
 	args.in_args[1].size = entry->d_name.len + 1;
 	args.in_args[1].value = entry->d_name.name;
 	err = fuse_simple_request(fm, &args);
@@ -1032,7 +1032,7 @@ static int fuse_rmdir(struct inode *dir, struct dentry *entry)
 	args.opcode = FUSE_RMDIR;
 	args.nodeid = get_node_id(dir);
 	args.in_numargs = 2;
-	fuse_set_zero_arg0(&args);
+	fuse_zero_in_arg0(&args);
 	args.in_args[1].size = entry->d_name.len + 1;
 	args.in_args[1].value = entry->d_name.name;
 	err = fuse_simple_request(fm, &args);
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index c2f2a48156d6..34541801d950 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -1020,7 +1020,7 @@ struct fuse_mount {
  */
 struct fuse_zero_header {};
 
-static inline void fuse_set_zero_arg0(struct fuse_args *args)
+static inline void fuse_zero_in_arg0(struct fuse_args *args)
 {
 	args->in_args[0].size = sizeof(struct fuse_zero_header);
 	args->in_args[0].value = NULL;
diff --git a/fs/fuse/xattr.c b/fs/fuse/xattr.c
index 93dfb06b6cea..aa0881162287 100644
--- a/fs/fuse/xattr.c
+++ b/fs/fuse/xattr.c
@@ -165,7 +165,7 @@ int fuse_removexattr(struct inode *inode, const char *name)
 	args.opcode = FUSE_REMOVEXATTR;
 	args.nodeid = get_node_id(inode);
 	args.in_numargs = 2;
-	fuse_set_zero_arg0(&args);
+	fuse_zero_in_arg0(&args);
 	args.in_args[1].size = strlen(name) + 1;
 	args.in_args[1].value = name;
 	err = fuse_simple_request(fm, &args);
-- 
2.47.3


