Return-Path: <io-uring+bounces-11200-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 15C55CCB00D
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 09:49:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A1C3230AECBE
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 08:42:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AC77334C25;
	Thu, 18 Dec 2025 08:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y/6qwSLN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2380A334C03
	for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 08:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766046908; cv=none; b=HpjI+XNSv4rvdoXWyDpcel43vBRVyxB25IzxoVcycpSxMo44KpdxSiUUdjsGikgLQIzFjD93HLtl3jNr3Wgm9Fx9FYO6fSXxIjKLZPVjVTnyxn9aDt/D/UOa2+aHqKEYKGmlBVW5LfarmHvUDh5hU+imdaHgqfMEUUq+8Htvwm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766046908; c=relaxed/simple;
	bh=soNDjN4Hg1HDbO6N47LyqeWtDuXMqLoY2KmCpUhlAu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oWUTQU/8Pa/RhMm7yFend3qNVmNuiExblBOjkjVRjlA7Oi3gxa+RJyjb9WMCKEZufkCzSU9J6sfEUbM52A9t3pN3YS8HTT6kcEhgVZ/Xj391V8WIrL/wQKB+U9tMg0kDI/x9vDAnGBCY+lrwOyV1T+wlx0XWd0fCGTqjGcg8bx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y/6qwSLN; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7aa2170adf9so358821b3a.0
        for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 00:35:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766046906; x=1766651706; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r+PMOnADpkrXPeja+JJtAc/R9LXegQj84x9pa/zMxiU=;
        b=Y/6qwSLNnEmV7KjZd0iA7st64ozvXr2DaDHBTWiU//JiVQc/h0B1yIqaM2o6s1tg5B
         yM+1lnPoT1sXj+L+dSzyXjw2xXCHll2lLHgNKrMTM0RfwVo25/L7BOte7Cra9H6rjUPr
         rIWKyX9LdUdSxQEMGa+N0ndCIFNWPahjxgHN97vAP1/gIRgSAAazA1R6fqjsvcDUIOle
         eTMPXDvH0DhXzYjeFVfmKROJ4qRlACmlABGJCqWn5P+ybBUAhvjxqgjeWDS/ZiGvzsvs
         ABSzxUEZeUtO1Wi45Yl3B+w5bnfnUVUgRLjOyo1olZ0kegfGHcTP8cvfamPeNirEsHNA
         2+Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766046906; x=1766651706;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=r+PMOnADpkrXPeja+JJtAc/R9LXegQj84x9pa/zMxiU=;
        b=kBk7jrezX9vmstuRDfX6UauxiTy/B8j0MDzkyQx6dxCArsxYoEcn0vuHwrqFEP2ZDT
         AxdDd6M1HJGK89cAUhHQLz1TviuscL19QWbplgW3ydmzyAVmFVcAg30XDZDDvFgNhF8B
         QHacQjQdJEGiazLuKiOOEmX8t3pViWuwiQXeIB7jRkviPJF1bwF5UEKK4Afhy4fW5p/e
         0TYnEASF8L6mpVuOXF3g2w8glSglpLMZNEdiIrQdJjdYIJ+X6iZxoMq6n+r3SqdMBDpW
         qMgZF6ZiEtncvtD2xb5NjwVxNoIuMue1kUk/8xUHDmysEyE8WZ//Yj9F//7Sn4+0021L
         7JCQ==
X-Forwarded-Encrypted: i=1; AJvYcCXfVpg7QlfaUAWXlXRN/m+TYjeQGdy7piOtAeSfAZIfDvC4HrcktdFPqiLJzJcAI16MTAZCCZJoZQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzjaGTp+qXQU+JdQyTMBOEHOeMwBvOsuCWiNzbWMXHtnn/HKhXO
	ZtPXN+OwGUsSkgWn+r7S3Lletqfn1zKuw/BmTJnQhv30k7tlGcB6YpRv
X-Gm-Gg: AY/fxX73w1f4b+hZbz+srpZEtOnevIMAx+Mc29POhzerF3fQf7TIpJjhkMRYkPFOPNK
	EqPu8w8cV863rauq5LAMa4aQSexWpMzqQmXygKmgOv6VtSar5Iz3dgj9p3qUPYcglUmhaKuCA/7
	Yt6oi0pxsQQ3e7Rc/1arMFzK3Z0S6tnAxtv+cj3kClrds3B/BF9bg6WeSGc1QjNZff+L+9InUZq
	lKHfXG81LGJWzR1zmPUfTFJGSzDuXYgmQkcn9FHsgiMm+qN9blLsMfWu7ZB8tUgA8uw3uDWocdc
	LiiTDWt7wsjfSoYjD3Rf7rBQq+LUzmtEHWA/RHv8dW46QGFBFZUDcQkOEv8riR0M8wNgSgWVFGR
	DZi85hBzfLyNNapF1fbgCFrKmKKUAZ6OzfZlJA2IthByemaxkjVgSAR/S8jucgJYQdCkzyRRH21
	w2uBs6hDHsZAf1B52fqA==
X-Google-Smtp-Source: AGHT+IFTf6hgc77gMUc6f1jkSA+JSeUFqQghikSLh65K23vmizl8bpdvr/mjNVjn5bYHMIHvZoKGEQ==
X-Received: by 2002:a05:6a20:3d84:b0:35e:8b76:c960 with SMTP id adf61e73a8af0-369af527c2cmr21965226637.48.1766046906261;
        Thu, 18 Dec 2025 00:35:06 -0800 (PST)
Received: from localhost ([2a03:2880:ff:5d::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c1d2fffa3e7sm1582279a12.24.2025.12.18.00.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 00:35:06 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 20/25] io_uring/rsrc: rename io_buffer_register_bvec()/io_buffer_unregister_bvec()
Date: Thu, 18 Dec 2025 00:33:14 -0800
Message-ID: <20251218083319.3485503-21-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251218083319.3485503-1-joannelkoong@gmail.com>
References: <20251218083319.3485503-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, io_buffer_register_bvec() takes in a request. In preparation
for supporting kernel-populated buffers in fuse io-uring (which will
need to register bvecs directly, not through a struct request), rename
this to io_buffer_register_request().

A subsequent patch will commandeer the "io_buffer_register_bvec()"
function name to support registering bvecs directly.

Rename io_buffer_unregister_bvec() to a more generic name,
io_buffer_unregister(), as both io_buffer_register_request() and
io_buffer_register_bvec() callers will use it for unregistration.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 Documentation/block/ublk.rst | 14 +++++++-------
 drivers/block/ublk_drv.c     | 18 +++++++++---------
 include/linux/io_uring/cmd.h | 26 ++++++++++++++++++++------
 io_uring/rsrc.c              | 14 +++++++-------
 4 files changed, 43 insertions(+), 29 deletions(-)

diff --git a/Documentation/block/ublk.rst b/Documentation/block/ublk.rst
index 8c4030bcabb6..aa6e0bf9405b 100644
--- a/Documentation/block/ublk.rst
+++ b/Documentation/block/ublk.rst
@@ -326,17 +326,17 @@ Zero copy
 ---------
 
 ublk zero copy relies on io_uring's fixed kernel buffer, which provides
-two APIs: `io_buffer_register_bvec()` and `io_buffer_unregister_bvec`.
+two APIs: `io_buffer_register_request()` and `io_buffer_unregister`.
 
 ublk adds IO command of `UBLK_IO_REGISTER_IO_BUF` to call
-`io_buffer_register_bvec()` for ublk server to register client request
+`io_buffer_register_request()` for ublk server to register client request
 buffer into io_uring buffer table, then ublk server can submit io_uring
 IOs with the registered buffer index. IO command of `UBLK_IO_UNREGISTER_IO_BUF`
-calls `io_buffer_unregister_bvec()` to unregister the buffer, which is
-guaranteed to be live between calling `io_buffer_register_bvec()` and
-`io_buffer_unregister_bvec()`. Any io_uring operation which supports this
-kind of kernel buffer will grab one reference of the buffer until the
-operation is completed.
+calls `io_buffer_unregister()` to unregister the buffer, which is guaranteed
+to be live between calling `io_buffer_register_request()` and
+`io_buffer_unregister()`. Any io_uring operation which supports this kind of
+kernel buffer will grab one reference of the buffer until the operation is
+completed.
 
 ublk server implementing zero copy or user copy has to be CAP_SYS_ADMIN and
 be trusted, because it is ublk server's responsibility to make sure IO buffer
diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index df9831783a13..0a42f6a75b62 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1202,8 +1202,8 @@ __ublk_do_auto_buf_reg(const struct ublk_queue *ubq, struct request *req,
 {
 	int ret;
 
-	ret = io_buffer_register_bvec(cmd, req, ublk_io_release,
-				      io->buf.auto_reg.index, issue_flags);
+	ret = io_buffer_register_request(cmd, req, ublk_io_release,
+					 io->buf.auto_reg.index, issue_flags);
 	if (ret) {
 		if (io->buf.auto_reg.flags & UBLK_AUTO_BUF_REG_FALLBACK) {
 			ublk_auto_buf_reg_fallback(ubq, req->tag);
@@ -2166,8 +2166,8 @@ static int ublk_register_io_buf(struct io_uring_cmd *cmd,
 	if (!req)
 		return -EINVAL;
 
-	ret = io_buffer_register_bvec(cmd, req, ublk_io_release, index,
-				      issue_flags);
+	ret = io_buffer_register_request(cmd, req, ublk_io_release, index,
+					 issue_flags);
 	if (ret) {
 		ublk_put_req_ref(io, req);
 		return ret;
@@ -2198,8 +2198,8 @@ ublk_daemon_register_io_buf(struct io_uring_cmd *cmd,
 	if (!ublk_dev_support_zero_copy(ub) || !ublk_rq_has_data(req))
 		return -EINVAL;
 
-	ret = io_buffer_register_bvec(cmd, req, ublk_io_release, index,
-				      issue_flags);
+	ret = io_buffer_register_request(cmd, req, ublk_io_release, index,
+					 issue_flags);
 	if (ret)
 		return ret;
 
@@ -2214,7 +2214,7 @@ static int ublk_unregister_io_buf(struct io_uring_cmd *cmd,
 	if (!(ub->dev_info.flags & UBLK_F_SUPPORT_ZERO_COPY))
 		return -EINVAL;
 
-	return io_buffer_unregister_bvec(cmd, index, issue_flags);
+	return io_buffer_unregister(cmd, index, issue_flags);
 }
 
 static int ublk_check_fetch_buf(const struct ublk_device *ub, __u64 buf_addr)
@@ -2350,7 +2350,7 @@ static int ublk_ch_uring_cmd_local(struct io_uring_cmd *cmd,
 		goto out;
 
 	/*
-	 * io_buffer_unregister_bvec() doesn't access the ubq or io,
+	 * io_buffer_unregister() doesn't access the ubq or io,
 	 * so no need to validate the q_id, tag, or task
 	 */
 	if (_IOC_NR(cmd_op) == UBLK_IO_UNREGISTER_IO_BUF)
@@ -2420,7 +2420,7 @@ static int ublk_ch_uring_cmd_local(struct io_uring_cmd *cmd,
 
 		/* can't touch 'ublk_io' any more */
 		if (buf_idx != UBLK_INVALID_BUF_IDX)
-			io_buffer_unregister_bvec(cmd, buf_idx, issue_flags);
+			io_buffer_unregister(cmd, buf_idx, issue_flags);
 		if (req_op(req) == REQ_OP_ZONE_APPEND)
 			req->__sector = addr;
 		if (compl)
diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 61c4ca863ef6..06e4cfadb344 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -102,6 +102,12 @@ int io_uring_cmd_kmbuffer_recycle(struct io_uring_cmd *cmd,
 
 int io_uring_cmd_is_kmbuf_ring(struct io_uring_cmd *ioucmd,
 			       unsigned int buf_group, unsigned int issue_flags);
+
+int io_buffer_register_request(struct io_uring_cmd *cmd, struct request *rq,
+			       void (*release)(void *), unsigned int index,
+			       unsigned int issue_flags);
+int io_buffer_unregister(struct io_uring_cmd *cmd, unsigned int index,
+			 unsigned int issue_flags);
 #else
 static inline int
 io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
@@ -185,6 +191,20 @@ static inline int io_uring_cmd_is_kmbuf_ring(struct io_uring_cmd *ioucmd,
 {
 	return -EOPNOTSUPP;
 }
+static inline int io_buffer_register_request(struct io_uring_cmd *cmd,
+					     struct request *rq,
+					     void (*release)(void *),
+					     unsigned int index,
+					     unsigned int issue_flags)
+{
+	return -EOPNOTSUPP;
+}
+static inline int io_buffer_unregister(struct io_uring_cmd *cmd,
+				       unsigned int index,
+				       unsigned int issue_flags)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 static inline struct io_uring_cmd *io_uring_cmd_from_tw(struct io_tw_req tw_req)
@@ -234,10 +254,4 @@ static inline void io_uring_cmd_done32(struct io_uring_cmd *ioucmd, s32 ret,
 	return __io_uring_cmd_done(ioucmd, ret, res2, issue_flags, true);
 }
 
-int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq,
-			    void (*release)(void *), unsigned int index,
-			    unsigned int issue_flags);
-int io_buffer_unregister_bvec(struct io_uring_cmd *cmd, unsigned int index,
-			      unsigned int issue_flags);
-
 #endif /* _LINUX_IO_URING_CMD_H */
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index a141aaeb099d..b25b418e5c11 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -936,9 +936,9 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 	return ret;
 }
 
-int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq,
-			    void (*release)(void *), unsigned int index,
-			    unsigned int issue_flags)
+int io_buffer_register_request(struct io_uring_cmd *cmd, struct request *rq,
+			       void (*release)(void *), unsigned int index,
+			       unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
 	struct io_rsrc_data *data = &ctx->buf_table;
@@ -998,10 +998,10 @@ int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq,
 	io_ring_submit_unlock(ctx, issue_flags);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(io_buffer_register_bvec);
+EXPORT_SYMBOL_GPL(io_buffer_register_request);
 
-int io_buffer_unregister_bvec(struct io_uring_cmd *cmd, unsigned int index,
-			      unsigned int issue_flags)
+int io_buffer_unregister(struct io_uring_cmd *cmd, unsigned int index,
+			 unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
 	struct io_rsrc_data *data = &ctx->buf_table;
@@ -1031,7 +1031,7 @@ int io_buffer_unregister_bvec(struct io_uring_cmd *cmd, unsigned int index,
 	io_ring_submit_unlock(ctx, issue_flags);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(io_buffer_unregister_bvec);
+EXPORT_SYMBOL_GPL(io_buffer_unregister);
 
 static int validate_fixed_range(u64 buf_addr, size_t len,
 				const struct io_mapped_ubuf *imu)
-- 
2.47.3


