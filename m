Return-Path: <io-uring+bounces-12767-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0BnwFseSvWnY+wIAu9opvQ
	(envelope-from <io-uring+bounces-12767-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 20 Mar 2026 19:32:39 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CE2992DF76A
	for <lists+io-uring@lfdr.de>; Fri, 20 Mar 2026 19:32:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 739EB3034319
	for <lists+io-uring@lfdr.de>; Fri, 20 Mar 2026 18:29:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79AD53E714F;
	Fri, 20 Mar 2026 18:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LJk+ksqm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8383C1971
	for <io-uring@vger.kernel.org>; Fri, 20 Mar 2026 18:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774031344; cv=none; b=qdWjOVP5Ksu8ZbMWGq5INplH7OgncIzrTYufCJjzprLNd8ISCi73rCOH20+yXtOzHwBNqW4RcR6YKwBqUjAVP5e6rrG9vPD35wmutlR2TPXx9BOkuAE0/dyFiccgien7Eui96Te/EyvX9551vSOFs0KfvcXEMnfkwjyJmnOs52c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774031344; c=relaxed/simple;
	bh=q0VItVySh1/u9tDdJXsQK6heHBgFsIaZP8pqcT5Euqw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XIIH3yvuZU+/socjG+Vj8A8oQWy0A8R9NCFdsrT2+ke69RZwiEqmzK3iF7wDrKn2I8o4ysV36PJgb8ZVi5lSR9Kldt87vzAYIEj7CaUIk2yqhiGVq07hRKViw7Sdu15FUk6NaNmUDq66PoCIIzYBTBcaJdllVIeouiI81owvFts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LJk+ksqm; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4852c9b4158so16593905e9.0
        for <io-uring@vger.kernel.org>; Fri, 20 Mar 2026 11:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774031340; x=1774636140; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1MyxcMH992rrfvmVhMVZjas0DVO2DOtdJRSUX6o8Tw0=;
        b=LJk+ksqmsVQzn+HtnXYrjwNMpt6p0X1u/lyvK4P4vbFsgdJ7B9+vn+ctcaU61VZoPj
         ynxxKih6D0kmB1bY83NDgmpTrHLPrONsDu8zYXo2VMu9O+OGngVCc75jMDtYJk+1Ihlz
         qothYbIT8DD9MSPHUlT5DHrksva1q6tbmFh7IId7JTg1r8d2SyFI7r78LA7DnjludYDR
         b+aBRzA6rR5gt6PI5jwaYbDfMxQQZq33TTAa119M1trnGpp+rv2LIJ4cR3r9g4LsrlrF
         WsBESVtp9I9GmGFToL81eJ39wkYwcNby24wost8AHjOzc1XVXfILO843K1BSX/ISTFm/
         bmQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774031340; x=1774636140;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1MyxcMH992rrfvmVhMVZjas0DVO2DOtdJRSUX6o8Tw0=;
        b=Y0++94Z7QXcJ3EahJjCjwIboGKqpjpoHN3ytqLGZxL2TcnSwTHAJe7yw+ia8HMJNiG
         pYwZ2NHl/VBXTNfPo3D0YUt2gjSQP/v3kNvIlXYp4/VQCFxgBR7exEtyaqTI59iWSNXd
         vu/MhHdvA/SRtER6MVD0IamQT5Q6Jij9IHE8AL66Nb6iOoWnz3mmCOdhRVemQJ8UMqFD
         MFJcQc+3Nmhvg0W5YiXwoVef7VXblb6yVWOkCwy70N1hS4AWXDEg9Jpq9kQcvO3+eC80
         leJ1QVFoFdc20DPnOYj7CZNtn67u4CXHuZINji27Pd9K75/0aiJGF5SNxWw3E1OocdP1
         X4+g==
X-Gm-Message-State: AOJu0YxKSpEV1//E2+8Mke4F+RkvgIlQr9qaAaabxzgbOQ0PWADn9yKA
	6pzusU3+48bYdYjnFv3zOn0uAiHbDZhKp+q3HebDRUQwbuhlaFhOfYClXSVOmaZ9c24=
X-Gm-Gg: ATEYQzwlN9sTVCvopyku91QGgnc/1J5XoJI081r+owvJKep4gd7+zxp6qS7KbVzyQjb
	PPXmMleS8gk5kMUgsDzN1x9vpcvlxFywNLoeXt3keejj9lD/u4UDgOVlbcjlOYH0MdG/1OsW9xt
	YdEnhIkfjrBWPh1HemUliZNRoc476Ol640k1x4D6QTTaoNYlW8ktSsDTkxwpBmXJSb/qv7oIacm
	cclFJG/QFPEMGSG+IutrxKbcLIpYOCZHeIvU1cu45w4shsJHRbtdrU1HEaxk/OB4CKwBzHnYpQM
	SJGaWNH1eFUxoxSRCvyMC9YTwJ0/mckspYsYh0J0gxwWbvE4/yOhe6gFH0dsdVo2mKYhx0KKnMC
	aOTCrYqJpQCze4PQ0S4tprY3LliYBvq6a7lV6Xj2j8PEcs07tPPVUQAB0wDCdne9tOrq3qS+Eic
	mQIEu8gl9zS01dHfy4fchGPwCx8Kcy7lJHibXUfADHoP1zG3hdokNvedekVA==
X-Received: by 2002:a05:600c:4ecd:b0:485:3f58:d84 with SMTP id 5b1f17b1804b1-486fee30199mr58450975e9.32.1774031340092;
        Fri, 20 Mar 2026 11:29:00 -0700 (PDT)
Received: from ddp-thinkpad.tail20b0d.ts.net ([80.208.222.2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-486fe6d91fbsm78231425e9.3.2026.03.20.11.28.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 11:28:59 -0700 (PDT)
From: Daniele Di Proietto <daniele.di.proietto@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Daniele Di Proietto <daniele.di.proietto@gmail.com>
Subject: [liburing v2] Add support for IORING_OP_DUP
Date: Fri, 20 Mar 2026 18:22:50 +0000
Message-ID: <20260320182250.780251-1-daniele.di.proietto@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
	TAGGED_FROM(0.00)[bounces-12767-lists,io-uring=lfdr.de];
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
	NEURAL_HAM(-0.00)[-0.911];
	RCVD_COUNT_FIVE(0.00)[5];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: CE2992DF76A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

The new operation duplicates an existing file (regular fd or fixed
descriptor) into a specific fd or fixed descriptor.

It's like dup3(), but async and also supports fixed descriptors as
source and destination.

Signed-off-by: Daniele Di Proietto <daniele.di.proietto@gmail.com>
---
Changes since v1:
* New interface (to/from direct descriptors)
* More testing
v1: https://lore.kernel.org/io-uring/20260310155111.2501074-1-daniele.di.proietto@gmail.com/T/#u

 man/io_uring_enter.2            |  35 ++
 man/io_uring_prep_dup.3         |  68 ++++
 src/include/liburing.h          |   8 +
 src/include/liburing/io_uring.h |  17 +
 src/sanitize.c                  |   4 +-
 test/Makefile                   |   1 +
 test/dup.c                      | 559 ++++++++++++++++++++++++++++++++
 7 files changed, 691 insertions(+), 1 deletion(-)
 create mode 100644 man/io_uring_prep_dup.3
 create mode 100644 test/dup.c

diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
index 7b99335e..c6c273c3 100644
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
@@ -1729,6 +1733,37 @@ for general usage details.
 
 Available since 6.19.
 
+.TP
+.B IORING_OP_DUP
+Used to duplicate a file. The source and destination can be in the regular
+process file descriptor table or in the fixed files table.
+.I fd
+points to the source file, while
+.I dup_new_fd
+points to the destination.
+Additional flags may be passed in via
+.IR dup_flags .
+If
+.BR IORING_DUP_OLD_FIXED ,
+is set,
+.I fd
+is a registered file, otherwise it's a regular fd.
+If
+.BR IORING_DUP_NEW_FIXED ,
+.I dup_new_fd
+is a registered file, otherwise it's a regular fd.
+.BR IORING_DUP_NO_CLOEXEC ,
+is the opposite of
+.BR O_CLOEXEC .
+only valid if
+.BR IORING_DUP_NEW_FIXED ,
+is not set.
+.I dup_new_fd can be
+.BR IORING_FILE_INDEX_ALLOC,
+in which case a slot will be allocated.
+
+Available since 7.1.
+
 .PP
 The
 .I flags
diff --git a/man/io_uring_prep_dup.3 b/man/io_uring_prep_dup.3
new file mode 100644
index 00000000..d6782ec6
--- /dev/null
+++ b/man/io_uring_prep_dup.3
@@ -0,0 +1,68 @@
+.TH io_uring_prep_dup 3 "March 20, 2026" "liburing-2.15" "liburing Manual"
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
+into the file
+.IR newfd .
+
+When
+.I dup_flags
+has
+.B IORING_DUP_OLD_FIXED
+set,
+.I oldfd
+must be a fixed file descriptor index. Otherwise it must be a regular
+file descriptor.
+
+When
+.I dup_flags
+has
+.B IORING_DUP_NEW_FIXED
+set,
+.I newfd
+must be a fixed file descriptor index (or
+.BR IORING_FILE_INDEX_ALLOC ).
+Otherwise it must be a regular file descriptor.
+
+When
+.I dup_flags
+has
+.B IORING_DUP_NO_CLOEXEC
+set,
+the new regular file descriptor should not be closed during exec. By default,
+.B O_CLOEXEC
+will be set on
+.I newfd
+otherwise.
+
+.SH RETURN VALUE
+None
+.SH ERRORS
+The CQE
+.I res
+field will contain the result of the operation, which in this case will be the
+new file descripor (or index). In case of failure, a negative value is returned.
+.SH SEE ALSO
+.BR io_uring_get_sqe (3),
+.BR io_uring_submit (3),
+.BR io_uring_prep_fixed_fd_install (3),
+.BR io_uring_prep_files_update (3),
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
index 1e58bc72..0083bf18 100644
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
@@ -472,6 +475,20 @@ enum io_uring_msg_ring_flags {
  */
 #define IORING_FIXED_FD_NO_CLOEXEC	(1U << 0)
 
+/*
+ * IORING_OP_DUP flags (sqe->dup_flags)
+ *
+ * IORING_DUP_NO_CLOEXEC	Don't mark the new fd as O_CLOEXEC. Only valid
+ *				if IORING_DUP_NEW_FIXED is not set.
+ * IORING_DUP_OLD_FIXED		sqe->fd (the source) is a fixed descriptor.
+ *				Otherwise it's a regular fd.
+ * IORING_DUP_NEW_FIXED		sqe->dup_new_fd (the destination) is a fixed
+ *				descriptor. Otherwise is a regular fd.
+ */
+#define IORING_DUP_NO_CLOEXEC	(1U << 0)
+#define IORING_DUP_OLD_FIXED	(1U << 1)
+#define IORING_DUP_NEW_FIXED	(1U << 2)
+
 /*
  * IORING_OP_NOP flags (sqe->nop_flags)
  *
diff --git a/src/sanitize.c b/src/sanitize.c
index 6d8465a5..08b79a3f 100644
--- a/src/sanitize.c
+++ b/src/sanitize.c
@@ -122,7 +122,9 @@ static inline void initialize_sanitize_handlers()
 	sanitize_handlers[IORING_OP_PIPE] = sanitize_sqe_addr;
 	sanitize_handlers[IORING_OP_NOP128] = sanitize_sqe_nop;
 	sanitize_handlers[IORING_OP_URING_CMD128] = sanitize_sqe_optval;
-	_Static_assert(IORING_OP_URING_CMD128 + 1 == IORING_OP_LAST, "Need an implementation for all IORING_OP_* codes");
+	sanitize_handlers[IORING_OP_DUP] = sanitize_sqe_nop;
+	_Static_assert(IORING_OP_DUP + 1 == IORING_OP_LAST,
+		       "Need an implementation for all IORING_OP_* codes");
 	sanitize_handlers_initialized = true;
 }
 
diff --git a/test/Makefile b/test/Makefile
index 9f45b6a0..4031f2b0 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -96,6 +96,7 @@ test_srcs := \
 	defer-tw-timeout.c \
 	double-poll-crash.c \
 	drop-submit.c \
+	dup.c \
 	eeed8b54e0df.c \
 	empty-eownerdead.c \
 	eploop.c \
diff --git a/test/dup.c b/test/dup.c
new file mode 100644
index 00000000..01bab4ce
--- /dev/null
+++ b/test/dup.c
@@ -0,0 +1,559 @@
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
+};
+
+static int probe(struct io_uring *ring)
+{
+	struct io_uring_probe *p;
+	int ret = T_EXIT_PASS;
+
+	p = io_uring_get_probe_ring(ring);
+	if (!p)
+		return T_EXIT_SKIP;
+	if (!io_uring_opcode_supported(p, IORING_OP_DUP))
+		ret = T_EXIT_SKIP;
+	io_uring_free_probe(p);
+	return ret;
+}
+
+static int setup(struct io_uring *ring, struct fixture *fixture)
+{
+	int ret, fds[2];
+
+	ret = io_uring_queue_init(4, ring, 0);
+	if (ret) {
+		fprintf(stderr, "ring setup failed: %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	ret = probe(ring);
+	if (ret)
+		return ret;
+
+	if (pipe(fds) < 0) {
+		perror("pipe");
+		return T_EXIT_FAIL;
+	}
+	fixture->fd_pipe_r = fds[0];
+	fixture->fd_pipe_w = fds[1];
+	ret = io_uring_register_files_sparse(ring, 5);
+	if (ret) {
+		fprintf(stderr, "failed register files %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	ret = io_uring_register_files_update(ring, 0, &fixture->fd_pipe_r, 1);
+	if (ret != 1) {
+		fprintf(stderr, "failed register files %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	fixture->fixed_pipe_r = 0;
+
+	return T_EXIT_PASS;
+}
+
+static int test_same_fd(struct io_uring *ring, struct fixture *fixture,
+			int fixed)
+{
+	unsigned int dup_flags = 0;
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	int fd, err;
+
+	sqe = io_uring_get_sqe(ring);
+	if (fixed) {
+		dup_flags |= IORING_DUP_NEW_FIXED | IORING_DUP_OLD_FIXED;
+		fd = fixture->fixed_pipe_r;
+	} else {
+		fd = fixture->fd_pipe_r;
+	}
+	io_uring_prep_dup(sqe, fd, fd, dup_flags);
+	io_uring_submit(ring);
+	err = io_uring_wait_cqe(ring, &cqe);
+	if (err) {
+		fprintf(stderr, "wait cqe %d\n", err);
+		return T_EXIT_FAIL;
+	}
+	err = cqe->res;
+	io_uring_cqe_seen(ring, cqe);
+
+	if (err != -EINVAL) {
+		fprintf(stderr, "dup expected -EINVAL got %d\n", err);
+		return T_EXIT_FAIL;
+	}
+
+	return T_EXIT_PASS;
+}
+
+static int are_pipes_connected(struct io_uring *ring, int fd_r, int fd_w,
+			       int r_fixed)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
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
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_read(sqe, fd_r, buf, sizeof(buf), 0);
+	if (r_fixed)
+		sqe->flags |= IOSQE_FIXED_FILE;
+	io_uring_submit(ring);
+	err = io_uring_wait_cqe(ring, &cqe);
+	if (err) {
+		fprintf(stderr, "read wait cqe %d\n", err);
+		return T_EXIT_FAIL;
+	}
+	err = cqe->res;
+	io_uring_cqe_seen(ring, cqe);
+
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
+
+	flags = fcntl(fd, F_GETFD, 0);
+	if (flags < 0) {
+		perror("fcntl");
+		return T_EXIT_FAIL;
+	}
+
+	if (nocloexec)
+		return (flags & FD_CLOEXEC) ? T_EXIT_FAIL : T_EXIT_PASS;
+	else
+		return (flags & FD_CLOEXEC) ? T_EXIT_PASS : T_EXIT_FAIL;
+}
+
+static int close_fixed(struct io_uring *ring, int fixed)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	int err;
+
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_close_direct(sqe, fixed);
+	io_uring_submit(ring);
+	err = io_uring_wait_cqe(ring, &cqe);
+	if (err) {
+		fprintf(stderr, "close wait cqe %d\n", err);
+		return T_EXIT_FAIL;
+	}
+	err = cqe->res;
+	io_uring_cqe_seen(ring, cqe);
+	if (err < 0) {
+		fprintf(stderr, "close failed: %d\n", err);
+		return T_EXIT_FAIL;
+	}
+	return T_EXIT_PASS;
+}
+
+static int full_fd(void)
+{
+	int fds[2];
+
+	if (pipe(fds) < 0) {
+		perror("pipe");
+		return -1;
+	}
+
+	close(fds[1]);
+	return fds[0];
+}
+
+static int full_fd_flush(void)
+{
+	return open("/sys/kernel/debug/tracing/per_cpu/cpu0/trace_pipe_raw",
+		    O_RDONLY);
+}
+
+static int full_fixed(struct io_uring *ring, unsigned int fd)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	int fds[2], err;
+
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_pipe_direct(sqe, fds, 0, fd);
+	io_uring_submit(ring);
+	err = io_uring_wait_cqe(ring, &cqe);
+	if (err) {
+		fprintf(stderr, "wait cqe %d\n", err);
+		return T_EXIT_FAIL;
+	}
+
+	err = cqe->res;
+	io_uring_cqe_seen(ring, cqe);
+	if (err) {
+		fprintf(stderr, "pipe direct %d\n", err);
+		return T_EXIT_FAIL;
+	}
+	return close_fixed(ring, fds[1]);
+}
+
+static int full_fixed_flush(struct io_uring *ring, unsigned int fd)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	int err;
+
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_open_direct(
+		sqe, "/sys/kernel/debug/tracing/per_cpu/cpu0/trace_pipe_raw", 0,
+		0, fd);
+	io_uring_submit(ring);
+	err = io_uring_wait_cqe(ring, &cqe);
+	if (err) {
+		fprintf(stderr, "wait cqe %d\n", err);
+		return T_EXIT_FAIL;
+	}
+	err = cqe->res;
+	io_uring_cqe_seen(ring, cqe);
+	return err == 0 ? T_EXIT_PASS : T_EXIT_FAIL;
+}
+
+struct test_params {
+	/* The src file is a direct descriptor (otherwise it's a regular fd). */
+	unsigned old_fixed : 1;
+	/* The dst file is a direct descriptor (otherwise it's a regular fd). */
+	unsigned new_fixed : 1;
+	/* If set, allocates a direct descriptor slot. Only valid if new_fixed is set. */
+	unsigned alloc : 1;
+	/* Pass the nocloexec flag. */
+	unsigned nocloexec : 1;
+	/* Pass the IOSQE_ASYNC flag. */
+	unsigned async : 1;
+	/* The dst file already contains something that will be closed. */
+	unsigned new_full : 1;
+	/* The dst file already contains something that requires flushing before closing. */
+	unsigned new_full_flush : 1;
+	/* The src file is a io_uring regular fd. */
+	unsigned old_ring : 1;
+	/* The dst file is a io_uring regular fd. */
+	unsigned new_ring : 1;
+	/* The src file doesn't exist. */
+	unsigned old_nx : 1;
+	/* If non-zero, expect this error */
+	int expected_error;
+};
+
+static int do_test(struct io_uring *ring, struct fixture *fixture,
+		   struct test_params params)
+{
+	unsigned int dup_flags = 0;
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	int ret, oldfd, newfd;
+
+	if (params.old_fixed) {
+		dup_flags |= IORING_DUP_OLD_FIXED;
+		oldfd = fixture->fixed_pipe_r;
+		if (params.old_nx)
+			oldfd = 10;
+	} else {
+		oldfd = fixture->fd_pipe_r;
+		if (params.old_ring)
+			oldfd = ring->ring_fd;
+		else if (params.old_nx)
+			oldfd = 10;
+	}
+	if (params.new_fixed) {
+		dup_flags |= IORING_DUP_NEW_FIXED;
+		if (params.alloc) {
+			newfd = IORING_FILE_INDEX_ALLOC;
+		} else {
+			newfd = 3;
+			if (params.new_full) {
+				if (params.new_full_flush)
+					ret = full_fixed_flush(ring, newfd);
+				else
+					ret = full_fixed(ring, newfd);
+				if (ret)
+					return T_EXIT_SKIP;
+			}
+		}
+	} else {
+		if (params.new_ring) {
+			newfd = ring->ring_fd;
+		} else {
+			if (params.new_full_flush)
+				newfd = full_fd_flush();
+			else
+				newfd = full_fd();
+			if (newfd == -1)
+				return T_EXIT_SKIP;
+			if (!params.new_full)
+				close(newfd);
+		}
+	}
+	if (params.nocloexec)
+		dup_flags |= IORING_DUP_NO_CLOEXEC;
+
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_dup(sqe, oldfd, newfd, dup_flags);
+	if (params.async)
+		sqe->flags |= IOSQE_ASYNC;
+
+	io_uring_submit(ring);
+	ret = io_uring_wait_cqe(ring, &cqe);
+	if (ret) {
+		fprintf(stderr, "wait cqe %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+	ret = cqe->res;
+	io_uring_cqe_seen(ring, cqe);
+	if (params.expected_error != 0) {
+		if (ret != params.expected_error) {
+			fprintf(stderr, "wrong expected error: %d\n", ret);
+			return T_EXIT_FAIL;
+		}
+		goto cleanup;
+	}
+	if (ret < 0) {
+		fprintf(stderr, "failed dup: %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	if (params.new_fixed && params.alloc) {
+		newfd = ret;
+	} else {
+		if (ret != newfd) {
+			fprintf(stderr, "wrong dup return value: %d\n", ret);
+			return T_EXIT_FAIL;
+		}
+	}
+
+	if (!params.old_ring) {
+		ret = are_pipes_connected(ring, newfd, fixture->fd_pipe_w,
+					  params.new_fixed);
+		if (ret != T_EXIT_PASS) {
+			fprintf(stderr, "dup pipes not connected\n");
+			return ret;
+		}
+	}
+	if (!params.new_fixed) {
+		ret = cloexec_check(newfd, params.nocloexec);
+		if (ret != T_EXIT_PASS) {
+			fprintf(stderr, "cloexec mismatch\n");
+			return ret;
+		}
+	}
+
+	if (params.new_fixed) {
+		ret = close_fixed(ring, newfd);
+		if (ret != T_EXIT_PASS) {
+			fprintf(stderr, "close_fixed error\n");
+			return ret;
+		}
+	} else {
+		close(newfd);
+	}
+
+	return T_EXIT_PASS;
+
+cleanup:
+	if (params.new_full) {
+		if (params.new_fixed)
+			close_fixed(ring, newfd);
+		else if (!params.new_ring)
+			close(newfd);
+	}
+
+	return T_EXIT_PASS;
+}
+
+static int test_large_fd(struct io_uring *ring, struct fixture *fixture)
+{
+	unsigned int dup_flags = 0;
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	int newfd, oldfd, ret;
+
+	sqe = io_uring_get_sqe(ring);
+	dup_flags |= IORING_DUP_OLD_FIXED;
+	oldfd = fixture->fixed_pipe_r;
+	newfd = 200;
+	io_uring_prep_dup(sqe, oldfd, newfd, dup_flags);
+	io_uring_submit(ring);
+	ret = io_uring_wait_cqe(ring, &cqe);
+	if (ret) {
+		fprintf(stderr, "wait cqe %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+	ret = cqe->res;
+	io_uring_cqe_seen(ring, cqe);
+
+	if (ret != newfd) {
+		fprintf(stderr, "dup expected %d got %d\n", newfd, ret);
+		return T_EXIT_FAIL;
+	}
+
+	ret = are_pipes_connected(ring, newfd, fixture->fd_pipe_w, false);
+	if (ret != T_EXIT_PASS) {
+		fprintf(stderr, "dup pipes not connected\n");
+		return ret;
+	}
+	close(newfd);
+
+	return T_EXIT_PASS;
+}
+
+int main(int argc, char *argv[])
+{
+	struct fixture fixture;
+	struct io_uring ring;
+	unsigned int i;
+	int ret;
+
+	if (argc > 1)
+		return T_EXIT_SKIP;
+
+	ret = setup(&ring, &fixture);
+	if (ret != T_EXIT_PASS) {
+		if (ret == T_EXIT_FAIL)
+			fprintf(stderr, "fixture setup failed\n");
+		return ret;
+	}
+
+	for (i = 0; i < (1 << 10); i++) {
+		struct test_params params;
+
+		params.old_fixed = (i & (1 << 0)) != 0;
+		params.new_fixed = (i & (1 << 1)) != 0;
+		params.nocloexec = (i & (1 << 2)) != 0;
+		params.async = (i & (1 << 3)) != 0;
+		params.alloc = (i & (1 << 4)) != 0;
+		params.new_full = (i & (1 << 5)) != 0;
+		params.new_full_flush = (i & (1 << 6)) != 0;
+		params.old_ring = (i & (1 << 7)) != 0;
+		params.new_ring = (i & (1 << 8)) != 0;
+		params.old_nx = (i & (1 << 9)) != 0;
+
+		params.expected_error = 0;
+
+		if (params.alloc && !params.new_fixed)
+			continue;
+
+		if (params.alloc && params.new_full)
+			continue;
+
+		if (params.old_fixed && params.old_ring)
+			continue;
+
+		if (params.new_fixed && params.new_ring)
+			continue;
+
+		if (!params.new_full && params.new_full_flush)
+			continue;
+
+		if (params.old_ring && params.new_ring)
+			continue;
+
+		if (params.old_ring && params.old_nx)
+			continue;
+
+		if (params.new_ring &&
+		    (!params.new_full || params.new_full_flush))
+			continue;
+
+		if (params.old_ring && params.new_fixed)
+			params.expected_error = -EBADF;
+
+		if (params.new_ring)
+			params.expected_error = -EBADF;
+
+		if (params.old_nx)
+			params.expected_error = -EBADF;
+
+		if (params.new_fixed && params.nocloexec)
+			params.expected_error = -EINVAL;
+
+		ret = do_test(&ring, &fixture, params);
+		if (ret != T_EXIT_PASS) {
+			if (ret == T_EXIT_SKIP && params.new_full_flush) {
+				fprintf(stderr, "Skipping!\n");
+				/* tracefs might not be accessible. Ignore */
+				continue;
+			}
+			if (ret == T_EXIT_FAIL)
+				fprintf(stderr,
+					"do_test (%u) "
+					"old_fixedio_rsrc_ : %u "
+					"new_fixed: %u "
+					"alloc: %u "
+					"nocloexec: %u "
+					"async: %u "
+					"new_full: %u "
+					"new_full_flush: %u "
+					"old_ring: %u "
+					"new_ring:%u "
+					"old_nx: %u "
+					"expected_error:%d "
+					"failed\n",
+					i, params.old_fixed, params.new_fixed,
+					params.alloc, params.nocloexec,
+					params.async, params.new_full,
+					params.new_full_flush, params.old_ring,
+					params.new_ring, params.old_nx,
+					params.expected_error);
+			return ret;
+		}
+	}
+
+	ret = test_same_fd(&ring, &fixture, 0);
+	if (ret != T_EXIT_PASS) {
+		if (ret == T_EXIT_FAIL)
+			fprintf(stderr, "test_same_fd fixed: 0 failed");
+		return ret;
+	}
+
+	ret = test_same_fd(&ring, &fixture, 1);
+	if (ret != T_EXIT_PASS) {
+		if (ret == T_EXIT_FAIL)
+			fprintf(stderr, "test_same_fd fixed: 1 failed");
+		return ret;
+	}
+
+	ret = test_large_fd(&ring, &fixture);
+	if (ret != T_EXIT_PASS) {
+		if (ret == T_EXIT_FAIL)
+			fprintf(stderr, "test_large_fd: 1 failed");
+		return ret;
+	}
+
+	return T_EXIT_PASS;
+}
-- 
2.43.0


