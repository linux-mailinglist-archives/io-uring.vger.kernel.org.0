Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0C422A969F
	for <lists+io-uring@lfdr.de>; Fri,  6 Nov 2020 14:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727343AbgKFNDr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 Nov 2020 08:03:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727314AbgKFNDn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 Nov 2020 08:03:43 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBF99C0613CF
        for <io-uring@vger.kernel.org>; Fri,  6 Nov 2020 05:03:42 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id c16so1267751wmd.2
        for <io-uring@vger.kernel.org>; Fri, 06 Nov 2020 05:03:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=i+iOu1q/eMXYH22dRLcknqvk+0dhZOxGvUAoXbY8KzE=;
        b=GxaDQ/h4InSugtwq8Jr2kbUWyMt+nRhwn05w7T0DbqixBVAwLAfJ7rotrYJLSGaChf
         9UgXtgEQXJMs944QLmKmgXVVt1VZFhfoxrqDQIxWVBpgIA+b1y8D00sBQqmmkghYIUjK
         A75OFcYFzU432WFMRSbmob068Cn+mwr9TtxLM8CBBEptweANCrVMpOduHjWQL86gR9M0
         s0M1x5H3ZmcHYDqKzYdj6DvOJ13e4Sw8wjMlbc3ogCWhKT0TDTodwmTlI5024Iv2J8f5
         92By3WX5aFnINhVO+Ae0/bn8/fAL62mrYAb5FUKnV20umYtvdhED/AzskUuy/gZUw4Mr
         4DPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i+iOu1q/eMXYH22dRLcknqvk+0dhZOxGvUAoXbY8KzE=;
        b=eGnh7ou5BCWd/fwFD7tA3MP63pa8uLTI3YTP4aEIPPK7QNB6LRrNyAxcLAxNN2I6Is
         dtJfC3h4nMU4OQI5PbOnGUjNkYPCBpdhAWb2i4bnjauj9GtIEjMkbj8D5/rRQEZO3ifB
         SwjY1LpjVzUQlqf9Ey3yVjE4tcLFeCIHaQHmZ1g+SFyLQAfYj0b/4IxH+VP5wmwjtIzE
         mdb46lduxw5psZAg1TvQo1d25E1PWYY5BciA7uF2K+hNFRaiWx3Z1payKdEly/LCMzss
         k8l19r/NCrk05tSTbVsi/2OpoBHZiq7IWbcARUOEqzU+Qu1UpRiWn14HHfCYlLufZSem
         Bn/w==
X-Gm-Message-State: AOAM531x+SfJwSTCOd+FHpwflMuGCtaFoO0A2Pt+0G2YfzwzrBZeAXVy
        dYWJr26jN+kTKqz2qz8vfTA=
X-Google-Smtp-Source: ABdhPJxQyjgM0J74zZt6dMGaAtedNmT8rbNnDBxToO+g8nM8f6eZI74QPWAT6gCQmbcIL7SyDFT3Sw==
X-Received: by 2002:a7b:ce0e:: with SMTP id m14mr2348622wmc.111.1604667821683;
        Fri, 06 Nov 2020 05:03:41 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id e5sm1931839wrw.93.2020.11.06.05.03.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 05:03:41 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/6] io_uring: add a {task,files} pair matching helper
Date:   Fri,  6 Nov 2020 13:00:22 +0000
Message-Id: <e6b9817bd9db1a4f51fd20261452f4340c929c37.1604667122.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1604667122.git.asml.silence@gmail.com>
References: <cover.1604667122.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add io_match_task() that matches both task and files.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 48 ++++++++++++++++++++++--------------------------
 1 file changed, 22 insertions(+), 26 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 74bb5cb9697c..14e671c909ed 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1037,6 +1037,26 @@ static inline void io_clean_op(struct io_kiocb *req)
 		__io_clean_op(req);
 }
 
+static bool io_match_task(struct io_kiocb *head,
+			  struct task_struct *task,
+			  struct files_struct *files)
+{
+	struct io_kiocb *req;
+
+	if (task && head->task != task)
+		return false;
+	if (!files)
+		return true;
+
+	io_for_each_link(req, head) {
+		if ((req->flags & REQ_F_WORK_INITIALIZED) &&
+		    (req->work.flags & IO_WQ_WORK_FILES) &&
+		    req->work.identity->files == files)
+			return true;
+	}
+	return false;
+}
+
 static void io_sq_thread_drop_mm_files(void)
 {
 	struct files_struct *files = current->files;
@@ -1686,27 +1706,6 @@ static void io_cqring_mark_overflow(struct io_ring_ctx *ctx)
 	}
 }
 
-static inline bool __io_match_files(struct io_kiocb *req,
-				    struct files_struct *files)
-{
-	return ((req->flags & REQ_F_WORK_INITIALIZED) &&
-	        (req->work.flags & IO_WQ_WORK_FILES)) &&
-		req->work.identity->files == files;
-}
-
-static bool io_match_files(struct io_kiocb *head, struct files_struct *files)
-{
-	struct io_kiocb *req;
-
-	if (!files)
-		return true;
-	io_for_each_link(req, head) {
-		if (__io_match_files(req, files))
-			return true;
-	}
-	return false;
-}
-
 /* Returns true if there are no backlogged entries after the flush */
 static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
 				     struct task_struct *tsk,
@@ -1734,9 +1733,7 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
 
 	cqe = NULL;
 	list_for_each_entry_safe(req, tmp, &ctx->cq_overflow_list, compl.list) {
-		if (tsk && req->task != tsk)
-			continue;
-		if (!io_match_files(req, files))
+		if (!io_match_task(req, tsk, files))
 			continue;
 
 		cqe = io_get_cqring(ctx);
@@ -8776,8 +8773,7 @@ static void io_cancel_defer_files(struct io_ring_ctx *ctx,
 
 	spin_lock_irq(&ctx->completion_lock);
 	list_for_each_entry_reverse(de, &ctx->defer_list, list) {
-		if (io_task_match(de->req, task) &&
-		    io_match_files(de->req, files)) {
+		if (io_match_task(de->req, task, files)) {
 			list_cut_position(&list, &ctx->defer_list, &de->list);
 			break;
 		}
-- 
2.24.0

