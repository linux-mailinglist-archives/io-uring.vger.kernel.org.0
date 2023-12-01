Return-Path: <io-uring+bounces-192-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AD6858000C9
	for <lists+io-uring@lfdr.de>; Fri,  1 Dec 2023 02:00:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF8F21C20F52
	for <lists+io-uring@lfdr.de>; Fri,  1 Dec 2023 01:00:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E2C17FF;
	Fri,  1 Dec 2023 01:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cl+8NYKW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C201721;
	Thu, 30 Nov 2023 16:59:31 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id 38308e7fff4ca-2c9d1b07e79so13098431fa.1;
        Thu, 30 Nov 2023 16:59:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701392369; x=1701997169; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0TuGV0ifQMGZnom21HAA9kziS07rsoo1KgAQCU1PjLY=;
        b=Cl+8NYKWpsBfrlb3OOP6FU2ffqIm9ApRk5yZbxJWdCCDpf3L+Xydj0M522iHPb22UU
         nif0n85IosTV+lK9/kTvwCzlaMFvaZJ058o3YURsaWZJlXdSCq5tAZss1EYGS2qd0kfu
         He3lm6zyRtLjJSVBI+6yiEgi8+nAsfS2e1HDmzxh4CdPnJBDx69bwjG8f8hjM8NSXNIE
         /+E8LRUOI0dh/2D9WuhJS9j/gX+mXVMW6Mazm0NKWNJvQRVFJY9w5s0T/SzZjw8dWy/M
         Qb2abOXoAvHsYBK282oe0PcW7ZBa9C97CU9tZYNjBy5wCPjrlsJsaGf8SG6pRL92zvoT
         b1ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701392369; x=1701997169;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0TuGV0ifQMGZnom21HAA9kziS07rsoo1KgAQCU1PjLY=;
        b=VT101o66i0l7C/PK+0Vz12VYeGzFMC5ZQozZZCLH+lMtCPBDlIjDW5HyTWIGOXQl71
         xFVqUwYexcDkqWjDK3Ehrhg9v1we4TwsYqtQKsZ2X+1ah6c8C3KbekQpqGjBf2bhec79
         wevTL4AXDBX7DwWDBXJkghrdBrccwclpdHpjISFuCNJ++I5IGvk06VPjt4B/WkTMWJvI
         gx7FEzNxwPUgojelTQr+QTv3D8Fds3jVHukShzHQ99sYHtiPMIKH3z8hQbr7On7+C/pm
         2057xh46ikhk/4Af7qIRZsFE6rj4L+y8avvQbQybDy19Jw2X647XLMxzxqomUEW9h0EU
         ZtzA==
X-Gm-Message-State: AOJu0Yy/U9+8ZSSbpNIHrgosJAVCmjuPeTqyP3G3J1GOaHAX03pL2nx3
	tUUoEoKaIi93qbeGcmejqvNQLoQwm60=
X-Google-Smtp-Source: AGHT+IHZ/QIUNeOY86P9qJNJREbcGY2Fr7epDL+dBcN7m+cI5VoIXcGg7cnHIC5D5yBjxW17Y2X9GA==
X-Received: by 2002:a05:651c:14d:b0:2c9:bc5d:1a14 with SMTP id c13-20020a05651c014d00b002c9bc5d1a14mr225339ljd.27.1701392368655;
        Thu, 30 Nov 2023 16:59:28 -0800 (PST)
Received: from 127.0.0.1localhost ([185.69.145.191])
        by smtp.gmail.com with ESMTPSA id ks19-20020a170906f85300b00a11b2677acbsm1250511ejb.163.2023.11.30.16.59.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 16:59:27 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	linux-block@vger.kernel.org,
	ming.lei@redhat.com,
	joshi.k@samsung.com,
	linux-security-module@vger.kernel.org,
	selinux@vger.kernel.org,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH v2 1/3] io_uring: split out cmd api into a separate header
Date: Fri,  1 Dec 2023 00:57:35 +0000
Message-ID: <7ec50bae6e21f371d3850796e716917fc141225a.1701391955.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1701391955.git.asml.silence@gmail.com>
References: <cover.1701391955.git.asml.silence@gmail.com>
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
 MAINTAINERS                    |  1 +
 drivers/block/ublk_drv.c       |  2 +-
 drivers/nvme/host/ioctl.c      |  2 +-
 include/linux/io_uring.h       | 89 +---------------------------------
 include/linux/io_uring/cmd.h   | 81 +++++++++++++++++++++++++++++++
 include/linux/io_uring_types.h | 20 ++++++++
 io_uring/io_uring.c            |  1 +
 io_uring/rw.c                  |  2 +-
 io_uring/uring_cmd.c           |  2 +-
 security/selinux/hooks.c       |  2 +-
 security/smack/smack_lsm.c     |  2 +-
 11 files changed, 110 insertions(+), 94 deletions(-)
 create mode 100644 include/linux/io_uring/cmd.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 97f51d5ec1cf..eaa3d8a2490b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11157,6 +11157,7 @@ L:	io-uring@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.dk/linux-block
 T:	git git://git.kernel.dk/liburing
+F:	include/linux/io_uring/
 F:	include/linux/io_uring.h
 F:	include/linux/io_uring_types.h
 F:	include/trace/events/io_uring.h
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
 
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index feda711c6b7b..17ec5e109aec 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -91,7 +91,7 @@
 #include <uapi/linux/mount.h>
 #include <linux/fsnotify.h>
 #include <linux/fanotify.h>
-#include <linux/io_uring.h>
+#include <linux/io_uring/cmd.h>
 
 #include "avc.h"
 #include "objsec.h"
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 65130a791f57..2cdaa46088a0 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -42,7 +42,7 @@
 #include <linux/fs_context.h>
 #include <linux/fs_parser.h>
 #include <linux/watch_queue.h>
-#include <linux/io_uring.h>
+#include <linux/io_uring/cmd.h>
 #include "smack.h"
 
 #define TRANS_TRUE	"TRUE"
-- 
2.43.0


