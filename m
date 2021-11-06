Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAE7D446BAF
	for <lists+io-uring@lfdr.de>; Sat,  6 Nov 2021 01:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbhKFBBj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Nov 2021 21:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233197AbhKFBBi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Nov 2021 21:01:38 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F343AC061570
        for <io-uring@vger.kernel.org>; Fri,  5 Nov 2021 17:58:57 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id t7so9660492pgl.9
        for <io-uring@vger.kernel.org>; Fri, 05 Nov 2021 17:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8tG1qoat1DJ47nGNpKe5fdyQvdswp0WSvhNCJQZNgZI=;
        b=Qm5v0hzAxfbtXoVa73MvTkFglJtu3jC4MV7q5ySchQ76tM9jwRrd+GA1HrbhmATg+a
         XtGKoQKUlV9yzc13iQOx89LH/1BQQ0vH4y95Zuhjm0N+udCwTN+2UB7TIAPemASD4RW2
         ESdFBJuQWti92Ii356KfgEw9hdUvWr8syR8zVRLEJLr2llaeA7QNAY2XPNvQzXRByFDe
         xYbJ41xqpNkfSxII2AYdgJybE5DAOrW/29efliBVY1MRz6nnDgYwwCLVLWEEIgL/mc57
         SICaMmGf6FeNXDclr/jKzxInFsTnkckbZMmuCLPAjr1MBHJpdnysiD1wP0PeyQNLduu3
         vwFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8tG1qoat1DJ47nGNpKe5fdyQvdswp0WSvhNCJQZNgZI=;
        b=i0I6Wo17bsgjwAzfbs03wmxOtSSQiGlPJwWzD98uOp93yK977oYbJzwM0zJCiCHQLN
         w+ifRzC9Mh3KkmGf8y39Xu/RwTiK0M+8m7NZrgoUEhzm9cV7EXXhMwCUvG3hngpwZkTX
         PmmGcy/qnq7mVewAky+xoUzTwaK6dZb+KQDMVWmg6LeLyBdLQ9lS/iJMlqRn0A8sj+tl
         mX86p1PoiJ44L7fby0AQvDes9KaFSPeE4ZPN/sD9xGNe2fAGuK89h4kZmRiN2+PgOIg+
         MKzzmKs+HQirkxg+c0OqeImpNpoL8TE8ubuxY00/uBo/Z9PNnsvkRROUNIaWAKxqdp97
         W3+g==
X-Gm-Message-State: AOAM533ut1+53/9/trCc3DYMOXvge97I8m+PTX4LOeLP7lhqUzymMZk3
        hNtZ1fFW0t+cjKVrnt7Q0E+lPpUPaX+2IPc4
X-Google-Smtp-Source: ABdhPJw9hMW64gcw2Y0bg16kKOPOHcUb+8SG/SYsHR0MpfHLxTvjoXdml7TPVZ0zE+S6FhjxEjmhBA==
X-Received: by 2002:a05:6a00:88e:b0:44c:c40:9279 with SMTP id q14-20020a056a00088e00b0044c0c409279mr63658441pfj.85.1636160337309;
        Fri, 05 Nov 2021 17:58:57 -0700 (PDT)
Received: from integral.. ([182.2.36.202])
        by smtp.gmail.com with ESMTPSA id lt5sm7070836pjb.43.2021.11.05.17.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 17:58:56 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammar.faizi@students.amikom.ac.id>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Bedirhan KURT <windowz414@gnuweeb.org>
Subject: [PATCH v3 liburing] test: Add kworker-hang test
Date:   Sat,  6 Nov 2021 07:58:07 +0700
Message-Id: <20211106005235.363346-1-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <687bd0c5-be36-6892-c1e5-4488548aab12@kernel.dk>
References: <687bd0c5-be36-6892-c1e5-4488548aab12@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is the reproducer for the kworker hang bug.

Reproduction Steps:
  1) A user task calls io_uring_queue_exit().

  2) Suspend the task with SIGSTOP / SIGTRAP before the ring exit is
     finished (do it as soon as step (1) is done).

  3) Wait for `/proc/sys/kernel/hung_task_timeout_secs` seconds
     elapsed.

  4) We get a complaint from the khungtaskd because the kworker is
     stuck in an uninterruptible state (D).

The kworkers waiting on ring exit are not progressing as the task
cannot proceed. When the user task is continued (e.g. get SIGCONT
after SIGSTOP, or continue after SIGTRAP breakpoint), the kworker
then can finish the ring exit.

So here we need a special handling for this case to avoid khungtaskd
complaint. Currently we don't have the fix for this.

The dmesg says:

  [247390.432294] INFO: task kworker/u8:2:358488 blocked for more than 10 seconds.
  [247390.432314]       Tainted: G           OE     5.15.0-stable #5
  [247390.432322] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
  [247390.432329] task:kworker/u8:2    state:D stack:    0 pid:358488 ppid:     2 flags:0x00004000
  [247390.432341] Workqueue: events_unbound io_ring_exit_work
  [247390.432354] Call Trace:
  [247390.432368]  __schedule+0x453/0x1850
  [247390.432388]  ? lock_acquire+0xc8/0x2d0
  [247390.432404]  ? usleep_range+0x90/0x90
  [247390.432412]  schedule+0x59/0xc0
  [247390.432420]  schedule_timeout+0x1aa/0x1f0
  [247390.432429]  ? mark_held_locks+0x49/0x70
  [247390.432439]  ? lockdep_hardirqs_on_prepare+0xff/0x180
  [247390.432445]  ? _raw_spin_unlock_irq+0x24/0x40
  [247390.432456]  __wait_for_common+0xc2/0x170
  [247390.432473]  io_ring_exit_work+0x1d9/0x750
  [247390.432486]  ? io_uring_del_tctx_node+0xe0/0xe0
  [247390.432502]  ? verify_cpu+0xf0/0x100
  [247390.432520]  process_one_work+0x23b/0x550
  [247390.432540]  worker_thread+0x55/0x3c0
  [247390.432546]  ? process_one_work+0x550/0x550
  [247390.432556]  kthread+0x140/0x160
  [247390.432564]  ? set_kthread_struct+0x40/0x40
  [247390.432574]  ret_from_fork+0x1f/0x30
  [247390.432605] INFO: task kworker/u8:0:359615 blocked for more than 10 seconds.
  [247390.432613]       Tainted: G           OE     5.15.0-stable #5
  [247390.432620] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
  [247390.432626] task:kworker/u8:0    state:D stack:    0 pid:359615 ppid:     2 flags:0x00004000
  [247390.432635] Workqueue: events_unbound io_ring_exit_work
  [247390.432643] Call Trace:
  [247390.432653]  __schedule+0x453/0x1850
  [247390.432676]  ? usleep_range+0x90/0x90
  [247390.432684]  schedule+0x59/0xc0
  [247390.432691]  schedule_timeout+0x1aa/0x1f0
  [247390.432700]  ? mark_held_locks+0x49/0x70
  [247390.432710]  ? lockdep_hardirqs_on_prepare+0xff/0x180
  [247390.432717]  ? _raw_spin_unlock_irq+0x24/0x40
  [247390.432728]  __wait_for_common+0xc2/0x170
  [247390.432744]  io_ring_exit_work+0x1d9/0x750
  [247390.432758]  ? io_uring_del_tctx_node+0xe0/0xe0
  [247390.432772]  ? verify_cpu+0xf0/0x100
  [247390.432788]  process_one_work+0x23b/0x550
  [247390.432807]  worker_thread+0x55/0x3c0
  [247390.432813]  ? process_one_work+0x550/0x550
  [247390.432824]  kthread+0x140/0x160
  [247390.432830]  ? set_kthread_struct+0x40/0x40
  [247390.432839]  ret_from_fork+0x1f/0x30
  [247390.432870]
                  Showing all locks held in the system:
  [247390.432877] 1 lock held by khungtaskd/40:
  [247390.432880]  #0: ffffffff82976700 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x15/0x174
  [247390.432911] 1 lock held by in:imklog/922:
  [247390.432915]  #0: ffff8881041cfcf0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0x4a/0x60
  [247390.432977] 2 locks held by pager/318088:
  [247390.432981]  #0: ffff8881208d4898 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x24/0x50
  [247390.433001]  #1: ffffc900010fd2e8 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0x49e/0x660
  [247390.433024] 1 lock held by htop/341462:
  [247390.433032] 2 locks held by kworker/u8:2/358488:
  [247390.433035]  #0: ffff888100106938 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x1c1/0x550
  [247390.433053]  #1: ffffc90003797e70 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x1c1/0x550
  [247390.433071] 2 locks held by kworker/u8:0/359615:
  [247390.433075]  #0: ffff888100106938 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x1c1/0x550
  [247390.433092]  #1: ffffc90003597e70 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x1c1/0x550
  [247390.433110] 1 lock held by dmesg/361178:
  [247390.433113]  #0: ffff88810b5300d0 (&user->lock){+.+.}-{3:3}, at: devkmsg_read+0x4b/0x230

  [247390.433134] =============================================

Cc: Pavel Begunkov <asml.silence@gmail.com>
Link: https://github.com/axboe/liburing/issues/448
Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
---
 .gitignore          |   1 +
 test/Makefile       |   1 +
 test/kworker-hang.c | 309 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 311 insertions(+)
 create mode 100644 test/kworker-hang.c

diff --git a/.gitignore b/.gitignore
index fb3a859..b0f5edf 100644
--- a/.gitignore
+++ b/.gitignore
@@ -65,6 +65,7 @@
 /test/io_uring_register
 /test/io_uring_setup
 /test/iopoll
+/test/kworker-hang
 /test/lfs-openat
 /test/lfs-openat-write
 /test/link
diff --git a/test/Makefile b/test/Makefile
index f7eafad..2af684a 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -83,6 +83,7 @@ test_srcs := \
 	io_uring_enter.c \
 	io_uring_register.c \
 	io_uring_setup.c \
+	kworker-hang.c \
 	lfs-openat.c \
 	lfs-openat-write.c \
 	link.c \
diff --git a/test/kworker-hang.c b/test/kworker-hang.c
new file mode 100644
index 0000000..801a746
--- /dev/null
+++ b/test/kworker-hang.c
@@ -0,0 +1,309 @@
+/* SPDX-License-Identifier: MIT */
+
+/*
+ * kworker-hang
+ *
+ * Link: https://github.com/axboe/liburing/issues/448
+ */
+
+#include <dirent.h>
+#include <errno.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <string.h>
+#include <fcntl.h>
+#include <sys/types.h>
+#include <sys/poll.h>
+#include <sys/eventfd.h>
+#include <sys/resource.h>
+#include <sys/wait.h>
+
+#include "helpers.h"
+#include "liburing.h"
+
+#define NR_RINGS			2
+#define WAIT_FOR_KWORKER_SECS		10
+#define WAIT_FOR_KWORKER_SECS_STR	"10"
+
+static bool is_all_numeric(const char *pid)
+{
+	size_t i, l;
+	char c;
+
+	l = strnlen(pid, 32);
+	if (l == 0)
+		return false;
+
+	for (i = 0; i < l; i++) {
+		c = pid[i];
+		if (!('0' <= c && c <= '9'))
+			return false;
+	}
+
+	return true;
+}
+
+static bool is_kworker_event_unbound(const char *pid)
+{
+	int fd;
+	bool ret = false;
+	char fpath[256];
+	char read_buf[256] = {0};
+	ssize_t read_size;
+
+	snprintf(fpath, sizeof(fpath), "/proc/%s/comm", pid);
+
+	fd = open(fpath, O_RDONLY);
+	if (fd < 0)
+		return false;
+
+	read_size = read(fd, read_buf, sizeof(read_buf) - 1);
+	if (read_size < 0)
+		goto out;
+
+	if (!strncmp(read_buf, "kworker", 7) && strstr(read_buf, "events_unbound"))
+		ret = true;
+out:
+	close(fd);
+	return ret;
+}
+
+static bool is_on_io_ring_exit_work(const char *pid)
+{
+	int fd;
+	bool ret = false;
+	char fpath[256];
+	char read_buf[4096] = {0};
+	ssize_t read_size;
+
+	snprintf(fpath, sizeof(fpath), "/proc/%s/stack", pid);
+
+	fd = open(fpath, O_RDONLY);
+	if (fd < 0)
+		return false;
+
+	read_size = read(fd, read_buf, sizeof(read_buf) - 1);
+	if (read_size < 0)
+		goto out;
+
+	if (strstr(read_buf, "io_ring_exit_work"))
+		ret = true;
+out:
+	close(fd);
+	return ret;
+}
+
+static bool is_in_dreaded_d_state(const char *pid)
+{
+	int fd;
+	bool ret = false;
+	char fpath[256];
+	char read_buf[4096] = {0};
+	ssize_t read_size;
+	const char *p = read_buf;
+
+	snprintf(fpath, sizeof(fpath), "/proc/%s/stat", pid);
+
+	fd = open(fpath, O_RDONLY);
+	if (fd < 0)
+		return false;
+
+	read_size = read(fd, read_buf, sizeof(read_buf) - 1);
+	if (read_size < 0)
+		goto out;
+
+	/*
+	 * It looks like this:
+	 * 9384 (kworker/u8:8+events_unbound) D 2 0 0 0 -1 69238880 0 0 0 0 0 0 0 0 20 0 1 0
+	 *
+	 * Catch the 'D'!
+	 */
+	while (*p != ')') {
+		p++;
+		if (&p[2] >= &read_buf[sizeof(read_buf) - 1])
+			/*
+			 * /proc/$pid/stack shows the wrong output?
+			 */
+			goto out;
+	}
+
+	ret = (p[2] == 'D');
+out:
+	close(fd);
+	return ret;
+}
+
+/*
+ * Returns 1 if we have kworker hang or fail to open `/proc`.
+ */
+static int scan_kworker_hang(void)
+{
+	DIR *dr;
+	int ret = 0;
+	struct dirent *de;
+
+	dr = opendir("/proc");
+	if (dr == NULL) {
+		perror("opendir");
+		return 1;
+	}
+
+	while (1) {
+		const char *pid;
+
+		de = readdir(dr);
+		if (!de)
+			break;
+
+		pid = de->d_name;
+		if (!is_all_numeric(pid))
+			continue;
+
+		if (!is_kworker_event_unbound(pid))
+			continue;
+
+		if (!is_on_io_ring_exit_work(pid))
+			continue;
+
+		if (is_in_dreaded_d_state(pid)) {
+			/* kworker is hang?! */
+			printf("Bug: found hang kworker on io_ring_exit_work "
+			       "/proc/%s\n", pid);
+			ret = 1;
+		}
+	}
+
+	closedir(dr);
+	return ret;
+}
+
+static void set_hung_entries(void)
+{
+	const char *cmds[] = {
+		/* Backup current values. */
+		"cat /proc/sys/kernel/hung_task_all_cpu_backtrace > hung_task_all_cpu_backtrace.bak",
+		"cat /proc/sys/kernel/hung_task_check_count > hung_task_check_count.bak",
+		"cat /proc/sys/kernel/hung_task_panic > hung_task_panic.bak",
+		"cat /proc/sys/kernel/hung_task_check_interval_secs > hung_task_check_interval_secs.bak",
+		"cat /proc/sys/kernel/hung_task_timeout_secs > hung_task_timeout_secs.bak",
+		"cat /proc/sys/kernel/hung_task_warnings > hung_task_warnings.bak",
+
+		/* Set to do the test. */
+		"echo 1 > /proc/sys/kernel/hung_task_all_cpu_backtrace",
+		"echo 99999999 > /proc/sys/kernel/hung_task_check_count",
+		"echo 0 > /proc/sys/kernel/hung_task_panic",
+		"echo 1 > /proc/sys/kernel/hung_task_check_interval_secs",
+		"echo " WAIT_FOR_KWORKER_SECS_STR " > /proc/sys/kernel/hung_task_timeout_secs",
+		"echo -1 > /proc/sys/kernel/hung_task_warnings",
+	};
+	int p;
+	size_t i;
+
+	for (i = 0; i < ARRAY_SIZE(cmds); i++)
+		p = system(cmds[i]);
+
+	(void)p;
+}
+
+static void restore_hung_entries(void)
+{
+	const char *cmds[] = {
+		/* Restore old values. */
+		"cat hung_task_all_cpu_backtrace.bak > /proc/sys/kernel/hung_task_all_cpu_backtrace",
+		"cat hung_task_check_count.bak > /proc/sys/kernel/hung_task_check_count",
+		"cat hung_task_panic.bak > /proc/sys/kernel/hung_task_panic",
+		"cat hung_task_check_interval_secs.bak > /proc/sys/kernel/hung_task_check_interval_secs",
+		"cat hung_task_timeout_secs.bak > /proc/sys/kernel/hung_task_timeout_secs",
+		"cat hung_task_warnings.bak > /proc/sys/kernel/hung_task_warnings",
+
+		/* Clean up! */
+		"rm -f " \
+		"hung_task_all_cpu_backtrace.bak " \
+		"hung_task_check_count.bak " \
+		"hung_task_panic.bak " \
+		"hung_task_check_interval_secs.bak " \
+		"hung_task_timeout_secs.bak " \
+		"hung_task_warnings.bak"
+	};
+	int p;
+	size_t i;
+
+	for (i = 0; i < ARRAY_SIZE(cmds); i++)
+		p = system(cmds[i]);
+
+	(void)p;
+}
+
+
+static int run_child(void)
+{
+	int ret, i;
+	struct io_uring rings[NR_RINGS];
+
+	for (i = 0; i < NR_RINGS; i++) {
+		struct io_uring_params p = { };
+
+		ret = io_uring_queue_init_params(64, &rings[i], &p);
+		if (ret) {
+			printf("io_uring_queue_init_params(): (%d) %s\n",
+			       ret, strerror(-ret));
+			return 1;
+		}
+	}
+
+	for (i = 0; i < NR_RINGS; i++)
+		io_uring_queue_exit(&rings[i]);
+
+	kill(getpid(), SIGSTOP);
+	/*
+	 * kworker hang right after it sends SIGSTOP to itself.
+	 * The parent process will check it.
+	 */
+	return 0;
+}
+
+int main(void)
+{
+	pid_t child_pid;
+	int ret, wstatus = 0;
+
+	/*
+	 * We need root to check /proc/$pid/stack and set /proc/sys/kernel/hung*
+	 */
+	if (getuid() != 0 && geteuid() != 0) {
+		printf("Skipping kworker-hang: not root\n");
+		return 0;
+	}
+
+	set_hung_entries();
+	child_pid = fork();
+	if (child_pid < 0) {
+		perror("fork()");
+		return 1;
+	}
+
+	if (!child_pid)
+		return run_child();
+
+	atexit(restore_hung_entries);
+
+	/* +2 just to add small extra time for khungtaskd. */
+	sleep(WAIT_FOR_KWORKER_SECS + 2);
+	ret = scan_kworker_hang();
+
+	kill(child_pid, SIGCONT);
+
+	if (waitpid(child_pid, &wstatus, 0) < 0) {
+		perror("waitpid()");
+		return 1;
+	}
+
+	if (!WIFEXITED(wstatus)) {
+		printf("Child process won't exit!\n");
+		return 1;
+	}
+
+	/* Make sure child process exited properly as well. */
+	return ret | WEXITSTATUS(wstatus);
+}
-- 
2.30.2

