Return-Path: <io-uring+bounces-9164-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EFD68B2FCA2
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 16:31:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A13BB1D21622
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 14:21:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EBBE2EC551;
	Thu, 21 Aug 2025 14:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="LrErjiBo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 877B92857C6
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 14:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755786013; cv=none; b=DmEci8K1NVy2Zr/jgLZtk37qMTxnRMaQh/CJVjsGc/p/RYPq20X6FrF0Caq3V6dCQDDPlltI3jX97pP4zOxOaxf9EfBPAs8fCgaPVNzibVYokSzhHq/LKNlYD18Q8vV3Ns/lR+tTbfWOMSS/JPTLkVW+7Q//+vi7XrZdVSc0rOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755786013; c=relaxed/simple;
	bh=/t5GHx4sVcVPPSbW9NA0qxnTNXGcUfOeTQujrB4NIns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L6AReh8VsMQrYJlCvlIF81zlgxorvPGsGusT2pjnHYUib7zfsHvL8I+G3paT53ObrONLBOlAL+oF4gQGuISPIT7vJhfBkBfc/9fxY/qRg9dT5k5fDeQ+YbKevWUf9dISdTekNT6BNJZ2hSxk6TJiogtb0po7xhuqgHiUM4sdAB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=LrErjiBo; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3e57010bc95so7633175ab.3
        for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 07:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755786009; x=1756390809; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=frJ/TkbO6Xo8bULk9z19sXOAKYxNN18NTwYcLUopqIo=;
        b=LrErjiBoFOBiyPFu55DwCegP64oOOHj1M4H+iIXE6VA8uljBx5aMQw/o0BwIc5BFy0
         f/klxA9M/ncmX8Kued7XxNuUjEu3p3OsqldiHtFY0BLNStrNW30koN5p52ShShfAS47r
         sBPbv6Fxh0w7zx/e3ZJY/UM82iTwJSdAOQQqy0JMGD+cFU75Mo26e0XngY17ZtjjiyuY
         +HF5YiX947/m4XNolw1dlJlSnxWw7h2QTPv+jQjAC5AuaSHtkGariCVSpw86ovA7Y9ZP
         7egoYhcrJed1Y9D7ECULZSXhNziG1WzhjXX99jabU47j+gyHlnsdHvdjSaoZNtR9WFNI
         Us0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755786009; x=1756390809;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=frJ/TkbO6Xo8bULk9z19sXOAKYxNN18NTwYcLUopqIo=;
        b=nJIzIVzJRuue1TQRgM0vYkQkn2vmvV13Knb12n5TOOrE8B7tZmpv7TRgw8FcuD0I/s
         y3njwCIcx4FD4prwdSvQrJAAXFcQpt+bFGGXMCGQWzNq9p0PSoWoy88lA70JsTpZ+YKt
         ipbqIGrEMeo1xUL6b4jdQMqVlutKb9XNumFf7v+ahQXgrrVidgpzPcEFBSQ2+UssVdmz
         ti0bQsspqJ5R8iDnTyLPAZzM/JLJKiYNdgUQ3efrOL4eDJtopuYhS5Q9AycAoMVALOBQ
         hAuLWENdsVGRDtBx+0Qkpxl2WwrTvDCMKktakJTPeU21yh2NmOdPND5RhluMvbCBniuB
         VGbg==
X-Gm-Message-State: AOJu0YwYoNGC3bWJXj2DQa8d4rAr8ED1aDcheJIn9288SsIG115g7rdZ
	v7WC1mXUbxHZVBEAx7/QPYIhR9YhBz1nvFbYjOZsuUc7lNR6J4bg960x+QmY0m5H8p5UBZn3/2T
	3UXO3
X-Gm-Gg: ASbGncsdLxAdWDoXzCLPniWJgL5t92NmugF0OJei91vrW5WNv1Oyxa0TrxMcOWVrhx6
	fUhUArT06d//oWNvTMjgReB15RN5JvMdg0jsQ6mXaALeqwB2go5kR93nnnixoY15Ovuzlj86gNk
	2W/eU74fByYjStDAkOPj+1ZU17vRgY+L2k1toaM3W1/rW91N5Jk2qco/IL7TdOmf7c92rGuElXU
	Q6+DW0OVFx5Kw6dcpj1I68HevrgqnFupF8sFKI+ikai0DTN2ldIPmizDxacJXkNJlA/ezPqbAcj
	HxmDkBKp/z50eXfq1QlcpAsVo/m14rZQfshdpGGK0F+0UwuW0QTQ56d74EbxWcKK6zbqqJig/9m
	GSiK691oXvdl5QkLi
X-Google-Smtp-Source: AGHT+IHwwMiOxkLV9XAdB4te6imtbkuQS0tubIQZE0H8lpH5zrQfPGfS44bTqAjnVaPXoO6gz1kirA==
X-Received: by 2002:a05:6e02:4413:10b0:3e8:4348:2e9c with SMTP id e9e14a558f8ab-3e843483083mr18650615ab.15.1755786009191;
        Thu, 21 Aug 2025 07:20:09 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e57e58c1basm73196595ab.5.2025.08.21.07.20.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 07:20:07 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/8] io_uring/nop: add support for IORING_SETUP_CQE_MIXED
Date: Thu, 21 Aug 2025 08:18:06 -0600
Message-ID: <20250821141957.680570-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821141957.680570-1-axboe@kernel.dk>
References: <20250821141957.680570-1-axboe@kernel.dk>
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
index 5135e1be0390..04ebff33d0e6 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -464,6 +464,7 @@ enum io_uring_msg_ring_flags {
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


