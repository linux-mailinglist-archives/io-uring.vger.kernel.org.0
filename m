Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65B3C204373
	for <lists+io-uring@lfdr.de>; Tue, 23 Jun 2020 00:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731009AbgFVWSV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Jun 2020 18:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731000AbgFVWST (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Jun 2020 18:18:19 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA94CC061573;
        Mon, 22 Jun 2020 15:18:18 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id d15so14859925edm.10;
        Mon, 22 Jun 2020 15:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=DrdHv0etgRdTJRMloebb5ELWSIQHSLCBHrC1nPqKOBo=;
        b=ljRD/dggkGGC6rHkjwQMDDIbl5xa+NBZ0vRdcGDpdbjhdmVQkaGzEMzg85DYu0C5pS
         z46Dw/EoXmibGavRy5/VcnpLbxq43oxMc3CAdt01NPp+ghP0avuW2L2tc2rs315VReVM
         fdlTed/3nrX2VXjXD88iZ2SbZRBaEQJUrHQsRmyMDFcd8mvhhViBw6fW5Ug+0XzESgXt
         jRyT+/i/P0I6/wCTuLlvCHfn75dns9yh7sckH297dNiqfxvRYsdzVcsyBGkWmsfv8ByC
         n5A0A3BVQ9BsKU/gipdKuBUuL1tapwNPXUvEOA4uxVCjnbs6ci0DpRuoUQwBRr0UM50V
         YY9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DrdHv0etgRdTJRMloebb5ELWSIQHSLCBHrC1nPqKOBo=;
        b=HUPRXvEZiZAZYR8N5Q7SnkMz2Q0FTQ57Dso0Yr0rEVvAjS5WqMwKZKU87L/iv7dzzt
         +1z5xX6MeLE5jUcVUeF0ukNXaGCVjW2lVz1GsbGDHmAfBb/eJ7fgNTaIjJvdrm7Ocy/P
         zz821zOlhT8EoeCuhNdVkhCX5+dx53WgfeGjexhJtWLLkgRdx8CGa8JH7SI5U52oaVML
         B+EcpVgX21xqhzwNoGokpoY9Ah+BrvqCMpuLVfDv/P7A5FrbaqxQqV4tsNQm9GELLD65
         /9qbUC7CtjLanrVCX3TDLl38UlRAFd3vp3YCwJV0GRo2Pmc8yX8EtP/jzrqNVkyzeXu2
         sPXQ==
X-Gm-Message-State: AOAM530frdNrXSYIRiv6cTPcOZxgiSCN12bOQjM5cdo4sRmKtM+SlFaM
        5sYHvCRMPlB/T37DIFAh4KSfczd+
X-Google-Smtp-Source: ABdhPJy2ais4FMuLolM4qlciAJwKyK2tSH5KjUyP5qU350a2lLuJt2PFNe1wps5KJsWiEVZjCXy2hw==
X-Received: by 2002:a05:6402:1217:: with SMTP id c23mr18974965edw.270.1592864297499;
        Mon, 22 Jun 2020 15:18:17 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id dm1sm13314421ejc.99.2020.06.22.15.18.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 15:18:17 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] io_uring: handle EAGAIN iopoll
Date:   Tue, 23 Jun 2020 01:16:33 +0300
Message-Id: <d9ab20194c0189c2d585a9e9173a147d156f129c.1592863245.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1592863245.git.asml.silence@gmail.com>
References: <cover.1592863245.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

req->iopoll() is not necessarily called by a task that submitted a
request. Because of that, it's dangerous to grab_env() and punt async
on -EGAIN, potentially grabbinf another task's mm and corrupting its
memory.

Do resubmit from the submitter task context.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bb0dfc450db5..595d2bbb31b1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -884,6 +884,8 @@ enum io_mem_account {
 	ACCT_PINNED,
 };
 
+static void io_complete_rw_common(struct kiocb *kiocb, long res);
+static bool io_rw_reissue(struct io_kiocb *req, long res);
 static void io_wq_submit_work(struct io_wq_work **workptr);
 static void io_cqring_fill_event(struct io_kiocb *req, long res);
 static void io_put_req(struct io_kiocb *req);
@@ -1756,8 +1758,11 @@ static void io_iopoll_queue(struct list_head *again)
 	do {
 		req = list_first_entry(again, struct io_kiocb, list);
 		list_del(&req->list);
-		refcount_inc(&req->refs);
-		io_queue_async_work(req);
+
+		if (!io_rw_reissue(req, -EAGAIN)) {
+			io_complete_rw_common(&req->rw.kiocb, -EAGAIN);
+			io_put_req(req);
+		}
 	} while (!list_empty(again));
 }
 
@@ -1930,6 +1935,8 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, unsigned *nr_events,
 		 */
 		if (!(++iters & 7)) {
 			mutex_unlock(&ctx->uring_lock);
+			if (current->task_works)
+				task_work_run();
 			mutex_lock(&ctx->uring_lock);
 		}
 
@@ -2288,6 +2295,7 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		kiocb->ki_complete = io_complete_rw_iopoll;
 		req->result = 0;
 		req->iopoll_completed = 0;
+		io_get_req_task(req);
 	} else {
 		if (kiocb->ki_flags & IOCB_HIPRI)
 			return -EINVAL;
-- 
2.24.0

