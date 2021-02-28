Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 803533274F1
	for <lists+io-uring@lfdr.de>; Sun, 28 Feb 2021 23:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbhB1Wkq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Feb 2021 17:40:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231613AbhB1Wkn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Feb 2021 17:40:43 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9BB3C0617A7
        for <io-uring@vger.kernel.org>; Sun, 28 Feb 2021 14:39:28 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id n22so1947836wmc.2
        for <io-uring@vger.kernel.org>; Sun, 28 Feb 2021 14:39:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=P12uktK+JhVBdPSOHzjJLgOwc1sp73GyWGXVagEH77A=;
        b=UE/If+4v6kgsXPOBFaesczhKFXJq1u55qTjASVanxfwPUq4JrBMa9tnFaf2cePC8EE
         d0LBs6z6Z1YlHb1GBpO1keUqH7U4TTLJXxSLykEYPvNGtVIGxukVOpolOqG3vC69Aan8
         K6G94zn6xhDdp/swFQvJ6HjeGG2PbLIDR0Kl2vhtKfaddW9SoTiwqh7Rz1cUpiEah4qP
         y/p8CTh4NpaHMF4J93Vo7cXGTyAHpWLbAuiD6WqW5SfjTNCcpDyh+GxUhnlUav5VtSHU
         ++e7KdmmAUIRi7WftLLZwC+5EFjhEkXqiZaLtSrWWi2scvyHyN+ED//MLhNBDHeJ5jeW
         hFqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P12uktK+JhVBdPSOHzjJLgOwc1sp73GyWGXVagEH77A=;
        b=ASt5L5lD5iHJ4rbz+BYUAX6r/4R1IOXqoAK9f4+iTLW0OZHQ9BDmURDoU7sxQCaLNs
         eMWYVBgLFu8Fequuxbn1eJU7B9jW+EYrJo6NvbsVpe1IVBIXd8agGDfsvrxoMuIQRZsd
         caBL6ooRnMecAWFTgd8nkBkHa03U2uLOCRKAYjjKtR+2YMXuPUFssypECOCyPywt35i4
         aGKCBJP6xjji4oOPghnEY3BDhvo14Moh7IKBxn6fgflZ18K5lQ8XJf6eUq8ADkQgT7tK
         9/+vmNgM0P2+tfyQ1efqpyxkLjdU5kun3ytwE5NQUG5FZFcAqqIUcagHFkzBoyYYa7eu
         hIFw==
X-Gm-Message-State: AOAM531/FHJK6QMnbmgCL0NTPeWV+0KO9pXkOXXvhDUhe31ep1ewvsuh
        i5mI3uC8tGYnVr8O2YhIqssOU6y4BRwwxQ==
X-Google-Smtp-Source: ABdhPJyXJMNMz2sR/Dm+47uk8ANgIMc0WenbB5BkA8U9RX/iINpQjq1Bh2Lc36fQoSOQXa4T2MC0iA==
X-Received: by 2002:a1c:bc82:: with SMTP id m124mr12863866wmf.118.1614551967784;
        Sun, 28 Feb 2021 14:39:27 -0800 (PST)
Received: from localhost.localdomain ([85.255.232.38])
        by smtp.gmail.com with ESMTPSA id y62sm22832576wmy.9.2021.02.28.14.39.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 14:39:27 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 10/12] io_uring: rethink def->needs_async_data
Date:   Sun, 28 Feb 2021 22:35:18 +0000
Message-Id: <6bf96f6507645bc417e7752ccf2a5f171d429685.1614551467.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614551467.git.asml.silence@gmail.com>
References: <cover.1614551467.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

needs_async_data controls allocation of async_data, and used in two
cases. 1) when async setup requires it (by io_req_prep_async() or
handler themselves), and 2) when op always needs additional space to
operate, like timeouts do.

Opcode preps already don't bother about the second case and do
allocation unconditionally, restrict needs_async_data to the first case
only and rename it into needs_async_setup.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bfc795e8258f..c9ab7ee5d500 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -833,8 +833,8 @@ struct io_op_def {
 	unsigned		pollout : 1;
 	/* op supports buffer selection */
 	unsigned		buffer_select : 1;
-	/* must always have async data allocated */
-	unsigned		needs_async_data : 1;
+	/* do prep async if is going to be punted */
+	unsigned		needs_async_setup : 1;
 	/* should block plug */
 	unsigned		plug : 1;
 	/* size of async data needed, if any */
@@ -848,7 +848,7 @@ static const struct io_op_def io_op_defs[] = {
 		.unbound_nonreg_file	= 1,
 		.pollin			= 1,
 		.buffer_select		= 1,
-		.needs_async_data	= 1,
+		.needs_async_setup	= 1,
 		.plug			= 1,
 		.async_size		= sizeof(struct io_async_rw),
 	},
@@ -857,7 +857,7 @@ static const struct io_op_def io_op_defs[] = {
 		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
-		.needs_async_data	= 1,
+		.needs_async_setup	= 1,
 		.plug			= 1,
 		.async_size		= sizeof(struct io_async_rw),
 	},
@@ -891,7 +891,7 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
-		.needs_async_data	= 1,
+		.needs_async_setup	= 1,
 		.async_size		= sizeof(struct io_async_msghdr),
 	},
 	[IORING_OP_RECVMSG] = {
@@ -899,11 +899,10 @@ static const struct io_op_def io_op_defs[] = {
 		.unbound_nonreg_file	= 1,
 		.pollin			= 1,
 		.buffer_select		= 1,
-		.needs_async_data	= 1,
+		.needs_async_setup	= 1,
 		.async_size		= sizeof(struct io_async_msghdr),
 	},
 	[IORING_OP_TIMEOUT] = {
-		.needs_async_data	= 1,
 		.async_size		= sizeof(struct io_timeout_data),
 	},
 	[IORING_OP_TIMEOUT_REMOVE] = {
@@ -916,14 +915,13 @@ static const struct io_op_def io_op_defs[] = {
 	},
 	[IORING_OP_ASYNC_CANCEL] = {},
 	[IORING_OP_LINK_TIMEOUT] = {
-		.needs_async_data	= 1,
 		.async_size		= sizeof(struct io_timeout_data),
 	},
 	[IORING_OP_CONNECT] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
-		.needs_async_data	= 1,
+		.needs_async_setup	= 1,
 		.async_size		= sizeof(struct io_async_connect),
 	},
 	[IORING_OP_FALLOCATE] = {
@@ -3073,7 +3071,7 @@ static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
 			     const struct iovec *fast_iov,
 			     struct iov_iter *iter, bool force)
 {
-	if (!force && !io_op_defs[req->opcode].needs_async_data)
+	if (!force && !io_op_defs[req->opcode].needs_async_setup)
 		return 0;
 	if (!req->async_data) {
 		if (io_alloc_async_data(req)) {
@@ -5738,12 +5736,8 @@ static int io_req_prep_async(struct io_kiocb *req)
 {
 	switch (req->opcode) {
 	case IORING_OP_READV:
-	case IORING_OP_READ_FIXED:
-	case IORING_OP_READ:
 		return io_rw_prep_async(req, READ);
 	case IORING_OP_WRITEV:
-	case IORING_OP_WRITE_FIXED:
-	case IORING_OP_WRITE:
 		return io_rw_prep_async(req, WRITE);
 	case IORING_OP_SENDMSG:
 		return io_sendmsg_prep_async(req);
@@ -5757,11 +5751,10 @@ static int io_req_prep_async(struct io_kiocb *req)
 
 static int io_req_defer_prep(struct io_kiocb *req)
 {
-	if (!io_op_defs[req->opcode].needs_async_data)
-		return 0;
-	/* some opcodes init it during the inital prep */
-	if (req->async_data)
+	if (!io_op_defs[req->opcode].needs_async_setup)
 		return 0;
+	if (WARN_ON_ONCE(req->async_data))
+		return -EFAULT;
 	if (io_alloc_async_data(req))
 		return -EAGAIN;
 	return io_req_prep_async(req);
-- 
2.24.0

