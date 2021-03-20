Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27657342941
	for <lists+io-uring@lfdr.de>; Sat, 20 Mar 2021 01:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbhCTABH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Mar 2021 20:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbhCTAAu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Mar 2021 20:00:50 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 120F2C061760
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 17:00:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=ARfahUekmCAeNsaSsPIN2TOi6Hk7jzfXlvU3FcTsqTw=; b=G66prjLhPWhUNo4kznz/M3AeYp
        W4JDn/wkRLjAJ+Oc3ORkHyOAzztKPJFXkJtyl3lEyV3ru67W7dqXyTSaVQRCNLRoPo9TRJH3njSSf
        DZhfoYAt7lULg8tiBBOJrHgwEJfZ1YF6Ny9zS2lQte7AdvuYym+HjFLm8brkGryoY8sg8VK4yIpYZ
        cms10b13AMpYRqPH4I2hJIb2gXrcu6xOCP4Io0CczLtCN/yWf/4cPr80o+TWBzoReG5dmQgcw2yee
        K02sDdweANEDzetJkMtTQK38CK/aJTxUMgmnkv60xySS4idviK3FRIans+RRHy/V17khZy2pdmbO4
        T+E2I7wRfrkVuL1chOXQKbMpCRuwFK5GGeIxEXywhXPjOj6LgJ0M025eRwdXUHMQg4EDZ8PDRJ/eg
        b2Q0N4G9g3R2TQThpBOYDSMLjyEplawPkQdE7SDhGYOaLz036hjNUCt7SShyK39qhm5TtXeSUOV6P
        D0EEoakZ3Vt66EIiHIVeDt5P;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lNP2t-0007WS-SF; Sat, 20 Mar 2021 00:00:47 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2 1/5] kernel: always initialize task->pf_io_worker to NULL
Date:   Sat, 20 Mar 2021 01:00:27 +0100
Message-Id: <438b738c1e4827a7fdfe43087da88bbe17eedc72.1616197787.git.metze@samba.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1616197787.git.metze@samba.org>
References: <cover.1615826736.git.metze@samba.org> <cover.1616197787.git.metze@samba.org>
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

