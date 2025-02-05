Return-Path: <io-uring+bounces-6273-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B9D2DA28963
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2025 12:37:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DACF9188896D
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2025 11:37:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B311222A4D9;
	Wed,  5 Feb 2025 11:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lwplOp/s"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB24722A4E1
	for <io-uring@vger.kernel.org>; Wed,  5 Feb 2025 11:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738755422; cv=none; b=nYpcmuUtN2xwlKDNg+3xkUwEaqAuugP1CAGu8OidbOEahU/TGuoqfEref9Dn5+to6XDpCeO078cxqlv4XkqHe5Ybft3RDWhSuJRTPyLDb3r9/AG9d0sxEY3bobUwDgocFVRE8T1bPnBDri6AJOlBRwly1QG8Z3jk4t3/VSy4vQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738755422; c=relaxed/simple;
	bh=M3QeKR3rEadmhAMGo5LEhYRK14X+WHtxcXUeoL4bX1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OajXvnkal/E9KGzXLO9RNLQtw0AKUlh7gAuy4fKYk6XFXtljcEFsvA/UNuAozSHG3ZNJ3Bm04E8NmCbiiXl6MFTQU9JTN0vV6d/8h3RAB6Gg9HwK4G1kOG4LnHbaJE2WOIar1xGRlFvXKeXxQecg6hROA8OAIAgJLKbEUA1nVG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lwplOp/s; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-436a39e4891so45783665e9.1
        for <io-uring@vger.kernel.org>; Wed, 05 Feb 2025 03:37:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738755419; x=1739360219; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tE+cKByEWWXThcjMWTmzJSol4RltuG6Uf0Z6BAELz0M=;
        b=lwplOp/s4oAvFvGsOQMw1Xe0v6H6HKsgSlfUuHeBN5rNFudbzqOroKmEc4hG6i3xxt
         U+epbEUlConA50cA6iIEqM2lWQbfgIe4emDtTcu5pOm9Ou0ea2uy4Utz28enHuwd0Ddq
         DEpjZ7HPW0u3bKKtzbuTAaBGfV466BgN0sjn7O2Uny50v9uIFcdR2IUBvENDjUJ+Dt66
         vAEXZFFOqUSwMS8SBanJJgG/dljdH1qbU3ZFpqbYUtZ1iCaGdyf8yaYg0czZooeqnQd7
         2vI8nZOfYq7mZV0crbDJenqd3UEi3b8rItCzJh5KwO1qrjrFDnYzqQrEl0OcAHM13J2a
         H9fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738755419; x=1739360219;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tE+cKByEWWXThcjMWTmzJSol4RltuG6Uf0Z6BAELz0M=;
        b=SGUOo7AINCYXw2q70JVA1V8WY/cHNyFP/RzWWJoq08E7WuJbIJps9tkrvurxgofTgG
         5Y6Qx6U2fCLKJbLZ4ZwUgz0kfgeWNQcD9xSHy9x7gMLwP/+x43TwLQuRqhYTCoUhbi+Z
         m+y2h/sXw/GlF3Opf8Kx7XK1/FLakL2NZ8MblM8+/0iUq5O366NXhyLPK2oacnI37zP5
         ZjJmSxpuQ6xyBi1gTiVVGgra/H/vaZg/cKNO/4nVMLYJtDfS1H0Gi9Xgn7mN0o5gyKW+
         10zmjODMN3tB/4gdUSqjph66aiggXPYcMhwMhZjd9Gog/oF7pQtNk8rUkN1qTMyjXChd
         TGwA==
X-Gm-Message-State: AOJu0YzSYf5Hn1d9nFOQCl4CJJKFVg8z7rtgk/0QxspK6BIWUXCKOA0m
	2hhjUoJokDzCGQD//G+C5xIX48abYqd9ebUcLlSK7qdfjEB/JjCo/EVhDA==
X-Gm-Gg: ASbGnctlXiWzu2WHDb4lcAZ1jVThjl8oevVVnS/K6pbrsKpti1ZVhz6ITsE6DpwlSJh
	yCQx+tIYOslWQSYTssG9vOnfMmo3SkabNWxF+5W9OpOQUnpQAtJHURLgWdzHKWmbp22A4jVoV15
	j8PDQc+f0b17WROZjmnVzTkgw0dJBhDdQ9FbGJ+KjFn0lI+iF4tl0E/RFDPk54EQPAQ8S3AddWL
	c7jemi9f7jN8J/YtskgXZ6/Wg3kUXCB7dAPh1eOXmBazrNh9Z9Fx5fKvj4ThICT0iRbZ791sV8u
	cyfpOKgbDAbvrowdv/in4NOS0fY=
X-Google-Smtp-Source: AGHT+IHAdSKYB6RqLjr3zmaDlCpIlrXJVn0QdBTos7/yUD7pf9cDN5CSYae/+u2L5/NwH9nMeNkcSQ==
X-Received: by 2002:a05:600c:500d:b0:434:f1d5:1453 with SMTP id 5b1f17b1804b1-4390e88b7fdmr14799485e9.0.1738755418224;
        Wed, 05 Feb 2025 03:36:58 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.128.4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4390d94d7d4sm18514505e9.10.2025.02.05.03.36.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2025 03:36:57 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 8/8] io_uring/kbuf: uninline __io_put_kbufs
Date: Wed,  5 Feb 2025 11:36:49 +0000
Message-ID: <3dade7f55ad590e811aff83b1ec55c9c04e17b2b.1738724373.git.asml.silence@gmail.com>
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

__io_put_kbufs() and other helper functions are too large to be inlined,
compilers would normally refuse to do so. Uninline it and move together
with io_kbuf_commit into kbuf.c.

io_kbuf_commitSigned-off-by: Pavel Begunkov <asml.silence@gmail.com>

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/kbuf.c | 60 +++++++++++++++++++++++++++++++++++++++
 io_uring/kbuf.h | 74 +++++++------------------------------------------
 2 files changed, 70 insertions(+), 64 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 6d76108b67e03..319c5a25f72db 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -20,6 +20,9 @@
 /* BIDs are addressed by a 16-bit field in a CQE */
 #define MAX_BIDS_PER_BGID (1 << 16)
 
+/* Mapped buffer ring, return io_uring_buf from head */
+#define io_ring_head_to_buf(br, head, mask)	&(br)->bufs[(head) & (mask)]
+
 struct io_provide_buf {
 	struct file			*file;
 	__u64				addr;
@@ -29,6 +32,34 @@ struct io_provide_buf {
 	__u16				bid;
 };
 
+bool io_kbuf_commit(struct io_kiocb *req,
+		    struct io_buffer_list *bl, int len, int nr)
+{
+	if (unlikely(!(req->flags & REQ_F_BUFFERS_COMMIT)))
+		return true;
+
+	req->flags &= ~REQ_F_BUFFERS_COMMIT;
+
+	if (unlikely(len < 0))
+		return true;
+
+	if (bl->flags & IOBL_INC) {
+		struct io_uring_buf *buf;
+
+		buf = io_ring_head_to_buf(bl->buf_ring, bl->head, bl->mask);
+		if (WARN_ON_ONCE(len > buf->len))
+			len = buf->len;
+		buf->len -= len;
+		if (buf->len) {
+			buf->addr += len;
+			return false;
+		}
+	}
+
+	bl->head += nr;
+	return true;
+}
+
 static inline struct io_buffer_list *io_buffer_get_list(struct io_ring_ctx *ctx,
 							unsigned int bgid)
 {
@@ -323,6 +354,35 @@ int io_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg)
 	return io_provided_buffers_select(req, &arg->max_len, bl, arg->iovs);
 }
 
+static inline bool __io_put_kbuf_ring(struct io_kiocb *req, int len, int nr)
+{
+	struct io_buffer_list *bl = req->buf_list;
+	bool ret = true;
+
+	if (bl) {
+		ret = io_kbuf_commit(req, bl, len, nr);
+		req->buf_index = bl->bgid;
+	}
+	req->flags &= ~REQ_F_BUFFER_RING;
+	return ret;
+}
+
+unsigned int __io_put_kbufs(struct io_kiocb *req, int len, int nbufs)
+{
+	unsigned int ret;
+
+	ret = IORING_CQE_F_BUFFER | (req->buf_index << IORING_CQE_BUFFER_SHIFT);
+
+	if (unlikely(!(req->flags & REQ_F_BUFFER_RING))) {
+		io_kbuf_drop_legacy(req);
+		return ret;
+	}
+
+	if (!__io_put_kbuf_ring(req, len, nbufs))
+		ret |= IORING_CQE_F_BUF_MORE;
+	return ret;
+}
+
 static int __io_remove_buffers(struct io_ring_ctx *ctx,
 			       struct io_buffer_list *bl, unsigned nbufs)
 {
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 3e18c916afc60..2ec0b983ce243 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -77,6 +77,10 @@ int io_register_pbuf_status(struct io_ring_ctx *ctx, void __user *arg);
 bool io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags);
 void io_kbuf_drop_legacy(struct io_kiocb *req);
 
+unsigned int __io_put_kbufs(struct io_kiocb *req, int len, int nbufs);
+bool io_kbuf_commit(struct io_kiocb *req,
+		    struct io_buffer_list *bl, int len, int nr);
+
 struct io_mapped_region *io_pbuf_get_region(struct io_ring_ctx *ctx,
 					    unsigned int bgid);
 
@@ -115,77 +119,19 @@ static inline bool io_kbuf_recycle(struct io_kiocb *req, unsigned issue_flags)
 	return false;
 }
 
-/* Mapped buffer ring, return io_uring_buf from head */
-#define io_ring_head_to_buf(br, head, mask)	&(br)->bufs[(head) & (mask)]
-
-static inline bool io_kbuf_commit(struct io_kiocb *req,
-				  struct io_buffer_list *bl, int len, int nr)
-{
-	if (unlikely(!(req->flags & REQ_F_BUFFERS_COMMIT)))
-		return true;
-
-	req->flags &= ~REQ_F_BUFFERS_COMMIT;
-
-	if (unlikely(len < 0))
-		return true;
-
-	if (bl->flags & IOBL_INC) {
-		struct io_uring_buf *buf;
-
-		buf = io_ring_head_to_buf(bl->buf_ring, bl->head, bl->mask);
-		if (WARN_ON_ONCE(len > buf->len))
-			len = buf->len;
-		buf->len -= len;
-		if (buf->len) {
-			buf->addr += len;
-			return false;
-		}
-	}
-
-	bl->head += nr;
-	return true;
-}
-
-static inline bool __io_put_kbuf_ring(struct io_kiocb *req, int len, int nr)
-{
-	struct io_buffer_list *bl = req->buf_list;
-	bool ret = true;
-
-	if (bl) {
-		ret = io_kbuf_commit(req, bl, len, nr);
-		req->buf_index = bl->bgid;
-	}
-	req->flags &= ~REQ_F_BUFFER_RING;
-	return ret;
-}
-
-static inline unsigned int __io_put_kbufs(struct io_kiocb *req, int len,
-					  int nbufs, unsigned issue_flags)
-{
-	unsigned int ret;
-
-	if (!(req->flags & (REQ_F_BUFFER_RING | REQ_F_BUFFER_SELECTED)))
-		return 0;
-
-	ret = IORING_CQE_F_BUFFER | (req->buf_index << IORING_CQE_BUFFER_SHIFT);
-	if (req->flags & REQ_F_BUFFER_RING) {
-		if (!__io_put_kbuf_ring(req, len, nbufs))
-			ret |= IORING_CQE_F_BUF_MORE;
-	} else {
-		io_kbuf_drop_legacy(req);
-	}
-	return ret;
-}
-
 static inline unsigned int io_put_kbuf(struct io_kiocb *req, int len,
 				       unsigned issue_flags)
 {
-	return __io_put_kbufs(req, len, 1, issue_flags);
+	if (!(req->flags & (REQ_F_BUFFER_RING | REQ_F_BUFFER_SELECTED)))
+		return 0;
+	return __io_put_kbufs(req, len, 1);
 }
 
 static inline unsigned int io_put_kbufs(struct io_kiocb *req, int len,
 					int nbufs, unsigned issue_flags)
 {
-	return __io_put_kbufs(req, len, nbufs, issue_flags);
+	if (!(req->flags & (REQ_F_BUFFER_RING | REQ_F_BUFFER_SELECTED)))
+		return 0;
+	return __io_put_kbufs(req, len, nbufs);
 }
 #endif
-- 
2.47.1


