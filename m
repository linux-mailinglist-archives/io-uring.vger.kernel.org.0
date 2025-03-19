Return-Path: <io-uring+bounces-7122-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A6566A684EA
	for <lists+io-uring@lfdr.de>; Wed, 19 Mar 2025 07:15:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC1C4423559
	for <lists+io-uring@lfdr.de>; Wed, 19 Mar 2025 06:14:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7292B24EF63;
	Wed, 19 Mar 2025 06:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="MAH5+K1d"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BB552505B2
	for <io-uring@vger.kernel.org>; Wed, 19 Mar 2025 06:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742364812; cv=none; b=h6eY8WnBPAeEkrT1pTC802vm0GOU8cLdC2txzyfIXYoLcRadwcgdF3PUImpFz/y+kk7V0AVWUoDRAL3Hca0juIVuK14MNhET5S7CFBW6qNh02zzs88H3rFZM6HgaZR5oKmf/lqR86du7EE18n322WawAe++dvWv8XtAut+/ivQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742364812; c=relaxed/simple;
	bh=mbXqG+VTiVNDPa0Fi621P5lQqETDJPz9dw0maRf2RLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hm6acSxa6PNTXwBk+HoFJbnBHgAsbbnRLL7ixMHF8piqIDI2wQ8pY8UJijjxJ6YO/tQ1GyCH3f8A8YYCkScRDHCICraHfHdIsdev3Ma+mYFBTR59u44IcNBQZsFAR+X1Gnz/SGPpoSYVjapfsSYc9w7GosXTce+T6LAQ0/3lia4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=MAH5+K1d; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2ff80290e44so7903390a91.0
        for <io-uring@vger.kernel.org>; Tue, 18 Mar 2025 23:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1742364810; x=1742969610; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mh8BnNc+9/8hJHF7wOcyjiM5crihBkkiiF/ddYF+Pzo=;
        b=MAH5+K1dsnpvMY4su3MtbJYISmB8e8AuY8ZMJbIQU8Yw72LWhos4pSVCGeYYg6axY/
         0peBIFlZ4c8ZUBbiyT4yx18FIE7e0wFgxwxNpZ4mfO7B2L8XThxARABjK+niTY08R+eR
         3zMbvbUSTT1DWklscrAduvLF+ilx0brFUKa20=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742364810; x=1742969610;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mh8BnNc+9/8hJHF7wOcyjiM5crihBkkiiF/ddYF+Pzo=;
        b=SHsSm0xfjKZSNh2ZrSrRYO/cQgR0ZHjxr14OeeqUhwyH5+IfROxhYgbMrhHccfJ8Ai
         jcYmxSHj/GrDs2xKCm6xZ67DsmVpPKEeCLaW4uO9oH6oQ8WUuL2ccJa6v3z4/7xsZ1Lg
         1QJ04uJYHyle1VCBGjbDgW2JqUGxu53v7orpjmHeeFgGPXV2XuFyYqLQ53oYZsgSellU
         YUQfbZtOjQEgT67QIdkogVq5yfqjl/QtIU77cMcq78rSrbospliqfDPyxy2goA09Z5ZK
         W+zcPhVK4SdZdZARRPCXXioVnYyU1wKFlB6birZFcSuAW6eJkJM7udEXM9QwXu+RO5yE
         Gjzg==
X-Forwarded-Encrypted: i=1; AJvYcCVn9aDKxYtIT3PNQ3ePVn/ES7CWoQOImXkBT5OFuttq2x6RgTUdkqC+OeeGCufqQA4043DtjiDAvw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6a7uUGWS8NN57pZMCEzP1bFwph2uiLWYZaQ3hldDXoSVQrgBx
	9UBXukElRySJK++S4unKhQ4fyWhqJDInw9P4fs6xrJ5S5knIniRD1gejT+su3gw=
X-Gm-Gg: ASbGncvE2bMWORBuYo+eKaGWVmdDiDJ9X1DKXOYNOA+H6c09zdOM5WXNiFF0jkVP393
	p3oYfqLTmFojO69DjdVWL52plj+OGMx5ept7TvtEEdqV+UvwnGppWN5k+aTiPAaX9MU/K9J3/Wv
	ykO11OmfSyEcaxwnRe7276zpjDrmskH2oLeGnX5CMZvXlHBz1duyxD4TY/aU2qIWzOHaOPX1qGm
	IJE/Po3Njzj/3ZwZFGW7L1WsqCboyFJXlu8U1xoU4g9SSi9lya1L4o/EUk+2X9ZP6dzu/7NC8+1
	x7yhkb/krVN860TqHCY+qFe/9xu80q6iSPQGy89+do+xB9fTSJZrrVOb10Ydocn6mALcwvePjkU
	ROmJ6
X-Google-Smtp-Source: AGHT+IHdbGO2urDOPCZIrJkjwT3bv9l2w3k2XVp7akC+vU69YG4/FJ7qndudn2Bzmp/K9qg91BFgbw==
X-Received: by 2002:a17:90b:224c:b0:2fe:b907:562f with SMTP id 98e67ed59e1d1-301bdf84fb6mr2588150a91.14.1742364810240;
        Tue, 18 Mar 2025 23:13:30 -0700 (PDT)
Received: from sidong.sidong.yang.office.furiosa.vpn ([61.83.209.48])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301bf589b07sm645103a91.11.2025.03.18.23.13.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Mar 2025 23:13:29 -0700 (PDT)
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: [RFC PATCH v5 3/5] io_uring/cmd: add iovec cache for commands
Date: Wed, 19 Mar 2025 06:12:49 +0000
Message-ID: <20250319061251.21452-4-sidong.yang@furiosa.ai>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250319061251.21452-1-sidong.yang@furiosa.ai>
References: <20250319061251.21452-1-sidong.yang@furiosa.ai>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

Add iou_vec to commands and wire caching for it, but don't expose it to
users just yet.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c  |  2 +-
 io_uring/opdef.c     |  1 +
 io_uring/uring_cmd.c | 20 ++++++++++++++++++++
 io_uring/uring_cmd.h |  5 +++++
 4 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 5eb9be063a7c..8ef93ce4a539 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -289,7 +289,7 @@ static void io_free_alloc_caches(struct io_ring_ctx *ctx)
 	io_alloc_cache_free(&ctx->apoll_cache, kfree);
 	io_alloc_cache_free(&ctx->netmsg_cache, io_netmsg_cache_free);
 	io_alloc_cache_free(&ctx->rw_cache, io_rw_cache_free);
-	io_alloc_cache_free(&ctx->cmd_cache, kfree);
+	io_alloc_cache_free(&ctx->cmd_cache, io_cmd_cache_free);
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
index 7c126ee497ea..abcc1ad236ef 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -16,6 +16,14 @@
 #include "rsrc.h"
 #include "uring_cmd.h"
 
+void io_cmd_cache_free(const void *entry)
+{
+	struct io_async_cmd *ac = (struct io_async_cmd *)entry;
+
+	io_vec_free(&ac->vec);
+	kfree(ac);
+}
+
 static void io_req_uring_cleanup(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
@@ -29,6 +37,13 @@ static void io_req_uring_cleanup(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (issue_flags & IO_URING_F_UNLOCKED)
 		return;
+
+	req->flags &= ~REQ_F_NEED_CLEANUP;
+
+	io_alloc_cache_vec_kasan(&ac->vec);
+	if (ac->vec.nr > IO_VEC_CACHE_SOFT_CAP)
+		io_vec_free(&ac->vec);
+
 	if (io_alloc_cache_put(&req->ctx->cmd_cache, cache)) {
 		ioucmd->sqe = NULL;
 		req->async_data = NULL;
@@ -36,6 +51,11 @@ static void io_req_uring_cleanup(struct io_kiocb *req, unsigned int issue_flags)
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
diff --git a/io_uring/uring_cmd.h b/io_uring/uring_cmd.h
index 2ec3a8785534..b45ec7cffcd1 100644
--- a/io_uring/uring_cmd.h
+++ b/io_uring/uring_cmd.h
@@ -1,13 +1,18 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include <linux/io_uring/cmd.h>
+#include <linux/io_uring_types.h>
 
 struct io_async_cmd {
 	struct io_uring_cmd_data	data;
+	struct iou_vec			vec;
 };
 
 int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags);
 int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+void io_uring_cmd_cleanup(struct io_kiocb *req);
 
 bool io_uring_try_cancel_uring_cmd(struct io_ring_ctx *ctx,
 				   struct io_uring_task *tctx, bool cancel_all);
+
+void io_cmd_cache_free(const void *entry);
-- 
2.43.0


