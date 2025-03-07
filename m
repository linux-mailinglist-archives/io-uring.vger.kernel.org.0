Return-Path: <io-uring+bounces-6985-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B21FAA56C87
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 16:48:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F02B71891373
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 15:48:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C912621D3D1;
	Fri,  7 Mar 2025 15:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XTJA2GJX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1FA9194C78
	for <io-uring@vger.kernel.org>; Fri,  7 Mar 2025 15:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741362497; cv=none; b=EP7EZlWGpzdseHdpbdVD/qP05iYa/Z0aEVQ5JPgOpPJQ47jN/rizQYtXyQIKzeiLyrWoDH8pSLg/QZsO8H5bxbuWZCOzIV5cR4od4robi+7D9ouIzguTTP5ybX/BI5l45eIiqEzDKY2mp3N8bi0bP/ojtV/05ket0SB/iiP8RQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741362497; c=relaxed/simple;
	bh=CTDOfIKLiLS36vq6sL2sgn5lKY5hbvt0oCtkq6B9W9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SmSetNzUManLWJ55LRQksHLbIRtHGnMBPsly3Zn74uCuzQaV3RULJeYHyzF9N6CyhsqqAfspgsjfBj4v6XZqooBasYi4dcfQIdmkpsJ2rRsB49UvhrdBN1s7srUZTDRrI6wAjty/ASPViRxYMlbc2CE/2IImOHTidiwJiAiwvgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XTJA2GJX; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5e5cded3e2eso2739825a12.0
        for <io-uring@vger.kernel.org>; Fri, 07 Mar 2025 07:48:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741362494; x=1741967294; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=REKT0J5DTDfZxhTt80Rxhy0qO38B5z+7gPhcbN7SaII=;
        b=XTJA2GJXKKEsHSGTouSB+QvviV0w4GIZyz+RGGa6E/8IdhByxhS1Okr7Gttr60Omiq
         kxi+CVarsbzaDuCPeB70JDPtcpERLBTRlWGDy2myv8+wBQf3pnpT0XGzNQmJpFKeJ3lS
         ubCfuBdfmiZ0AZVlkSBG8WHBApkn+6VyjDlwT83J1wmBMCs15QIIrTEVZOxE68dH98b/
         JzVRw4KrBMtj59qWBrw00qNf9APE4sVaXXe+GmglxxGBDapXORoD/Vqk59dDp5djt0I6
         o/1KBV6HXiPF5hLNNn+ataympqpQ7YO11drRxA+Qvcn3hU7yxrR93a6w2m4HMg1E5VKm
         PCEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741362494; x=1741967294;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=REKT0J5DTDfZxhTt80Rxhy0qO38B5z+7gPhcbN7SaII=;
        b=HvvhHkKpwBuyIjNBHQsZHTsJKrSOn/jYe7V4Q5BxWLkPgMicfXU1p0M4UUAKnDoRg4
         jb63xh1RBvEoNREuGXgO8F4TZk69NCeIv8MJnbd++tqQmq5LbNL+SuOVX8ANxaQ+r6lT
         jEaqjjA+di3BV2h4HgW90h7we7WNzl40b8QeKqZ5LWhtlb3yWlwPXNbzO8mywhOwHlYI
         KuqLTz8XEEmknouzGADxQSBUXw/dqDaGHEXb/QgoP2oWiVsBiuSr6YrAWFqp83j+44zY
         16SiKGcQ1wSZiGDpOJfBcywjyNb8tHlN7Wjx8a6QtI0jGqJKhWxwIXttQTw3NKn6lKEs
         9E5g==
X-Gm-Message-State: AOJu0YxygNqCZLy8PkBKtYJG4Mbqk951DdM8qxVgCuGNWM8pESwCG5JB
	vpM7KINigSfyI+Kb36u6nB8+3HDQ3Rfji6e030FpQFc1Sp5Ge8qvuWQM1Q==
X-Gm-Gg: ASbGncuRI9uPcIa2CrnxcrOiKADK2Ruz7FKmt4a6cLbz/9k6a/l6Ryp/2n/U+DIPEKc
	8yeaAVvq4L4CT40ja/Oz6QdT8oUbfc/V0IKFJAraRKm+03pnFOfo8XMNl09Mslfk+Aat/KZyIRH
	a2hv8GamGxMe2QxFBUNomDUBhZKt5j5gZaY1H3/2YHwSQBgMLiJIfnfWh0a7qkeQSa6k0+VtG+y
	OpDxqqLLrFOupmAmyhpg9haXWNEcqwpv1zrplRXrfy8YPqgXIwwO5PllsSKdl+/zk1dNWTqbDt9
	IDLAkJrK8D8wrB/JSrS59e9AaPFx
X-Google-Smtp-Source: AGHT+IFFy4WaJE3ajLQ1SRwAJzN7hQgbSbqi4RDF9DWFDuDMdSHp5dm2Wc9bvgfrKYcHuL2m1f1xlA==
X-Received: by 2002:a05:6402:2793:b0:5dc:cf9b:b048 with SMTP id 4fb4d7f45d1cf-5e5e22a96bbmr3705563a12.1.1741362493511;
        Fri, 07 Mar 2025 07:48:13 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:1422])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e5c766a033sm2665591a12.56.2025.03.07.07.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 07:48:12 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 3/9] io_uring/rw: implement vectored registered rw
Date: Fri,  7 Mar 2025 15:49:04 +0000
Message-ID: <beb0bf561a9ff264f2d93070762c852106f85b5c.1741361926.git.asml.silence@gmail.com>
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

Implement registered buffer vectored reads with new opcodes
IORING_OP_WRITEV_FIXED and IORING_OP_READV_FIXED.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h |  2 ++
 io_uring/opdef.c              | 39 +++++++++++++++++++++++++++
 io_uring/rw.c                 | 51 +++++++++++++++++++++++++++++++++++
 io_uring/rw.h                 |  2 ++
 4 files changed, 94 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 3d99bf9bbf61..9e5eec7490bb 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -281,6 +281,8 @@ enum io_uring_op {
 	IORING_OP_LISTEN,
 	IORING_OP_RECV_ZC,
 	IORING_OP_EPOLL_WAIT,
+	IORING_OP_READV_FIXED,
+	IORING_OP_WRITEV_FIXED,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index db77df513d55..7fd173197b1e 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -540,6 +540,35 @@ const struct io_issue_def io_issue_defs[] = {
 		.prep			= io_eopnotsupp_prep,
 #endif
 	},
+	[IORING_OP_READV_FIXED] = {
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.pollin			= 1,
+		.plug			= 1,
+		.audit_skip		= 1,
+		.ioprio			= 1,
+		.iopoll			= 1,
+		.iopoll_queue		= 1,
+		.vectored		= 1,
+		.async_size		= sizeof(struct io_async_rw),
+		.prep			= io_prep_readv_fixed,
+		.issue			= io_read,
+	},
+	[IORING_OP_WRITEV_FIXED] = {
+		.needs_file		= 1,
+		.hash_reg_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.pollout		= 1,
+		.plug			= 1,
+		.audit_skip		= 1,
+		.ioprio			= 1,
+		.iopoll			= 1,
+		.iopoll_queue		= 1,
+		.vectored		= 1,
+		.async_size		= sizeof(struct io_async_rw),
+		.prep			= io_prep_writev_fixed,
+		.issue			= io_write,
+	},
 };
 
 const struct io_cold_def io_cold_defs[] = {
@@ -775,6 +804,16 @@ const struct io_cold_def io_cold_defs[] = {
 	[IORING_OP_EPOLL_WAIT] = {
 		.name			= "EPOLL_WAIT",
 	},
+	[IORING_OP_READV_FIXED] = {
+		.name			= "READV_FIXED",
+		.cleanup		= io_readv_writev_cleanup,
+		.fail			= io_rw_fail,
+	},
+	[IORING_OP_WRITEV_FIXED] = {
+		.name			= "WRITEV_FIXED",
+		.cleanup		= io_readv_writev_cleanup,
+		.fail			= io_rw_fail,
+	},
 };
 
 const char *io_uring_get_opcode(u8 opcode)
diff --git a/io_uring/rw.c b/io_uring/rw.c
index ad7f647d48e9..4c4229f41aaa 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -381,6 +381,57 @@ int io_prep_write_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return __io_prep_rw(req, sqe, ITER_SOURCE);
 }
 
+static int io_rw_prep_reg_vec(struct io_kiocb *req, int ddir)
+{
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
+	struct io_async_rw *io = req->async_data;
+	const struct iovec __user *uvec;
+	size_t uvec_segs = rw->len;
+	struct iovec *iov;
+	int iovec_off, ret;
+	void *res;
+
+	if (uvec_segs > io->vec.nr) {
+		ret = io_vec_realloc(&io->vec, uvec_segs);
+		if (ret)
+			return ret;
+		req->flags |= REQ_F_NEED_CLEANUP;
+	}
+	/* pad iovec to the right */
+	iovec_off = io->vec.nr - uvec_segs;
+	iov = io->vec.iovec + iovec_off;
+	uvec = u64_to_user_ptr(rw->addr);
+	res = iovec_from_user(uvec, uvec_segs, uvec_segs, iov,
+			      io_is_compat(req->ctx));
+	if (IS_ERR(res))
+		return PTR_ERR(res);
+
+	ret = io_import_reg_vec(ddir, &io->iter, req, &io->vec,
+				uvec_segs, iovec_off, 0);
+	iov_iter_save_state(&io->iter, &io->iter_state);
+	return ret;
+}
+
+int io_prep_readv_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	int ret;
+
+	ret = __io_prep_rw(req, sqe, ITER_DEST);
+	if (unlikely(ret))
+		return ret;
+	return io_rw_prep_reg_vec(req, ITER_DEST);
+}
+
+int io_prep_writev_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	int ret;
+
+	ret = __io_prep_rw(req, sqe, ITER_SOURCE);
+	if (unlikely(ret))
+		return ret;
+	return io_rw_prep_reg_vec(req, ITER_SOURCE);
+}
+
 /*
  * Multishot read is prepared just like a normal read/write request, only
  * difference is that we set the MULTISHOT flag.
diff --git a/io_uring/rw.h b/io_uring/rw.h
index 529fd2f96a7f..81d6d9a8cf69 100644
--- a/io_uring/rw.h
+++ b/io_uring/rw.h
@@ -32,6 +32,8 @@ struct io_async_rw {
 
 int io_prep_read_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_prep_write_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_prep_readv_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_prep_writev_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_prep_readv(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_prep_writev(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_prep_read(struct io_kiocb *req, const struct io_uring_sqe *sqe);
-- 
2.48.1


