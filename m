Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADE9655046F
	for <lists+io-uring@lfdr.de>; Sat, 18 Jun 2022 14:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234021AbiFRM14 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Jun 2022 08:27:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234062AbiFRM1z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Jun 2022 08:27:55 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33BF518E22
        for <io-uring@vger.kernel.org>; Sat, 18 Jun 2022 05:27:54 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id z7so9318219edm.13
        for <io-uring@vger.kernel.org>; Sat, 18 Jun 2022 05:27:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CLd76MGzaIkw9CPSETt0MjjC/xAOsNwsnlG8FkvJCiY=;
        b=Q9lVPZU9iMSPaXYTuwIEhlZFi+9P60px03jQX4qtACEQJioPyqkpeOsjMr618xEbQr
         hag5YaAqUpqXHCqUCWY57kjuJFW/yK+gnmwEYU+0cwmoeVL+pNzIWBP3cbixFSTR6iPu
         Cf8Ac3J++aRGP1YGlHASnRfP5t6eXqC80VEmIlKv1k2teZoCjHEprATFaTOLajr3Yuob
         FghdQM4BstnXctvHFW5t3tk8q9IMO0J1IcayuB89+5LoTOWcvt5xUzUqVhINsaZ1aiA8
         sDZKs+TC2dPEBBKSHGMbtmroMNMUrXp744ci+1ZOyhf8TXU2FGtyg4iJkDBI0A8Lekl3
         e5aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CLd76MGzaIkw9CPSETt0MjjC/xAOsNwsnlG8FkvJCiY=;
        b=MnfgFRyBhdIPgbo7pJm/gwMGMiD7cyXj3gNep8QHj9oLfH/n1mD1A4R7txkwfYNYnp
         7QvbN0bvxXhLnuZWS/3RjZPLRj/v/pgU3rrT3RyDg7VTZQHCNquR0nqluM3XehZvJybf
         pT9WToiVIsyQ1D3jzZPojMyAbyX55BKKrY6xg9sXPjZ36CmiQ1HEBzV7apZl4iuWMhmB
         BJHcG2hKmcS0StTkR96w6oTdhFeOQSkNUyIASAsWc/FkA9EGQOj17AC454DIXHvPrvXT
         5jnwlLQybKVl7I1n3SzLM00stYjygw3ExkLNOBpMcQ8XQ6RZOcGtw7+FsQL3uP6NJgEQ
         L8yw==
X-Gm-Message-State: AJIora+xZbECA6QdnKf9Xp6VouCMb8ZeTDiM3Pic2WFcAAhqk5Pqrx4g
        oyOcRivSb1sYPLj0Hf07UU8C4WGiTgj5Eg==
X-Google-Smtp-Source: AGRyM1s0DHQ8TDwTph45hCdnC/LzFpc0LdkaHOayFyi1kvcPjEfSkbXhICX1chZp85aiK0OXwBnt7g==
X-Received: by 2002:a05:6402:510d:b0:42d:e266:e02f with SMTP id m13-20020a056402510d00b0042de266e02fmr18202252edd.277.1655555272458;
        Sat, 18 Jun 2022 05:27:52 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id u23-20020a056402111700b0042dd792b3e8sm5771523edv.50.2022.06.18.05.27.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jun 2022 05:27:52 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 3/4] io_uring: consistent naming for inline completion
Date:   Sat, 18 Jun 2022 13:27:26 +0100
Message-Id: <ce36284d656e44966b3c4ddf148a18c8dd643052.1655553990.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655553990.git.asml.silence@gmail.com>
References: <cover.1655553990.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Improve naming of the inline/deferred completion helper so it's
consistent with it's *_post counterpart. Add some comments and extra
lockdeps to ensure the locking is done right.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c |  4 ++--
 io_uring/io_uring.h | 10 +++++++++-
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 430e65494989..3a955044f2f7 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1391,7 +1391,7 @@ void io_req_task_complete(struct io_kiocb *req, bool *locked)
 	}
 
 	if (*locked)
-		io_req_add_compl_list(req);
+		io_req_complete_defer(req);
 	else
 		io_req_complete_post(req);
 }
@@ -1659,7 +1659,7 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (ret == IOU_OK) {
 		if (issue_flags & IO_URING_F_COMPLETE_DEFER)
-			io_req_add_compl_list(req);
+			io_req_complete_defer(req);
 		else
 			io_req_complete_post(req);
 	} else if (ret != IOU_ISSUE_SKIP_COMPLETE)
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 5eaa01c4697c..362a42471154 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -168,10 +168,18 @@ static inline void io_tw_lock(struct io_ring_ctx *ctx, bool *locked)
 	}
 }
 
-static inline void io_req_add_compl_list(struct io_kiocb *req)
+/*
+ * Don't complete immediately but use deferred completion infrastructure.
+ * Protected by ->uring_lock and can only be used either with
+ * IO_URING_F_COMPLETE_DEFER or inside a tw handler holding the mutex.
+ */
+static inline void io_req_complete_defer(struct io_kiocb *req)
+	__must_hold(&req->ctx->uring_lock)
 {
 	struct io_submit_state *state = &req->ctx->submit_state;
 
+	lockdep_assert_held(&req->ctx->uring_lock);
+
 	if (!(req->flags & REQ_F_CQE_SKIP))
 		state->flush_cqes = true;
 	wq_list_add_tail(&req->comp_list, &state->compl_reqs);
-- 
2.36.1

