Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD81C79B2F6
	for <lists+io-uring@lfdr.de>; Tue, 12 Sep 2023 01:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241018AbjIKWKC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Sep 2023 18:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244545AbjIKUkd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Sep 2023 16:40:33 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A148127
        for <io-uring@vger.kernel.org>; Mon, 11 Sep 2023 13:40:29 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-68e2ff0b5c4so489542b3a.0
        for <io-uring@vger.kernel.org>; Mon, 11 Sep 2023 13:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1694464828; x=1695069628; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WnGBrfZZuySU2APTyOcddYlt8Geg3fQwoMh64sBxPCY=;
        b=d3En+Isos11fb/iqh201dqZwfOYvNgN87FivMeUbWdfS7tbMDyOhRIP8Muxi20Y3KF
         ZWyyYiHTjCu+tZhvxBGytZQeaT8HehMAuzUkQJbmEf3W7Lj8Hp9EhSG4wA0O6Yo7kJp9
         iowICh1/0/Za02E6azgbjt1heThLFGL9VYBiHD8Vc/kiKaTvPfDvPUQ2tTulGm4hS8mf
         i0oyG/DoeuAK2PtiXKtjJGfp8qnOym0Ww0HWChBdCpO1yU26VavVKP2szQ9hSzT2OMmI
         oKGP+vsoRq3M3vB+tUv2t1dK5eofnGWIfZ/6+ljKEp2gzrjHED2u3XZnhPdf/LeFgR9Y
         /TtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694464828; x=1695069628;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WnGBrfZZuySU2APTyOcddYlt8Geg3fQwoMh64sBxPCY=;
        b=EL3m87jAjwGhxxUn3ZgVYU45OQCc8vdw+KLkxHjjvt+9fsNjUhhVHngP+YuN95ACvs
         ADLZ7wL1qu+EWkpQyI6zs6kD06M2m9DdAKH+voHbUwWlLjTmEk+hWE16I+l9xZqVUZmV
         l/3FVg6Wau435n4XUAim0rHYMw/PN6ZbHjnEULN9s3IdiWOjVWP0FYp9UZTMKR4pBdNZ
         rz8HVHXIQlAdxQUBfOS/KW6w6KuHmfMXDByaw0ekR9LxnZ4Laq7nTrl+Fs3pgax/Pb5I
         dKyK8+5BD1y3BzvKgI47E+IE0iyoGBIcasruG5bJSqRKsjdtkU3WUrJ4oRqDYZo/H6R4
         OcUw==
X-Gm-Message-State: AOJu0YxKVcDvVYwu32MOGUB4YY6FHe0oapgmN2cewdZhSjBpXuWtgk5+
        XwJGZOw/1qB9aovmA8fwcKBAaIHV32Y9CtU47dxGzQ==
X-Google-Smtp-Source: AGHT+IEGGazBX2ZumWzVAVAq0lb1AGNPM7LvwRAwP44xqCplc4eGXd3OIYqfviy4LI6WNWVaNdjfkw==
X-Received: by 2002:a05:6a00:4ac3:b0:68f:c8b3:3077 with SMTP id ds3-20020a056a004ac300b0068fc8b33077mr3535020pfb.1.1694464828284;
        Mon, 11 Sep 2023 13:40:28 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ef22-20020a056a002c9600b0068fe5a5a566sm100544pfb.142.2023.09.11.13.40.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Sep 2023 13:40:27 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring/rw: mark readv/writev as vectored in the opcode definition
Date:   Mon, 11 Sep 2023 14:40:20 -0600
Message-Id: <20230911204021.1479172-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230911204021.1479172-1-axboe@kernel.dk>
References: <20230911204021.1479172-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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

