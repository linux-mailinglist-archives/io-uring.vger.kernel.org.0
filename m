Return-Path: <io-uring+bounces-6995-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 38010A56CF2
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 17:02:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5EE13B611E
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 16:00:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C669B22156E;
	Fri,  7 Mar 2025 15:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LnBRAuU8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75E222156A
	for <io-uring@vger.kernel.org>; Fri,  7 Mar 2025 15:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741363191; cv=none; b=OtclzY7y82hndqdQC0U9uQVDf7MXZ+PY2GTEMwa0HuGVMYTO7//HB3FxLFPKzbKMU0wOR+iCrQpuPM7exV6hfm4j0GJyYM96VwYLXW0suHdWhVaU4oNN4I4XfT3jl9M7hcPma/kMABrpJWkEEUekXAkhU7crxdBcXEiRgM6i2SI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741363191; c=relaxed/simple;
	bh=CTDOfIKLiLS36vq6sL2sgn5lKY5hbvt0oCtkq6B9W9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VrrMcIVMt55dmdjqiKazMxHA/MHhPkFQ3iy76qRqcKsPdBLHwROKeRbUPmGRyt/a9pVB/ngAXMKgLRC2DU+CBNwatDLiaa2vuFzpdgyPfZB/GpMJX7GVFwrxrbOXwsjkUEVblwsv31EftzgfwU0uqtZD2fODVZw/vmVbAHIUroM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LnBRAuU8; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-abf45d8db04so309858566b.1
        for <io-uring@vger.kernel.org>; Fri, 07 Mar 2025 07:59:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741363187; x=1741967987; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=REKT0J5DTDfZxhTt80Rxhy0qO38B5z+7gPhcbN7SaII=;
        b=LnBRAuU8vQqN9zq0VQIzVq5tgjo698/8Nf8J3R3u1jjsfl+tg55k51NFqk2m/qi68D
         76oWw0BgKgJCVTU1Q5X3rb5+OAN6NvPoLn5fqy/Wb46iQ7pRI/Ua4cOSDbeRqqhTojcD
         sSUe27Lg0v1IWWe8yLIXwwqfVV4CLy+w7rdj0FmxJx//y03Zmbh65A02cPySU+nkSnV6
         ViR3VPs3sogKupsmH9ZieBTZ6IVqeot3rNuT9lY0Z3mZ5qGIxQZsn+R/B5qWnwmPCj6R
         WQPaEISDUmKw/whLVi6Y0RU4zRkzoLrnc/pOcMohG3GBcntuD8jvVmxEUXUktaOdn36D
         qHrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741363187; x=1741967987;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=REKT0J5DTDfZxhTt80Rxhy0qO38B5z+7gPhcbN7SaII=;
        b=DbOXT4RBlBqD86zsOfHlqUeVTq+0B8DDfXAkZiN2vYaL+5rVegTuk1nP/XC4EXOke1
         v6RZ/O8F5XQA3cbwbkriGJawGno91hAKln4mXq6K335zvGMUhnen/sp0hl3G98/Z1vEY
         gXQygy9nHCe05AnuG7xtoDE7arbIDI4dxnKII27KSbaqNkTzueg8rmaKrlIx+2rDVLJS
         S5qcr9tU2hZJdh13xdQnDZ1eMMQpGhgU+IdCinpQGDbXeUvmYKhnhpLHiy2PvQGLnDpI
         V53fRSbMFYTsfVjALewiMihHZHkYRFys9vwlSX8TKaay6nVbZ1+GwkVJtn9zxxS5wEm2
         Fkyw==
X-Gm-Message-State: AOJu0YzbCBgrKktE3jWPCu2V4G77+6xf8y4+PfjFhJq9SOLgOcVF6JPp
	5aVfzR/ZNZj8ujv4o6k4onWBDnWuxGIrCNfJwUlERL8kT+RIb5XI5p4QrQ==
X-Gm-Gg: ASbGncs7VEq8hbKFY/OQQazN7snLLWNJMJOp6oauqLXv022qOij006FZ5+oy6v5+cgq
	HGYp32CVgRcFlt5buv2E1IJt6KM4H9kmqK2hY6y47JhzNbymZkKGOcTqwu/Q5vLe8Tk4mwg8uRR
	BC0avHaIJWm+BduQ5HmZtOp5pcnnhIn5n5HvfBmvdKWceXzF5G5kRrmiLsfWzOmeqAyg/SJ12VX
	eov2ek/FJlbMJVEZwxalgYLO4nFotkoSNWo7W0Ki/8L1cWjLL2EE0NUUyoA56scqqirnpBw8xk7
	Mr5tk+7YwlXTMBrA3t6DskkcsDRC
X-Google-Smtp-Source: AGHT+IH99pHifUa/pfyYPQcoE2fd5F1+3SNbhJmNu/sgS6YPnCTS4AAkCm40ViUENemOL7XIPmXFwQ==
X-Received: by 2002:a17:907:d25:b0:abf:4f72:538e with SMTP id a640c23a62f3a-ac252f42b35mr379317266b.55.1741363187284;
        Fri, 07 Mar 2025 07:59:47 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:a068])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac2399d7a17sm297369166b.179.2025.03.07.07.59.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 07:59:46 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v4 3/9] io_uring/rw: implement vectored registered rw
Date: Fri,  7 Mar 2025 16:00:31 +0000
Message-ID: <d7c89eb481e870f598edc91cc66ff4d1e4ae3788.1741362889.git.asml.silence@gmail.com>
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


