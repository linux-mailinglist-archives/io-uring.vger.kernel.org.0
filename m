Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAD834FC7FD
	for <lists+io-uring@lfdr.de>; Tue, 12 Apr 2022 01:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbiDKXLm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Apr 2022 19:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231184AbiDKXLl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Apr 2022 19:11:41 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD0213F44
        for <io-uring@vger.kernel.org>; Mon, 11 Apr 2022 16:09:26 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id c29so1449544pfp.1
        for <io-uring@vger.kernel.org>; Mon, 11 Apr 2022 16:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zMuHocXx7S5bI4xWNZ+ai42rlRPkJWSVZ+KJQHTyXiE=;
        b=F3oESdqV6KCWZ4tAsmEorfwl8qwjbeu/LEGxIKzIdxxiGnXFYVNfJG9naPYjT7a3as
         1VF7gA1MzOEUuq0RAgq5AveU/eFffjAYjdceKo3DXc0LilPV7K/PI1CuhCqv0N1nf5UH
         idAU6k8u9LUwUJ5SsR5fVLwQ4rwi8earLII8jy76UZ+LcrOHV9QsIsaghMEEwKqJk3hs
         oTgCpiTCJjdyuDTehm2UeQqig+7GqYaulJ1Oveu4+UjashJ598o/ATFQaRK+UYYRsv7J
         XMKeGS70Rj7uMwfYsLGyhygJ/fwBiBnDTLk6LAMfRHOwhGzMUfq80YpOV11sdQtzIMjj
         Xmug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zMuHocXx7S5bI4xWNZ+ai42rlRPkJWSVZ+KJQHTyXiE=;
        b=FozG6sax2VdXZYH7vArGkxMOzdprryoFPOgT5RTQsarZME52pikr6nk0u0EwKYhiya
         kwjYaQYSboh+lg3+RboG8Nhk+fIvu0WHq238RRatqmUSMrfOgwr9UlJ8EvD1xPG3TqnE
         M+2hZlR3Qny2e/aSJoX0/euKRCXbreUqJC9w94PujRHbOOGzOnLdP5NgerNHPCi4oH09
         vuIvvnlGVZ7W0+qwQJEx0oa8JyEomWpNl0aKJ/cK6Wr/UHDNlVl+z7oAzyHzU36fk4UK
         /JQ5e/0BBneulGCuOoSdjIuFDItrJVL2UMBiygMRas6aEZKwTOP5uf5m2KClh8t7OuAw
         QOUw==
X-Gm-Message-State: AOAM533HHSqoyF968tH5UuwquLaGi5ik7wbs/7S2/kMqYcdQ14muQrL/
        cvDrXpVyFDRVhwbNxyGKWGYO/KFHji8iKA==
X-Google-Smtp-Source: ABdhPJzgiwLRGfpnXIkVu/msiSCPcMhi4YocB9jGJI36HUTKK8dTt/NlhSgRxCJMl3l5Tpz+67YJkA==
X-Received: by 2002:aa7:9041:0:b0:4fe:3d6c:1739 with SMTP id n1-20020aa79041000000b004fe3d6c1739mr1654105pfo.13.1649718565741;
        Mon, 11 Apr 2022 16:09:25 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5-20020a631045000000b0039d942d18f0sm191614pgq.48.2022.04.11.16.09.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 16:09:25 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/4] io_uring: move apoll->events cache
Date:   Mon, 11 Apr 2022 17:09:14 -0600
Message-Id: <20220411230915.252477-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220411230915.252477-1-axboe@kernel.dk>
References: <20220411230915.252477-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In preparation for fixing a regression with pulling in an extra cacheline
for IO that doesn't usually touch the last cacheline of the io_kiocb,
move the cached location of apoll->events to space shared with some other
completion data. Like cflags, this isn't used until after the request
has been completed, so we can piggy back on top of comp_list.

Fixes: 81459350d581 ("io_uring: cache req->apoll->events in req->cflags")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b4a5e2a6aa9c..3a97535d0550 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -916,8 +916,12 @@ struct io_kiocb {
 	/* store used ubuf, so we can prevent reloading */
 	struct io_mapped_ubuf		*imu;
 
-	/* used by request caches, completion batching and iopoll */
-	struct io_wq_work_node		comp_list;
+	union {
+		/* used by request caches, completion batching and iopoll */
+		struct io_wq_work_node	comp_list;
+		/* cache ->apoll->events */
+		int apoll_events;
+	};
 	atomic_t			refs;
 	atomic_t			poll_refs;
 	struct io_task_work		io_task_work;
@@ -5833,7 +5837,6 @@ static void io_poll_remove_entries(struct io_kiocb *req)
 static int io_poll_check_events(struct io_kiocb *req, bool locked)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	struct io_poll_iocb *poll = io_poll_get_single(req);
 	int v;
 
 	/* req->task == current here, checking PF_EXITING is safe */
@@ -5850,17 +5853,17 @@ static int io_poll_check_events(struct io_kiocb *req, bool locked)
 			return -ECANCELED;
 
 		if (!req->result) {
-			struct poll_table_struct pt = { ._key = req->cflags };
+			struct poll_table_struct pt = { ._key = req->apoll_events };
 
 			if (unlikely(!io_assign_file(req, IO_URING_F_UNLOCKED)))
 				req->result = -EBADF;
 			else
-				req->result = vfs_poll(req->file, &pt) & req->cflags;
+				req->result = vfs_poll(req->file, &pt) & req->apoll_events;
 		}
 
 		/* multishot, just fill an CQE and proceed */
-		if (req->result && !(req->cflags & EPOLLONESHOT)) {
-			__poll_t mask = mangle_poll(req->result & poll->events);
+		if (req->result && !(req->apoll_events & EPOLLONESHOT)) {
+			__poll_t mask = mangle_poll(req->result & req->apoll_events);
 			bool filled;
 
 			spin_lock(&ctx->completion_lock);
@@ -5938,7 +5941,7 @@ static void __io_poll_execute(struct io_kiocb *req, int mask, int events)
 	 * CPU. We want to avoid pulling in req->apoll->events for that
 	 * case.
 	 */
-	req->cflags = events;
+	req->apoll_events = events;
 	if (req->opcode == IORING_OP_POLL_ADD)
 		req->io_task_work.func = io_poll_task_func;
 	else
@@ -6330,7 +6333,7 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 		return -EINVAL;
 
 	io_req_set_refcount(req);
-	req->cflags = poll->events = io_poll_parse_events(sqe, flags);
+	req->apoll_events = poll->events = io_poll_parse_events(sqe, flags);
 	return 0;
 }
 
-- 
2.35.1

