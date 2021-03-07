Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D27533002F
	for <lists+io-uring@lfdr.de>; Sun,  7 Mar 2021 11:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbhCGKzg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 7 Mar 2021 05:55:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231558AbhCGKza (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 7 Mar 2021 05:55:30 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB562C06175F
        for <io-uring@vger.kernel.org>; Sun,  7 Mar 2021 02:55:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=Q1YuyqZQYy0iTuYqkShRErpF5SjoIGIKQ7OuVCR5m6c=; b=DIXHPQRJ2MWaigfckfL0mmBgR7
        TsQvVpmPMIibzRaqSb5tSx9M6Ee1IwB5nVXp5wPVomOgQ4qHAphLAdKMLDSvsV+w06TM/tGoBZUvP
        yiMOv5wvGqKTZbh5yeK5qVNrYzBAADKRJZnZE0onEIq5WQ3pX+JZSsDcKrPazdnh7L8rFOkEiXEdD
        /CjHAURWyi+pIjRnpqMV0ZrikqQLQRzNaqexgwWXPFM6s8G2lJBu4lTgPy5nRKkZDsPC3t6wdP3Jq
        689HpAgkAz/eqRcfSIkjif9v0FM6Ss8OdeUE8pec1EIM0YC3KQD7sSslQ3S9xLuG1fcxGl2uBfbqW
        ynOKywmboFFvF3igC6X5UbtrczqQCd4piWNH8dgWiwAxpW7HBJ6Acx1cj+rjQ/x5Zx7CM1W1wtbAJ
        6q43gk2EFdsHawh47ddSEj+QkDLxfvQugFggJDA0MJzmvZTM9AzJ17+G7s85NKHtfqEJu50yV27HX
        WKnNwvjwSmUDbCK82/HSzc8L;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lIr48-0000O0-1P; Sun, 07 Mar 2021 10:55:16 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH 2/2] io_uring: kill io_sq_thread_fork() and return -EOWNERDEAD if the sq_thread is gone
Date:   Sun,  7 Mar 2021 11:54:29 +0100
Message-Id: <20210307105429.3565442-3-metze@samba.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210307105429.3565442-1-metze@samba.org>
References: <20210307105429.3565442-1-metze@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/io_uring.c | 31 +++----------------------------
 1 file changed, 3 insertions(+), 28 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 133b52a9a768..6487f9b2c3a7 100644
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
 
@@ -7844,26 +7842,6 @@ void __io_uring_free(struct task_struct *tsk)
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
@@ -9197,13 +9175,10 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
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
2.25.1

