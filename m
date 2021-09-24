Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1A174178E9
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 18:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347451AbhIXQiU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 12:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347574AbhIXQh5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 12:37:57 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 005F0C06129E
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:33:01 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id ee50so38227151edb.13
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=nvpshZorjLoykDtpKq3HQrucWftoyB6Tqw8TB61nC7E=;
        b=LQXgNICkeU/owQoXyWuhMJJKG1XQ1MafcNWI3dUgBOX/QZP1Ot67E2xnkDXc2mgb52
         s9MqpSOkYubjP5IZyXxnmlpIIsz4MqVjKoxeNd8hBC1UsGUlYqo/TEpgBeTXYrzlAlzG
         B4dw55Wf84wNodzATssQy33rwMeNr3HmCR5TayUmbZtkYZIma3VvWjCszRaYcH5Rdtq2
         +JZ4CmCX5WNGFxh8cMMl6DKxrkkknH6eOBjDYhi6lSj++InheiHGpP01oOoXnz+ciMSc
         RTTsILIVlEkFbXu9Fed2LEa+FQFgQE8nYnsKeHpfcyRDVH2PGtDZkj/TPo9BqoLUkzHa
         KwDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nvpshZorjLoykDtpKq3HQrucWftoyB6Tqw8TB61nC7E=;
        b=Jv0TNKamq/PHjW3XmnFaQ9SokL7fmsCXPQ79uR5bBySqIa9La+Z/w1wYAv7hRB+7AW
         460AkaFO0Hph8Rf12XSoReOLYBMcwMVkUDn9CDOucLdT2ZViCC5OrUXH82rHqO7WecHp
         uKM3uUR//3dNfU9zioLXk6YDnDouKaJ+W9JM7FhLdaEYxxaBMAZqfO+BexXiEY1RTAjN
         ZeaK8SDuCcY5EBW8IJ4LOcnw35/mfZA6m3CWej141hD+MNhKS3QUqXcVi2MEP7P1Kl/x
         lop9xz3RS4kSRka6iqodf0WezNvda1qOKUAfz1Bko5r8bf9uw7/4WBiki6ZjkbPyLukC
         VrLQ==
X-Gm-Message-State: AOAM5304vmZlGpvyTG3bCL3GB7BYC8kjY/MfZH672wcu9XrwmT1DUELT
        DFO44P4dlCT7jmudeKWS7ycsFgNll/4=
X-Google-Smtp-Source: ABdhPJy3m23rHolfi7gDLElDEGzrHCmgj+UPSEB8ZD9OtrwjS8r74+/42avnCWryGwncGeQGXLJ8jA==
X-Received: by 2002:a50:9d48:: with SMTP id j8mr6133928edk.165.1632501180656;
        Fri, 24 Sep 2021 09:33:00 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id w10sm6167021eds.30.2021.09.24.09.32.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 09:33:00 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 15/23] io_uring: don't pass state to io_submit_state_end
Date:   Fri, 24 Sep 2021 17:31:53 +0100
Message-Id: <fa953e60221a21f83152d3b755cf197e4231f437.1632500264.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632500264.git.asml.silence@gmail.com>
References: <cover.1632500264.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Submission state and ctx and coupled together, no need to passs

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1d14d85377b5..26342ff481cb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7129,11 +7129,13 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 /*
  * Batched submission is done, ensure local IO is flushed out.
  */
-static void io_submit_state_end(struct io_submit_state *state,
-				struct io_ring_ctx *ctx)
+static void io_submit_state_end(struct io_ring_ctx *ctx)
 {
+	struct io_submit_state *state = &ctx->submit_state;
+
 	if (state->link.head)
 		io_queue_sqe(state->link.head);
+	/* flush only after queuing links as they can generate completions */
 	io_submit_flush_completions(ctx);
 	if (state->plug_started)
 		blk_finish_plug(&state->plug);
@@ -7236,7 +7238,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 		percpu_ref_put_many(&ctx->refs, unused);
 	}
 
-	io_submit_state_end(&ctx->submit_state, ctx);
+	io_submit_state_end(ctx);
 	 /* Commit SQ ring head once we've consumed and submitted all SQEs */
 	io_commit_sqring(ctx);
 
-- 
2.33.0

