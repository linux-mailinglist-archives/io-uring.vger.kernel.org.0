Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85D72334BC7
	for <lists+io-uring@lfdr.de>; Wed, 10 Mar 2021 23:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233830AbhCJWoj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Mar 2021 17:44:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232571AbhCJWoH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Mar 2021 17:44:07 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E4BC061760
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:07 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id c16so9254506ply.0
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=64bTn8xgi2ZrJT2hUHloVoEsgbz0Guro3NzZ/Qrndkg=;
        b=mlw+mTBGregKL1o6wbxhzfRFBpMK+4iqWK6QOtUXgo2TfHDqo+rX0nVO2flEBZwiil
         zaEVaWRuPZCp3fv5DMTY4gK4CFR7C0YxiGxDEjbQmbovHuwJ2jdZiqM5Z0hTzkNY9l5W
         NxQLr2xkhI4UQ6xGdGCtDxTTcDu4a/fiZMRPIQc+21+pzmLUKYHOaBJmAzpdTscSwS8u
         ILSZtx5kqAYXC7O7fE/3nLTeyTco3vDCEjbv0MqqwHupOT6y1uvmWMnsF0oVga4kuKML
         JTEliKmSv+GQs192surSmXWqqVP9A5YgtLyaJ9Cjoz/izWxMMgYS1ERA01tk1F8pmXRW
         lXHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=64bTn8xgi2ZrJT2hUHloVoEsgbz0Guro3NzZ/Qrndkg=;
        b=IyF+jBAJG+I+5GwVH2GcqHeyo6jEUufELpmSjWdmOqup0Q1CUKL2dfI0VE+JsZHqbE
         kt79xVt2nqh2HXUwu2F+ZkUfXi/yTr7kcsh8Ip8ZRy29uI/QmaiCYK5GHbid55+mCZ8s
         zOM8zJ9cHhAaMwzok4vdoIyz3HYkz4ht+nvWsZTFDQ2tQ3ITDm3C4VCuR0vGFI6jdOFw
         cUXDFM5H1bvW8/Pe79LS84awMxesTlb6VJM62O+EFJ7uC3OXkmMuuQZUmMaDb8q+/ioR
         FU6lBp7L6J0hPvvama9zQobxZywwTH7FRgPZCgBOx62r4nVXGSIGCNCjy5tJdcVPz90A
         8yeA==
X-Gm-Message-State: AOAM5307+fh685KezjyS6c4+qo1cb/lNHuznUIzQBqz/z6/x+9IyqbSY
        nssJsv5cLVQSNHts65end8K/hVFB3ASpLg==
X-Google-Smtp-Source: ABdhPJyw5uKjpvddoTahHXgBf2ALM97HDX7KR+xIWI8+n4udBa3hboAxMfbXHIztIdrYhcTq5WnFZw==
X-Received: by 2002:a17:90a:cc0b:: with SMTP id b11mr5842093pju.216.1615416246666;
        Wed, 10 Mar 2021 14:44:06 -0800 (PST)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id j23sm475783pfn.94.2021.03.10.14.44.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 14:44:06 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 02/27] io-wq: always track creds for async issue
Date:   Wed, 10 Mar 2021 15:43:33 -0700
Message-Id: <20210310224358.1494503-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310224358.1494503-1-axboe@kernel.dk>
References: <20210310224358.1494503-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If we go async with a request, grab the creds that the task currently has
assigned and make sure that the async side switches to them. This is
handled in the same way that we do for registered personalities.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.h    |  2 +-
 fs/io_uring.c | 33 +++++++++++++++++++--------------
 2 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/fs/io-wq.h b/fs/io-wq.h
index 5fbf7997149e..1ac2f3248088 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -79,8 +79,8 @@ static inline void wq_list_del(struct io_wq_work_list *list,
 
 struct io_wq_work {
 	struct io_wq_work_node list;
+	const struct cred *creds;
 	unsigned flags;
-	unsigned short personality;
 };
 
 static inline struct io_wq_work *wq_next_work(struct io_wq_work *work)
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 92c25b5f1349..d51c6ba9268b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1183,6 +1183,9 @@ static void io_prep_async_work(struct io_kiocb *req)
 	const struct io_op_def *def = &io_op_defs[req->opcode];
 	struct io_ring_ctx *ctx = req->ctx;
 
+	if (!req->work.creds)
+		req->work.creds = get_current_cred();
+
 	if (req->flags & REQ_F_FORCE_ASYNC)
 		req->work.flags |= IO_WQ_WORK_CONCURRENT;
 
@@ -1648,6 +1651,10 @@ static void io_dismantle_req(struct io_kiocb *req)
 		io_put_file(req, req->file, (req->flags & REQ_F_FIXED_FILE));
 	if (req->fixed_rsrc_refs)
 		percpu_ref_put(req->fixed_rsrc_refs);
+	if (req->work.creds) {
+		put_cred(req->work.creds);
+		req->work.creds = NULL;
+	}
 
 	if (req->flags & REQ_F_INFLIGHT) {
 		struct io_ring_ctx *ctx = req->ctx;
@@ -5916,18 +5923,8 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	const struct cred *creds = NULL;
 	int ret;
 
-	if (req->work.personality) {
-		const struct cred *new_creds;
-
-		if (!(issue_flags & IO_URING_F_NONBLOCK))
-			mutex_lock(&ctx->uring_lock);
-		new_creds = idr_find(&ctx->personality_idr, req->work.personality);
-		if (!(issue_flags & IO_URING_F_NONBLOCK))
-			mutex_unlock(&ctx->uring_lock);
-		if (!new_creds)
-			return -EINVAL;
-		creds = override_creds(new_creds);
-	}
+	if (req->work.creds && req->work.creds != current_cred())
+		creds = override_creds(req->work.creds);
 
 	switch (req->opcode) {
 	case IORING_OP_NOP:
@@ -6291,7 +6288,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 {
 	struct io_submit_state *state;
 	unsigned int sqe_flags;
-	int ret = 0;
+	int personality, ret = 0;
 
 	req->opcode = READ_ONCE(sqe->opcode);
 	/* same numerical values with corresponding REQ_F_*, safe to copy */
@@ -6324,8 +6321,16 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		return -EOPNOTSUPP;
 
 	req->work.list.next = NULL;
+	personality = READ_ONCE(sqe->personality);
+	if (personality) {
+		req->work.creds = idr_find(&ctx->personality_idr, personality);
+		if (!req->work.creds)
+			return -EINVAL;
+		get_cred(req->work.creds);
+	} else {
+		req->work.creds = NULL;
+	}
 	req->work.flags = 0;
-	req->work.personality = READ_ONCE(sqe->personality);
 	state = &ctx->submit_state;
 
 	/*
-- 
2.30.2

