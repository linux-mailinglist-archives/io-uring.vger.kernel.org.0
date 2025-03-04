Return-Path: <io-uring+bounces-6938-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CCC0A4E483
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 16:59:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 95D607AA6F4
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 15:57:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7589298CB6;
	Tue,  4 Mar 2025 15:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hP7NOZdM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2170298CA0
	for <io-uring@vger.kernel.org>; Tue,  4 Mar 2025 15:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741102780; cv=none; b=NQjQPO/h2lra+3IDFQvx4w2RzzFJxYAWGpvtQlU8Com8kAx4AKGc57jSkt/+3nguAOPoVDlUbV+0sD9P74GfQBssjzBoOCDFwBZ+f/AMZBuCa+D7GzD6hY4zUzBpLCle0v4JtMas9u2cj/4VhsujhXs/VsM4UTJCVt5ik0kJBRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741102780; c=relaxed/simple;
	bh=Dfyl5JUYMQ4WXsedoYmAVv71GmQLPCka+J2WuBab3mg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oornH+p3vBSzbO8Jo4x4minVjCWR8Z+UlD+4BDFigdF4qZoLOjndPCFDh1LbQy4Y8z+kpBTyG0z6XtqizjhCT/caA/f06U1hYPKFHZ2zqZfP1wNm2qDVfUY8G1V+b7JwSL07yPXa5gBovyqvBRnqE94NY7QmhrOfIoib8eyt3R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hP7NOZdM; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5e549af4927so4100701a12.2
        for <io-uring@vger.kernel.org>; Tue, 04 Mar 2025 07:39:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741102777; x=1741707577; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S++4h6XEEInGoer4Mhouq45inPSSKuv2sG0OsLdnyFA=;
        b=hP7NOZdMjHo8OvwHYf3KX8dtDoFW9LYFCK+0xytwjRTqns5zBemUnDT02kDTj/pIOO
         4ejCMlYrdDhef8bQeYp7s2KYNyO90z1RPcP6oksLPOHjYPYAiQZJfq9rQ5wf9eQ3dxbx
         5AupLGyhr9DRGKwmNOw28iNRiHrzltj4vPuk72PsZ6J7pPYZxkZYUDG5tVwj0bk9zBFs
         9qSCVprlo17zRsS96m8b1bEFOY3CdJk9eDKZS29Pv+tJXjAcdRgswKCZzhvhK/3FFnrP
         Y18mrlyUj9MzQKytBBJIOxIIpaszUql1pGQLUKuBqzpgFhPrmYGS5FMUUUGWNBRx5CuN
         6JpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741102777; x=1741707577;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S++4h6XEEInGoer4Mhouq45inPSSKuv2sG0OsLdnyFA=;
        b=h56VjDhvlDGDuxD1yrC6dnH6kJivNW8NfNlGta8huyCcWpR0UaMUg7tPtaDrIQKJv4
         oGJPaGTTlRSSA82kwU3Ewd7PP0k8SWdKapB2r2FzyNJ0tXnEUI6J+UZ/ca7umBdGG1hC
         8Qlm7Ecz3lviZG4eSOq2DFy8zO349ZvULlpZIDWD8cM6mtne6A2JtW1+gUkjtpmjH9iQ
         CmFEUq9xZd9AkWoDs30jMdU+ITGU0g4XtFUkjkFJHNuJ8vPw+QzmnzEV4fDNTD5QVC+o
         XIjZfuzVgho3vGAmcuhePmnl10hrm9GLn3A2KK3OZWb39x0oGauC8zqNPcrYgx4wqSYj
         bAoQ==
X-Gm-Message-State: AOJu0YzATS4hGJ0HonGLP0mFspqPoPCWRN3Mc85X2UcqUwFwREb1fA3C
	9fChSW2gJ+WSN/z9Dm+Pb7gWOAtz7EvEUxW7FA5RRdsSYqaMaQFHusllgA==
X-Gm-Gg: ASbGncuVVfNGG2o6Hy+cvFmCJF8Ytlb575GCAxB5Kk5AGYMfIihRctopc+sjSgygVTE
	XoCyPVDCGAugtZ99ZjuBClQA5waXtjD3bR92+Ir6YKpBaLOm+RvZJKrVuJKy4tDV36B9LZdRYjb
	mA6QosKKDqbucxIU3LJfcyVII0pzuP5CEJgAowD2zHQTtnHNtJVPTGaZSb+Fep7BCZS4UsPW54B
	5WDlIO4Vgs7/J1VZ199A5H9vG/N961XnPdhfbua97pjFJsBaefmyYXZCzwNxXcshybDRBbqFo2J
	ASebruzQz0u14uWBDVPSMW/kvKNo
X-Google-Smtp-Source: AGHT+IES3BAXsq1p5J+bL1Pg8YxKjD7sqkv+HHL3zFzay07Bpa0wOI2LAZ5Y/d6gDZU5DBvWiLHZOw==
X-Received: by 2002:a17:907:9815:b0:abf:641a:5727 with SMTP id a640c23a62f3a-abf641a5b44mr1054379566b.7.1741102776680;
        Tue, 04 Mar 2025 07:39:36 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:3bd7])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac1ecafa17fsm168420966b.162.2025.03.04.07.39.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 07:39:35 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Andres Freund <andres@anarazel.de>
Subject: [PATCH v2 4/9] io_uring/rw: defer reg buf vec import
Date: Tue,  4 Mar 2025 15:40:25 +0000
Message-ID: <5b1f8b6ce1b39c5bc0c7f42119f941fdf0621505.1741102644.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1741102644.git.asml.silence@gmail.com>
References: <cover.1741102644.git.asml.silence@gmail.com>
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
index b770a2b12da6..d36fccda754b 100644
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


