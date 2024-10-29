Return-Path: <io-uring+bounces-4107-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E11E9B4DB7
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 16:23:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1E05428581E
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 15:23:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D42F51946BA;
	Tue, 29 Oct 2024 15:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fjO5OmiI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3864A192D73
	for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 15:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730215391; cv=none; b=Ilh1eokxkhhd+GYVwhiK+WlxG8LMhlaGPq94R2Va+YYBGxl5VDd7OPq6YHmuEgxNT9A3J2BCJhF4kZ9sGU7fr0bgtgV28tWnP2m2rLXkk5LbtjTOt4R3Ay4agyMlAYlJmwTl/q9fmpchDlwO4mxAU7Ll/HXbbcIZeQJPy1qpbe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730215391; c=relaxed/simple;
	bh=MFnBn3Pt+fR8V94brBcdw32DLbRG+lgrEKVj+CSb2kM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+vBdXVkqO0Gp5P/JgmIgtpXFgRG/ivD5ngdduSS+/VHM1Nu5ffg5GPGgi9jxScENtkFYzHifLoD+Dc54WchOV6Dtz2ixOgq0hj/8VKwhT6r/gGcDBTPXQIhYIBWuCSrUJboah3kMsA+l+CT4xCXaX3Qz2sNB76Jkof/AjkWCes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fjO5OmiI; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-83ac817aac3so224087339f.0
        for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 08:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730215388; x=1730820188; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1wzBUpdtpa3hgDqW+hLOo7TP8QbExzAyYMIVCGHCt2s=;
        b=fjO5OmiInsLraK6U0/nHbSqHpvoHB6WskVFk7bhJUBBA0H/SX8m9QgNSsy1rr2VO1u
         wFHozHsmy1GJaDCELIMzPIQhYgir/3c+ls+wrCjYiXRgJCY+SQnM6O9jmardcPz7v+Zb
         C/TgFkqLmM30EQiG61+Jchc3UY91okorZgJ7MM+2S8ixRDxJL6+28RbxDUyV/R8DxXpt
         MYiXCHt/FKw+d/O6aGqvna4rqSzY8X4BVcfInMcuiUJlrSn8Vsjm0Ov9rtKsxpkZrV/F
         iF3jJynflcgEd46dSA9AFSet844fRjYOeNnfufsIgvQqGUa5OgxgdiMPbM+VJqle0n6q
         y3Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730215388; x=1730820188;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1wzBUpdtpa3hgDqW+hLOo7TP8QbExzAyYMIVCGHCt2s=;
        b=Fvc/srURxK06ch3ykORWFajx+LzP06il4qqVbBHcZfiuodAAOAsesRy9Q5sXed3fft
         EjenACWFn/fn0QGL7jDNvuA3pSrbXYeStqs8zdQz3bdsNuIrY/kNN/n9QP7VNNIOMhV8
         Gm5KS64n2H+DHHwRaJlRzvssQ3KLFUFmLBGQHeHdBwNK4rnpIBXPSLs2Wg8NwKQXBBjM
         TNOYPR9dBfTNfuQijpw83UM8Psl5A3Mi1Fx29J3WA43y0sJuUs9yuMAw690Apk9GBxXD
         Uwyc8yLWlJr3w7kuHaM0ED60j4dyUA5ciC7ToD/7eZEeDNmRJ9yI4ZUmDPqNxFphpZHK
         FRjw==
X-Gm-Message-State: AOJu0Yw784MCOHOGA0mOcWoiExKyG8Yq+oma47W9kJz1TJZ523Lm6rPh
	e6WDi57IKqkxJ/Jtj05lgiRgNrVtcuFZQI8USEm0rQHTSfRlkYaS+Xz7PE1kdVpeoUIE8ol46sQ
	W
X-Google-Smtp-Source: AGHT+IFLeKfustyDdRJxQJ7GI181AUb8Du1hiK6ihHsBFuXyAp3j/8yl1Y5CZ12lejKPHY8IVouQzw==
X-Received: by 2002:a05:6602:160f:b0:82d:16fa:52dd with SMTP id ca18e2360f4ac-83b5670c468mr13553339f.7.1730215387960;
        Tue, 29 Oct 2024 08:23:07 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc725eb58esm2434160173.27.2024.10.29.08.23.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2024 08:23:06 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 04/14] io_uring/splice: open code 2nd direct file assignment
Date: Tue, 29 Oct 2024 09:16:33 -0600
Message-ID: <20241029152249.667290-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241029152249.667290-1-axboe@kernel.dk>
References: <20241029152249.667290-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for not pinning the whole registered file table, open
code the second potential direct file assignment. This will be handled
by appropriate helpers in the future, for now just do it manually.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/opdef.c  |  2 ++
 io_uring/splice.c | 44 ++++++++++++++++++++++++++++++++++++--------
 io_uring/splice.h |  1 +
 3 files changed, 39 insertions(+), 8 deletions(-)

diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index a2be3bbca5ff..3de75eca1c92 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -641,6 +641,7 @@ const struct io_cold_def io_cold_defs[] = {
 	},
 	[IORING_OP_SPLICE] = {
 		.name			= "SPLICE",
+		.cleanup		= io_splice_cleanup,
 	},
 	[IORING_OP_PROVIDE_BUFFERS] = {
 		.name			= "PROVIDE_BUFFERS",
@@ -650,6 +651,7 @@ const struct io_cold_def io_cold_defs[] = {
 	},
 	[IORING_OP_TEE] = {
 		.name			= "TEE",
+		.cleanup		= io_splice_cleanup,
 	},
 	[IORING_OP_SHUTDOWN] = {
 		.name			= "SHUTDOWN",
diff --git a/io_uring/splice.c b/io_uring/splice.c
index 3b659cd23e9d..e62bc6497a94 100644
--- a/io_uring/splice.c
+++ b/io_uring/splice.c
@@ -21,6 +21,7 @@ struct io_splice {
 	u64				len;
 	int				splice_fd_in;
 	unsigned int			flags;
+	struct io_rsrc_node		*rsrc_node;
 };
 
 static int __io_splice_prep(struct io_kiocb *req,
@@ -34,6 +35,7 @@ static int __io_splice_prep(struct io_kiocb *req,
 	if (unlikely(sp->flags & ~valid_flags))
 		return -EINVAL;
 	sp->splice_fd_in = READ_ONCE(sqe->splice_fd_in);
+	sp->rsrc_node = NULL;
 	req->flags |= REQ_F_FORCE_ASYNC;
 	return 0;
 }
@@ -45,6 +47,38 @@ int io_tee_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return __io_splice_prep(req, sqe);
 }
 
+void io_splice_cleanup(struct io_kiocb *req)
+{
+	struct io_splice *sp = io_kiocb_to_cmd(req, struct io_splice);
+
+	io_put_rsrc_node(req->ctx, sp->rsrc_node);
+}
+
+static struct file *io_splice_get_file(struct io_kiocb *req,
+				       unsigned int issue_flags)
+{
+	struct io_splice *sp = io_kiocb_to_cmd(req, struct io_splice);
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_fixed_file *slot;
+	struct file *file = NULL;
+
+	if (!(sp->flags & SPLICE_F_FD_IN_FIXED))
+		return io_file_get_normal(req, sp->splice_fd_in);
+
+	io_ring_submit_lock(ctx, issue_flags);
+	if (unlikely(sp->splice_fd_in >= ctx->nr_user_files))
+		goto out;
+	sp->splice_fd_in = array_index_nospec(sp->splice_fd_in, ctx->nr_user_files);
+	slot = &ctx->file_table.files[sp->splice_fd_in];
+	if (!req->rsrc_node)
+		__io_req_set_rsrc_node(req, ctx);
+	file = io_slot_file(slot);
+	req->flags |= REQ_F_NEED_CLEANUP;
+out:
+	io_ring_submit_unlock(ctx, issue_flags);
+	return file;
+}
+
 int io_tee(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_splice *sp = io_kiocb_to_cmd(req, struct io_splice);
@@ -55,10 +89,7 @@ int io_tee(struct io_kiocb *req, unsigned int issue_flags)
 
 	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
 
-	if (sp->flags & SPLICE_F_FD_IN_FIXED)
-		in = io_file_get_fixed(req, sp->splice_fd_in, issue_flags);
-	else
-		in = io_file_get_normal(req, sp->splice_fd_in);
+	in = io_splice_get_file(req, issue_flags);
 	if (!in) {
 		ret = -EBADF;
 		goto done;
@@ -96,10 +127,7 @@ int io_splice(struct io_kiocb *req, unsigned int issue_flags)
 
 	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
 
-	if (sp->flags & SPLICE_F_FD_IN_FIXED)
-		in = io_file_get_fixed(req, sp->splice_fd_in, issue_flags);
-	else
-		in = io_file_get_normal(req, sp->splice_fd_in);
+	in = io_splice_get_file(req, issue_flags);
 	if (!in) {
 		ret = -EBADF;
 		goto done;
diff --git a/io_uring/splice.h b/io_uring/splice.h
index 542f94168ad3..b9b2848327fb 100644
--- a/io_uring/splice.h
+++ b/io_uring/splice.h
@@ -3,5 +3,6 @@
 int io_tee_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_tee(struct io_kiocb *req, unsigned int issue_flags);
 
+void io_splice_cleanup(struct io_kiocb *req);
 int io_splice_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_splice(struct io_kiocb *req, unsigned int issue_flags);
-- 
2.45.2


