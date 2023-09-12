Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4125E79D77C
	for <lists+io-uring@lfdr.de>; Tue, 12 Sep 2023 19:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233692AbjILRZL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Sep 2023 13:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbjILRZJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Sep 2023 13:25:09 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA5010E9
        for <io-uring@vger.kernel.org>; Tue, 12 Sep 2023 10:25:05 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id e9e14a558f8ab-34f17290a9cso7001035ab.1
        for <io-uring@vger.kernel.org>; Tue, 12 Sep 2023 10:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1694539504; x=1695144304; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WnGBrfZZuySU2APTyOcddYlt8Geg3fQwoMh64sBxPCY=;
        b=lB50xNnVTqb3mE5r7VLswro6ih9Ege5wUTw88ACKahAKf1YO0mIu+s/gKeSWS1rTij
         6M04OSq/SwktsENlcP5dN0Ps4AU7vvxGJcjdl3bJ82vC2QgZlzq1/MzS4JncrwGp8F5r
         reh6aEkNNMfNf8v6oU3uNZf8xevxoQM9m/c8leL0mCzuZZp/e50gUDUw996U53CI0sDe
         xdBj2gqmZyBXuaOztG6b8oHEo/vqj+0kuz1150j736Pcp+cwibl58X0CDveI2wiZO4E8
         YsD5WKC0nm1VIGDGPmgiygJQxbl6M0qwANhLf3MyG+Lhk5uLCvARn9zGa+QIOQyrVBiQ
         yyAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694539504; x=1695144304;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WnGBrfZZuySU2APTyOcddYlt8Geg3fQwoMh64sBxPCY=;
        b=P7ZtyL+DX9mv4klfDw6MBK3/mbnip1Y+We0K073J7WmsuMj61kQiJlpDTucOlkneGG
         ewPFW6KaJcKKuKXH5Mdvhd3VFrhmiZN4q/uhCN7ubwVvGT40Tf4h8p0ZCUA1a4cUWGYM
         3OqLJj9QTsKqZKWqfvHKvCc0U+dPWoYgLIcsVFty7k7MJYVEIOSm9urygS1F+sXe6pxz
         UUWz/sB4nIlT5j0KBCb7VKiu0JnSv8mQshviwX+/odGPAS+vVsDZpQygdZqCnNTlKdHm
         4hN+xdpvhRFIO8ctbBlPZq6kPTa1TqRctRxUzXgjvhKhbEBX68FL7++FgF4d05GKgMw/
         eP9A==
X-Gm-Message-State: AOJu0YwdF2OTOkb8CyWWhH4z7QmG5beMoPnp+t6qPkyMZU1aiWGjlQBu
        lUJqPwq9a6x6bCS3vDpBMcqt91rmnhX+TZ94DLFK4g==
X-Google-Smtp-Source: AGHT+IFH5gR4CVEtikAweBWnP2CIhuOHLx1EzeZNwYkQBxlI/B52vTlKR4c5P6ZZTANMtIljiqZUlQ==
X-Received: by 2002:a92:c9c2:0:b0:34f:7ba2:50e8 with SMTP id k2-20020a92c9c2000000b0034f7ba250e8mr197472ilq.2.1694539504672;
        Tue, 12 Sep 2023 10:25:04 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id d4-20020a056e02214400b0034ac1a32fd9sm1777055ilv.44.2023.09.12.10.25.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 10:25:03 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, krisman@suse.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring/rw: mark readv/writev as vectored in the opcode definition
Date:   Tue, 12 Sep 2023 11:24:57 -0600
Message-Id: <20230912172458.1646720-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230912172458.1646720-1-axboe@kernel.dk>
References: <20230912172458.1646720-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is cleaner than gating on the opcode type, particularly as more
read/write type opcodes may be added.

Then we can use that for the data import, and for __io_read() on
whether or not we need to copy state.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/opdef.c |  2 ++
 io_uring/opdef.h |  2 ++
 io_uring/rw.c    | 10 ++++++----
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 1d26ef10fc16..bfb7c53389c0 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -65,6 +65,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.ioprio			= 1,
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
+		.vectored		= 1,
 		.prep			= io_prep_rw,
 		.issue			= io_read,
 	},
@@ -78,6 +79,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.ioprio			= 1,
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
+		.vectored		= 1,
 		.prep			= io_prep_rw,
 		.issue			= io_write,
 	},
diff --git a/io_uring/opdef.h b/io_uring/opdef.h
index c22c8696e749..9e5435ec27d0 100644
--- a/io_uring/opdef.h
+++ b/io_uring/opdef.h
@@ -29,6 +29,8 @@ struct io_issue_def {
 	unsigned		iopoll_queue : 1;
 	/* opcode specific path will handle ->async_data allocation if needed */
 	unsigned		manual_alloc : 1;
+	/* vectored opcode, set if 1) vectored, and 2) handler needs to know */
+	unsigned		vectored : 1;
 
 	int (*issue)(struct io_kiocb *, unsigned int);
 	int (*prep)(struct io_kiocb *, const struct io_uring_sqe *);
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 402e8bf002d6..c3bf38419230 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -388,8 +388,7 @@ static struct iovec *__io_import_iovec(int ddir, struct io_kiocb *req,
 	buf = u64_to_user_ptr(rw->addr);
 	sqe_len = rw->len;
 
-	if (opcode == IORING_OP_READ || opcode == IORING_OP_WRITE ||
-	    (req->flags & REQ_F_BUFFER_SELECT)) {
+	if (!io_issue_defs[opcode].vectored || req->flags & REQ_F_BUFFER_SELECT) {
 		if (io_do_buffer_select(req)) {
 			buf = io_buffer_select(req, &sqe_len, issue_flags);
 			if (!buf)
@@ -776,8 +775,11 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (ret == -EAGAIN || (req->flags & REQ_F_REISSUE)) {
 		req->flags &= ~REQ_F_REISSUE;
-		/* if we can poll, just do that */
-		if (req->opcode == IORING_OP_READ && file_can_poll(req->file))
+		/*
+		 * If we can poll, just do that. For a vectored read, we'll
+		 * need to copy state first.
+		 */
+		if (file_can_poll(req->file) && !io_issue_defs[req->opcode].vectored)
 			return -EAGAIN;
 		/* IOPOLL retry should happen for io-wq threads */
 		if (!force_nonblock && !(req->ctx->flags & IORING_SETUP_IOPOLL))
-- 
2.40.1

