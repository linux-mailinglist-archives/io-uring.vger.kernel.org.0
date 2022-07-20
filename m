Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6301257BBE9
	for <lists+io-uring@lfdr.de>; Wed, 20 Jul 2022 18:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbiGTQvA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Jul 2022 12:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232124AbiGTQu6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Jul 2022 12:50:58 -0400
Received: from out02.mta.xmission.com (out02.mta.xmission.com [166.70.13.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70BE643E42;
        Wed, 20 Jul 2022 09:50:57 -0700 (PDT)
Received: from in01.mta.xmission.com ([166.70.13.51]:57260)
        by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oECuW-00AUU7-8M; Wed, 20 Jul 2022 10:50:56 -0600
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:40120 helo=email.froward.int.ebiederm.org.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oECuU-008sgE-SV; Wed, 20 Jul 2022 10:50:55 -0600
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Olivier Langlois <olivier@trillion01.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <192c9697e379bf084636a8213108be6c3b948d0b.camel@trillion01.com>
        <9692dbb420eef43a9775f425cb8f6f33c9ba2db9.camel@trillion01.com>
        <87h7i694ij.fsf_-_@disp2133>
        <1b519092-2ebf-3800-306d-c354c24a9ad1@gmail.com>
        <b3e43e07c68696b83a5bf25664a3fa912ba747e2.camel@trillion01.com>
        <13250a8d-1a59-4b7b-92e4-1231d73cbdda@gmail.com>
        <878rw9u6fb.fsf@email.froward.int.ebiederm.org>
        <303f7772-eb31-5beb-2bd0-4278566591b0@gmail.com>
        <87ilsg13yz.fsf@email.froward.int.ebiederm.org>
        <8218f1a245d054c940e25142fd00a5f17238d078.camel@trillion01.com>
        <a29a1649-5e50-4221-9f44-66a35fbdff80@kernel.dk>
        <87y1wnrap0.fsf_-_@email.froward.int.ebiederm.org>
Date:   Wed, 20 Jul 2022 11:50:48 -0500
In-Reply-To: <87y1wnrap0.fsf_-_@email.froward.int.ebiederm.org> (Eric
        W. Biederman's message of "Wed, 20 Jul 2022 11:49:31 -0500")
Message-ID: <87sfmvramv.fsf_-_@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1oECuU-008sgE-SV;;;mid=<87sfmvramv.fsf_-_@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX195BT+dt24hxqlE4/lWaMT0/oqgF0ENkLw=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;Jens Axboe <axboe@kernel.dk>
X-Spam-Relay-Country: 
X-Spam-Timing: total 801 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 11 (1.4%), b_tie_ro: 10 (1.2%), parse: 1.32
        (0.2%), extract_message_metadata: 15 (1.9%), get_uri_detail_list: 4.6
        (0.6%), tests_pri_-1000: 14 (1.7%), tests_pri_-950: 1.24 (0.2%),
        tests_pri_-900: 0.99 (0.1%), tests_pri_-90: 147 (18.3%), check_bayes:
        145 (18.1%), b_tokenize: 19 (2.4%), b_tok_get_all: 66 (8.3%),
        b_comp_prob: 4.3 (0.5%), b_tok_touch_all: 51 (6.3%), b_finish: 1.06
        (0.1%), tests_pri_0: 598 (74.6%), check_dkim_signature: 0.66 (0.1%),
        check_dkim_adsp: 3.0 (0.4%), poll_dns_idle: 1.20 (0.1%), tests_pri_10:
        2.3 (0.3%), tests_pri_500: 7 (0.9%), rewrite_mail: 0.00 (0.0%)
Subject: [PATCH 1/2] signal: Move stopping for the coredump from do_exit
 into get_signal
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Stopping to participate in a coredump from a kernel oops makes no
sense and is actively dangerous because the kernel is known to be
broken.  Considering to stop in a coredump from a kernel thread exit
is silly because userspace coredumps are not generated from kernel
threads.  Not stopping for a coredump in exit(2) and exit_group(2) and
related userspace exits that call do_exit or do_group_exit directly is
the current behavior of the code as the PF_SIGNALED test in
coredump_task_exit attests.

Since only tasks that pass through get_signal and set PF_SIGNALED can
join coredumps move stopping for coredumps into get_signal, where the
PF_SIGNALED test is unnecessary.  This avoids even the potential of
stopping for coredumps in the silly or dangerous places.

This can be seen to be safe by examining the few places that call do_exit:

- get_signal calling do_group_exit
  Called by get_signal to terminate the userspace process.  As stopping
  for the coredump happens now happens in get_signal the code will
  continue to participate in the coredump.

- exit_group(2) calling do_group_exit

  If a thread calls exit_group(2) while another thread in the same process
  is performing a coredump there is a race.  The thread that wins the
  race will take the lock and set SIGNAL_GROUP_EXIT.  If it is the
  thread that called do_group_exit then zap_threads will return -EAGAIN
  and no coredump will be generated.  If it is the thread that is
  coredumping that wins the race, the task that called do_group_exit
  will exit gracefully with an error code before the coredump begins.

  Having a single thread exit just before the coredump starts is not
  ideal as the semantics make no sense. (Did the group exit happen
  before the coredump or did the coredump happen before the group
  exit?).

  Eventually I intend for group exits to flow through get_signal and
  this silliness will no longer be possible.  Until then the current
  behavior when this race occurs is maintained.

- io_uring
  Called after get_signal returns to terminate the I/O worker thread
  (essentially a userspace thread that only runs kernel code) so that
  additional cleanup code can be run before do_exit.  As get_signal is
  called the prior to do_exit code will continue to participate in the
  coredump.

- make_task_dead
  Called on an unhandled kernel or hardware failure.  As the failure
  is unhandled any extra work has the potential to make the failure worse
  so being part of a coredump is not appropriate.

- kthread_exit
  Called to terminate a kernel thread as such coredumps do not exist.

- call_usermodehelper_exec_async
  Called to terminate a kernel thread if kerenel_execve fails, as it is a
  kernel thread coredumps do not exist.

- reboot, seeccomp
  For these calls of do_exit() they are semantically direct calls of
  exit(2) today.  As do_exit() does not synchronize with siglock there
  is no logical race between a coredump killing the thread and these
  threads exiting.  These threads logically exit before the coredump
  happens.  This is also the current behavior so there is nothing to
  be concerned about with respect to userspsace semantics or
  regresssions.

Moving the coredump stop for userspace threads that did not dequeue
the coredumping signal from from do_exit into get_signal in general is
safe, because the coredump in the single threaded case completely
happens in get_signal.  The code movement ensures that a
multi-threaded coredump will not have any issues because the
additional threads stop after some amount of cleanup has been done.

The coredump code is robust to all kinds of userspace changes
happening in parallel as multiple processes can share a mm.  This
makes the it safe to perform the coredump before the io_uring cleanup
happens as io_uring can't do anything another process sharing the mm
would not be doing.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/coredump.c            | 25 ++++++++++++++++++++++++-
 include/linux/coredump.h |  2 ++
 kernel/exit.c            | 29 +++++------------------------
 kernel/signal.c          |  5 +++++
 mm/oom_kill.c            |  2 +-
 5 files changed, 37 insertions(+), 26 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index b836948c9543..67dda77c500f 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -389,6 +389,29 @@ static int zap_threads(struct task_struct *tsk,
 	return nr;
 }
 
+void coredump_join(struct core_state *core_state)
+{
+	/* Stop and join the in-progress coredump */
+	struct core_thread self;
+
+	self.task = current;
+	self.next = xchg(&core_state->dumper.next, &self);
+	/*
+	 * Implies mb(), the result of xchg() must be visible
+	 * to core_state->dumper.
+	 */
+	if (atomic_dec_and_test(&core_state->nr_threads))
+		complete(&core_state->startup);
+
+	for (;;) {
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		if (!self.task) /* see coredump_finish() */
+			break;
+		freezable_schedule();
+	}
+	__set_current_state(TASK_RUNNING);
+}
+
 static int coredump_wait(int exit_code, struct core_state *core_state)
 {
 	struct task_struct *tsk = current;
@@ -436,7 +459,7 @@ static void coredump_finish(bool core_dumped)
 		next = curr->next;
 		task = curr->task;
 		/*
-		 * see coredump_task_exit(), curr->task must not see
+		 * see coredump_join(), curr->task must not see
 		 * ->task == NULL before we read ->next.
 		 */
 		smp_mb();
diff --git a/include/linux/coredump.h b/include/linux/coredump.h
index 08a1d3e7e46d..815d6099b757 100644
--- a/include/linux/coredump.h
+++ b/include/linux/coredump.h
@@ -40,8 +40,10 @@ extern int dump_emit(struct coredump_params *cprm, const void *addr, int nr);
 extern int dump_align(struct coredump_params *cprm, int align);
 int dump_user_range(struct coredump_params *cprm, unsigned long start,
 		    unsigned long len);
+extern void coredump_join(struct core_state *core_state);
 extern void do_coredump(const kernel_siginfo_t *siginfo);
 #else
+extern inline void coredump_join(struct core_state *core_state) {}
 static inline void do_coredump(const kernel_siginfo_t *siginfo) {}
 #endif
 
diff --git a/kernel/exit.c b/kernel/exit.c
index d8ecbaa514f7..2218ca02ac71 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -352,35 +352,16 @@ static void coredump_task_exit(struct task_struct *tsk)
 	 * We must hold siglock around checking core_state
 	 * and setting PF_POSTCOREDUMP.  The core-inducing thread
 	 * will increment ->nr_threads for each thread in the
-	 * group without PF_POSTCOREDUMP set.
+	 * group without PF_POSTCOREDUMP set.  Decrement ->nr_threads
+	 * and possibly complete core_state->startup to politely skip
+	 * participating in any pending coredumps.
 	 */
 	spin_lock_irq(&tsk->sighand->siglock);
 	tsk->flags |= PF_POSTCOREDUMP;
 	core_state = tsk->signal->core_state;
+	if (core_state && atomic_dec_and_test(&core_state->nr_threads))
+		complete(&core_state->startup);
 	spin_unlock_irq(&tsk->sighand->siglock);
-	if (core_state) {
-		struct core_thread self;
-
-		self.task = current;
-		if (self.task->flags & PF_SIGNALED)
-			self.next = xchg(&core_state->dumper.next, &self);
-		else
-			self.task = NULL;
-		/*
-		 * Implies mb(), the result of xchg() must be visible
-		 * to core_state->dumper.
-		 */
-		if (atomic_dec_and_test(&core_state->nr_threads))
-			complete(&core_state->startup);
-
-		for (;;) {
-			set_current_state(TASK_UNINTERRUPTIBLE);
-			if (!self.task) /* see coredump_finish() */
-				break;
-			freezable_schedule();
-		}
-		__set_current_state(TASK_RUNNING);
-	}
 }
 
 #ifdef CONFIG_MEMCG
diff --git a/kernel/signal.c b/kernel/signal.c
index 8a0f114d00e0..8595c935027e 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2687,6 +2687,7 @@ bool get_signal(struct ksignal *ksig)
 	}
 
 	for (;;) {
+		struct core_state *core_state;
 		struct k_sigaction *ka;
 		enum pid_type type;
 
@@ -2820,6 +2821,7 @@ bool get_signal(struct ksignal *ksig)
 		}
 
 	fatal:
+		core_state = signal->core_state;
 		spin_unlock_irq(&sighand->siglock);
 		if (unlikely(cgroup_task_frozen(current)))
 			cgroup_leave_frozen(true);
@@ -2842,6 +2844,9 @@ bool get_signal(struct ksignal *ksig)
 			 * that value and ignore the one we pass it.
 			 */
 			do_coredump(&ksig->info);
+		} else if (core_state) {
+			/* Wait for the coredump to happen */
+			coredump_join(core_state);
 		}
 
 		/*
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 3c6cf9e3cd66..1bb689fd9f81 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -845,7 +845,7 @@ static inline bool __task_will_free_mem(struct task_struct *task)
 
 	/*
 	 * A coredumping process may sleep for an extended period in
-	 * coredump_task_exit(), so the oom killer cannot assume that
+	 * get_signal(), so the oom killer cannot assume that
 	 * the process will promptly exit and release memory.
 	 */
 	if (sig->core_state)
-- 
2.35.3

