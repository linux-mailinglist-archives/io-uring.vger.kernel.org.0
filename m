Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 014CF20D23A
	for <lists+io-uring@lfdr.de>; Mon, 29 Jun 2020 20:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728003AbgF2Srt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Jun 2020 14:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729363AbgF2Srq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Jun 2020 14:47:46 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA2FAC030F0E
        for <io-uring@vger.kernel.org>; Mon, 29 Jun 2020 09:20:30 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id l2so15191268wmf.0
        for <io-uring@vger.kernel.org>; Mon, 29 Jun 2020 09:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=o2paStTFKCEk74HGjYKCjwh5UW42Rrh1bWpIkuVmoOE=;
        b=LT7czy6n/X52yJmFew+4fnDB0VMogSJwu1RjlDr/lCsI2YuNIPa31tnXC2o0348lFC
         SuAWKfj7q0jC9GnxNpj+JspEh0Tynr6RCJBIpeDuX5w5oBYlZw+RD0zJmbmqTo2Weg/m
         TK/ezCa56bpGS8CkP+W4RtOedPJuQkqSelnKt3+zX4vBsqnOPyIQMeHYK/qb1rE9mT2U
         ZIJ4op3WTbSiAfqClYFEM6riWNbYgXPTpfVp2rbSutuD3jukek9BlrTqP7E4GfHoNyg8
         5avLlvdyY8Gwlw6xHvLni46iKhgnFY3Ra5SfYW2xYkW5hfMEPOQF5dTYFCdFMTRbFDEC
         0/7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o2paStTFKCEk74HGjYKCjwh5UW42Rrh1bWpIkuVmoOE=;
        b=YKhrHY73FdGjPrZRlY33us6w/4Nz+JNhwmuMc42w4TMdYpUHx9u7J1VDyyTginUboL
         MrZsTYnj7HuJPQNLeqMEtP2oJJtDIjb8+AqlbEhNVFGCBXLNlCtr/tECDEhR7Ag9qB3J
         O2SYGAOw9hxQsL6FgpfTLmchMylXQoq+6Ak/tfTZJZobKCgY2LK03l4mXIoX+fHAvACK
         VsMLYm1R9au68o4Wzanmqnc0fwiXjWzELd95vOruItwJaco8kb01t19iNkgahdk0Ytc5
         +anD4A42Q5FrXRF+3UlVHMLOIpg4zzFXAkkfBVfCMapRH9HD/1lHyOVUWBtiRzkvDZmS
         QkkA==
X-Gm-Message-State: AOAM531fZnBbi5oM46OVIneSmlBEzPIUgIasVhJMwKOgf6mZA91TPCdY
        KCemNIB+FP7XS5upXpZzwXHdAjL8
X-Google-Smtp-Source: ABdhPJzqKVFdU8OycB2+yXr5lf/D6Ff9HIu21/OhMo7tYhjU0cgTGADpG2E3Th3qEaFRsIS3jdp6fQ==
X-Received: by 2002:a7b:cc92:: with SMTP id p18mr17930095wma.4.1593447629506;
        Mon, 29 Jun 2020 09:20:29 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id 2sm282333wmo.44.2020.06.29.09.20.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 09:20:29 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/4] io_uring: factor out grab_env() from defer_prep()
Date:   Mon, 29 Jun 2020 19:18:42 +0300
Message-Id: <2a02f4a6f182fcc1de788c3f878bd9870186ee0c.1593446892.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1593446892.git.asml.silence@gmail.com>
References: <cover.1593446892.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Remove io_req_work_grab_env() call from io_req_defer_prep(), just call
it when neccessary.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4a05bc519134..2dcdc2c09e8c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5217,7 +5217,7 @@ static int io_files_update(struct io_kiocb *req, bool force_nonblock,
 }
 
 static int io_req_defer_prep(struct io_kiocb *req,
-			     const struct io_uring_sqe *sqe, bool for_async)
+			     const struct io_uring_sqe *sqe)
 {
 	ssize_t ret = 0;
 
@@ -5231,9 +5231,6 @@ static int io_req_defer_prep(struct io_kiocb *req,
 			return ret;
 	}
 
-	if (for_async || (req->flags & REQ_F_WORK_INITIALIZED))
-		io_req_work_grab_env(req);
-
 	switch (req->opcode) {
 	case IORING_OP_NOP:
 		break;
@@ -5346,9 +5343,10 @@ static int io_req_defer(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (!req->io) {
 		if (io_alloc_async_ctx(req))
 			return -EAGAIN;
-		ret = io_req_defer_prep(req, sqe, true);
+		ret = io_req_defer_prep(req, sqe);
 		if (ret < 0)
 			return ret;
+		io_req_work_grab_env(req);
 	}
 
 	spin_lock_irq(&ctx->completion_lock);
@@ -5960,9 +5958,10 @@ static void io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			ret = -EAGAIN;
 			if (io_alloc_async_ctx(req))
 				goto fail_req;
-			ret = io_req_defer_prep(req, sqe, true);
+			ret = io_req_defer_prep(req, sqe);
 			if (unlikely(ret < 0))
 				goto fail_req;
+			io_req_work_grab_env(req);
 		}
 
 		/*
@@ -6016,7 +6015,7 @@ static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		if (io_alloc_async_ctx(req))
 			return -EAGAIN;
 
-		ret = io_req_defer_prep(req, sqe, false);
+		ret = io_req_defer_prep(req, sqe);
 		if (ret) {
 			/* fail even hard links since we don't submit */
 			head->flags |= REQ_F_FAIL_LINK;
@@ -6043,7 +6042,7 @@ static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (io_alloc_async_ctx(req))
 				return -EAGAIN;
 
-			ret = io_req_defer_prep(req, sqe, false);
+			ret = io_req_defer_prep(req, sqe);
 			if (ret)
 				req->flags |= REQ_F_FAIL_LINK;
 			*link = req;
-- 
2.24.0

