Return-Path: <io-uring+bounces-12623-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mHq/D6NFsGnFhgIAu9opvQ
	(envelope-from <io-uring+bounces-12623-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 17:24:03 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AA370254A8B
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 17:24:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7FE9532F106F
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 15:51:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07B0538B7B2;
	Tue, 10 Mar 2026 15:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ebSHG/Tf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585D43B6C01
	for <io-uring@vger.kernel.org>; Tue, 10 Mar 2026 15:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773157887; cv=none; b=gIDfgaKMbgOvhdPmCpPeK1yLZoEYrJmd/25/cLnGdXaMzyg3faaMX0FnLtMvaplau+UBdBuR674+rbqlf+tH+RkNqVvt9jCq+stLTdU+PUGczcyuf1wDB4W0tI8So8rNxDa7agcCNb4uV2+dcl/ksOJDMN0tpJlZXJPxu+MPd+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773157887; c=relaxed/simple;
	bh=omuPlw94HqC/C0+bhhKdlyKKmrdjUUML64pXH/0Ertk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PGN9/rBJa5EHgBXZw6+l0xyjohhrrQTFi+yyHIRh7qcBJV7g9Nv6Mg9GBJr+iKSv78FxCKDVN6tnsdUPzFswDbLfn27eMMBnpx7dNE0o+/81/kXkD9L88rwo4MXl8coCI4d8UftLpGls0RGEwre3cv2+BfZ8pf6VRv05zF8aYyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ebSHG/Tf; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4852e09e23dso29441475e9.0
        for <io-uring@vger.kernel.org>; Tue, 10 Mar 2026 08:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773157881; x=1773762681; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iFJAWIqQ0mbqgguHwVzxsSroqxLrk96F88avy9tabBs=;
        b=ebSHG/Tf39dy4ydT17iFKfde2ZR5vKjsYFuSC3yMX7WuiGOYEDyIOO4L3UGkK6sZIz
         davk+egAjjhZSSbZQAB/9777ubFTwz4ea1duzTJ9XHkp3XA9P2XUNZ/8gm1/ybvBOZAI
         lSq60wY2WA1uy/LC2z2agP9xyv9ewHV48Mc069lTGqdW+Qqbwe6/DuFbR3YD+e3q4gPZ
         Pj6eP4qPUhfSIKMC+wmqZe1RPKij+SCnR+CyFLN/XBr6UB93tKBC/r4UTtWFmUiSKJxC
         Q0x8zdq1VHDsUf9ITvqnM6nXDXo4jzxwtehoiwFnGdR6OCnbxc/p9UObLi4WMQNiPJ4R
         I1cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773157881; x=1773762681;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iFJAWIqQ0mbqgguHwVzxsSroqxLrk96F88avy9tabBs=;
        b=uBmYiNJpDw5A6CovyUb9j0fkAmYzLi6VnOWWfL3W2krbzH7loGnuGcvTn/PH0EaUnX
         2hhxnZ/6qkX+2U2gUwDPEwsbsL8XrJC/o2f3K7DwKAC+8AfJqeP+p4jtiT009pz0A6Ub
         Gj6yvwJTBJssqUwJbuft/MK/T+dCSrrWyMpteJfIEDJ0gbniUwmvZpwSGrrMqHIhE9e8
         jw0nKt46raXpkZk7vxw4dNQ8VywsEW0cKC6Pt4PHtRXKgo1wcU5KWHSlPk26ruvy4WLF
         POMcrfiGFJhPijpkf/3jwRvediR/XZZRBT60+3rdLW7uf1hMwSU6TvTGZpvZkmC/WD5A
         EvKg==
X-Gm-Message-State: AOJu0YyrBNzF186/peSFa9YPRkYgmxphCyQi/sb0tCmIKpJMBFRhmR5t
	erOHbp0UbGiL/MSr9bXdA9xwIJ1zJ4CuuCNfqLsZL6KnrR3MGmpFJ9HRRKKtmCD1rhM=
X-Gm-Gg: ATEYQzwvh8nQnBimZo4AtHfLfDvH4T3qh+JmjMsbBj0kTOE/1YXgSiXPcytiEBTRHhT
	FEDU2+0iyIACMGkYAmkCGDNbISCGjsoq+9AxM+2H9iJcoaVt42rI2IQbrTBozOLMm/j/V3Q1y4k
	c/jtvQg4fllEaRBazao2Tr057PepKD1srCTcUB/0n1rJFikjOsGdHQ33MWlPbDUHsRQSfIS2jGr
	UCFQuuzYmsm5OJK+gzo84lqbXwVWz5KNxj/QeZChpESjzDZFdx8MQle210IFBG2y2tDaEX7g14B
	JLgRE85y7+b9h8Hud97Sh4AN9U8bLco+DPBO4hscOgN4eprLXigfp2yTaJUgbCP+4qNAOOW6v75
	kgEIlcfZx7k50D6n+Y5Pfzt48Bw+PiKHEGpEJcoHk3qxCVU2RrGBprcMlSpwzH6Fy14MSFwTYUd
	wHMYDnYOSuVQKV4gnrCJmJa6lvuLlZHIhTgFOZx+15uVQCtc5DDY98GFCS
X-Received: by 2002:a05:600c:a115:b0:485:3b5b:eb8 with SMTP id 5b1f17b1804b1-4853b5b108emr107092155e9.26.1773157880698;
        Tue, 10 Mar 2026 08:51:20 -0700 (PDT)
Received: from ddp-thinkpad.tail20b0d.ts.net ([80.208.222.2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439dad8dbb3sm33637589f8f.4.2026.03.10.08.51.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 08:51:20 -0700 (PDT)
From: Daniele Di Proietto <daniele.di.proietto@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Daniele Di Proietto <daniele.di.proietto@gmail.com>
Subject: [PATCH liburing] Add support for IORING_OP_DUP
Date: Tue, 10 Mar 2026 15:51:11 +0000
Message-ID: <20260310155111.2501074-1-daniele.di.proietto@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AA370254A8B
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12623-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[kernel.dk,gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_NEQ_ENVFROM(0.00)[danielediproietto@gmail.com,io-uring@vger.kernel.org];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

The new operation duplicates an existing file (regular fd or direct
descriptor) into a specific file descriptor.

With the IOSQE_FIXED_FILE sqe flag, it's like
IORING_OP_FIXED_FD_INSTALL, but with a specific destination file
descriptor.

Without the IOSQE_FIXED_FILE sqe flag, it's like dup3().

Signed-off-by: Daniele Di Proietto <daniele.di.proietto@gmail.com>
---
 man/io_uring_enter.2            |  24 ++++
 man/io_uring_prep_dup.3         |  71 ++++++++++
 src/include/liburing.h          |   8 ++
 src/include/liburing/io_uring.h |  10 ++
 test/Makefile                   |   1 +
 test/dup.c                      | 240 ++++++++++++++++++++++++++++++++
 6 files changed, 354 insertions(+)
 create mode 100644 man/io_uring_prep_dup.3
 create mode 100644 test/dup.c

diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
index bd4f0613..105f78c4 100644
--- a/man/io_uring_enter.2
+++ b/man/io_uring_enter.2
@@ -272,6 +272,8 @@ struct io_uring_sqe {
 		__u32		futex_flags;
 		__u32		install_fd_flags;
 		__u32		nop_flags;
+		__u32		pipe_flags;
+		__u32		dup_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	/* pack this to avoid bogus arm OABI complaints */
@@ -286,7 +288,9 @@ struct io_uring_sqe {
 	union {
 		__s32	splice_fd_in;
 		__u32	file_index;
+		__u32	zcrx_ifq_idx;
 		__u32	optlen;
+		__s32	dup_new_fd;
 		struct {
 			__u16	addr_len;
 			__u16	__pad3[1];
@@ -1729,6 +1733,26 @@ for general usage details.
 
 Available since 6.19.
 
+.TP
+.B IORING_OP_DUP
+Used to duplicate a file into a specifc fd of the regular process file table.
+If
+.B IOSQE_FIXED_FILE
+is set,
+.I fd
+must contain the file index, otherwise it must contain a regular fd, similar to
+.BR dup (2) .
+The duplicated file is placed into
+.IR dup_new_fd .
+Additional flags may be passed in via
+.IR dup_flags .
+Currently supported flags are
+.BR IORING_DUP_NO_CLOEXEC ,
+which is the opposite of
+.BR O_CLOEXEC .
+
+Available since 7.1.
+
 .PP
 The
 .I flags
diff --git a/man/io_uring_prep_dup.3 b/man/io_uring_prep_dup.3
new file mode 100644
index 00000000..6e334eaa
--- /dev/null
+++ b/man/io_uring_prep_dup.3
@@ -0,0 +1,71 @@
+.TH io_uring_prep_dup 3 "February 24, 2026" "liburing-2.15" "liburing Manual"
+.SH NAME
+io_uring_prep_dup \- prepare file duplication request
+.SH SYNOPSIS
+.nf
+.B #include <liburing.h>
+.PP
+.BI "void io_uring_prep_dup(struct io_uring_sqe *" sqe ","
+.BI "                       int " oldfd ","
+.BI "                       int " newfd ","
+.BI "                       unsigned int " dup_flags ");"
+.fi
+.SH DESCRIPTION
+.PP
+The
+.BR io_uring_prep_dup (3)
+helper prepares a file duplication request. The submission queue entry
+.I sqe
+is setup to duplicate the duplicate the file
+.I oldfd
+with the specified
+.I dup_flags
+into the regular file descriptor
+.IR newfd .
+
+When the SQE flag
+.B IOSQE_FIXED_FILE
+is set,
+.I oldfd
+must be a fixed file descriptor index.
+.BR io_uring_prep_dup (3)
+behaves similarly to
+.BR io_uring_prep_fixed_fd_install (3),
+but allows specifying a specific destination fd.
+
+.I newfd
+must always be a regular file descriptor.
+
+When the SQE flag
+.B IOSQE_FIXED_FILE
+is not set, this is similar to
+.BR dup3 (2).
+
+.I dup_flags
+may be either zero, or set to
+.B IORING_DUP_NO_CLOEXEC
+to indicate that the new regular file descriptor should not be closed during
+exec. By default,
+.B O_CLOEXEC
+will be set on
+.I newfd
+otherwise. Setting this field to anything but
+those two values will result in the request being failed with
+.B -EINVAL
+in the CQE
+.I res
+field.
+
+.SH RETURN VALUE
+None
+.SH ERRORS
+The CQE
+.I res
+field will contain the result of the operation, which in this case will be the
+value of the new regular file descriptor. In case of failure, a negative value
+is returned.
+.SH SEE ALSO
+.BR io_uring_get_sqe (3),
+.BR io_uring_submit (3),
+.BR io_uring_prep_fixed_fd_install (3),
+.BR dup3 (2),
diff --git a/src/include/liburing.h b/src/include/liburing.h
index c056e71c..debf9e34 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -1688,6 +1688,14 @@ IOURINGINLINE void io_uring_prep_pipe_direct(struct io_uring_sqe *sqe, int *fds,
 	__io_uring_set_target_fixed_file(sqe, file_index);
 }
 
+IOURINGINLINE void io_uring_prep_dup(struct io_uring_sqe *sqe, int oldfd,
+				     int newfd, unsigned int flags)
+{
+	io_uring_prep_rw(IORING_OP_DUP, sqe, oldfd, 0, 0, 0);
+	sqe->dup_new_fd = newfd;
+	sqe->dup_flags = flags;
+}
+
 /* Read the kernel's SQ head index with appropriate memory ordering */
 IOURINGINLINE unsigned io_uring_load_sq_head(const struct io_uring *ring)
 	LIBURING_NOEXCEPT
diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 7a0b517b..73d616ac 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -74,6 +74,7 @@ struct io_uring_sqe {
 		__u32		install_fd_flags;
 		__u32		nop_flags;
 		__u32		pipe_flags;
+		__u32		dup_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	/* pack this to avoid bogus arm OABI complaints */
@@ -90,6 +91,7 @@ struct io_uring_sqe {
 		__u32	file_index;
 		__u32	zcrx_ifq_idx;
 		__u32	optlen;
+		__s32	dup_new_fd;
 		struct {
 			__u16	addr_len;
 			__u16	__pad3[1];
@@ -312,6 +314,7 @@ enum io_uring_op {
 	IORING_OP_PIPE,
 	IORING_OP_NOP128,
 	IORING_OP_URING_CMD128,
+	IORING_OP_DUP,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
@@ -472,6 +475,13 @@ enum io_uring_msg_ring_flags {
  */
 #define IORING_FIXED_FD_NO_CLOEXEC	(1U << 0)
 
+/*
+ * IORING_OP_DUP flags (sqe->install_fd_flags)
+ *
+ * IORING_DUP_NO_CLOEXEC	Don't mark the fd as O_CLOEXEC
+ */
+#define IORING_DUP_NO_CLOEXEC (1U << 0)
+
 /*
  * IORING_OP_NOP flags (sqe->nop_flags)
  *
diff --git a/test/Makefile b/test/Makefile
index 7b94a1f4..2960139b 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -89,6 +89,7 @@ test_srcs := \
 	defer-tw-timeout.c \
 	double-poll-crash.c \
 	drop-submit.c \
+	dup.c \
 	eeed8b54e0df.c \
 	empty-eownerdead.c \
 	eploop.c \
diff --git a/test/dup.c b/test/dup.c
new file mode 100644
index 00000000..08d11444
--- /dev/null
+++ b/test/dup.c
@@ -0,0 +1,240 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Description: test io_uring_prep_dup
+ *
+ */
+#include <errno.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <fcntl.h>
+
+#include "liburing.h"
+#include "helpers.h"
+
+struct fixture {
+	/* file descriptor of a pipe connected to fd_pipe_w */
+	int fd_pipe_r;
+	/* direct descriptor of a pipe connected to fd_pipe_w */
+	int fixed_pipe_r;
+
+	/* file descriptor of a pipe connected to fd_pipe_r and fixed_pipe_r */
+	int fd_pipe_w;
+
+	/* closed file descriptor */
+	int fd_invalid;
+	/* closed file descriptor */
+	int fd_invalid_2;
+};
+
+static int setup(struct io_uring *ring, struct fixture *fixture)
+{
+	int ret, fds[2];
+
+	if (pipe(fds) < 0) {
+		perror("pipe");
+		return T_EXIT_FAIL;
+	}
+	fixture->fd_pipe_r = fds[0];
+	fixture->fd_pipe_w = fds[1];
+	ret = io_uring_register_files(ring, &fixture->fd_pipe_r, 1);
+	if (ret) {
+		fprintf(stderr, "failed register files %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+	fixture->fixed_pipe_r = 0;
+
+	if (pipe(fds) < 0) {
+		perror("pipe");
+		return T_EXIT_FAIL;
+	}
+	close(fds[0]);
+	close(fds[1]);
+
+	fixture->fd_invalid = fds[0];
+	fixture->fd_invalid_2 = fds[1];
+
+	return T_EXIT_PASS;
+}
+
+static int are_pipes_connected(int fd_r, int fd_w)
+{
+	char buf[32];
+	int err;
+
+	err = write(fd_w, "Hello", 5);
+	if (err < 0) {
+		perror("write");
+		return T_EXIT_FAIL;
+	} else if (err != 5) {
+		fprintf(stderr, "short write %d\n", err);
+		return T_EXIT_FAIL;
+	}
+
+	err = read(fd_r, buf, sizeof(buf));
+	if (err != 5) {
+		fprintf(stderr, "unexpected read ret %d\n", err);
+		return T_EXIT_FAIL;
+	}
+
+	return T_EXIT_PASS;
+}
+
+static int cloexec_check(int fd, int nocloexec)
+{
+	int flags;
+	flags = fcntl(fd, F_GETFD, 0);
+	if (flags < 0) {
+		perror("fcntl");
+		return T_EXIT_FAIL;
+	}
+
+	if (nocloexec) {
+		return (flags & FD_CLOEXEC) ? T_EXIT_FAIL : T_EXIT_PASS;
+	} else {
+		return (flags & FD_CLOEXEC) ? T_EXIT_PASS : T_EXIT_FAIL;
+	}
+}
+
+static int test_working(struct io_uring *ring, struct fixture *fixture,
+			int fixed, int nocloexec)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	int ret, oldfd, newfd;
+
+	if (fixed) {
+		oldfd = fixture->fixed_pipe_r;
+	} else {
+		oldfd = fixture->fd_pipe_r;
+	}
+	newfd = fixture->fd_invalid;
+
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_dup(sqe, oldfd, newfd,
+			  nocloexec ? IORING_DUP_NO_CLOEXEC : 0);
+	if (fixed) {
+		sqe->flags |= IOSQE_FIXED_FILE;
+	}
+	io_uring_submit(ring);
+	ret = io_uring_wait_cqe(ring, &cqe);
+	if (ret) {
+		fprintf(stderr, "wait cqe %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+	if (cqe->res < 0) {
+		fprintf(stderr, "failed dup: %d\n", cqe->res);
+		return T_EXIT_FAIL;
+	}
+	io_uring_cqe_seen(ring, cqe);
+
+	ret = are_pipes_connected(newfd, fixture->fd_pipe_w);
+	if (ret != T_EXIT_PASS) {
+		fprintf(stderr, "dup pipes not connected\n");
+		return ret;
+	}
+	ret = cloexec_check(newfd, nocloexec);
+	if (ret != T_EXIT_PASS) {
+		fprintf(stderr, "cloexec mismatch\n");
+		return ret;
+	}
+
+	close(newfd);
+	return T_EXIT_PASS;
+}
+
+static int test_invalid_flags(struct io_uring *ring, struct fixture *fixture)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	int ret, oldfd, newfd;
+
+	oldfd = fixture->fd_pipe_r;
+	newfd = fixture->fd_invalid;
+
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_dup(sqe, oldfd, newfd, 1 << 7);
+	io_uring_submit(ring);
+	ret = io_uring_wait_cqe(ring, &cqe);
+	if (ret) {
+		fprintf(stderr, "wait cqe %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+	if (cqe->res != -EINVAL) {
+		return T_EXIT_FAIL;
+	}
+	io_uring_cqe_seen(ring, cqe);
+
+	return T_EXIT_PASS;
+}
+
+int main(int argc, char *argv[])
+{
+	struct io_uring_probe *probe;
+	struct fixture fixture;
+	struct io_uring ring;
+	int ret;
+
+	if (argc > 1)
+		return T_EXIT_SKIP;
+
+	probe = io_uring_get_probe();
+	if (!probe) {
+		return T_EXIT_SKIP;
+	}
+	if (!io_uring_opcode_supported(probe, IORING_OP_DUP)) {
+		return T_EXIT_SKIP;
+	}
+	io_uring_free_probe(probe);
+
+	ret = io_uring_queue_init(4, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "ring setup failed: %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	ret = setup(&ring, &fixture);
+	if (ret != T_EXIT_PASS) {
+		fprintf(stderr, "fixture setup failed\n");
+		return T_EXIT_FAIL;
+	}
+
+	ret = test_working(&ring, &fixture, 0, 0);
+	if (ret != T_EXIT_PASS) {
+		if (ret == T_EXIT_FAIL)
+			fprintf(stderr,
+				"test_working regular cloexec failed\n");
+		return ret;
+	}
+
+	ret = test_working(&ring, &fixture, 1, 0);
+	if (ret != T_EXIT_PASS) {
+		if (ret == T_EXIT_FAIL)
+			fprintf(stderr, "test_working fixed cloexec failed\n");
+		return ret;
+	}
+
+	ret = test_working(&ring, &fixture, 0, 1);
+	if (ret != T_EXIT_PASS) {
+		if (ret == T_EXIT_FAIL)
+			fprintf(stderr,
+				"test_working regular nocloexec failed\n");
+		return ret;
+	}
+
+	ret = test_working(&ring, &fixture, 1, 1);
+	if (ret != T_EXIT_PASS) {
+		if (ret == T_EXIT_FAIL)
+			fprintf(stderr,
+				"test_working fixed nocloexec failed\n");
+		return ret;
+	}
+
+	ret = test_invalid_flags(&ring, &fixture);
+	if (ret != T_EXIT_PASS) {
+		if (ret == T_EXIT_FAIL)
+			fprintf(stderr, "test_invalid_flags failed\n");
+		return ret;
+	}
+
+	return T_EXIT_PASS;
+}
-- 
2.43.0


