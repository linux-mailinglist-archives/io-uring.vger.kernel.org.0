Return-Path: <io-uring+bounces-297-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F3BE4819102
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 20:44:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AFF6E2867E2
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 19:44:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DCF639851;
	Tue, 19 Dec 2023 19:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Ei9cCcpy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A6A3D0A3
	for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 19:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1d38e51cab3so10344705ad.1
        for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 11:44:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1703015051; x=1703619851; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NcJIjGxyMfVB+pIGK6Jt2srvycl4Mg1Kl+7VKXkrFHc=;
        b=Ei9cCcpyAbdts6LOHD1LyB1yY+SxjtEG/gJ1D9bSKPuyM2vlv/1wzCRuYXCE3rAnwj
         zwtYvF+1La5QWltbPa194b5wDVnNSrBQPkD5oX+ppLqdxb82G6uhdO+2H8nOed7/xfY0
         DR6jMaYB5HzxPhIuwifcjsvQUoniSziIIUvetmG+UiqMvtQp7eOb41mcfqfER6kJHmhH
         NGbEfi9y17PWKVBAMsZKXsNP/QhfmPLxfHQZi0xEYzLJvXFjri96s9JOAmrELt2YyrUY
         PxbYtX7MR4l5UDbMSDhyE1b6HeA77g2JjdBZcSIiWcVP6d30JCphFDfXdGrMF0avg6kv
         i4aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703015051; x=1703619851;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NcJIjGxyMfVB+pIGK6Jt2srvycl4Mg1Kl+7VKXkrFHc=;
        b=CU9Oq453wCsHzk8gi4vCF7AkmNPvnmoJ7FrfS1sJjrAZkfX0cmnci4aGuqAZvAJW+/
         hG6kxi62BnqIC9oXVq3O816roMFKCsVkM3xVHRVGGTlYDPm7EaMtzJGxXZST7z3XWJ4C
         s17Vf5xlEGviTy/LhFA1/oEvBmjW2oTgfBXMXAIxQchCtbaVenSx7Rt7KqkyelJiSY8A
         bFA0WBr1wXD7rtXnOx4AJQYVCcTXo9Det03DgU665Cf+Kq5FrbwedWMxO974NsKhmo/B
         D3eT+FbyV1diWJffXhj6Jj2HFOSiso+ns94SfUgBvuGv6T2qNgUcbSfqSsVfAAatzLs0
         M95Q==
X-Gm-Message-State: AOJu0YwGTKcVv09phMIziweUksItiyuXvCCy3IgpCZ5C3laXDeCo18yc
	yFFk2b1xB4LVgTdEnUenEXPCZGY1VWKWhY7uL+c1fg==
X-Google-Smtp-Source: AGHT+IHhEnxacD0NwchLanc6DzRaB8fcQcpPa0P/zMLv+OARJUlq5Qnmfy+t5KDYD4knQUa0zfSBPQ==
X-Received: by 2002:a17:902:ee14:b0:1d3:e7cc:e2a6 with SMTP id z20-20020a170902ee1400b001d3e7cce2a6mr1539675plb.0.1703015051036;
        Tue, 19 Dec 2023 11:44:11 -0800 (PST)
Received: from localhost.localdomain ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id b2-20020a170902bd4200b001d369beee67sm7083397plx.131.2023.12.19.11.44.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Dec 2023 11:44:10 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring/unix: drop usage of io_uring socket
Date: Tue, 19 Dec 2023 12:42:57 -0700
Message-ID: <20231219194401.591059-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231219194401.591059-1-axboe@kernel.dk>
References: <20231219194401.591059-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since we no longer allow sending io_uring fds over SCM_RIGHTS, move to
using io_is_uring_fops() to detect whether this is a io_uring fd or not.
With that done, kill off io_uring_get_socket() as nobody calls it
anymore.

This is in preparation to yanking out the rest of the core related to
unix gc with io_uring.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring.h | 10 +++++-----
 io_uring/io_uring.c      | 13 -------------
 io_uring/io_uring.h      |  1 -
 net/core/scm.c           |  2 +-
 net/unix/scm.c           |  4 +---
 5 files changed, 7 insertions(+), 23 deletions(-)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index d8fc93492dc5..68ed6697fece 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -7,12 +7,12 @@
 #include <uapi/linux/io_uring.h>
 
 #if defined(CONFIG_IO_URING)
-struct sock *io_uring_get_socket(struct file *file);
 void __io_uring_cancel(bool cancel_all);
 void __io_uring_free(struct task_struct *tsk);
 void io_uring_unreg_ringfd(void);
 const char *io_uring_get_opcode(u8 opcode);
 int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags);
+bool io_is_uring_fops(struct file *file);
 
 static inline void io_uring_files_cancel(void)
 {
@@ -32,10 +32,6 @@ static inline void io_uring_free(struct task_struct *tsk)
 		__io_uring_free(tsk);
 }
 #else
-static inline struct sock *io_uring_get_socket(struct file *file)
-{
-	return NULL;
-}
 static inline void io_uring_task_cancel(void)
 {
 }
@@ -54,6 +50,10 @@ static inline int io_uring_cmd_sock(struct io_uring_cmd *cmd,
 {
 	return -EOPNOTSUPP;
 }
+static inline bool io_is_uring_fops(struct file *file)
+{
+	return false;
+}
 #endif
 
 #endif
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 2b24ce692b0b..a9acccd45880 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -171,19 +171,6 @@ static struct ctl_table kernel_io_uring_disabled_table[] = {
 };
 #endif
 
-struct sock *io_uring_get_socket(struct file *file)
-{
-#if defined(CONFIG_UNIX)
-	if (io_is_uring_fops(file)) {
-		struct io_ring_ctx *ctx = file->private_data;
-
-		return ctx->ring_sock->sk;
-	}
-#endif
-	return NULL;
-}
-EXPORT_SYMBOL(io_uring_get_socket);
-
 static inline void io_submit_flush_completions(struct io_ring_ctx *ctx)
 {
 	if (!wq_list_empty(&ctx->submit_state.compl_reqs) ||
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 1112c198e516..04e33f25919c 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -44,7 +44,6 @@ struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
 			       unsigned issue_flags);
 
 void __io_req_task_work_add(struct io_kiocb *req, unsigned flags);
-bool io_is_uring_fops(struct file *file);
 bool io_alloc_async_data(struct io_kiocb *req);
 void io_req_task_queue(struct io_kiocb *req);
 void io_queue_iowq(struct io_kiocb *req, struct io_tw_state *ts_dont_use);
diff --git a/net/core/scm.c b/net/core/scm.c
index db3f7cd519c2..d0e0852a24d5 100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -105,7 +105,7 @@ static int scm_fp_copy(struct cmsghdr *cmsg, struct scm_fp_list **fplp)
 		if (fd < 0 || !(file = fget_raw(fd)))
 			return -EBADF;
 		/* don't allow io_uring files */
-		if (io_uring_get_socket(file)) {
+		if (io_is_uring_fops(file)) {
 			fput(file);
 			return -EINVAL;
 		}
diff --git a/net/unix/scm.c b/net/unix/scm.c
index 6ff628f2349f..822ce0d0d791 100644
--- a/net/unix/scm.c
+++ b/net/unix/scm.c
@@ -35,10 +35,8 @@ struct sock *unix_get_socket(struct file *filp)
 		/* PF_UNIX ? */
 		if (s && ops && ops->family == PF_UNIX)
 			u_sock = s;
-	} else {
-		/* Could be an io_uring instance */
-		u_sock = io_uring_get_socket(filp);
 	}
+
 	return u_sock;
 }
 EXPORT_SYMBOL(unix_get_socket);
-- 
2.43.0


