Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87CE73EC866
	for <lists+io-uring@lfdr.de>; Sun, 15 Aug 2021 11:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237148AbhHOJlo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 Aug 2021 05:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237260AbhHOJll (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 Aug 2021 05:41:41 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F741C061764
        for <io-uring@vger.kernel.org>; Sun, 15 Aug 2021 02:41:11 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id w24so1883489wmi.5
        for <io-uring@vger.kernel.org>; Sun, 15 Aug 2021 02:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=rS0tNmhq3ZEAugZC40Jj65+7wMe4X3sFaM1r1SxPE0E=;
        b=IpQlEMhWTiCRbtCnUJeR2zDKg8fpMwCFf5uzEQL3ZFpmkNDz4ohfDuS3GlAb8achDr
         Tnv9SSEeAM9LhoWE3hmQHAhlib9K2uKRWpc/u8eCsOaFaDzEQawq7vDnCHRvHzpbVCb/
         2vA+GyNXyklcUTbDlruiAnvNEtPASR+TZe+KEAtWoUZJFk0rt8t/J9XOIsINz/CDk1ky
         sSM9KYMTJ1ZO/lblnHNCoIaGDnoSDUVwxE3DhxM+D3qToMaRvptl2Kw35rmy8GagXDnb
         fKVqx3knAML1Fp9y6XqWMf06eSAjqCrGxiIhr9xhU5hncn1DOuPm8TapTMDCiBzqHAgo
         sHgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rS0tNmhq3ZEAugZC40Jj65+7wMe4X3sFaM1r1SxPE0E=;
        b=LshnsduVUz6k/JbTVO1SnP3+dYKzaLvy4L+yXWuAj9vcagmUG7KQz/khLTIb58Ub+o
         0zH31PcHF5HFtyDGj7q1NdK0TsyjHmQd6+RP9PVteHNtgTDQN1ecpf7C1qWIQpKxm7rk
         +KswhKEVD1lK+TDS1NsweP4iRX/V9vkcriQCU+wP3H+S69FicAdOxdJW+NDzqLN0hhD+
         7H8iCa7gYmQtMDmq9rB90+yN8UFcolVGW5MF2HY46w9oi0rRRkw18bSg7kqEgGfT/zWs
         WFybif7HaGgllOFtfaejIG9LBQ5nwUFPQMqk5/1j+I/Kk+boHJQPORwzzYddRx2uOi7t
         F0Ow==
X-Gm-Message-State: AOAM533v/gIWZqr0BcMaosmhau0Eja5p/ov//6Z6qVGAKrYgfxUBaXQo
        0gi/m2BSqI82brnGanWZNJI=
X-Google-Smtp-Source: ABdhPJwAqFYtqXczjd7orMYSZ81YTM6zIywguv2IwRLR6LN1QEUlaT54gN9ZjqW4T7pG5XeLoKGqZA==
X-Received: by 2002:a05:600c:a44:: with SMTP id c4mr10318119wmq.83.1629020470006;
        Sun, 15 Aug 2021 02:41:10 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.97])
        by smtp.gmail.com with ESMTPSA id t8sm8828815wrx.27.2021.08.15.02.41.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Aug 2021 02:41:09 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 8/9] io_uring: cancel not-armed linked touts separately
Date:   Sun, 15 Aug 2021 10:40:25 +0100
Message-Id: <ae228cde2c0df3d92d29d5e4852ed9fa8a2a97db.1628981736.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628981736.git.asml.silence@gmail.com>
References: <cover.1628981736.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Adjust io_disarm_next(), so it can detect if there is a linked but
not-yet-armed timeout and complete/cancel it separately. Will be used in
the following patch.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index abd9df563d3d..9b6ed088d8d5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1034,6 +1034,9 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_UNLINKAT] = {},
 };
 
+/* requests with any of those set should undergo io_disarm_next() */
+#define IO_DISARM_MASK (REQ_F_ARM_LTIMEOUT | REQ_F_LINK_TIMEOUT | REQ_F_FAIL)
+
 static bool io_disarm_next(struct io_kiocb *req);
 static void io_uring_del_tctx_node(unsigned long index);
 static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
@@ -1686,7 +1689,7 @@ static void io_req_complete_post(struct io_kiocb *req, long res,
 	 */
 	if (req_ref_put_and_test(req)) {
 		if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK)) {
-			if (req->flags & (REQ_F_LINK_TIMEOUT | REQ_F_FAIL))
+			if (req->flags & IO_DISARM_MASK)
 				io_disarm_next(req);
 			if (req->link) {
 				io_req_task_queue(req->link);
@@ -1924,7 +1927,17 @@ static bool io_disarm_next(struct io_kiocb *req)
 {
 	bool posted = false;
 
-	if (likely(req->flags & REQ_F_LINK_TIMEOUT)) {
+	if (req->flags & REQ_F_ARM_LTIMEOUT) {
+		struct io_kiocb *link = req->link;
+
+		if (link && link->opcode == IORING_OP_LINK_TIMEOUT) {
+			io_remove_next_linked(req);
+			io_cqring_fill_event(link->ctx, link->user_data,
+					     -ECANCELED, 0);
+			io_put_req_deferred(link);
+			posted = true;
+		}
+	} else if (req->flags & REQ_F_LINK_TIMEOUT) {
 		struct io_ring_ctx *ctx = req->ctx;
 
 		spin_lock_irq(&ctx->timeout_lock);
@@ -1949,7 +1962,7 @@ static struct io_kiocb *__io_req_find_next(struct io_kiocb *req)
 	 * dependencies to the next request. In case of failure, fail the rest
 	 * of the chain.
 	 */
-	if (req->flags & (REQ_F_LINK_TIMEOUT | REQ_F_FAIL)) {
+	if (req->flags & IO_DISARM_MASK) {
 		struct io_ring_ctx *ctx = req->ctx;
 		bool posted;
 
-- 
2.32.0

