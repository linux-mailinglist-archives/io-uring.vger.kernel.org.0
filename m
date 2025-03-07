Return-Path: <io-uring+bounces-6983-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C761A56C84
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 16:48:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8A40F18907A4
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 15:48:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0723921D008;
	Fri,  7 Mar 2025 15:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K2t0nmGB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284DC21D3C0
	for <io-uring@vger.kernel.org>; Fri,  7 Mar 2025 15:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741362494; cv=none; b=hBwBmZvP61EDarIgmu0ECqYSkftSJ0u3+/W0EUhJE0I/ddCGBzDgxO9VAsXOyOjaGxk73a4rUtDQ+1invTMU745U1F948fxdO2xeGaIK0Rc4AaRK+fxQx/V9/FFS7uP+aKtA1iiPB8HFAewJp/KbYZw0q+Wcu2LcsFbYKbcG7wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741362494; c=relaxed/simple;
	bh=Q8PdENXAiLSA678FCapF070tkBMsP1ce5Gykksi+Hcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KUlBje9DnuvRzp8VStNbS+tVeuzT5wB6+QZB1osUoSnTCBRqxkH8YusJ8kZXdWZM7ibK+5GEZGgf1guilyRDeg5Ijuy+0k6DEklqRbLHSWxGe7JruH0/iRbnsE8hiGf2xkp3YiGcGR4K+tXlRDADsz1fv3NE6HzaxnlhpqrCqGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K2t0nmGB; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5e0b70fb1daso3683873a12.1
        for <io-uring@vger.kernel.org>; Fri, 07 Mar 2025 07:48:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741362491; x=1741967291; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oGewhYsabKASpjkFax+fSFYao6hHzoa78HnivAvFalA=;
        b=K2t0nmGB/hheIbzQodTNIxD26WRp6axmjKHOiF2WN6ts2DWmZNx93Jp8pb3a7a/gLw
         te7Fwsp2mfr4a6olb8bSd+ORjtmtozvmgj4GoMRTpeijvQNO6sjVuVIlohA8+3quYdFg
         PU12NbX2xo568tORS/9mgflFGfG+MawX78cSIYYf+r9JHlHThe/zzDXQ5nePRnAhNJqw
         RlIYcAiV7bcPRe1vLCUBfQSekJR7zsBbjssRK4H/RivPqDyDsTfy/Fhxf2iT4mKR9R4m
         z7jUCgxisBtHjIE2lmIkPfKlgLayT8XqvxTD6UTy4MqSVvLEG2YgdOyRUSYMhg0G/cT6
         rLWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741362491; x=1741967291;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oGewhYsabKASpjkFax+fSFYao6hHzoa78HnivAvFalA=;
        b=m6ypTyClkVVdIPqDyhMN3euLs1UTzYWd8cZHZJ/zGKoxqHb1BOPb7HW0GMpctOJ+ix
         Hs540N/scfjLk0pbaWYQj9ewZRRnbE4dnGBVGwH/xlqRM31jbfFaHIkdQOJLR90hPx9L
         sVNQKE7EQnY/un7ZHmRyoWmBdxc/X1B3V9iPMgrxMD5tJSCW7ESoYLzsPMPuW9MLwN4O
         dQFmiwetp5fYnNJWFGR++3iHG716f4Itrr7JZIoa8wHIJjGzCDHxE9YCdYPGv5hK/FkW
         jcmycB4bofxlasAwLpWQOWBoe2HZeHH/mCuEzi9ClP35vSmOFMzffYngtYzCsWCSDamh
         IhAA==
X-Gm-Message-State: AOJu0YzYaSakAgT5+2Ifrbzhi3MlmR85W18b/W/MUyVjaex71Q+YaNig
	nqm1xFdSKBmLbmpsuDZ3UbQJyGuzjxcA88iSq1GJchRhAcq0f+dyWUcaNQ==
X-Gm-Gg: ASbGncsvdksUdJWKKoY6Kx1BCB5PQCfqEykQLuXz3yCGOdZSSkSQW3JicUR6tZ+T3AI
	ZnFn79SzFWAzAjtvfTjUAedCqbkVDq5yl5UOICuLDumMqXVbzMdZxuoHcgoS6tdJX9zG7X8/IHP
	CXb10s4JjDgVJeQOvoLvQvFYAU+5BFG5DpwJWSbKopywN0V333oypqc3KRjrd3Lg86A+4EzKf3K
	TQK0iRSc2M20S+yyoVWFyT0Gi7pinJRBOc/npbqiKgRcZzlVO6uA+tL6Nat7m4gDPw7o9DoH5F6
	g6WgPp0CFsu35o1yl0Wkl+gUpHFr
X-Google-Smtp-Source: AGHT+IF9rUDg+UlQM7x7vGlNMJkJgvGM91lCW0qlgToELVBvIkY5ymi3nTOLLoMQa43wgi3OFpcGbA==
X-Received: by 2002:a05:6402:518a:b0:5d9:82bc:ad06 with SMTP id 4fb4d7f45d1cf-5e5e22bf16amr4766917a12.3.1741362490583;
        Fri, 07 Mar 2025 07:48:10 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:1422])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e5c766a033sm2665591a12.56.2025.03.07.07.48.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 07:48:09 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 1/9] io_uring: introduce struct iou_vec
Date: Fri,  7 Mar 2025 15:49:02 +0000
Message-ID: <a605b7474a814ae7f28a057bfefa127f5b86187c.1741361926.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1741361926.git.asml.silence@gmail.com>
References: <cover.1741361926.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I need a convenient way to pass around and work with iovec+size pair,
put them into a structure and makes use of it in rw.c

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  5 +++++
 io_uring/rsrc.c                |  9 +++++++++
 io_uring/rsrc.h                | 17 +++++++++++++++++
 io_uring/rw.c                  | 17 +++++++----------
 io_uring/rw.h                  |  4 ++--
 5 files changed, 40 insertions(+), 12 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 35fc241c4672..9101f12d21ef 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -110,6 +110,11 @@ struct io_uring_task {
 	} ____cacheline_aligned_in_smp;
 };
 
+struct iou_vec {
+	struct iovec		*iovec;
+	unsigned		nr;
+};
+
 struct io_uring {
 	u32 head;
 	u32 tail;
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 28783f1dde00..bac509f85c80 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1260,3 +1260,12 @@ int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg)
 	fput(file);
 	return ret;
 }
+
+void io_vec_free(struct iou_vec *iv)
+{
+	if (!iv->iovec)
+		return;
+	kfree(iv->iovec);
+	iv->iovec = NULL;
+	iv->nr = 0;
+}
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 284e300e63fb..ff78ead6bc75 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -4,6 +4,7 @@
 
 #include <linux/io_uring_types.h>
 #include <linux/lockdep.h>
+#include <linux/io_uring_types.h>
 
 enum {
 	IORING_RSRC_FILE		= 0,
@@ -145,4 +146,20 @@ static inline void __io_unaccount_mem(struct user_struct *user,
 	atomic_long_sub(nr_pages, &user->locked_vm);
 }
 
+void io_vec_free(struct iou_vec *iv);
+
+static inline void io_vec_reset_iovec(struct iou_vec *iv,
+				      struct iovec *iovec, unsigned nr)
+{
+	io_vec_free(iv);
+	iv->iovec = iovec;
+	iv->nr = nr;
+}
+
+static inline void io_alloc_cache_vec_kasan(struct iou_vec *iv)
+{
+	if (IS_ENABLED(CONFIG_KASAN))
+		io_vec_free(iv);
+}
+
 #endif
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 5ee9f8949e8b..ad7f647d48e9 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -87,9 +87,9 @@ static int io_import_vec(int ddir, struct io_kiocb *req,
 	int ret, nr_segs;
 	struct iovec *iov;
 
-	if (io->free_iovec) {
-		nr_segs = io->free_iov_nr;
-		iov = io->free_iovec;
+	if (io->vec.iovec) {
+		nr_segs = io->vec.nr;
+		iov = io->vec.iovec;
 	} else {
 		nr_segs = 1;
 		iov = &io->fast_iov;
@@ -101,9 +101,7 @@ static int io_import_vec(int ddir, struct io_kiocb *req,
 		return ret;
 	if (iov) {
 		req->flags |= REQ_F_NEED_CLEANUP;
-		io->free_iov_nr = io->iter.nr_segs;
-		kfree(io->free_iovec);
-		io->free_iovec = iov;
+		io_vec_reset_iovec(&io->vec, iov, io->iter.nr_segs);
 	}
 	return 0;
 }
@@ -151,7 +149,7 @@ static void io_rw_recycle(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(issue_flags & IO_URING_F_UNLOCKED))
 		return;
 
-	io_alloc_cache_kasan(&rw->free_iovec, &rw->free_iov_nr);
+	io_alloc_cache_vec_kasan(&rw->vec);
 	if (io_alloc_cache_put(&req->ctx->rw_cache, rw)) {
 		req->async_data = NULL;
 		req->flags &= ~REQ_F_ASYNC_DATA;
@@ -201,7 +199,7 @@ static int io_rw_alloc_async(struct io_kiocb *req)
 	rw = io_uring_alloc_async_data(&ctx->rw_cache, req);
 	if (!rw)
 		return -ENOMEM;
-	if (rw->free_iovec)
+	if (rw->vec.iovec)
 		req->flags |= REQ_F_NEED_CLEANUP;
 	rw->bytes_done = 0;
 	return 0;
@@ -1327,7 +1325,6 @@ void io_rw_cache_free(const void *entry)
 {
 	struct io_async_rw *rw = (struct io_async_rw *) entry;
 
-	if (rw->free_iovec)
-		kfree(rw->free_iovec);
+	io_vec_free(&rw->vec);
 	kfree(rw);
 }
diff --git a/io_uring/rw.h b/io_uring/rw.h
index bf121b81ebe8..529fd2f96a7f 100644
--- a/io_uring/rw.h
+++ b/io_uring/rw.h
@@ -9,13 +9,13 @@ struct io_meta_state {
 };
 
 struct io_async_rw {
+	struct iou_vec			vec;
 	size_t				bytes_done;
-	struct iovec			*free_iovec;
+
 	struct_group(clear,
 		struct iov_iter			iter;
 		struct iov_iter_state		iter_state;
 		struct iovec			fast_iov;
-		int				free_iov_nr;
 		/*
 		 * wpq is for buffered io, while meta fields are used with
 		 * direct io
-- 
2.48.1


