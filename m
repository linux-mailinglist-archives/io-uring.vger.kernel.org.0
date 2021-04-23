Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 396493689B7
	for <lists+io-uring@lfdr.de>; Fri, 23 Apr 2021 02:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236851AbhDWAUY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Apr 2021 20:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236068AbhDWAUX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Apr 2021 20:20:23 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A4BC061574
        for <io-uring@vger.kernel.org>; Thu, 22 Apr 2021 17:19:47 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id c15so37605216wro.13
        for <io-uring@vger.kernel.org>; Thu, 22 Apr 2021 17:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Y7ONp2E6hnkyHKb232kR/+sR4WGeAYJSavH5KRYf/NQ=;
        b=MCW6xW9QeiIeAc6RrzxRFHjLOLyh8VfT9k4VgCbeqZJZfMbkL8tXyWqBp1JZCxVgR2
         xHnWx8WipI7sQ1Kr0UHxvIbVBLa3Tr9iaxCoexFYQq1zN1H62XFThDX4LG5cIxkVvj3q
         +0LD6fmNM1r/uU4dIkshGO4bW/a8lYyPrbokiVhEtQS9Wrz1TYS3xpKjo0iggMGPiwO7
         XRuYruzQb4QYx+CW5FNnauogfm/apfjd5pFsCkOScvbIS8esLEa4w3xpQo3fFuZp4ZZl
         Y2Mx/wS5RUfeQafY4ay1kwVsj241mBtk2AhSMBWrYkydcxGXKfqjEDiKNcp4aZksX520
         YIFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y7ONp2E6hnkyHKb232kR/+sR4WGeAYJSavH5KRYf/NQ=;
        b=TdlQiRlCkNvJ/oQ2TyoHhOt5H6uElkGQY73AawaJVAYvUsgiC50eZrwlJw7ioXOZ2U
         K/ELueAP6QnLzvlSu/0+9Ed6n750NS1AMwLjvQxZfWPXi4tOFoAkwMCko/1NWZA34quJ
         Gh0BYhu0BN+445ArAtd9c6Sh/Fm1+zWD+1eAsTkXrGUXr81+IEXkDB9dDxmedI1+5JvB
         qX+e4slxZAICOJRWt27ygbHA90M2SD46ZS+Nye44ctxCXVGSPGOJtDvSrgB6ynuAR2Ji
         Sy2fjaAcV9YYGr1kj4BZZyWT9yO1oi0ZCXOzv5GqfpMODZVRCWh/rUPr5r8tI7MgKr1K
         sUWg==
X-Gm-Message-State: AOAM533rXXXAP7/kdtBdMt9gCl7356xAjAZ8HiHhz3f19v2pwloQKCWQ
        YUhplYVgdLjIYX4bQmafg6AoZ2uJvsM=
X-Google-Smtp-Source: ABdhPJzAMe1Rs7VIJXPoNkfAvC5nkGf+I64S7Er1Xb5N8KrYGxU8pJKm62CzpvBz8LCSlh2nXuEBwA==
X-Received: by 2002:a05:6000:1785:: with SMTP id e5mr1041999wrg.143.1619137186141;
        Thu, 22 Apr 2021 17:19:46 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.225])
        by smtp.gmail.com with ESMTPSA id g12sm6369605wru.47.2021.04.22.17.19.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 17:19:45 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 09/11] io_uring: prepare fixed rw for dynanic buffers
Date:   Fri, 23 Apr 2021 01:19:26 +0100
Message-Id: <16e90af9d67f0f4b3c7c326974b8dbcc1c874797.1619128798.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1619128798.git.asml.silence@gmail.com>
References: <cover.1619128798.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

With dynamic buffer updates, registered buffers in the table may change
at any moment. First of all we want to prevent future races between
updating and importing (i.e. io_import_fixed()), where the latter one
may happen without uring_lock held, e.g. from io-wq.

A second problem is that currently we may do importing several times for
IORING_OP_{READ,WRITE}_FIXED, e.g. getting -EAGAIN on an inline attempt
and then redoing import after apoll/from iowq. In this case it can see
two completely different buffers, that's not good, especially since we
often hide short reads from the userspace.

Copy iter when going async. There are concerns about performance.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index cff8561d567a..c80b5fef159d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -903,6 +903,7 @@ static const struct io_op_def io_op_defs[] = {
 		.unbound_nonreg_file	= 1,
 		.pollin			= 1,
 		.plug			= 1,
+		.needs_async_setup	= 1,
 		.async_size		= sizeof(struct io_async_rw),
 	},
 	[IORING_OP_WRITE_FIXED] = {
@@ -911,6 +912,7 @@ static const struct io_op_def io_op_defs[] = {
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
 		.plug			= 1,
+		.needs_async_setup	= 1,
 		.async_size		= sizeof(struct io_async_rw),
 	},
 	[IORING_OP_POLL_ADD] = {
@@ -2683,6 +2685,10 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		kiocb->ki_complete = io_complete_rw;
 	}
 
+	if (req->opcode == IORING_OP_READ_FIXED ||
+	    req->opcode == IORING_OP_WRITE_FIXED)
+		io_req_set_rsrc_node(req);
+
 	req->rw.addr = READ_ONCE(sqe->addr);
 	req->rw.len = READ_ONCE(sqe->len);
 	req->buf_index = READ_ONCE(sqe->buf_index);
@@ -5919,7 +5925,9 @@ static int io_req_prep_async(struct io_kiocb *req)
 
 	switch (req->opcode) {
 	case IORING_OP_READV:
+	case IORING_OP_READ_FIXED:
 		return io_rw_prep_async(req, READ);
+	case IORING_OP_WRITE_FIXED:
 	case IORING_OP_WRITEV:
 		return io_rw_prep_async(req, WRITE);
 	case IORING_OP_SENDMSG:
-- 
2.31.1

