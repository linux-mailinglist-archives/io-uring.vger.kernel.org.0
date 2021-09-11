Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BAB1407870
	for <lists+io-uring@lfdr.de>; Sat, 11 Sep 2021 15:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235880AbhIKNyB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Sep 2021 09:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235927AbhIKNx7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Sep 2021 09:53:59 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B90C061574
        for <io-uring@vger.kernel.org>; Sat, 11 Sep 2021 06:52:47 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id d6so6925358wrc.11
        for <io-uring@vger.kernel.org>; Sat, 11 Sep 2021 06:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ANWB3boj+GTIRIWnzR0rxJ/2cve+hdluR57wIVWI90E=;
        b=fXMPRV1Vn6D1frqQmug6+lHA8/zAbS8qDdNEe07T3tOsRseKNndJkU/K1eDX6iB8jM
         bp+XQAEnDkUIri8FnPXEQQ8HrZ8e4Q8O6cn2SJTBYvX7ckXFkS0iFt7+BU4aZnuAMLTj
         oS7E/+tIiOgFv3KvUBu9/aEe2CNcZHvPoGFR04cxKHK+j+ST+6xxY9UgkfDZqxLFIqXE
         xrLAVNSkUsiPG0NzfWX8C+YfOhYXGkIIq+gXcrETeuipqlsSvHLJyxAFdAjo4E18QfYk
         T1Tnig5+PAysNoq3vqVB4I8Xznf25zmfIiSHdadVsM6Xidr+eM9fWeiHhDe1NMnCcR6k
         OKqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ANWB3boj+GTIRIWnzR0rxJ/2cve+hdluR57wIVWI90E=;
        b=o3ix5kQ5wEM1cpENHJNTUV81C26xE0UA6KPjzrj1nC+EFrydIwSciEY3JGKiWQoa7s
         sA5PG2fVstXeQWaPCTv2uPJ/CaQ4iD7xlg+0Prqv5iejjkSptqBbDzy0f81kMabs5chy
         tI0s4mXgocO1CEqJOk7cwmSBHQFid+5EBarSIN9IAs3b7zgHdL19+EjDIStiD01niYTq
         PjijUQO5sDvjZokqZdZoOMd09p3TTxz9oZ+ZNj0x2NP1RT1TlVfhtl4HPRZ8yVuzDOEH
         uYmuN7Z/z+0OBdehty6fPtSMKBDUgA0lpaP3y33xXlwBeV5ycz5QScVyXa6halUQgJvZ
         h2Fw==
X-Gm-Message-State: AOAM532SYcHqOsoEr5nbwVLV0l3ygeO6IPDvJjvurNpJ4IjPp1WfZ9/l
        hpvJflEq8Gyn2QBseOg9hf9UY+o6Whw=
X-Google-Smtp-Source: ABdhPJwKEclrgrSL/KrmDyP4G6FyRLN3oyU/6CoBpSjl93BnopjLl1DdK579YDpqPOfSY4JaUpt8tg==
X-Received: by 2002:adf:e8ce:: with SMTP id k14mr3161363wrn.283.1631368365634;
        Sat, 11 Sep 2021 06:52:45 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.175])
        by smtp.gmail.com with ESMTPSA id n10sm1774928wrt.78.2021.09.11.06.52.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Sep 2021 06:52:45 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/3] io_uring: don't spinlock when not posting CQEs
Date:   Sat, 11 Sep 2021 14:52:02 +0100
Message-Id: <3a5f0436099b84f71fdc8c9bd9f21842581feaf9.1631367587.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1631367587.git.asml.silence@gmail.com>
References: <cover.1631367587.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When no of queued for the batch completion requests need to post an CQE,
see IOSQE_CQE_SKIP_SUCCESS, avoid grabbing ->completion_lock and other
commit/post.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 172c857e8b3f..8983a5a6851a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -317,6 +317,7 @@ struct io_submit_state {
 
 	bool			plug_started;
 	bool			need_plug;
+	bool			flush_cqes;
 
 	/*
 	 * Batch completion logic
@@ -1858,6 +1859,8 @@ static void io_req_complete_state(struct io_kiocb *req, long res,
 	req->result = res;
 	req->compl.cflags = cflags;
 	req->flags |= REQ_F_COMPLETE_INLINE;
+	if (!(req->flags & IOSQE_CQE_SKIP_SUCCESS))
+		req->ctx->submit_state.flush_cqes = true;
 }
 
 static inline void __io_req_complete(struct io_kiocb *req, unsigned issue_flags,
@@ -2354,17 +2357,19 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 	int i, nr = state->compl_nr;
 	struct req_batch rb;
 
-	spin_lock(&ctx->completion_lock);
-	for (i = 0; i < nr; i++) {
-		struct io_kiocb *req = state->compl_reqs[i];
+	if (state->flush_cqes) {
+		spin_lock(&ctx->completion_lock);
+		for (i = 0; i < nr; i++) {
+			struct io_kiocb *req = state->compl_reqs[i];
 
-		if (!(req->flags & REQ_F_CQE_SKIP))
-			__io_fill_cqe(ctx, req->user_data, req->result,
-				      req->compl.cflags);
+			if (!(req->flags & REQ_F_CQE_SKIP))
+				__io_fill_cqe(ctx, req->user_data, req->result,
+					      req->compl.cflags);
+		}
+		io_commit_cqring(ctx);
+		spin_unlock(&ctx->completion_lock);
+		io_cqring_ev_posted(ctx);
 	}
-	io_commit_cqring(ctx);
-	spin_unlock(&ctx->completion_lock);
-	io_cqring_ev_posted(ctx);
 
 	io_init_req_batch(&rb);
 	for (i = 0; i < nr; i++) {
@@ -2376,6 +2381,7 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 
 	io_req_free_batch_finish(ctx, &rb);
 	state->compl_nr = 0;
+	state->flush_cqes = false;
 }
 
 /*
-- 
2.33.0

