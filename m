Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22A7D43834E
	for <lists+io-uring@lfdr.de>; Sat, 23 Oct 2021 13:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbhJWLQc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 Oct 2021 07:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbhJWLQb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 Oct 2021 07:16:31 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFCB9C061764
        for <io-uring@vger.kernel.org>; Sat, 23 Oct 2021 04:14:12 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 67-20020a1c1946000000b0030d4c90fa87so4738718wmz.2
        for <io-uring@vger.kernel.org>; Sat, 23 Oct 2021 04:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+jwjn7+CzJ9li1XvVvXkEhgmX5LuJsaUhNCyW1KF+c4=;
        b=odAwvdD++5MUgydqwLyFpUNX0WiVbq5lH0khtaNiUOHoR8DWql41Po/CGiyiMwbV0U
         QodeeOS8n8ijxtWuF7pJAEyPil56Vrm5w296hBCrwVfNUCfgprL1Z345MmgVds9Gnu6w
         7Jty/Bb1/PI4+UwF9dCsdZqlv8d0mdHyL7QXCzIOtwALJZTapyImpvSpDm9yNw/MWO5Z
         zpVP0U3I+Bntsf7f7V44nAsf37of91kUTh+5w2MajYjjmwhEUdfhUMTYsqXbDHwME2LH
         I0j4woyQgm+b7cEvkX7FxZZ7OWVcQMdyGfs3KFpiSmcR+aPXVk+Qkyc5tM+Y0F2Q7Kjz
         X8jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+jwjn7+CzJ9li1XvVvXkEhgmX5LuJsaUhNCyW1KF+c4=;
        b=EILtbakIwWV31eDBZ6BjECfZ3hpp7TkGtQtHTnJ/WlWxOKFfnsnjMr7oIGLBqiwUne
         nO+ivNUfz7wmwUEkQyavX32KP7016gXly4Y5xX0BfFc2GRZZLzLIA+jXGZW5bkfyeLMa
         ft7OTUr8h94xssaMhyD6k1WNyP4P9IwdrgmXkGZVG4DK8poY4em7+KMp+g6pGNSCESni
         HtNqYfRz99rJH7lFfXSnV8IK/FfXo9FZ7hewh0IiPGC1odsTywXOoJCU6I5An4tex/sb
         cuNvwGNNBFVYD7dmgx4064sOTTzSyxGjgquwumSJf5p5UcAz/9H+IIJRCyKFek1ntmC5
         AuPQ==
X-Gm-Message-State: AOAM530InK+vHlOg2QRZjl4hR5pnAQIeYnENAZmc52xC2eiujypIIHAr
        nmj4Zo19D/ZN+mA//6OG8EIcBhwUXo4=
X-Google-Smtp-Source: ABdhPJyrFS9gv4mn1MmppmjFRwXTvDPvvHq0A01ivx8wr5Hu34nt9cFmcXcveNv3i5eiylomZwswqQ==
X-Received: by 2002:a1c:9d14:: with SMTP id g20mr6175336wme.110.1634987651334;
        Sat, 23 Oct 2021 04:14:11 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.133.195])
        by smtp.gmail.com with ESMTPSA id w2sm10416316wrt.31.2021.10.23.04.14.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Oct 2021 04:14:11 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Hao Xu <haoxu@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 3/8] io_uring: clean iowq submit work cancellation
Date:   Sat, 23 Oct 2021 12:13:57 +0100
Message-Id: <ff4a09cf41f7a22bbb294b6f1faea721e21fe615.1634987320.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1634987320.git.asml.silence@gmail.com>
References: <cover.1634987320.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If we've got IO_WQ_WORK_CANCEL in io_wq_submit_work(), handle the error
on the same lines as the check instead of having a weird code flow. The
main loop doesn't change but goes one indention left.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 59 +++++++++++++++++++++++++--------------------------
 1 file changed, 29 insertions(+), 30 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7f92523c1282..58cb3a14d58e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6721,6 +6721,8 @@ static struct io_wq_work *io_wq_free_work(struct io_wq_work *work)
 static void io_wq_submit_work(struct io_wq_work *work)
 {
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
+	unsigned int issue_flags = IO_URING_F_UNLOCKED;
+	bool needs_poll = false;
 	struct io_kiocb *timeout;
 	int ret = 0;
 
@@ -6735,40 +6737,37 @@ static void io_wq_submit_work(struct io_wq_work *work)
 		io_queue_linked_timeout(timeout);
 
 	/* either cancelled or io-wq is dying, so don't touch tctx->iowq */
-	if (work->flags & IO_WQ_WORK_CANCEL)
-		ret = -ECANCELED;
+	if (work->flags & IO_WQ_WORK_CANCEL) {
+		io_req_task_queue_fail(req, -ECANCELED);
+		return;
+	}
 
-	if (!ret) {
-		bool needs_poll = false;
-		unsigned int issue_flags = IO_URING_F_UNLOCKED;
+	if (req->flags & REQ_F_FORCE_ASYNC) {
+		needs_poll = req->file && file_can_poll(req->file);
+		if (needs_poll)
+			issue_flags |= IO_URING_F_NONBLOCK;
+	}
 
-		if (req->flags & REQ_F_FORCE_ASYNC) {
-			needs_poll = req->file && file_can_poll(req->file);
-			if (needs_poll)
-				issue_flags |= IO_URING_F_NONBLOCK;
+	do {
+		ret = io_issue_sqe(req, issue_flags);
+		if (ret != -EAGAIN)
+			break;
+		/*
+		 * We can get EAGAIN for iopolled IO even though we're
+		 * forcing a sync submission from here, since we can't
+		 * wait for request slots on the block side.
+		 */
+		if (!needs_poll) {
+			cond_resched();
+			continue;
 		}
 
-		do {
-			ret = io_issue_sqe(req, issue_flags);
-			if (ret != -EAGAIN)
-				break;
-			/*
-			 * We can get EAGAIN for iopolled IO even though we're
-			 * forcing a sync submission from here, since we can't
-			 * wait for request slots on the block side.
-			 */
-			if (!needs_poll) {
-				cond_resched();
-				continue;
-			}
-
-			if (io_arm_poll_handler(req) == IO_APOLL_OK)
-				return;
-			/* aborted or ready, in either case retry blocking */
-			needs_poll = false;
-			issue_flags &= ~IO_URING_F_NONBLOCK;
-		} while (1);
-	}
+		if (io_arm_poll_handler(req) == IO_APOLL_OK)
+			return;
+		/* aborted or ready, in either case retry blocking */
+		needs_poll = false;
+		issue_flags &= ~IO_URING_F_NONBLOCK;
+	} while (1);
 
 	/* avoid locking problems by failing it from a clean context */
 	if (ret)
-- 
2.33.1

