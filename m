Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEBA820C0EE
	for <lists+io-uring@lfdr.de>; Sat, 27 Jun 2020 13:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgF0LGq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 27 Jun 2020 07:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726429AbgF0LGp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 27 Jun 2020 07:06:45 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51FAEC03E979
        for <io-uring@vger.kernel.org>; Sat, 27 Jun 2020 04:06:45 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id q15so11055415wmj.2
        for <io-uring@vger.kernel.org>; Sat, 27 Jun 2020 04:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=oryJBGx0GBXeU2Bdl7V8PTu3R4O3WT8rT5+Dojxubgc=;
        b=Zrs+EMhNqM4eJ50RchKl9JGiovA687i4eMOXyBOJWq1rdT47w9j0UwllxY2Mimz5Gw
         bBA8NtQr71uC58jLL2lkmkLHIOcuGbNG9iKdZyZ949QjM3KeBK2c540Cdq57US2LZyA2
         A8sgXMrIlO7RY/bdvqOLKpr7MBBLh6WNF3o+kAdt+AV/JbJoYJumL7qIXI1oVZmtTBer
         7MLB6ocKtv9u2zmRz/5sZdCECjnOrESpa6bI7Ig+QUEHR8wvSpuRJb7Bj5Cdyb0opQaV
         uqaf+IGt5/DYVf9azBLGEZ3UH+fdQawj2hOeWI9vRXff7nEkpDR0BBN3F0RfN2RfMXIN
         53WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oryJBGx0GBXeU2Bdl7V8PTu3R4O3WT8rT5+Dojxubgc=;
        b=g3pE9pXRaqxSyDkbTQjMo0qegIysZbiHMup9+v0bF0RF/W9nH3IImZcmhqI0LQcjOK
         q7/TnIamUJG47LKBGuCRhloiQJhl2G1TtT6u8yNT0/qMY54mpf6sVo4E1rJh0/HHI1D2
         STP5lPJuV99i3NX2X9nuMoHQaDuYJNkTCOOoCKoY6S9pFGPpUkmXSWPXE/SRsSNhviaq
         kGQe67/7F7jrYxyz25wj3/v2YPK34gcjQz9I0wqdbpG5XL1Fl74paKsgpNAmg0wrHBWd
         MGY9OZ/8BjmDnVqMVOd7sjJDaibJA6RfQCGKKgrJKwA5gSpeAsQr75JeQdqLEao6v93E
         fpsg==
X-Gm-Message-State: AOAM530AcHRcVAjlsR01GIGsZiz3SLLj842gZhbRqzTkbT06g+gyp+dG
        bVVVMCZXdAvw10O2gng9qmpjjgKv
X-Google-Smtp-Source: ABdhPJxCuFBX+IKcXhcgtEqLm1C+XRAqGDNfqZa2oNSTEbrXwFqWjaA6jyzYDtINxLGuM3pC47x6pg==
X-Received: by 2002:a05:600c:2907:: with SMTP id i7mr5031535wmd.40.1593256004075;
        Sat, 27 Jun 2020 04:06:44 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id x1sm14706721wrp.10.2020.06.27.04.06.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Jun 2020 04:06:43 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/5] io_uring: fix feeding io-wq with uninit reqs
Date:   Sat, 27 Jun 2020 14:04:56 +0300
Message-Id: <8ba05db0dc37f05c64ad5814ddeaed4a462c3ae5.1593253742.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1593253742.git.asml.silence@gmail.com>
References: <cover.1593253742.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_steal_work() can't be sure that @nxt have req->work
properly set, so we can't pass it to io-wq as is.

A dirty quick fix -- drag it through io_req_task_queue(),
and always return NULL from io_steal_work().

e.g.
[   50.770161] BUG: kernel NULL pointer dereference, address: 00000000
[   50.770164] #PF: supervisor write access in kernel mode
[   50.770164] #PF: error_code(0x0002) - not-present page
[   50.770168] CPU: 1 PID: 1448 Comm: io_wqe_worker-0 Tainted: G
	I       5.8.0-rc2-00035-g2237d76530eb-dirty #494
[   50.770172] RIP: 0010:override_creds+0x19/0x30
...
[   50.770183]  io_worker_handle_work+0x25c/0x430
[   50.770185]  io_wqe_worker+0x2a0/0x350
[   50.770190]  kthread+0x136/0x180
[   50.770194]  ret_from_fork+0x22/0x30

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e10aeae8cc52..b577d6f50cbc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1791,7 +1791,7 @@ static void io_put_req(struct io_kiocb *req)
 
 static struct io_wq_work *io_steal_work(struct io_kiocb *req)
 {
-	struct io_kiocb *link, *nxt = NULL;
+	struct io_kiocb *nxt = NULL;
 
 	/*
 	 * A ref is owned by io-wq in which context we're. So, if that's the
@@ -1808,10 +1808,15 @@ static struct io_wq_work *io_steal_work(struct io_kiocb *req)
 	if ((nxt->flags & REQ_F_ISREG) && io_op_defs[nxt->opcode].hash_reg_file)
 		io_wq_hash_work(&nxt->work, file_inode(nxt->file));
 
-	link = io_prep_linked_timeout(nxt);
-	if (link)
-		nxt->flags |= REQ_F_QUEUE_TIMEOUT;
-	return &nxt->work;
+	io_req_task_queue(nxt);
+	/*
+	 * If we're going to return actual work, here should be timeout prep:
+	 *
+	 * link = io_prep_linked_timeout(nxt);
+	 * if (link)
+	 *	nxt->flags |= REQ_F_QUEUE_TIMEOUT;
+	 */
+	return NULL;
 }
 
 /*
-- 
2.24.0

