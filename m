Return-Path: <io-uring+bounces-4069-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 410099B344C
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 16:04:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 107541C21DF5
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 15:04:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA56C18FDB0;
	Mon, 28 Oct 2024 15:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="WJz+OxFU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 138521D9681
	for <io-uring@vger.kernel.org>; Mon, 28 Oct 2024 15:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730127888; cv=none; b=tROblNcPxvgDiF2efMTihmZgUcU/foaCcg6BbkJBp9u7puQIVUeikKtF33tykG5GfN7Bg6e/PeprBZPxITVn28DHh0BzH2/1ym49KXaULCfnUtD1IeogwLPp2B4wioz9Qd8RXCWi6w6DnQZEPHp4lk0dWI+tTETYmwuouE/MgzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730127888; c=relaxed/simple;
	bh=HPnvI+rOjDAWZqF0Xd42uWJKF/3qtcinc1VyXx9MXy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h4+q+sL/2w9oqU5ztGVf8EJlafPhez3pcPKQO16BNWkhnr/hDvObhBRZmk0KXd+DjU4QAn1NQ1ksOwpn3ZGyB1cuE2OMwQZsQikh4C425qqnnLICfYcVHhDbgrlrIQZ6/xQcBGuf6xI8V+4U7KWmOMx7GqU+BEp/+7Srxpmg4Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=WJz+OxFU; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3a3aeb19ea2so16000385ab.0
        for <io-uring@vger.kernel.org>; Mon, 28 Oct 2024 08:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730127884; x=1730732684; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lk/+RVPeoujW1QBGROEzXF5c7w5OPLyPUXaokbUSoj0=;
        b=WJz+OxFUIe+DfhHgsVZ0nDBs6PpiZ9xQetozra0lsfAHbXOcUwe2CUhsljaVxa0LL3
         rojUQsuP2kaeGntrltjjE3FXRERIu1BjvTKlkXectjSwGjaD8s01yy3nrVuKukLZMgiI
         q7E+S1P8ZHUpxGwF4Jt24MAIL17iX/lk0eQao9DC96m4hi3NRPWZv35YDYNW75MkHu7+
         PnknCmt4osvTH1cRIdzzFpoJuJfVkEai/e4LWYmyEW14M7qOeogFndL2fB+SQ/GvPJoK
         sBbSk3PtmM+Fw+4/IcDN+wP+U103//dK6I+fX81nSzLxvSPHBOTeAc9X+tvEc9pBYH0v
         QCLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730127884; x=1730732684;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lk/+RVPeoujW1QBGROEzXF5c7w5OPLyPUXaokbUSoj0=;
        b=qBzKTkilGtL4PrkJ/EvmAYc6+juaWSvAI6Zl6TXjQZSWNQ+R5Sxqhlu0IWzBDxOCxF
         F8rzpI8b7Kix75bfQK+lP9vyC9jSfkWrerY1pwW7LZdt/nNQBbs4C1AakvdP8RALjiSb
         8kCUmrK6NPNf+ce577SdxZzQ3JDU41JSHJGPkCDxz4eAnXqrhkl+ghMsalaup7Jzk/JV
         e456BcAT1KLHdnVxTj11D/byoOqwbzx5LbGb2GUUwyHhwrcuQqL3k7id+mkqbZSE1dg/
         HljMZwWmUfs3edUj5DDkPVlUtfwauF/pSfMsDc/W2/qFBKfjD+aJoIBWM2ZUaTPOSvN7
         zW7g==
X-Gm-Message-State: AOJu0YxLu+VyqiR7ZB5zzvSsKrBWvtPiJbIuC8W0WdpKMIuoW9znyR0g
	Pf1EezLnS5mndmxO1NFYYYNZjzH4Z8q3Du2mNoGLNRukuOyr4ww13Yz+GRyQeLr8dHIgJs2C/ZR
	A
X-Google-Smtp-Source: AGHT+IG5i6GgjRUwZBstb32BYDeJPkTd3KNhTLPLHcgtEo1HaqZMq7xT07taUC8OMvEXruMNl5W2zQ==
X-Received: by 2002:a05:6e02:1d01:b0:3a0:9829:100b with SMTP id e9e14a558f8ab-3a4ed2fcbc6mr66461455ab.21.1730127884126;
        Mon, 28 Oct 2024 08:04:44 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc7261c7e3sm1721616173.72.2024.10.28.08.04.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2024 08:04:41 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 01/13] io_uring/nop: add support for testing registered files and buffers
Date: Mon, 28 Oct 2024 08:52:31 -0600
Message-ID: <20241028150437.387667-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241028150437.387667-1-axboe@kernel.dk>
References: <20241028150437.387667-1-axboe@kernel.dk>
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


