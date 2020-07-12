Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BCD421C858
	for <lists+io-uring@lfdr.de>; Sun, 12 Jul 2020 11:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728669AbgGLJnX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Jul 2020 05:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727777AbgGLJnX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Jul 2020 05:43:23 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C68EC061794
        for <io-uring@vger.kernel.org>; Sun, 12 Jul 2020 02:43:23 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id a1so2698583edt.10
        for <io-uring@vger.kernel.org>; Sun, 12 Jul 2020 02:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Kl+ETg2iqBIX4rEHr3haTBoktKVciCXhPOAMd41WWLI=;
        b=rgNXjZPhmvs6TTWZk/jA6cKSPYieULlFE/MYgrVMOLvUg5OHb2qVJ4/rg+HIdMzGXT
         +2ckxcc03XROQo5FrHjlubszQI5YdTrKyv7jkrCysjhuntMGvaSI+I6Y2KZOcpj0GwVI
         EykNtfmpwyciVzF6CCS6t/poNVzYmy9uLlJxwgz/69fptnkxMivwEkwZmFu1jzxM0MAW
         GegYWrA7TxRWiUxY1H1ZtC4CWMPSy/XfW2s6i34SeW32DOonmoM5SFvD60dMPBltnzIY
         vOX0YOV4Au8GLKrYfqPjMgkkHHrUF0Ojmen60jl9u4uxVc/NCefRVYm3SDMk8Mb/yDeo
         62FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Kl+ETg2iqBIX4rEHr3haTBoktKVciCXhPOAMd41WWLI=;
        b=qxBFyUQXEPEaqUUlVvpMwTvQZdtbcrOAv9+v534Hvq0lAGovgi+U1OH7QpJxHw3swY
         KoMMF9oV6YxengxMKRbc+WH6fcby0qkbeJqLwO+f5bQjCneClL9BtzN9KgGthglItPJe
         r7SAN997cpJh4SDzfllNpQoDFGRhPXopgdrJP4z3PQa3mZhjk9RhNpI+T3TEW3fAHYfp
         bzGczXjdX/amxXsmE5r48latR9DcZ2XLrJRB7nS5ZCFrFg0M2IFePQ6AzHyjF2eMWAxd
         WUMLkhlG1Q+BuHZSt9iRrh0/6NXJNYIRMV3cc0+JBi9r48dlLL5+IaYvEjVEzucSLguD
         7bqA==
X-Gm-Message-State: AOAM533RJ342OKwboMiyHqfmnZi2aabwR1NMXpyoqZdRspuY3ZXDQimI
        OtNpxm8QUD+lQtDKpwc5XN06R0fT
X-Google-Smtp-Source: ABdhPJz7fPL6tGWE8R68ThWfxNo/rzEHjrKUXTozD5UkGSb6C0R1akxUoxg1kjZSimLf7+iuj6aJHA==
X-Received: by 2002:a50:f9c9:: with SMTP id a9mr89781691edq.89.1594547001907;
        Sun, 12 Jul 2020 02:43:21 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id a8sm7283718ejp.51.2020.07.12.02.43.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2020 02:43:21 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 9/9] io_uring: place cflags into completion data
Date:   Sun, 12 Jul 2020 12:41:15 +0300
Message-Id: <238845b25937d2d9641c9007e53784481dc6ab41.1594546078.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1594546078.git.asml.silence@gmail.com>
References: <cover.1594546078.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

req->cflags is used only for defer-completion path, just use
completion data to store it. With the 4 bytes from the ->sequence
patch and compacting io_kiocb, this frees 8 bytes.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index db7f86b6da09..08af9abe69e3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -492,6 +492,7 @@ struct io_statx {
 struct io_completion {
 	struct file			*file;
 	struct list_head		list;
+	int				cflags;
 };
 
 struct io_async_connect {
@@ -633,7 +634,6 @@ struct io_kiocb {
 	};
 
 	struct io_async_ctx		*io;
-	int				cflags;
 	u8				opcode;
 	/* polled IO has completed */
 	u8				iopoll_completed;
@@ -1347,7 +1347,7 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 		if (cqe) {
 			WRITE_ONCE(cqe->user_data, req->user_data);
 			WRITE_ONCE(cqe->res, req->result);
-			WRITE_ONCE(cqe->flags, req->cflags);
+			WRITE_ONCE(cqe->flags, req->compl.cflags);
 		} else {
 			WRITE_ONCE(ctx->rings->cq_overflow,
 				atomic_inc_return(&ctx->cached_cq_overflow));
@@ -1402,7 +1402,7 @@ static void __io_cqring_fill_event(struct io_kiocb *req, long res, long cflags)
 		req->flags |= REQ_F_OVERFLOW;
 		refcount_inc(&req->refs);
 		req->result = res;
-		req->cflags = cflags;
+		req->compl.cflags = cflags;
 		list_add_tail(&req->compl.list, &ctx->cq_overflow_list);
 	}
 }
@@ -1435,7 +1435,7 @@ static void io_submit_flush_completions(struct io_comp_state *cs)
 
 		req = list_first_entry(&cs->list, struct io_kiocb, compl.list);
 		list_del(&req->compl.list);
-		__io_cqring_fill_event(req, req->result, req->cflags);
+		__io_cqring_fill_event(req, req->result, req->compl.cflags);
 		if (!(req->flags & REQ_F_LINK_HEAD)) {
 			req->flags |= REQ_F_COMP_LOCKED;
 			io_put_req(req);
@@ -1463,7 +1463,7 @@ static void __io_req_complete(struct io_kiocb *req, long res, unsigned cflags,
 			io_cleanup_req(req);
 
 		req->result = res;
-		req->cflags = cflags;
+		req->compl.cflags = cflags;
 		list_add_tail(&req->compl.list, &cs->list);
 		if (++cs->nr >= 32)
 			io_submit_flush_completions(cs);
-- 
2.24.0

