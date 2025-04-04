Return-Path: <io-uring+bounces-7405-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 484B6A7C175
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 18:21:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E3A0E17CCE0
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 16:21:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F04D20AF62;
	Fri,  4 Apr 2025 16:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l9Fen5Yi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5154920ADE9
	for <io-uring@vger.kernel.org>; Fri,  4 Apr 2025 16:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743783673; cv=none; b=gNLslEB4LlN5nEVdgLSET6JUFZDabHE10FDUqZt1X5urYS9+JjnAUpK4H+4hrFgmBHvffYjn3alW9iRmixHne+Xourm/Q43/QTLGaFe1MUZJAxqglTv2gjy2O5ePMGxT8esO+9hKyjRHr13Vxlrzg3SyKDZA8cgoL882/Dhtkdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743783673; c=relaxed/simple;
	bh=X6XkgO/2J6cWEumjWggsd7LobOoRYSrXua06ZrAMVUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QwQrdoleo/lRlN4QaV/oqEam9ZmuhQupB2a2kd8/ESK78aSwZ+kvGsmiEeb4mlZe4abMyQkOoPIbWZJR0+IoJP3INbCu3gNR9oUIjdpEbxAuLgm+uqj/kFKGliaHj0RLvxxcnt1DvAqfS+crgOXlQdvSPoHuRzjMB/yolbvbskc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l9Fen5Yi; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-ac3eb3fdd2eso45277766b.0
        for <io-uring@vger.kernel.org>; Fri, 04 Apr 2025 09:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743783668; x=1744388468; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zOfK4mLxM92OSI9jXfUtr+7+kCu9rBgviQpi8ZslCPY=;
        b=l9Fen5YiCEbqYgx9sLONJoe/5YkpgqgEJ1uYw8P5uwBdP7X1HIUac/t0u60J/zMtae
         +KI0/4ZTCmL9m7D7pZWUixvPoSBIyW1xEO2LJy7SPRGix60a4cdS1og/VQflCnQ1Wrxh
         1Q99R3SMcKVozFxbZrdMZ0QgRFIizt8D+qqSOU90sTXIv+2ZqLajgR0NR8wHNgeWe3jd
         3+Nu4rYnNRgwjcm8PvyxQtRhmVYVr1RqPyvpZOo/ujAzZvpArEwDoms0BhwdhSn5eKdv
         wUxbeiuzs/98EgB97Qpp8vh3fEBujWd2pGnAoA7Z8uWLJhqwSVC2qxe2dekTUeL7mdyq
         I/0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743783668; x=1744388468;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zOfK4mLxM92OSI9jXfUtr+7+kCu9rBgviQpi8ZslCPY=;
        b=VRxmnUhuVLpGz3KklLJ+uJG0fQ27sb+5lSidVbbFyJHbnotCPYSeeOov6xHOdzEEj6
         b8Y4IkipN3acoI1CwcRnz+cbs/5fubixIj8FfXqh20YD4WUeViaDZ168mBIvaPFT/HlU
         Z5w1f2UseCuo2vOPpZIfLTzdCaz2SKtH9Vs07WkZDDJnAolQbEX86n+ohcrA/ZXeNvAY
         CovIfYQNaqwgcndPActNQnp6zXME2RrIA3uv4WY63bOomQpzRQOiY/jhdV0wyxCr954G
         Y1JJIM+euBkAVhmJQiyEpoixTGkZA4gb0s8/VuEK/znoMuUFzdWrUxe7jL1DMuNKFFa/
         Kacw==
X-Gm-Message-State: AOJu0YwLxbDvh7f8wrKoshxRxDGCnTPTcEuAut+j1yOCWaSvN35DnJ8c
	AHvF8a6b2QmBi1s9OLvPrmONe51m3W50uTbR+bKSZDORA7SKw0GqoGOrEA==
X-Gm-Gg: ASbGncs50C7rQ73608N3oQwVCm61OKz3DMvJca3son/38x7wLdCH7M1fK3jLvC6TDIH
	+uMtq65v7UWMwjcgcAP2bk/vwMV88L5mhr9j95Q9XgDbSnjEvKohslsWU8HMJ0y/wqKD4GsayyT
	4cQIYjxFP2PW3+Wy2hDHQ43ryCKFQiX4c7D7FoolUKtSYVyULjYAf67yUIO1NlMeUPqIEU+d1Q9
	cMBASx/bGVLf8J3dWurMQSy+0OmhJHDeWT8ltApgAPB/w3jdsquddWC6Drclu/dsZazqqbP/152
	UgmFVsC7XkRsEhgrHtJdYa5ZvIOG
X-Google-Smtp-Source: AGHT+IEaW/3jOskcp+/e5PMX8Xhqyajz2GI07Z1haR29Ir32GD0x8tuL3XdOPJAYY95x215vyETFmg==
X-Received: by 2002:a17:907:94c9:b0:ac7:18e3:1b16 with SMTP id a640c23a62f3a-ac7d1877e2fmr418351966b.20.1743783668054;
        Fri, 04 Apr 2025 09:21:08 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:ce28])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7c0184865sm273316066b.124.2025.04.04.09.21.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Apr 2025 09:21:07 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 2/4] io_uring: deduplicate node tagging
Date: Fri,  4 Apr 2025 17:22:15 +0100
Message-ID: <bfca5c11b2f34272f8c9d62ab92fef736b2413fa.1743783348.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1743783348.git.asml.silence@gmail.com>
References: <cover.1743783348.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move tag handling into io_sqe_buffer_register() so that we don't need to
duplicate it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 29 ++++++++++-------------------
 1 file changed, 10 insertions(+), 19 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 3c6e6e396052..d5e29536466c 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -27,7 +27,7 @@ struct io_rsrc_update {
 };
 
 static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
-			struct iovec *iov, struct page **last_hpage);
+			struct iovec *iov, struct page **last_hpage, u64 tag);
 
 /* only define max */
 #define IORING_MAX_FIXED_FILES	(1U << 20)
@@ -311,18 +311,11 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 		err = io_buffer_validate(iov);
 		if (err)
 			break;
-		node = io_sqe_buffer_register(ctx, iov, &last_hpage);
+		node = io_sqe_buffer_register(ctx, iov, &last_hpage, tag);
 		if (IS_ERR(node)) {
 			err = PTR_ERR(node);
 			break;
 		}
-		if (tag) {
-			if (!node) {
-				err = -EINVAL;
-				break;
-			}
-			node->tag = tag;
-		}
 		i = array_index_nospec(up->offset + done, ctx->buf_table.nr);
 		io_reset_rsrc_node(ctx, &ctx->buf_table, i);
 		ctx->buf_table.nodes[i] = node;
@@ -771,7 +764,8 @@ bool io_check_coalesce_buffer(struct page **page_array, int nr_pages,
 
 static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 						   struct iovec *iov,
-						   struct page **last_hpage)
+						   struct page **last_hpage,
+						   u64 tag)
 {
 	struct io_mapped_ubuf *imu = NULL;
 	struct page **pages = NULL;
@@ -782,12 +776,16 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 	struct io_imu_folio_data data;
 	bool coalesced = false;
 
-	if (!iov->iov_base)
+	if (!iov->iov_base) {
+		if (tag)
+			return ERR_PTR(-EINVAL);
 		return NULL;
+	}
 
 	node = io_rsrc_node_alloc(ctx, IORING_RSRC_BUFFER);
 	if (!node)
 		return ERR_PTR(-ENOMEM);
+	node->tag = tag;
 
 	ret = -ENOMEM;
 	pages = io_pin_pages((unsigned long) iov->iov_base, iov->iov_len,
@@ -899,18 +897,11 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 			}
 		}
 
-		node = io_sqe_buffer_register(ctx, iov, &last_hpage);
+		node = io_sqe_buffer_register(ctx, iov, &last_hpage, tag);
 		if (IS_ERR(node)) {
 			ret = PTR_ERR(node);
 			break;
 		}
-		if (tag) {
-			if (!node) {
-				ret = -EINVAL;
-				break;
-			}
-			node->tag = tag;
-		}
 		data.nodes[i] = node;
 	}
 
-- 
2.48.1


