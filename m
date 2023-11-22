Return-Path: <io-uring+bounces-140-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 986F77F4BDC
	for <lists+io-uring@lfdr.de>; Wed, 22 Nov 2023 17:03:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BB5D81C20A66
	for <lists+io-uring@lfdr.de>; Wed, 22 Nov 2023 16:03:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 507BD5787D;
	Wed, 22 Nov 2023 16:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tl4Yoaw5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D781A1B9;
	Wed, 22 Nov 2023 08:02:49 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-a00ac0101d9so382976466b.0;
        Wed, 22 Nov 2023 08:02:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700668968; x=1701273768; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5dSrUq+ohe+2QxG5hUZzM2C3AjiOuQC9HjD2I4wQZ4U=;
        b=Tl4Yoaw5VZWNQwD+t+rbHbsfX3BJpNidWe6vYBgx0NDWPWo5jFm+jZ0nxOTkQxrKwG
         bnrImZOYh6w68+o2cmBrxEqc69VscODx7tCApOnsgSKL8ko8uRNicStU+OW/XzaZwUvq
         P3hzeSLaWHQ40ZlGGnvAD1TSjuY/3wlb9O9pYynk9hSqWSsbJRVBE9ZuwYGOeOJXrbbO
         D2XhNblQnHzRzwkHhHBT9e6J5UQBc4/G0sCn8ikBQyO1iE9f1yqnvCZW3OrGi9cNbCuS
         dmO3rFJZN8TzMM6h5jMbOwvS0LmjHgliHmgySPpRgn8+FvrB73gaQGLCL+FYqCjhC/mv
         79QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700668968; x=1701273768;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5dSrUq+ohe+2QxG5hUZzM2C3AjiOuQC9HjD2I4wQZ4U=;
        b=vwb0t0xf7gXte9N/w2TRoKSpB9ZjZsdb740gooQCqwME0gjVU5j3mIjeGabS0mH8O9
         ksSq4ahaN+jxZQBSWxGi/8mCLuXg5xLTr7Qj0asv+0Y+1/A0b89UNuCKtqxPylUC1fLW
         b5InNP+ZlsGnIiue0dexZY6ItsYXygCwbO1/6mTK61GMMAq1b6n5NwbU9OpbMlbsfVZy
         a/YoCWNvpE6YW7XMpQYgh1yTdrY2wunfNEQ2S62JP3TyJ/oDAFeVXw1+3eE2OVppxYTn
         upe+VV8TUbZUZyoSo4lcZ4lpPb5r61APl8JeJnME0pWyg9on56qn0xX5StoX6M6h64q1
         8JiQ==
X-Gm-Message-State: AOJu0Yz0YsnvCDnZh0QEarufsuNTnDbLPW4rgmpwu6D89GG9oEJvMTfT
	5eLl9yqcxppwy4lGhllmPLmLxi+TLYQ=
X-Google-Smtp-Source: AGHT+IEsW15KaW8QYJ4q6C6qtAKSP2U9DyVTlX09iq1I4wkEcXMFV20v+wCRwqxjp9zoulScYHPIbQ==
X-Received: by 2002:a17:906:68c9:b0:9d2:20ee:b18b with SMTP id y9-20020a17090668c900b009d220eeb18bmr735631ejr.42.1700668967478;
        Wed, 22 Nov 2023 08:02:47 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::2:fba6])
        by smtp.gmail.com with ESMTPSA id x26-20020a1709065ada00b009fd04a1a1dfsm4541805ejs.40.2023.11.22.08.02.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Nov 2023 08:02:46 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	linux-block@vger.kernel.org,
	ming.lei@redhat.com,
	joshi.k@samsung.com
Subject: [PATCH 1/3] io_uring: split out cmd api into a separate header
Date: Wed, 22 Nov 2023 16:01:09 +0000
Message-ID: <547e56560b97cd66f00bfc5b53db24f2fa1a8852.1700668641.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <cover.1700668641.git.asml.silence@gmail.com>
References: <cover.1700668641.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

linux/io_uring.h is slowly becoming a rubbish bin where we put
anything exposed to other subsystems. For instance, the task exit
hooks and io_uring cmd infra are completely orthogonal and don't need
each other's definitions. Start cleaning it up by splitting out all
command bits into a new header file.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/block/ublk_drv.c       |  2 +-
 drivers/nvme/host/ioctl.c      |  2 +-
 include/linux/io_uring.h       | 89 +---------------------------------
 include/linux/io_uring/cmd.h   | 81 +++++++++++++++++++++++++++++++
 include/linux/io_uring_types.h | 20 ++++++++
 io_uring/io_uring.c            |  1 +
 io_uring/rw.c                  |  2 +-
 io_uring/uring_cmd.c           |  2 +-
 8 files changed, 107 insertions(+), 92 deletions(-)
 create mode 100644 include/linux/io_uring/cmd.h

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 83600b45e12a..909377068a87 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -36,7 +36,7 @@
 #include <linux/sched/mm.h>
 #include <linux/uaccess.h>
 #include <linux/cdev.h>
-#include <linux/io_uring.h>
+#include <linux/io_uring/cmd.h>
 #include <linux/blk-mq.h>
 #include <linux/delay.h>
 #include <linux/mm.h>
diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 529b9954d2b8..6864a6eeee93 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -5,7 +5,7 @@
  */
 #include <linux/ptrace.h>	/* for force_successful_syscall_return */
 #include <linux/nvme_ioctl.h>
-#include <linux/io_uring.h>
+#include <linux/io_uring/cmd.h>
 #include "nvme.h"
 
 enum {
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index aefb73eeeebf..d8fc93492dc5 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -6,71 +6,13 @@
 #include <linux/xarray.h>
 #include <uapi/linux/io_uring.h>
 
-enum io_uring_cmd_flags {
-	IO_URING_F_COMPLETE_DEFER	= 1,
-	IO_URING_F_UNLOCKED		= 2,
-	/* the request is executed from poll, it should not be freed */
-	IO_URING_F_MULTISHOT		= 4,
-	/* executed by io-wq */
-	IO_URING_F_IOWQ			= 8,
-	/* int's last bit, sign checks are usually faster than a bit test */
-	IO_URING_F_NONBLOCK		= INT_MIN,
-
-	/* ctx state flags, for URING_CMD */
-	IO_URING_F_SQE128		= (1 << 8),
-	IO_URING_F_CQE32		= (1 << 9),
-	IO_URING_F_IOPOLL		= (1 << 10),
-
-	/* set when uring wants to cancel a previously issued command */
-	IO_URING_F_CANCEL		= (1 << 11),
-	IO_URING_F_COMPAT		= (1 << 12),
-};
-
-/* only top 8 bits of sqe->uring_cmd_flags for kernel internal use */
-#define IORING_URING_CMD_CANCELABLE	(1U << 30)
-#define IORING_URING_CMD_POLLED		(1U << 31)
-
-struct io_uring_cmd {
-	struct file	*file;
-	const struct io_uring_sqe *sqe;
-	union {
-		/* callback to defer completions to task context */
-		void (*task_work_cb)(struct io_uring_cmd *cmd, unsigned);
-		/* used for polled completion */
-		void *cookie;
-	};
-	u32		cmd_op;
-	u32		flags;
-	u8		pdu[32]; /* available inline for free use */
-};
-
-static inline const void *io_uring_sqe_cmd(const struct io_uring_sqe *sqe)
-{
-	return sqe->cmd;
-}
-
 #if defined(CONFIG_IO_URING)
-int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
-			      struct iov_iter *iter, void *ioucmd);
-void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret, ssize_t res2,
-			unsigned issue_flags);
 struct sock *io_uring_get_socket(struct file *file);
 void __io_uring_cancel(bool cancel_all);
 void __io_uring_free(struct task_struct *tsk);
 void io_uring_unreg_ringfd(void);
 const char *io_uring_get_opcode(u8 opcode);
-void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
-			    void (*task_work_cb)(struct io_uring_cmd *, unsigned),
-			    unsigned flags);
-/* users should follow semantics of IOU_F_TWQ_LAZY_WAKE */
-void io_uring_cmd_do_in_task_lazy(struct io_uring_cmd *ioucmd,
-			void (*task_work_cb)(struct io_uring_cmd *, unsigned));
-
-static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
-			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
-{
-	__io_uring_cmd_do_in_task(ioucmd, task_work_cb, 0);
-}
+int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags);
 
 static inline void io_uring_files_cancel(void)
 {
@@ -89,28 +31,7 @@ static inline void io_uring_free(struct task_struct *tsk)
 	if (tsk->io_uring)
 		__io_uring_free(tsk);
 }
-int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags);
-void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
-		unsigned int issue_flags);
-struct task_struct *io_uring_cmd_get_task(struct io_uring_cmd *cmd);
 #else
-static inline int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
-			      struct iov_iter *iter, void *ioucmd)
-{
-	return -EOPNOTSUPP;
-}
-static inline void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret,
-		ssize_t ret2, unsigned issue_flags)
-{
-}
-static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
-			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
-{
-}
-static inline void io_uring_cmd_do_in_task_lazy(struct io_uring_cmd *ioucmd,
-			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
-{
-}
 static inline struct sock *io_uring_get_socket(struct file *file)
 {
 	return NULL;
@@ -133,14 +54,6 @@ static inline int io_uring_cmd_sock(struct io_uring_cmd *cmd,
 {
 	return -EOPNOTSUPP;
 }
-static inline void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
-		unsigned int issue_flags)
-{
-}
-static inline struct task_struct *io_uring_cmd_get_task(struct io_uring_cmd *cmd)
-{
-	return NULL;
-}
 #endif
 
 #endif
diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
new file mode 100644
index 000000000000..62fcfaf6fcc9
--- /dev/null
+++ b/include/linux/io_uring/cmd.h
@@ -0,0 +1,81 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _LINUX_IO_URING_CMD_H
+#define _LINUX_IO_URING_CMD_H
+
+#include <uapi/linux/io_uring.h>
+#include <linux/io_uring_types.h>
+
+/* only top 8 bits of sqe->uring_cmd_flags for kernel internal use */
+#define IORING_URING_CMD_CANCELABLE	(1U << 30)
+#define IORING_URING_CMD_POLLED		(1U << 31)
+
+struct io_uring_cmd {
+	struct file	*file;
+	const struct io_uring_sqe *sqe;
+	union {
+		/* callback to defer completions to task context */
+		void (*task_work_cb)(struct io_uring_cmd *cmd, unsigned);
+		/* used for polled completion */
+		void *cookie;
+	};
+	u32		cmd_op;
+	u32		flags;
+	u8		pdu[32]; /* available inline for free use */
+};
+
+static inline const void *io_uring_sqe_cmd(const struct io_uring_sqe *sqe)
+{
+	return sqe->cmd;
+}
+
+#if defined(CONFIG_IO_URING)
+int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
+			      struct iov_iter *iter, void *ioucmd);
+void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret, ssize_t res2,
+			unsigned issue_flags);
+void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
+			    void (*task_work_cb)(struct io_uring_cmd *, unsigned),
+			    unsigned flags);
+/* users should follow semantics of IOU_F_TWQ_LAZY_WAKE */
+void io_uring_cmd_do_in_task_lazy(struct io_uring_cmd *ioucmd,
+			void (*task_work_cb)(struct io_uring_cmd *, unsigned));
+
+static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
+			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
+{
+	__io_uring_cmd_do_in_task(ioucmd, task_work_cb, 0);
+}
+
+void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
+		unsigned int issue_flags);
+struct task_struct *io_uring_cmd_get_task(struct io_uring_cmd *cmd);
+
+#else
+static inline int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
+			      struct iov_iter *iter, void *ioucmd)
+{
+	return -EOPNOTSUPP;
+}
+static inline void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret,
+		ssize_t ret2, unsigned issue_flags)
+{
+}
+static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
+			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
+{
+}
+static inline void io_uring_cmd_do_in_task_lazy(struct io_uring_cmd *ioucmd,
+			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
+{
+}
+static inline void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
+		unsigned int issue_flags)
+{
+}
+static inline struct task_struct *io_uring_cmd_get_task(struct io_uring_cmd *cmd)
+{
+	return NULL;
+}
+#endif
+
+#endif /* _LINUX_IO_URING_CMD_H */
diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index d3009d56af0b..0bcecb734af3 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -7,6 +7,26 @@
 #include <linux/llist.h>
 #include <uapi/linux/io_uring.h>
 
+enum io_uring_cmd_flags {
+	IO_URING_F_COMPLETE_DEFER	= 1,
+	IO_URING_F_UNLOCKED		= 2,
+	/* the request is executed from poll, it should not be freed */
+	IO_URING_F_MULTISHOT		= 4,
+	/* executed by io-wq */
+	IO_URING_F_IOWQ			= 8,
+	/* int's last bit, sign checks are usually faster than a bit test */
+	IO_URING_F_NONBLOCK		= INT_MIN,
+
+	/* ctx state flags, for URING_CMD */
+	IO_URING_F_SQE128		= (1 << 8),
+	IO_URING_F_CQE32		= (1 << 9),
+	IO_URING_F_IOPOLL		= (1 << 10),
+
+	/* set when uring wants to cancel a previously issued command */
+	IO_URING_F_CANCEL		= (1 << 11),
+	IO_URING_F_COMPAT		= (1 << 12),
+};
+
 struct io_wq_work_node {
 	struct io_wq_work_node *next;
 };
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ed254076c723..6ffd7216393b 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -70,6 +70,7 @@
 #include <linux/fadvise.h>
 #include <linux/task_work.h>
 #include <linux/io_uring.h>
+#include <linux/io_uring/cmd.h>
 #include <linux/audit.h>
 #include <linux/security.h>
 #include <asm/shmparam.h>
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 64390d4e20c1..4943d683508b 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -10,7 +10,7 @@
 #include <linux/poll.h>
 #include <linux/nospec.h>
 #include <linux/compat.h>
-#include <linux/io_uring.h>
+#include <linux/io_uring/cmd.h>
 
 #include <uapi/linux/io_uring.h>
 
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index acbc2924ecd2..4ed0c66e3aae 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -2,7 +2,7 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/file.h>
-#include <linux/io_uring.h>
+#include <linux/io_uring/cmd.h>
 #include <linux/security.h>
 #include <linux/nospec.h>
 
-- 
2.42.1


