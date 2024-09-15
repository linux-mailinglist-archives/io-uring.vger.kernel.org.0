Return-Path: <io-uring+bounces-3192-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03E5397977E
	for <lists+io-uring@lfdr.de>; Sun, 15 Sep 2024 17:23:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B99DB282170
	for <lists+io-uring@lfdr.de>; Sun, 15 Sep 2024 15:23:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 391821C7B99;
	Sun, 15 Sep 2024 15:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="rO/FXFOh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C81971C8FA6
	for <io-uring@vger.kernel.org>; Sun, 15 Sep 2024 15:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726413807; cv=none; b=JR4XIYF9zT2SIYFSd6MDLpPhmCU8UWz1NgQ2ZM3Q83uSBsImkrQwcIkhYH/8G5XBcgHe5Q8O3E/bBhad1LvukeKTq55pvQQiHMobaUNIBsNTzQoFSJ2N0tra/qd68FbcJyWuS2UkbaSEzeq/gxWvL4HZM38T1H1lRFGNIX3D1l8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726413807; c=relaxed/simple;
	bh=S2F1uBzjRNQnrkV7+JPFKaUnkMKjLRDrjZAMd/eXRHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FR9/Uc8uTbnaF0lBo0qZhTEzsrb/vPYVKPfq8IAkfBz3aPNMyqwzZEpS5CnE1D3e0VSO2d3tc0VvVCw9sLqLFVn4+9Cle5XUqRbCMauPqca6JK49ZFuB/alLlbIw7Z6Vx5J1wUUKvzPGJo6MkWja+H0coQ9ZISS54UXOM46BiH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=rO/FXFOh; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2068acc8a4fso21987425ad.1
        for <io-uring@vger.kernel.org>; Sun, 15 Sep 2024 08:23:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726413803; x=1727018603; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OVU30hcfgfZmc5/oV8zT/i63y8UtewElLCRs86OSyV0=;
        b=rO/FXFOhnuRlqb4d3lfVlAutNLi7xkE7LC6rLF8pLsPl9fkUq/yDWe5a/x01h5XiVG
         Q0AlOxYiISCTPeySF1aFahMuVkcT0IRA8wvA34vCcUFzhQAsql5yIK4Wu8byFnlYMTMC
         9I3ztboBMIbi0A+biqolPcG2kCZRy1t3u5WrLHTW892OgN5/biBCCVWjHaXoJ1PFNtVO
         IUfuN7UHC9o+qYdchMB93RUeeaqKxNuCgR15YXdo0jD4kxDVAEMlgexsT556CVPbHMtn
         Nf/KUTbL26fBqnVxXGXC9YRLfZTYmcX5hDezXMV1QskX62C2RyJsov3ogvmLxhX1WYUV
         8BIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726413803; x=1727018603;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OVU30hcfgfZmc5/oV8zT/i63y8UtewElLCRs86OSyV0=;
        b=AwWm3sJajiwiLq5AC20fYTmlpa3uAf0J5x/mB/Rxe7HA04m0Jrk0Ht3P8m3jYWKrOV
         NLoMvvS2T1kKs5bCvv7Edloa3ruqqzYgbEeVPTWyGmIUGFiyD7/vZkKilyylPMGH8waK
         N06U06hupjiUxCtyXAyj8LFAbUpg1ekYqK5DIELE/kjuGuIfxlmHhIxkM72scX+QyHJ4
         6ItM1CY9Yh9JoqvG9IlsGINO2aaxHD6tASRCzOaJyH8XIRreSR3Q7+pr6uTGApFGKHQr
         lAfVeQBewg0ik90bN5vP1miuufDI1GgquGAw+MsAyY0BQT3vuDBvGgJcDe9it41sMbc9
         oSjw==
X-Gm-Message-State: AOJu0YyAMjUXGaK7pz04vOqATTjs5XCSjEcxjNQSZ+pdT1AMISFM+ilK
	vNBHfqpIm0sNkXdYyQTLwRUH/WYjZvKIbUQgWfPENVFXiE1TxgqWWz+0cPKg9DGHe0vxsTeXqEp
	P
X-Google-Smtp-Source: AGHT+IGGloJOUgPGHVr2ZQcxEV+vId5Pjt+IjLRf+dzLpmnIIGBTQSvcnV4zeWsOWCPrdrxWxBHQXg==
X-Received: by 2002:a17:902:e54e:b0:206:c8dc:e334 with SMTP id d9443c01a7336-20782be4dc3mr131963805ad.39.1726413802604;
        Sun, 15 Sep 2024 08:23:22 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-207964a5ec4sm22083755ad.232.2024.09.15.08.23.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Sep 2024 08:23:21 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: cliang01.li@samsung.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring/rsrc: change ubuf->ubuf_end to length tracking
Date: Sun, 15 Sep 2024 09:22:35 -0600
Message-ID: <20240915152315.821382-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240915152315.821382-1-axboe@kernel.dk>
References: <20240915152315.821382-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If we change it to tracking ubuf->start + ubuf->len, then we can reduce
the size of struct io_mapped_ubuf by another 4 bytes, effectively 8
bytes, as a hole is eliminated too.

This shrinks io_mapped_ubuf to 32 bytes.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/fdinfo.c | 3 +--
 io_uring/rsrc.c   | 6 +++---
 io_uring/rsrc.h   | 4 ++--
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index d43e1b5fcb36..6b1247664b35 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -177,9 +177,8 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
 	seq_printf(m, "UserBufs:\t%u\n", ctx->nr_user_bufs);
 	for (i = 0; has_lock && i < ctx->nr_user_bufs; i++) {
 		struct io_mapped_ubuf *buf = ctx->user_bufs[i];
-		unsigned int len = buf->ubuf_end - buf->ubuf;
 
-		seq_printf(m, "%5u: 0x%llx/%u\n", i, buf->ubuf, len);
+		seq_printf(m, "%5u: 0x%llx/%u\n", i, buf->ubuf, buf->len);
 	}
 	if (has_lock && !xa_empty(&ctx->personalities)) {
 		unsigned long index;
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 2477995e2d65..131bcdda577a 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -38,7 +38,7 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 static const struct io_mapped_ubuf dummy_ubuf = {
 	/* set invalid range, so io_import_fixed() fails meeting it */
 	.ubuf = -1UL,
-	.ubuf_end = 0,
+	.len = UINT_MAX,
 };
 
 int __io_account_mem(struct user_struct *user, unsigned long nr_pages)
@@ -985,7 +985,7 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 	size = iov->iov_len;
 	/* store original address for later verification */
 	imu->ubuf = (unsigned long) iov->iov_base;
-	imu->ubuf_end = imu->ubuf + iov->iov_len;
+	imu->len = iov->iov_len;
 	imu->nr_bvecs = nr_pages;
 	imu->folio_shift = PAGE_SHIFT;
 	if (coalesced)
@@ -1086,7 +1086,7 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
 	if (unlikely(check_add_overflow(buf_addr, (u64)len, &buf_end)))
 		return -EFAULT;
 	/* not inside the mapped region */
-	if (unlikely(buf_addr < imu->ubuf || buf_end > imu->ubuf_end))
+	if (unlikely(buf_addr < imu->ubuf || buf_end > (imu->ubuf + imu->len)))
 		return -EFAULT;
 
 	/*
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index e290d2be3285..8ed588036210 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -42,11 +42,11 @@ struct io_rsrc_node {
 
 struct io_mapped_ubuf {
 	u64		ubuf;
-	u64		ubuf_end;
+	unsigned int	len;
 	unsigned int	nr_bvecs;
 	unsigned int    folio_shift;
-	unsigned long	acct_pages;
 	refcount_t	refs;
+	unsigned long	acct_pages;
 	struct bio_vec	bvec[] __counted_by(nr_bvecs);
 };
 
-- 
2.45.2


