Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB9EA358A06
	for <lists+io-uring@lfdr.de>; Thu,  8 Apr 2021 18:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232382AbhDHQrH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Apr 2021 12:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232381AbhDHQrH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Apr 2021 12:47:07 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7658C061760;
        Thu,  8 Apr 2021 09:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Type:MIME-Version:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=Gq/rdyGTyQ0u+Ooonn/Pvwu5OLrn0QqmtopJqPVCiv8=; b=d9fxvosm0WowzxDsYdm1j+w9zp
        i44NxxJXj+1FRM2OhLp3rHqJbY67o1Z5V3di2LW19ZEgvJfzCYYdVMbzNgqNkwPs/QLzC3N4FGJNz
        PM/YDLES2vs3oIto0SSdfvvDdB/r5gfmS9qqCERY7BATxqVDegCPGr0AkzmsUuSem4JdWeOwIBCI+
        DB1b9VHqLQCwzdD3Oy7JAUdjLD7jcps48ZUdv/t2515ENxgdE87WHDWyv0jz2U7A+XkCbd+DTzQXr
        WzLLuxF7H1+oQYhtMTxbw++Ycs3PtTCenYa10Sbudx4Faq3gAEAB2oMFO8Wa3E2j5WGrn+/N6YxaN
        iFgw0xtw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lUXnx-008g4r-2r; Thu, 08 Apr 2021 16:46:53 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 5C22E3001D0;
        Thu,  8 Apr 2021 18:46:30 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 2624C2BE57BB8; Thu,  8 Apr 2021 11:44:50 +0200 (CEST)
Date:   Thu, 8 Apr 2021 11:44:50 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] io-wq: Fix io_wq_worker_affinity()
Message-ID: <YG7QkiUzlEbW85TU@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Do not include private headers and do not frob in internals.

On top of that, while the previous code restores the affinity, it
doesn't ensure the task actually moves there if it was running,
leading to the fun situation that it can be observed running outside
of its allowed mask for potentially significant time.

Use the proper API instead.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 fs/io-wq.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -17,7 +17,6 @@
 #include <linux/cpu.h>
 #include <linux/tracehook.h>
 
-#include "../kernel/sched/sched.h"
 #include "io-wq.h"
 
 #define WORKER_IDLE_TIMEOUT	(5 * HZ)
@@ -1098,14 +1097,8 @@ void io_wq_put_and_exit(struct io_wq *wq
 
 static bool io_wq_worker_affinity(struct io_worker *worker, void *data)
 {
-	struct task_struct *task = worker->task;
-	struct rq_flags rf;
-	struct rq *rq;
-
-	rq = task_rq_lock(task, &rf);
-	do_set_cpus_allowed(task, cpumask_of_node(worker->wqe->node));
-	task->flags |= PF_NO_SETAFFINITY;
-	task_rq_unlock(rq, task, &rf);
+	set_cpus_allowed_ptr(worker->task, cpumask_of_node(worker->wqe->node));
+
 	return false;
 }
 
