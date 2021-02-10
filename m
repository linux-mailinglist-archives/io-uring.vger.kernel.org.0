Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA6023165B6
	for <lists+io-uring@lfdr.de>; Wed, 10 Feb 2021 12:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbhBJLwW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Feb 2021 06:52:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231316AbhBJLuR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Feb 2021 06:50:17 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DADCFC061756
        for <io-uring@vger.kernel.org>; Wed, 10 Feb 2021 03:49:36 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id l12so2175584wry.2
        for <io-uring@vger.kernel.org>; Wed, 10 Feb 2021 03:49:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Kim+Egx3YunVE89CFAHxppDmL27JDdkp02s227ojOWE=;
        b=QT37/rCfUNSa5SZWe1Mtmir2xZXRDYNlgSY9kVmkcI7RDCqnzPCUYYz73vzyeZuely
         Y/rwezq7+lKmPSVRErxLAfXKJEGTj/AKauTiAZeZfcWx0Emig7R/sfjSwFmb7bUAKLW7
         NuA00cwUA/eByKLqdjwJRg+//F3F/4VvPGm4roiz5zIn/S5eic5oeWuK7+d52XsfDULc
         y5FPS3PWoRU+J1sAzxbuNTiQOxdi9OuBZLXRXbwdsV5tWDZ1nu/PiNvQGENJCYEO+TBd
         +RbjGVGvYNRkBlsP6Wb0ke9VebaGmle0gHJvZMHrHHGPLodGRHSfccrzI3V+QCMbUwvD
         PZ2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Kim+Egx3YunVE89CFAHxppDmL27JDdkp02s227ojOWE=;
        b=aCDLU9BTOsZpr56oOgS5EV6xCDVL8e6yyg9yp4Y3B8GchL6b2MG/VdBEoxL7+Tu5eq
         vdlyJIda9IvC0V0JVs+I99uL8ZfGQ/Z2ZmTaUFI+YzLWThy9GGkofZfecc2h4TpQUK/Q
         jNGqFLIfLr2fUKc0uhAES5Q8BBK2+iOggIa8M+Yjnj85/uAvlX5lWswTLPpfc2/Nx6Wx
         ZI1xykuCN1aFSw2CnhTNq2M93p3RM0B7mxGTm2Taq9l136o4/ynV5wTlY51o5Vvislv0
         KmIQ4cK/yOQ6zApmqPMx07ExyqbLgZXnf3Iv7D9VCo9KziTl5sMpvmsZ9dbrROmukfNv
         aQGQ==
X-Gm-Message-State: AOAM532pk8sXqieDVYPn6rjXx+CRdezFtKsJEmghH+hxl7lgM0tW57O0
        NmVJud/UJz6lIm4/5gR+zO1U1T7MBx2QHA==
X-Google-Smtp-Source: ABdhPJyfwuHtVjXnbzvky3yCm2/VFYN9yHz9p1VK8g8aaDinqP9dlJ5ZIT9DKJiTQ0wtLYeEzLLUxA==
X-Received: by 2002:a05:6000:1201:: with SMTP id e1mr3328663wrx.14.1612957775733;
        Wed, 10 Feb 2021 03:49:35 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.126])
        by smtp.gmail.com with ESMTPSA id j11sm2811145wrt.26.2021.02.10.03.49.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 03:49:35 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/2] io_uring: cancel files inflight counting
Date:   Wed, 10 Feb 2021 11:45:41 +0000
Message-Id: <814776086d1f35dfc3040cf0d8f35f9c0ccb2e61.1612957420.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612957420.git.asml.silence@gmail.com>
References: <cover.1612957420.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

To not skip events, io_uring_cancel_files() is pretty much counts on
io_uring_count_inflight() to be monotonous for the time it's used.
That's  not the case when it includes requests of other thats that are
PF_EXITING.

Cancel as before, but don't account extra in io_uring_count_inflight(),
we can hang otherwise.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 17194e0d62ff..6b73e38aa1a9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1090,15 +1090,14 @@ static inline void io_set_resource_node(struct io_kiocb *req)
 	}
 }
 
-static bool io_match_task(struct io_kiocb *head,
-			  struct task_struct *task,
-			  struct files_struct *files)
+static bool __io_match_task(struct io_kiocb *head, struct task_struct *task,
+			    struct files_struct *files, bool match_exiting)
 {
 	struct io_kiocb *req;
 
 	if (task && head->task != task) {
 		/* in terms of cancelation, always match if req task is dead */
-		if (head->task->flags & PF_EXITING)
+		if (match_exiting && (head->task->flags & PF_EXITING))
 			return true;
 		return false;
 	}
@@ -1117,6 +1116,13 @@ static bool io_match_task(struct io_kiocb *head,
 	return false;
 }
 
+static bool io_match_task(struct io_kiocb *head,
+			  struct task_struct *task,
+			  struct files_struct *files)
+{
+	return __io_match_task(head, task, files, true);
+}
+
 static void io_sq_thread_drop_mm_files(void)
 {
 	struct files_struct *files = current->files;
@@ -9032,7 +9038,7 @@ static int io_uring_count_inflight(struct io_ring_ctx *ctx,
 
 	spin_lock_irq(&ctx->inflight_lock);
 	list_for_each_entry(req, &ctx->inflight_list, inflight_entry)
-		cnt += io_match_task(req, task, files);
+		cnt += __io_match_task(req, task, files, false);
 	spin_unlock_irq(&ctx->inflight_lock);
 	return cnt;
 }
-- 
2.24.0

