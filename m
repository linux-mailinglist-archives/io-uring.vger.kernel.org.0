Return-Path: <io-uring+bounces-6908-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 56C96A4C5AE
	for <lists+io-uring@lfdr.de>; Mon,  3 Mar 2025 16:51:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9DDAB3A64CC
	for <lists+io-uring@lfdr.de>; Mon,  3 Mar 2025 15:50:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0079214A6C;
	Mon,  3 Mar 2025 15:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lVNg8c/I"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5A921481D
	for <io-uring@vger.kernel.org>; Mon,  3 Mar 2025 15:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741017008; cv=none; b=W3bVxymouiA8oDXw+6dmuTbwfzIgjzUaoCWj5uQ2sZ+sNGWMMbcSjlltWEu4EnTS0ysXt8peec580I9S0G1vZlbblfl6rjUJ3RTjs+dfNNF9La29HNNMP0u82pLOq6YOPctmrimXHZh5NvBQYPfAO8u/gFTwT131NDfh9i+/CbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741017008; c=relaxed/simple;
	bh=/k+C4WrIcyZoM7DP6xOSy0mBPHla12k1sfjHglsWHKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JBwWkNcTr6s4Oa8ZC+RCcIHdta2Ld+WfzRLePv33BB6u3nLEmiqmmo51+whzAOgtIbw01jP+of9KsgaYBhzlG6EgSynVuHFh7z2JaPvZt3vRytdvBsJD4y/r0z8z+DP6yzlyyRxqsDMMVmDUsLRi5L4AuzVwY2+zADlw/quNzv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lVNg8c/I; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5e4b410e48bso6983169a12.0
        for <io-uring@vger.kernel.org>; Mon, 03 Mar 2025 07:50:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741017005; x=1741621805; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MXOQyWnlq5tzOu2N0NICEtzunR0KjmiKmSNM3Jri7zM=;
        b=lVNg8c/IsBpaWIb8Wxt0ZllF8Co0ekaj0ujaqROdpM0raj9DVdDRh77K7t9rL7kH4+
         +lvq3IEKqRY7IxNBz8IuIrMzKgViOMJEHkH7zL0Y9W4Pjf+DKGo2rXG3KZOyvUf44vyq
         PzLbbH2r3h5LsoSfxeeqlTHDWsTQovsvDJGaxUQuCqmekzxBWmfjOXxUZjgF6maqv+fh
         7USLofssZ82O9Z+NToF28lhSYPJROYU/Eud+58UQf+o4afMs/MxVz2V6ZTPS27K4opPy
         oMuDTJ8YjzJUcxQ7YT9FuzgPJx9BXA+D0CmVG4jYtoDzogNFCsN0R5C66qZSUmuXJPWw
         TBjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741017005; x=1741621805;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MXOQyWnlq5tzOu2N0NICEtzunR0KjmiKmSNM3Jri7zM=;
        b=LjTLORv8siQHKA8gPsF5xiwvw+vrdVFEl67hebg5q5MEB8kurC0qau9yc8bWJLYWf0
         O9ZGeq0Cz36l9zkjsvZpc38kusZq/vNi/C8ZEmcLKblnzrSdyqKQ6pu1zyO90aMD+fF0
         chrcBWRmLetLz8wjK0uSHVna9FpMg/JdAzvpxqm+GFtdu4UTpluZY2jGTWcOtd/P7Q+N
         N5G2cK3HqPMjnSXxXXXV6tCwRwgn/5E/FSGXdBYJc0/rkTuyTMvLuiSyNqvjrAU+6iQ6
         CGBSl0dDBNI7ONJf4/2RCaXVSV2Ag1n3t0UwOhNMpKpuc3WHVzDFUMTC4wTJBDuk93Rb
         O4Vg==
X-Gm-Message-State: AOJu0YxV7xOUnE2TH76yaMoAW+jE58Wp0AS1C4H0yn44ooTj1G+sRCUX
	Yp4Gg1vPoY/EsNv9JPS+cbTYKZ9d7TI2/FT5A6X8T+bYLtEDkr2HKmyGWg==
X-Gm-Gg: ASbGnctPzlQyxeL7VnOm/1gVaYy85jN1LKaYBi0AGfPYERokHfi7L6+ctggdGq7akz6
	42ljwHHDJ5E7AX41nx6Yr9mP0E0HD5q1A96JWMvshHnkzcIMfdlJOqqg4e/UBrkVBCaPuFigCzs
	IAmoTFOop7bFxL7da24NMZPIVQNynCV5LbW7j3dw3Y5B06N71MtkcsRQE5Qu2ylPI58fb2um9o2
	uH+sfeBAjSV/1Nu2r3olIbX1A0WgOHyZBLoBmVqRhC5kkbfO+kuQ07rLXA/3D1FEyCDcdcQjPEp
	h8eZ75ZB2wTolc0fW3sv+IQgcpj6
X-Google-Smtp-Source: AGHT+IHuOrAZfretqhG4WseQbBXsQ/v93bwmCEqyNVRhm+hhSR/Z0iPuHqYAd6aMOFslnY/R4v0fEw==
X-Received: by 2002:a17:907:3f29:b0:ac1:eebf:9d0 with SMTP id a640c23a62f3a-ac1eebf0a41mr13495566b.31.1741017004663;
        Mon, 03 Mar 2025 07:50:04 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:299a])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf4e50c80esm492335266b.61.2025.03.03.07.50.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Mar 2025 07:50:03 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Andres Freund <andres@anarazel.de>
Subject: [PATCH 3/8] io_uring/rw: implement vectored registered rw
Date: Mon,  3 Mar 2025 15:50:58 +0000
Message-ID: <444a0ab0c3dc6320c5604a06284923a7abefa145.1741014186.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1741014186.git.asml.silence@gmail.com>
References: <cover.1741014186.git.asml.silence@gmail.com>
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
index 1e02e94bc26d..9dd384b369ee 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -280,6 +280,8 @@ enum io_uring_op {
 	IORING_OP_BIND,
 	IORING_OP_LISTEN,
 	IORING_OP_RECV_ZC,
+	IORING_OP_READV_FIXED,
+	IORING_OP_WRITEV_FIXED,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 9511262c513e..6655d2cbf74d 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -529,6 +529,35 @@ const struct io_issue_def io_issue_defs[] = {
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
@@ -761,6 +790,16 @@ const struct io_cold_def io_cold_defs[] = {
 	[IORING_OP_RECV_ZC] = {
 		.name			= "RECV_ZC",
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
index e86a3858f48b..475b6306a316 100644
--- a/io_uring/rw.h
+++ b/io_uring/rw.h
@@ -34,6 +34,8 @@ struct io_async_rw {
 
 int io_prep_read_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_prep_write_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_prep_readv_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_prep_writev_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_prep_readv(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_prep_writev(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_prep_read(struct io_kiocb *req, const struct io_uring_sqe *sqe);
-- 
2.48.1


