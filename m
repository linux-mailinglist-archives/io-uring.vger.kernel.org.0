Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9615A27AD41
	for <lists+io-uring@lfdr.de>; Mon, 28 Sep 2020 13:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726665AbgI1Lwm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 28 Sep 2020 07:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbgI1Lwm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 28 Sep 2020 07:52:42 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C643C061755
        for <io-uring@vger.kernel.org>; Mon, 28 Sep 2020 04:52:42 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id k15so951487wrn.10
        for <io-uring@vger.kernel.org>; Mon, 28 Sep 2020 04:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=xEfTFBtUCng+ZVuEikSNdrnaOA4mu6RUxHRTHMDrVa8=;
        b=CDEcZF9SL7JtsSb1EVy/x/sONu3bzzcs8fi1F/9rW5vJaN7ySJwKGx5SECOYE8/2Vh
         op8Wr3BW1i15MDQkJQ8NwuYQaOCl//nWQNFS0m5Rlxjl/zh/3ae/d0Z6JgGsjOUyPo52
         VaKsk1Vlbi1Dw/zcho0zd6BIRl/hUVAQ5RcA/XNyNIkTeC0D1Em/HT88IdmsPzISEmqM
         BFMaPTiyOLMO89gspUo+GpLrHvshF7WXCQ38f6QZTGJrmFBoChQoOLUifVa1Mjr3ctAB
         smGAVSSsg16CLaRGwdofRpDEeONPjNqZDpu4DTxNI6g8STZFSOLLjOqMBKLxZ6+rfqBO
         Jofw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xEfTFBtUCng+ZVuEikSNdrnaOA4mu6RUxHRTHMDrVa8=;
        b=GOjZ5jKwQjGbVEgWQZvLcbc/YEspeMWkzAEyMaZ3cnZ5gv3wIKq+oizyjY0lS7FQe2
         v8LxDeKAwmdE9yLnFQ27i043zyEe1mNGJRk7Ck9/faD13YOlUAuatUlDN14reYooWlmS
         IVLGEK8QIS028dD39ejCkk5kcqLfhl8Hxj1PemWaPN1r5hwPkvx1l0n1t9nJNIENI9I5
         n7G6yyPhoDJvSrj9mrX56CHElHr83h+ElFlo0I2hmIqEHFT6qU8UZ3J+X/uOsjBohUdf
         vpBCCmU3gnO7a7usLrd7MJ10HK3GO+ch7ZDMKVwOq8uxllm5qiiftsk93NymbFfO2Wsk
         JhTA==
X-Gm-Message-State: AOAM532y7sX89zuFfXjsnA9XD+cNnkHLKstVf+rjJG/jbWux8kNp+hvC
        G4ELI8pLKjslfGbCuNFXYAY=
X-Google-Smtp-Source: ABdhPJze8DTrLrJYTutAmLBavcWcO516SFT16RlVn0V1FB5SBLiBCWJnVMEqRVMUqUdANK4fp4SrVw==
X-Received: by 2002:a05:6000:1084:: with SMTP id y4mr1250736wrw.138.1601293961059;
        Mon, 28 Sep 2020 04:52:41 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-140.range109-152.btcentralplus.com. [109.152.100.140])
        by smtp.gmail.com with ESMTPSA id l4sm1275282wrc.14.2020.09.28.04.52.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 04:52:40 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/2] io_uring: fix unsynchronised removal of sq_data
Date:   Mon, 28 Sep 2020 14:49:50 +0300
Message-Id: <1647bc3920b40771429afb28a2b82d9c9cb1e6c6.1601293611.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1601293611.git.asml.silence@gmail.com>
References: <cover.1601293611.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Remove io_sq_thread_stop() from io_uring_flush() and just clear
->sqo_files, etc. instead. The first reason is that io_sq_thread_stop()
null's ctx->sq_data without any lock held, that's racy. Also, it kills
an SQPOLL thread even though there may be other processes wanting to
continue using the io_uring instance.

syzbot+b64c3e0ed576fc1d70e5@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6523500e4ae2..0ab0c3aefefd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8548,13 +8548,7 @@ static int io_uring_flush(struct file *file, void *data)
 {
 	struct io_ring_ctx *ctx = file->private_data;
 
-	/*
-	 * If the task is going away, cancel work it may have pending
-	 */
-	if (fatal_signal_pending(current) || (current->flags & PF_EXITING)) {
-		io_sq_thread_stop(ctx);
-		io_wq_cancel_cb(ctx->io_wq, io_cancel_task_cb, current, true);
-	} else if (ctx->flags & IORING_SETUP_SQPOLL) {
+	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		struct io_sq_data *sqd = ctx->sq_data;
 
 		/* Ring is being closed, mark us as neding new assignment */
@@ -8568,6 +8562,12 @@ static int io_uring_flush(struct file *file, void *data)
 		io_sq_thread_unpark(sqd);
 	}
 
+	/*
+	 * If the task is going away, cancel work it may have pending
+	 */
+	if (fatal_signal_pending(current) || (current->flags & PF_EXITING))
+		io_wq_cancel_cb(ctx->io_wq, io_cancel_task_cb, current, true);
+
 	io_uring_cancel_files(ctx, data);
 
 	return 0;
-- 
2.24.0

