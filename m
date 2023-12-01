Return-Path: <io-uring+bounces-189-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C0938000BE
	for <lists+io-uring@lfdr.de>; Fri,  1 Dec 2023 02:00:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 38580281520
	for <lists+io-uring@lfdr.de>; Fri,  1 Dec 2023 01:00:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D70010E5;
	Fri,  1 Dec 2023 01:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CZ5WmVb6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3002B171D;
	Thu, 30 Nov 2023 16:59:32 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id 38308e7fff4ca-2c9d4740e1cso12074731fa.1;
        Thu, 30 Nov 2023 16:59:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701392370; x=1701997170; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QmhVSg59KnuTjEpkqtsVamEUiD5Q79qxS4NrNhYjt80=;
        b=CZ5WmVb62J6aZEAHXVY1ikaAD8eaFaKbc/4H+vST/9XGDPzCeNGb/aChpx+YPWfHDC
         Xj0+EAZ3uKwe3GvQjcJjCqzbbe1+MiZZhPMyW0g9CjbDMWRSE7NO0G+BykDvysvJKIVE
         91iwAC/2PCz4MgTmzc6JsJQTmftnF/DRBMUmOJW7z7tqPXA15MUcehd9RAzvHi1uPqby
         PmPfFGkbxZi8pZJM3qypt5Z8bixDY1QvxkN78aRchjxwuHrzJqjT7s2oMBMfTirBeu7c
         dh55yUms4PecAnoBGoTM8zE0jZDaUyAD+uBa3+bo8H3HuVBtU8uC5rVhW8WzZ7LuWXhF
         e4FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701392370; x=1701997170;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QmhVSg59KnuTjEpkqtsVamEUiD5Q79qxS4NrNhYjt80=;
        b=kmQ6IJOLXvRw3EJsMV0mDldnQww+sYl0cwwJkBo1QvY9fPPe8c8zf9nDqPn4+FhpA/
         vVJcTeZg/5YqUJmJZOlQSz7OaXCgrloIZ1bol9JDnD7zYlFOJiYU8YCwjkLxu18s1mtV
         1d3JRm4XIw7KfjssT3wAh5YzTUPJAF/G6qFF7+xqC6zrrfMKQV5wV6nRtKXytkZPVcQq
         zGnzWKa3Dxis/jYi5Ie3498Z4Jub7Pb1SseRACkx5VaTXGYOBtmOBthQkvE0eRGG81ck
         w+benhP6kOH/OcM70P78HPpU4BaDybXzVRdZy4g1u8qDya0qKYNurGC9f/oFXZqabo3L
         XLJA==
X-Gm-Message-State: AOJu0Yw6maDPCGuXt4CbFe+w+BTcR0W5E0Adwl85AztYFsHZUeai61Ac
	3ndGbMy+fUlspIOxGFgn15ZXDv+YkDY=
X-Google-Smtp-Source: AGHT+IFhwTksU6dn/WHUnR2RoFhnlXair9hraJjUZcVNlXwb44nFIKJF0plmfx4cVZ1n9AGHLTjlrg==
X-Received: by 2002:a2e:360a:0:b0:2c9:dae6:4446 with SMTP id d10-20020a2e360a000000b002c9dae64446mr78866lja.200.1701392369793;
        Thu, 30 Nov 2023 16:59:29 -0800 (PST)
Received: from 127.0.0.1localhost ([185.69.145.191])
        by smtp.gmail.com with ESMTPSA id ks19-20020a170906f85300b00a11b2677acbsm1250511ejb.163.2023.11.30.16.59.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 16:59:29 -0800 (PST)
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
Subject: [PATCH v2 2/3] io_uring/cmd: inline io_uring_cmd_do_in_task_lazy
Date: Fri,  1 Dec 2023 00:57:36 +0000
Message-ID: <2ec9fb31dd192d1c5cf26d0a2dec5657d88a8e48.1701391955.git.asml.silence@gmail.com>
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

Now as we can easily include io_uring_types.h, move IOU_F_TWQ_LAZY_WAKE
and inline io_uring_cmd_do_in_task_lazy().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring/cmd.h   | 31 ++++++++++++++++---------------
 include/linux/io_uring_types.h | 11 +++++++++++
 io_uring/io_uring.h            | 10 ----------
 io_uring/uring_cmd.c           |  7 -------
 4 files changed, 27 insertions(+), 32 deletions(-)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 62fcfaf6fcc9..ee9b3bc3a4af 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -36,15 +36,6 @@ void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret, ssize_t res2,
 void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
 			    void (*task_work_cb)(struct io_uring_cmd *, unsigned),
 			    unsigned flags);
-/* users should follow semantics of IOU_F_TWQ_LAZY_WAKE */
-void io_uring_cmd_do_in_task_lazy(struct io_uring_cmd *ioucmd,
-			void (*task_work_cb)(struct io_uring_cmd *, unsigned));
-
-static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
-			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
-{
-	__io_uring_cmd_do_in_task(ioucmd, task_work_cb, 0);
-}
 
 void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
 		unsigned int issue_flags);
@@ -60,12 +51,9 @@ static inline void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret,
 		ssize_t ret2, unsigned issue_flags)
 {
 }
-static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
-			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
-{
-}
-static inline void io_uring_cmd_do_in_task_lazy(struct io_uring_cmd *ioucmd,
-			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
+static inline void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
+			    void (*task_work_cb)(struct io_uring_cmd *, unsigned),
+			    unsigned flags)
 {
 }
 static inline void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
@@ -78,4 +66,17 @@ static inline struct task_struct *io_uring_cmd_get_task(struct io_uring_cmd *cmd
 }
 #endif
 
+/* users must follow the IOU_F_TWQ_LAZY_WAKE semantics */
+static inline void io_uring_cmd_do_in_task_lazy(struct io_uring_cmd *ioucmd,
+			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
+{
+	__io_uring_cmd_do_in_task(ioucmd, task_work_cb, IOU_F_TWQ_LAZY_WAKE);
+}
+
+static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
+			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
+{
+	__io_uring_cmd_do_in_task(ioucmd, task_work_cb, 0);
+}
+
 #endif /* _LINUX_IO_URING_CMD_H */
diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 0bcecb734af3..8ff4642dc6e3 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -7,6 +7,17 @@
 #include <linux/llist.h>
 #include <uapi/linux/io_uring.h>
 
+enum {
+	/*
+	 * A hint to not wake right away but delay until there are enough of
+	 * tw's queued to match the number of CQEs the task is waiting for.
+	 *
+	 * Must not be used wirh requests generating more than one CQE.
+	 * It's also ignored unless IORING_SETUP_DEFER_TASKRUN is set.
+	 */
+	IOU_F_TWQ_LAZY_WAKE			= 1,
+};
+
 enum io_uring_cmd_flags {
 	IO_URING_F_COMPLETE_DEFER	= 1,
 	IO_URING_F_UNLOCKED		= 2,
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index dc6d779b452b..48ffdb156f73 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -15,16 +15,6 @@
 #include <trace/events/io_uring.h>
 #endif
 
-enum {
-	/*
-	 * A hint to not wake right away but delay until there are enough of
-	 * tw's queued to match the number of CQEs the task is waiting for.
-	 *
-	 * Must not be used wirh requests generating more than one CQE.
-	 * It's also ignored unless IORING_SETUP_DEFER_TASKRUN is set.
-	 */
-	IOU_F_TWQ_LAZY_WAKE			= 1,
-};
 
 enum {
 	IOU_OK			= 0,
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 4ed0c66e3aae..94e9de1c24aa 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -78,13 +78,6 @@ void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
 }
 EXPORT_SYMBOL_GPL(__io_uring_cmd_do_in_task);
 
-void io_uring_cmd_do_in_task_lazy(struct io_uring_cmd *ioucmd,
-			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
-{
-	__io_uring_cmd_do_in_task(ioucmd, task_work_cb, IOU_F_TWQ_LAZY_WAKE);
-}
-EXPORT_SYMBOL_GPL(io_uring_cmd_do_in_task_lazy);
-
 static inline void io_req_set_cqe32_extra(struct io_kiocb *req,
 					  u64 extra1, u64 extra2)
 {
-- 
2.43.0


