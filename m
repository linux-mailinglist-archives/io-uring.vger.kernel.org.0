Return-Path: <io-uring+bounces-258-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EDE2809A11
	for <lists+io-uring@lfdr.de>; Fri,  8 Dec 2023 04:11:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AF8F01F2111C
	for <lists+io-uring@lfdr.de>; Fri,  8 Dec 2023 03:11:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A67BD20E4;
	Fri,  8 Dec 2023 03:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="qIytiEaZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38030D5B
	for <io-uring@vger.kernel.org>; Thu,  7 Dec 2023 19:11:49 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1d072f50a44so3669565ad.0
        for <io-uring@vger.kernel.org>; Thu, 07 Dec 2023 19:11:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1702005108; x=1702609908; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rgQX9qBgmn/VYQpX2SK3TteUyRcW/gaxvboc4+EPMWE=;
        b=qIytiEaZjeLawkONNjIRMww/Wtii9tTzl+hYLibnGM2l5t3QAPTE8Wxh6GhrSKVEGU
         Bq+4zXIIX3GzBR/UJ99WNDOJu7Oz68HSltMoD1wfsTThGapuONQwhmh4KNPAOLCI8hgt
         dAo1bTqbpAL5ZcVIIjSTZ+M8KV9/Lt1W14M0FSnHvIAnm0p9sagukjcEvBv0vU3jw52K
         EyC1ez+lkQxgIdpwxwfn2R6NW7P/22dNDyLmUoMC/EZ3rQ9eVkchbHNGeTmHaRandn5J
         zUrhyO4wfqa+tJgBl2t//OzZAYcDpLdErBOS7Rka2AYeaddAefEY3i+ftRQZuAiJzHlO
         6HFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702005108; x=1702609908;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rgQX9qBgmn/VYQpX2SK3TteUyRcW/gaxvboc4+EPMWE=;
        b=ja+sIhaouRRxk4Fw8lDV+I8p2a7xr8x0iayxqpc2mbbuPP9dsoSWM4DXi+FbUgbObF
         MeZEfDb+mrWtrxJeRaKIApKfpO7/ToSuCXN3ZBoVCFqSpwlDwNEf0aDzyYDL/301a+pL
         uFE4+oA0RzMOkyzurviso6tpikRzwP/iiEN4dOIcVnLlONNWeDO6eNuFVJhwBXz2BNS7
         IOW3RlBBI77IcgQj7QVUsORAGJS/e4L+XSQMQdIwNUBhCz903UVDnIcuidwGnd/Yv+n4
         jPHUoqQjnqp2HG3ZVAAK1VrXrW5jUQ4NxDLpKfWCNV/UkWTbwJzST0EMsRjf+B/1AKeI
         uwDg==
X-Gm-Message-State: AOJu0YwlFWlIPM81XzXh1TP9TnXVsaK9XD/prUgX62/08rguAzHrx1uw
	osDbbKFVeEPpax/EBQqmUwfIwEKfIC1nkryZyfMvTA==
X-Google-Smtp-Source: AGHT+IG9JkPrZUP2coIgl+o9OWa7tRRGF220SaqocG+NM/UDRsYF8xnmVjXa5+t30FNOB8R0V9tIHg==
X-Received: by 2002:a17:902:eb0a:b0:1d0:83bc:5648 with SMTP id l10-20020a170902eb0a00b001d083bc5648mr6975583plb.2.1702005107777;
        Thu, 07 Dec 2023 19:11:47 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id d11-20020a170902c18b00b001bc6e6069a6sm547842pld.122.2023.12.07.19.11.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Dec 2023 19:11:46 -0800 (PST)
Message-ID: <df0e24ff-f3a0-4818-8282-2a4e03b7b5a6@kernel.dk>
Date: Thu, 7 Dec 2023 20:11:45 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
Cc: Pavel Begunkov <asml.silence@gmail.com>,
 Christian Brauner <brauner@kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/openclose: add support for
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

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring.h |  2 ++
 io_uring/opdef.c              |  9 +++++++++
 io_uring/openclose.c          | 37 +++++++++++++++++++++++++++++++++++
 io_uring/openclose.h          |  3 +++
 4 files changed, 51 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index f1c16f817742..af82aab9e632 100644
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
index fb73adb89067..5b8f79edef26 100644
--- a/io_uring/openclose.c
+++ b/io_uring/openclose.c
@@ -31,6 +31,11 @@ struct io_close {
 	u32				file_slot;
 };
 
+struct io_fixed_install {
+	struct file			*file;
+	int				flags;
+};
+
 static bool io_openat_force_async(struct io_open *open)
 {
 	/*
@@ -254,3 +259,35 @@ int io_close(struct io_kiocb *req, unsigned int issue_flags)
 	io_req_set_res(req, ret, 0);
 	return IOU_OK;
 }
+
+int io_install_fixed_fd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_fixed_install *ifi;
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
+	/* really just O_CLOEXEC or not */
+	ifi->flags = READ_ONCE(sqe->install_fd_flags);
+	return 0;
+}
+
+int io_install_fixed_fd(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_fixed_install *ifi;
+	int ret;
+
+	ifi = io_kiocb_to_cmd(req, struct io_fixed_install);
+	ret = receive_fd(req->file, ifi->flags);
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


