Return-Path: <io-uring+bounces-7037-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F311A57CB4
	for <lists+io-uring@lfdr.de>; Sat,  8 Mar 2025 19:20:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 292083B177F
	for <lists+io-uring@lfdr.de>; Sat,  8 Mar 2025 18:20:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EB061E8356;
	Sat,  8 Mar 2025 18:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WN0fxy96"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435112A8C1
	for <io-uring@vger.kernel.org>; Sat,  8 Mar 2025 18:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741458038; cv=none; b=A3iJE4MSFh+cm1YStsCsfjzVFBSgKei/ZeF2Cf/hmsSZ5mEWrzxzs+LpU/16a4KIjRW+z0/81DawMgRsR6WdjXVAEtrkuz2XkPBiPnwfpJEaV9v2vw3/Zs8bFvJRd8+AGkDj6wxaxVtLLLHsqqMAceNbYSR4hpDHpX4PKTqkhiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741458038; c=relaxed/simple;
	bh=vRdyNFhikLV5Jc8kVej/r2WTMmGWWwjOIHEr5gLt6h4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RPzZezPeyJ6v3ARyz9/xkfsEkfzkAZhixLzcX0WgygwLt1ArECADiy0W/bPOQUsil7Gf52eHzOSQfE75nBkiwzqNADgnYO7To/TvWgOAw9zF4YdxvkHEurH9gj04mcn8xynQ1qaYBdxaVbkC/NumML1xZUJxKrJoUS2HncYRWIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WN0fxy96; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-390effd3e85so2565904f8f.0
        for <io-uring@vger.kernel.org>; Sat, 08 Mar 2025 10:20:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741458034; x=1742062834; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y4G6UhwDG6Iv2+x8Xu6Fvxj6TrNlbTxoIn+pduaKuzs=;
        b=WN0fxy967xAxHh63dFF8lsI9gfyiQrPXZf5/LK5o9tk7EqfIlbx/G1pnf08Cm1Pood
         P3N6id3S3L3KZpvRrNPdP3fM06IwQqHMkd4k36ZmF2+8U8czaj4K3G9Ltu0Wm/lW90Y4
         QJpHkGwmejGJ6CYChMQtfrNR3tJcpj8Lgx5lT/GlcNurmuxXnOr3Axfpa7Xew1sRFaPr
         tDex5VD16JoDQ8Jy7oKOOuX3Sn8hOMRjZhHCBwzvlWak5G6GXh/9+w+N0chRXaBtjZAY
         9Zs2xiGOb5gATlD5tO+VMJYNjeGrJIOpHf7vzYPD16LoRW79MH7xNHcswgk7V1trPqBo
         aOvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741458034; x=1742062834;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y4G6UhwDG6Iv2+x8Xu6Fvxj6TrNlbTxoIn+pduaKuzs=;
        b=sXy8Mh7WmwA0jVQUmcJISl8v7/82H0qT5N3A/aJ9pHVvjzHmPOnn2DpXZfYTYpY5r0
         73SE0OUX3oPcsEsbOXAS2gUsvf07ohwztWZyA8+ccOUMcJkzr5oT9Z403HVEuk5M0DkX
         5wv1oWl/RPdr+POjnbmLqv9xRKKQRSaPZli17OinhSore4y/WwmzXArp0gNWs/Qpl8dz
         tr61NPmVrlLNzI10VjADBRdgBAqE4tiZye7WuVzgHAuSnq76ACRgypSC9+V6yrZWOtEx
         lMkKku4V9tuHYjDzWjTsxCPPY3o7nhYQengqjA3oAEu3fY3A8sWCtZI2N6Py1c+hdyUW
         yiZA==
X-Gm-Message-State: AOJu0YzvnJ8X9KUdiDG8oNA+WDKpIkM5zyaXq180roX1vhQzBjZXiL17
	h8T6B//R87jb43ei8BDphR9qZAdFQNxkiOpWBpt+glesgDejL4YKKyZreA==
X-Gm-Gg: ASbGnctLOTNLA5N6j/O5M0nSnnEMNq8XrB09gGJqxrK8AsYUjkpeEy1nTMY4MhkZTzw
	CMHz9CRBI6/MwA90I+RO87yPSE5GaTIlJeTtl41P51pLNC65R9J/nhBOzc0hDp5w90wui89oirv
	J8mN2VADVXOafb5WntUtcvxkakqIgik4wCcpw3nKkaOQ/4aCgg5K1Wm+bYz2GTgGlR+JIcvfE3y
	0YS7SrCWJ4Y18f6QDPCEKOxRjB/Bq7HEffRfQ9V7HtTpSvJTYYOgzo/4LW5jz9lZhIII29LIkQ0
	lvc471CKx96nAh+Gi7aqAX1j+wFlMkQfYnrbUTus65zBJEtWmOZ9WS7WVQ==
X-Google-Smtp-Source: AGHT+IFnnNV4Kqyn8IRIb8OnorMzsQtJOplx15ipSuoZf0Q0S8XPwNTeFAPElyiD8aS1xhVwx3djyQ==
X-Received: by 2002:a5d:64ec:0:b0:391:3406:b4e2 with SMTP id ffacd0b85a97d-3913406b7e9mr4960630f8f.49.1741458033924;
        Sat, 08 Mar 2025 10:20:33 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.236.160])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912c106a1asm9472996f8f.100.2025.03.08.10.20.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Mar 2025 10:20:33 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/2] io_uring: introduce io_prep_reg_iovec()
Date: Sat,  8 Mar 2025 18:21:15 +0000
Message-ID: <7de2ecb9ed5efc3c5cf320232236966da5ad4ccc.1741457480.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1741457480.git.asml.silence@gmail.com>
References: <cover.1741457480.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

iovecs that are turned into registered buffers are imported in a special
way with an offset, so that later we can do an in place translation. Add
a helper function taking care of it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c  | 23 +++--------------------
 io_uring/rsrc.c | 26 ++++++++++++++++++++++++++
 io_uring/rsrc.h |  2 ++
 io_uring/rw.c   | 21 +--------------------
 4 files changed, 32 insertions(+), 40 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 9fa5c9570875..6b8dbadf445f 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -403,9 +403,7 @@ static int io_sendmsg_zc_setup(struct io_kiocb *req, const struct io_uring_sqe *
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr *kmsg = req->async_data;
 	struct user_msghdr msg;
-	int ret, iovec_off;
-	struct iovec *iov;
-	void *res;
+	int ret;
 
 	if (!(sr->flags & IORING_RECVSEND_FIXED_BUF))
 		return io_sendmsg_setup(req, sqe);
@@ -416,24 +414,9 @@ static int io_sendmsg_zc_setup(struct io_kiocb *req, const struct io_uring_sqe *
 	if (unlikely(ret))
 		return ret;
 	sr->msg_control = kmsg->msg.msg_control_user;
-
-	if (msg.msg_iovlen > kmsg->vec.nr || WARN_ON_ONCE(!kmsg->vec.iovec)) {
-		ret = io_vec_realloc(&kmsg->vec, msg.msg_iovlen);
-		if (ret)
-			return ret;
-		req->flags |= REQ_F_NEED_CLEANUP;
-	}
-	iovec_off = kmsg->vec.nr - msg.msg_iovlen;
-	iov = kmsg->vec.iovec + iovec_off;
-
-	res = iovec_from_user(msg.msg_iov, msg.msg_iovlen, kmsg->vec.nr, iov,
-			      io_is_compat(req->ctx));
-	if (IS_ERR(res))
-		return PTR_ERR(res);
-
 	kmsg->msg.msg_iter.nr_segs = msg.msg_iovlen;
-	req->flags |= REQ_F_IMPORT_BUFFER;
-	return ret;
+
+	return io_prep_reg_iovec(req, &kmsg->vec, msg.msg_iov, msg.msg_iovlen);
 }
 
 #define SENDMSG_FLAGS (IORING_RECVSEND_POLL_FIRST | IORING_RECVSEND_BUNDLE)
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 71fe47facd4c..0e413e910f3d 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1397,3 +1397,29 @@ int io_import_reg_vec(int ddir, struct iov_iter *iter,
 
 	return io_vec_fill_bvec(ddir, iter, imu, iov, nr_iovs, vec);
 }
+
+int io_prep_reg_iovec(struct io_kiocb *req, struct iou_vec *iv,
+		      const struct iovec __user *uvec, size_t uvec_segs)
+{
+	struct iovec *iov;
+	int iovec_off, ret;
+	void *res;
+
+	if (uvec_segs > iv->nr) {
+		ret = io_vec_realloc(iv, uvec_segs);
+		if (ret)
+			return ret;
+		req->flags |= REQ_F_NEED_CLEANUP;
+	}
+
+	/* pad iovec to the right */
+	iovec_off = iv->nr - uvec_segs;
+	iov = iv->iovec + iovec_off;
+	res = iovec_from_user(uvec, uvec_segs, uvec_segs, iov,
+			      io_is_compat(req->ctx));
+	if (IS_ERR(res))
+		return PTR_ERR(res);
+
+	req->flags |= REQ_F_IMPORT_BUFFER;
+	return 0;
+}
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index b0097c06b577..43f784915573 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -67,6 +67,8 @@ int io_import_reg_vec(int ddir, struct iov_iter *iter,
 			struct io_kiocb *req, struct iou_vec *vec,
 			unsigned nr_iovs, unsigned iovec_off,
 			unsigned issue_flags);
+int io_prep_reg_iovec(struct io_kiocb *req, struct iou_vec *iv,
+			const struct iovec __user *uvec, size_t uvec_segs);
 
 int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg);
 int io_sqe_buffers_unregister(struct io_ring_ctx *ctx);
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 50037313555f..4861b876f48e 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -407,28 +407,9 @@ static int io_rw_prep_reg_vec(struct io_kiocb *req)
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 	struct io_async_rw *io = req->async_data;
 	const struct iovec __user *uvec;
-	size_t uvec_segs = rw->len;
-	struct iovec *iov;
-	int iovec_off, ret;
-	void *res;
 
-	if (uvec_segs > io->vec.nr) {
-		ret = io_vec_realloc(&io->vec, uvec_segs);
-		if (ret)
-			return ret;
-		req->flags |= REQ_F_NEED_CLEANUP;
-	}
-	/* pad iovec to the right */
-	iovec_off = io->vec.nr - uvec_segs;
-	iov = io->vec.iovec + iovec_off;
 	uvec = u64_to_user_ptr(rw->addr);
-	res = iovec_from_user(uvec, uvec_segs, uvec_segs, iov,
-			      io_is_compat(req->ctx));
-	if (IS_ERR(res))
-		return PTR_ERR(res);
-
-	req->flags |= REQ_F_IMPORT_BUFFER;
-	return 0;
+	return io_prep_reg_iovec(req, &io->vec, uvec, rw->len);
 }
 
 int io_prep_readv_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe)
-- 
2.48.1


