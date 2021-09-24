Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85A4B417CB8
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 23:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348504AbhIXVCp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 17:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346613AbhIXVCh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 17:02:37 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 633EFC06173F
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:01:03 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id bx4so40995550edb.4
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=/GEHl2W6L9En4sqGDMwmiJ6qw3dbP3hRdugkttZDgFM=;
        b=XOxp6KKpKIuDNc4pmLHZg8nBAl4bE9/jDXACPTMXJLAcJfqDRL1wgW9nUyqiXl7fUa
         +wWQrcZzmJc6rQ1eZmCxT+ZWS34f1VcbzjPxKvHJw+O/GUyErPGHDHYKOl6kQfw/wI0n
         nP7gEnSim/QqskXBEJPr+fYeTYhEYmKIOocar29KZYPszhN3XrrmGGIV9/UE9V57XrOW
         cZF3nZzypDtPbOcokJEdk2coZ0XQbmJGQTFEtw7HcKe+C2QWgNBPuzVRRC2N+xSB259P
         4VYWmmlebV/Dzqk3w7FtDs3e18VWdZPyegUHnBYCMEJGLuaM6uNYFECtAL0C353lroV8
         1OwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/GEHl2W6L9En4sqGDMwmiJ6qw3dbP3hRdugkttZDgFM=;
        b=IUHN+LhGDO/6fnfW2y/96It43XIQKcXKo1p6O8YZX8H4+/jjU8ZwepdSAFqpXQK/Ka
         3WtjnxFAhae0SAqU3CwaRfkZYbPuh/yzJA2ct9Q9wYQjKgacIRoZ3tYlDrBwSu/PqRe7
         hv/aYHGmWTii3KmrMQ6uCaBjAYh+ahwH4PjhPMWTcyEjd2/vDU3Vn1MfAloymXFnnLBg
         3kCAQk9kcYOGiPWPvEad5dNUfRvP5cdxmlwf3uhTKFFojKojAROBsswsErboZrgvhHk6
         c8oPLrwaGqUbNvbdBwHaVJDi75u5dorwB7gVAd9Wh8Sp1CoDShHUwYZH+o4lvmRX1oGa
         vBwA==
X-Gm-Message-State: AOAM533XXuo9C/5ULSrth5Gv7NRmz4Q37S1KSZz/gkKnsjwZVKjdNPgk
        TVcYSaZ1YHJxzADd41eRy6U=
X-Google-Smtp-Source: ABdhPJz6zrmfMmg1/DnAMTH0rwChRfq2hwk6wHnA521KfBbfRJyIB4RYstqbnEKkJ/7j7ODZpHP5mw==
X-Received: by 2002:a17:907:3e05:: with SMTP id hp5mr13418455ejc.527.1632517262006;
        Fri, 24 Sep 2021 14:01:02 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id bc4sm6276048edb.18.2021.09.24.14.01.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 14:01:01 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 15/24] io_uring: don't pass state to io_submit_state_end
Date:   Fri, 24 Sep 2021 21:59:55 +0100
Message-Id: <e22d77a5786ef77e0c49b933ad74bae55cfb6ca6.1632516769.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632516769.git.asml.silence@gmail.com>
References: <cover.1632516769.git.asml.silence@gmail.com>
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
index f8640959554b..bc2a5cd80f07 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7145,11 +7145,13 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
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
@@ -7252,7 +7254,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 		percpu_ref_put_many(&ctx->refs, unused);
 	}
 
-	io_submit_state_end(&ctx->submit_state, ctx);
+	io_submit_state_end(ctx);
 	 /* Commit SQ ring head once we've consumed and submitted all SQEs */
 	io_commit_sqring(ctx);
 
-- 
2.33.0

