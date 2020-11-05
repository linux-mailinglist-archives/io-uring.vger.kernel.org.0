Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67C7E2A8069
	for <lists+io-uring@lfdr.de>; Thu,  5 Nov 2020 15:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730669AbgKEOJa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Nov 2020 09:09:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgKEOJ3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Nov 2020 09:09:29 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EFB6C0613CF
        for <io-uring@vger.kernel.org>; Thu,  5 Nov 2020 06:09:28 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id w1so1935521wrm.4
        for <io-uring@vger.kernel.org>; Thu, 05 Nov 2020 06:09:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RQvzvLklLKp6j5WfUkLuKtKfLsbfzYjsb00HcZ3TBDM=;
        b=eI5TF2CTiBjWEbiLWtALNNedcsB/YD3el7MEE4JPMTLkZTnidYN66kI4I2VrHBlUeI
         SkfOad5+/khGCdpOVwkW+zGwJw/CQfT3Pkb6Gah7ccCsCpONV5ybzWrFv0wxVodG6Myn
         Z68A/S29XpYv87xXbam6RDKbQ9RIOiTPoZjwq0PbpHu8AAVN+byWI5qTd7IiPq90yC4E
         j7UYDpN8xsKXx+WWp/93xxLeFNa3r8LvJrhNZI9ZABj0cKZ3WwAFoYhNG5slLeA67VGv
         eubVRzRFreo5oIc5VrVB4R9yl9FJiN4c1d/RfzEVKysWmLoT2rwie/9yOoG7IPIHhrJR
         NSXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RQvzvLklLKp6j5WfUkLuKtKfLsbfzYjsb00HcZ3TBDM=;
        b=PMBT97gMfYjnDRECxSR8MjuWWTp90F2UHRnc19FznWv09f5tGGBTbxDZqRsSzruq/Z
         vqu6GNVPHUCkwYZh6WBwYlv5QnAESVa+M2O6B38aHtd8dX0e/Iz4CP0EH/pjk732fb09
         A8ePj466WKmmk/53KCT/uRbkAV9mCemxh8vY+BY0DfHroEGGJ/VGyGq4hpRcZ9Y2HIuy
         LdTEKCB7iH9Zb8DwOh0mLr5FKai+VOPCQLdVSJKtCNK50M5pYFXZUkjV1kBXoAX7JMBL
         EQZ9pzI0KN8CFopkT7n57paUELQeJVKPB93l/h5xKxy+XGN2kG6T9AbxmQzmchl/Iibu
         VFnw==
X-Gm-Message-State: AOAM531BnTc4J12vwIrui8LOPIBzHeQPfWZbus/Y3ERt8XLTNL1ZUuCV
        b7VvfEqbbCngQTj2OtOaAZd1oPJ180w=
X-Google-Smtp-Source: ABdhPJwc0YQ1dMFINPK9E0BEhYV27xZGetY8/SuRQC2s1GFjGv1sZjnRK9U/WpH6KSZP6R15/DXzeg==
X-Received: by 2002:adf:bd86:: with SMTP id l6mr3259246wrh.205.1604585366727;
        Thu, 05 Nov 2020 06:09:26 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id x1sm2612874wrl.41.2020.11.05.06.09.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 06:09:26 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.10] io_uring: don't forget to task-cancel drained reqs
Date:   Thu,  5 Nov 2020 14:06:19 +0000
Message-Id: <d507a3d66353d83b20d8a5e2722e8e437233449a.1604585149.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If there is a long-standing request of one task locking up execution of
deferred requests, and the defer list contains requests of another task
(all files-less), then a potential execution of __io_uring_task_cancel()
by that another task will sleep until that first long-standing request
completion, and that may take long.

E.g.
tsk1: req1/read(empty_pipe) -> tsk2: req(DRAIN)
Then __io_uring_task_cancel(tsk2) waits for req1 completion.

It seems we even can manufacture a complicated case with many tasks
sharing many rings that can lock them forever.

Cancel deferred requests for __io_uring_task_cancel() as well.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

Looks like I can't finish refactoring cancellations without finding new
flaws to fix. That may be not the prettiest thing but will be cleaned in
5.11.

 fs/io_uring.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 984cc961871f..58da3489d791 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8495,6 +8495,7 @@ static void io_attempt_cancel(struct io_ring_ctx *ctx, struct io_kiocb *req)
 }
 
 static void io_cancel_defer_files(struct io_ring_ctx *ctx,
+				  struct task_struct *task,
 				  struct files_struct *files)
 {
 	struct io_defer_entry *de = NULL;
@@ -8502,7 +8503,8 @@ static void io_cancel_defer_files(struct io_ring_ctx *ctx,
 
 	spin_lock_irq(&ctx->completion_lock);
 	list_for_each_entry_reverse(de, &ctx->defer_list, list) {
-		if (io_match_files(de->req, files)) {
+		if (io_task_match(de->req, task) &&
+		    io_match_files(de->req, files)) {
 			list_cut_position(&list, &ctx->defer_list, &de->list);
 			break;
 		}
@@ -8528,7 +8530,6 @@ static bool io_uring_cancel_files(struct io_ring_ctx *ctx,
 	if (list_empty_careful(&ctx->inflight_list))
 		return false;
 
-	io_cancel_defer_files(ctx, files);
 	/* cancel all at once, should be faster than doing it one by one*/
 	io_wq_cancel_cb(ctx->io_wq, io_wq_files_match, files, true);
 
@@ -8620,6 +8621,11 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 		io_sq_thread_park(ctx->sq_data);
 	}
 
+	if (files)
+		io_cancel_defer_files(ctx, NULL, files);
+	else
+		io_cancel_defer_files(ctx, task, NULL);
+
 	io_cqring_overflow_flush(ctx, true, task, files);
 
 	while (__io_uring_cancel_task_requests(ctx, task, files)) {
-- 
2.24.0

