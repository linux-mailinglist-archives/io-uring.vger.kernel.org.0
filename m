Return-Path: <io-uring+bounces-1174-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CF5F58819B5
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 23:58:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 472801F227CE
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 22:58:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA763381D1;
	Wed, 20 Mar 2024 22:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="XP7oOtw2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 259D085C7B
	for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 22:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710975497; cv=none; b=LQCbeIXMU0kISUo/SWjJKID27HIawyZaKk6RMjX92zVRus8ZdFd/rM9KyRY280JazwDL+5ZKwFr5hPkwU1Y2nsH9hc0lcHYHf1/1KxwWZLW3DmP/bMnLIUVPGR+vWRJAaNDE9r7pc+jKUcuCHf6sBYMq9hvrk6c2sKb4dvHgBuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710975497; c=relaxed/simple;
	bh=bB/99Sql5QhvGfpvnuMj+twJX5qvjPZVN7MMuR6CJdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=saxG2/gWoQCltXAkm2jolpA2jdsctr3pQJSOZ0bR+jpAPlOUkrxyNQnZ7QLyWm3R0cmUHYxGrnpFiiyElP0zGAhKaBEbo27MruVMYo7jHW9SMoSHz5q3KAKKRnGaJ9mOrLDZHsDJO30HYgeNpkXwcoJG7aX+zoxCSJsJbW5WLQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=XP7oOtw2; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-7c8e4c0412dso3588839f.1
        for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 15:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710975495; x=1711580295; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QQvAjh5Wpcw+bcAzkV2ljLDRQuX/cONcnXkTdAOR3TI=;
        b=XP7oOtw2HB3YeGtqOCIrjQc0j5J2mCoWJh3KPbFP+xkQpf6JcRAqWrapYP/BpMBFs1
         GpMlJRt656TdV2aMZ/4GnCgCvGJzNsQ0lm27t4/lrAYw3MNb5cS8BPmVanTsAXV8z9qq
         ejV3/tf6LrX3ACbdYQ0/hgFb7pY5vnFPq8leiDtz1y+dtel9MUMGAG74gfPIVzuahj7s
         kM/5sBXQ3GVeDV3JUyx16np/ZzJxCvisMju1R/20+jz8FaQYD2nvwkOiwMU9WUlMUGdQ
         UXnCFDHcKg448CWaDlni/NZsSVkAAtzrjLNZ3HQ6/ZR+A5IqcJ1HwG+faloiJxhhbvbx
         Zv9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710975495; x=1711580295;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QQvAjh5Wpcw+bcAzkV2ljLDRQuX/cONcnXkTdAOR3TI=;
        b=r5jk1mvJYJix7O/y0cv8vUHNVj+QR/x1U00NgryTC3Lprq9BWoHwFq6GSCvy+4LKht
         DFfeOfT4R3ALoVgFWIXWn8aw22S/Ky+Nqr+63zO1uNJmFjsrnr2AT4bDMYcAQap5QtlX
         zzT6GpeD/TLsMdmnasxrLd9Y4hpXWoRITXNx2ILMee33A1NEX6YBicB6TR/fC7EhsNxM
         USKzsEURFNf+Jb75NK7SGKiY36kzyhmvALQ2Ud1Akx1mgTKdM9aAG/O2bA6Sun4Fu0OE
         DdP8G8l7xhaOIOnD/7ktt6Y0nCPpDYnq0y3H030r4UWlHJXLzHrF7BGuS3UH9nKKeHG2
         yyhg==
X-Gm-Message-State: AOJu0YxP7doJ4awqxGEnfJWN/8AwExMSt1DW/IJgClcORaJaoRWMHfL9
	d6IXgE8MGnS6xriNu6d4S4J2Oh81Qq6nk5dM0ZnH2R6Uj532dRxvO9yr3CM5gKTzLimQX+9E5s+
	X
X-Google-Smtp-Source: AGHT+IGzs737Fq5BWxZDi55vn8UwF2s9qG9jHRK9epOcRrhEqftaF2Q11PXbSYiaKQfP7cFpNvdQRw==
X-Received: by 2002:a6b:5108:0:b0:7ce:f407:1edf with SMTP id f8-20020a6b5108000000b007cef4071edfmr6851731iob.0.1710975494826;
        Wed, 20 Mar 2024 15:58:14 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id z19-20020a6b0a13000000b007cf23a498dcsm434384ioi.38.2024.03.20.15.58.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Mar 2024 15:58:13 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 12/17] io_uring/rw: add iovec recycling
Date: Wed, 20 Mar 2024 16:55:27 -0600
Message-ID: <20240320225750.1769647-13-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240320225750.1769647-1-axboe@kernel.dk>
References: <20240320225750.1769647-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Let the io_async_rw hold on to the iovec and reuse it, rather than always
allocate and free them.

Also enables KASAN for the iovec entries, so that reuse can be detected
even while they are in the cache.

While doing so, shrink io_async_rw by getting rid of the bigger embedded
fast iovec. Since iovecs are being recycled now, shrink it from 8 to 1.
This reduces the io_async_rw size from 264 to 160 bytes, a 40% reduction.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/rw.c | 42 +++++++++++++++++++++++++++++++++++++-----
 io_uring/rw.h |  3 ++-
 2 files changed, 39 insertions(+), 6 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 19e866929cd3..57f2d315a620 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -81,7 +81,9 @@ static int __io_import_iovec(int ddir, struct io_kiocb *req,
 {
 	const struct io_issue_def *def = &io_issue_defs[req->opcode];
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
+	struct iovec *iov;
 	void __user *buf;
+	int nr_segs, ret;
 	size_t sqe_len;
 
 	buf = u64_to_user_ptr(rw->addr);
@@ -99,9 +101,24 @@ static int __io_import_iovec(int ddir, struct io_kiocb *req,
 		return import_ubuf(ddir, buf, sqe_len, &io->iter);
 	}
 
-	io->free_iovec = io->fast_iov;
-	return __import_iovec(ddir, buf, sqe_len, UIO_FASTIOV, &io->free_iovec,
-				&io->iter, req->ctx->compat);
+	if (io->free_iovec) {
+		nr_segs = io->free_iov_nr;
+		iov = io->free_iovec;
+	} else {
+		iov = &io->fast_iov;
+		nr_segs = 1;
+	}
+	ret = __import_iovec(ddir, buf, sqe_len, nr_segs, &iov, &io->iter,
+				req->ctx->compat);
+	if (unlikely(ret < 0))
+		return ret;
+	if (iov) {
+		req->flags |= REQ_F_NEED_CLEANUP;
+		io->free_iov_nr = io->iter.nr_segs;
+		kfree(io->free_iovec);
+		io->free_iovec = iov;
+	}
+	return 0;
 }
 
 static inline int io_import_iovec(int rw, struct io_kiocb *req,
@@ -122,6 +139,7 @@ static void io_rw_iovec_free(struct io_async_rw *rw)
 {
 	if (rw->free_iovec) {
 		kfree(rw->free_iovec);
+		rw->free_iov_nr = 0;
 		rw->free_iovec = NULL;
 	}
 }
@@ -129,12 +147,16 @@ static void io_rw_iovec_free(struct io_async_rw *rw)
 static void io_rw_recycle(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_async_rw *rw = req->async_data;
+	struct iovec *iov;
 
 	if (unlikely(issue_flags & IO_URING_F_UNLOCKED)) {
 		io_rw_iovec_free(rw);
 		return;
 	}
+	iov = rw->free_iovec;
 	if (io_alloc_cache_put(&req->ctx->rw_cache, &rw->cache)) {
+		if (iov)
+			kasan_mempool_poison_object(iov);
 		req->async_data = NULL;
 		req->flags &= ~REQ_F_ASYNC_DATA;
 	}
@@ -184,6 +206,11 @@ static int io_rw_alloc_async(struct io_kiocb *req)
 	entry = io_alloc_cache_get(&ctx->rw_cache);
 	if (entry) {
 		rw = container_of(entry, struct io_async_rw, cache);
+		if (rw->free_iovec) {
+			kasan_mempool_unpoison_object(rw->free_iovec,
+				rw->free_iov_nr * sizeof(struct iovec));
+			req->flags |= REQ_F_NEED_CLEANUP;
+		}
 		req->flags |= REQ_F_ASYNC_DATA;
 		req->async_data = rw;
 		goto done;
@@ -191,8 +218,9 @@ static int io_rw_alloc_async(struct io_kiocb *req)
 
 	if (!io_alloc_async_data(req)) {
 		rw = req->async_data;
-done:
 		rw->free_iovec = NULL;
+		rw->free_iov_nr = 0;
+done:
 		rw->bytes_done = 0;
 		return 0;
 	}
@@ -1157,6 +1185,10 @@ void io_rw_cache_free(struct io_cache_entry *entry)
 	struct io_async_rw *rw;
 
 	rw = container_of(entry, struct io_async_rw, cache);
-	kfree(rw->free_iovec);
+	if (rw->free_iovec) {
+		kasan_mempool_unpoison_object(rw->free_iovec,
+				rw->free_iov_nr * sizeof(struct iovec));
+		io_rw_iovec_free(rw);
+	}
 	kfree(rw);
 }
diff --git a/io_uring/rw.h b/io_uring/rw.h
index 7824896dc52d..cf51d0eb407a 100644
--- a/io_uring/rw.h
+++ b/io_uring/rw.h
@@ -9,8 +9,9 @@ struct io_async_rw {
 	};
 	struct iov_iter			iter;
 	struct iov_iter_state		iter_state;
-	struct iovec			fast_iov[UIO_FASTIOV];
+	struct iovec			fast_iov;
 	struct iovec			*free_iovec;
+	int				free_iov_nr;
 	struct wait_page_queue		wpq;
 };
 
-- 
2.43.0


