Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B96AD2E8F57
	for <lists+io-uring@lfdr.de>; Mon,  4 Jan 2021 03:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727513AbhADCDj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Jan 2021 21:03:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727709AbhADCDi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Jan 2021 21:03:38 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7261AC061793
        for <io-uring@vger.kernel.org>; Sun,  3 Jan 2021 18:02:58 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id t16so30711921wra.3
        for <io-uring@vger.kernel.org>; Sun, 03 Jan 2021 18:02:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=K2rcJ8n6pGAZCg4TmSNTLqt1Zo8w+vtt0tSV58Fl2Dc=;
        b=rlRJOIe0bbK7AuP561FVehsdHT+liECUNhqG/UKHgeoxLWclIUfH04Mjy4mt/59KO5
         iDjMQXuuOZEylnPoTwK1fFAxKPhAnLsj/8hzz7kqlaJBMLjg4Pm09HaLZ9ngh+n68+5a
         Fkw3zTtENFxzwpUZalelY9GZlIEyw4n7oWEPasEBwNy4OF21ssopj0gX6RZYkopx8Opy
         eOlnYZpkdgLvZJI0DUq2Ygu1Om3KGoE0IT4nDUruhNx2ReWrXVRC06GruVEU8tE8ggqf
         pRETt13W9PreCX6tSaKjC7V4dDUg5unpcSxzEFy8TiBVK1kmAwbQ5PRylAf1PAe2isWr
         4Q1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K2rcJ8n6pGAZCg4TmSNTLqt1Zo8w+vtt0tSV58Fl2Dc=;
        b=jaVkbSd6F8TklnicjLyP9Mh6LSG798gAo8XYVbuuj547RYg5Po7ovzosqXS8pHTQ7B
         jI0zrefvSOD90pbuqX7J9uiQTBN8ISnNJ/EUA//Etb8yTCAtPtR5k6EoMFQhTNh2Q8Bh
         MDbtEaq/qkhS3qFFr1ipb0kX4KE/OepUtMVQxwRAHsmi9La5dXjVXMXJqCSeNXL9kwg7
         rX5RAGnlkldE0FWm+JY6fWGRCY5vzOjygdw//lcQSC2rbK46SclpFjU6d55+c9PgTgHn
         QYDycESXM9yYbYxfyLGzk4sbeN4amL9+RuDFiqM4Ec40NbOqSAklgAHbTNTIBdF9NLCh
         7AGg==
X-Gm-Message-State: AOAM533f2R+k+gk1HWwoIsE0i7x8lritzsjJaSh5OUm4FecUnLrZHvZv
        eaU0sKZIihEwkW1YD1CD6zJlo42pSlpzZQ==
X-Google-Smtp-Source: ABdhPJx2q8F4I9aKjgNq2uHX/6eRuKbEvL0z8vQN1yzGteSzT087e8eJEDUGsMSEfGg6riTXWu3nGQ==
X-Received: by 2002:adf:e547:: with SMTP id z7mr75704886wrm.283.1609725777227;
        Sun, 03 Jan 2021 18:02:57 -0800 (PST)
Received: from localhost.localdomain ([85.255.233.205])
        by smtp.gmail.com with ESMTPSA id c4sm96632893wrw.72.2021.01.03.18.02.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Jan 2021 18:02:56 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 1/6] io_uring: drop file refs after task cancel
Date:   Mon,  4 Jan 2021 01:59:14 +0000
Message-Id: <1857205031b0ad011bd32f27b1438c60315e10c5.1609725418.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1609725418.git.asml.silence@gmail.com>
References: <cover.1609725418.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_uring fds marked O_CLOEXEC and we explicitly cancel all requests
before going through exec, so we don't want to leave task's file
references to not our anymore io_uring instances.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ca46f314640b..ee1beec7a04d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8948,6 +8948,15 @@ static void io_uring_attempt_task_drop(struct file *file)
 		io_uring_del_task_file(file);
 }
 
+static void io_uring_remove_task_files(struct io_uring_task *tctx)
+{
+	struct file *file;
+	unsigned long index;
+
+	xa_for_each(&tctx->xa, index, file)
+		io_uring_del_task_file(file);
+}
+
 void __io_uring_files_cancel(struct files_struct *files)
 {
 	struct io_uring_task *tctx = current->io_uring;
@@ -8956,16 +8965,12 @@ void __io_uring_files_cancel(struct files_struct *files)
 
 	/* make sure overflow events are dropped */
 	atomic_inc(&tctx->in_idle);
-
-	xa_for_each(&tctx->xa, index, file) {
-		struct io_ring_ctx *ctx = file->private_data;
-
-		io_uring_cancel_task_requests(ctx, files);
-		if (files)
-			io_uring_del_task_file(file);
-	}
-
+	xa_for_each(&tctx->xa, index, file)
+		io_uring_cancel_task_requests(file->private_data, files);
 	atomic_dec(&tctx->in_idle);
+
+	if (files)
+		io_uring_remove_task_files(tctx);
 }
 
 static s64 tctx_inflight(struct io_uring_task *tctx)
@@ -9028,6 +9033,8 @@ void __io_uring_task_cancel(void)
 	} while (1);
 
 	atomic_dec(&tctx->in_idle);
+
+	io_uring_remove_task_files(tctx);
 }
 
 static int io_uring_flush(struct file *file, void *data)
-- 
2.24.0

