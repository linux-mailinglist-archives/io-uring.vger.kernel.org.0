Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78F3D1E9102
	for <lists+io-uring@lfdr.de>; Sat, 30 May 2020 13:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbgE3Lzv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 30 May 2020 07:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728433AbgE3Lzt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 30 May 2020 07:55:49 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E9DFC03E969;
        Sat, 30 May 2020 04:55:49 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id h5so833724wrc.7;
        Sat, 30 May 2020 04:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=7Tw1j6bV69ZB3geFecNl1fgq+fEOi9pUTNVdPouvjqk=;
        b=QZhb4cjoxkPxfPKIhu/jyNgE1EdZjRMZ84mSpO41CfMvChT6895+ynF5Y2re02qQV5
         +NoaIUC7iz8+ycTA7Y/IQf8T3tBmYTas+JuPsWVU2IgXF9cApj/okJ7KCe1jKnenIHpR
         wWxXJu4/1ReX1HtWHw7yla5CuwPH33tsahsT/dzHJ6iaVwreMKR020gOMbfbIPKBGm34
         2SAOu7b+2vPKlfu35JftV92h9geYydJjpKi6Y/cN4tNDA7mgwsuV7jPaAnw/TsMH6SES
         pwyRU8GGYLiuRp7auJ08gVjCGke2RIOMX68oDiJKP2Z28prdiNDP3kNqIDcmLtyJeaNR
         IAGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7Tw1j6bV69ZB3geFecNl1fgq+fEOi9pUTNVdPouvjqk=;
        b=MgqhcSHK+8uw9xW1wjsRsaJWiTUSmGcLYJrGq4T4dspZcv6NRjdsxEQM4Rz+ZYH07D
         1vGB6atIu2gYIkiZ/PjibTkwgZe+3AboL3maUfxC06o+S32w27q36U6YezNgshk/KNXT
         /pVDmIL0Ckbl8fZCNtoobfsySULjKCVoHrpXoIz7YzrjetwLZVsRF08BxtL8gUrBKWY5
         LTyr0N2YrrPHirovjsecrQwxPVH23jdmpwq0B/171OCQelelTq0acW6JNqe33NPS4oJ9
         irGKGhEJzg5bRedTAMPJdn7V/XD40PYZW63PIIKXWYnnsn07SCKUhAFe9NTu+/c6YVB3
         5Djg==
X-Gm-Message-State: AOAM530ZuseXOYG2Tl1N9WrjOmtKYkVwKPy7M2bR2FSYVAH9ZOd1uchI
        kA5f62Efxe1Rx1G+wsSLNJCVRJ56
X-Google-Smtp-Source: ABdhPJwg7x3TJNTHBcrf4jBeLI90m6EFVb7dZJzSV8q70fUaNChHzE1Dbzon9Ak3x5ddxAI6uP85Zg==
X-Received: by 2002:adf:ed4f:: with SMTP id u15mr12860495wro.126.1590839747931;
        Sat, 30 May 2020 04:55:47 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id l18sm3405332wmj.22.2020.05.30.04.55.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2020 04:55:47 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] io_uring: move timeouts flushing to a helper
Date:   Sat, 30 May 2020 14:54:17 +0300
Message-Id: <71b6d33a78d49461a05226e2d4411866e31ddb13.1590839530.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1590839530.git.asml.silence@gmail.com>
References: <cover.1590839530.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Separate flushing offset timeouts io_commit_cqring() by moving it into a
helper. Just a preparation, makes following patches clearer.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 942862c59200..0975cd8ddcb7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -988,23 +988,6 @@ static inline bool req_need_defer(struct io_kiocb *req)
 	return false;
 }
 
-static struct io_kiocb *io_get_timeout_req(struct io_ring_ctx *ctx)
-{
-	struct io_kiocb *req;
-
-	req = list_first_entry_or_null(&ctx->timeout_list, struct io_kiocb, list);
-	if (req) {
-		if (req->flags & REQ_F_TIMEOUT_NOSEQ)
-			return NULL;
-		if (!__req_need_defer(req)) {
-			list_del_init(&req->list);
-			return req;
-		}
-	}
-
-	return NULL;
-}
-
 static void __io_commit_cqring(struct io_ring_ctx *ctx)
 {
 	struct io_rings *rings = ctx->rings;
@@ -1133,13 +1116,24 @@ static void __io_queue_deferred(struct io_ring_ctx *ctx)
 	} while (!list_empty(&ctx->defer_list));
 }
 
-static void io_commit_cqring(struct io_ring_ctx *ctx)
+static void io_flush_timeouts(struct io_ring_ctx *ctx)
 {
-	struct io_kiocb *req;
+	while (!list_empty(&ctx->timeout_list)) {
+		struct io_kiocb *req = list_first_entry(&ctx->timeout_list,
+							struct io_kiocb, list);
 
-	while ((req = io_get_timeout_req(ctx)) != NULL)
+		if (req->flags & REQ_F_TIMEOUT_NOSEQ)
+			break;
+		if (__req_need_defer(req))
+			break;
+		list_del_init(&req->list);
 		io_kill_timeout(req);
+	}
+}
 
+static void io_commit_cqring(struct io_ring_ctx *ctx)
+{
+	io_flush_timeouts(ctx);
 	__io_commit_cqring(ctx);
 
 	if (unlikely(!list_empty(&ctx->defer_list)))
-- 
2.24.0

