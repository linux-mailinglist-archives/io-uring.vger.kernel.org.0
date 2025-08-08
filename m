Return-Path: <io-uring+bounces-8915-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A8C59B1ED95
	for <lists+io-uring@lfdr.de>; Fri,  8 Aug 2025 19:04:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5FAF23A63C2
	for <lists+io-uring@lfdr.de>; Fri,  8 Aug 2025 17:03:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 806E51D2F42;
	Fri,  8 Aug 2025 17:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="okni3ed7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC526267F48
	for <io-uring@vger.kernel.org>; Fri,  8 Aug 2025 17:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754672637; cv=none; b=GucvG8NphagJpPsGUgN31VeUS2qiyWkTGmvrSsoNYZAcPpnET1YirGe1+KAPZum36ljkc7U8oJ0gSlYCCoGoBzzdTEkOoYeFjYX0JAjczSlGfZqQKNzp/zYKziujEFLFdoMDltCvXMHg75AzNurKrp1k0o10JryWQNV7uUdTtk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754672637; c=relaxed/simple;
	bh=+rYeqzjKD75xgmdy8tRDHHYXBe+lyjQCHOHFRcT2ZSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XRXQCk+Si0SCtZb/2NQFu/ZBYXZ26k4qUGN8LoIB5voAhY2uBbmUmQ6m0e+uVMTCfhMRrWRO0KHHuOkRoPisBideX+8ZahOmz/r57kObvbhhF15IGGEMfy84rznVJooecSFu2f8wIEYHuk5XXW+jO1mmn77Pv7Tna/QlXbzH4NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=okni3ed7; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-883e23706c7so166819539f.3
        for <io-uring@vger.kernel.org>; Fri, 08 Aug 2025 10:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1754672634; x=1755277434; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qQ8OpTHxmVb1lwx6Y3BFMb5dPVADy//VK3KY9e8tDt8=;
        b=okni3ed7ANTJqBR35q91EE0DnapAXnqfgdafgUybXtM0iKjMUvjZlnW86bRbeaDYgL
         zhAyd+4fnsWy3mD0mZI/ghl7+qCU8Khc3wv5FiqDotyG9FypbagcAXiA5F5D/035Hgnc
         f3/XQPFX69smTd0bo3so07cYfmhHc4YDAlyWf9pP8h0Yz80eW6XXYMqEwTlsQ0aPWdJW
         jlDX9v4jtuwRe9rmM9qFDFMT04wh9wfiZuhkwLzxyFEEpRjiiCiveEGly3hxTm51Sc0K
         Ecok7vSNFwDhAhNMdHkB5jDZG44CUDjKoOXQ4pKmEcbiC1Zt1XBtDvVRbLdyt+gSgNA/
         5ryA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754672634; x=1755277434;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qQ8OpTHxmVb1lwx6Y3BFMb5dPVADy//VK3KY9e8tDt8=;
        b=reahdamrPvEADHmJVRh3+HfotVUBmN1TIB5q1/6LHeTG3oYH50FCizTC/udWIIiImD
         6sEUlPmY6x4al8K69AmiHpor/SfOMyAkUy59ZVL6UUnyOOZJXalzl16y2N29kA3mXmT4
         Lh0yimM6UVsbUR8KNFP2tSp3SmrzmseBkQcESjfH25sFxAH/fy/9vNGjpMiJ0V3pI1Bg
         EbnqiiJZHqqUOq8b4vGcXk+P+mVR8+xXh9i7DlhWXWtErmuvwnBqiGuv/y/9f1UD0r6G
         efWQzQsuNlBgr4wx3sOcfhmGq7qbPomwBdCrhszYLmRIj4zOT1XhJV983QJCSU0YooDl
         3WLA==
X-Gm-Message-State: AOJu0YyA4C3SplH8JubOOKCsSuZ9ahje7CUfADYbhEA/uJIHN7PaU0oy
	sRRRtP0+bGaQKjhIwuq04PT7Ik7piVF/6ybcL+M7mScF0bYghzOmrvPYqEU4nlwFOwyKTsMoom6
	KNQoK
X-Gm-Gg: ASbGnctJPZOEPOcjzmBOUWruE1I4gF7BwZ2ugUqa1UdC4reU9Rkrl/7vWTZ0FHND7W1
	2eeYMYkPapi0aPtKW1VyohcYnGh4IbaKYJzwXQkFk+H559XqbR6UhiHVw8QZK1vh8V+DazbM6ux
	x2UYBhGhLBCd6SyJwIdTU25wGASWJkFF4zoYYMPo4CMbKadRcerSsDIvonzI1tqahJQiV5iwM9U
	MpnrR0vLsx2+2q60PpIofduWHiXcdNDDM+hafyN/RTHRXQNifBvVI2VXx2em6qbksE+B3Yla/2j
	uAo0IGi4tWMglOmysM+3GAl0Ex2Wvutxrjm4vgc3ERgNzUu20DwXYuo20ZWd9kD+1/oJRjrpK5k
	am3B3DQ==
X-Google-Smtp-Source: AGHT+IG87R5weD982qzgfS5+G+L28h6Tf/+shnk8bkBrJwbfAhu66ru/I7G0rtZOOvQ8jQ/K1i5VCA==
X-Received: by 2002:a6b:720e:0:b0:883:e4de:378c with SMTP id ca18e2360f4ac-883f11e08f4mr554199139f.5.1754672634330;
        Fri, 08 Aug 2025 10:03:54 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-883f198d65esm68203439f.20.2025.08.08.10.03.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 10:03:52 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/8] io_uring/nop: add support for IORING_SETUP_CQE_MIXED
Date: Fri,  8 Aug 2025 11:03:06 -0600
Message-ID: <20250808170339.610340-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250808170339.610340-1-axboe@kernel.dk>
References: <20250808170339.610340-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds support for setting IORING_NOP_CQE32 as a flag for a NOP
command, in which case a 32b CQE will be posted rather than a regular
one. This is the default if the ring has been setup with
IORING_SETUP_CQE32. If the ring has been setup with
IORING_SETUP_CQE_MIXED, then 16b CQEs will be posted without this flag
set, and 32b CQEs if this flag is set. For the latter case, sqe->off is
what will be posted as cqe->big_cqe[0] and sqe->addr is what will be
posted as cqe->big_cqe[1].

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring.h |  1 +
 io_uring/nop.c                | 17 +++++++++++++++--
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 9396afb01dc8..33b386f43d47 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -460,6 +460,7 @@ enum io_uring_msg_ring_flags {
 #define IORING_NOP_FIXED_FILE		(1U << 2)
 #define IORING_NOP_FIXED_BUFFER		(1U << 3)
 #define IORING_NOP_TW			(1U << 4)
+#define IORING_NOP_CQE32		(1U << 5)
 
 /*
  * IO completion data structure (Completion Queue Entry)
diff --git a/io_uring/nop.c b/io_uring/nop.c
index 20ed0f85b1c2..3caf07878f8a 100644
--- a/io_uring/nop.c
+++ b/io_uring/nop.c
@@ -17,11 +17,13 @@ struct io_nop {
 	int             result;
 	int		fd;
 	unsigned int	flags;
+	__u64		extra1;
+	__u64		extra2;
 };
 
 #define NOP_FLAGS	(IORING_NOP_INJECT_RESULT | IORING_NOP_FIXED_FILE | \
 			 IORING_NOP_FIXED_BUFFER | IORING_NOP_FILE | \
-			 IORING_NOP_TW)
+			 IORING_NOP_TW | IORING_NOP_CQE32)
 
 int io_nop_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
@@ -41,6 +43,14 @@ int io_nop_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		nop->fd = -1;
 	if (nop->flags & IORING_NOP_FIXED_BUFFER)
 		req->buf_index = READ_ONCE(sqe->buf_index);
+	if (nop->flags & IORING_NOP_CQE32) {
+		struct io_ring_ctx *ctx = req->ctx;
+
+		if (!(ctx->flags & (IORING_SETUP_CQE32|IORING_SETUP_CQE_MIXED)))
+			return -EINVAL;
+		nop->extra1 = READ_ONCE(sqe->off);
+		nop->extra2 = READ_ONCE(sqe->addr);
+	}
 	return 0;
 }
 
@@ -68,7 +78,10 @@ int io_nop(struct io_kiocb *req, unsigned int issue_flags)
 done:
 	if (ret < 0)
 		req_set_fail(req);
-	io_req_set_res(req, nop->result, 0);
+	if (nop->flags & IORING_NOP_CQE32)
+		io_req_set_res32(req, nop->result, 0, nop->extra1, nop->extra2);
+	else
+		io_req_set_res(req, nop->result, 0);
 	if (nop->flags & IORING_NOP_TW) {
 		req->io_task_work.func = io_req_task_complete;
 		io_req_task_work_add(req);
-- 
2.50.1


