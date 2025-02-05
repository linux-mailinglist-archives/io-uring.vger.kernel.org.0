Return-Path: <io-uring+bounces-6272-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 55694A28968
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2025 12:37:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1768C3A54FA
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2025 11:36:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31E9022ACD4;
	Wed,  5 Feb 2025 11:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NH7bT2T8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E9422ACD7
	for <io-uring@vger.kernel.org>; Wed,  5 Feb 2025 11:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738755421; cv=none; b=J9uI/U08sVJTZ2/ElT1ub7GlaWFwmNSipLES+PDPhWhIFdKgfk14+w7iFCmViVPM92ar90O/zQXcdfjKRe5plsS4INrp7DUAfmsKlgXQsh8EN8qcA3gVzkUotr8rjux7OtRhHVDLMsR1+B9piHAmhDbAls+gyk/+DfmRfkxSAbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738755421; c=relaxed/simple;
	bh=fO3WIHRlQugLysD9UNt7Mq+Lb7PdSKoQ2Hw07m6RHq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rAELt7rByqa70EJXxrVw4uRRXqbuJBx3wgEfL9zSK4isPG84rjomBJKzgOaHtpCIABtl52iY096XRTafZv3Yy0cslhlAnYkMBpJg+Fw3n2223pimyfwn665srLOLpGqnZKzFEz01o4QZkt3IeLGrDOCKAvuibn84VGmJZsxWgu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NH7bT2T8; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4364a37a1d7so66020735e9.3
        for <io-uring@vger.kernel.org>; Wed, 05 Feb 2025 03:36:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738755417; x=1739360217; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HhExhce8Aiyglbiuep/ta6W+YhgIu1iQn6uz5vzEfYk=;
        b=NH7bT2T8oTQDr12DFfZnmrapqxNRFgQe7DHuas+c4h/kZMZmb8gOxMnddDlipQdPY+
         dvlpKhgoVcCjHmgzEoPZXWW4tOFuWqrEfYbRezTH8CefrLu7kYCwBVqyZfKHf/Oh4lDe
         AaMY5U4M7QYW7kEI7sgI4yAS/G0C8XcjklyoKbVp8izGfEFHZhmD63347qvAKzknnFDS
         BfGvbpBQjzcicRM5vnALA5fB48rIeYB+h2qo7UgQDOlfZDsr2fCkt6xQN7wjXn7S3jou
         ncFc9EKwQ8un6JCfAh6zWZO1KTME8UtuYpn/2HnZ989PZ0JL8zZkxSPiWwDaU3IBEzuZ
         Wn/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738755417; x=1739360217;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HhExhce8Aiyglbiuep/ta6W+YhgIu1iQn6uz5vzEfYk=;
        b=Gr8a837yqkkhzKerI5zcavcv6s4a28/IzaLgYU8pqk7gxZhbLM5Qy+rgqoI9LCZ8gI
         VAvRsewSnX7kp3ymOnC3PWOpcswK8hQ/S9W4HVOE4o8/IUPXut7wzYqdl08CsKRHh6Ym
         LgtJZNNS4peIk3DQ2h1bEgrxaaLl7MbC9qb4aFyYHXwVaSZzIznyh6YUCw4fF564f6fQ
         3GcFbxb01fXJJpO60l6LAhEIIfYMzaGhY08C+vxsZv1a1kUSk2tCpyEdN13xg9vOeirq
         yclhdNhOy17VNuXvJIOxXx7zk642mNAmvqrkD+IUy9oOtIEgeWfvlYgmesR98/HchaqG
         MOJQ==
X-Gm-Message-State: AOJu0YwTwkYE4U3Kg99Ot4OKP1eGEiGe7hx9eW+XkErpIyjjgkf4eqXy
	7rZXt5MyeGE6Aq5ua3/RRt7JPWLdVxb3/CRjj7u9v2mU77whHBgGqVX5nQ==
X-Gm-Gg: ASbGncsNp1/MjdhndISNIqsUVl9ng6m24GWOn/9GWP8RFJ8i4I2VX8ctooPxIHdFNMm
	XM7GJQ8ndbFKgfbMghu4BYtzf/LM9D3LjRN7KHhkqOqdJHiDZxUrhdGcJbBZoqWdJCOCu8VwQi0
	6kgjNzAfaAkHnBzPHks8C+HQZOWyuC8380n3urw5JxBGBCtruv2nLMK27KbziaCikV28Naheray
	WDRPNaH4eniXmPVxnWp8aaHnUPQrn7JfR7OmvcG+Y5+gK5Ce+6UK84nh2WqNtSqdr16NgGAcz03
	cA8BTyVpfB7JQTiM4SF5Ze22QS8=
X-Google-Smtp-Source: AGHT+IFdKhn0SfGvIFa8dvxYguULcGBNa9fF7bA1pOk4J99pvcl6zOMNQAd87PRMoWD3kPwXA64t1A==
X-Received: by 2002:a05:600c:1f8f:b0:434:ff30:a159 with SMTP id 5b1f17b1804b1-4390d34b326mr18629285e9.0.1738755416857;
        Wed, 05 Feb 2025 03:36:56 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.128.4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4390d94d7d4sm18514505e9.10.2025.02.05.03.36.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2025 03:36:55 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 7/8] io_uring/kbuf: introduce io_kbuf_drop_legacy()
Date: Wed,  5 Feb 2025 11:36:48 +0000
Message-ID: <c8cc73e2272f09a86ecbdad9ebdd8304f8e583c0.1738724373.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1738724373.git.asml.silence@gmail.com>
References: <cover.1738724373.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_kbuf_drop() is only used for legacy provided buffers, and so
__io_put_kbuf_list() is never called for REQ_F_BUFFER_RING. Remove the
dead branch out of __io_put_kbuf_list(), rename it into
io_kbuf_drop_legacy() and use it directly instead of io_kbuf_drop().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c |  2 +-
 io_uring/kbuf.c     | 10 ++++++++++
 io_uring/kbuf.h     | 24 ++----------------------
 3 files changed, 13 insertions(+), 23 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 969caaccce9d8..ec98a0ec6f34e 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -397,7 +397,7 @@ static bool req_need_defer(struct io_kiocb *req, u32 seq)
 static void io_clean_op(struct io_kiocb *req)
 {
 	if (unlikely(req->flags & REQ_F_BUFFER_SELECTED))
-		io_kbuf_drop(req);
+		io_kbuf_drop_legacy(req);
 
 	if (req->flags & REQ_F_NEED_CLEANUP) {
 		const struct io_cold_def *def = &io_cold_defs[req->opcode];
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index f41c141ae8eda..6d76108b67e03 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -50,6 +50,16 @@ static int io_buffer_add_list(struct io_ring_ctx *ctx,
 	return xa_err(xa_store(&ctx->io_bl_xa, bgid, bl, GFP_KERNEL));
 }
 
+void io_kbuf_drop_legacy(struct io_kiocb *req)
+{
+	if (WARN_ON_ONCE(!(req->flags & REQ_F_BUFFER_SELECTED)))
+		return;
+	req->buf_index = req->kbuf->bgid;
+	req->flags &= ~REQ_F_BUFFER_SELECTED;
+	kfree(req->kbuf);
+	req->kbuf = NULL;
+}
+
 bool io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 055b7a672f2e0..3e18c916afc60 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -75,6 +75,7 @@ int io_unregister_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg);
 int io_register_pbuf_status(struct io_ring_ctx *ctx, void __user *arg);
 
 bool io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags);
+void io_kbuf_drop_legacy(struct io_kiocb *req);
 
 struct io_mapped_region *io_pbuf_get_region(struct io_ring_ctx *ctx,
 					    unsigned int bgid);
@@ -158,27 +159,6 @@ static inline bool __io_put_kbuf_ring(struct io_kiocb *req, int len, int nr)
 	return ret;
 }
 
-static inline void __io_put_kbuf_list(struct io_kiocb *req, int len)
-{
-	if (req->flags & REQ_F_BUFFER_RING) {
-		__io_put_kbuf_ring(req, len, 1);
-	} else {
-		req->buf_index = req->kbuf->bgid;
-		req->flags &= ~REQ_F_BUFFER_SELECTED;
-		kfree(req->kbuf);
-		req->kbuf = NULL;
-	}
-}
-
-static inline void io_kbuf_drop(struct io_kiocb *req)
-{
-	if (!(req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING)))
-		return;
-
-	/* len == 0 is fine here, non-ring will always drop all of it */
-	__io_put_kbuf_list(req, 0);
-}
-
 static inline unsigned int __io_put_kbufs(struct io_kiocb *req, int len,
 					  int nbufs, unsigned issue_flags)
 {
@@ -192,7 +172,7 @@ static inline unsigned int __io_put_kbufs(struct io_kiocb *req, int len,
 		if (!__io_put_kbuf_ring(req, len, nbufs))
 			ret |= IORING_CQE_F_BUF_MORE;
 	} else {
-		__io_put_kbuf_list(req, len);
+		io_kbuf_drop_legacy(req);
 	}
 	return ret;
 }
-- 
2.47.1


