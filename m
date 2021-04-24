Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2516B36A394
	for <lists+io-uring@lfdr.de>; Sun, 25 Apr 2021 01:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbhDXX1T (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 24 Apr 2021 19:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbhDXX1S (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 24 Apr 2021 19:27:18 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D24CFC061574
        for <io-uring@vger.kernel.org>; Sat, 24 Apr 2021 16:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=4kjcA47Fen3EsGKPal3bxcwWV/ZU/R6V1kTvJ6dCdcc=; b=IEUKV85qtlNgxDJsc6Nq7G3k71
        Y6bz5Dj1n4fGPcinJL7dMe05Iynz/cRZwIseN5VUjvioakXpGWiNhLlNxhVE3hl6G3dW1Iy8fZvsD
        mwF4rx6utqnlctKyvG9c7xMEF9vKjNQIs8z9a9wNw1baT9VTFzAWdfE2fYUpHsbAwm0RxvN0RaW6I
        8FjJfcA0SIK+9WcHILjg2TtxLdNVjsG/6I+1CI9YVa783wSGMxkgApJpG798XVNCAD8SoLtfy9is5
        TXy2oIykichiVtgf+sD+cJPQYPuXtJgEYvjKw8XznqsjtS5oNbsuC7yRUE9VtKEMVIlf1PyYF3mtp
        XGvrIXH1HXlDH3KfPhd8neKrEHsET6izJDeJHatlWsQouFEpl2jb7lLBU+vFHrsuGEhUBDmLnFo7y
        SDf1mICNpQMIq3VyFBgeoJ1TCSmFQ9qh5nhFdE/xG7kdee6DD+xr95XweU0PwqPhlwl8tTXhHPqYS
        r5Ef68IkUR/EUTv38Kdy/5St;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1laRfX-0007W2-0c; Sat, 24 Apr 2021 23:26:35 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v3 1/6] kernel: always initialize task->pf_io_worker to NULL
Date:   Sun, 25 Apr 2021 01:26:03 +0200
Message-Id: <9ac733469378af9c154b2eb496f71a7d5e4182ef.1619306115.git.metze@samba.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1619306115.git.metze@samba.org>
References: <cover.1619306115.git.metze@samba.org>
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
index b81ccb1ca3a7..224c8317df34 100644
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

