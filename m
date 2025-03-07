Return-Path: <io-uring+bounces-6989-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F004A56C8B
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 16:48:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D066189079B
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 15:48:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 792FC21CFF6;
	Fri,  7 Mar 2025 15:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VdydvhaU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D281DF71
	for <io-uring@vger.kernel.org>; Fri,  7 Mar 2025 15:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741362503; cv=none; b=ScVn4GkA7sybvVAzMJRXqq1KqOiYvgJFxGcSRJsaKzTnvb4AWs7XYSUml0Z2kseKQlUHkvrDBcjI+3Vrd8wO25fdqDHdQTgntVD5hehTrLOfes44gaOhk8VVYl39sTEMHMkYOBRO6SDX9gaCCM9xmU/NOGtnJi6xcfnNNxd8bZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741362503; c=relaxed/simple;
	bh=+ko6qVLwFbY8p2fCkuMHNRIwwTZQjN0AL9uVp4qcr08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZKTTn9N8UbioiO4jBY8vCeIrjfJP4Jqxpb79VqS7AVbV2I0XKb+nGan+798DpQv4ySXrUCLqAZ3AzqoJuD47HcbamlgN0rmiZ/SH7n2Y3ZknAiJgqdgyPwZR7/3yzqJuz9ZvkioPuPqZ8NZpC3aZVPQRgz5aZhQ7IWgB6H/xgTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VdydvhaU; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5e5c7d6b96fso3185434a12.3
        for <io-uring@vger.kernel.org>; Fri, 07 Mar 2025 07:48:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741362499; x=1741967299; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yljV5A1erT6qwC3xVxpqpVfrN9r/MNCu0zylOYIEozc=;
        b=VdydvhaUg5Mdvo+6pey7ci+gjz/lg0GStXgyQNiacYVHAYDukHqUtUhWez5gBENs1x
         GcGHWl8q2Q9SXWVX0fczYM2d2sOoC4zmihjGGaBx236EGEORf6sWxppF8pLB3Xpxt+sE
         S/vSBHRR3wS5YE2a1gnu4GvlkvghcHWIdvsZHjXhY5AbOrDZ0we2gvyPaWfZH2ojK0TD
         quPXutSDo92rh12NwRn/m8oMZlCDg9RotY426GJcw86BWXXqCKPmdlkFL/0y9W8iTmRS
         zJZW+OR18Kv3uvRdJ3a+EP8OlR8QE0S9zkhBIgwMylJ1BLEDRrAYfzSOBGJImmVaPUcO
         VGRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741362499; x=1741967299;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yljV5A1erT6qwC3xVxpqpVfrN9r/MNCu0zylOYIEozc=;
        b=wlVrP+qK7MbdbT4PmaFBCGNnd038fcBLhK+w8flxMQGxmL5y4H5A9iQP42QTRcI2Yh
         VC6pN2k1dmn/dcMf7NrRfC4MnXUGgf6uNLLPemG6UKOhk+cWYcxuXzl4RGCjocNjCE2D
         fP1KUfL+4rpflU6CE3+zb+SNrQIySwiAl/TZ7zwggNfzKeFiY1VhhpKsQ+yuxxY/lFrv
         Os6WZwRFPKdLRoxp9aiiqtlNIzLuNw/vbEDFW7BZHiI8qXdtbh2eCiZhdsZk7VzNhO5d
         1eDW0bW30ckPdIUC5er2tkc9p6H8ztSDdAEMRTIAqIsKuKx1W8RN2mKxQ5YKZyLSDBIq
         aTmg==
X-Gm-Message-State: AOJu0YzMIILr1PUh7Sr7r9bQUzccUw3xeJgzw7bJ92n050hS7LKLxw8N
	Z/OjVTQra4qxydsxOehMTdWeAXHW7rysvsJbsSAYTQPv0lwy61/06ygTTw==
X-Gm-Gg: ASbGncuOcjAn9ax5ckzp3LyMAONzXmqUn47YzOYk+vAvkMUEDSfAVTCDr2+5HNASvgF
	pKO04T3ZFmOpVr1ytZ/mArcglie5Da81K1bmIuMFyyrMnVi9aSD8iPkGxOoOrpacNGShrOhQOIQ
	NJsVBsVSeyF0NIPuXk7c1IyYumxSpTeRd14KQ6cDY6/VCNwIEJku5psquOULnuuVLwNOQpk/Swb
	JlMl3W25l2I89QU+KspwTbHM07pAZrecPYiXesoxKXdw9uZz2WHxM+MdHShJKdzyy7YIDDzJFjw
	O+55rXvTHYU1/hhpeGY23g8UHpgO
X-Google-Smtp-Source: AGHT+IF2tLXtQyqecrT83VDAwCbmRXARWHJkEL39+aFQZQpoqpfFSFC04GaIDnabETmi07kSUDn/LQ==
X-Received: by 2002:a50:8dca:0:b0:5e5:bd8d:edb9 with SMTP id 4fb4d7f45d1cf-5e5e22db548mr3514793a12.10.1741362499192;
        Fri, 07 Mar 2025 07:48:19 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:1422])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e5c766a033sm2665591a12.56.2025.03.07.07.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 07:48:18 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 8/9] io_uring/net: implement vectored reg bufs for zctx
Date: Fri,  7 Mar 2025 15:49:09 +0000
Message-ID: <ae30f9c33e40eb685e54fc94e8194dc6b93ce33b.1741361926.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1741361926.git.asml.silence@gmail.com>
References: <cover.1741361926.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for vectored registered buffers for send zc.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 59 ++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 55 insertions(+), 4 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index a4b39343f345..5e27c22e1d58 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -395,6 +395,44 @@ static int io_sendmsg_setup(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	return io_sendmsg_copy_hdr(req, kmsg);
 }
 
+static int io_sendmsg_zc_setup(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
+	struct io_async_msghdr *kmsg = req->async_data;
+	struct user_msghdr msg;
+	int ret, iovec_off;
+	struct iovec *iov;
+	void *res;
+
+	if (!(sr->flags & IORING_RECVSEND_FIXED_BUF))
+		return io_sendmsg_setup(req, sqe);
+
+	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
+
+	ret = io_msg_copy_hdr(req, kmsg, &msg, ITER_SOURCE, NULL);
+	if (unlikely(ret))
+		return ret;
+	sr->msg_control = kmsg->msg.msg_control_user;
+
+	if (msg.msg_iovlen > kmsg->vec.nr || WARN_ON_ONCE(!kmsg->vec.iovec)) {
+		ret = io_vec_realloc(&kmsg->vec, msg.msg_iovlen);
+		if (ret)
+			return ret;
+		req->flags |= REQ_F_NEED_CLEANUP;
+	}
+	iovec_off = kmsg->vec.nr - msg.msg_iovlen;
+	iov = kmsg->vec.iovec + iovec_off;
+
+	res = iovec_from_user(msg.msg_iov, msg.msg_iovlen, kmsg->vec.nr, iov,
+			      io_is_compat(req->ctx));
+	if (IS_ERR(res))
+		return PTR_ERR(res);
+
+	kmsg->msg.msg_iter.nr_segs = msg.msg_iovlen;
+	req->flags |= REQ_F_IMPORT_BUFFER;
+	return ret;
+}
+
 #define SENDMSG_FLAGS (IORING_RECVSEND_POLL_FIRST | IORING_RECVSEND_BUNDLE)
 
 int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -1333,8 +1371,6 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (req->opcode != IORING_OP_SEND_ZC) {
 		if (unlikely(sqe->addr2 || sqe->file_index))
 			return -EINVAL;
-		if (unlikely(zc->flags & IORING_RECVSEND_FIXED_BUF))
-			return -EINVAL;
 	}
 
 	zc->len = READ_ONCE(sqe->len);
@@ -1350,7 +1386,7 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return -ENOMEM;
 	if (req->opcode != IORING_OP_SENDMSG_ZC)
 		return io_send_setup(req, sqe);
-	return io_sendmsg_setup(req, sqe);
+	return io_sendmsg_zc_setup(req, sqe);
 }
 
 static int io_sg_from_iter_iovec(struct sk_buff *skb,
@@ -1506,6 +1542,22 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 	unsigned flags;
 	int ret, min_ret = 0;
 
+	kmsg->msg.sg_from_iter = io_sg_from_iter_iovec;
+
+	if (req->flags & REQ_F_IMPORT_BUFFER) {
+		unsigned uvec_segs = kmsg->msg.msg_iter.nr_segs;
+		unsigned iovec_off = kmsg->vec.nr - uvec_segs;
+		int ret;
+
+		ret = io_import_reg_vec(ITER_SOURCE, &kmsg->msg.msg_iter, req,
+					&kmsg->vec, uvec_segs, iovec_off,
+					issue_flags);
+		if (unlikely(ret))
+			return ret;
+		kmsg->msg.sg_from_iter = io_sg_from_iter;
+		req->flags &= ~REQ_F_IMPORT_BUFFER;
+	}
+
 	sock = sock_from_file(req->file);
 	if (unlikely(!sock))
 		return -ENOTSOCK;
@@ -1524,7 +1576,6 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 
 	kmsg->msg.msg_control_user = sr->msg_control;
 	kmsg->msg.msg_ubuf = &io_notif_to_data(sr->notif)->uarg;
-	kmsg->msg.sg_from_iter = io_sg_from_iter_iovec;
 	ret = __sys_sendmsg_sock(sock, &kmsg->msg, flags);
 
 	if (unlikely(ret < min_ret)) {
-- 
2.48.1


