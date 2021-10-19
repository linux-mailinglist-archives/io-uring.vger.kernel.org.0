Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31CAB433EFE
	for <lists+io-uring@lfdr.de>; Tue, 19 Oct 2021 21:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234941AbhJSTJp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Oct 2021 15:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234891AbhJSTJo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Oct 2021 15:09:44 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C929C06161C
        for <io-uring@vger.kernel.org>; Tue, 19 Oct 2021 12:07:31 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id f11so781329pfc.12
        for <io-uring@vger.kernel.org>; Tue, 19 Oct 2021 12:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AvpjsctkJ2wGZbWN5uRK2uEnX7++Xnjd7Wy5llXev4c=;
        b=O1Kh8qSFzDg//k6he7205a6eqyBd1Zw7pOtQQnYUl4QPlZva/jqryGre6EEqScnyip
         Sqd1bfGtMyzsV6PPDK8P5pg2HVB9xxT51/cLtV/skmHWAyz7EEwMBJxYWMz97FsWKBLl
         fq84BmHg37Wu2PiG3wS/1wo+ZlTR66pAq/RmHdhI4J3EZ7bATdH4jafuZisgX4+MDR9/
         v5vpp4H/ZBpHj+m4g8aU+J1lXTVEa7+jClgFc0OzigeTao0h69FwxLQ9ANUZNwiZkMG1
         wM5YcuL/F+JzkC0LCOtDyHqBIo7XvZJ0ER5pkanmFMTcJH8BV/c3B0vW5UCVASOrOMTE
         LT6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AvpjsctkJ2wGZbWN5uRK2uEnX7++Xnjd7Wy5llXev4c=;
        b=jAiGs3ZTVUCYvrGISEDi7E/MiAZsoff5Et+YVg6SVNXjNfa66vfb5rzRD0obBYq25f
         8tF1z2FgakNpwuc0dU7udF/VLbvwhaiQQPIT5XPqqU3KsjT9bCyzM7AytTGflyACtYqb
         bTwf4AqX4L015hKF4sq+xggMB2cUODZmQorGy3oZ3l2UDnUQ5hJGh9dJs6yhMLEr60UI
         L0lsPyrFIL3hqoyLhyAVfhzu5+tXgs+Buog0oEuo/iiexPae4mDTEAtUTgvM0onMYUc/
         JG/5rSRAAFvpJV8R0LrI0MXbsCaYaUdXfZIJxXY4kk8gyuZ2L0o7pSPaItFc1cTI1fSb
         TggQ==
X-Gm-Message-State: AOAM532LkpJhsN4pUl0nroPLaPJfJY8Jl79wZM2RibJoj8fDQpfwJjxQ
        PpamCBdroIZyWjHGWw2J6BiehkK4zXA6Jvaq
X-Google-Smtp-Source: ABdhPJz8tV21/jmHPlqIxnyi/8sUsdHIvC93dq/Q7SicD8r32OlqZgq0nqsA+mTxCGlioYiDzYDvrg==
X-Received: by 2002:aa7:8149:0:b0:44c:916c:1fdb with SMTP id d9-20020aa78149000000b0044c916c1fdbmr1725404pfn.34.1634670450645;
        Tue, 19 Oct 2021 12:07:30 -0700 (PDT)
Received: from integral.. ([182.2.39.223])
        by smtp.gmail.com with ESMTPSA id s22sm16834145pfe.76.2021.10.19.12.07.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 12:07:30 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Subject: [PATCH liburing] test: Add kworker-hang test
Date:   Wed, 20 Oct 2021 02:07:08 +0700
Message-Id: <jVMSI0NVN7BJ-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add kworker-hang test to reproduce this:

  [11133.980033] INFO: task kworker/u8:3:16315 blocked for more than 10 seconds.
  [11133.980041]       Tainted: G           OE     5.15.0-rc4-for-5.16-io-uring-00060-g4922ab639eb6 #4
  [11133.980047] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
  [11133.980052] task:kworker/u8:3    state:D stack:    0 pid:16315 ppid:     2 flags:0x00004000
  [11133.980061] Workqueue: events_unbound io_ring_exit_work
  [11133.980068] Call Trace:
  [11133.980076]  __schedule+0x453/0x1850
  [11133.980097]  ? usleep_range+0x90/0x90
  [11133.980104]  schedule+0x59/0xc0
  [11133.980111]  schedule_timeout+0x1aa/0x1f0
  [11133.980119]  ? mark_held_locks+0x49/0x70
  [11133.980128]  ? lockdep_hardirqs_on_prepare+0xff/0x180
  [11133.980134]  ? _raw_spin_unlock_irq+0x24/0x40
  [11133.980143]  __wait_for_common+0xc2/0x170
  [11133.980158]  io_ring_exit_work+0x42c/0x44a
  [11133.980166]  ? io_uring_del_tctx_node+0xad/0xad
  [11133.980178]  ? verify_cpu+0xf0/0x100
  [11133.980193]  process_one_work+0x23b/0x550
  [11133.980209]  worker_thread+0x55/0x3c0
  [11133.980214]  ? process_one_work+0x550/0x550
  [11133.980223]  kthread+0x140/0x160
  [11133.980229]  ? set_kthread_struct+0x40/0x40
  [11133.980237]  ret_from_fork+0x1f/0x30
  [11133.980278]
                 Showing all locks held in the system:
  [11133.980282] 2 locks held by kworker/u8:0/8:
  [11133.980286]  #0: ffff888100106938 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x1c1/0x550
  [11133.980304]  #1: ffffc90000187e70 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x1c1/0x550
  [11133.980322] 1 lock held by khungtaskd/39:
  [11133.980325]  #0: ffffffff82977740 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x15/0x174
  [11133.980348] 2 locks held by kworker/u8:9/760:
  [11133.980351]  #0: ffff888100106938 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x1c1/0x550
  [11133.980366]  #1: ffffc9000176fe70 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x1c1/0x550
  [11133.980385] 1 lock held by in:imklog/926:
  [11133.980388]  #0: ffff88813208c2f0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0x4a/0x60
  [11133.980434] 1 lock held by htop/13609:
  [11133.980438] 2 locks held by kworker/u8:3/16315:
  [11133.980441]  #0: ffff888100106938 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x1c1/0x550
  [11133.980456]  #1: ffffc90008d43e70 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x1c1/0x550
  [11133.980475] 1 lock held by dmesg/18421:
  [11133.980478]  #0: ffff88824be300d0 (&user->lock){+.+.}-{3:3}, at: devkmsg_read+0x4b/0x230

  [11133.980498] =============================================

Cc: Pavel Begunkov <asml.silence@gmail.com>
Link: https://github.com/axboe/liburing/issues/448
Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
---
 test/Makefile       |   2 +
 test/kworker-hang.c | 289 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 291 insertions(+)
 create mode 100644 test/kworker-hang.c

diff --git a/test/Makefile b/test/Makefile
index 1a10a24..7c8691d 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -75,6 +75,7 @@ test_targets += \
 	io_uring_register \
 	io_uring_setup \
 	iopoll \
+	kworker-hang \
 	lfs-openat \
 	lfs-openat-write \
 	link \
@@ -227,6 +228,7 @@ test_srcs := \
 	io_uring_register.c \
 	io_uring_setup.c \
 	iopoll.c \
+	kworker-hang.c \
 	lfs-openat-write.c \
 	lfs-openat.c \
 	link-timeout.c \
diff --git a/test/kworker-hang.c b/test/kworker-hang.c
new file mode 100644
index 0000000..577b124
--- /dev/null
+++ b/test/kworker-hang.c
@@ -0,0 +1,289 @@
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
+#define NR_RINGS			5
+#define WAIT_FOR_KWORKER_SECS		10
+#define WAIT_FOR_KWORKER_SECS_STR	"10"
+
+static void run_child(void)
+{
+	int ret, i;
+	struct io_uring rings[NR_RINGS];
+
+	for (i = 0; i < NR_RINGS; i++) {
+		struct io_uring_params p = { };
+		ret = io_uring_queue_init_params(64, &rings[i], &p);
+		if (ret) {
+			fprintf(stderr, "queue_init: %d/%d\n", ret, i);
+			goto err;
+		}
+	}
+
+	for (i = 0; i < NR_RINGS; i++)
+		io_uring_queue_exit(&rings[i]);
+
+	kill(getpid(), SIGSTOP);
+
+	/* We may have kworkers hang here, let the parent check it. */
+	return;
+
+err:
+	/* We can't create io_uring context */
+	exit(1);
+}
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
+static bool is_on_ring_exit_work(const char *pid)
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
+		if (!is_on_ring_exit_work(pid))
+			continue;
+
+		if (is_in_dreaded_d_state(pid)) {
+			/* kworker is hang?! */
+			printf("Bug: found hang kworker on io_ring_exit_work "
+				"/proc/%s\n", pid);
+			ret = 1;
+		}
+	}
+
+	return ret;
+}
+
+static void set_hung_entries(void)
+{
+	const char *cmds[] = {
+		/* Backup current values */
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
+int main(int argc, char *argv[])
+{
+	int ret;
+	pid_t child_pid;
+
+	if (getuid() != 0 && geteuid() != 0) {
+		printf("Skipping kworker-hang: not root\n");
+		return 0;
+	}
+
+	set_hung_entries();
+	child_pid = fork();
+
+	if (!child_pid) {
+		run_child();
+		return 0;
+	}
+
+	/* +2 just to add small extra time for khungtaskd. */
+	sleep(WAIT_FOR_KWORKER_SECS + 2);
+	ret = scan_kworker_hang();
+	restore_hung_entries();
+
+	kill(child_pid, SIGCONT);
+	wait(NULL);
+	return ret;
+}
-- 
2.30.2

