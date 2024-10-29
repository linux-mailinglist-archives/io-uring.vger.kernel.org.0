Return-Path: <io-uring+bounces-4117-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BEF1C9B4DC1
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 16:24:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F570282DC5
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 15:24:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1197192D73;
	Tue, 29 Oct 2024 15:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="S/0lO4ou"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC98193074
	for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 15:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730215403; cv=none; b=QPsdnE7X5iAIPTka2hHOk8qh27r2MrXurBKaPfwlf3jjpHyMSu3i2IRUHijLwHvLTRbO65KBYc8g6nqaDJHc4aKF2YE7YB0NDupbPpQAsmcVdOKvwf+Xw91ffOJyeDUgmiUeoaqCI/ka/inHz1B1ZVraqd5J2Nc6egLIkImF3LU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730215403; c=relaxed/simple;
	bh=uQWCLluDMPQNOEiZ8Ul9ExJn/tDb0mVWPhxe1LwxSMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L4gJKizuT3Wxyx6tARROrRJ41bmJQhG34SUN7Jdalu6g8BFDvnGkgUFfvMkSEWZbQt797/HqdzwBfIRrvuhtTv1rTtoClQBxEXvYOE5t3W1C0dJDcdKDiB908HdyrPyPwzrRvEh7/iOr3bUhrrfczXE++8/SuOABHeJViEZGcjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=S/0lO4ou; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-83ab94452a7so234427139f.3
        for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 08:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730215400; x=1730820200; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1g4Gm0gSb+oxL2pvGRFmkBIgUYG3z4aBcpjF/hLkUQI=;
        b=S/0lO4ou7DzzMIZA1R6loNEAasLLmGm5Imp9BJq5jLNtKO1QXSj5U93C7gSTE1mVGw
         FX2JpsapLfDkgp5KCCH1j7tpYsDpq8w2k+L0fQldxhJ4ygcLWaRX71UXat0JmYTPPfNi
         u0J6Zqw5VozIq8Ps+JGKfkomusuzIJfRpLmcdbejw50XFJbV1BFN6MOLGRc0QZ2vMkZg
         pOxNvpVAIezN8SJY4H21HEeKua1DWXIwOk0reVlXttVe2msvbwp04erCIQ00cKEBVgxa
         c2oe/Pt7RQevSXCk833pbeV3lyKJIWSVIeppRXwP1cIaGujyhvOuEuJi39QYLomsoO3z
         DGzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730215400; x=1730820200;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1g4Gm0gSb+oxL2pvGRFmkBIgUYG3z4aBcpjF/hLkUQI=;
        b=JWWrg8KzTTuRbYmZspQQJHsmx5AG4bCCof0ZjHNNr8Rm1aod7SRwtYuxPzPW7DZOjz
         Hd7X4py91WN25PNiRHGXwNirZUf5lGoBkPIRoabrd92uSIAAWnizx5qHVCkAkm8kuR4B
         tuBaNMBYqhxKEE/Yb2w36DQz3AeUCXlaju+/6zxpE0hG2iLc1g/QjwZZpy8h1c80QYKe
         p0Jio2l1R2/NKBtyf9R7ZjulWgREsgNlL2kwW4u4XCrsJTWbyOzAekEwFNzcABuHoorf
         M200usI4N6ErsIWq6hWhtPRHvfRLwhl6jaWzpqZ/Jgt+cGaAHd7Bs49amsY5H/PWFujA
         wpiA==
X-Gm-Message-State: AOJu0YyVP5HVcgAJAyaydZNPybTIzoC2Bn8lfvCR8HzaPwS+KcMtNNIP
	S7N1RCGj7x20EunShP9uuxiy3fCAFLNht5c7Y0e5pRrVxPB3QUfKG1fz044vGy167VBgBr0FHUl
	z
X-Google-Smtp-Source: AGHT+IEB4HZr8SpkQXVyD4kbsc5kytkUQ+KqPkVATsUPNbzuigMUz4DhuLB1QG3QwSYuqPjs/pcsfQ==
X-Received: by 2002:a05:6602:6411:b0:83a:9a59:f382 with SMTP id ca18e2360f4ac-83b567b996fmr13630139f.16.1730215400262;
        Tue, 29 Oct 2024 08:23:20 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc725eb58esm2434160173.27.2024.10.29.08.23.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2024 08:23:19 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 14/14] io_uring/rsrc: add io_reset_rsrc_node() helper
Date: Tue, 29 Oct 2024 09:16:43 -0600
Message-ID: <20241029152249.667290-15-axboe@kernel.dk>
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

Puts and reset an existing node in a slot, if one exists. Returns true
if a node was there, false if not. This helps cleanup some of the code
that does a lookup just to clear an existing node.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/filetable.c | 10 +++-------
 io_uring/rsrc.c      | 12 +++---------
 io_uring/rsrc.h      | 11 +++++++++++
 3 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/io_uring/filetable.c b/io_uring/filetable.c
index 1f22f183cdeb..717d5b806781 100644
--- a/io_uring/filetable.c
+++ b/io_uring/filetable.c
@@ -58,7 +58,7 @@ static int io_install_fixed_file(struct io_ring_ctx *ctx, struct file *file,
 				 u32 slot_index)
 	__must_hold(&req->ctx->uring_lock)
 {
-	struct io_rsrc_node *node, *old_node;
+	struct io_rsrc_node *node;
 
 	if (io_is_uring_fops(file))
 		return -EBADF;
@@ -71,10 +71,7 @@ static int io_install_fixed_file(struct io_ring_ctx *ctx, struct file *file,
 	if (IS_ERR(node))
 		return -ENOMEM;
 
-	old_node = io_rsrc_node_lookup(&ctx->file_table.data, slot_index);
-	if (old_node)
-		io_put_rsrc_node(old_node);
-	else
+	if (!io_reset_rsrc_node(&ctx->file_table.data, slot_index))
 		io_file_bitmap_set(&ctx->file_table, slot_index);
 
 	ctx->file_table.data.nodes[slot_index] = node;
@@ -133,8 +130,7 @@ int io_fixed_fd_remove(struct io_ring_ctx *ctx, unsigned int offset)
 	node = io_rsrc_node_lookup(&ctx->file_table.data, offset);
 	if (!node)
 		return -EBADF;
-	io_put_rsrc_node(node);
-	ctx->file_table.data.nodes[offset] = NULL;
+	io_reset_rsrc_node(&ctx->file_table.data, offset);
 	io_file_bitmap_clear(&ctx->file_table, offset);
 	return 0;
 }
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 0924c53dd954..97673771a0fb 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -182,7 +182,6 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 		return -EINVAL;
 
 	for (done = 0; done < nr_args; done++) {
-		struct io_rsrc_node *node;
 		u64 tag = 0;
 
 		if ((tags && copy_from_user(&tag, &tags[done], sizeof(tag))) ||
@@ -198,12 +197,9 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 			continue;
 
 		i = up->offset + done;
-		node = io_rsrc_node_lookup(&ctx->file_table.data, i);
-		if (node) {
-			io_put_rsrc_node(node);
-			ctx->file_table.data.nodes[i] = NULL;
+		if (io_reset_rsrc_node(&ctx->file_table.data, i))
 			io_file_bitmap_clear(&ctx->file_table, i);
-		}
+
 		if (fd != -1) {
 			struct file *file = fget(fd);
 			struct io_rsrc_node *node;
@@ -281,9 +277,7 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 			err = PTR_ERR(node);
 			break;
 		}
-		if (ctx->buf_table.nodes[i])
-			io_put_rsrc_node(ctx->buf_table.nodes[i]);
-
+		io_reset_rsrc_node(&ctx->buf_table, i);
 		ctx->buf_table.nodes[i] = node;
 		if (tag)
 			node->tag = tag;
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 6952fb45f57a..abd214f303f5 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -85,6 +85,17 @@ static inline void io_put_rsrc_node(struct io_rsrc_node *node)
 		io_free_rsrc_node(node);
 }
 
+static inline bool io_reset_rsrc_node(struct io_rsrc_data *data, int index)
+{
+	struct io_rsrc_node *node = data->nodes[index];
+
+	if (!node)
+		return false;
+	io_put_rsrc_node(node);
+	data->nodes[index] = NULL;
+	return true;
+}
+
 static inline void io_req_put_rsrc_nodes(struct io_kiocb *req)
 {
 	if (req->rsrc_nodes[IORING_RSRC_FILE] != rsrc_empty_node) {
-- 
2.45.2


