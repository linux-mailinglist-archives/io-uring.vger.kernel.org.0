Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45F34446DA7
	for <lists+io-uring@lfdr.de>; Sat,  6 Nov 2021 12:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbhKFLkD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 6 Nov 2021 07:40:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbhKFLkD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 6 Nov 2021 07:40:03 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28437C061570
        for <io-uring@vger.kernel.org>; Sat,  6 Nov 2021 04:37:22 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id r5so12727641pls.1
        for <io-uring@vger.kernel.org>; Sat, 06 Nov 2021 04:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QYqiFQhbfMfg4eQtgqn5vpecYtbI5Vvj6uJSiZzgMfI=;
        b=aqzDMuBtSP5RosSobPZOzKD929LNRTp1krT2kvrEGYOM55vmWdgfGNtavOyFMqQcjJ
         ZPzsFIPpQzAUhZwduHSR+sV9C/qgl/ARa9BUZf1i0iCuhAQlItUIeFE26SGcssv6YRk8
         UrxXWiXCrHO5+czHLwS8t+sfD57MUO8ZcY3IVlf0i7Cg0/qiMt06lSIK7s5zWP7qU/6l
         whrVUfy1D/b1kIwJ/pg344hGJk0D624gGQbfrYLIYARSaOvdUgPMpDTOby7RCdouqc69
         C3uEE9zd9jzVfGLjZH8whXPBDpcZPGh+9fJoGfnOutiLxOZ+D4lburmdA5XtTSmDZCOl
         SKTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QYqiFQhbfMfg4eQtgqn5vpecYtbI5Vvj6uJSiZzgMfI=;
        b=Q0dlabWtZlyxyMyVHO/OzK3lv2MCc2GHFRQtBMJLNG+SLkYd937sZ9ZvhPqu7YlU9P
         oJ1+Juha3LISW9ZANf8s+rrdmzDVtC1NhGK04iBzmykbYOitM1B+gQ4YtLnviI21CyZS
         w+s5aiyKqcTkJJXA5snaszUCDae5FF8KnxWSerHC6kJ3nEHqhp9e4VwgtO6WyvO2RHQx
         REFKBwz8SCoKKGDGZ9gpttWmXuun/bIwFldOZrxjFvTmSrimmOEcwc6IVOtwBprsdneZ
         TX4N4i9ymftmTMTg46EXivWNrASbEPPyD3/vd0IwvWADzZfsYrSFc5f5cjG2V/k66N3e
         w+AA==
X-Gm-Message-State: AOAM530b6SNRLJq2/NPxXLOKky6WX2U8e9fP998eAp6lbSyjAhiygb2D
        hyv7l62j3fhlDW/5gb7gcaFSUQ==
X-Google-Smtp-Source: ABdhPJx3bbpIIH1xfWYRvwRlebqj8t7amQIKjsgiGZGGLyQhZqbVHUNeFIEEaHYGT4gLPY4otCcP9A==
X-Received: by 2002:a17:903:2288:b0:141:e76d:1b16 with SMTP id b8-20020a170903228800b00141e76d1b16mr37935077plh.21.1636198641318;
        Sat, 06 Nov 2021 04:37:21 -0700 (PDT)
Received: from integral.. ([182.2.38.101])
        by smtp.gmail.com with ESMTPSA id cv1sm11678081pjb.48.2021.11.06.04.37.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Nov 2021 04:37:20 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammar.faizi@students.amikom.ac.id>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Bedirhan KURT <windowz414@gnuweeb.org>
Subject: [PATCH v5 liburing] test: Add kworker-hang test
Date:   Sat,  6 Nov 2021 18:37:09 +0700
Message-Id: <20211106113506.457208-1-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211106074057.431607-1-ammar.faizi@intel.com>
References: <20211106074057.431607-1-ammar.faizi@intel.com>
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
after SIGSTOP, or continue after SIGTRAP breakpoint), the kworkers
then can finish the ring exit.

We need a special handling for this case to avoid khungtaskd
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

  v5:
    - Use stderr for printing errors.

 .gitignore          |   1 +
 test/Makefile       |   1 +
 test/kworker-hang.c | 322 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 324 insertions(+)
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
index 0000000..786bb36
--- /dev/null
+++ b/test/kworker-hang.c
@@ -0,0 +1,322 @@
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
+
+/*
+ * WAIT_FOR_KWORKER_SECS can be any longer, but to make
+ * the test short, 10 seconds should be enough.
+ */
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
+	char read_buf[256] = { };
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
+	char read_buf[4096] = { };
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
+static bool is_in_d_state(const char *pid)
+{
+	int fd;
+	bool ret = false;
+	char fpath[256];
+	char read_buf[4096] = { };
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
+ * Return 1 if we have kworkers hang or fail to open `/proc`.
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
+		if (is_in_d_state(pid)) {
+			/* kworker hang */
+			fprintf(stderr, "Bug: found hang kworker on "
+				"io_ring_exit_work /proc/%s\n", pid);
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
+			"hung_task_all_cpu_backtrace.bak " \
+			"hung_task_check_count.bak " \
+			"hung_task_panic.bak " \
+			"hung_task_check_interval_secs.bak " \
+			"hung_task_timeout_secs.bak " \
+			"hung_task_warnings.bak"
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
+			fprintf(stderr, "io_uring_queue_init_params(): (%d) %s\n",
+			        ret, strerror(-ret));
+			return 1;
+		}
+	}
+
+	for (i = 0; i < NR_RINGS; i++)
+		io_uring_queue_exit(&rings[i]);
+
+	kill(getpid(), SIGSTOP);
+	/*
+	 * kworkers hang right after this task sends SIGSTOP to itself.
+	 * The parent process will check it. We are suspended here!
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
+		fprintf(stderr, "Skipping kworker-hang: not root\n");
+		return 0;
+	}
+
+	set_hung_entries();
+	child_pid = fork();
+	if (child_pid < 0) {
+		ret = errno;
+		fprintf(stderr, "fork(): (%d) %s\n", ret, strerror(ret));
+		return 1;
+	}
+
+	if (!child_pid)
+		return run_child();
+
+	atexit(restore_hung_entries);
+
+	/*
+	 * +2 just to add small extra time for
+	 * fork(), io_uring_setup(), close(), etc.
+	 */
+	sleep(WAIT_FOR_KWORKER_SECS + 2);
+	ret = scan_kworker_hang();
+
+	/*
+	 * Continue the suspended task.
+	 */
+	kill(child_pid, SIGCONT);
+
+	if (waitpid(child_pid, &wstatus, 0) < 0) {
+		ret = errno;
+		fprintf(stderr, "waitpid(): (%d) %s\n", ret, strerror(ret));
+		return 1;
+	}
+
+	if (!WIFEXITED(wstatus)) {
+		fprintf(stderr, "Child process won't exit");
+		return 1;
+	}
+
+	/* Make sure child process exited properly as well. */
+	return ret | WEXITSTATUS(wstatus);
+}
-- 
2.30.2

