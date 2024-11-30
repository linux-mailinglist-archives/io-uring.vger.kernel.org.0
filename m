Return-Path: <io-uring+bounces-5157-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F356D9DEEFE
	for <lists+io-uring@lfdr.de>; Sat, 30 Nov 2024 05:49:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3E1D2B209A8
	for <lists+io-uring@lfdr.de>; Sat, 30 Nov 2024 04:49:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C1627080D;
	Sat, 30 Nov 2024 04:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GI1wQ/YJ"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC1F29A0;
	Sat, 30 Nov 2024 04:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732942160; cv=none; b=aUDL8DZr9WfknPQW+e6htdl/O3kmSOWBzx5FLYESSmn52fJBvGL/RrNLQz1kSItjFsWjMtdpGuHIvgvCejVLohwLZELnREuc3zjvhRdJIAFLaDrwozUGKvQVgv3TkRGDzwfx3P0hL6sgEr31DA9DZOe0frzsO8g8oQfWPk7EwdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732942160; c=relaxed/simple;
	bh=7a+G0bORdE2giUr3BfncHUbUhxIoNcU4LB5xeDPWjC0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=cqOHN5yG8sbpqD5HIJj8xSr0eqW3CTm4xAS0Gsjrl9da/slCdeBrvooWE/HijI21FHos1bAQgnr/Mciu66qpsy9nns2+Qr6CUhBKu91J7r144oZaf/S3QZ/E6o23NtLl5KaJk4zlB5VhYXq+avCAmneF6pmNax+EQOMv42qDNaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GI1wQ/YJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B319DC4CECC;
	Sat, 30 Nov 2024 04:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732942159;
	bh=7a+G0bORdE2giUr3BfncHUbUhxIoNcU4LB5xeDPWjC0=;
	h=From:To:Cc:Subject:Date:From;
	b=GI1wQ/YJnVYzohfA+pkUBuCpZ7wmxmedH3w63YwPYzewyxYdEl0OgB6j0OpKX69kP
	 gHCQDqAsGzSlc7cSAnQx4/T++rPZOCA6VXS8vFoTxin2qWiLmfxBWIB4M0ggiKzcwG
	 EALQDbzN0Gk3lZ8JTYwgfGYA/+FefzNwcO4MTFw1dSOceBPmUVLOHrPmalQ62C9l6i
	 QUe4V2BmgIriWzUlbuc2osu6jamacQ4TlSkrNsWVvBZHm8vWf3GWqF5SwZl9GJzF2u
	 b+fAt858jkaIDXPzS7VoWh+9H/2aWNuInIscckjflwohp4CUaA3Sjm72pUc6hot48/
	 W3imNrwytJ5sA==
From: Kees Cook <kees@kernel.org>
To: Eric Biederman <ebiederm@xmission.com>
Cc: Kees Cook <kees@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chen Yu <yu.c.chen@intel.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH] exec: Make sure task->comm is always NUL-terminated
Date: Fri, 29 Nov 2024 20:49:14 -0800
Message-Id: <20241130044909.work.541-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4500; i=kees@kernel.org; h=from:subject:message-id; bh=7a+G0bORdE2giUr3BfncHUbUhxIoNcU4LB5xeDPWjC0=; b=owGbwMvMwCVmps19z/KJym7G02pJDOleM738HBLK3jN2iE/6eH1DywlDV//zrlOz/B20zoSrF TcWRqh2lLIwiHExyIopsgTZuce5eLxtD3efqwgzh5UJZAgDF6cATKSmnZFhhnD59S3JD5jX3D1Q mbmj6tqU1GW6Zs+WWgddMvkW5bPjByPDewHbf9LBK0Ic3Q08T3n7tfyLWvl1wUbxiKnnNR5G8O7 iAAA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

Using strscpy() meant that the final character in task->comm may be
non-NUL for a moment before the "string too long" truncation happens.

Instead of adding a new use of the ambiguous strncpy(), we'd want to
use memtostr_pad() which enforces being able to check at compile time
that sizes are sensible, but this requires being able to see string
buffer lengths. Instead of trying to inline __set_task_comm() (which
needs to call trace and perf functions), just open-code it. But to
make sure we're always safe, add compile-time checking like we already
do for get_task_comm().

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Suggested-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Kees Cook <kees@kernel.org>
---
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org

Here's what I'd prefer to use to clean up set_task_comm(). I merged
Linus and Eric's suggestions and open-coded memtostr_pad().
---
 fs/exec.c             | 12 ++++++------
 include/linux/sched.h |  9 ++++-----
 io_uring/io-wq.c      |  2 +-
 io_uring/sqpoll.c     |  2 +-
 kernel/kthread.c      |  3 ++-
 5 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index e0435b31a811..5f16500ac325 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1200,16 +1200,16 @@ char *__get_task_comm(char *buf, size_t buf_size, struct task_struct *tsk)
 EXPORT_SYMBOL_GPL(__get_task_comm);
 
 /*
- * These functions flushes out all traces of the currently running executable
- * so that a new one can be started
+ * This is unlocked -- the string will always be NUL-terminated, but
+ * may show overlapping contents if racing concurrent reads.
  */
-
 void __set_task_comm(struct task_struct *tsk, const char *buf, bool exec)
 {
-	task_lock(tsk);
+	size_t len = min(strlen(buf), sizeof(tsk->comm) - 1);
+
 	trace_task_rename(tsk, buf);
-	strscpy_pad(tsk->comm, buf, sizeof(tsk->comm));
-	task_unlock(tsk);
+	memcpy(tsk->comm, buf, len);
+	memset(&tsk->comm[len], 0, sizeof(tsk->comm) - len);
 	perf_event_comm(tsk, exec);
 }
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index e6ee4258169a..ac9f429ddc17 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1932,11 +1932,10 @@ static inline void kick_process(struct task_struct *tsk) { }
 #endif
 
 extern void __set_task_comm(struct task_struct *tsk, const char *from, bool exec);
-
-static inline void set_task_comm(struct task_struct *tsk, const char *from)
-{
-	__set_task_comm(tsk, from, false);
-}
+#define set_task_comm(tsk, from) ({			\
+	BUILD_BUG_ON(sizeof(from) != TASK_COMM_LEN);	\
+	__set_task_comm(tsk, from, false);		\
+})
 
 extern char *__get_task_comm(char *to, size_t len, struct task_struct *tsk);
 #define get_task_comm(buf, tsk) ({			\
diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index a38f36b68060..5d0928f37471 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -634,7 +634,7 @@ static int io_wq_worker(void *data)
 	struct io_wq_acct *acct = io_wq_get_acct(worker);
 	struct io_wq *wq = worker->wq;
 	bool exit_mask = false, last_timeout = false;
-	char buf[TASK_COMM_LEN];
+	char buf[TASK_COMM_LEN] = {};
 
 	set_mask_bits(&worker->flags, 0,
 		      BIT(IO_WORKER_F_UP) | BIT(IO_WORKER_F_RUNNING));
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index a26593979887..90011f06c7fb 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -271,7 +271,7 @@ static int io_sq_thread(void *data)
 	struct io_ring_ctx *ctx;
 	struct rusage start;
 	unsigned long timeout = 0;
-	char buf[TASK_COMM_LEN];
+	char buf[TASK_COMM_LEN] = {};
 	DEFINE_WAIT(wait);
 
 	/* offload context creation failed, just exit */
diff --git a/kernel/kthread.c b/kernel/kthread.c
index db4ceb0f503c..162d55811744 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -736,10 +736,11 @@ EXPORT_SYMBOL(kthread_stop_put);
 
 int kthreadd(void *unused)
 {
+	static const char comm[TASK_COMM_LEN] = "kthreadd";
 	struct task_struct *tsk = current;
 
 	/* Setup a clean context for our children to inherit. */
-	set_task_comm(tsk, "kthreadd");
+	set_task_comm(tsk, comm);
 	ignore_signals(tsk);
 	set_cpus_allowed_ptr(tsk, housekeeping_cpumask(HK_TYPE_KTHREAD));
 	set_mems_allowed(node_states[N_MEMORY]);
-- 
2.34.1


