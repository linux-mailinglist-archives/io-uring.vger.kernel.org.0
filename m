Return-Path: <io-uring+bounces-6996-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D5D43A56CEB
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 17:01:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 09DDC17B175
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 16:00:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72E2422156A;
	Fri,  7 Mar 2025 15:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FJ0VZAY+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8670E194C78
	for <io-uring@vger.kernel.org>; Fri,  7 Mar 2025 15:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741363192; cv=none; b=insEzv5OFoWDFPAVlxzE6XYEOJ1vAmJyRwo54AqzwrDZXD8FO7tggfm6WvfY1eqCUquGrLDruCDy9bKq+haBcYpS7eQdAvbjZEnB7GQozoquwzahMv0QKu00x0o0yYAajXBcXAXD0gImjGBXCpvwzlPVrASM6mUSmYbA0bWCFCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741363192; c=relaxed/simple;
	bh=gNKF/L5J2pAWM9hL6RvdhhPWEP4Yq0qat+0Q7PL2fuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oFjYftPfFm/30KjLUkPOwYPGYO5gtD9UGKyf2zEEes5NIrJYnZb46w8eh6hwV6ZU/Zn3CsmNhe/fgMN3W+2rMrDZUdXw3T2sFdV1Oq+Ooc+CDs+x0WF4VHYPxaMmafzc/PddyhaDzPdYn8ogR/ABIYpAgZHe2gFfbmQ2FSz9pK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FJ0VZAY+; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-ac2400d1c01so326436566b.1
        for <io-uring@vger.kernel.org>; Fri, 07 Mar 2025 07:59:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741363188; x=1741967988; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=93tvkzOu0v7DF9VuZKcubARhjargqjujprNt6uu0n0M=;
        b=FJ0VZAY+yvxL5mE1UhWRYElrcCEg91v/gq9szfnPdT3bw0PHVhJjPB5Fo/OaR2oVCo
         O0dMG2AZFjRHdyqWcXVtw/SiUz0eaq//jI0vYnRdyl/YmGbXBAzhMHtNlx4/TLcuQ4Zy
         ADmCiK5IfwjyymToUrOO5BoNJZgBViGjV2dzQWnDvc+aJM2SL1cQRi6h1f7f+j/AG3X8
         zO0Noi1sjWc6P5lkLJh7SsboBniyRux3nq9/3JsW5Ilp0aIRzysDgykPcxGGlcMMEPCi
         jw4WEvoiHcz1UoaN+y3f+j1lyEOoM4IHLXeXhxxjsEGYXf0quMk7EkHic+IwYjD+cvp6
         3+gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741363188; x=1741967988;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=93tvkzOu0v7DF9VuZKcubARhjargqjujprNt6uu0n0M=;
        b=cVeJQVCOS7xZG3fYcIoMqNyndm37vzEeChTpXyB0gyqG5BwBo8UVInjnVxQhNJIWap
         IlFcbTeGLpPQrB9R3xpd9UiT0Ho99YEXME5sOoJe9hKbu7iUk9ZJkg092YxUcT/T9t9/
         u0krsc5kVbMfnIAwtK1e46pIwm8i8mxOefJBvnr0C0hOLe1d8/B/1BQ2iVvna0UpAGqe
         2X9sc6GZA+DLhwsC/b844dls5qtYL1fwk61k6tDCmPKh43FgHx4FpdFApPINXr7IUvHh
         PdOWRUiujaEaEIkqbsqkfhP62MRF4q+LbvyWcSM6vUNpMd+o5ibwzs5QmAsXzwrJPvSG
         AYQw==
X-Gm-Message-State: AOJu0YwLCL22TEJ1BEgn4dh/kpBSHv/2rE1Vw8CBjWENPPkdV5vMMBwA
	Q1zwoHz5ujGtCMjbJ3vhMTKnmeRwG3jkOSVjk/Y1ghJ5B8v1MOVvkeBgYQ==
X-Gm-Gg: ASbGncsXiVJN/ujtiIpJ53rm91Un+hA6yrbUOOVHAlBaZ9olB4F+0AU9hUS2/TJBvbO
	FOEo3SJ96CYuQFOd/U6QDDTae1pnbfUQznlvlKi7rut9i/ffTzy9QLTu+xYUA1jrPOsc7hsar1f
	7PFQH7DufAjtsg9F89c6t3+TRn6E0eNQg3pEXwB4PIgvxxrnGQU+hoZO0rAya7bOyYj7K/lPfms
	5mi/ofufQAbmhyM/PSS3c08gePD26T0fC1azAaJizbue7c0NfvqWR06SMxxHnVy7fX+vrJL86V7
	n7FUGY3kgryIC+fNJW+rv4oWkaHK
X-Google-Smtp-Source: AGHT+IGV9eH1SpNxkOV4jv5qlfSbSVvRiVruu0fnQeARy7WuDeD+rNa1ovI/PzduZEvIgsPB523Eag==
X-Received: by 2002:a17:907:84c1:b0:abf:68b5:f78b with SMTP id a640c23a62f3a-ac26cc4b0bamr2294166b.24.1741363188173;
        Fri, 07 Mar 2025 07:59:48 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:a068])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac2399d7a17sm297369166b.179.2025.03.07.07.59.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 07:59:47 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v4 4/9] io_uring/rw: defer reg buf vec import
Date: Fri,  7 Mar 2025 16:00:32 +0000
Message-ID: <e8491c976e4ab83a4e3dc428e9fe7555e59583b8.1741362889.git.asml.silence@gmail.com>
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

Import registered buffers for vectored reads and writes later at issue
time as we now do for other fixed ops.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  3 +++
 io_uring/rw.c                  | 42 +++++++++++++++++++++++++++-------
 2 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index cc84f6e5a64c..0e87e292bfb5 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -502,6 +502,7 @@ enum {
 	REQ_F_BUFFERS_COMMIT_BIT,
 	REQ_F_BUF_NODE_BIT,
 	REQ_F_HAS_METADATA_BIT,
+	REQ_F_IMPORT_BUFFER_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -584,6 +585,8 @@ enum {
 	REQ_F_BUF_NODE		= IO_REQ_FLAG(REQ_F_BUF_NODE_BIT),
 	/* request has read/write metadata assigned */
 	REQ_F_HAS_METADATA	= IO_REQ_FLAG(REQ_F_HAS_METADATA_BIT),
+	/* resolve padded iovec to registered buffers */
+	REQ_F_IMPORT_BUFFER	= IO_REQ_FLAG(REQ_F_IMPORT_BUFFER_BIT),
 };
 
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, io_tw_token_t tw);
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 4c4229f41aaa..e62f4ce34171 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -381,7 +381,25 @@ int io_prep_write_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return __io_prep_rw(req, sqe, ITER_SOURCE);
 }
 
-static int io_rw_prep_reg_vec(struct io_kiocb *req, int ddir)
+static int io_rw_import_reg_vec(struct io_kiocb *req,
+				struct io_async_rw *io,
+				int ddir, unsigned int issue_flags)
+{
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
+	unsigned uvec_segs = rw->len;
+	unsigned iovec_off = io->vec.nr - uvec_segs;
+	int ret;
+
+	ret = io_import_reg_vec(ddir, &io->iter, req, &io->vec,
+				uvec_segs, iovec_off, issue_flags);
+	if (unlikely(ret))
+		return ret;
+	iov_iter_save_state(&io->iter, &io->iter_state);
+	req->flags &= ~REQ_F_IMPORT_BUFFER;
+	return 0;
+}
+
+static int io_rw_prep_reg_vec(struct io_kiocb *req)
 {
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 	struct io_async_rw *io = req->async_data;
@@ -406,10 +424,8 @@ static int io_rw_prep_reg_vec(struct io_kiocb *req, int ddir)
 	if (IS_ERR(res))
 		return PTR_ERR(res);
 
-	ret = io_import_reg_vec(ddir, &io->iter, req, &io->vec,
-				uvec_segs, iovec_off, 0);
-	iov_iter_save_state(&io->iter, &io->iter_state);
-	return ret;
+	req->flags |= REQ_F_IMPORT_BUFFER;
+	return 0;
 }
 
 int io_prep_readv_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -419,7 +435,7 @@ int io_prep_readv_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	ret = __io_prep_rw(req, sqe, ITER_DEST);
 	if (unlikely(ret))
 		return ret;
-	return io_rw_prep_reg_vec(req, ITER_DEST);
+	return io_rw_prep_reg_vec(req);
 }
 
 int io_prep_writev_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -429,7 +445,7 @@ int io_prep_writev_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	ret = __io_prep_rw(req, sqe, ITER_SOURCE);
 	if (unlikely(ret))
 		return ret;
-	return io_rw_prep_reg_vec(req, ITER_SOURCE);
+	return io_rw_prep_reg_vec(req);
 }
 
 /*
@@ -906,7 +922,11 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 	ssize_t ret;
 	loff_t *ppos;
 
-	if (io_do_buffer_select(req)) {
+	if (req->flags & REQ_F_IMPORT_BUFFER) {
+		ret = io_rw_import_reg_vec(req, io, ITER_DEST, issue_flags);
+		if (unlikely(ret))
+			return ret;
+	} else if (io_do_buffer_select(req)) {
 		ret = io_import_rw_buffer(ITER_DEST, req, io, issue_flags);
 		if (unlikely(ret < 0))
 			return ret;
@@ -1117,6 +1137,12 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	ssize_t ret, ret2;
 	loff_t *ppos;
 
+	if (req->flags & REQ_F_IMPORT_BUFFER) {
+		ret = io_rw_import_reg_vec(req, io, ITER_SOURCE, issue_flags);
+		if (unlikely(ret))
+			return ret;
+	}
+
 	ret = io_rw_init_file(req, FMODE_WRITE, WRITE);
 	if (unlikely(ret))
 		return ret;
-- 
2.48.1


