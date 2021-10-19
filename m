Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0622433A9A
	for <lists+io-uring@lfdr.de>; Tue, 19 Oct 2021 17:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbhJSPhZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Oct 2021 11:37:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:50664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229991AbhJSPhY (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 19 Oct 2021 11:37:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A46EE6115A;
        Tue, 19 Oct 2021 15:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634657711;
        bh=Hv4wPC5ThKLeEBzYo7qmbC7yxyXLVIfmn8ndn7O5YYE=;
        h=From:To:Cc:Subject:Date:From;
        b=YsAPLLqy9JzMiXP2q8AvNCj61eHKc8ZPo9taTw8m2jtkOSUDPekaLXcVkk5PLcTXV
         Ijij6LBDAaneXeuUvBi7rk/jmRjIKT2WchxhJYohqvAfwsKneJ8+WwXAhYY0yNQdHf
         c61wT2On2/eQsTgNezupmJ7CEh/rXmbJEDkHqUehOsARYHcTAi0LYByihOaOeHhww5
         6sB2nUek7cUIAIsFG5lmWZdtfunnir4IOEARQbG0zXK7c4nkoN7bwAtCPtakQfRtYC
         R9OMmK0mlQE+wM39MnJCOCGPlwoCionirwUhuwYifscnR+jjnRLEjrdTn9yJJQ/jxt
         MDouptRQEugrQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [v2] io_uring: warning about unused-but-set parameter
Date:   Tue, 19 Oct 2021 17:34:53 +0200
Message-Id: <20211019153507.348480-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

When enabling -Wunused warnings by building with W=1, I get an
instance of the -Wunused-but-set-parameter warning in the io_uring code:

fs/io_uring.c: In function 'io_queue_async_work':
fs/io_uring.c:1445:61: error: parameter 'locked' set but not used [-Werror=unused-but-set-parameter]
 1445 | static void io_queue_async_work(struct io_kiocb *req, bool *locked)
      |                                                       ~~~~~~^~~~~~

There are very few warnings of this type, so it would be nice to enable
this by default and fix all the existing instances. As the assignment
serves no purpose by itself other than to prevent developers from using
the variable, an easy workaround is to remove the assignment and just
rename the argument to "dont_use".

Fixes: f237c30a5610 ("io_uring: batch task work locking")
Link: https://lore.kernel.org/lkml/20210920121352.93063-1-arnd@kernel.org/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
Changes in v2:
 - remove the assignment altogether
 - rename the parameter
---
 fs/io_uring.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index be307360d1b0..8d9e208957fd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1521,15 +1521,12 @@ static inline void io_req_add_compl_list(struct io_kiocb *req)
 	wq_list_add_tail(&req->comp_list, &state->compl_reqs);
 }
 
-static void io_queue_async_work(struct io_kiocb *req, bool *locked)
+static void io_queue_async_work(struct io_kiocb *req, bool *dont_use)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_kiocb *link = io_prep_linked_timeout(req);
 	struct io_uring_task *tctx = req->task->io_uring;
 
-	/* must not take the lock, NULL it as a precaution */
-	locked = NULL;
-
 	BUG_ON(!tctx);
 	BUG_ON(!tctx->io_wq);
 
-- 
2.29.2

