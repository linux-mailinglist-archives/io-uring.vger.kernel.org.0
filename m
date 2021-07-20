Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5843CF733
	for <lists+io-uring@lfdr.de>; Tue, 20 Jul 2021 11:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231922AbhGTJKk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Jul 2021 05:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbhGTJKj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Jul 2021 05:10:39 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08F56C061762
        for <io-uring@vger.kernel.org>; Tue, 20 Jul 2021 02:51:17 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id u5-20020a7bc0450000b02901480e40338bso1240334wmc.1
        for <io-uring@vger.kernel.org>; Tue, 20 Jul 2021 02:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zhmSfp6HBE7HEEyKl/xOTkO/7cbYQMAhGX5YKiISW2k=;
        b=ea5mXCRlSwO3bkS5XIYzfY8gA9Esg41Z9bB4luom9EaTveFVvnSZ83+diKz9Zene2u
         wIvJqfY071ugDtIq4HKwLjoKxxoiuXNFfyzVa3lmmnY1PQw42JUomMHNfliuq3deR9BW
         C1ntdAtkLOiF4qGqsc/dn40Tle7NjU6aBS/Skk8tIp4THWKYJF3AHFTNEzoEYR8+JNKt
         ccbjzEHFzClQpD7ne+wqhumlqvB5Aslh36uiEu9ONKxD5SJCDJA0R3W8Dj3oHhi71sEr
         2SWr9328303p0MZJXoqW9AJoxfENQQ0bd4anPPYd+tw3wJXP99ad2BH0XJi1grpNmNVX
         uC7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zhmSfp6HBE7HEEyKl/xOTkO/7cbYQMAhGX5YKiISW2k=;
        b=jeNm4ByHSoB1JT4Ag+BSuyckVXyu7qSDuYkk1Pq64nh2jqhzo2xlCU7BjqHRESej9v
         F+qfiQdZJY/7L3lEfSl8Lt+Zk6Z4XINda5m33kuRThtHLXiRTTjmoei1H2HIzFtc263t
         Hdc7av0XYxVBbgLYBOF2QTe8fXoUTjikrdrbaMp/g5yCkDoCmpODFc9eW1QykQakI6Y5
         5d/4ZiD/K5ZQ8qyqonPhte5NjBsK1R5qKfAWaV+Ib+K20BOa8QZhwDNc349ZO/99+W3/
         p0rd+eKY53Q/5hFfxQoyJIrGpGQDTyENWxyBmP45eKlfQ9MQw/pPbrKbOiQS8IeR0ND2
         9d3Q==
X-Gm-Message-State: AOAM530EZ9iH2LSKUJbeNUrnTxrjl+QtKr5zcx3zqN/j3RqivvlHpStK
        XMx7tg42pBpFDgZct78cw40=
X-Google-Smtp-Source: ABdhPJySLCgHg2O0N9kHEoWK73OODmNNyCBtm9uw+Kg9Z78dmAbWqkZMBHYXffg6lRdhPokTHvD/6Q==
X-Received: by 2002:a05:600c:4285:: with SMTP id v5mr17132980wmc.189.1626774675704;
        Tue, 20 Jul 2021 02:51:15 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.204])
        by smtp.gmail.com with ESMTPSA id p9sm22297701wrx.59.2021.07.20.02.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 02:51:15 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
Subject: [PATCH 1/2] io_uring: explicitly count entries for poll reqs
Date:   Tue, 20 Jul 2021 10:50:43 +0100
Message-Id: <9d6b9e561f88bcc0163623b74a76c39f712151c3.1626774457.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1626774457.git.asml.silence@gmail.com>
References: <cover.1626774457.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If __io_queue_proc() fails to add a second poll entry, e.g. kmalloc()
failed, but it goes on with a third waitqueue, it may succeed and
overwrite the error status. Count the number of poll entries we added,
so we can set pt->error to zero at the beginning and find out when the
mentioned scenario happens.

Cc: stable@vger.kernel.org
Fixes: 18bceab101add ("io_uring: allow POLL_ADD with double poll_wait() users")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0cac361bf6b8..6668902cf50c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4802,6 +4802,7 @@ IO_NETOP_FN(recv);
 struct io_poll_table {
 	struct poll_table_struct pt;
 	struct io_kiocb *req;
+	int nr_entries;
 	int error;
 };
 
@@ -4995,11 +4996,11 @@ static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
 	struct io_kiocb *req = pt->req;
 
 	/*
-	 * If poll->head is already set, it's because the file being polled
-	 * uses multiple waitqueues for poll handling (eg one for read, one
-	 * for write). Setup a separate io_poll_iocb if this happens.
+	 * The file being polled uses multiple waitqueues for poll handling
+	 * (e.g. one for read, one for write). Setup a separate io_poll_iocb
+	 * if this happens.
 	 */
-	if (unlikely(poll->head)) {
+	if (unlikely(pt->nr_entries)) {
 		struct io_poll_iocb *poll_one = poll;
 
 		/* already have a 2nd entry, fail a third attempt */
@@ -5027,7 +5028,7 @@ static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
 		*poll_ptr = poll;
 	}
 
-	pt->error = 0;
+	pt->nr_entries++;
 	poll->head = head;
 
 	if (poll->events & EPOLLEXCLUSIVE)
@@ -5104,9 +5105,12 @@ static __poll_t __io_arm_poll_handler(struct io_kiocb *req,
 
 	ipt->pt._key = mask;
 	ipt->req = req;
-	ipt->error = -EINVAL;
+	ipt->error = 0;
+	ipt->nr_entries = 0;
 
 	mask = vfs_poll(req->file, &ipt->pt) & poll->events;
+	if (unlikely(!ipt->nr_entries) && !ipt->error)
+		ipt->error = -EINVAL;
 
 	spin_lock_irq(&ctx->completion_lock);
 	if (likely(poll->head)) {
-- 
2.32.0

