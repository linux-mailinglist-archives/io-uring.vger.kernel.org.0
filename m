Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54CD452B553
	for <lists+io-uring@lfdr.de>; Wed, 18 May 2022 11:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233427AbiERIk2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 May 2022 04:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233321AbiERIkY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 May 2022 04:40:24 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72C84C8BE0
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 01:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=g4fhh/jaoaiXgD0A58bF6TxSzg6yFwnWkwOfK0pR8Q8=; b=L+nASTp0xS4U9STthd9Ou6HGnq
        CFjHk3HjuJybhNHVnyhNt5dzerWeLtxeXI65UseEdfzUkEmUQhbSuZ1MHYUnZOlBkoE/ybS66vx2A
        dxnP0JMvT/X84o/JhlZB0UC7URoHC5nT2xK9S7iGXekXgslXVR+wLBU08rCG9RrIDAEi4cprQCazw
        LVevJM1wY22Bkd2u58wGWp97codEOqDigX6LBYrlu6CF04sBa+3R3H+nEfn1chOWZkWXseXkTYqz2
        ymW+A7c+nn5cfX6JXhiqAbjnzGxVr0wG0CNUap9r5BRK2O1dFmBHE5mCmRatvaV/Ln9Ue3xbNjvGJ
        G6T++Kig==;
Received: from [2001:4bb8:19a:7bdf:8143:492c:c3b:39b6] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nrFEE-000dV1-1l; Wed, 18 May 2022 08:40:22 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     axboe@kernel.dk
Cc:     asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH 4/6] io_uring: make apoll_events a __poll_t
Date:   Wed, 18 May 2022 10:40:03 +0200
Message-Id: <20220518084005.3255380-5-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220518084005.3255380-1-hch@lst.de>
References: <20220518084005.3255380-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

apoll_events is fed to vfs_poll and the poll tables, so it should be
a __poll_t.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/io_uring.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fc435f95ef340..1b46c3e9df33a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1031,7 +1031,7 @@ struct io_kiocb {
 		/* used by request caches, completion batching and iopoll */
 		struct io_wq_work_node	comp_list;
 		/* cache ->apoll->events */
-		int apoll_events;
+		__poll_t apoll_events;
 	};
 	atomic_t			refs;
 	atomic_t			poll_refs;
@@ -6977,7 +6977,7 @@ static void io_apoll_task_func(struct io_kiocb *req, bool *locked)
 		io_req_complete_failed(req, ret);
 }
 
-static void __io_poll_execute(struct io_kiocb *req, int mask, int events)
+static void __io_poll_execute(struct io_kiocb *req, int mask, __poll_t events)
 {
 	req->cqe.res = mask;
 	/*
@@ -6996,7 +6996,8 @@ static void __io_poll_execute(struct io_kiocb *req, int mask, int events)
 	io_req_task_work_add(req, false);
 }
 
-static inline void io_poll_execute(struct io_kiocb *req, int res, int events)
+static inline void io_poll_execute(struct io_kiocb *req, int res,
+		__poll_t events)
 {
 	if (io_poll_get_ownership(req))
 		__io_poll_execute(req, res, events);
-- 
2.30.2

