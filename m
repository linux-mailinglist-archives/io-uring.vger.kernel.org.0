Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6D724A748
	for <lists+io-uring@lfdr.de>; Wed, 19 Aug 2020 21:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726585AbgHSTzK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Aug 2020 15:55:10 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:41748 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgHSTzJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Aug 2020 15:55:09 -0400
Date:   Wed, 19 Aug 2020 21:55:05 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1597866906;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=C4NNWA82EI8P7mru9ssnkkajzDSatM3aJrVOrBR9Tec=;
        b=XGrDin6F5FqU0ypUu076RQTf75Bbusz1vTSKqVCyy2GHlPEpLiJ8OSu23rrAuqfju35V5I
        11oyx5SfzT2mBWD5q6ZfB75/NeAkbpCHoUd+j4ty1x1XHvCTflRCSdJetlQzH+9FMYpxa5
        ItvWjZjjKClIvqHr1Dz5L/jwUfLXRyJc65Dv1yRVDrESW+y8Q8YyNQQ7nfYbOdDNzaGf9s
        bEjHOxxUzX0Glr9VRzk2iz0YretZKsnTO/ymV1QmrEgDWyyA87w7/hUpTRM0vz7u1rxvPz
        U+XODZXLsXnqdA0gAhAG2LZUCS/J7h9KUMw1vOTwKfiWTxaeXXEnqRdU8EMToA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1597866906;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=C4NNWA82EI8P7mru9ssnkkajzDSatM3aJrVOrBR9Tec=;
        b=eW50GFG1rD+iv7oNdxZ6PdVWaPlxFpFp7lCTV10OIkFB28ADzojsaHgKwN33FRBR4rQjGf
        0v0+HrfXxvtMbYBw==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     peterz@infradead.org
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Jens Axboe <axboe@kernel.dk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 1/2] sched: Bring the PF_IO_WORKER and PF_WQ_WORKER bits
 closer together
Message-ID: <20200819195505.y3fxk72sotnrkczi@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200819142134.GD2674@hirez.programming.kicks-ass.net>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The bits PF_IO_WORKER and PF_WQ_WORKER are tested together in
sched_submit_work() which is considered to be a hot path.
If the two bits cross the 8 or 16 bit boundary then most architecture
require multiple load instructions in order to create the constant
value. Also, such a value can not be encoded within the compare opcode.

By moving the bit definition within the same block, the compiler can
create/use one immediate value.

For some reason gcc-10 on ARM64 requires both bits to be next to each
other in order to issue "tst reg, val; bne label". Otherwise the result
is "mov reg1, val; tst reg, reg1; bne label".

Move PF_VCPU out of the way so that PF_IO_WORKER can be next to
PF_WQ_WORKER.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---

Could someone from the ARM64 camp please verify if this a gcc "bug" or
opcode/arch limitation? With PF_IO_WORKER as 1 (without the PF_VCPU
swap) I get for ARM:

| tst     r2, #33 @ task_flags,
| beq     .L998           @,

however ARM64 does here:
| mov     w0, 33  // tmp117,
| tst     w19, w0 // task_flags, tmp117
| bne     .L453           //,

the extra mov operation. Moving PF_IO_WORKER next to PF_WQ_WORKER as
this patch gives me:
| tst     w19, 48 // task_flags,
| bne     .L453           //,


 include/linux/sched.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 93ecd930efd31..2bf0af19a62a4 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1489,9 +1489,10 @@ extern struct pid *cad_pid;
 /*
  * Per process flags
  */
+#define PF_VCPU			0x00000001	/* I'm a virtual CPU */
 #define PF_IDLE			0x00000002	/* I am an IDLE thread */
 #define PF_EXITING		0x00000004	/* Getting shut down */
-#define PF_VCPU			0x00000010	/* I'm a virtual CPU */
+#define PF_IO_WORKER		0x00000010	/* Task is an IO worker */
 #define PF_WQ_WORKER		0x00000020	/* I'm a workqueue worker */
 #define PF_FORKNOEXEC		0x00000040	/* Forked but didn't exec */
 #define PF_MCE_PROCESS		0x00000080      /* Process policy on mce errors */
@@ -1515,7 +1516,6 @@ extern struct pid *cad_pid;
 #define PF_NO_SETAFFINITY	0x04000000	/* Userland is not allowed to meddle with cpus_mask */
 #define PF_MCE_EARLY		0x08000000      /* Early kill for mce process policy */
 #define PF_MEMALLOC_NOCMA	0x10000000	/* All allocation request will have _GFP_MOVABLE cleared */
-#define PF_IO_WORKER		0x20000000	/* Task is an IO worker */
 #define PF_FREEZER_SKIP		0x40000000	/* Freezer should not count it as freezable */
 #define PF_SUSPEND_TASK		0x80000000      /* This thread called freeze_processes() and should not be frozen */
 
-- 
2.28.0

