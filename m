Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1661128A52
	for <lists+io-uring@lfdr.de>; Sat, 21 Dec 2019 17:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbfLUQP6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 21 Dec 2019 11:15:58 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34844 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726319AbfLUQP5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 21 Dec 2019 11:15:57 -0500
Received: by mail-wr1-f65.google.com with SMTP id g17so12310633wro.2;
        Sat, 21 Dec 2019 08:15:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7qK7z/osxTMjlAYWmRfKxKF3BffCQ9pFRuTHMR/mgMI=;
        b=HqIFY4ouVENSqwnBhlI4Z/1Kltm0UvZldD1xButCUUW4E5RGzEFP91cMK/9Wgo/dO3
         t3BnzpOu7nLo3UpcQap4aDsKJWZNoIdYXpF0JMh02GARDGQSa0RxfsBJh9ltMYZR99C7
         NHv6cCESXnZWcRpZ/J2KeFC3DtUv3xZ7H2sHVPbKQxV1lg29U3cuyfhrqkNUSzbKT4A4
         1iGWxG/pap3xqOG/TbWtndxEOhuedlQ6txCfwarBhzoD+03oycl6LouAzLSoFOTJw9GK
         AmYYbZr/suA+x1ob+1PQvqQZkGY4Vs4plUXdysTOBXhBYPFtU5TFnsT7aqk0ip0qJbde
         SM2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7qK7z/osxTMjlAYWmRfKxKF3BffCQ9pFRuTHMR/mgMI=;
        b=rf8jcAC/hNEVYH9U1fU8b0EWdwhcrUmVwcXBoDbsQSTA5M1OKj6upKEd9qdWRSoJDd
         WO/QtooeBHQOKayQE9hlgIFbUTsS6MJV0YQQFDkD3KGALnePeW5tbsoWhSNlYhUywIbT
         l+pXSaOYVXGK5ZG1xt3LK/bd217LZCn2dvuLeVVPcSJsMD8KfiARKex9VtYleBcoWlgo
         6yDLus1Il5PyJCrjF9/6PrJDmha+VmskiqoAztdoHKaNKzjzCZ4PUIhajmI41hyiHGFx
         whOjg/uZe5NsxO091pm1mRe9WheJPZ/vLWysXURVBWTooOhhfTwp3UxodO642wz7dbbh
         gx9A==
X-Gm-Message-State: APjAAAWLf0UWNHCGsefl/mw9LcgAC35WNJnEptupg6m7sIXts9eaC8wA
        F/ENCrFcBduDy0i+MQV2dIU=
X-Google-Smtp-Source: APXvYqzjPq+1eiV+yAX9vqlwL+9h4V0nioBRuH5Yiudxskhlghs7hUPft/D2SFysxQv3Isvct1nCXw==
X-Received: by 2002:adf:eb0a:: with SMTP id s10mr22379309wrn.320.1576944955775;
        Sat, 21 Dec 2019 08:15:55 -0800 (PST)
Received: from localhost.localdomain ([109.126.149.134])
        by smtp.gmail.com with ESMTPSA id o129sm13831260wmb.1.2019.12.21.08.15.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Dec 2019 08:15:55 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
        Christoph Lameter <cl@linux.com>
Subject: [PATCH RFC v2 3/3] io_uring: batch get(ctx->ref) across submits
Date:   Sat, 21 Dec 2019 19:15:09 +0300
Message-Id: <925d8fe5406779bbfa108caa3d1f9fd16e3434b5.1576944502.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1576944502.git.asml.silence@gmail.com>
References: <cover.1576944502.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Double account ctx->refs keeping number of taken refs in ctx. As
io_uring gets per-request ctx->refs during submission, while holding
ctx->uring_lock, this allows in most of the time to bypass
percpu_ref_get*() and its overhead.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5392134f042f..eef09de94609 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -84,6 +84,9 @@
 #define IORING_MAX_ENTRIES	32768
 #define IORING_MAX_CQ_ENTRIES	(2 * IORING_MAX_ENTRIES)
 
+/* Not less than IORING_MAX_ENTRIES, so can grab once per submission loop */
+#define IORING_REFS_THRESHOLD	IORING_MAX_ENTRIES
+
 /*
  * Shift of 9 is 512 entries, or exactly one page on 64-bit archs
  */
@@ -197,6 +200,7 @@ struct fixed_file_data {
 struct io_ring_ctx {
 	struct {
 		struct percpu_ref	refs;
+		unsigned long		taken_refs; /* used under @uring_lock */
 	} ____cacheline_aligned_in_smp;
 
 	struct {
@@ -690,6 +694,13 @@ static void io_ring_ctx_ref_free(struct percpu_ref *ref)
 	complete(&ctx->completions[0]);
 }
 
+static void io_free_taken_refs(struct io_ring_ctx *ctx)
+{
+	if (ctx->taken_refs)
+		percpu_ref_put_many(&ctx->refs, ctx->taken_refs);
+	ctx->taken_refs = 0;
+}
+
 static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 {
 	struct io_ring_ctx *ctx;
@@ -4388,7 +4399,6 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 	struct io_submit_state state, *statep = NULL;
 	struct io_kiocb *link = NULL;
 	int i, submitted = 0;
-	unsigned int extra_refs;
 	bool mm_fault = false;
 
 	/* if we have a backlog and couldn't flush it all, return BUSY */
@@ -4398,9 +4408,15 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 			return -EBUSY;
 	}
 
-	if (!percpu_ref_tryget_many(&ctx->refs, nr))
-		return -EAGAIN;
-	extra_refs = nr;
+	if (ctx->taken_refs < IORING_REFS_THRESHOLD) {
+		if (unlikely(percpu_ref_is_dying(&ctx->refs))) {
+			io_free_taken_refs(ctx);
+			return -ENXIO;
+		}
+		if (!percpu_ref_tryget_many(&ctx->refs, IORING_REFS_THRESHOLD))
+			return -EAGAIN;
+		ctx->taken_refs += IORING_REFS_THRESHOLD;
+	}
 
 	if (nr > IO_PLUG_THRESHOLD) {
 		io_submit_state_start(&state, nr);
@@ -4417,8 +4433,9 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 				submitted = -EAGAIN;
 			break;
 		}
-		--extra_refs;
 		if (!io_get_sqring(ctx, req, &sqe)) {
+			/* not submitted, but a ref is freed */
+			ctx->taken_refs--;
 			__io_free_req(req);
 			break;
 		}
@@ -4454,8 +4471,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 		io_queue_link_head(link);
 	if (statep)
 		io_submit_state_end(&state);
-	if (extra_refs)
-		percpu_ref_put_many(&ctx->refs, extra_refs);
+	ctx->taken_refs -= submitted;
 
 	 /* Commit SQ ring head once we've consumed and submitted all SQEs */
 	io_commit_sqring(ctx);
@@ -5731,6 +5747,7 @@ static int io_uring_fasync(int fd, struct file *file, int on)
 static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 {
 	mutex_lock(&ctx->uring_lock);
+	io_free_taken_refs(ctx);
 	percpu_ref_kill(&ctx->refs);
 	mutex_unlock(&ctx->uring_lock);
 
@@ -6196,6 +6213,7 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 
 	if (opcode != IORING_UNREGISTER_FILES &&
 	    opcode != IORING_REGISTER_FILES_UPDATE) {
+		io_free_taken_refs(ctx);
 		percpu_ref_kill(&ctx->refs);
 
 		/*
-- 
2.24.0

