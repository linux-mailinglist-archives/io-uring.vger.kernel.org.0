Return-Path: <io-uring+bounces-4031-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E30F9B0503
	for <lists+io-uring@lfdr.de>; Fri, 25 Oct 2024 16:05:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E173283E5F
	for <lists+io-uring@lfdr.de>; Fri, 25 Oct 2024 14:05:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F20470820;
	Fri, 25 Oct 2024 14:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="mzeHa1mB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905EE1FB880
	for <io-uring@vger.kernel.org>; Fri, 25 Oct 2024 14:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729865122; cv=none; b=S2Rxn6mGUFLSCHhW7eMwFMvIvzELXG3lPmYjA4UtspuZk/G2B+2Ni3/wXTzXM11c10lbQ0c/AJX7sfXqkBQdM6upfa0DYfjoTeLVmmJ0c6ELUVGO/M1+w0BBMSzIaWDLsf8n3y5E6b8J5kNJolJWfbhr6m3gcaHYo5Q+7Y90kwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729865122; c=relaxed/simple;
	bh=j3VmYIUYlyBTGlqvUIMc0JUgVTjmWoaF5EMC9Dn7Zk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XxgOov9xh5TQqwqaptH2E6/C50GicdM1IG7mSSSwx94k01RQz+iWk98otxGxLWqzAUGYQYZeNBjkSBq6pg2VViXYbvDvJpiopK9cCuv0FD+Ixz4/x7la03vgVx6GbW0mfSD3xq5UF1cCvOT3CjLgadGAW3oiVYHwnxCTbkMOGuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=mzeHa1mB; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-83ab5b4b048so84650939f.2
        for <io-uring@vger.kernel.org>; Fri, 25 Oct 2024 07:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729865118; x=1730469918; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5+0vcL80oErDAtwoUFPo8e5XBLS2uO6xNRw7O3/obNg=;
        b=mzeHa1mBDyH0K8dMHWbvgphE5zEvZhuurtPcxo25caUcBeZkd+d29OMZ7bHCmjPwMe
         7e/440f3mk6+E+5InDA6Zq9bqmt9o2uN1LSsRPZ0WS74duQy4Gefu1rnhFa6Tj2DQcd5
         PssLkSZPZlzp/9ecdMFoQCzivE0mLex2b4SlHfTPDArTssIjOLk0K5XjzcQVmst3REEc
         zmTx3ZfsgZ86TLzQmk9IBeZk6oCYdtgQ1RpwR+64oSkRHJBPdctjb+KZw2dZxFzfIsyL
         MCbyWnEvs6+nfw7l2qL5hcBAa34Lp2kVPTTx57Vdq/XlRDooPCN6kgx2rtpCEjUkbG+X
         SH/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729865118; x=1730469918;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5+0vcL80oErDAtwoUFPo8e5XBLS2uO6xNRw7O3/obNg=;
        b=iTshyvQLG7BCKc/osYnICrDGzvczL+rK8/Ef5M63rBU1OdFaU4Wbt+BhENRKu4pGJu
         3oFA4H0R/5IKsqTF9h2Y0jsALQy6D+rUAecnAU1MShOqIWVYVp/0z0WLv+qQ3GnzM5Zr
         X1gHzPrlUvYRB/p9kSwubdbGMIoHXswWterv2dALZ/x5A6mLQF7JuktmBE+NX0dcycNg
         7qe13HDC/cEv2zgheLmjRyhqDDpoEkaYDMG0OxRPOex5D8Sv6HO2kVp0Drg2PjI8KYSX
         p7LvpxsSCIEXMahvoo2wcO80nA75N6It+YrjTh8554/ADO6x+UkwYnpbEjoWHiWOORHK
         4yww==
X-Gm-Message-State: AOJu0YyOzrbISKFD+Fd391qYNpYIjQ2JOnIj84R6sLhpWFwt6EhF7n7d
	woV1d4LRb2P3sj5DwqZ5R7vt7jT7wMSbSkHz/aGbXHvIga56fWtnEKcHeSDnDFW1yIQN75H/AZS
	4
X-Google-Smtp-Source: AGHT+IE3yo7YcZ6vLqWajl28vIH83Z4pmh+4jZ+w/3RxHU73dqNsMByGtc3eyPU7HbNv/Ib41v+06A==
X-Received: by 2002:a05:6e02:1522:b0:39b:330b:bb25 with SMTP id e9e14a558f8ab-3a4de7a2df5mr63978055ab.12.1729865118074;
        Fri, 25 Oct 2024 07:05:18 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a4e6e56641sm2924635ab.65.2024.10.25.07.05.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2024 07:05:16 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: jannh@google.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/4] io_uring: abstract out a bit of the ring filling logic
Date: Fri, 25 Oct 2024 08:02:29 -0600
Message-ID: <20241025140502.167623-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241025140502.167623-2-axboe@kernel.dk>
References: <20241025140502.167623-2-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Abstract out a io_uring_fill_params() helper, which fills out the
necessary bits of struct io_uring_params. Add it to io_uring.h as well,
in preparation for having another internal user of it.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 70 ++++++++++++++++++++++++++-------------------
 io_uring/io_uring.h |  1 +
 2 files changed, 41 insertions(+), 30 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 6dea5242d666..b5974bdad48b 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3498,14 +3498,8 @@ static struct file *io_uring_get_file(struct io_ring_ctx *ctx)
 					 O_RDWR | O_CLOEXEC, NULL);
 }
 
-static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
-				  struct io_uring_params __user *params)
+int io_uring_fill_params(unsigned entries, struct io_uring_params *p)
 {
-	struct io_ring_ctx *ctx;
-	struct io_uring_task *tctx;
-	struct file *file;
-	int ret;
-
 	if (!entries)
 		return -EINVAL;
 	if (entries > IORING_MAX_ENTRIES) {
@@ -3547,6 +3541,42 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 		p->cq_entries = 2 * p->sq_entries;
 	}
 
+	p->sq_off.head = offsetof(struct io_rings, sq.head);
+	p->sq_off.tail = offsetof(struct io_rings, sq.tail);
+	p->sq_off.ring_mask = offsetof(struct io_rings, sq_ring_mask);
+	p->sq_off.ring_entries = offsetof(struct io_rings, sq_ring_entries);
+	p->sq_off.flags = offsetof(struct io_rings, sq_flags);
+	p->sq_off.dropped = offsetof(struct io_rings, sq_dropped);
+	p->sq_off.resv1 = 0;
+	if (!(p->flags & IORING_SETUP_NO_MMAP))
+		p->sq_off.user_addr = 0;
+
+	p->cq_off.head = offsetof(struct io_rings, cq.head);
+	p->cq_off.tail = offsetof(struct io_rings, cq.tail);
+	p->cq_off.ring_mask = offsetof(struct io_rings, cq_ring_mask);
+	p->cq_off.ring_entries = offsetof(struct io_rings, cq_ring_entries);
+	p->cq_off.overflow = offsetof(struct io_rings, cq_overflow);
+	p->cq_off.cqes = offsetof(struct io_rings, cqes);
+	p->cq_off.flags = offsetof(struct io_rings, cq_flags);
+	p->cq_off.resv1 = 0;
+	if (!(p->flags & IORING_SETUP_NO_MMAP))
+		p->cq_off.user_addr = 0;
+
+	return 0;
+}
+
+static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
+				  struct io_uring_params __user *params)
+{
+	struct io_ring_ctx *ctx;
+	struct io_uring_task *tctx;
+	struct file *file;
+	int ret;
+
+	ret = io_uring_fill_params(entries, p);
+	if (unlikely(ret))
+		return ret;
+
 	ctx = io_ring_ctx_alloc(p);
 	if (!ctx)
 		return -ENOMEM;
@@ -3630,6 +3660,9 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	if (ret)
 		goto err;
 
+	if (!(p->flags & IORING_SETUP_NO_SQARRAY))
+		p->sq_off.array = (char *)ctx->sq_array - (char *)ctx->rings;
+
 	ret = io_sq_offload_create(ctx, p);
 	if (ret)
 		goto err;
@@ -3638,29 +3671,6 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	if (ret)
 		goto err;
 
-	p->sq_off.head = offsetof(struct io_rings, sq.head);
-	p->sq_off.tail = offsetof(struct io_rings, sq.tail);
-	p->sq_off.ring_mask = offsetof(struct io_rings, sq_ring_mask);
-	p->sq_off.ring_entries = offsetof(struct io_rings, sq_ring_entries);
-	p->sq_off.flags = offsetof(struct io_rings, sq_flags);
-	p->sq_off.dropped = offsetof(struct io_rings, sq_dropped);
-	if (!(ctx->flags & IORING_SETUP_NO_SQARRAY))
-		p->sq_off.array = (char *)ctx->sq_array - (char *)ctx->rings;
-	p->sq_off.resv1 = 0;
-	if (!(ctx->flags & IORING_SETUP_NO_MMAP))
-		p->sq_off.user_addr = 0;
-
-	p->cq_off.head = offsetof(struct io_rings, cq.head);
-	p->cq_off.tail = offsetof(struct io_rings, cq.tail);
-	p->cq_off.ring_mask = offsetof(struct io_rings, cq_ring_mask);
-	p->cq_off.ring_entries = offsetof(struct io_rings, cq_ring_entries);
-	p->cq_off.overflow = offsetof(struct io_rings, cq_overflow);
-	p->cq_off.cqes = offsetof(struct io_rings, cqes);
-	p->cq_off.flags = offsetof(struct io_rings, cq_flags);
-	p->cq_off.resv1 = 0;
-	if (!(ctx->flags & IORING_SETUP_NO_MMAP))
-		p->cq_off.user_addr = 0;
-
 	p->features = IORING_FEAT_SINGLE_MMAP | IORING_FEAT_NODROP |
 			IORING_FEAT_SUBMIT_STABLE | IORING_FEAT_RW_CUR_POS |
 			IORING_FEAT_CUR_PERSONALITY | IORING_FEAT_FAST_POLL |
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 4a471a810f02..e3e6cb14de5d 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -70,6 +70,7 @@ static inline bool io_should_wake(struct io_wait_queue *iowq)
 
 unsigned long rings_size(unsigned int flags, unsigned int sq_entries,
 			 unsigned int cq_entries, size_t *sq_offset);
+int io_uring_fill_params(unsigned entries, struct io_uring_params *p);
 bool io_cqe_cache_refill(struct io_ring_ctx *ctx, bool overflow);
 int io_run_task_work_sig(struct io_ring_ctx *ctx);
 void io_req_defer_failed(struct io_kiocb *req, s32 res);
-- 
2.45.2


