Return-Path: <io-uring+bounces-7121-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D7BEBA684DC
	for <lists+io-uring@lfdr.de>; Wed, 19 Mar 2025 07:14:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4D22D1892A1F
	for <lists+io-uring@lfdr.de>; Wed, 19 Mar 2025 06:14:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AAC32500B6;
	Wed, 19 Mar 2025 06:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="J9ry71SE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C6B24F5AD
	for <io-uring@vger.kernel.org>; Wed, 19 Mar 2025 06:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742364809; cv=none; b=C1h6ApKgsO5pNU7HW0nKNVjMuL9wToMBGF7F1KSETGnAokEM/KhvEtgQeHd3ruI2cW/QtlnfZeBuGGZfWbd1VjZW4Zva1pHptw5YMRoZ6cbBrWNwlMQ/Oa4qGybmyrK/tnGahHld1REq2W7i4ky18IM+gKNLdU90P/7AFBy1CS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742364809; c=relaxed/simple;
	bh=0IdlGsxiHlOpfB3LWKjSS9hQhoWmXtFYaCxPr3UzbE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uth39u+jE1XjBi1AyFdGvCg8qtjRXMkINXIQANdhGxR9hff6OK/n9VyM3o05SsyT206othqkiX1e72TD/3EmqHqHC+XfxekkwkX75ppN88tKidtkIN17ao4ugR4Btqm1Y2TRP+7P2c7LHRecMCgggARkMs2MMjHIWuMTVVh+x7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=J9ry71SE; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2ff799d99dcso6709804a91.1
        for <io-uring@vger.kernel.org>; Tue, 18 Mar 2025 23:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1742364808; x=1742969608; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6AbNriybkAMg6arWdOZVqfylWfhbFH3phG3S4HFDKww=;
        b=J9ry71SEuiDmw14IQk1Pmk3yFRI/2xqN08SBlv2P7vavGHbPvfsCoQ3mppUNWoEU98
         uJcVAvo6tWr7O3f5pvtIX0tprFetwrArPBbROR/OosdWgNpgS1Yv4bXvhHM4KJ5+UWl7
         dDV5SF4cK/u3Mumby9/dlmrz96fN+5c7t6hqE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742364808; x=1742969608;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6AbNriybkAMg6arWdOZVqfylWfhbFH3phG3S4HFDKww=;
        b=MVoMxUDL8C1OjQz7YmbjcQxtzCwq5Oe0YQQnxBgsaS83zr7hOPQ1SATUkXjIFhtctp
         zi/R+xXvNMQvkUTdy1TaT9bBM9bbLjxm4mzl297i1643TfeahgIMgGF5wqW/988+g9SR
         OjRJc/o8DHpE1G8nAYnQq7lDqnHE8hOm5id5RGHSbErAoObgzNo2swyyazEhiW2L8yL3
         KQKAIhPseVzoR5Uee1HxQ+9WI48XfJneCp0M6TMsWfyPMhKWt9fE04Bssm2vVfzeeB7p
         /PwrmIxYxgoupMZK4v3ej36ik77V3ZPlxhfIyL9W4nENsEnIkUt3hsLD+54LE+8wtMs2
         9y9g==
X-Forwarded-Encrypted: i=1; AJvYcCUuAkuJUZoofUr+NXqwcJqGP3M3F9hMdxY5s9yqHD4mLBcjW5CExj/XZE9yPDJIr3Ub97f5EHibxw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyxJVpig6AychBneOmB3i5D/dmko0ZMENum+WVQ7tRyWHZA8RIA
	Vg57ElSTNl7PKU/zHoLSsyoGzpvB2OFH+rcKGJKdKRAm4LPfg1QIhNPlcZigDY0=
X-Gm-Gg: ASbGncvHRifPamZveRQTKn8/eQfXk0FcIRKH+Bqws9gyrfH80rXip849oYLVrT8s1vc
	YwNjJ6MtC2TeQI6felj5g4095rBNLMP7SDYfPiXIONlV7WvtNG5536DOJBTQTVu8RNh9Ze+5qmQ
	8g5W7KvrJSZt6iJn3AHV9OMzvEpTbKQzi1Ub9YdjCd36sOQvW5xWoW25LofdvVwkMHEKFoP2z/e
	TAxH8WHsJ/yT99NVZJVdEN6zZmOgtTfgrJ47aQ0sODzq/iPIVBQ3ZEylZ2Gu8jdIbb51G4YOOn3
	5U80G9aKIUFL86y2EjPn/0bUU5VaoIw5n8bgtGkjnwuaPYQHZT3oxEXjVZKs5ik0KMmVLC2H80o
	g3Yam
X-Google-Smtp-Source: AGHT+IGXSqzU8y1cmSTygGM2aLfIYSj2l7hrJ3dPPrIwTZ/TmZGV+LoRrdcJncNf2fekVNIFT5waog==
X-Received: by 2002:a17:90b:390e:b0:2fe:b8ba:62de with SMTP id 98e67ed59e1d1-301be1f8ecdmr2258008a91.25.1742364807891;
        Tue, 18 Mar 2025 23:13:27 -0700 (PDT)
Received: from sidong.sidong.yang.office.furiosa.vpn ([61.83.209.48])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301bf589b07sm645103a91.11.2025.03.18.23.13.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Mar 2025 23:13:27 -0700 (PDT)
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: [RFC PATCH v5 2/5] io_uring/cmd: don't expose entire cmd async data
Date: Wed, 19 Mar 2025 06:12:48 +0000
Message-ID: <20250319061251.21452-3-sidong.yang@furiosa.ai>
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

io_uring needs private bits in cmd's ->async_data, and they should never
be exposed to drivers as it'd certainly be abused. Leave struct
io_uring_cmd_data for the drivers but wrap it into a structure. It's a
prep patch and doesn't do anything useful yet.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c  |  2 +-
 io_uring/opdef.c     |  2 +-
 io_uring/uring_cmd.c | 18 +++++++++++-------
 io_uring/uring_cmd.h |  6 ++++++
 4 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 7f26ad334e30..5eb9be063a7c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -335,7 +335,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 			    sizeof(struct io_async_rw),
 			    offsetof(struct io_async_rw, clear));
 	ret |= io_alloc_cache_init(&ctx->cmd_cache, IO_ALLOC_CACHE_MAX,
-			    sizeof(struct io_uring_cmd_data), 0);
+			    sizeof(struct io_async_cmd), 0);
 	spin_lock_init(&ctx->msg_lock);
 	ret |= io_alloc_cache_init(&ctx->msg_cache, IO_ALLOC_CACHE_MAX,
 			    sizeof(struct io_kiocb), 0);
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 7fd173197b1e..e4aa61a414fb 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -416,7 +416,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.plug			= 1,
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
-		.async_size		= sizeof(struct io_uring_cmd_data),
+		.async_size		= sizeof(struct io_async_cmd),
 		.prep			= io_uring_cmd_prep,
 		.issue			= io_uring_cmd,
 	},
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 792bd54851b1..7c126ee497ea 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -19,7 +19,8 @@
 static void io_req_uring_cleanup(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
-	struct io_uring_cmd_data *cache = req->async_data;
+	struct io_async_cmd *ac = req->async_data;
+	struct io_uring_cmd_data *cache = &ac->data;
 
 	if (cache->op_data) {
 		kfree(cache->op_data);
@@ -169,12 +170,15 @@ static int io_uring_cmd_prep_setup(struct io_kiocb *req,
 				   const struct io_uring_sqe *sqe)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
-	struct io_uring_cmd_data *cache;
+	struct io_async_cmd *ac;
 
-	cache = io_uring_alloc_async_data(&req->ctx->cmd_cache, req);
-	if (!cache)
+	/* see io_uring_cmd_get_async_data() */
+	BUILD_BUG_ON(offsetof(struct io_async_cmd, data) != 0);
+
+	ac = io_uring_alloc_async_data(&req->ctx->cmd_cache, req);
+	if (!ac)
 		return -ENOMEM;
-	cache->op_data = NULL;
+	ac->data.op_data = NULL;
 
 	/*
 	 * Unconditionally cache the SQE for now - this is only needed for
@@ -183,8 +187,8 @@ static int io_uring_cmd_prep_setup(struct io_kiocb *req,
 	 * that it doesn't read in per-op data, play it safe and ensure that
 	 * any SQE data is stable beyond prep. This can later get relaxed.
 	 */
-	memcpy(cache->sqes, sqe, uring_sqe_size(req->ctx));
-	ioucmd->sqe = cache->sqes;
+	memcpy(ac->data.sqes, sqe, uring_sqe_size(req->ctx));
+	ioucmd->sqe = ac->data.sqes;
 	return 0;
 }
 
diff --git a/io_uring/uring_cmd.h b/io_uring/uring_cmd.h
index f6837ee0955b..2ec3a8785534 100644
--- a/io_uring/uring_cmd.h
+++ b/io_uring/uring_cmd.h
@@ -1,5 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0
 
+#include <linux/io_uring/cmd.h>
+
+struct io_async_cmd {
+	struct io_uring_cmd_data	data;
+};
+
 int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags);
 int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 
-- 
2.43.0


