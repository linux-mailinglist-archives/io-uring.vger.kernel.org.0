Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C680833C33A
	for <lists+io-uring@lfdr.de>; Mon, 15 Mar 2021 18:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233598AbhCORDF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Mar 2021 13:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235552AbhCORCJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Mar 2021 13:02:09 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F094C06174A
        for <io-uring@vger.kernel.org>; Mon, 15 Mar 2021 10:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=ARfahUekmCAeNsaSsPIN2TOi6Hk7jzfXlvU3FcTsqTw=; b=b96xRJnCC2APEZ+LqyXHWD5SrG
        tg9HhEy7Kem/bqBw2QLnv3XCOPmArxAiNqyrGw0VMDI4rnjYZzzcGYYaIx7qEIrruRdAcbIhMrCDa
        ETmTtynQTxNvixWEcZu0wPimtGveWDX+wpD0r+DE+TsjzoEZNBxYBPSDOe9tgc5Sy0YOcI7LBKzi4
        m7sqM3ujfy+e9FkXpa0cG/baTPYD9S+lXBnIPFGRSUF1ng4gIRtSaC2UziKtmC0G31lYdB75TZTL7
        9w6YdyVCxX6GEdFKHFdjeBQClbUrsf5gzfZmn3xpTNy9WgMcOTSO5kQcwkIBxuarXLNRxNyRoP9C4
        FPj9DhIxS6XQ9nr2jsGhys5V3Lw6qodEV7wk+CsgPM4+Q3UFQLuDKhBDRMS6P7XDKb/w9bE4r+Bo6
        Nl6q1BTmDESeJWg/yldb5JP0NPi2eaen2eiT4YAE5TpFULu/EhFGsejJ8xI5zqMVpHfGflVfalj0g
        zqYnEXCBApj4n8vRvzxRoFAH;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lLqbW-00056c-P0; Mon, 15 Mar 2021 17:02:06 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>, Jens Axboe <axboe@kernel.dk>
Subject: [RFC PATCH 01/10] kernel: always initialize task->pf_io_worker to NULL
Date:   Mon, 15 Mar 2021 18:01:39 +0100
Message-Id: <660dcc31edd73d78c38608bfd98eb2a3e5287f38.1615826736.git.metze@samba.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1615826736.git.metze@samba.org>
References: <cover.1615826736.git.metze@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Otherwise io_wq_worker_{running,sleeping}() may dereference an
invalid pointer (in future). Currently all users of create_io_thread()
are fine and get task->pf_io_worker = NULL implicitly from the
wq_manager, which got it either from the userspace thread
of the sq_thread, which explicitly reset it to NULL.

I think it's safer to always reset it in order to avoid future
problems.

Fixes: 3bfe6106693b ("io-wq: fork worker threads from original task")
cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 kernel/fork.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/fork.c b/kernel/fork.c
index d3171e8e88e5..0b7068c55552 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -927,6 +927,7 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
 	tsk->splice_pipe = NULL;
 	tsk->task_frag.page = NULL;
 	tsk->wake_q.next = NULL;
+	tsk->pf_io_worker = NULL;
 
 	account_kernel_stack(tsk, 1);
 
-- 
2.25.1

