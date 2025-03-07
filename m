Return-Path: <io-uring+bounces-7000-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AABBA56CED
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 17:01:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8F039166A34
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 16:00:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60B972206B5;
	Fri,  7 Mar 2025 15:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c7ffU+wz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7924F22156B
	for <io-uring@vger.kernel.org>; Fri,  7 Mar 2025 15:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741363197; cv=none; b=BzPhmyEmz0CXy8rEyZQ0sD16auvMODCRPGpPfa6TxxVS63bE4L8Z9uQJvml3x65Im8f+P+eEPGdKNbfbL/b9tH/4Yi38h9vWe/9G9aypVCU3pPmoayuutjk0qurLPk7f+P2mP6jDN8FoHGkbqHK+ul0HQW6A/ewTdllWayxTcdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741363197; c=relaxed/simple;
	bh=+ko6qVLwFbY8p2fCkuMHNRIwwTZQjN0AL9uVp4qcr08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KaxMpjg/pOw64o3yiMJD6lYPDPZKhft2wRESGiSLl2OUVxXaldzZ83tJKj8lJqjm7ElRlYc6SMw9sa6uxHhpTBuiKa2LJ5OVngrB3EKyNF8OOtDqsSJdokNGLZhhmgFT+RX7DFnT/+BFCpdbXTZMbSPWjQiOwkliUwpxtF3z8uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c7ffU+wz; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-abf615d5f31so380925266b.2
        for <io-uring@vger.kernel.org>; Fri, 07 Mar 2025 07:59:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741363193; x=1741967993; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yljV5A1erT6qwC3xVxpqpVfrN9r/MNCu0zylOYIEozc=;
        b=c7ffU+wzkCUeF/8p726acNqKHgYa3BsIz8uzk1YG6SB54kXJ6ISpKm3a3JwGQbEP2u
         p3SffSHc331P3Qsil1ZiEe5glsjrRrAKjcB/6iW1s9PGytPQgnfv3R75ZZlxHQtK1iTh
         GJRwIHkWkayqjN69N+Kun+T7/7Ex4b5P9Jiw2aQ4g+8sl56rDrqXG+/8U+kPSGvdlo7x
         4eLBTPfemuRdJ+RAKY8GY+md+MCkcNomCqYDSl9wolS9ZLZj/eGjeSqQZ+6ztaftKRMP
         cwpBUH2t5QtR8TVfIlxj9tzruKbkThGvuF0ksU2kckhTYgRhZIzGmRkeNGkBzBvdVyyr
         YWZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741363193; x=1741967993;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yljV5A1erT6qwC3xVxpqpVfrN9r/MNCu0zylOYIEozc=;
        b=bQ8F3yi+6pRp1x9nO0fzvqIR6pCLlJ+W4CgcLZ8Acq1AB8MsEfzGkPb0HOuKbJ24wA
         pWf8os42rDvtXsI8A4Pyl+/oiafXH/bZYhD8aHG/4LqJPNSYLlCVrxzh8PrY9f94e4za
         PUA0XdmF2sEHpQH8rOAAJR8hh7MlGpfO6JvDm3/cI02hKg8lXKMiRSPS+L+yCwOIjYXU
         7l3xw3dIWBPS8FLHSGi+OHimV+w666tlR3QgbwbWW5eDMddJ2NR+ho1IhYX6v3995RSi
         /30hGqeYSJ1v+ybQ+dl2NZD9wTQtr/nrd5m9EGeZfXEAYE4zzwmnoxzgZJD6hGpSoESh
         4/FA==
X-Gm-Message-State: AOJu0YzFN0v92RwNlQ+K3F2k1QpKuGIQD+9taUtNBA/tYKkSt10Dgvfd
	Q78Ejqn85lZRqwtkmonTkrlh7Qs5C3DV6I7caNo8LO2+qSUrMVeFTNMdCQ==
X-Gm-Gg: ASbGncsLyJ2k63y2f7AE5OJ+H7Ddg00CCmbwgTiCperu9XnOGWLPGIOTfhrUmF4d5M2
	FDbl2y7priSIE/bNw3fiVKBTnWiB0QOFz0vn2upJ+oBl8iS02f5SJkbP/eMug1yapY3ed1LNf8V
	2s93OdwcTVocPlwdlt2KcZle+fD6ZbuFoF2yLxltatrB23YO3xOfSAmssKYt7ZsTR2n91861H/y
	RJszpRCXlE0XMtHmPlMaeuBYSGVlxfzYfPLCTYt1c6jZccO/ZE4IonFZ08WcrnivYhXWjbCCTyC
	Ud5Vgvxv8uPSAs3ba6I55Yh7yWFS
X-Google-Smtp-Source: AGHT+IEJwFn4cbFZCXEtmv6uj8zTX03Aq/LaWQ0s1B2IxViGBe8PpdOB/EtXCA8vQqsWu9YOSR+9RA==
X-Received: by 2002:a17:907:158a:b0:ac1:e0fd:a81e with SMTP id a640c23a62f3a-ac252630d02mr317185166b.21.1741363192770;
        Fri, 07 Mar 2025 07:59:52 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:a068])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac2399d7a17sm297369166b.179.2025.03.07.07.59.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 07:59:51 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v4 8/9] io_uring/net: implement vectored reg bufs for zctx
Date: Fri,  7 Mar 2025 16:00:36 +0000
Message-ID: <e484052875f862d2dca99f0f8c04407c1d51a1c1.1741362889.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1741362889.git.asml.silence@gmail.com>
References: <cover.1741362889.git.asml.silence@gmail.com>
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


