Return-Path: <io-uring+bounces-274-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A463E80AF95
	for <lists+io-uring@lfdr.de>; Fri,  8 Dec 2023 23:18:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2672E1F210AA
	for <lists+io-uring@lfdr.de>; Fri,  8 Dec 2023 22:18:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D6F758ADE;
	Fri,  8 Dec 2023 22:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="1k4a4ZOK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2419E1723
	for <io-uring@vger.kernel.org>; Fri,  8 Dec 2023 14:18:48 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1d03f03cda9so4676885ad.0
        for <io-uring@vger.kernel.org>; Fri, 08 Dec 2023 14:18:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1702073927; x=1702678727; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VoMQU0dC/7e16jU3C/gAFD8bWBh4rvQiE6XpqdOBFVM=;
        b=1k4a4ZOKZwGfFUMedSaqQpVM6C1JBrlRt/jgR+GmbjkYF3Ng+JiYXkyByEqXZerGoR
         0j+ge8asScPorSdzgbj4m9p1Iq5sJoQvPVnpE2HhOiqm93E5Ma7e9nIpgHQHtBOek8Fd
         m7ti/Iq1Mx92bUC/vrLvtkq12iWYGQnnubp5dJxIMi2rynJEji5vYLUdJBWrr55O+u9V
         3LIjazpC/8AVLQL4D02RUhRGRrIYiKaB7emfWrt0n2ud0aX+EAPQ+1KQSssDcWTATdaG
         ahgCukwDO/LtQonrlAexx0PhBF1jw6vGgGEhVC3TizBEjxHy+irOn5O/rg6gVL9oG5go
         y/7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702073927; x=1702678727;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VoMQU0dC/7e16jU3C/gAFD8bWBh4rvQiE6XpqdOBFVM=;
        b=fTOCPD+r6qzM+YT8isx8xF47cJGlr9vYjmSRGExgdSkdTFHT2gfRLshx/wUK9ychzo
         VVfwvQPGMUL4awqrr4DOCYxL08DJKnwZ+k7BDRYzOXmCtvTiJKXK5aTZehb8+838x+vJ
         Q8IvxxIVRnPYkgq4F+BSuT84AJsovmIweiOWUCdsJl/v6ltQIVSXlXju0GKTfQsJTeS+
         ts4ZyjCoNsDZjU8fn5zO/fCbjQc3GqNvkeLLnE3e4dcmXv1JpsoSYZIvzXZJObN9NZUv
         MSI1zkpWlehBmnYDOGYIDveD0SzgfV6zebNDr2d+cFd5yig69xfn2/vZB/O4CPUxH1eM
         nv0g==
X-Gm-Message-State: AOJu0YwW6RHTjhIVQwPh02WSNQeHJmVRV9iSMDNHiYKPewnef9ZGnCez
	4bX3coIkGGzYHu13RtQuo/kFgJECxFSQgYMD4dVBDw==
X-Google-Smtp-Source: AGHT+IG+0S4kXzyK1MkA4blkH/toj7F8e6bA+DFYOGhYtP+OtIeKCB4Viy+JR+ET4GWiu5SUHBJC0A==
X-Received: by 2002:a17:902:db10:b0:1d0:bb65:6860 with SMTP id m16-20020a170902db1000b001d0bb656860mr1363974plx.6.1702073926720;
        Fri, 08 Dec 2023 14:18:46 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id t14-20020a1709027fce00b001cf8c062610sm2237667plb.127.2023.12.08.14.18.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Dec 2023 14:18:46 -0800 (PST)
Message-ID: <ceadeb5d-ddaa-4b18-841d-3b1f1e3a0669@kernel.dk>
Date: Fri, 8 Dec 2023 15:18:45 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
 Pavel Begunkov <asml.silence@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2] io_uring/openclose: add support for
 IORING_OP_FIXED_FD_INSTALL
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

io_uring can currently open/close regular files or fixed/direct
descriptors. Or you can instantiate a fixed descriptor from a regular
one, and then close the regular descriptor. But you currently can't turn
a purely fixed/direct descriptor into a regular file descriptor.

IORING_OP_FIXED_FD_INSTALL adds support for installing a direct
descriptor into the normal file table, just like receiving a file
descriptor or opening a new file would do. This is all nicely abstracted
into receive_fd(), and hence adding support for this is truly trivial.

Since direct descriptors are only usable within io_uring itself, it can
be useful to turn them into real file descriptors if they ever need to
be accessed via normal syscalls. This can either be a transitory thing,
or just a permanent transition for a given direct descriptor.

By default, new fds are installed with O_CLOEXEC set. The application
can disable O_CLOEXEC by setting IORING_FIXED_FD_NO_CLOEXEC in the
sqe->install_fd_flags member.

Suggested-by: Christian Brauner <brauner@kernel.org>
Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---

v2:
	- add reviewed/suggested-by
	- default to O_CLOEXEC
	- pull in vfs.misc to get new receive_fd()

Also see expanded test case here:

https://git.kernel.dk/cgit/liburing/tree/test/fd-install.c

 include/uapi/linux/io_uring.h |  9 +++++++
 io_uring/opdef.c              |  9 +++++++
 io_uring/openclose.c          | 46 +++++++++++++++++++++++++++++++++++
 io_uring/openclose.h          |  3 +++
 4 files changed, 67 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index f1c16f817742..db4b913e6b39 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -71,6 +71,7 @@ struct io_uring_sqe {
 		__u32		uring_cmd_flags;
 		__u32		waitid_flags;
 		__u32		futex_flags;
+		__u32		install_fd_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	/* pack this to avoid bogus arm OABI complaints */
@@ -253,6 +254,7 @@ enum io_uring_op {
 	IORING_OP_FUTEX_WAIT,
 	IORING_OP_FUTEX_WAKE,
 	IORING_OP_FUTEX_WAITV,
+	IORING_OP_FIXED_FD_INSTALL,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
@@ -386,6 +388,13 @@ enum {
 /* Pass through the flags from sqe->file_index to cqe->flags */
 #define IORING_MSG_RING_FLAGS_PASS	(1U << 1)
 
+/*
+ * IORING_OP_FIXED_FD_INSTALL flags (sqe->install_fd_flags)
+ *
+ * IORING_FIXED_FD_NO_CLOEXEC	Don't mark the fd as O_CLOEXEC
+ */
+#define IORING_FIXED_FD_NO_CLOEXEC	(1U << 0)
+
 /*
  * IO completion data structure (Completion Queue Entry)
  */
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 799db44283c7..6705634e5f52 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -469,6 +469,12 @@ const struct io_issue_def io_issue_defs[] = {
 		.prep			= io_eopnotsupp_prep,
 #endif
 	},
+	[IORING_OP_FIXED_FD_INSTALL] = {
+		.needs_file		= 1,
+		.audit_skip		= 1,
+		.prep			= io_install_fixed_fd_prep,
+		.issue			= io_install_fixed_fd,
+	},
 };
 
 const struct io_cold_def io_cold_defs[] = {
@@ -704,6 +710,9 @@ const struct io_cold_def io_cold_defs[] = {
 	[IORING_OP_FUTEX_WAITV] = {
 		.name			= "FUTEX_WAITV",
 	},
+	[IORING_OP_FIXED_FD_INSTALL] = {
+		.name			= "FIXED_FD_INSTALL",
+	},
 };
 
 const char *io_uring_get_opcode(u8 opcode)
diff --git a/io_uring/openclose.c b/io_uring/openclose.c
index 74fc22461f48..20efb022563d 100644
--- a/io_uring/openclose.c
+++ b/io_uring/openclose.c
@@ -31,6 +31,11 @@ struct io_close {
 	u32				file_slot;
 };
 
+struct io_fixed_install {
+	struct file			*file;
+	unsigned int			o_flags;
+};
+
 static bool io_openat_force_async(struct io_open *open)
 {
 	/*
@@ -254,3 +259,44 @@ int io_close(struct io_kiocb *req, unsigned int issue_flags)
 	io_req_set_res(req, ret, 0);
 	return IOU_OK;
 }
+
+int io_install_fixed_fd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_fixed_install *ifi;
+	unsigned int flags;
+
+	if (sqe->off || sqe->addr || sqe->len || sqe->buf_index ||
+	    sqe->splice_fd_in || sqe->addr3)
+		return -EINVAL;
+
+	/* must be a fixed file */
+	if (!(req->flags & REQ_F_FIXED_FILE))
+		return -EBADF;
+
+	ifi = io_kiocb_to_cmd(req, struct io_fixed_install);
+
+	flags = READ_ONCE(sqe->install_fd_flags);
+	if (flags & ~IORING_FIXED_FD_NO_CLOEXEC)
+		return -EINVAL;
+
+	/* default to O_CLOEXEC, disable if IORING_FIXED_FD_NO_CLOEXEC is set */
+	if (flags & IORING_FIXED_FD_NO_CLOEXEC)
+		ifi->o_flags = 0;
+	else
+		ifi->o_flags = O_CLOEXEC;
+
+	return 0;
+}
+
+int io_install_fixed_fd(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_fixed_install *ifi;
+	int ret;
+
+	ifi = io_kiocb_to_cmd(req, struct io_fixed_install);
+	ret = receive_fd(req->file, NULL, ifi->o_flags);
+	if (ret < 0)
+		req_set_fail(req);
+	io_req_set_res(req, ret, 0);
+	return IOU_OK;
+}
diff --git a/io_uring/openclose.h b/io_uring/openclose.h
index 4b1c28d3a66c..8a93c98ad0ad 100644
--- a/io_uring/openclose.h
+++ b/io_uring/openclose.h
@@ -12,3 +12,6 @@ int io_openat2(struct io_kiocb *req, unsigned int issue_flags);
 
 int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_close(struct io_kiocb *req, unsigned int issue_flags);
+
+int io_install_fixed_fd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_install_fixed_fd(struct io_kiocb *req, unsigned int issue_flags);
-- 
2.42.0

-- 
Jens Axboe


