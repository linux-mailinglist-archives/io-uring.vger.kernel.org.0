Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8DF434B96
	for <lists+io-uring@lfdr.de>; Wed, 20 Oct 2021 14:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbhJTMzB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Oct 2021 08:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbhJTMzB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Oct 2021 08:55:01 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3FE1C06161C
        for <io-uring@vger.kernel.org>; Wed, 20 Oct 2021 05:52:46 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id oa12-20020a17090b1bcc00b0019f715462a8so2357119pjb.3
        for <io-uring@vger.kernel.org>; Wed, 20 Oct 2021 05:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1a2Xi8HZk+kteQjcUQ/ItYiJDmxgvZT1Ca1tNiB5CEQ=;
        b=cMM8rPmwowwiJD9taEJhu0SXV2twyBJg8ALBxe5ivYYYaXkS0NfDhzQTT+Xvl/NA/o
         Zi+vRDedC59af5l8acdVFfHLxAke6+8jmEm9SQF5WAwiBOhodcAZdSKfxmHLiG43NCao
         QlMC3U4PHs9iHAGNWRlsoMp0XxzGAuUeO/inv436oN+co3ilIYPT1ewbMtKPr2wyH8yu
         gi/Qfpo/FeGCey46663h88UeOzw00LFBtpglj0zCbP2NFU12d2tnvzDJxKL2IZ8or+uy
         NjIsNSr99h1w3au9ubQ4mY0gayckCZePFfIiAeuhoOzpmy5tDghGrvJA0qaDX9olFzHN
         5msA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1a2Xi8HZk+kteQjcUQ/ItYiJDmxgvZT1Ca1tNiB5CEQ=;
        b=Ki7wxGMhvlMp5q5sxpkSwCw9tZqevIoIYeos5rnBWa0w8mF6YVHahjaab2JareAonh
         6Wocd7a/aOaZxbGWRTBjfnr7DBJ/j72sKHg6+UW6y5GuUAlpDYv3ZEyDKwOo+V7ohe/r
         RUPAEF1EE4jXMiVU+CrpF/8rtxtMkz98Yospaanr81T7uX5YX1obeT98F9vCO8kpg3VU
         PysOgChEB1pps6VssWONV06MP1wQaWbGnM4P0YYv+XcZ8InzAxqOCcg3S2uPOosG3b6f
         V83p6ZKZRbFJ+yqROyXbvLQrDTSCiblTns+2VPupT+MA1B+zjobged8POSgu7aAV7SgX
         m6qg==
X-Gm-Message-State: AOAM532sNf1HiGVMt8O5jyaFKyugSHMJtgRRvd78NDKMqJbD1H84wNqb
        k5ass/vsE03SDnqMNmLMnFS+wA==
X-Google-Smtp-Source: ABdhPJzyA6SkuDgsG0HRISxkXUxwOeYN9aW6z5aPdY0YTUEM+5kM56yFlP+HZs9Xd2jk0n3awLChKQ==
X-Received: by 2002:a17:90b:4b48:: with SMTP id mi8mr7127444pjb.13.1634734366139;
        Wed, 20 Oct 2021 05:52:46 -0700 (PDT)
Received: from integral.. ([182.2.70.229])
        by smtp.gmail.com with ESMTPSA id u16sm2763369pfi.73.2021.10.20.05.52.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 05:52:43 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>,
        Bedirhan KURT <windowz414@gnuweeb.org>
Subject: [PATCH v2 liburing] test: Add kworker-hang test
Date:   Wed, 20 Oct 2021 19:51:59 +0700
Message-Id: <ECikfVpksVU-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <jVMSI0NVN7BJ-ammarfaizi2@gnuweeb.org>
References: <jVMSI0NVN7BJ-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add kworker-hang test to reproduce this:

  [28335.037622] INFO: task kworker/u8:3:77596 blocked for more than 10 seconds.
  [28335.037629]       Tainted: G        W  OE     5.15.0-rc4-for-5.16-io-uring-00060-g4922ab639eb6 #4
  [28335.037637] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
  [28335.037642] task:kworker/u8:3    state:D stack:    0 pid:77596 ppid:     2 flags:0x00004000
  [28335.037650] Workqueue: events_unbound io_ring_exit_work
  [28335.037658] Call Trace:
  [28335.037667]  __schedule+0x453/0x1850
  [28335.037681]  ? lock_acquire+0xc8/0x2d0
  [28335.037688]  ? io_ring_exit_work+0x98/0x44a
  [28335.037700]  ? usleep_range+0x90/0x90
  [28335.037707]  schedule+0x59/0xc0
  [28335.037715]  schedule_timeout+0x1aa/0x1f0
  [28335.037723]  ? mark_held_locks+0x49/0x70
  [28335.037733]  ? lockdep_hardirqs_on_prepare+0xff/0x180
  [28335.037740]  ? _raw_spin_unlock_irq+0x24/0x40
  [28335.037750]  __wait_for_common+0xc2/0x170
  [28335.037767]  io_ring_exit_work+0x42c/0x44a
  [28335.037776]  ? io_uring_del_tctx_node+0xad/0xad
  [28335.037790]  ? verify_cpu+0xf0/0x100
  [28335.037806]  process_one_work+0x23b/0x550
  [28335.037824]  worker_thread+0x55/0x3c0
  [28335.037830]  ? process_one_work+0x550/0x550
  [28335.037840]  kthread+0x140/0x160
  [28335.037846]  ? set_kthread_struct+0x40/0x40
  [28335.037856]  ret_from_fork+0x1f/0x30
  [28335.037887] INFO: task kworker/u8:4:78057 blocked for more than 10 seconds.
  [28335.037895]       Tainted: G        W  OE     5.15.0-rc4-for-5.16-io-uring-00060-g4922ab639eb6 #4
  [28335.037901] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
  [28335.037907] task:kworker/u8:4    state:D stack:    0 pid:78057 ppid:     2 flags:0x00004000
  [28335.037915] Workqueue: events_unbound io_ring_exit_work
  [28335.037922] Call Trace:
  [28335.037931]  __schedule+0x453/0x1850
  [28335.037946]  ? lock_acquire+0xc8/0x2d0
  [28335.037953]  ? io_ring_exit_work+0x98/0x44a
  [28335.037965]  ? usleep_range+0x90/0x90
  [28335.037973]  schedule+0x59/0xc0
  [28335.037980]  schedule_timeout+0x1aa/0x1f0
  [28335.037989]  ? mark_held_locks+0x49/0x70
  [28335.037999]  ? lockdep_hardirqs_on_prepare+0xff/0x180
  [28335.038005]  ? _raw_spin_unlock_irq+0x24/0x40
  [28335.038016]  __wait_for_common+0xc2/0x170
  [28335.038032]  io_ring_exit_work+0x42c/0x44a
  [28335.038041]  ? io_uring_del_tctx_node+0xad/0xad
  [28335.038055]  ? verify_cpu+0xf0/0x100
  [28335.038070]  process_one_work+0x23b/0x550
  [28335.038089]  worker_thread+0x55/0x3c0
  [28335.038095]  ? process_one_work+0x550/0x550
  [28335.038105]  kthread+0x140/0x160
  [28335.038111]  ? set_kthread_struct+0x40/0x40
  [28335.038120]  ret_from_fork+0x1f/0x30
  [28335.038148]
                 Showing all locks held in the system:
  [28335.038155] 1 lock held by khungtaskd/39:
  [28335.038159]  #0: ffffffff82977740 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x15/0x174
  [28335.038189] 1 lock held by in:imklog/926:
  [28335.038193]  #0: ffff88813208c2f0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0x4a/0x60
  [28335.038253] 2 locks held by kworker/u8:1/68219:
  [28335.038257]  #0: ffff888100106938 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x1c1/0x550
  [28335.038274]  #1: ffffc90003f7fe70 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x1c1/0x550
  [28335.038291] 2 locks held by kworker/u8:0/76320:
  [28335.038295]  #0: ffff888100106938 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x1c1/0x550
  [28335.038311]  #1: ffffc90003ca7e70 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x1c1/0x550
  [28335.038328] 2 locks held by kworker/u8:2/76681:
  [28335.038331]  #0: ffff888100106938 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x1c1/0x550
  [28335.038347]  #1: ffffc9000837be70 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x1c1/0x550
  [28335.038365] 2 locks held by kworker/u8:3/77596:
  [28335.038368]  #0: ffff888100106938 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x1c1/0x550
  [28335.038384]  #1: ffffc900083e3e70 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x1c1/0x550
  [28335.038401] 1 lock held by dmesg/78014:
  [28335.038405]  #0: ffff888217c180d0 (&user->lock){+.+.}-{3:3}, at: devkmsg_read+0x4b/0x230
  [28335.038423] 2 locks held by kworker/u8:4/78057:
  [28335.038427]  #0: ffff888100106938 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x1c1/0x550
  [28335.038443]  #1: ffffc900088b7e70 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x1c1/0x550

  [28335.038463] =============================================

  [28335.038468] NMI backtrace for cpu 2
  [28335.038471] CPU: 2 PID: 39 Comm: khungtaskd Tainted: G        W  OE     5.15.0-rc4-for-5.16-io-uring-00060-g4922ab639eb6 #4 8b24b2500a34cedea2e69c8d84eb4c855e713e61
  [28335.038478] Hardware name: Acer Aspire ES1-421/OLVIA_BE, BIOS V1.05 07/02/2015
  [28335.038481] Call Trace:
  [28335.038486]  dump_stack_lvl+0x57/0x72
  [28335.038495]  nmi_cpu_backtrace.cold+0x32/0x7f
  [28335.038500]  ? lapic_can_unplug_cpu+0x80/0x80
  [28335.038510]  nmi_trigger_cpumask_backtrace+0xd1/0xe0
  [28335.038520]  watchdog+0x5b3/0x670
  [28335.038528]  ? _raw_spin_unlock_irqrestore+0x37/0x40
  [28335.038535]  ? hungtask_pm_notify+0x40/0x40
  [28335.038544]  kthread+0x140/0x160
  [28335.038549]  ? set_kthread_struct+0x40/0x40
  [28335.038558]  ret_from_fork+0x1f/0x30
  [28335.038586] Sending NMI from CPU 2 to CPUs 0-1,3:
  [28335.038601] NMI backtrace for cpu 0 skipped: idling at native_safe_halt+0xb/0x10
  [28335.038609] NMI backtrace for cpu 1 skipped: idling at native_safe_halt+0xb/0x10
  [28335.038615] NMI backtrace for cpu 3
  [28335.038618] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G        W  OE     5.15.0-rc4-for-5.16-io-uring-00060-g4922ab639eb6 #4 8b24b2500a34cedea2e69c8d84eb4c855e713e61
  [28335.038622] Hardware name: Acer Aspire ES1-421/OLVIA_BE, BIOS V1.05 07/02/2015
  [28335.038624] RIP: 0010:acpi_idle_enter+0x92/0x100
  [28335.038631] Code: 00 41 bc 01 00 00 00 48 8b 2c 02 0f b6 45 01 3c 03 75 07 0f 09 0f 1f 44 00 00 0f b6 45 08 3c 01 74 3a 3c 02 74 45 8b 55 04 ec <48> 8b 05 07 fd 51 01 a9 00 00 00 80 75 08 48 8b 15 3d 74 9d 02 ed
  [28335.038634] RSP: 0018:ffffc900001d7e90 EFLAGS: 00000093
  [28335.038637] RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000000000040
  [28335.038639] RDX: 0000000000000414 RSI: ffff88810135b000 RDI: ffff888103161000
  [28335.038641] RBP: ffff88810135b098 R08: ffffffff82ae8f00 R09: 0000000000000018
  [28335.038643] R10: 0000000000000170 R11: 0000000000000af8 R12: 0000000000000002
  [28335.038644] R13: ffffffff82ae8fe8 R14: 0000000000000002 R15: 0000000000000000
  [28335.038646] FS:  0000000000000000(0000) GS:ffff888313d80000(0000) knlGS:0000000000000000
  [28335.038649] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [28335.038651] CR2: 00001e5478e1a518 CR3: 0000000199650000 CR4: 00000000000406e0
  [28335.038653] Call Trace:
  [28335.038656]  cpuidle_enter_state+0x9b/0x460
  [28335.038665]  cpuidle_enter+0x29/0x40
  [28335.038670]  do_idle+0x1fb/0x2a0
  [28335.038676]  cpu_startup_entry+0x19/0x20
  [28335.038680]  secondary_startup_64_no_verify+0xc2/0xcb

Cc: Pavel Begunkov <asml.silence@gmail.com>
Link: https://github.com/axboe/liburing/issues/448
Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
---

 v2:
  - Add child exit code check.
  - closedir() the opendir().
  - Add test/kworker-hang to .gitignore.
  - Small trival cleanups.

 .gitignore          |   1 +
 test/Makefile       |   2 +
 test/kworker-hang.c | 309 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 312 insertions(+)
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
index 0000000..6b52926
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
+#define NR_RINGS			5
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

