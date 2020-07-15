Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3EB220929
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2020 11:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730824AbgGOJs5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jul 2020 05:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730612AbgGOJs5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jul 2020 05:48:57 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A97C061755
        for <io-uring@vger.kernel.org>; Wed, 15 Jul 2020 02:48:57 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id bm28so1149724edb.2
        for <io-uring@vger.kernel.org>; Wed, 15 Jul 2020 02:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=r9pfUWChHdTcbivFBZSP7MbVFXcm765yRCsQoPfgkvc=;
        b=kW8LmjqPmRZShUV/nA12lVYu/QwV/1TBTXetguNzbsuhsCHfEEFItis3myp96wbwPT
         IYWVfOEgwpLQuP2+LHd9pnCQd5aGapaHg5GiDMcXk+49WCxOpgmTqvGv1izUHwplDyMQ
         ohzwB2d+hv6NDhWMHTA8tLTkwxsMxgzfG6/do9jP4IUewFFWCXXn33w4IjlumI8LOw0X
         sN4/3MXMlrRBpvC0JI2+IOFAPgfc2q5J0u4p4WsQaSH9jc9vJ9tQHJfJQCXyBqj7oKu4
         4sAW/TVn8MHu8j+3mahBxi/tbKbjOVXcwJ3Q6r9f0FxVc65lQw8feEYswLPJzcMTCoyv
         BOkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r9pfUWChHdTcbivFBZSP7MbVFXcm765yRCsQoPfgkvc=;
        b=Z9+8GY86nxF0FfVQ6tF4Qf9vVqApsGgKjJ/gQ81Vcsr9xHFWFQuNEEp2dh3u4qBtzA
         LoZPRtJUk5fBG7PE1znckw8kz7AhiTiqjqp77jf2/zrXmDTjSsaWMvY0b42ERP+zDrew
         rb+uJpnnapDhmw3YJnE4y9TQWM9zwYHXPYxAblyXIgzQQUaR93FK/fu7PaIiFIiYxJ1t
         jme8wUTL0Uxsn5gDkW+/ioMU7ZHzSPTG801GQi1a1ec5nv0rICX/yJSPvdtIavu6NDDt
         vlg0BrF55kp1KCnXV6Qo0xSx2FsJ+4BWnmmTV53LxB1C3S85Fj5Ki1vySs57caIsFnrJ
         CpQg==
X-Gm-Message-State: AOAM532RFG8v5cZYp0ruTzuFb06ylIFXCIk7eZM+iXGqYwdcSYho4eXl
        MT5g/SD36adQKHsIh3PLPowsAacb
X-Google-Smtp-Source: ABdhPJwoKXr2lpwVyVAikh1Qhar42mdo32szgOFYwAXvZE4f3Jxr4E0eUeBPoaxGGT64VQPs3QmWXg==
X-Received: by 2002:a05:6402:2064:: with SMTP id bd4mr8546107edb.180.1594806535705;
        Wed, 15 Jul 2020 02:48:55 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id d13sm1635690edv.12.2020.07.15.02.48.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 02:48:55 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/4] io_uring: alloc ->io in io_req_defer_prep()
Date:   Wed, 15 Jul 2020 12:46:51 +0300
Message-Id: <ff573cc4458f611f15e362b70f6606218eee7d09.1594806332.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1594806332.git.asml.silence@gmail.com>
References: <cover.1594806332.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Every call to io_req_defer_prep() is prepended with allocating ->io,
just do that in the function. And while we're at it, mark error paths
with unlikey and replace "if (ret < 0)" with "if (ret)".

There is only one change in the observable behaviour, that's instead of
killing the head request right away on error, it postpones it until the
link is assembled, that looks more preferable.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a3157028c591..0e6bbf3367b9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5259,6 +5259,9 @@ static int io_req_defer_prep(struct io_kiocb *req,
 	if (!sqe)
 		return 0;
 
+	if (io_alloc_async_ctx(req))
+		return -EAGAIN;
+
 	if (io_op_defs[req->opcode].file_table) {
 		io_req_init_async(req);
 		ret = io_grab_files(req);
@@ -5398,10 +5401,8 @@ static int io_req_defer(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return 0;
 
 	if (!req->io) {
-		if (io_alloc_async_ctx(req))
-			return -EAGAIN;
 		ret = io_req_defer_prep(req, sqe);
-		if (ret < 0)
+		if (ret)
 			return ret;
 	}
 	io_prep_async_link(req);
@@ -6004,11 +6005,8 @@ static void io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		}
 	} else if (req->flags & REQ_F_FORCE_ASYNC) {
 		if (!req->io) {
-			ret = -EAGAIN;
-			if (io_alloc_async_ctx(req))
-				goto fail_req;
 			ret = io_req_defer_prep(req, sqe);
-			if (unlikely(ret < 0))
+			if (unlikely(ret))
 				goto fail_req;
 		}
 
@@ -6060,11 +6058,8 @@ static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			head->flags |= REQ_F_IO_DRAIN;
 			ctx->drain_next = 1;
 		}
-		if (io_alloc_async_ctx(req))
-			return -EAGAIN;
-
 		ret = io_req_defer_prep(req, sqe);
-		if (ret) {
+		if (unlikely(ret)) {
 			/* fail even hard links since we don't submit */
 			head->flags |= REQ_F_FAIL_LINK;
 			return ret;
@@ -6087,11 +6082,8 @@ static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			req->flags |= REQ_F_LINK_HEAD;
 			INIT_LIST_HEAD(&req->link_list);
 
-			if (io_alloc_async_ctx(req))
-				return -EAGAIN;
-
 			ret = io_req_defer_prep(req, sqe);
-			if (ret)
+			if (unlikely(ret))
 				req->flags |= REQ_F_FAIL_LINK;
 			*link = req;
 		} else {
-- 
2.24.0

