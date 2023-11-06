Return-Path: <io-uring+bounces-44-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 245107E2E49
	for <lists+io-uring@lfdr.de>; Mon,  6 Nov 2023 21:39:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C890E280D34
	for <lists+io-uring@lfdr.de>; Mon,  6 Nov 2023 20:39:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22B492C842;
	Mon,  6 Nov 2023 20:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bKOnzuI+"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8E029D09
	for <io-uring@vger.kernel.org>; Mon,  6 Nov 2023 20:39:24 +0000 (UTC)
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35086D76
	for <io-uring@vger.kernel.org>; Mon,  6 Nov 2023 12:39:20 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-40806e40fccso30859745e9.2
        for <io-uring@vger.kernel.org>; Mon, 06 Nov 2023 12:39:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699303158; x=1699907958; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CBqu+kBWQyi7JQ96NT52vJFaXu5bMWwsvdgWWdxySaE=;
        b=bKOnzuI+17gMkL4D531q2JYEbs3+iMKSrOHNIcJaRH4SIeeTH/4hc/QXaupIeJLy8k
         0UXhhznPCKVw6rQKWl/CmVE5sYjZTrAfDigJk7eB8iEAcjNX1eO5G5iurxK6X+p9NBYj
         M+zNi8vimXypnAtqQaOqWjiw5oI6D5QwOA4rGmGbbn2kkMNoxR+mNXjSDHvex6814mZa
         3MlvNBLXzMKfe741Q6MIP9VpN2wzBZ0QLOR3gKNY2vBhMcNZED4W0oqJ0szaUO5BNV6v
         6POT6kB7xTv9HFbe/fmAKqU9nd7iyfVG2Y6w2KI6QHt9bPEePGzdfwG/fraSNiJSF+Jv
         Fkwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699303158; x=1699907958;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CBqu+kBWQyi7JQ96NT52vJFaXu5bMWwsvdgWWdxySaE=;
        b=BfCoOif8N3SnwwjSucJ2hPAko50es//N1DNMszJd8/tYAAbZpkbx9mhmNohPkM9jms
         GR+LKKHU8/5aur1sRNN8OPmfcm1sJjzTY3jv/M9EPoFyN+2kAC1lq8FQXSeZcHvFzHrS
         5pj02wu4Oylf+nTP4JeW9pD/8gQZa9tuAupocR5Mc5emNeE3CrPV2wHY/LAUEnIcrFSz
         uPboW42sdvBVLOvI80tx1sGSWbuPTm5ZW5JUMANcp/v+E315S48++u3y+CRh1rk6IKoe
         WO/rv+Zhx6DXePv5TTvTPmF8tpUSSBQI+OKy1qv5YcuuLQ4yXcBWWsU13jFiTObRgEyz
         Pcmg==
X-Gm-Message-State: AOJu0YwCagZeB4xYHQnVSerCNSxlSNI+6DB51Z3Tp5ECeFOLRZhbs9dh
	U3fsd6PB4Z1TCZ6FuKQzLUR1vry3hAs=
X-Google-Smtp-Source: AGHT+IGiZHHDFwtg72NugPAdRuuLZ6kZXfGUPJpWm9r0q83dYK6g3hc/ya+h/bJ3KtqS1JijcTMitw==
X-Received: by 2002:a05:600c:1c9d:b0:401:73b2:f043 with SMTP id k29-20020a05600c1c9d00b0040173b2f043mr787265wms.1.1699303157575;
        Mon, 06 Nov 2023 12:39:17 -0800 (PST)
Received: from puck.. (finc-22-b2-v4wan-160991-cust114.vm7.cable.virginm.net. [82.17.76.115])
        by smtp.gmail.com with ESMTPSA id s7-20020a05600c45c700b003fc16ee2864sm13349062wmo.48.2023.11.06.12.39.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Nov 2023 12:39:17 -0800 (PST)
From: Dylan Yudaken <dyudaken@gmail.com>
To: io-uring@vger.kernel.org
Cc: axboe@kernel.dk,
	asml.silence@gmail.com,
	Dylan Yudaken <dyudaken@gmail.com>
Subject: [PATCH v2 1/3] io_uring: indicate if io_kbuf_recycle did recycle anything
Date: Mon,  6 Nov 2023 20:39:07 +0000
Message-ID: <20231106203909.197089-2-dyudaken@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231106203909.197089-1-dyudaken@gmail.com>
References: <20231106203909.197089-1-dyudaken@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It can be useful to know if io_kbuf_recycle did actually recycle the
buffer on the request, or if it left the request alone.

Signed-off-by: Dylan Yudaken <dyudaken@gmail.com>
---
 io_uring/kbuf.c |  6 +++---
 io_uring/kbuf.h | 13 ++++++++-----
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index fea06810b43d..a1e4239c7d75 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -52,7 +52,7 @@ static int io_buffer_add_list(struct io_ring_ctx *ctx,
 	return xa_err(xa_store(&ctx->io_bl_xa, bgid, bl, GFP_KERNEL));
 }
 
-void io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags)
+bool io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_buffer_list *bl;
@@ -65,7 +65,7 @@ void io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags)
 	 * multiple use.
 	 */
 	if (req->flags & REQ_F_PARTIAL_IO)
-		return;
+		return false;
 
 	io_ring_submit_lock(ctx, issue_flags);
 
@@ -76,7 +76,7 @@ void io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags)
 	req->buf_index = buf->bgid;
 
 	io_ring_submit_unlock(ctx, issue_flags);
-	return;
+	return true;
 }
 
 unsigned int __io_put_kbuf(struct io_kiocb *req, unsigned issue_flags)
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index d14345ef61fc..f2d615236b2c 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -53,11 +53,11 @@ int io_unregister_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg);
 
 unsigned int __io_put_kbuf(struct io_kiocb *req, unsigned issue_flags);
 
-void io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags);
+bool io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags);
 
 void *io_pbuf_get_address(struct io_ring_ctx *ctx, unsigned long bgid);
 
-static inline void io_kbuf_recycle_ring(struct io_kiocb *req)
+static inline bool io_kbuf_recycle_ring(struct io_kiocb *req)
 {
 	/*
 	 * We don't need to recycle for REQ_F_BUFFER_RING, we can just clear
@@ -80,8 +80,10 @@ static inline void io_kbuf_recycle_ring(struct io_kiocb *req)
 		} else {
 			req->buf_index = req->buf_list->bgid;
 			req->flags &= ~REQ_F_BUFFER_RING;
+			return true;
 		}
 	}
+	return false;
 }
 
 static inline bool io_do_buffer_select(struct io_kiocb *req)
@@ -91,12 +93,13 @@ static inline bool io_do_buffer_select(struct io_kiocb *req)
 	return !(req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING));
 }
 
-static inline void io_kbuf_recycle(struct io_kiocb *req, unsigned issue_flags)
+static inline bool io_kbuf_recycle(struct io_kiocb *req, unsigned issue_flags)
 {
 	if (req->flags & REQ_F_BUFFER_SELECTED)
-		io_kbuf_recycle_legacy(req, issue_flags);
+		return io_kbuf_recycle_legacy(req, issue_flags);
 	if (req->flags & REQ_F_BUFFER_RING)
-		io_kbuf_recycle_ring(req);
+		return io_kbuf_recycle_ring(req);
+	return false;
 }
 
 static inline unsigned int __io_put_kbuf_list(struct io_kiocb *req,
-- 
2.41.0


