Return-Path: <io-uring+bounces-7093-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93453A65205
	for <lists+io-uring@lfdr.de>; Mon, 17 Mar 2025 14:59:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 09B2916ADE4
	for <lists+io-uring@lfdr.de>; Mon, 17 Mar 2025 13:58:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B37E824292C;
	Mon, 17 Mar 2025 13:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="dKUQoHMD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33665242908
	for <io-uring@vger.kernel.org>; Mon, 17 Mar 2025 13:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742219881; cv=none; b=oZiN7/Cw67RFbHzW8AaRzYh62XLJbhLLJlbyOnKxzc/f9vx3Jrb6dQrJvCN/e1Znz4Cqmuv2L7ptjN11S9LE8d3wrG7NmG1Xh/Jy4AFpW9TcWqwtXfL8yNJKUp6DMoEi8GlD1f4ldB2nBpgxtqEtetN0/IQmOZH/bXDFs4gHFEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742219881; c=relaxed/simple;
	bh=MUln8dzk96jrS8N7WaQSszZ2y7lpJFghuGsy5mJDX7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bi8YXoFE3Dhc8San2SN28UmrSSVfkTXBXZ/TBpsAnBzrfCTkm4UYBSaw+CV/0uz3gCWPj5hTHIax9dvYFCCnFMQlkGN6pXZIETFU52X/8r54vIbnybc7nxqR8355Ljup0Oir26/hrT4NvAtJLRQ/D4Ew4GmTEqKm/I4GII/eVNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=dKUQoHMD; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-300fefb8e06so3374162a91.0
        for <io-uring@vger.kernel.org>; Mon, 17 Mar 2025 06:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1742219879; x=1742824679; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YQa2yXoRrARN2BUDV+ngN+TPs4QoczcMbvd+w0pXTw8=;
        b=dKUQoHMD1mdhkIi4cVWcT90C8UdRh3hl4zoLdBuAW3lkrBY+EdQuAr4rKTFTpzWply
         Bwi0v+u2F+MQwPBHe/KkDp9XKb/AAO4CIh4tctu1O9hG0Ssz4ds3/1hnX+VaJo7Y8Fdq
         B4amqLcAVfk/fOx/4ItI6C8MAuEKkbxCIrcPQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742219879; x=1742824679;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YQa2yXoRrARN2BUDV+ngN+TPs4QoczcMbvd+w0pXTw8=;
        b=EJjSMHnsjGAbfajOUBgTT6NH5AOERvR8UHiSCpLI4ths5XhmPGRBH1O00XUiCmYRbs
         Mn6ARl+A4019IXOIqrYoRWxYZIpZwwYHoAOgxpSnfTuot0prFj/duRqhb/xUe+oIaDA1
         G4stmlyFvLKjeZgEms5dcdcGYyaW37iVuom/RracK3c9BcSkaO+34TDbv8ETG+jEhdEA
         hrV24waaw0xDk06GHMHJjnlB2hm04a4iInZHnbejNXx3D7bbzAs2wSch+XaJ5HHVIfJk
         hlZu855YDVHC2XGKs+eq3N1rW+o/do35Iq/EHl9P+WtLsgePpckF5rRLAvfwWCIfYqKr
         VbaQ==
X-Forwarded-Encrypted: i=1; AJvYcCUA4m60x0g80un9a6yAnkYNfTEMGNo7+fGXYYY4Lp1hHorAj8Dl/EFjtbv7EJUdtbKlbLickbMwww==@vger.kernel.org
X-Gm-Message-State: AOJu0YzD2aj2zf0h7qVpD1mYmP9Ab8JJYppZtCGTPhXuOPfSor1MashE
	cu7J8CHg3D8ybcGaHww81CtbuSG8Gb20ZOWBlE77yBt1xJZsiQlLy7O5hhfncd4=
X-Gm-Gg: ASbGncuKnwBDLrbWjqc5hPWsMfm/tudFMQsNCHQarC2V/Pj/DZNZpbkPtZT3RNv0Zoj
	+JWje4d5otazYw1pxTbeSl+GTSpUYW8+gMHC2p3xW4lpa+HWXq6Xf4MF0P+ZqSAeqA8IGo2nt5K
	82EuCVrVZN6VCYY2YBHd1m8qWMYzFxu7uvGgnEy7RfKB0egpDThs2uKCaoWvHVI6Dwd2k4Yw0+7
	wG7cbuNrDVVM/SQg+aW8Pj5utmCXADB+9vHz84Crir52ybVGEJZ+KgS71khQ/Ky2XyIyxkkprNt
	aAvujWlrhbJSH/fcgCtP+oRqcWnLOeiqbvt5emO0oMY2ZwCnORSspQv3azaX3ecTCJzhqGRwguV
	t3eiuJRIHrBiuNnI=
X-Google-Smtp-Source: AGHT+IE1Y7pp7Us6sxXqWDZ6744BRQUSCXKFnFGSNVTBGDp4dsbg+5u3su0ELJH3VSZUrZsckswABQ==
X-Received: by 2002:a17:90b:3145:b0:2fe:a336:fe65 with SMTP id 98e67ed59e1d1-30151cd2dc5mr16694880a91.10.1742219879425;
        Mon, 17 Mar 2025 06:57:59 -0700 (PDT)
Received: from sidong.sidong.yang.office.furiosa.vpn ([61.83.209.48])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30153b99508sm5993742a91.39.2025.03.17.06.57.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 06:57:59 -0700 (PDT)
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org,
	Sidong Yang <sidong.yang@furiosa.ai>
Subject: [RFC PATCH v4 2/5] io-uring/cmd: add iou_vec field for io_uring_cmd
Date: Mon, 17 Mar 2025 13:57:39 +0000
Message-ID: <20250317135742.4331-3-sidong.yang@furiosa.ai>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250317135742.4331-1-sidong.yang@furiosa.ai>
References: <20250317135742.4331-1-sidong.yang@furiosa.ai>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch adds iou_vec field for io_uring_cmd. Also it needs to be
cleanup for cache. It could be used in uring cmd api that imports
multiple fixed buffers.

Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
---
 io_uring/io_uring.c  |  2 +-
 io_uring/opdef.c     |  1 +
 io_uring/uring_cmd.c | 20 ++++++++++++++++++++
 io_uring/uring_cmd.h |  4 ++++
 4 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 513f036bccbb..08506d1224c5 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -289,7 +289,7 @@ static void io_free_alloc_caches(struct io_ring_ctx *ctx)
 	io_alloc_cache_free(&ctx->apoll_cache, kfree);
 	io_alloc_cache_free(&ctx->netmsg_cache, io_netmsg_cache_free);
 	io_alloc_cache_free(&ctx->rw_cache, io_rw_cache_free);
-	io_alloc_cache_free(&ctx->uring_cache, kfree);
+	io_alloc_cache_free(&ctx->uring_cache, io_cmd_cache_free);
 	io_alloc_cache_free(&ctx->msg_cache, kfree);
 	io_futex_cache_free(ctx);
 	io_rsrc_cache_free(ctx);
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index e4aa61a414fb..489384c0438b 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -755,6 +755,7 @@ const struct io_cold_def io_cold_defs[] = {
 	},
 	[IORING_OP_URING_CMD] = {
 		.name			= "URING_CMD",
+		.cleanup		= io_uring_cmd_cleanup,
 	},
 	[IORING_OP_SEND_ZC] = {
 		.name			= "SEND_ZC",
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index e4cd6fe9fd47..bf4002e93ec5 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -29,6 +29,13 @@ static void io_req_uring_cleanup(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (issue_flags & IO_URING_F_UNLOCKED)
 		return;
+
+	req->flags &= ~REQ_F_NEED_CLEANUP;
+
+	io_alloc_cache_vec_kasan(&ac->iou_vec);
+	if (ac->iou_vec.nr > IO_VEC_CACHE_SOFT_CAP)
+		io_vec_free(&ac->iou_vec);
+
 	if (io_alloc_cache_put(&req->ctx->uring_cache, cache)) {
 		ioucmd->sqe = NULL;
 		req->async_data = NULL;
@@ -36,6 +43,11 @@ static void io_req_uring_cleanup(struct io_kiocb *req, unsigned int issue_flags)
 	}
 }
 
+void io_uring_cmd_cleanup(struct io_kiocb *req)
+{
+	io_req_uring_cleanup(req, 0);
+}
+
 bool io_uring_try_cancel_uring_cmd(struct io_ring_ctx *ctx,
 				   struct io_uring_task *tctx, bool cancel_all)
 {
@@ -346,3 +358,11 @@ int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_sock);
 #endif
+
+void io_cmd_cache_free(const void *entry)
+{
+	struct io_async_cmd *ac = (struct io_async_cmd *)entry;
+
+	io_vec_free(&ac->iou_vec);
+	kfree(ac);
+}
diff --git a/io_uring/uring_cmd.h b/io_uring/uring_cmd.h
index f3593012658c..8986224e0c57 100644
--- a/io_uring/uring_cmd.h
+++ b/io_uring/uring_cmd.h
@@ -1,13 +1,17 @@
 // SPDX-License-Identifier: GPL-2.0
+#include <linux/io_uring_types.h>
 
 #include <linux/io_uring/cmd.h>
 
 struct io_async_cmd {
 	struct io_uring_cmd_data data;
+	struct iou_vec iou_vec;
 };
 
 int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags);
 int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+void io_uring_cmd_cleanup(struct io_kiocb *req);
 
 bool io_uring_try_cancel_uring_cmd(struct io_ring_ctx *ctx,
 				   struct io_uring_task *tctx, bool cancel_all);
+void io_cmd_cache_free(const void *entry);
-- 
2.43.0


