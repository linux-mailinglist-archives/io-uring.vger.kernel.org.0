Return-Path: <io-uring+bounces-6986-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0326DA56C88
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 16:48:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 415D118900E8
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 15:48:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBB0C194C78;
	Fri,  7 Mar 2025 15:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MkdgrSB8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01BCDDF71
	for <io-uring@vger.kernel.org>; Fri,  7 Mar 2025 15:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741362498; cv=none; b=Y+1zJRgZLfHZxVoanyfcOYt9PakEgv90/b9kfAUMLSFgwFAojzkc6AyBzOKppCgxpSXSWUkjEO0XWBUJx+W24agoHARBH27bkReMgxHxls0sZny7cHEHX1lbk+rRPl3u6zt/A+pUpfNF5WMKMStL/8v3tnEz6fC5EzAzivhdPdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741362498; c=relaxed/simple;
	bh=gNKF/L5J2pAWM9hL6RvdhhPWEP4Yq0qat+0Q7PL2fuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vBSAa+kK3wL4R286SwHuslr240MiRH1JNLCclZEARsYl7LNssGjwNE6K+tyXZdJXBEImSzEagaecbK1cOgcLnhQKZl2g9vk8K7jJs70KPuOW9+It32emW8XmSSs3kbxOXuyaBkUslTbOeIoLL6pQkYFp4CXNav4Sz+kDmvfKtj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MkdgrSB8; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5e5e7fd051bso1012066a12.0
        for <io-uring@vger.kernel.org>; Fri, 07 Mar 2025 07:48:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741362495; x=1741967295; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=93tvkzOu0v7DF9VuZKcubARhjargqjujprNt6uu0n0M=;
        b=MkdgrSB8/H7r9EC+eLNdtSGmwgIsxuOfWg2MZt7yEDe/i0fAagm0/vrNWMEto+dbqX
         Q1lITNDz4tA8VGjQx68e/by1QA+rBpMFWNQ13zC5wjwYkG0BbsnOkJHRi/25wHeRTldp
         1uvjYwCwcNDUa5mrqyi2oyO8gyQKl0wdqyx9TAcPwPneSkdth/pgM6s2sDd/IBf7EMLy
         qw7SaCfXXWH2wYshCcdbga6wSx3sN7u89tWTa5lS2aFQ5BlZb+zUAW1ram3Byii1pIzM
         kS2+93IeplEeL+fzIIm0PRLLreKvVfVsrT+tYu6wKJUr2lGlpKmmp6eqBBKqFEzPEHgD
         80sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741362495; x=1741967295;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=93tvkzOu0v7DF9VuZKcubARhjargqjujprNt6uu0n0M=;
        b=NZfuczU6dUH6HJ84s4T/JwAcF8S+dW1VA3tZDfvfKLq6tY5JAu/9FxOXzYcPsN7cPM
         yGj2jmmC7JprJxxJniPG6iZ0BLDfMTqWjny+rLYgh3YBzIne0v8LKc4u1Njc+N14wXVg
         UsBp4Pz6SsyNX1JgKHjQR5gvDzSVxhKr6o6oQRxswQYZeFY7iSpsK8FgqzJvH6v7+BeN
         ED2qW5b4Tb1d9N5hzJI2eXH3wmit1smJnmomYsKmnmPpybLcWuise0003hmWOBMHkQzP
         RzthoReh6yUklZa0/XeJGMESfmX2cC/5Ucnw4fZ5mG0zBB40ITjPzfAeRm8lZEWoM2Oa
         lACg==
X-Gm-Message-State: AOJu0Yx5BT84KGWhRWnnzdl/81rh4juW80PP/vJYSxjISqwFmvCPqpnU
	hDQ6FhxAnurtvhjrbInjQB9nNU6JjG4kMmAFY8ydGbB6q5kILzSAdcPdeQ==
X-Gm-Gg: ASbGncuwaZ6HtyrSyoRjHemSyWm9aKTAF9wFcue2kcQZU/zLAIVrvX2DFysFHGqbqpX
	bwBHtRK2SXf8G6rn2MOpCfwKteuJOQNtjLmXZ2JK3UNGP1Z4aSYZaQrdylMrcHG0Rp9OppBnAO3
	xaHu+5a6gCa0Oc+sYAAtAytGD4N0bSnftO660ii0bRxicPPWJCpAmWGVbjE9svYplbNlclV4i+c
	ndmK/KnwN0OwlZ1DSGyMtMnN0noHFotFuuhKvLpY+0W7H7qo9Yq/7n1a4lmoU5fMADQLfXv/rjO
	D50GccKJjxDdDeeiza/tqp5d+HZs
X-Google-Smtp-Source: AGHT+IEtQCqShBzxU3wM1ns//mwtr6og3quzCi8dHnjyWACbmbhVQQ90qPJ+6sCe+n8wqLc9yac1Ig==
X-Received: by 2002:a05:6402:27d3:b0:5e4:d2d4:b4f3 with SMTP id 4fb4d7f45d1cf-5e5e22cb5a3mr4748811a12.14.1741362494745;
        Fri, 07 Mar 2025 07:48:14 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:1422])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e5c766a033sm2665591a12.56.2025.03.07.07.48.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 07:48:13 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 4/9] io_uring/rw: defer reg buf vec import
Date: Fri,  7 Mar 2025 15:49:05 +0000
Message-ID: <b0f5be5ad2ead2e432a2b234c7b263ea6085bc2b.1741361926.git.asml.silence@gmail.com>
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


