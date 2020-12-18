Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1AEF2DE333
	for <lists+io-uring@lfdr.de>; Fri, 18 Dec 2020 14:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbgLRNRW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Dec 2020 08:17:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727645AbgLRNRW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Dec 2020 08:17:22 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8819FC0611C5
        for <io-uring@vger.kernel.org>; Fri, 18 Dec 2020 05:16:07 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id r4so2510396wmh.5
        for <io-uring@vger.kernel.org>; Fri, 18 Dec 2020 05:16:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=qn2CQ12XFIPIYy+WknqbKRR5JZfrb7fJeTILyI1yCv0=;
        b=DXKB3B0HQ9cYpeMBxtjBQOedgx3OeDPRTyF3zZu2f9lRMD2eFlh8/q9HEzaCcaUO7G
         m0ZlqcGJRvO+X4WdPSb8mQvcBUDNzvEMuHE0mp+zvTQfpgxk7sztuzDyqSsGmxJ1sS7+
         GRBziAHAsPYRRQ19Nm3V9qSM0D2b3sqpFuvTf6CTa7JWoE1q/Fra64AekF3GSInOVINI
         1GKV8/H6nMwgOs6OtVMrsvqRtid8TRiyt2Qt4BojEvqWF0xEByQlRZyH/hm7yapq+7TJ
         a8DCW2Po+MxOcM6rYCyIqE2Te7KGI11tfd0OLAvfjOdG91Qw/Zzsgk4evxvQ4C0aQzdT
         yv0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qn2CQ12XFIPIYy+WknqbKRR5JZfrb7fJeTILyI1yCv0=;
        b=qIlA0jKpGer1u0HgVkBYVVJPtIEzQF3+1ty4EOuXSF7bGy4m0fv6eFWRV6xpCgBRFh
         7GpcXHZLBsgnQDbcN7fVxKz8XlXR5bRwls+Z+gHxmePw4LgVFsN7c30vH4LCAxQyC9Re
         euDUWkaW6tWNtD016BfWeuwOAY/M7RpkHN0MMPvguriEYM9B48lIkaR3jhLkiOcwh8is
         aiYADFQ838IK6ALcUz7ZsD+zrcbPTJ/MtQsCIhUGi08lDRYJ3a5KgQ7l1XPcffFbxzyX
         h8/mqB+l7A70dk9O+bCNMUULQ8wO+OAH6muNVGMNv1W0D+4SNj5PPTTtv7cuch+Hs3vO
         7NCA==
X-Gm-Message-State: AOAM533Aw4U4QCF+TAagthIy2llEs4G6nt58hn1pFRUhTqZobkl1ybpV
        TB6mmlC4gXkwiOpNEJ9Uogo=
X-Google-Smtp-Source: ABdhPJxPfrIHnfYmObWAn56zpxt+otySsAIAXaq4aLqOi0YSlEBQyQloU+7z6uwmwEYc0rLBsyw+NQ==
X-Received: by 2002:a1c:2203:: with SMTP id i3mr4200537wmi.6.1608297366301;
        Fri, 18 Dec 2020 05:16:06 -0800 (PST)
Received: from localhost.localdomain ([85.255.234.120])
        by smtp.gmail.com with ESMTPSA id b9sm12778595wmd.32.2020.12.18.05.16.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Dec 2020 05:16:05 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 7/8] io_uring: cleanup task cancel
Date:   Fri, 18 Dec 2020 13:12:27 +0000
Message-Id: <9a2eadf262a9e119461d21a2761537436614f88e.1608296656.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1608296656.git.asml.silence@gmail.com>
References: <cover.1608296656.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There is no use of io_uring_try_task_cancel(), inline it, kill extra
in_idle inc/dec as it's already done by __io_uring_task_cancel(), and do
a bit of renaming.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4bf709d9db32..134ea0e3373d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8767,8 +8767,8 @@ static void __io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
  * hard links. These persist even for failure of cancelations, hence keep
  * looping until none are found.
  */
-static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
-					  struct files_struct *files)
+static void io_uring_try_task_cancel(struct io_ring_ctx *ctx,
+				     struct files_struct *files)
 {
 	struct task_struct *task = current;
 
@@ -8862,19 +8862,6 @@ static void io_uring_attempt_task_drop(struct file *file)
 		io_uring_del_task_file(current->io_uring, file);
 }
 
-static void io_uring_try_task_cancel(struct files_struct *files)
-{
-	struct io_uring_task *tctx = current->io_uring;
-	struct file *file;
-	unsigned long index;
-
-	/* make sure overflow events are dropped */
-	atomic_inc(&tctx->in_idle);
-	xa_for_each(&tctx->xa, index, file)
-		io_uring_cancel_task_requests(file->private_data, files);
-	atomic_dec(&tctx->in_idle);
-}
-
 static s64 tctx_inflight(struct io_uring_task *tctx, bool files)
 {
 	unsigned long index;
@@ -8917,6 +8904,8 @@ static s64 tctx_inflight(struct io_uring_task *tctx, bool files)
 void __io_uring_task_cancel(struct files_struct *files)
 {
 	struct io_uring_task *tctx = current->io_uring;
+	unsigned long index;
+	struct file *file;
 	DEFINE_WAIT(wait);
 	s64 inflight;
 
@@ -8928,7 +8917,8 @@ void __io_uring_task_cancel(struct files_struct *files)
 		inflight = tctx_inflight(tctx, !!files);
 		if (!inflight)
 			break;
-		io_uring_try_task_cancel(files);
+		xa_for_each(&tctx->xa, index, file)
+			io_uring_try_task_cancel(file->private_data, files);
 
 		prepare_to_wait(&tctx->wait, &wait, TASK_UNINTERRUPTIBLE);
 
@@ -8945,9 +8935,6 @@ void __io_uring_task_cancel(struct files_struct *files)
 	atomic_dec(&tctx->in_idle);
 
 	if (files) {
-		struct file *file;
-		unsigned long index;
-
 		xa_for_each(&tctx->xa, index, file)
 			io_uring_del_task_file(tctx, file);
 	}
-- 
2.24.0

