Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 869B7403CAD
	for <lists+io-uring@lfdr.de>; Wed,  8 Sep 2021 17:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344845AbhIHPmn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 11:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240206AbhIHPmn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Sep 2021 11:42:43 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC6B3C061575
        for <io-uring@vger.kernel.org>; Wed,  8 Sep 2021 08:41:34 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id x6so3933365wrv.13
        for <io-uring@vger.kernel.org>; Wed, 08 Sep 2021 08:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=CNBXR7rDFzMfUqbBMbNugC5MWu6fW+F2FQcnVAlzGjk=;
        b=GTM+koSxOaUoe6jPjq2EWoatlNlRnYmswQTrxG7syfeJOAYEwdjbvSWWHmDihi52xs
         YMEHIAV9UiiVBJ8AKaP6PZ6wVTtjhKzcgwxPh4X8ynFaNNLjNVW6LJ/s4TeioLNyoZ9O
         IYouGCIK6N5f79OdIS0JnE1b2RKvh9ZL/rYluafNHYiAiTb9+4aYfKAZq+m7vMjfdiv/
         UQWNd/SPyiSgub9k5ui6y8MlXqDzqAyy0nh9dtp4kyWdZx6fWgoxZG9mwMRAOHHtAkz0
         rNL4jqLg+thoxeIOd/k3zLxlR7FF6EBOGCvRE66AjdEjqKhKUoVrT/PXlwJ14n+LlJbQ
         Exgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CNBXR7rDFzMfUqbBMbNugC5MWu6fW+F2FQcnVAlzGjk=;
        b=2tPCGRdZkpWvlH7E2w2SaU4JeDeCR044mGIQ4SSBJWUsr6cwduPDR/LswGeqQ4qbgs
         zIgEoogvlra/h6PerXlK874yCu+KBbTbyBFLETq0D1WlMyEmZGyju0QppzcxikVZ+56C
         ryVCaMO+xtT2uSm55gmz5Ml/SL1EvymgcaTp1M+VawCo9PjFy71osadeUtEyMu1HQHJd
         Y1nIY+G+xj+lJTE+A/EuWHqaVSHYS5FMNOLLjzngwqfgdbQh66N8FSY6uaVUrjAr8SHo
         LuLoLn9E4ZbJur7amPPrJ5TwkrCBvnr+vAObfvnM9CDsAjoXswqurm7ahBIWx5SLWQp2
         hErg==
X-Gm-Message-State: AOAM531vUZk81BGykk4nSiGohArKD8tl9EkPCnokuEuw3Q8pdBRHHlsY
        2IR+Lw3hKYuqnWCIQxePZmE9CmP3f4M=
X-Google-Smtp-Source: ABdhPJyHRyUBKyQk+0jX3QQmUj4nLkKkmrJme2MLdwm5jjZRsKzl/jOIFPuvTvFhgGc9OsmetQNUig==
X-Received: by 2002:adf:fdd2:: with SMTP id i18mr4797371wrs.406.1631115693558;
        Wed, 08 Sep 2021 08:41:33 -0700 (PDT)
Received: from localhost.localdomain ([185.69.144.232])
        by smtp.gmail.com with ESMTPSA id s10sm2580979wrg.42.2021.09.08.08.41.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 08:41:33 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/5] io_uring: kill off ios_left
Date:   Wed,  8 Sep 2021 16:40:49 +0100
Message-Id: <f13993bcf5b477f9a7d52881fc49f9457ea9870a.1631115443.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1631115443.git.asml.silence@gmail.com>
References: <cover.1631115443.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

->ios_left is only used to decide whether to plug or not, kill it to
avoid this extra accounting, just use the initial submission number.
There is no much difference in regards of enabling plugging, where this
one does it in a few more cases, but all major ones should be covered
well.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d816c09c88a5..849e1cb9fba4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -315,6 +315,7 @@ struct io_submit_state {
 	unsigned int		free_reqs;
 
 	bool			plug_started;
+	bool			need_plug;
 
 	/*
 	 * Batch completion logic
@@ -323,8 +324,6 @@ struct io_submit_state {
 	unsigned int		compl_nr;
 	/* inline/task_work completion list, under ->uring_lock */
 	struct list_head	free_list;
-
-	unsigned int		ios_left;
 };
 
 struct io_ring_ctx {
@@ -7032,10 +7031,10 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	 * Plug now if we have more than 1 IO left after this, and the target
 	 * is potentially a read/write to block based storage.
 	 */
-	if (!state->plug_started && state->ios_left > 1 &&
-	    io_op_defs[req->opcode].plug) {
+	if (state->need_plug && io_op_defs[req->opcode].plug) {
 		blk_start_plug(&state->plug);
 		state->plug_started = true;
+		state->need_plug = false;
 	}
 
 	if (io_op_defs[req->opcode].needs_file) {
@@ -7044,8 +7043,6 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		if (unlikely(!req->file))
 			ret = -EBADF;
 	}
-
-	state->ios_left--;
 	return ret;
 }
 
@@ -7152,7 +7149,7 @@ static void io_submit_state_start(struct io_submit_state *state,
 				  unsigned int max_ios)
 {
 	state->plug_started = false;
-	state->ios_left = max_ios;
+	state->need_plug = max_ios > 2;
 	/* set only head, no need to init link_last in advance */
 	state->link.head = NULL;
 }
-- 
2.33.0

