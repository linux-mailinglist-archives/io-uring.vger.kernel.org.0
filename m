Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D87921E191
	for <lists+io-uring@lfdr.de>; Mon, 13 Jul 2020 22:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgGMUjg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jul 2020 16:39:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgGMUjf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jul 2020 16:39:35 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA80C061755
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 13:39:35 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id a1so18910748ejg.12
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 13:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=2iU5QyHu+spIoR5L6ativWl6coV1CEjNS6ldoXiuN2c=;
        b=ALloU/GIlPsAXBVPD0hbjfFtNv9+ADUWaiI/vV5Yq21awFyyd6qzzZM2IzyyGrRyf1
         yRMilUbcZ++BpDS8Dc0isVL2zXXwHPbYGTqjTc9mUDLgOlajycm8PBPv6++S8pch56Sm
         /PEN0UG8IEDfHRd80IO7xgDBzDwF3s1KoTSh4N7HY6uOT7m7gwaD2/P5hP+2CRIIA+kj
         9FhwN6SgRkWjPLfvP/IIJXH4GFZX4w6286dZv8wsv67TUT4sSPvCWMw62gjFNAT/QffM
         WdknsR+LvDdqXYhkscsOdXPW6daYicRpO95TnAcLLLfVXuv+OL//0xn+lcDO+htzSXA4
         AMlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2iU5QyHu+spIoR5L6ativWl6coV1CEjNS6ldoXiuN2c=;
        b=oJICNXl5eN4+gnrV8onvuvcmKr9D6od0wEXt3b3kZ3FcQzJT4X3OJPzNvuluj44P41
         3dccForbSa74bi7Pqjc40VysVTsHuo56txthgJGOHrxgbo/2iql9jhDulmy1MQ+nO+ie
         219aaSkp8+9lE+Z/jk0MUlFoe3cwAR1i35QA2S9pRsh7hTmfZztv/fcz3xPMF5smzCHj
         Fv08n9eRueE3oMrEQ7AV2FkjwitrDfz0TY21LaEe3XlO5hhCsZFsphG/Xk6uM7rqwNyR
         vQ5bZtJa6eHrxh64XiIimP1M3TK4+6J7I+auCiSskILFGeGl0MmkQuY8INYWP7Jy3h/F
         JWuQ==
X-Gm-Message-State: AOAM533hEghUwCa4mfb64TzeFjdERN9J5TAH9YmeFzzBpDW0++nEo15b
        IdHh5uezpxKa5ajdgmFIZbg=
X-Google-Smtp-Source: ABdhPJyEtlrRcaqYqfQ9KJiWwdlor4wj4WMG/IHos/6LNHD129ReRj6WVEtU24M+tcU8a1Tvk+eH6A==
X-Received: by 2002:a17:906:c459:: with SMTP id ck25mr1539971ejb.177.1594672774264;
        Mon, 13 Jul 2020 13:39:34 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id m14sm10491855ejx.80.2020.07.13.13.39.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 13:39:33 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 9/9] io_uring: place cflags into completion data
Date:   Mon, 13 Jul 2020 23:37:16 +0300
Message-Id: <de7e15119b0923695104bc57be87cecf933fcce6.1594670798.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1594670798.git.asml.silence@gmail.com>
References: <cover.1594670798.git.asml.silence@gmail.com>
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
index e70129fac6db..7038c4f08805 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -491,6 +491,7 @@ struct io_statx {
 struct io_completion {
 	struct file			*file;
 	struct list_head		list;
+	int				cflags;
 };
 
 struct io_async_connect {
@@ -632,7 +633,6 @@ struct io_kiocb {
 	};
 
 	struct io_async_ctx		*io;
-	int				cflags;
 	u8				opcode;
 	/* polled IO has completed */
 	u8				iopoll_completed;
@@ -1350,7 +1350,7 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 		if (cqe) {
 			WRITE_ONCE(cqe->user_data, req->user_data);
 			WRITE_ONCE(cqe->res, req->result);
-			WRITE_ONCE(cqe->flags, req->cflags);
+			WRITE_ONCE(cqe->flags, req->compl.cflags);
 		} else {
 			WRITE_ONCE(ctx->rings->cq_overflow,
 				atomic_inc_return(&ctx->cached_cq_overflow));
@@ -1404,7 +1404,7 @@ static void __io_cqring_fill_event(struct io_kiocb *req, long res, long cflags)
 		io_clean_op(req);
 		req->flags |= REQ_F_OVERFLOW;
 		req->result = res;
-		req->cflags = cflags;
+		req->compl.cflags = cflags;
 		refcount_inc(&req->refs);
 		list_add_tail(&req->compl.list, &ctx->cq_overflow_list);
 	}
@@ -1438,7 +1438,7 @@ static void io_submit_flush_completions(struct io_comp_state *cs)
 
 		req = list_first_entry(&cs->list, struct io_kiocb, compl.list);
 		list_del(&req->compl.list);
-		__io_cqring_fill_event(req, req->result, req->cflags);
+		__io_cqring_fill_event(req, req->result, req->compl.cflags);
 		if (!(req->flags & REQ_F_LINK_HEAD)) {
 			req->flags |= REQ_F_COMP_LOCKED;
 			io_put_req(req);
@@ -1464,7 +1464,7 @@ static void __io_req_complete(struct io_kiocb *req, long res, unsigned cflags,
 	} else {
 		io_clean_op(req);
 		req->result = res;
-		req->cflags = cflags;
+		req->compl.cflags = cflags;
 		list_add_tail(&req->compl.list, &cs->list);
 		if (++cs->nr >= 32)
 			io_submit_flush_completions(cs);
-- 
2.24.0

