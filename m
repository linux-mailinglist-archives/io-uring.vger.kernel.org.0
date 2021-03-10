Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04589334BCE
	for <lists+io-uring@lfdr.de>; Wed, 10 Mar 2021 23:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233821AbhCJWom (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Mar 2021 17:44:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232181AbhCJWoR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Mar 2021 17:44:17 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78EEDC061761
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:17 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id y67so13201515pfb.2
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kFMDwdAN2QPboW/i5VGwRvXqcdIPT6EINkWCR3y/CjY=;
        b=d5LNCJh8S4u52OLhbURxgZhlDvSsRHwcIu6seHKSFDg176AK0ESBmMqz+R56eSB0kh
         ULAza0D+RaFctoukIoROJZoxKs86/CrmvtdSFDzsa/DP/Eqd3IC+97Cnf+olQFIB8zqm
         +IIdboMscte7tkuBbLruRKbXl5hqZVycjGYVXQikFDZgHemhfxk219buSPSfGGITVVc0
         MYmY325D6rrr9ZaSs8czoGntchMJP3YtjCYLb0o1SpRKyWySLIaAlXw7+xG2aQu+4skH
         TkimA/6pgCAvqEfGQAptVRna/XUmHOQzauaFj68k/8KStvk+NrntTsqYOt8M7zysdQPu
         vNOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kFMDwdAN2QPboW/i5VGwRvXqcdIPT6EINkWCR3y/CjY=;
        b=UnKjkRjTRqcVNJDgCvFEquwPAxGRgZD4Rw5YQsmSV0UFu3hqajK5ELYQyCCL2eK5GZ
         cRc0OrLmvRSajvWM3k5H+BtN4GWNWHT3ljlEfrfRR/OzncegirdZzoh4q5v3oHUaigqJ
         1eGFQbouUDucsl3CP6KVRy8w3lFq/qrQZvHCgsudbIboSnq9ZUYsynZOMX4Z1bjazIvd
         xGvTM5+/NgImZAycH5dBtpeczUG8aMyOKKKnuRSpv2hhWiSmblIipBvm3xpy7jO3CGJH
         nYi3owS95cQrQwgLIeYwZHKriug2AP5ODbZOQSxIWEJyhM5luDqAwKRoSTSg/OFxh4xp
         mHaQ==
X-Gm-Message-State: AOAM533w6XkXNegDIYo1zJDXQbwLrsGy7GKRE8qVs6rT6xuNvzPPoNmt
        cTFPMh/gnq9k7R1i7Ipd/RdmFgWRaYJBzg==
X-Google-Smtp-Source: ABdhPJyVnHqEDOHj2UR3gNAfBDDc+rthWO7PU3vpk+0RETPrIUeaZYcf88XgZP2IXzfsszAHgUlUUQ==
X-Received: by 2002:aa7:96ab:0:b029:1f6:2d3:3c91 with SMTP id g11-20020aa796ab0000b02901f602d33c91mr5174403pfk.10.1615416256793;
        Wed, 10 Mar 2021 14:44:16 -0800 (PST)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id j23sm475783pfn.94.2021.03.10.14.44.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 14:44:16 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 12/27] io_uring: kill io_sq_thread_fork() and return -EOWNERDEAD if the sq_thread is gone
Date:   Wed, 10 Mar 2021 15:43:43 -0700
Message-Id: <20210310224358.1494503-13-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310224358.1494503-1-axboe@kernel.dk>
References: <20210310224358.1494503-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Stefan Metzmacher <metze@samba.org>

This brings the behavior back in line with what 5.11 and earlier did,
and this is no longer needed with the improved handling of creds
not needing to do unshare().

Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 31 +++----------------------------
 1 file changed, 3 insertions(+), 28 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4d3333ca27a3..7cf96be691d8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -336,7 +336,6 @@ struct io_ring_ctx {
 		unsigned int		drain_next: 1;
 		unsigned int		eventfd_async: 1;
 		unsigned int		restricted: 1;
-		unsigned int		sqo_exec: 1;
 
 		/*
 		 * Ring buffer of indices into array of io_uring_sqe, which is
@@ -6786,7 +6785,6 @@ static int io_sq_thread(void *data)
 
 	sqd->thread = NULL;
 	list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
-		ctx->sqo_exec = 1;
 		io_ring_set_wakeup_flag(ctx);
 	}
 
@@ -7846,26 +7844,6 @@ void __io_uring_free(struct task_struct *tsk)
 	tsk->io_uring = NULL;
 }
 
-static int io_sq_thread_fork(struct io_sq_data *sqd, struct io_ring_ctx *ctx)
-{
-	struct task_struct *tsk;
-	int ret;
-
-	clear_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
-	reinit_completion(&sqd->parked);
-	ctx->sqo_exec = 0;
-	sqd->task_pid = current->pid;
-	tsk = create_io_thread(io_sq_thread, sqd, NUMA_NO_NODE);
-	if (IS_ERR(tsk))
-		return PTR_ERR(tsk);
-	ret = io_uring_alloc_task_context(tsk, ctx);
-	if (ret)
-		set_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
-	sqd->thread = tsk;
-	wake_up_new_task(tsk);
-	return ret;
-}
-
 static int io_sq_offload_create(struct io_ring_ctx *ctx,
 				struct io_uring_params *p)
 {
@@ -9199,13 +9177,10 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		io_cqring_overflow_flush(ctx, false, NULL, NULL);
 
-		if (unlikely(ctx->sqo_exec)) {
-			ret = io_sq_thread_fork(ctx->sq_data, ctx);
-			if (ret)
-				goto out;
-			ctx->sqo_exec = 0;
-		}
 		ret = -EOWNERDEAD;
+		if (unlikely(ctx->sq_data->thread == NULL)) {
+			goto out;
+		}
 		if (flags & IORING_ENTER_SQ_WAKEUP)
 			wake_up(&ctx->sq_data->wait);
 		if (flags & IORING_ENTER_SQ_WAIT) {
-- 
2.30.2

