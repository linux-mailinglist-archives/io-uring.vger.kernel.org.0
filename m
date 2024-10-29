Return-Path: <io-uring+bounces-4104-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91F379B4DB3
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 16:23:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B559A1C22575
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 15:23:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6568D194AD8;
	Tue, 29 Oct 2024 15:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="vsnu8H3X"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F9419309C
	for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 15:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730215388; cv=none; b=r0wsOlRRPmFZIjbv/uzp1iBMVpv1PxhSYVJ6APBIaTWYKdNnUSY9VdXqVE+emmtOWWhxyXs5SN0XPJrgunt1dUaE7Pi49+4k/qKQfj7wXgj6HAvTr36ukVDs9qKkp/oTkQblQG23mWAv0fGNNn6dsckZ2cB8AB6LJkZev8lxOGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730215388; c=relaxed/simple;
	bh=HPnvI+rOjDAWZqF0Xd42uWJKF/3qtcinc1VyXx9MXy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VGdM4yjZiB9djoecLwIWDbrFUgIrRLiBdxa0q5/9lbwgXHDBBGPHBNqsNDnQt4Q2wUDJ0kh0ue+wObiMzie5H93N1G7MpyIYHg0XmlCAFewo4CyYvLMycpka8jJ/tLEEX/J/h4t5BbRav4+qyBWds6xQ5Jb9hKtvuHmQLOmsaVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=vsnu8H3X; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-83abe7fc77eso216129039f.0
        for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 08:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730215384; x=1730820184; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lk/+RVPeoujW1QBGROEzXF5c7w5OPLyPUXaokbUSoj0=;
        b=vsnu8H3XVuEqFy4VIR4JsaiT55+p2IlwtQriRvLxypjhuWpsyjjjJqn9jtAuGvdC0x
         CLAp9ColUzJ1I9iColhO5X6qldvFnPj+BXUu4S0CNppc0MEMnc86Sc+A/bp/2owjvjHC
         L0pQR1sKae/ocYh/oQQFc63GvO4TC0bk0x6UL37KNt9gFXOGgiFlsiHG43przn3LLRRd
         D4Q2hpTl7smFzSsk5GAfeIpdk+lLUfBKmZrSwsbfOfRlQySLEj3n2RGA4avwCXR9fjL5
         3JIL1zYsyB+EuzZipm10KusVsj1KT1+2ZnrnzWw6rANn08ah+aeVQSZJAYRNz+AFiFTA
         fKJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730215384; x=1730820184;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lk/+RVPeoujW1QBGROEzXF5c7w5OPLyPUXaokbUSoj0=;
        b=s1lCXZkU6553ezwsF784gvWjnPg7W8MU/6jBeCoCnVKLVzMkcMgOt17pVm1PYi8xZE
         o8f7aMg6Ka2j1N0r15TE11rMJJ6Cy4MjHprTPum7Q3aq/SP5sGFU4EQf0SC6jzpBlshN
         PrLocnDcLlvexdmYPtt9bewdqJss+T3WCqNhH05m78BhoMeR3d5KU4ZabcOpCiYXSyFS
         5JgVlNsG5hxGUAli0Wf8LlED9pVFmiP6b+DOCTJgts9uopAHMccYY4WmQ6C9t37xXprg
         G1xIC2ROtzRRWOTxFcjBUd1I1ts9kFofyphDNxPmCh8DmDqADzyQ6j97q/Nx0twZg82T
         cR5g==
X-Gm-Message-State: AOJu0YzSvUryl+OUbjn5UMNc1ZkZu891/YHs1YVw6p+mqXk/NBX8PQUB
	fSJrPGWnPmCFksXGhky1GqB4IeUOEjZyyzlrGcMknkFcJKLF9tgkqwS+05g2T05Zz6B3uuBcbOs
	B
X-Google-Smtp-Source: AGHT+IFyGCgj6sBqmq1H7Fa2+H7eo/7eyAqvIAEKnYZENz7KEfldBCmNDyOcpnBounuaDFLGHEk3yA==
X-Received: by 2002:a05:6602:6102:b0:83b:5221:2a87 with SMTP id ca18e2360f4ac-83b52215d0cmr148735839f.3.1730215383557;
        Tue, 29 Oct 2024 08:23:03 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc725eb58esm2434160173.27.2024.10.29.08.23.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2024 08:23:02 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 01/14] io_uring/nop: add support for testing registered files and buffers
Date: Tue, 29 Oct 2024 09:16:30 -0600
Message-ID: <20241029152249.667290-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241029152249.667290-1-axboe@kernel.dk>
References: <20241029152249.667290-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Useful for testing performance/efficiency impact of registered files
and buffers, vs (particularly) non-registered files.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring.h |  3 +++
 io_uring/nop.c                | 49 +++++++++++++++++++++++++++++++----
 2 files changed, 47 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 65b7417c1b05..024745283783 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -416,6 +416,9 @@ enum io_uring_msg_ring_flags {
  * IORING_NOP_INJECT_RESULT	Inject result from sqe->result
  */
 #define IORING_NOP_INJECT_RESULT	(1U << 0)
+#define IORING_NOP_FILE			(1U << 1)
+#define IORING_NOP_FIXED_FILE		(1U << 2)
+#define IORING_NOP_FIXED_BUFFER		(1U << 3)
 
 /*
  * IO completion data structure (Completion Queue Entry)
diff --git a/io_uring/nop.c b/io_uring/nop.c
index a5bcf3d6984f..2c7a22ba4053 100644
--- a/io_uring/nop.c
+++ b/io_uring/nop.c
@@ -8,35 +8,74 @@
 #include <uapi/linux/io_uring.h>
 
 #include "io_uring.h"
+#include "rsrc.h"
 #include "nop.h"
 
 struct io_nop {
 	/* NOTE: kiocb has the file as the first member, so don't do it here */
 	struct file     *file;
 	int             result;
+	int		fd;
+	int		buffer;
+	unsigned int	flags;
 };
 
+#define NOP_FLAGS	(IORING_NOP_INJECT_RESULT | IORING_NOP_FIXED_FILE | \
+			 IORING_NOP_FIXED_BUFFER | IORING_NOP_FILE)
+
 int io_nop_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	unsigned int flags;
 	struct io_nop *nop = io_kiocb_to_cmd(req, struct io_nop);
 
-	flags = READ_ONCE(sqe->nop_flags);
-	if (flags & ~IORING_NOP_INJECT_RESULT)
+	nop->flags = READ_ONCE(sqe->nop_flags);
+	if (nop->flags & ~NOP_FLAGS)
 		return -EINVAL;
 
-	if (flags & IORING_NOP_INJECT_RESULT)
+	if (nop->flags & IORING_NOP_INJECT_RESULT)
 		nop->result = READ_ONCE(sqe->len);
 	else
 		nop->result = 0;
+	if (nop->flags & IORING_NOP_FIXED_FILE)
+		nop->fd = READ_ONCE(sqe->fd);
+	if (nop->flags & IORING_NOP_FIXED_BUFFER)
+		nop->buffer = READ_ONCE(sqe->buf_index);
 	return 0;
 }
 
 int io_nop(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_nop *nop = io_kiocb_to_cmd(req, struct io_nop);
+	int ret = nop->result;
+
+	if (nop->flags & IORING_NOP_FILE) {
+		if (nop->flags & IORING_NOP_FIXED_FILE) {
+			req->file = io_file_get_fixed(req, nop->fd, issue_flags);
+			req->flags |= REQ_F_FIXED_FILE;
+		} else {
+			req->file = io_file_get_normal(req, nop->fd);
+		}
+		if (!req->file) {
+			ret = -EBADF;
+			goto done;
+		}
+	}
+	if (nop->flags & IORING_NOP_FIXED_BUFFER) {
+		struct io_ring_ctx *ctx = req->ctx;
+		struct io_mapped_ubuf *imu;
+		int idx;
 
-	if (nop->result < 0)
+		ret = -EFAULT;
+		io_ring_submit_lock(ctx, issue_flags);
+		if (nop->buffer < ctx->nr_user_bufs) {
+			idx = array_index_nospec(nop->buffer, ctx->nr_user_bufs);
+			imu = READ_ONCE(ctx->user_bufs[idx]);
+			io_req_set_rsrc_node(req, ctx);
+			ret = 0;
+		}
+		io_ring_submit_unlock(ctx, issue_flags);
+	}
+done:
+	if (ret < 0)
 		req_set_fail(req);
 	io_req_set_res(req, nop->result, 0);
 	return IOU_OK;
-- 
2.45.2


