Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B335B128A54
	for <lists+io-uring@lfdr.de>; Sat, 21 Dec 2019 17:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbfLUQP5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 21 Dec 2019 11:15:57 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43383 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbfLUQP4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 21 Dec 2019 11:15:56 -0500
Received: by mail-wr1-f65.google.com with SMTP id d16so12276881wre.10;
        Sat, 21 Dec 2019 08:15:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h+czerSo1XAoQq8sqnK90pcICbUxRS+KoG3fOEYG01k=;
        b=JkPvRb+BO93GQZzZ09XvihTuia6YXz/PwpwohyAH/1UTKFrA4mewEOMwtZSK8mY7wX
         +YHg6o0BmLtT7gh1XllVXV7WiUAmOT0CAEVdaPcxY2y2JIbC/ylEq1WRTcnCdyMJ0oDP
         CXogOpUDyz2TJgj3P0Uj4k4hQ3zzZJRMQoePQkiabJa8sBBZE5XnbRyuqU34W8SmClBM
         m0t+allKK46MbW6dQSGQXepv659LyBGH4CttXSoFhGVXPlhJUUSJMASwweCtKpDG5JgZ
         aAJAqiqVQ30CU6TiXBlzk2K4G6e48L89WgBD15D/xwBX2KL2P/tqQYYqutAAOCeRxIwl
         zXfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h+czerSo1XAoQq8sqnK90pcICbUxRS+KoG3fOEYG01k=;
        b=Uo89EDXh8Vw6oWHT/9VmYZsEIEWzgqMiLLOuA9rIXqfHqzAKySkZfrIyJFOPawhp0b
         3748h7+XPSn2iQT8l4Ro3VPCxNfQsajihHpOrpmov0QYsw8kPi5NzvWVcjVyZlJutmG+
         nuCb7nolZSzi7+40eKcGrz5hlYbquY7lOq1tD34FrIneSWIY6rIZFYPS6v56qpexyJOv
         qjVa8l7+OQ9OsYWso1t2VmlcX299r7/s2tsKngDMMfU/U2RSs3tvPAk0QYhVRGeYfHGx
         otXVaC8XUaEb/U5g2Q3v042Y6S4PQnLMGbw7tY9nt9WpRsWCmHkP5G4ETWI6r3fmh0Ei
         Sp4Q==
X-Gm-Message-State: APjAAAWIRYz6qdtTjYKuD1MnCIItJb7XI6zpXGYTz7vOwhwkscS+CsKw
        LnrDBl9M7o2b1JLf5ri+k8k=
X-Google-Smtp-Source: APXvYqxEs07NBMTqb2ZFc+aRcun6y0ZpI7gQlsmdwsOnRU4EC6tfnrcjuwVeydo1Mf9eHsa8nDjxgw==
X-Received: by 2002:a5d:5345:: with SMTP id t5mr22332197wrv.0.1576944954290;
        Sat, 21 Dec 2019 08:15:54 -0800 (PST)
Received: from localhost.localdomain ([109.126.149.134])
        by smtp.gmail.com with ESMTPSA id o129sm13831260wmb.1.2019.12.21.08.15.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Dec 2019 08:15:53 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
        Christoph Lameter <cl@linux.com>
Subject: [PATCH v2 2/3] io_uring: batch getting pcpu references
Date:   Sat, 21 Dec 2019 19:15:08 +0300
Message-Id: <229f00564ac243cee0bfef8372a8581efedc0da2.1576944502.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1576944502.git.asml.silence@gmail.com>
References: <cover.1576944502.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

percpu_ref_tryget() has its own overhead. Instead getting a reference
for each request, grab a bunch once per io_submit_sqes().

basic benchmark with submit and wait 128 non-linked nops showed ~5%
performance gain. (7044 KIOPS vs 7423)

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 513f1922ce6a..5392134f042f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1045,9 +1045,6 @@ static struct io_kiocb *io_get_req(struct io_ring_ctx *ctx,
 	gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
 	struct io_kiocb *req;
 
-	if (!percpu_ref_tryget(&ctx->refs))
-		return NULL;
-
 	if (!state) {
 		req = kmem_cache_alloc(req_cachep, gfp);
 		if (unlikely(!req))
@@ -4391,6 +4388,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 	struct io_submit_state state, *statep = NULL;
 	struct io_kiocb *link = NULL;
 	int i, submitted = 0;
+	unsigned int extra_refs;
 	bool mm_fault = false;
 
 	/* if we have a backlog and couldn't flush it all, return BUSY */
@@ -4400,6 +4398,10 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 			return -EBUSY;
 	}
 
+	if (!percpu_ref_tryget_many(&ctx->refs, nr))
+		return -EAGAIN;
+	extra_refs = nr;
+
 	if (nr > IO_PLUG_THRESHOLD) {
 		io_submit_state_start(&state, nr);
 		statep = &state;
@@ -4415,6 +4417,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 				submitted = -EAGAIN;
 			break;
 		}
+		--extra_refs;
 		if (!io_get_sqring(ctx, req, &sqe)) {
 			__io_free_req(req);
 			break;
@@ -4451,6 +4454,8 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 		io_queue_link_head(link);
 	if (statep)
 		io_submit_state_end(&state);
+	if (extra_refs)
+		percpu_ref_put_many(&ctx->refs, extra_refs);
 
 	 /* Commit SQ ring head once we've consumed and submitted all SQEs */
 	io_commit_sqring(ctx);
-- 
2.24.0

