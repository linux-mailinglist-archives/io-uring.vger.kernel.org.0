Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5A04668CB
	for <lists+io-uring@lfdr.de>; Thu,  2 Dec 2021 18:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348023AbhLBRH0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Dec 2021 12:07:26 -0500
Received: from mx-rz-1.rrze.uni-erlangen.de ([131.188.11.20]:46987 "EHLO
        mx-rz-1.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348043AbhLBRH0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Dec 2021 12:07:26 -0500
X-Greylist: delayed 460 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Dec 2021 12:07:25 EST
Received: from mx-rz-smart.rrze.uni-erlangen.de (mx-rz-smart.rrze.uni-erlangen.de [IPv6:2001:638:a000:1025::1e])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mx-rz-1.rrze.uni-erlangen.de (Postfix) with ESMTPS id 4J4htZ03VKz8tQg;
        Thu,  2 Dec 2021 17:56:22 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fau.de; s=fau-2021;
        t=1638464182; bh=KlVsAy7OGVzh0Xfjl+WSSgiFJLlzKE+dpm9VJQZwdl0=;
        h=Date:From:To:Cc:Subject:From:To:CC:Subject;
        b=fm0uMa0/GUKqYsLgsieRsH1eIFvSoPgB6+BOl8yPn/AAqeSWTrPVAfd8yN6kZHvCA
         /acfhRwaVZNsUy6mnFfKj8A3/+RPiR7CBqrquo6IgxGvM6YuLpwWybAWiwu8m+lGPi
         0wK4gjVbmn16upaR+/XPucVsPCCYHcoQBW2kOJggYKigAVP/Tak+HfIWkfQ+WTSssF
         RUMq0c3U+JWScNM0BuaMpwgqOifkOyhvF0a3VVDHGoJytBpBYna/MQbYtSBe2dSiIS
         GHXg+aFDd9j2t9iiONEDU2dTjFzDBrce21ejdbUXUa8vpxqlfLbk0Cm87KIoLCeInk
         x9FUOSgkDRjpA==
X-Virus-Scanned: amavisd-new at boeck5.rrze.uni-erlangen.de (RRZE)
X-RRZE-Flag: Not-Spam
X-RRZE-Submit-IP: 2003:eb:5724:4441:7a2b:46ff:fe28:e01a
Received: from localhost (p200300eb572444417a2b46fffe28e01a.dip0.t-ipconnect.de [IPv6:2003:eb:5724:4441:7a2b:46ff:fe28:e01a])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: U2FsdGVkX1+li2saNnm/ykosi7e3NQpiGOhh5PqVYBo=)
        by smtp-auth.uni-erlangen.de (Postfix) with ESMTPSA id 4J4htV3688z8v3s;
        Thu,  2 Dec 2021 17:56:18 +0100 (CET)
Date:   Thu, 2 Dec 2021 17:56:06 +0100
From:   Florian Fischer <florian.fl.fischer@fau.de>
To:     io-uring@vger.kernel.org
Cc:     Florian Schmaus <schmaus@cs.fau.de>
Subject: Tasks stuck on exit(2) with 5.15.6
Message-ID: <20211202165606.mqryio4yzubl7ms5@pasture>
Mail-Followup-To: io-uring@vger.kernel.org,
        Florian Schmaus <schmaus@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

I experienced stuck tasks during a process' exit when using multiple
io_uring instances on a 48/96-core system in a multi-threaded environment,
where we use an io_uring per thread and a single pipe(2) to pass messages
between the threads.

When the program calls exit(2) without joining the threads or unmapping/closing
the io_urings, the program gets stuck in the zombie state - sometimes leaving
behind multiple <cpu>:<n>-events kernel-threads using a considerable amount of CPU.

I can reproduce this behavior on Debian running Linux 5.15.6 with the
reproducer below compiled with Debian's gcc (10.2.1-6):

// gcc -Werror -Wall -O3 hang-pipe-reproducer.c -o hang-pipe-reproducer -pthread -luring
#include <assert.h>
#include <err.h>
#include <errno.h>
#include <liburing.h>
#include <pthread.h>
#include <semaphore.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/sysinfo.h>
#include <unistd.h>

#define IORING_ENTRIES 8
#define UNUSED __attribute((unused))

static pthread_t* threads;
static pthread_barrier_t init_barrier;
static int sleep_fd, notify_fd;
static sem_t sem;

void* thread_func(UNUSED void* arg) {
	struct io_uring ring;
	int res = io_uring_queue_init(IORING_ENTRIES, &ring, 0);
	if (res) err(EXIT_FAILURE, "io_uring_queue_init failed");

	pthread_barrier_wait(&init_barrier);

	for(;;) {
		struct io_uring_sqe* sqe = io_uring_get_sqe(&ring);
		assert(sqe);

		uint64_t buf;
		io_uring_prep_read(sqe, sleep_fd, &buf, sizeof(buf), 0);
    
		int res = io_uring_submit_and_wait(&ring, 1);
		if (res < 0) err(EXIT_FAILURE, "io_uring_submit_and_wait failed");

		struct io_uring_cqe* cqe;
		res = io_uring_peek_cqe(&ring, &cqe);
		assert(!res);
		if (cqe->res < 0) {
			errno = -cqe->res;
			err(EXIT_FAILURE, "read failed");
		}
		assert(cqe->res == sizeof(buf));

		sem_post(&sem);

		io_uring_cqe_seen(&ring, cqe);
	}

	return NULL;
}

int main() {
	int cpus = get_nprocs();
	int res = pthread_barrier_init(&init_barrier, NULL, cpus);
	if (res) err(EXIT_FAILURE, "pthread_barrier_init failed");

	res = sem_init(&sem, 0, 0);
	if (res) err(EXIT_FAILURE, "sem_init failed");

	printf("start %d io_uring threads\n", cpus);
	threads = malloc(sizeof(pthread_t) * cpus);
	if (!threads) err(EXIT_FAILURE, "malloc failed");

	int fds[2];
	res = pipe(fds);
	if (res) err(EXIT_FAILURE, "pipe failed");
	sleep_fd = fds[0];
	notify_fd = fds[1];

	for (unsigned i = 0; i < cpus; ++i) {
		errno = pthread_create(&threads[i], NULL, thread_func, NULL);
		if (errno) err(EXIT_FAILURE, "pthread_create failed");
	}

	// Write #cpus notifications
	printf("write %d notifications\n", cpus);
	const uint64_t n = 0x42;
	for (unsigned i = 0; i < cpus; ++i) {
		res = write(notify_fd, &n, sizeof(n));
		if (res < 0) err(EXIT_FAILURE, "write failed");
		assert(res == sizeof(n));
	}

	// Await that all notifications were received
	for (unsigned i = 0; i < cpus; ++i) {
		sem_wait(&sem);
	}

	// Exit without resource cleanup
	exit(EXIT_SUCCESS);
}

Kernel info message about the hung task:

INFO: task hang-pipe-repro:404364 blocked for more than 845 seconds.
      Tainted: G            E     5.15.6 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:hang-pipe-repro state:D stack:    0 pid:404364 ppid: 19554 flags:0x00024004
Call Trace:
 <TASK>
 ? usleep_range+0x80/0x80
 __schedule+0x2eb/0x910
 ? usleep_range+0x80/0x80
 schedule+0x44/0xa0
 schedule_timeout+0xfc/0x140
 ? __prepare_to_swait+0x4b/0x70
 __wait_for_common+0xae/0x160
 io_wq_put_and_exit+0xf9/0x330
 io_uring_cancel_generic+0x200/0x2e0
 ? finish_wait+0x80/0x80
 do_exit+0xba/0xa90
 do_group_exit+0x33/0xa0
 get_signal+0x170/0x910
 arch_do_signal_or_restart+0xf0/0x7a0
 ? __schedule+0x2f3/0x910
 ? __queue_work+0x1c8/0x3d0
 exit_to_user_mode_prepare+0x119/0x180
 syscall_exit_to_user_mode+0x23/0x40
 do_syscall_64+0x48/0xc0
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f2df15c59b9
RSP: 002b:00007f2dd4434de8 EFLAGS: 00000212 ORIG_RAX: 00000000000001aa
RAX: 0000000000000001 RBX: 00007f2dd4434e30 RCX: 00007f2df15c59b9
RDX: 0000000000000001 RSI: 0000000000000001 RDI: 000000000000003f
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000008
R10: 0000000000000001 R11: 0000000000000212 R12: 00007f2dd4434e20
R13: 00007ffc8577b38f R14: 00007f2dd4434fc0 R15: 0000000000802000
 </TASK>

The trace ran through scripts/decode_stacktrace.sh

Call Trace:
<TASK>
 ? usleep_range (kernel/time/timer.c:1843)
 __schedule (kernel/sched/core.c:4944 kernel/sched/core.c:6291)
 ? usleep_range (kernel/time/timer.c:1843)
 schedule (./arch/x86/include/asm/bitops.h:207 (discriminator 1) ./include/asm-generic/bitops/instrumented-non-atomic.h:135 (discriminator 1) ./include/linux/thread_info.h:118 (discriminator 1) ./include/linux/sched.h:2107 (discriminator 1) kernel/sched/core.c:6372 (discriminator 1))
 schedule_timeout (kernel/time/timer.c:1858)
 ? __prepare_to_swait (./include/linux/list.h:67 ./include/linux/list.h:100 kernel/sched/swait.c:89)
 __wait_for_common (kernel/sched/completion.c:86 kernel/sched/completion.c:106)
 io_wq_put_and_exit (./include/asm-generic/bitops/find.h:117 ./include/linux/nodemask.h:265 fs/io-wq.c:1216 fs/io-wq.c:1249)
 io_uring_cancel_generic (fs/io_uring.c:9753 fs/io_uring.c:9832)
 ? finish_wait (kernel/sched/wait.c:408)
 do_exit (kernel/exit.c:781)
 do_group_exit (./include/linux/sched/signal.h:269 kernel/exit.c:905)
 get_signal (./arch/x86/include/asm/current.h:15 kernel/signal.c:2758)
 arch_do_signal_or_restart (arch/x86/kernel/signal.c:865 (discriminator 1))
 ? __schedule (kernel/sched/core.c:6299)
 ? __queue_work (./arch/x86/include/asm/paravirt.h:590 ./arch/x86/include/asm/qspinlock.h:56 ./include/linux/spinlock.h:216 ./include/linux/spinlock_api_smp.h:151 kernel/workqueue.c:1522)
 exit_to_user_mode_prepare (kernel/entry/common.c:174 kernel/entry/common.c:207)
 syscall_exit_to_user_mode (./arch/x86/include/asm/jump_label.h:55 ./arch/x86/include/asm/nospec-branch.h:289 ./arch/x86/include/asm/entry-common.h:94 kernel/entry/common.c:131 kernel/entry/common.c:302)
 do_syscall_64 (arch/x86/entry/common.c:87)
 entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:113)
RIP: 0033:0x7f2df15c59b9
RSP: 002b:00007f2dd4434de8 EFLAGS: 00000212 ORIG_RAX: 00000000000001aa
RAX: 0000000000000001 RBX: 00007f2dd4434e30 RCX: 00007f2df15c59b9
RDX: 0000000000000001 RSI: 0000000000000001 RDI: 000000000000003f
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000008
R10: 0000000000000001 R11: 0000000000000212 R12: 00007f2dd4434e20
R13: 00007ffc8577b38f R14: 00007f2dd4434fc0 R15: 0000000000802000
 </TASK>


Using a 5.14 kernel the reproducer exits immediately.

Florian Fischer
