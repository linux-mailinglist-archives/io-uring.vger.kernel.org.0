Return-Path: <io-uring+bounces-4072-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DCEA9B3450
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 16:04:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 707B81C215F6
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 15:04:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B32A11DE3AD;
	Mon, 28 Oct 2024 15:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Z7scMJp5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276E41DE3AA
	for <io-uring@vger.kernel.org>; Mon, 28 Oct 2024 15:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730127892; cv=none; b=GkLnqAJ7GFl1Xe+7UTFnhELVpijblxLy0SCLlm3BXKoIfPn4DCxz/LTjdg7wLWY5SU/82oawidfsEt1tBditDe1+R9d46dLOIdo2tsdnuETUhku9zPJyX1efBgh1ihLKj7vsT3g6/FmnYAItR1nS0CSsRL07VZO77Y9a5BQ8Yu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730127892; c=relaxed/simple;
	bh=MFnBn3Pt+fR8V94brBcdw32DLbRG+lgrEKVj+CSb2kM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wsa6GAgFlCMPaii+fUxzi/KqOu8nmxJd7XsmJ85MDxVkjIC/JXLDGbYxrChDsIuSvfPl4+5EPzsscwcsZUSGpoRmral6zlprD/x3REx7q5fxWGW+2WDDuTdUSMiN/0FPRv1cYvI1yojK+aoz8nJQssZ8KvlCdcEdVNhNi2HunHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Z7scMJp5; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3a3b6b281d4so17752255ab.0
        for <io-uring@vger.kernel.org>; Mon, 28 Oct 2024 08:04:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730127888; x=1730732688; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1wzBUpdtpa3hgDqW+hLOo7TP8QbExzAyYMIVCGHCt2s=;
        b=Z7scMJp56K9VQEnVsD2ADUbRNDU7wpCeg7XJOa8pAtOkzwnerfw8tSD2wDkoXgnOUN
         8RDr2mDxqW5Ld7uxCLuDfEFu5HKfsz0N6jaZYmrYq7N77KPi7qrBZcQt+H+lQIMJ3hZo
         utvYMIWNAlget9C7cWjRtd4c40H/U3gVk4vGRKOvIMGs+jD8wURUmWwGL7mCugp3MJC4
         b27qOzwjeXcRnUFCaZsm6R5w5FaY9MF59THorbvHEmq80ykhFqGO5v3WIsPReXpXE5C4
         sDgxWdtU+WVPH8U4QtF1ZoFpbXdSfOJ7M2zNm1a/ngH5jUNgrMOrgNvyM3zuxqCroTMZ
         284A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730127888; x=1730732688;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1wzBUpdtpa3hgDqW+hLOo7TP8QbExzAyYMIVCGHCt2s=;
        b=JPN0OZGFx/jRdmmN1421J+FJvuk+wE6veLUvr4OmDPyYwssXGRLmbnjzYBn2RhI9Ii
         D0Pkj3cX8bqmRg/jAnP365DOTpXuywbkQZI6J9Sy4CyBlwcKcggZ78cFCTqIfoT3p1Bk
         sJDBhIS+WSWi/jIzUd/cJJQuQOqd7Y/DCMUhp/hs6GGH1Jc+U9YkDWaMECKfaK5IadOG
         J9PyHT/bLCXL0Irmr9UC4GvZNdELoYH8gqRAkvhJ8z8lfbInolav7nddxi7O0wnF4SMN
         G0/HTeI3BJ6pJ63Vdk2lZkcxETVPh7UVdaXMykO9dOyyqY5ZI/IaCGFcQgxEUTj0ztDv
         qQWg==
X-Gm-Message-State: AOJu0Yy9Pm54+ktAj4u2nhVJ/HWwiwnnuBs3K5RBG9Wnb38aquG4Bhyp
	wu6gmUOhF8zSfMNkLG3Gh0jJMcePOMpuJspaIexbkSYGREKZVqovwFlxd+z+aeQAPgf6V/NQSwf
	X
X-Google-Smtp-Source: AGHT+IEWlGS4ppe1fXn3O0knG6L0TbNFLTODTpYR8w3WdANEUF4ILqYV4UC4qlstFwSo9j2Tli8atw==
X-Received: by 2002:a92:c261:0:b0:3a4:e726:58a6 with SMTP id e9e14a558f8ab-3a4ed27dbdbmr73315645ab.8.1730127888400;
        Mon, 28 Oct 2024 08:04:48 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc7261c7e3sm1721616173.72.2024.10.28.08.04.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2024 08:04:46 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 04/13] io_uring/splice: open code 2nd direct file assignment
Date: Mon, 28 Oct 2024 08:52:34 -0600
Message-ID: <20241028150437.387667-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241028150437.387667-1-axboe@kernel.dk>
References: <20241028150437.387667-1-axboe@kernel.dk>
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


