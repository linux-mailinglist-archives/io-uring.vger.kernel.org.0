Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00692220927
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2020 11:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730808AbgGOJsv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jul 2020 05:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730612AbgGOJsv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jul 2020 05:48:51 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9CCEC061755
        for <io-uring@vger.kernel.org>; Wed, 15 Jul 2020 02:48:50 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id ga4so1484979ejb.11
        for <io-uring@vger.kernel.org>; Wed, 15 Jul 2020 02:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=s2CMvuLq064YhghXs+HQkeOzczPaVNZuAeWpAbdEqSw=;
        b=tmylVmOGmC4LNsTnrk8dVzjLosglG6OXc9wxuy1rGuZVGWKbsuCtx/FvUHhs0QaMuW
         90cD9empkI5HK5f2vWoL+O1l1QxisD6cvVq4OOJb0rKmC/vZQyB4CZH1FcGkewBaCIJ2
         DP/cmj1BsJicuZP3BbkcAGSJ0CET3lNKFRpjZoDunqdG8QIbW4paw8u2UzfEwhcifz1N
         83irzl4FUzYJpsyIHGrTjdWW3AWhJRn00l9hCOyvvPKlVeU8as2kmcDmDQcCOBMil7Kc
         Wqomg5pctWWiBJdVz7Qortmu9qFLDrgzSRy9Ig4aLPiPMIkJ8nq9eBDLWUZ3iSiQLFSY
         p6gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s2CMvuLq064YhghXs+HQkeOzczPaVNZuAeWpAbdEqSw=;
        b=pE1mV6tCUVtXPnNUHXT6Bq9BlPvbWn/ByU28QiguYhsGbl0v7mkYPDFG8o2RTFSbLQ
         lkMS2UhfRPWBTjUWHsPIHeQCmNubFiqhLIUjjg/PaX9U17RNZpg20utdVTxlEpRs39pG
         16NG044KTteOObb6YG9EgJUFBm6FhjO2vtSgLoZ7E9Eh1QzP7RmlQK+/uq5s79WmslNB
         voBmHYs5PbcdsqeHBEzUYbdoQQOmFTfpP1fAtTd3mcTCVN7oR+XWmfcFpvHcoB8cU5jK
         5ycfwaKaZeG7xmdxC8eCYcKHinygdo3XgSrpeci/ByeQ4E3GuK6oPb9kCFIhFHjsGeY5
         LW6Q==
X-Gm-Message-State: AOAM530UxHnHMZP5WppYJfN4WImP6tvFcyqgiuwT5AeiPgzb17ZPzS1W
        TzcB+1ZHDplmu425b8Hbaa/w140C
X-Google-Smtp-Source: ABdhPJy+wSWtRGXDh34PlzIru2TkhniAX06rglm+LCXGTivbZvcETvVAtDyPEQwgETP6UJtJ0XmKHw==
X-Received: by 2002:a17:906:6d4d:: with SMTP id a13mr8148176ejt.146.1594806529497;
        Wed, 15 Jul 2020 02:48:49 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id d13sm1635690edv.12.2020.07.15.02.48.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 02:48:49 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/4] io_uring: inline io_req_work_grab_env()
Date:   Wed, 15 Jul 2020 12:46:49 +0300
Message-Id: <c9a358a60e24848be117bc5cebfb46f45bf7e0b2.1594806332.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1594806332.git.asml.silence@gmail.com>
References: <cover.1594806332.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The only caller of io_req_work_grab_env() is io_prep_async_work(), and
they are both initialising req->work. Inline grab_env(), it's easier
to keep this way, moreover there already were bugs with misplacing
io_req_init_async().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 48 +++++++++++++++++++-----------------------------
 1 file changed, 19 insertions(+), 29 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b854dbf530bb..149a1c37665e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1114,31 +1114,7 @@ static void __io_commit_cqring(struct io_ring_ctx *ctx)
 	}
 }
 
-static void io_req_work_grab_env(struct io_kiocb *req)
-{
-	const struct io_op_def *def = &io_op_defs[req->opcode];
-
-	io_req_init_async(req);
-
-	if (!req->work.mm && def->needs_mm) {
-		mmgrab(current->mm);
-		req->work.mm = current->mm;
-	}
-	if (!req->work.creds)
-		req->work.creds = get_current_cred();
-	if (!req->work.fs && def->needs_fs) {
-		spin_lock(&current->fs->lock);
-		if (!current->fs->in_exec) {
-			req->work.fs = current->fs;
-			req->work.fs->users++;
-		} else {
-			req->work.flags |= IO_WQ_WORK_CANCEL;
-		}
-		spin_unlock(&current->fs->lock);
-	}
-}
-
-static inline void io_req_work_drop_env(struct io_kiocb *req)
+static void io_req_clean_work(struct io_kiocb *req)
 {
 	if (!(req->flags & REQ_F_WORK_INITIALIZED))
 		return;
@@ -1176,8 +1152,22 @@ static void io_prep_async_work(struct io_kiocb *req)
 		if (def->unbound_nonreg_file)
 			req->work.flags |= IO_WQ_WORK_UNBOUND;
 	}
-
-	io_req_work_grab_env(req);
+	if (!req->work.mm && def->needs_mm) {
+		mmgrab(current->mm);
+		req->work.mm = current->mm;
+	}
+	if (!req->work.creds)
+		req->work.creds = get_current_cred();
+	if (!req->work.fs && def->needs_fs) {
+		spin_lock(&current->fs->lock);
+		if (!current->fs->in_exec) {
+			req->work.fs = current->fs;
+			req->work.fs->users++;
+		} else {
+			req->work.flags |= IO_WQ_WORK_CANCEL;
+		}
+		spin_unlock(&current->fs->lock);
+	}
 }
 
 static void io_prep_async_link(struct io_kiocb *req)
@@ -1546,7 +1536,7 @@ static void io_dismantle_req(struct io_kiocb *req)
 	if (req->file)
 		io_put_file(req, req->file, (req->flags & REQ_F_FIXED_FILE));
 	__io_put_req_task(req);
-	io_req_work_drop_env(req);
+	io_req_clean_work(req);
 
 	if (req->flags & REQ_F_INFLIGHT) {
 		struct io_ring_ctx *ctx = req->ctx;
@@ -4815,7 +4805,7 @@ static bool io_poll_remove_one(struct io_kiocb *req)
 			io_put_req(req);
 			/*
 			 * restore ->work because we will call
-			 * io_req_work_drop_env below when dropping the
+			 * io_req_clean_work below when dropping the
 			 * final reference.
 			 */
 			if (req->flags & REQ_F_WORK_INITIALIZED)
-- 
2.24.0

