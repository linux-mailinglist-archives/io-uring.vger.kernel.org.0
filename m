Return-Path: <io-uring+bounces-7433-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D281BA812B9
	for <lists+io-uring@lfdr.de>; Tue,  8 Apr 2025 18:45:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8BF1D1882C65
	for <lists+io-uring@lfdr.de>; Tue,  8 Apr 2025 16:46:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3E3622FAD4;
	Tue,  8 Apr 2025 16:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="mVgS8cav"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C604422ACE3
	for <io-uring@vger.kernel.org>; Tue,  8 Apr 2025 16:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744130746; cv=none; b=Rfp9IPyvNuscFOySLH3Ad+Yhovn6qdS+qaj+MCumHGdDr3lL81QBUNoidcxRXlya/ndE9pAWI3KyG8ubZLc1ZhOAsSgXKl9Gys9dtzn0vUlbWemv7InfCoZe3Vk0+wBwyUiQC50J1Dr/O7SPbBn5g9OiAApCbWzzw1NIkcseepE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744130746; c=relaxed/simple;
	bh=6IkMnC+3c3s0F0p3oWToGaeROc2suAE6HuFOHw7LtyI=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=eh0wDGlsOKkHArvdmTb1RLVV3I2noMdcKPT0/oe2XMOt52fJW0pslcgUKC1EJQOWNLmIXpX2/Z/uvMNvpY4uAJApmliBC0t43HY+H26nFu2HGf3faDz/F8QjmpjMPf9bbiAgzRjFOzzvKraCzvUClcscdMkbEi7k0WnzfLw9JVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=mVgS8cav; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-85e751cffbeso449283139f.0
        for <io-uring@vger.kernel.org>; Tue, 08 Apr 2025 09:45:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1744130741; x=1744735541; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=efa2n046kXBjx5lGK///lUP4SKY46XQmnVMmonbr9Mo=;
        b=mVgS8cavtxPRuIne2oufe/sQU9F/9TXNXcH/gUTnkiq5ANwINFx7MYxRsHgrfTQ3Ru
         av/G9dgpcihouXdqHglTYiA5f7nVpNLZKCxLMDU/9zAtsorlrL+VDGQa47SU9gNJBUJ7
         8892IvMloBSluC1gohKvDFEy+4cjrKsipIS0oRb5QB9n+yZZOHoEq8uaLCTBksi64nRQ
         qGSaId9CsPfu8FGc93FuVsR7oftaJURSW/oLFbmEU9B5upVl8D7XWGPMrkoFij/QakY3
         X8i04pcNhxMJZeXfPdUDMqzgRNFO8726lPOeCuWx/lOfBfqy5OO7ka3Xlt4V6vYuB0po
         Njug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744130741; x=1744735541;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=efa2n046kXBjx5lGK///lUP4SKY46XQmnVMmonbr9Mo=;
        b=hL2DYilfTK3fv/qSC33m+r8tY8qW2iNhCMZMs0408r6lz9x0ooGsUzxG0SclcDgIEN
         o4NBO3nBqI7uS1uJr4TdOvWiYwNW+RSMdcsjGo4/F2pzZw+5D/IpCE5tWovjIIv+yIRQ
         emw+aP4mwSD4kxF+KntxJtVBvjhmGGBnyIG2mOcCzeKeaV+J4dcnrUMzefZLaUxOQF9m
         Zgos1RHpkfcb9QlRNgjRLhUu/7M+U3UkbRufg2YT6ld4SYEy9aVOSPfByziTS0HGb+cK
         257DFg0bWsUjvag00X1f9Rf9rA9qKeRs51jCazCk/Yrrql8nb2cFRD6Mniul2tLsctOf
         oZVw==
X-Gm-Message-State: AOJu0YyBeBWzCih/NpsY+nUEg8o82d6N81/6FdfVO3Mm7slnq89SOHi8
	PnEncZrSNBhdcPHxrLcVffgz8ljtIbNebObxzcxW0bHpEqJ6OG2shW/C0A3tg7CR9utoxd8tUYy
	h
X-Gm-Gg: ASbGnctnOha54lmJykgMBpXN94IU8BQgZOVoND8yBSZsHsDEaGqUxdDwglRsZckFIKq
	6gfNDQhda0MV+6nVy8AzVK8n2pUqpxFKZ1d1fWz14hSle/JL9PHhNfiWDTSE/sPS9kCG6/0ExbO
	0N0JrIoA+MsGGHeT/MWnLYB3EMRB0eJhu4JjSLULp8wXPNhgOgseo4YhkiSEwcgJDJtfB7l7ygh
	g9jOz9UaPkncGEmlg88vxiDTt8x99lx07CSWN6EbIgvCyrt29bc6LaATEcEXC9/qtXAmWGKmm2F
	mGej87J8G2gRFcm6R2xR6zTnAds3DQ9bGrS1Gpzk
X-Google-Smtp-Source: AGHT+IGCsyEuNEP44MoGo4BtaaTVek3l/k3V5+bjMVEPMXsJGdKxQTxhbMgUuAK/VahXsk2y0FpY5g==
X-Received: by 2002:a05:6602:728b:b0:85b:5869:b6a with SMTP id ca18e2360f4ac-8611b3d63a2mr1992937439f.3.1744130741267;
        Tue, 08 Apr 2025 09:45:41 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f4f44e28ccsm569718173.130.2025.04.08.09.45.40
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Apr 2025 09:45:40 -0700 (PDT)
Message-ID: <0d00a292-4aab-4554-8bbc-cfdd852f9988@kernel.dk>
Date: Tue, 8 Apr 2025 10:45:39 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: add support for IORING_OP_PIPE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

This works just like pipe2(2), except it also supports fixed file
descriptors. Used in a similar fashion as for other fd instantiating
opcodes (like accept, socket, open, etc), where sqe->file_slot is set
appropriately if two direct descriptors are desired rather than a set
of normal file descriptors.

sqe->addr must be set to a pointer to an array of 2 integers, which
is where the fixed/normal file descriptors are copied to.

sqe->pipe_flags contains flags, same as what is allowed for pipe2(2).

Future expansion of per-op private flags can go in sqe->ioprio,
like we do for other opcodes that take both a "syscall" flag set and
an io_uring opcode specific flag set.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index ed2beb4def3f..431c156f9fe8 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -73,6 +73,7 @@ struct io_uring_sqe {
 		__u32		futex_flags;
 		__u32		install_fd_flags;
 		__u32		nop_flags;
+		__u32		pipe_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	/* pack this to avoid bogus arm OABI complaints */
@@ -283,6 +284,7 @@ enum io_uring_op {
 	IORING_OP_EPOLL_WAIT,
 	IORING_OP_READV_FIXED,
 	IORING_OP_WRITEV_FIXED,
+	IORING_OP_PIPE,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 489384c0438b..db36433c2294 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -569,6 +569,10 @@ const struct io_issue_def io_issue_defs[] = {
 		.prep			= io_prep_writev_fixed,
 		.issue			= io_write,
 	},
+	[IORING_OP_PIPE] = {
+		.prep			= io_pipe_prep,
+		.issue			= io_pipe,
+	},
 };
 
 const struct io_cold_def io_cold_defs[] = {
@@ -815,6 +819,9 @@ const struct io_cold_def io_cold_defs[] = {
 		.cleanup		= io_readv_writev_cleanup,
 		.fail			= io_rw_fail,
 	},
+	[IORING_OP_PIPE] = {
+		.name			= "PIPE",
+	},
 };
 
 const char *io_uring_get_opcode(u8 opcode)
diff --git a/io_uring/openclose.c b/io_uring/openclose.c
index e3357dfa14ca..4dd461163457 100644
--- a/io_uring/openclose.c
+++ b/io_uring/openclose.c
@@ -6,6 +6,8 @@
 #include <linux/fdtable.h>
 #include <linux/fsnotify.h>
 #include <linux/namei.h>
+#include <linux/pipe_fs_i.h>
+#include <linux/watch_queue.h>
 #include <linux/io_uring.h>
 
 #include <uapi/linux/io_uring.h>
@@ -302,3 +304,134 @@ int io_install_fixed_fd(struct io_kiocb *req, unsigned int issue_flags)
 	io_req_set_res(req, ret, 0);
 	return IOU_OK;
 }
+
+struct io_pipe {
+	struct file *file;
+	int __user *fds;
+	int flags;
+	int file_slot;
+	unsigned long nofile;
+};
+
+int io_pipe_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_pipe *p = io_kiocb_to_cmd(req, struct io_pipe);
+
+	if (sqe->fd || sqe->off || sqe->addr3)
+		return -EINVAL;
+
+	p->fds = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	p->flags = READ_ONCE(sqe->pipe_flags);
+	if (p->flags & ~(O_CLOEXEC | O_NONBLOCK | O_DIRECT | O_NOTIFICATION_PIPE))
+		return -EINVAL;
+
+	p->file_slot = READ_ONCE(sqe->file_index);
+	p->nofile = rlimit(RLIMIT_NOFILE);
+	return 0;
+}
+
+static int io_pipe_fixed(struct io_kiocb *req, struct file **files,
+			 unsigned int issue_flags)
+{
+	struct io_pipe *p = io_kiocb_to_cmd(req, struct io_pipe);
+	struct io_ring_ctx *ctx = req->ctx;
+	int ret, fds[2] = { -1, -1 };
+	int slot = p->file_slot;
+
+	if (p->flags & O_CLOEXEC)
+		return -EINVAL;
+
+	io_ring_submit_lock(ctx, issue_flags);
+
+	ret = __io_fixed_fd_install(ctx, files[0], slot);
+	if (ret < 0)
+		goto err;
+	fds[0] = ret;
+	files[0] = NULL;
+
+	/*
+	 * If a specific slot is given, next one will be used for
+	 * the write side.
+	 */
+	if (slot != IORING_FILE_INDEX_ALLOC)
+		slot++;
+
+	ret = __io_fixed_fd_install(ctx, files[1], slot);
+	if (ret < 0)
+		goto err;
+	fds[1] = ret;
+	files[1] = NULL;
+
+	io_ring_submit_unlock(ctx, issue_flags);
+
+	if (!copy_to_user(p->fds, fds, sizeof(fds)))
+		return 0;
+
+	ret = -EFAULT;
+	io_ring_submit_lock(ctx, issue_flags);
+err:
+	if (fds[0] != -1)
+		io_fixed_fd_remove(ctx, fds[0]);
+	if (fds[1] != -1)
+		io_fixed_fd_remove(ctx, fds[1]);
+	io_ring_submit_unlock(ctx, issue_flags);
+	return ret;
+}
+
+static int io_pipe_fd(struct io_kiocb *req, struct file **files)
+{
+	struct io_pipe *p = io_kiocb_to_cmd(req, struct io_pipe);
+	int ret, fds[2] = { -1, -1 };
+
+	ret = __get_unused_fd_flags(p->flags, p->nofile);
+	if (ret < 0)
+		goto err;
+	fds[0] = ret;
+
+	ret = __get_unused_fd_flags(p->flags, p->nofile);
+	if (ret < 0)
+		goto err;
+	fds[1] = ret;
+
+	if (!copy_to_user(p->fds, fds, sizeof(fds))) {
+		fd_install(fds[0], files[0]);
+		fd_install(fds[1], files[1]);
+		return 0;
+	}
+	ret = -EFAULT;
+err:
+	if (fds[0] != -1)
+		put_unused_fd(fds[0]);
+	if (fds[1] != -1)
+		put_unused_fd(fds[1]);
+	return ret;
+}
+
+int io_pipe(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_pipe *p = io_kiocb_to_cmd(req, struct io_pipe);
+	struct file *files[2];
+	int ret;
+
+	ret = create_pipe_files(files, p->flags);
+	if (ret)
+		return ret;
+	files[0]->f_mode |= FMODE_NOWAIT;
+	files[1]->f_mode |= FMODE_NOWAIT;
+
+	if (!!p->file_slot)
+		ret = io_pipe_fixed(req, files, issue_flags);
+	else
+		ret = io_pipe_fd(req, files);
+
+	io_req_set_res(req, ret, 0);
+	if (!ret)
+		return IOU_OK;
+
+	req_set_fail(req);
+	if (files[0])
+		fput(files[0]);
+	if (files[1])
+		fput(files[1]);
+	return ret;
+}
diff --git a/io_uring/openclose.h b/io_uring/openclose.h
index 8a93c98ad0ad..4ca2a9935abc 100644
--- a/io_uring/openclose.h
+++ b/io_uring/openclose.h
@@ -13,5 +13,8 @@ int io_openat2(struct io_kiocb *req, unsigned int issue_flags);
 int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_close(struct io_kiocb *req, unsigned int issue_flags);
 
+int io_pipe_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_pipe(struct io_kiocb *req, unsigned int issue_flags);
+
 int io_install_fixed_fd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_install_fixed_fd(struct io_kiocb *req, unsigned int issue_flags);

-- 
Jens Axboe


