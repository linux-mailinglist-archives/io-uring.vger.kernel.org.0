Return-Path: <io-uring+bounces-10923-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBFEEC9D70C
	for <lists+io-uring@lfdr.de>; Wed, 03 Dec 2025 01:38:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7481E3A11FA
	for <lists+io-uring@lfdr.de>; Wed,  3 Dec 2025 00:38:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DA1922DF9E;
	Wed,  3 Dec 2025 00:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IKLGFrck"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075ED263C7F
	for <io-uring@vger.kernel.org>; Wed,  3 Dec 2025 00:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764722238; cv=none; b=b6+zcw1+F0Y8oTygszUeCd1J3FEoOfXJb82VonFaUYqjYSzvbKHtenbTnqJpUIPPJ21JlxhNjmVwWpw0xSsOYaeyKxX6v2plexpFrzs9rqLWEUNjlgdv7uBkwttvLjPOcirfppZs9shQfxMPJTjcsFwGozaHB6/1uiv3q8TUoFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764722238; c=relaxed/simple;
	bh=DGLsiI/Q1Hu5KRYnzIRyJt8xaZK2Chi+JAznO7fS7Jo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ItCFJGM4UODguuOCbBQGQWWckvlLgO80njPcJCOUFc/i3ZUHPWx00Jt2QgxQnjcf8/oosDr3gBfK5wCoJVxIUA9eTOob6osnwyZvv4lPn6kNnUblzj75Uf2e4mU3HTojezZf+TyZj2EsPNBEgC/an+2VtC45lt9suKS4bhhBS8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IKLGFrck; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-297dc3e299bso58420635ad.1
        for <io-uring@vger.kernel.org>; Tue, 02 Dec 2025 16:37:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764722236; x=1765327036; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WsqpJrMs/ysg2fPHsSWUY+OyuCu+dlN13abeE7pc+o8=;
        b=IKLGFrckU93IaZH3yTYDG5XFozqv7fMG5TccPby6b7mvhLymz08JUajd10K3ZNi0GG
         EDUFXGYEuReTZP3IdwGt2NeN1ngMPtASXjw/Av8vvos09JC6h9awvrYqJjAS0V4OPUz3
         kdxBUfWT+httIPSuIjlwhiUE6WyNCU3lf+iM6ZOdw8DyVO7xHpIbi24zD6fOHemde9aA
         H9P9igBGd94WJfRxKXN4lHyHpv3Gb0lwapBeAAEJFdK4xq6Fm+1T6YhzT+RV+5b/EL/+
         0M8HJB+DeXc0g7p8v+8FJMFeYFpG9CVbPGu8BafiyN3iuOeWrwyfslupkIMQSuUQ3eib
         /S9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764722236; x=1765327036;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WsqpJrMs/ysg2fPHsSWUY+OyuCu+dlN13abeE7pc+o8=;
        b=un1D/MaPGs70Rac0GshB8M0LY0Lb+eqrKmc13Q0BPt/jkrADpFc2O+vmOnzdVDgE4O
         hjWz4l8foxNksvChZtJtqftzmD5BEtThBms5eUOJVNUCa2w8/qwQ54+0hozxXWZfEfaN
         /fiP+K5MEtGXuC32p3yT/3m9lhrUMThww70ktRldh29TTFd8TzjkyL53JXNs3FdtqFqO
         zxL/9HBdaCOBUWdeRXaLicIU5Tu7B9cd89+1oD8W+kcy0Xj/sPDw6MkrwEphIfyLQvf8
         S7IGWrWN3H19hZghRkn4mFSujHZs9yrEKs4hSHYWJ1jRhgeydNLbicEvLVc+0lmGfXAo
         2bKg==
X-Forwarded-Encrypted: i=1; AJvYcCVWvMWDUe2fO9hkK2EBVxBi8kG2C0lUI6QvbIkIpAfhJ5HR0zoguOUKidoqM3P86MSIam7KTE3GzA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxhNGKhNPG+B/3YwLLAjcep7muEPYh/lnaQRwHCw0PDt65ysQZo
	1gnlUc9p1IxEUXNXbkWVP6Ejap2FT15oBlQOhHzS7k0DzE4kjMMghLKx
X-Gm-Gg: ASbGncuage15sfak88Pzy1clkf1LIMNHQOdCbsRvlL0TrPvmcAvg0/SZ/fQrvZ/VKro
	ueByqzLa0UldSGdPOof7UYO88t4GelnbTJumxN7w6VBTuKXStuY/SATbpmXdsT1sHhLxdf8sl0Q
	lCwwOfRLUP6F46KSZqLCBAyJTB6zwOlAuYEtqzwVqq3xB6/3zNWYg1Wh2HeoT/FY5IkuMa6JWau
	mY4RfJJJZOUE0JgjOCNbF2nHiVwyYI4lvIxDBKZbRgMJHPMYtMh9YuY+govJWS7rs0XxORY38r6
	AdwTa8bq569C6FWl/uV8cwDVmAy1tqP4Kl/0uSM8c90wWPro4B8AodHAEezavx0O0JuRS/vDLZs
	aK+4Cn6O7n/1Vrf/8hDlpTfPsdSwKmXUj382hTFxZVGDyriWivhg61MoHDoofhVPEhfDlua5Bla
	GnET1khp/XrGt9/Q/eFw==
X-Google-Smtp-Source: AGHT+IFRuT/a8cMuL9O40GMAUyNMct99b729Oe6C4pg7eGK28S7kSEqBbWm3LtInLtgz/CcoM487iA==
X-Received: by 2002:a17:902:f641:b0:297:d764:9874 with SMTP id d9443c01a7336-29d683026ddmr5417735ad.21.1764722236359;
        Tue, 02 Dec 2025 16:37:16 -0800 (PST)
Received: from localhost ([2a03:2880:ff:5f::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29bceb54449sm165126415ad.87.2025.12.02.16.37.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 16:37:16 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v1 28/30] fuse: enforce op header for every payload reply
Date: Tue,  2 Dec 2025 16:35:23 -0800
Message-ID: <20251203003526.2889477-29-joannelkoong@gmail.com>
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

In order to support fuse io-uring zero-copy, the payload and the headers
for a request/reply must reside in separate buffers since any
zero-copied payload will be transparent to the daemon but the headers
need to be accessible.

Currently, a fuse reply can be either:
* arg[0] = op header, arg[1] = payload
* arg[0] = payload
* arg[0] = NULL

Fuse io-uring needs to differentiate between the first two for copying
to/from the ring.

Enforce that all fuse replies that have a payload also have an op
header. If there is is only a payload to send in the reply, then the
header will be a zero-size no-op header.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/fuse/dir.c     |  5 +++--
 fs/fuse/file.c    | 11 ++++++-----
 fs/fuse/fuse_i.h  |  6 ++++++
 fs/fuse/readdir.c |  2 +-
 fs/fuse/xattr.c   | 16 ++++++++++------
 5 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index b79be8bbbaf8..238fa1bab3c9 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1630,8 +1630,9 @@ static int fuse_readlink_folio(struct inode *inode, struct folio *folio)
 	ap.args.out_pages = true;
 	ap.args.out_argvar = true;
 	ap.args.page_zeroing = true;
-	ap.args.out_numargs = 1;
-	ap.args.out_args[0].size = desc.length;
+	ap.args.out_numargs = 2;
+	fuse_zero_out_arg0(&ap.args);
+	ap.args.out_args[1].size = desc.length;
 	res = fuse_simple_request(fm, &ap.args);
 
 	fuse_invalidate_atime(inode);
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index f1ef77a0be05..ff6c287bc4ed 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -581,8 +581,9 @@ void fuse_read_args_fill(struct fuse_io_args *ia, struct file *file, loff_t pos,
 	args->in_args[0].size = sizeof(ia->read.in);
 	args->in_args[0].value = &ia->read.in;
 	args->out_argvar = true;
-	args->out_numargs = 1;
-	args->out_args[0].size = count;
+	args->out_numargs = 2;
+	fuse_zero_out_arg0(args);
+	args->out_args[1].size = count;
 }
 
 static void fuse_release_user_pages(struct fuse_args_pages *ap, ssize_t nres,
@@ -711,7 +712,7 @@ static void fuse_aio_complete_req(struct fuse_mount *fm, struct fuse_args *args,
 				      ia->write.out.size;
 		}
 	} else {
-		u32 outsize = args->out_args[0].size;
+		u32 outsize = args->out_args[1].size;
 
 		nres = outsize;
 		if (ia->read.in.size != outsize)
@@ -870,7 +871,7 @@ static void fuse_readpages_end(struct fuse_mount *fm, struct fuse_args *args,
 	struct fuse_io_args *ia = container_of(args, typeof(*ia), ap.args);
 	struct fuse_args_pages *ap = &ia->ap;
 	size_t count = ia->read.in.size;
-	size_t num_read = args->out_args[0].size;
+	size_t num_read = args->out_args[1].size;
 	struct address_space *mapping;
 	struct inode *inode;
 
@@ -1506,7 +1507,7 @@ static int fuse_get_user_pages(struct fuse_args_pages *ap, struct iov_iter *ii,
 			if (write)
 				ap->args.in_args[1].value = user_addr;
 			else
-				ap->args.out_args[0].value = user_addr;
+				ap->args.out_args[1].value = user_addr;
 
 			iov_iter_advance(ii, frag_size);
 			*nbytesp = frag_size;
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 34541801d950..e45126d792a6 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -1026,6 +1026,12 @@ static inline void fuse_zero_in_arg0(struct fuse_args *args)
 	args->in_args[0].value = NULL;
 }
 
+static inline void fuse_zero_out_arg0(struct fuse_args *args)
+{
+	args->out_args[0].size = sizeof(struct fuse_zero_header);
+	args->out_args[0].value = NULL;
+}
+
 static inline struct fuse_mount *get_fuse_mount_super(struct super_block *sb)
 {
 	return sb->s_fs_info;
diff --git a/fs/fuse/readdir.c b/fs/fuse/readdir.c
index c2aae2eef086..d80cd2bedabe 100644
--- a/fs/fuse/readdir.c
+++ b/fs/fuse/readdir.c
@@ -349,7 +349,7 @@ static int fuse_readdir_uncached(struct file *file, struct dir_context *ctx)
 	if (!buf)
 		return -ENOMEM;
 
-	args->out_args[0].value = buf;
+	args->out_args[1].value = buf;
 
 	plus = fuse_use_readdirplus(inode, ctx);
 	if (plus) {
diff --git a/fs/fuse/xattr.c b/fs/fuse/xattr.c
index aa0881162287..4011a99abd52 100644
--- a/fs/fuse/xattr.c
+++ b/fs/fuse/xattr.c
@@ -70,12 +70,14 @@ ssize_t fuse_getxattr(struct inode *inode, const char *name, void *value,
 	args.in_args[1].size = strlen(name) + 1;
 	args.in_args[1].value = name;
 	/* This is really two different operations rolled into one */
-	args.out_numargs = 1;
 	if (size) {
 		args.out_argvar = true;
-		args.out_args[0].size = size;
-		args.out_args[0].value = value;
+		args.out_numargs = 2;
+		fuse_zero_out_arg0(&args);
+		args.out_args[1].size = size;
+		args.out_args[1].value = value;
 	} else {
+		args.out_numargs = 1;
 		args.out_args[0].size = sizeof(outarg);
 		args.out_args[0].value = &outarg;
 	}
@@ -132,12 +134,14 @@ ssize_t fuse_listxattr(struct dentry *entry, char *list, size_t size)
 	args.in_args[0].size = sizeof(inarg);
 	args.in_args[0].value = &inarg;
 	/* This is really two different operations rolled into one */
-	args.out_numargs = 1;
 	if (size) {
 		args.out_argvar = true;
-		args.out_args[0].size = size;
-		args.out_args[0].value = list;
+		args.out_numargs = 2;
+		fuse_zero_out_arg0(&args);
+		args.out_args[1].size = size;
+		args.out_args[1].value = list;
 	} else {
+		args.out_numargs = 1;
 		args.out_args[0].size = sizeof(outarg);
 		args.out_args[0].value = &outarg;
 	}
-- 
2.47.3


