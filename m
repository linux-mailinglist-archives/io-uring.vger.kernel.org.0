Return-Path: <io-uring+bounces-13761-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id QqW+JMUzMmrLwgUAu9opvQ
	(envelope-from <io-uring+bounces-13761-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2026 07:42:29 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 24C1E696A32
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2026 07:42:29 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="eQlYOF1/";
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13761-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13761-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 97B853008C2F
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2026 05:42:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36D24398911;
	Wed, 17 Jun 2026 05:42:26 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39C6378D9A
	for <io-uring@vger.kernel.org>; Wed, 17 Jun 2026 05:42:22 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781674946; cv=none; b=hYDlQz9nwkVkYeJ4zAPjtgXh6m5zst/q/wQJhm2wjK9k/J7LqFvKjW5SJTRkUjzH6ZA+R4Jd9f5mtUrPmuccdjH2vqxBGS5mlNP5TVi4/0JziS+VyHaAo9pTFLvGjwhpPH24xmKOG7lHg1+jtCNPxtk652lyAMgUbNnhhOKhwCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781674946; c=relaxed/simple;
	bh=dIuD67qpEpyFTlpy10+W/qEaz73JqBqqBcNymLgogmE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=k9zCvIn3ytJabaKtjzfPWgfRKdgKcVaWkWnbMwvM91NeDG4hHgS+QyumBQ2IkYCqkgczoMw6LfrKvN2qQVhRw/oWaDT+TIISJo674eoUoSfgC/V6TptlS/2iXsUNjGcGXHNe5noH8FSVMNNJaiXto4BOqwlCsQ2yLOPyAM4fN+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eQlYOF1/; arc=none smtp.client-ip=209.85.214.177
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2bf3781ca51so44158425ad.0
        for <io-uring@vger.kernel.org>; Tue, 16 Jun 2026 22:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781674942; x=1782279742; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Wji7WH23+J1tkvyifdqlYvidSiV1PN6f17es/nfODCY=;
        b=eQlYOF1/DCIqXytiC4o3498zQk0bd2KLuFEeIB2AojHH1FKaK3mcCMqRIcq+bDZp19
         ODDd+FMVrl20MR3yA2wR3HhZqtzB1hhqJ6RZNWUsybZzAqCMFdH/DEK0f5bGB5WQsqA4
         J5w0bj6yJaLFNi9t+bXAUmp8rhEFkbu1THIG3DiNQXOmB979esPv/J9CNvqTdbO0MzRx
         D0eiquJLa2y5o53ag72+wydkaSUdaEz8UHhVr4jsKxcsAOP7VGwuAE5WRNsoFzftbVxV
         rORbK9pxqBDnKqEVbMlTb3b1nEcBdZyJXFX/4ZW7cdE8Wmvc62k+EHp3BMyh1gjrPMuQ
         +mIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781674942; x=1782279742;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wji7WH23+J1tkvyifdqlYvidSiV1PN6f17es/nfODCY=;
        b=esAjrppxF3LrSRbFXdSMig56PSKjn6a3jDzJ6txSmzkS7XRJxL6Xjdh7Yf1DLvPE8t
         hvXTV/R3rKrWrJhVa+lRNhva4B5nhuYTHWn0lvVPg7sFpJq4Hn2UnxmjZ6egDPtyue+U
         X4azKaG21LcfboGfs8FCKfPVbw2rouewH0UYoQgZ+gq/P1KC/2SaL70WVE0IsFf6SV5A
         yDco68SwZx6j42nVY5zidj8zxqrBxrfB/ycGM9YqKvGPDopdZdw4/s5GuBpcq7fC811Z
         L6jTLG8HRZPzBCuum/dsC3cjmcEyz7lHNy33JParM8mIQnhtlrBuBRWgdhiONLj+qogw
         5upw==
X-Forwarded-Encrypted: i=1; AFNElJ/4rYj7du+aG7FYUxUGavUjJk/VYeQRE/u/yPcemIYpz/bDrZEJo/ZYc/1cszfO5TzBPBZjW8RVTg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyAZSSE7zLxMW5Ki48/cr/1+UnxxN1/TL0Rm5LZZz26kFopNqA3
	IyntLUCqZ5jUJoRRKS0E1c++VMnfMK4XB0/cVCaX3G/TkWIepEg3MAxk
X-Gm-Gg: AfdE7cmPpZmMfQwnD/Lo5ZmLogCyhbavrsw+yTRa/UbMV5+MVsBiA06MVbZqMVfFdgz
	j54vwuJIEp+0y2nh38RPLsZd5k51/lYnWhG4EUM6SQedGseYxEkLFR6IGBSxqdRWOrmXp6x2q5Q
	Cq0xpNeUS7FVgsLHveD/0FErRRba6venU/0EXx2eRCNSngzZSUV9LRcjGb84nUCfmemOOLaqqEI
	QgPLto+Ia5kp5avRhR2VaMQwMy23DROPVseoP8AuIMbHv2AcW6Jm1i2ozWr0NjiS65lE6Q8vJ5m
	MlrmlxJBwdq1i5cD+8H/362tQc6uaXegpyOpYTQEQVSKAtnxM79H3ftV9yDeJSegO3w3ThcIFGz
	Srhm9YMjt//h/Qe94mfKd1WFUIodQopOhHHbhLqrgfq8DJuPnulZ1b1hm+XSecv0yrzh57DNsUZ
	kYPnXkGcSWdpEjPPh2ULwc1MRnjCqfbYa3kiWtj7y/l1npUXk=
X-Received: by 2002:a17:903:f8d:b0:2c6:beec:c677 with SMTP id d9443c01a7336-2c6beeccbb3mr13959775ad.23.1781674941720;
        Tue, 16 Jun 2026 22:42:21 -0700 (PDT)
Received: from Athena ([58.146.127.224])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c6bbc5323csm12154635ad.45.2026.06.16.22.42.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 22:42:21 -0700 (PDT)
From: harshal24-chavan <harshal24.chavan@gmail.com>
To: axboe@kernel.dk,
	kees@kernel.org
Cc: gustavoars@kernel.org,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	harshal24-chavan <harshal24.chavan@gmail.com>
Subject: [PATCH] io_uring/register: add IORING_REGISTER_CLONE_FILES opcode
Date: Wed, 17 Jun 2026 11:12:08 +0530
Message-ID: <20260617054208.24840-1-harshal24.chavan@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[kernel.org,vger.kernel.org,gmail.com];
	FORWARDED(0.00)[lists@lfdr.de];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER(0.00)[harshal24chavan@gmail.com,io-uring@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-13761-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:kees@kernel.org,m:gustavoars@kernel.org,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:linux-hardening@vger.kernel.org,m:harshal24.chavan@gmail.com,m:harshal24chavan@gmail.com,s:lists@lfdr.de];
	DKIM_TRACE(0.00)[gmail.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[harshal24chavan@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 24C1E696A32

Currently, if an application wants to duplicate registered file descriptors
from one io_uring instance to another, it must manually unregister and
re-register them, incurring unnecessary overhead.

Add IORING_REGISTER_CLONE_FILES to allow direct cloning of the file table
from a source ring to a destination ring. This includes support for
partial offsets and the IORING_REGISTER_DST_REPLACE flag.

Signed-off-by: harshal24-chavan <harshal24.chavan@gmail.com>
---
 include/uapi/linux/io_uring.h | 616 +++++++++++++++++-----------------
 io_uring/register.c           |  57 ++--
 io_uring/rsrc.c               | 259 +++++++++++---
 io_uring/rsrc.h               |  75 +++--
 4 files changed, 600 insertions(+), 407 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 909fb7aea638..eb6f35b3746e 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -30,105 +30,105 @@ extern "C" {
  * IO submission data structure (Submission Queue Entry)
  */
 struct io_uring_sqe {
-	__u8	opcode;		/* type of operation for this sqe */
-	__u8	flags;		/* IOSQE_ flags */
-	__u16	ioprio;		/* ioprio for the request */
-	__s32	fd;		/* file descriptor to do IO on */
+	__u8 opcode; /* type of operation for this sqe */
+	__u8 flags; /* IOSQE_ flags */
+	__u16 ioprio; /* ioprio for the request */
+	__s32 fd; /* file descriptor to do IO on */
 	union {
-		__u64	off;	/* offset into file */
-		__u64	addr2;
+		__u64 off; /* offset into file */
+		__u64 addr2;
 		struct {
-			__u32	cmd_op;
-			__u32	__pad1;
+			__u32 cmd_op;
+			__u32 __pad1;
 		};
 	};
 	union {
-		__u64	addr;	/* pointer to buffer or iovecs */
-		__u64	splice_off_in;
+		__u64 addr; /* pointer to buffer or iovecs */
+		__u64 splice_off_in;
 		struct {
-			__u32	level;
-			__u32	optname;
+			__u32 level;
+			__u32 optname;
 		};
 	};
-	__u32	len;		/* buffer size or number of iovecs */
+	__u32 len; /* buffer size or number of iovecs */
 	union {
-		__u32		rw_flags;
-		__u32		fsync_flags;
-		__u16		poll_events;	/* compatibility */
-		__u32		poll32_events;	/* word-reversed for BE */
-		__u32		sync_range_flags;
-		__u32		msg_flags;
-		__u32		timeout_flags;
-		__u32		accept_flags;
-		__u32		cancel_flags;
-		__u32		open_flags;
-		__u32		statx_flags;
-		__u32		fadvise_advice;
-		__u32		splice_flags;
-		__u32		rename_flags;
-		__u32		unlink_flags;
-		__u32		hardlink_flags;
-		__u32		xattr_flags;
-		__u32		msg_ring_flags;
-		__u32		uring_cmd_flags;
-		__u32		waitid_flags;
-		__u32		futex_flags;
-		__u32		install_fd_flags;
-		__u32		nop_flags;
-		__u32		pipe_flags;
+		__u32 rw_flags;
+		__u32 fsync_flags;
+		__u16 poll_events; /* compatibility */
+		__u32 poll32_events; /* word-reversed for BE */
+		__u32 sync_range_flags;
+		__u32 msg_flags;
+		__u32 timeout_flags;
+		__u32 accept_flags;
+		__u32 cancel_flags;
+		__u32 open_flags;
+		__u32 statx_flags;
+		__u32 fadvise_advice;
+		__u32 splice_flags;
+		__u32 rename_flags;
+		__u32 unlink_flags;
+		__u32 hardlink_flags;
+		__u32 xattr_flags;
+		__u32 msg_ring_flags;
+		__u32 uring_cmd_flags;
+		__u32 waitid_flags;
+		__u32 futex_flags;
+		__u32 install_fd_flags;
+		__u32 nop_flags;
+		__u32 pipe_flags;
 	};
-	__u64	user_data;	/* data to be passed back at completion time */
+	__u64 user_data; /* data to be passed back at completion time */
 	/* pack this to avoid bogus arm OABI complaints */
 	union {
 		/* index into fixed buffers, if used */
-		__u16	buf_index;
+		__u16 buf_index;
 		/* for grouped buffer selection */
-		__u16	buf_group;
+		__u16 buf_group;
 	} __attribute__((packed));
 	/* personality to use, if used */
-	__u16	personality;
+	__u16 personality;
 	union {
-		__s32	splice_fd_in;
-		__u32	file_index;
-		__u32	zcrx_ifq_idx;
-		__u32	optlen;
+		__s32 splice_fd_in;
+		__u32 file_index;
+		__u32 zcrx_ifq_idx;
+		__u32 optlen;
 		struct {
-			__u16	addr_len;
-			__u16	__pad3[1];
+			__u16 addr_len;
+			__u16 __pad3[1];
 		};
 		struct {
-			__u8	write_stream;
-			__u8	__pad4[3];
+			__u8 write_stream;
+			__u8 __pad4[3];
 		};
 	};
 	union {
 		struct {
-			__u64	addr3;
-			__u64	__pad2[1];
+			__u64 addr3;
+			__u64 __pad2[1];
 		};
 		struct {
-			__u64	attr_ptr; /* pointer to attribute information */
-			__u64	attr_type_mask; /* bit mask of attributes */
+			__u64 attr_ptr; /* pointer to attribute information */
+			__u64 attr_type_mask; /* bit mask of attributes */
 		};
-		__u64	optval;
+		__u64 optval;
 		/*
 		 * If the ring is initialized with IORING_SETUP_SQE128, then
 		 * this field is used for 80 bytes of arbitrary command data
 		 */
-		__u8	cmd[0];
+		__u8 cmd[0];
 	};
 };
 
 /* sqe->attr_type_mask flags */
-#define IORING_RW_ATTR_FLAG_PI	(1U << 0)
+#define IORING_RW_ATTR_FLAG_PI (1U << 0)
 /* PI attribute information */
 struct io_uring_attr_pi {
-		__u16	flags;
-		__u16	app_tag;
-		__u32	len;
-		__u64	addr;
-		__u64	seed;
-		__u64	rsvd;
+	__u16 flags;
+	__u16 app_tag;
+	__u32 len;
+	__u64 addr;
+	__u64 seed;
+	__u64 rsvd;
 };
 
 /*
@@ -138,7 +138,7 @@ struct io_uring_attr_pi {
  * in. The picked direct descriptor will be returned in cqe->res, or -ENFILE
  * if the space is full.
  */
-#define IORING_FILE_INDEX_ALLOC		(~0U)
+#define IORING_FILE_INDEX_ALLOC (~0U)
 
 enum io_uring_sqe_flags_bit {
 	IOSQE_FIXED_FILE_BIT,
@@ -154,31 +154,31 @@ enum io_uring_sqe_flags_bit {
  * sqe->flags
  */
 /* use fixed fileset */
-#define IOSQE_FIXED_FILE	(1U << IOSQE_FIXED_FILE_BIT)
+#define IOSQE_FIXED_FILE (1U << IOSQE_FIXED_FILE_BIT)
 /* issue after inflight IO */
-#define IOSQE_IO_DRAIN		(1U << IOSQE_IO_DRAIN_BIT)
+#define IOSQE_IO_DRAIN (1U << IOSQE_IO_DRAIN_BIT)
 /* links next sqe */
-#define IOSQE_IO_LINK		(1U << IOSQE_IO_LINK_BIT)
+#define IOSQE_IO_LINK (1U << IOSQE_IO_LINK_BIT)
 /* like LINK, but stronger */
-#define IOSQE_IO_HARDLINK	(1U << IOSQE_IO_HARDLINK_BIT)
+#define IOSQE_IO_HARDLINK (1U << IOSQE_IO_HARDLINK_BIT)
 /* always go async */
-#define IOSQE_ASYNC		(1U << IOSQE_ASYNC_BIT)
+#define IOSQE_ASYNC (1U << IOSQE_ASYNC_BIT)
 /* select buffer from sqe->buf_group */
-#define IOSQE_BUFFER_SELECT	(1U << IOSQE_BUFFER_SELECT_BIT)
+#define IOSQE_BUFFER_SELECT (1U << IOSQE_BUFFER_SELECT_BIT)
 /* don't post CQE if request succeeded */
-#define IOSQE_CQE_SKIP_SUCCESS	(1U << IOSQE_CQE_SKIP_SUCCESS_BIT)
+#define IOSQE_CQE_SKIP_SUCCESS (1U << IOSQE_CQE_SKIP_SUCCESS_BIT)
 
 /*
  * io_uring_setup() flags
  */
-#define IORING_SETUP_IOPOLL	(1U << 0)	/* io_context is polled */
-#define IORING_SETUP_SQPOLL	(1U << 1)	/* SQ poll thread */
-#define IORING_SETUP_SQ_AFF	(1U << 2)	/* sq_thread_cpu is valid */
-#define IORING_SETUP_CQSIZE	(1U << 3)	/* app defines CQ size */
-#define IORING_SETUP_CLAMP	(1U << 4)	/* clamp SQ/CQ ring sizes */
-#define IORING_SETUP_ATTACH_WQ	(1U << 5)	/* attach to existing wq */
-#define IORING_SETUP_R_DISABLED	(1U << 6)	/* start with ring disabled */
-#define IORING_SETUP_SUBMIT_ALL	(1U << 7)	/* continue submit on error */
+#define IORING_SETUP_IOPOLL (1U << 0) /* io_context is polled */
+#define IORING_SETUP_SQPOLL (1U << 1) /* SQ poll thread */
+#define IORING_SETUP_SQ_AFF (1U << 2) /* sq_thread_cpu is valid */
+#define IORING_SETUP_CQSIZE (1U << 3) /* app defines CQ size */
+#define IORING_SETUP_CLAMP (1U << 4) /* clamp SQ/CQ ring sizes */
+#define IORING_SETUP_ATTACH_WQ (1U << 5) /* attach to existing wq */
+#define IORING_SETUP_R_DISABLED (1U << 6) /* start with ring disabled */
+#define IORING_SETUP_SUBMIT_ALL (1U << 7) /* continue submit on error */
 /*
  * Cooperative task running. When requests complete, they often require
  * forcing the submitter to transition to the kernel to complete. If this
@@ -186,59 +186,59 @@ enum io_uring_sqe_flags_bit {
  * than force an inter-processor interrupt reschedule. This avoids interrupting
  * a task running in userspace, and saves an IPI.
  */
-#define IORING_SETUP_COOP_TASKRUN	(1U << 8)
+#define IORING_SETUP_COOP_TASKRUN (1U << 8)
 /*
  * If COOP_TASKRUN is set, get notified if task work is available for
  * running and a kernel transition would be needed to run it. This sets
  * IORING_SQ_TASKRUN in the sq ring flags. Not valid without COOP_TASKRUN
  * or DEFER_TASKRUN.
  */
-#define IORING_SETUP_TASKRUN_FLAG	(1U << 9)
-#define IORING_SETUP_SQE128		(1U << 10) /* SQEs are 128 byte */
-#define IORING_SETUP_CQE32		(1U << 11) /* CQEs are 32 byte */
+#define IORING_SETUP_TASKRUN_FLAG (1U << 9)
+#define IORING_SETUP_SQE128 (1U << 10) /* SQEs are 128 byte */
+#define IORING_SETUP_CQE32 (1U << 11) /* CQEs are 32 byte */
 /*
  * Only one task is allowed to submit requests
  */
-#define IORING_SETUP_SINGLE_ISSUER	(1U << 12)
+#define IORING_SETUP_SINGLE_ISSUER (1U << 12)
 
 /*
  * Defer running task work to get events.
  * Rather than running bits of task work whenever the task transitions
  * try to do it just before it is needed.
  */
-#define IORING_SETUP_DEFER_TASKRUN	(1U << 13)
+#define IORING_SETUP_DEFER_TASKRUN (1U << 13)
 
 /*
  * Application provides the memory for the rings
  */
-#define IORING_SETUP_NO_MMAP		(1U << 14)
+#define IORING_SETUP_NO_MMAP (1U << 14)
 
 /*
  * Register the ring fd in itself for use with
  * IORING_REGISTER_USE_REGISTERED_RING; return a registered fd index rather
  * than an fd.
  */
-#define IORING_SETUP_REGISTERED_FD_ONLY	(1U << 15)
+#define IORING_SETUP_REGISTERED_FD_ONLY (1U << 15)
 
 /*
  * Removes indirection through the SQ index array.
  */
-#define IORING_SETUP_NO_SQARRAY		(1U << 16)
+#define IORING_SETUP_NO_SQARRAY (1U << 16)
 
 /* Use hybrid poll in iopoll process */
-#define IORING_SETUP_HYBRID_IOPOLL	(1U << 17)
+#define IORING_SETUP_HYBRID_IOPOLL (1U << 17)
 
 /*
  * Allow both 16b and 32b CQEs. If a 32b CQE is posted, it will have
  * IORING_CQE_F_32 set in cqe->flags.
  */
-#define IORING_SETUP_CQE_MIXED		(1U << 18)
+#define IORING_SETUP_CQE_MIXED (1U << 18)
 
 /*
  * Allow both 64b and 128b SQEs. If a 128b SQE is posted, it will have
  * a 128b opcode.
  */
-#define IORING_SETUP_SQE_MIXED		(1U << 19)
+#define IORING_SETUP_SQE_MIXED (1U << 19)
 
 /*
  * When set, io_uring ignores SQ head and tail and fetches SQEs to submit
@@ -250,7 +250,7 @@ enum io_uring_sqe_flags_bit {
  * IORING_SETUP_SQPOLL. The user must also never change the SQ head and tail
  * values and keep it set to 0. Any other value is undefined behaviour.
  */
-#define IORING_SETUP_SQ_REWIND		(1U << 20)
+#define IORING_SETUP_SQ_REWIND (1U << 20)
 
 enum io_uring_op {
 	IORING_OP_NOP,
@@ -331,15 +331,15 @@ enum io_uring_op {
  *				multishot commands. Not compatible with
  *				IORING_URING_CMD_FIXED, for now.
  */
-#define IORING_URING_CMD_FIXED	(1U << 0)
-#define IORING_URING_CMD_MULTISHOT	(1U << 1)
-#define IORING_URING_CMD_MASK	(IORING_URING_CMD_FIXED | IORING_URING_CMD_MULTISHOT)
-
+#define IORING_URING_CMD_FIXED (1U << 0)
+#define IORING_URING_CMD_MULTISHOT (1U << 1)
+#define IORING_URING_CMD_MASK \
+	(IORING_URING_CMD_FIXED | IORING_URING_CMD_MULTISHOT)
 
 /*
  * sqe->fsync_flags
  */
-#define IORING_FSYNC_DATASYNC	(1U << 0)
+#define IORING_FSYNC_DATASYNC (1U << 0)
 
 /*
  * sqe->timeout_flags
@@ -348,21 +348,23 @@ enum io_uring_op {
  *					value in nanoseconds instead of
  *					pointing to a timespec.
  */
-#define IORING_TIMEOUT_ABS		(1U << 0)
-#define IORING_TIMEOUT_UPDATE		(1U << 1)
-#define IORING_TIMEOUT_BOOTTIME		(1U << 2)
-#define IORING_TIMEOUT_REALTIME		(1U << 3)
-#define IORING_LINK_TIMEOUT_UPDATE	(1U << 4)
-#define IORING_TIMEOUT_ETIME_SUCCESS	(1U << 5)
-#define IORING_TIMEOUT_MULTISHOT	(1U << 6)
-#define IORING_TIMEOUT_IMMEDIATE_ARG	(1U << 7)
-#define IORING_TIMEOUT_CLOCK_MASK	(IORING_TIMEOUT_BOOTTIME | IORING_TIMEOUT_REALTIME)
-#define IORING_TIMEOUT_UPDATE_MASK	(IORING_TIMEOUT_UPDATE | IORING_LINK_TIMEOUT_UPDATE)
+#define IORING_TIMEOUT_ABS (1U << 0)
+#define IORING_TIMEOUT_UPDATE (1U << 1)
+#define IORING_TIMEOUT_BOOTTIME (1U << 2)
+#define IORING_TIMEOUT_REALTIME (1U << 3)
+#define IORING_LINK_TIMEOUT_UPDATE (1U << 4)
+#define IORING_TIMEOUT_ETIME_SUCCESS (1U << 5)
+#define IORING_TIMEOUT_MULTISHOT (1U << 6)
+#define IORING_TIMEOUT_IMMEDIATE_ARG (1U << 7)
+#define IORING_TIMEOUT_CLOCK_MASK \
+	(IORING_TIMEOUT_BOOTTIME | IORING_TIMEOUT_REALTIME)
+#define IORING_TIMEOUT_UPDATE_MASK \
+	(IORING_TIMEOUT_UPDATE | IORING_LINK_TIMEOUT_UPDATE)
 /*
  * sqe->splice_flags
  * extends splice(2) flags
  */
-#define SPLICE_F_FD_IN_FIXED	(1U << 31) /* the last bit of __u32 */
+#define SPLICE_F_FD_IN_FIXED (1U << 31) /* the last bit of __u32 */
 
 /*
  * POLL_ADD flags. Note that since sqe->poll_events is the flag space, the
@@ -377,10 +379,10 @@ enum io_uring_op {
  *
  * IORING_POLL_LEVEL		Level triggered poll.
  */
-#define IORING_POLL_ADD_MULTI	(1U << 0)
-#define IORING_POLL_UPDATE_EVENTS	(1U << 1)
-#define IORING_POLL_UPDATE_USER_DATA	(1U << 2)
-#define IORING_POLL_ADD_LEVEL		(1U << 3)
+#define IORING_POLL_ADD_MULTI (1U << 0)
+#define IORING_POLL_UPDATE_EVENTS (1U << 1)
+#define IORING_POLL_UPDATE_USER_DATA (1U << 2)
+#define IORING_POLL_ADD_LEVEL (1U << 3)
 
 /*
  * ASYNC_CANCEL flags.
@@ -393,12 +395,12 @@ enum io_uring_op {
  * IORING_ASYNC_CANCEL_USERDATA	Match on user_data, default for no other key
  * IORING_ASYNC_CANCEL_OP	Match request based on opcode
  */
-#define IORING_ASYNC_CANCEL_ALL	(1U << 0)
-#define IORING_ASYNC_CANCEL_FD	(1U << 1)
-#define IORING_ASYNC_CANCEL_ANY	(1U << 2)
-#define IORING_ASYNC_CANCEL_FD_FIXED	(1U << 3)
-#define IORING_ASYNC_CANCEL_USERDATA	(1U << 4)
-#define IORING_ASYNC_CANCEL_OP	(1U << 5)
+#define IORING_ASYNC_CANCEL_ALL (1U << 0)
+#define IORING_ASYNC_CANCEL_FD (1U << 1)
+#define IORING_ASYNC_CANCEL_ANY (1U << 2)
+#define IORING_ASYNC_CANCEL_FD_FIXED (1U << 3)
+#define IORING_ASYNC_CANCEL_USERDATA (1U << 4)
+#define IORING_ASYNC_CANCEL_OP (1U << 5)
 
 /*
  * send/sendmsg and recv/recvmsg flags (sqe->ioprio)
@@ -434,12 +436,12 @@ enum io_uring_op {
  * IORING_SEND_VECTORIZED	If set, SEND[_ZC] will take a pointer to a io_vec
  *				to allow vectorized send operations.
  */
-#define IORING_RECVSEND_POLL_FIRST	(1U << 0)
-#define IORING_RECV_MULTISHOT		(1U << 1)
-#define IORING_RECVSEND_FIXED_BUF	(1U << 2)
-#define IORING_SEND_ZC_REPORT_USAGE	(1U << 3)
-#define IORING_RECVSEND_BUNDLE		(1U << 4)
-#define IORING_SEND_VECTORIZED		(1U << 5)
+#define IORING_RECVSEND_POLL_FIRST (1U << 0)
+#define IORING_RECV_MULTISHOT (1U << 1)
+#define IORING_RECVSEND_FIXED_BUF (1U << 2)
+#define IORING_SEND_ZC_REPORT_USAGE (1U << 3)
+#define IORING_RECVSEND_BUNDLE (1U << 4)
+#define IORING_SEND_VECTORIZED (1U << 5)
 
 /*
  * cqe.res for IORING_CQE_F_NOTIF if
@@ -448,21 +450,21 @@ enum io_uring_op {
  * It should be treated as a flag, all other
  * bits of cqe.res should be treated as reserved!
  */
-#define IORING_NOTIF_USAGE_ZC_COPIED    (1U << 31)
+#define IORING_NOTIF_USAGE_ZC_COPIED (1U << 31)
 
 /*
  * accept flags stored in sqe->ioprio
  */
-#define IORING_ACCEPT_MULTISHOT	(1U << 0)
-#define IORING_ACCEPT_DONTWAIT	(1U << 1)
-#define IORING_ACCEPT_POLL_FIRST	(1U << 2)
+#define IORING_ACCEPT_MULTISHOT (1U << 0)
+#define IORING_ACCEPT_DONTWAIT (1U << 1)
+#define IORING_ACCEPT_POLL_FIRST (1U << 2)
 
 /*
  * IORING_OP_MSG_RING command types, stored in sqe->addr
  */
 enum io_uring_msg_ring_flags {
-	IORING_MSG_DATA,	/* pass sqe->len as 'res' and off as user_data */
-	IORING_MSG_SEND_FD,	/* send a registered fd to another ring */
+	IORING_MSG_DATA, /* pass sqe->len as 'res' and off as user_data */
+	IORING_MSG_SEND_FD, /* send a registered fd to another ring */
 };
 
 /*
@@ -471,36 +473,36 @@ enum io_uring_msg_ring_flags {
  * IORING_MSG_RING_CQE_SKIP	Don't post a CQE to the target ring. Not
  *				applicable for IORING_MSG_DATA, obviously.
  */
-#define IORING_MSG_RING_CQE_SKIP	(1U << 0)
+#define IORING_MSG_RING_CQE_SKIP (1U << 0)
 /* Pass through the flags from sqe->file_index to cqe->flags */
-#define IORING_MSG_RING_FLAGS_PASS	(1U << 1)
+#define IORING_MSG_RING_FLAGS_PASS (1U << 1)
 
 /*
  * IORING_OP_FIXED_FD_INSTALL flags (sqe->install_fd_flags)
  *
  * IORING_FIXED_FD_NO_CLOEXEC	Don't mark the fd as O_CLOEXEC
  */
-#define IORING_FIXED_FD_NO_CLOEXEC	(1U << 0)
+#define IORING_FIXED_FD_NO_CLOEXEC (1U << 0)
 
 /*
  * IORING_OP_NOP flags (sqe->nop_flags)
  *
  * IORING_NOP_INJECT_RESULT	Inject result from sqe->result
  */
-#define IORING_NOP_INJECT_RESULT	(1U << 0)
-#define IORING_NOP_FILE			(1U << 1)
-#define IORING_NOP_FIXED_FILE		(1U << 2)
-#define IORING_NOP_FIXED_BUFFER		(1U << 3)
-#define IORING_NOP_TW			(1U << 4)
-#define IORING_NOP_CQE32		(1U << 5)
+#define IORING_NOP_INJECT_RESULT (1U << 0)
+#define IORING_NOP_FILE (1U << 1)
+#define IORING_NOP_FIXED_FILE (1U << 2)
+#define IORING_NOP_FIXED_BUFFER (1U << 3)
+#define IORING_NOP_TW (1U << 4)
+#define IORING_NOP_CQE32 (1U << 5)
 
 /*
  * IO completion data structure (Completion Queue Entry)
  */
 struct io_uring_cqe {
-	__u64	user_data;	/* sqe->user_data value passed back */
-	__s32	res;		/* result code for this event */
-	__u32	flags;
+	__u64 user_data; /* sqe->user_data value passed back */
+	__s32 res; /* result code for this event */
+	__u32 flags;
 
 	/*
 	 * If the ring is initialized with IORING_SETUP_CQE32, then this field
@@ -535,25 +537,25 @@ struct io_uring_cqe {
  *			setup in a mixed CQE mode, where both 16b and 32b
  *			CQEs may be posted to the CQ ring.
  */
-#define IORING_CQE_F_BUFFER		(1U << 0)
-#define IORING_CQE_F_MORE		(1U << 1)
-#define IORING_CQE_F_SOCK_NONEMPTY	(1U << 2)
-#define IORING_CQE_F_NOTIF		(1U << 3)
-#define IORING_CQE_F_BUF_MORE		(1U << 4)
-#define IORING_CQE_F_SKIP		(1U << 5)
-#define IORING_CQE_F_32			(1U << 15)
+#define IORING_CQE_F_BUFFER (1U << 0)
+#define IORING_CQE_F_MORE (1U << 1)
+#define IORING_CQE_F_SOCK_NONEMPTY (1U << 2)
+#define IORING_CQE_F_NOTIF (1U << 3)
+#define IORING_CQE_F_BUF_MORE (1U << 4)
+#define IORING_CQE_F_SKIP (1U << 5)
+#define IORING_CQE_F_32 (1U << 15)
 
-#define IORING_CQE_BUFFER_SHIFT		16
+#define IORING_CQE_BUFFER_SHIFT 16
 
 /*
  * Magic offsets for the application to mmap the data it needs
  */
-#define IORING_OFF_SQ_RING		0ULL
-#define IORING_OFF_CQ_RING		0x8000000ULL
-#define IORING_OFF_SQES			0x10000000ULL
-#define IORING_OFF_PBUF_RING		0x80000000ULL
-#define IORING_OFF_PBUF_SHIFT		16
-#define IORING_OFF_MMAP_MASK		0xf8000000ULL
+#define IORING_OFF_SQ_RING 0ULL
+#define IORING_OFF_CQ_RING 0x8000000ULL
+#define IORING_OFF_SQES 0x10000000ULL
+#define IORING_OFF_PBUF_RING 0x80000000ULL
+#define IORING_OFF_PBUF_SHIFT 16
+#define IORING_OFF_MMAP_MASK 0xf8000000ULL
 
 /*
  * Filled with the offset for mmap(2)
@@ -573,9 +575,9 @@ struct io_sqring_offsets {
 /*
  * sq_ring->flags
  */
-#define IORING_SQ_NEED_WAKEUP	(1U << 0) /* needs io_uring_enter wakeup */
-#define IORING_SQ_CQ_OVERFLOW	(1U << 1) /* CQ ring is overflown */
-#define IORING_SQ_TASKRUN	(1U << 2) /* task should enter the kernel */
+#define IORING_SQ_NEED_WAKEUP (1U << 0) /* needs io_uring_enter wakeup */
+#define IORING_SQ_CQ_OVERFLOW (1U << 1) /* CQ ring is overflown */
+#define IORING_SQ_TASKRUN (1U << 2) /* task should enter the kernel */
 
 struct io_cqring_offsets {
 	__u32 head;
@@ -594,19 +596,19 @@ struct io_cqring_offsets {
  */
 
 /* disable eventfd notifications */
-#define IORING_CQ_EVENTFD_DISABLED	(1U << 0)
+#define IORING_CQ_EVENTFD_DISABLED (1U << 0)
 
 /*
  * io_uring_enter(2) flags
  */
-#define IORING_ENTER_GETEVENTS		(1U << 0)
-#define IORING_ENTER_SQ_WAKEUP		(1U << 1)
-#define IORING_ENTER_SQ_WAIT		(1U << 2)
-#define IORING_ENTER_EXT_ARG		(1U << 3)
-#define IORING_ENTER_REGISTERED_RING	(1U << 4)
-#define IORING_ENTER_ABS_TIMER		(1U << 5)
-#define IORING_ENTER_EXT_ARG_REG	(1U << 6)
-#define IORING_ENTER_NO_IOWAIT		(1U << 7)
+#define IORING_ENTER_GETEVENTS (1U << 0)
+#define IORING_ENTER_SQ_WAKEUP (1U << 1)
+#define IORING_ENTER_SQ_WAIT (1U << 2)
+#define IORING_ENTER_EXT_ARG (1U << 3)
+#define IORING_ENTER_REGISTERED_RING (1U << 4)
+#define IORING_ENTER_ABS_TIMER (1U << 5)
+#define IORING_ENTER_EXT_ARG_REG (1U << 6)
+#define IORING_ENTER_NO_IOWAIT (1U << 7)
 
 /*
  * Passed in for io_uring_setup(2). Copied back with updated info on success
@@ -627,107 +629,110 @@ struct io_uring_params {
 /*
  * io_uring_params->features flags
  */
-#define IORING_FEAT_SINGLE_MMAP		(1U << 0)
-#define IORING_FEAT_NODROP		(1U << 1)
-#define IORING_FEAT_SUBMIT_STABLE	(1U << 2)
-#define IORING_FEAT_RW_CUR_POS		(1U << 3)
-#define IORING_FEAT_CUR_PERSONALITY	(1U << 4)
-#define IORING_FEAT_FAST_POLL		(1U << 5)
-#define IORING_FEAT_POLL_32BITS 	(1U << 6)
-#define IORING_FEAT_SQPOLL_NONFIXED	(1U << 7)
-#define IORING_FEAT_EXT_ARG		(1U << 8)
-#define IORING_FEAT_NATIVE_WORKERS	(1U << 9)
-#define IORING_FEAT_RSRC_TAGS		(1U << 10)
-#define IORING_FEAT_CQE_SKIP		(1U << 11)
-#define IORING_FEAT_LINKED_FILE		(1U << 12)
-#define IORING_FEAT_REG_REG_RING	(1U << 13)
-#define IORING_FEAT_RECVSEND_BUNDLE	(1U << 14)
-#define IORING_FEAT_MIN_TIMEOUT		(1U << 15)
-#define IORING_FEAT_RW_ATTR		(1U << 16)
-#define IORING_FEAT_NO_IOWAIT		(1U << 17)
+#define IORING_FEAT_SINGLE_MMAP (1U << 0)
+#define IORING_FEAT_NODROP (1U << 1)
+#define IORING_FEAT_SUBMIT_STABLE (1U << 2)
+#define IORING_FEAT_RW_CUR_POS (1U << 3)
+#define IORING_FEAT_CUR_PERSONALITY (1U << 4)
+#define IORING_FEAT_FAST_POLL (1U << 5)
+#define IORING_FEAT_POLL_32BITS (1U << 6)
+#define IORING_FEAT_SQPOLL_NONFIXED (1U << 7)
+#define IORING_FEAT_EXT_ARG (1U << 8)
+#define IORING_FEAT_NATIVE_WORKERS (1U << 9)
+#define IORING_FEAT_RSRC_TAGS (1U << 10)
+#define IORING_FEAT_CQE_SKIP (1U << 11)
+#define IORING_FEAT_LINKED_FILE (1U << 12)
+#define IORING_FEAT_REG_REG_RING (1U << 13)
+#define IORING_FEAT_RECVSEND_BUNDLE (1U << 14)
+#define IORING_FEAT_MIN_TIMEOUT (1U << 15)
+#define IORING_FEAT_RW_ATTR (1U << 16)
+#define IORING_FEAT_NO_IOWAIT (1U << 17)
 
 /*
  * io_uring_register(2) opcodes and arguments
  */
 enum io_uring_register_op {
-	IORING_REGISTER_BUFFERS			= 0,
-	IORING_UNREGISTER_BUFFERS		= 1,
-	IORING_REGISTER_FILES			= 2,
-	IORING_UNREGISTER_FILES			= 3,
-	IORING_REGISTER_EVENTFD			= 4,
-	IORING_UNREGISTER_EVENTFD		= 5,
-	IORING_REGISTER_FILES_UPDATE		= 6,
-	IORING_REGISTER_EVENTFD_ASYNC		= 7,
-	IORING_REGISTER_PROBE			= 8,
-	IORING_REGISTER_PERSONALITY		= 9,
-	IORING_UNREGISTER_PERSONALITY		= 10,
-	IORING_REGISTER_RESTRICTIONS		= 11,
-	IORING_REGISTER_ENABLE_RINGS		= 12,
+	IORING_REGISTER_BUFFERS = 0,
+	IORING_UNREGISTER_BUFFERS = 1,
+	IORING_REGISTER_FILES = 2,
+	IORING_UNREGISTER_FILES = 3,
+	IORING_REGISTER_EVENTFD = 4,
+	IORING_UNREGISTER_EVENTFD = 5,
+	IORING_REGISTER_FILES_UPDATE = 6,
+	IORING_REGISTER_EVENTFD_ASYNC = 7,
+	IORING_REGISTER_PROBE = 8,
+	IORING_REGISTER_PERSONALITY = 9,
+	IORING_UNREGISTER_PERSONALITY = 10,
+	IORING_REGISTER_RESTRICTIONS = 11,
+	IORING_REGISTER_ENABLE_RINGS = 12,
 
 	/* extended with tagging */
-	IORING_REGISTER_FILES2			= 13,
-	IORING_REGISTER_FILES_UPDATE2		= 14,
-	IORING_REGISTER_BUFFERS2		= 15,
-	IORING_REGISTER_BUFFERS_UPDATE		= 16,
+	IORING_REGISTER_FILES2 = 13,
+	IORING_REGISTER_FILES_UPDATE2 = 14,
+	IORING_REGISTER_BUFFERS2 = 15,
+	IORING_REGISTER_BUFFERS_UPDATE = 16,
 
 	/* set/clear io-wq thread affinities */
-	IORING_REGISTER_IOWQ_AFF		= 17,
-	IORING_UNREGISTER_IOWQ_AFF		= 18,
+	IORING_REGISTER_IOWQ_AFF = 17,
+	IORING_UNREGISTER_IOWQ_AFF = 18,
 
 	/* set/get max number of io-wq workers */
-	IORING_REGISTER_IOWQ_MAX_WORKERS	= 19,
+	IORING_REGISTER_IOWQ_MAX_WORKERS = 19,
 
 	/* register/unregister io_uring fd with the ring */
-	IORING_REGISTER_RING_FDS		= 20,
-	IORING_UNREGISTER_RING_FDS		= 21,
+	IORING_REGISTER_RING_FDS = 20,
+	IORING_UNREGISTER_RING_FDS = 21,
 
 	/* register ring based provide buffer group */
-	IORING_REGISTER_PBUF_RING		= 22,
-	IORING_UNREGISTER_PBUF_RING		= 23,
+	IORING_REGISTER_PBUF_RING = 22,
+	IORING_UNREGISTER_PBUF_RING = 23,
 
 	/* sync cancelation API */
-	IORING_REGISTER_SYNC_CANCEL		= 24,
+	IORING_REGISTER_SYNC_CANCEL = 24,
 
 	/* register a range of fixed file slots for automatic slot allocation */
-	IORING_REGISTER_FILE_ALLOC_RANGE	= 25,
+	IORING_REGISTER_FILE_ALLOC_RANGE = 25,
 
 	/* return status information for a buffer group */
-	IORING_REGISTER_PBUF_STATUS		= 26,
+	IORING_REGISTER_PBUF_STATUS = 26,
 
 	/* set/clear busy poll settings */
-	IORING_REGISTER_NAPI			= 27,
-	IORING_UNREGISTER_NAPI			= 28,
+	IORING_REGISTER_NAPI = 27,
+	IORING_UNREGISTER_NAPI = 28,
 
-	IORING_REGISTER_CLOCK			= 29,
+	IORING_REGISTER_CLOCK = 29,
 
 	/* clone registered buffers from source ring to current ring */
-	IORING_REGISTER_CLONE_BUFFERS		= 30,
+	IORING_REGISTER_CLONE_BUFFERS = 30,
 
 	/* send MSG_RING without having a ring */
-	IORING_REGISTER_SEND_MSG_RING		= 31,
+	IORING_REGISTER_SEND_MSG_RING = 31,
 
 	/* register a netdev hw rx queue for zerocopy */
-	IORING_REGISTER_ZCRX_IFQ		= 32,
+	IORING_REGISTER_ZCRX_IFQ = 32,
 
 	/* resize CQ ring */
-	IORING_REGISTER_RESIZE_RINGS		= 33,
+	IORING_REGISTER_RESIZE_RINGS = 33,
 
-	IORING_REGISTER_MEM_REGION		= 34,
+	IORING_REGISTER_MEM_REGION = 34,
 
 	/* query various aspects of io_uring, see linux/io_uring/query.h */
-	IORING_REGISTER_QUERY			= 35,
+	IORING_REGISTER_QUERY = 35,
 
 	/* auxiliary zcrx configuration, see enum zcrx_ctrl_op */
-	IORING_REGISTER_ZCRX_CTRL		= 36,
+	IORING_REGISTER_ZCRX_CTRL = 36,
 
 	/* register bpf filtering programs */
-	IORING_REGISTER_BPF_FILTER		= 37,
+	IORING_REGISTER_BPF_FILTER = 37,
+
+	/* clone file descriptors from another ring*/
+	IORING_REGISTER_CLONE_FILES = 38,
 
 	/* this goes last */
 	IORING_REGISTER_LAST,
 
 	/* flag added to the opcode to use a registered ring fd */
-	IORING_REGISTER_USE_REGISTERED_RING	= 1U << 31
+	IORING_REGISTER_USE_REGISTERED_RING = 1U << 31
 };
 
 /* io-wq worker categories */
@@ -745,7 +750,7 @@ struct io_uring_files_update {
 
 enum {
 	/* initialise with user provided memory pointed by user_addr */
-	IORING_MEM_REGION_TYPE_USER		= 1,
+	IORING_MEM_REGION_TYPE_USER = 1,
 };
 
 struct io_uring_region_desc {
@@ -759,7 +764,7 @@ struct io_uring_region_desc {
 
 enum {
 	/* expose the region as registered wait arguments */
-	IORING_MEM_REGION_REG_WAIT_ARG		= 1,
+	IORING_MEM_REGION_REG_WAIT_ARG = 1,
 };
 
 struct io_uring_mem_region_reg {
@@ -772,7 +777,7 @@ struct io_uring_mem_region_reg {
  * Register a fully sparse file space, rather than pass in an array of all
  * -1 file descriptors.
  */
-#define IORING_RSRC_REGISTER_SPARSE	(1U << 0)
+#define IORING_RSRC_REGISTER_SPARSE (1U << 0)
 
 struct io_uring_rsrc_register {
 	__u32 nr;
@@ -798,20 +803,20 @@ struct io_uring_rsrc_update2 {
 };
 
 /* Skip updating fd indexes set to this value in the fd table */
-#define IORING_REGISTER_FILES_SKIP	(-2)
+#define IORING_REGISTER_FILES_SKIP (-2)
 
-#define IO_URING_OP_SUPPORTED	(1U << 0)
+#define IO_URING_OP_SUPPORTED (1U << 0)
 
 struct io_uring_probe_op {
 	__u8 op;
 	__u8 resv;
-	__u16 flags;	/* IO_URING_OP_* flags */
+	__u16 flags; /* IO_URING_OP_* flags */
 	__u32 resv2;
 };
 
 struct io_uring_probe {
-	__u8 last_op;	/* last opcode supported */
-	__u8 ops_len;	/* length of ops[] array below */
+	__u8 last_op; /* last opcode supported */
+	__u8 ops_len; /* length of ops[] array below */
 	__u16 resv;
 	__u32 resv2[3];
 	struct io_uring_probe_op ops[];
@@ -821,8 +826,8 @@ struct io_uring_restriction {
 	__u16 opcode;
 	union {
 		__u8 register_op; /* IORING_RESTRICTION_REGISTER_OP */
-		__u8 sqe_op;      /* IORING_RESTRICTION_SQE_OP */
-		__u8 sqe_flags;   /* IORING_RESTRICTION_SQE_FLAGS_* */
+		__u8 sqe_op; /* IORING_RESTRICTION_SQE_OP */
+		__u8 sqe_flags; /* IORING_RESTRICTION_SQE_FLAGS_* */
 	};
 	__u8 resv;
 	__u32 resv2[3];
@@ -836,29 +841,38 @@ struct io_uring_task_restriction {
 };
 
 struct io_uring_clock_register {
-	__u32	clockid;
-	__u32	__resv[3];
+	__u32 clockid;
+	__u32 __resv[3];
 };
 
 enum {
-	IORING_REGISTER_SRC_REGISTERED	= (1U << 0),
-	IORING_REGISTER_DST_REPLACE	= (1U << 1),
+	IORING_REGISTER_SRC_REGISTERED = (1U << 0),
+	IORING_REGISTER_DST_REPLACE = (1U << 1),
 };
 
 struct io_uring_clone_buffers {
-	__u32	src_fd;
-	__u32	flags;
-	__u32	src_off;
-	__u32	dst_off;
-	__u32	nr;
-	__u32	pad[3];
+	__u32 src_fd;
+	__u32 flags;
+	__u32 src_off;
+	__u32 dst_off;
+	__u32 nr;
+	__u32 pad[3];
+};
+
+struct io_uring_clone_files {
+	__u32 src_fd;
+	__u32 flags;
+	__u32 src_off;
+	__u32 dst_off;
+	__u32 nr;
+	__u32 pad[3];
 };
 
 struct io_uring_buf {
-	__u64	addr;
-	__u32	len;
-	__u16	bid;
-	__u16	resv;
+	__u64 addr;
+	__u32 len;
+	__u16 bid;
+	__u16 resv;
 };
 
 struct io_uring_buf_ring {
@@ -868,10 +882,10 @@ struct io_uring_buf_ring {
 		 * ring tail is overlaid with the io_uring_buf->resv field.
 		 */
 		struct {
-			__u64	resv1;
-			__u32	resv2;
-			__u16	resv3;
-			__u16	tail;
+			__u64 resv1;
+			__u32 resv2;
+			__u16 resv3;
+			__u16 tail;
 		};
 		__DECLARE_FLEX_ARRAY(struct io_uring_buf, bufs);
 	};
@@ -895,25 +909,25 @@ struct io_uring_buf_ring {
  *			track of where the current read/recv index is at.
  */
 enum io_uring_register_pbuf_ring_flags {
-	IOU_PBUF_RING_MMAP	= 1,
-	IOU_PBUF_RING_INC	= 2,
+	IOU_PBUF_RING_MMAP = 1,
+	IOU_PBUF_RING_INC = 2,
 };
 
 /* argument for IORING_(UN)REGISTER_PBUF_RING */
 struct io_uring_buf_reg {
-	__u64	ring_addr;
-	__u32	ring_entries;
-	__u16	bgid;
-	__u16	flags;
-	__u32	min_left;
-	__u32	resv[5];
+	__u64 ring_addr;
+	__u32 ring_entries;
+	__u16 bgid;
+	__u16 flags;
+	__u32 min_left;
+	__u32 resv[5];
 };
 
 /* argument for IORING_REGISTER_PBUF_STATUS */
 struct io_uring_buf_status {
-	__u32	buf_group;	/* input */
-	__u32	head;		/* output */
-	__u32	resv[8];
+	__u32 buf_group; /* input */
+	__u32 head; /* output */
+	__u32 resv[8];
 };
 
 enum io_uring_napi_op {
@@ -934,12 +948,12 @@ enum io_uring_napi_tracking_strategy {
 
 /* argument for IORING_(UN)REGISTER_NAPI */
 struct io_uring_napi {
-	__u32	busy_poll_to;
-	__u8	prefer_busy_poll;
+	__u32 busy_poll_to;
+	__u8 prefer_busy_poll;
 
 	/* a io_uring_napi_op value */
-	__u8	opcode;
-	__u8	pad[2];
+	__u8 opcode;
+	__u8 pad[2];
 
 	/*
 	 * for IO_URING_NAPI_REGISTER_OP, it is a
@@ -948,8 +962,8 @@ struct io_uring_napi {
 	 * for IO_URING_NAPI_STATIC_ADD_ID/IO_URING_NAPI_STATIC_DEL_ID
 	 * it is the napi id to add/del from napi_list.
 	 */
-	__u32	op_param;
-	__u32	resv;
+	__u32 op_param;
+	__u32 resv;
 };
 
 /*
@@ -957,22 +971,22 @@ struct io_uring_napi {
  */
 enum io_uring_register_restriction_op {
 	/* Allow an io_uring_register(2) opcode */
-	IORING_RESTRICTION_REGISTER_OP		= 0,
+	IORING_RESTRICTION_REGISTER_OP = 0,
 
 	/* Allow an sqe opcode */
-	IORING_RESTRICTION_SQE_OP		= 1,
+	IORING_RESTRICTION_SQE_OP = 1,
 
 	/* Allow sqe flags */
-	IORING_RESTRICTION_SQE_FLAGS_ALLOWED	= 2,
+	IORING_RESTRICTION_SQE_FLAGS_ALLOWED = 2,
 
 	/* Require sqe flags (these flags must be set on each submission) */
-	IORING_RESTRICTION_SQE_FLAGS_REQUIRED	= 3,
+	IORING_RESTRICTION_SQE_FLAGS_REQUIRED = 3,
 
 	IORING_RESTRICTION_LAST
 };
 
 enum {
-	IORING_REG_WAIT_TS		= (1U << 0),
+	IORING_REG_WAIT_TS = (1U << 0),
 };
 
 /*
@@ -982,36 +996,36 @@ enum {
  * the below structure.
  */
 struct io_uring_reg_wait {
-	struct __kernel_timespec	ts;
-	__u32				min_wait_usec;
-	__u32				flags;
-	__u64				sigmask;
-	__u32				sigmask_sz;
-	__u32				pad[3];
-	__u64				pad2[2];
+	struct __kernel_timespec ts;
+	__u32 min_wait_usec;
+	__u32 flags;
+	__u64 sigmask;
+	__u32 sigmask_sz;
+	__u32 pad[3];
+	__u64 pad2[2];
 };
 
 /*
  * Argument for io_uring_enter(2) with IORING_GETEVENTS | IORING_ENTER_EXT_ARG
  */
 struct io_uring_getevents_arg {
-	__u64	sigmask;
-	__u32	sigmask_sz;
-	__u32	min_wait_usec;
-	__u64	ts;
+	__u64 sigmask;
+	__u32 sigmask_sz;
+	__u32 min_wait_usec;
+	__u64 ts;
 };
 
 /*
  * Argument for IORING_REGISTER_SYNC_CANCEL
  */
 struct io_uring_sync_cancel_reg {
-	__u64				addr;
-	__s32				fd;
-	__u32				flags;
-	struct __kernel_timespec	timeout;
-	__u8				opcode;
-	__u8				pad[7];
-	__u64				pad2[3];
+	__u64 addr;
+	__s32 fd;
+	__u32 flags;
+	struct __kernel_timespec timeout;
+	__u8 opcode;
+	__u8 pad[7];
+	__u64 pad2[3];
 };
 
 /*
@@ -1019,9 +1033,9 @@ struct io_uring_sync_cancel_reg {
  * The range is specified as [off, off + len)
  */
 struct io_uring_file_index_range {
-	__u32	off;
-	__u32	len;
-	__u64	resv;
+	__u32 off;
+	__u32 len;
+	__u64 resv;
 };
 
 struct io_uring_recvmsg_out {
@@ -1035,7 +1049,7 @@ struct io_uring_recvmsg_out {
  * Argument for IORING_OP_URING_CMD when file is a socket
  */
 enum io_uring_socket_op {
-	SOCKET_URING_OP_SIOCINQ		= 0,
+	SOCKET_URING_OP_SIOCINQ = 0,
 	SOCKET_URING_OP_SIOCOUTQ,
 	SOCKET_URING_OP_GETSOCKOPT,
 	SOCKET_URING_OP_SETSOCKOPT,
@@ -1047,15 +1061,15 @@ enum io_uring_socket_op {
  * SOCKET_URING_OP_TX_TIMESTAMP definitions
  */
 
-#define IORING_TIMESTAMP_HW_SHIFT	16
+#define IORING_TIMESTAMP_HW_SHIFT 16
 /* The cqe->flags bit from which the timestamp type is stored */
-#define IORING_TIMESTAMP_TYPE_SHIFT	(IORING_TIMESTAMP_HW_SHIFT + 1)
+#define IORING_TIMESTAMP_TYPE_SHIFT (IORING_TIMESTAMP_HW_SHIFT + 1)
 /* The cqe->flags flag signifying whether it's a hardware timestamp */
-#define IORING_CQE_F_TSTAMP_HW		((__u32)1 << IORING_TIMESTAMP_HW_SHIFT)
+#define IORING_CQE_F_TSTAMP_HW ((__u32)1 << IORING_TIMESTAMP_HW_SHIFT)
 
 struct io_timespec {
-	__u64		tv_sec;
-	__u64		tv_nsec;
+	__u64 tv_sec;
+	__u64 tv_nsec;
 };
 
 #ifdef __cplusplus
diff --git a/io_uring/register.c b/io_uring/register.c
index dce5e2f9cf77..6a6b7f6a169e 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -35,8 +35,8 @@
 #include "query.h"
 #include "bpf_filter.h"
 
-#define IORING_MAX_RESTRICTIONS	(IORING_RESTRICTION_LAST + \
-				 IORING_REGISTER_LAST + IORING_OP_LAST)
+#define IORING_MAX_RESTRICTIONS \
+	(IORING_RESTRICTION_LAST + IORING_REGISTER_LAST + IORING_OP_LAST)
 
 static __cold int io_probe(struct io_ring_ctx *ctx, void __user *arg,
 			   unsigned nr_args)
@@ -86,7 +86,6 @@ int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
 	return -EINVAL;
 }
 
-
 static int io_register_personality(struct io_ring_ctx *ctx)
 {
 	const struct cred *creds;
@@ -96,7 +95,8 @@ static int io_register_personality(struct io_ring_ctx *ctx)
 	creds = get_current_cred();
 
 	ret = xa_alloc_cyclic(&ctx->personalities, &id, (void *)creds,
-			XA_LIMIT(0, USHRT_MAX), &ctx->pers_next, GFP_KERNEL);
+			      XA_LIMIT(0, USHRT_MAX), &ctx->pers_next,
+			      GFP_KERNEL);
 	if (ret < 0) {
 		put_cred(creds);
 		return ret;
@@ -133,7 +133,8 @@ static __cold int io_parse_restrictions(void __user *arg, unsigned int nr_args,
 		case IORING_RESTRICTION_REGISTER_OP:
 			if (res[i].register_op >= IORING_REGISTER_LAST)
 				goto err;
-			__set_bit(res[i].register_op, restrictions->register_op);
+			__set_bit(res[i].register_op,
+				  restrictions->register_op);
 			restrictions->reg_registered = true;
 			break;
 		case IORING_RESTRICTION_SQE_OP:
@@ -165,7 +166,8 @@ static __cold int io_parse_restrictions(void __user *arg, unsigned int nr_args,
 }
 
 static __cold int io_register_restrictions(struct io_ring_ctx *ctx,
-					   void __user *arg, unsigned int nr_args)
+					   void __user *arg,
+					   unsigned int nr_args)
 {
 	int ret;
 
@@ -484,22 +486,23 @@ static void io_register_free_rings(struct io_ring_ctx *ctx,
 	io_free_region(ctx->user, &r->ring_region);
 }
 
-#define swap_old(ctx, o, n, field)		\
-	do {					\
-		(o).field = (ctx)->field;	\
-		(ctx)->field = (n).field;	\
+#define swap_old(ctx, o, n, field)        \
+	do {                              \
+		(o).field = (ctx)->field; \
+		(ctx)->field = (n).field; \
 	} while (0)
 
-#define RESIZE_FLAGS	(IORING_SETUP_CQSIZE | IORING_SETUP_CLAMP)
-#define COPY_FLAGS	(IORING_SETUP_NO_SQARRAY | IORING_SETUP_SQE128 | \
-			 IORING_SETUP_CQE32 | IORING_SETUP_NO_MMAP | \
-			 IORING_SETUP_CQE_MIXED | IORING_SETUP_SQE_MIXED)
+#define RESIZE_FLAGS (IORING_SETUP_CQSIZE | IORING_SETUP_CLAMP)
+#define COPY_FLAGS                                                            \
+	(IORING_SETUP_NO_SQARRAY | IORING_SETUP_SQE128 | IORING_SETUP_CQE32 | \
+	 IORING_SETUP_NO_MMAP | IORING_SETUP_CQE_MIXED |                      \
+	 IORING_SETUP_SQE_MIXED)
 
 static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 {
 	struct io_ctx_config config;
 	struct io_uring_region_desc rd;
-	struct io_ring_ctx_rings o = { }, n = { }, *to_free = NULL;
+	struct io_ring_ctx_rings o = {}, n = {}, *to_free = NULL;
 	unsigned i, tail, old_head;
 	struct io_uring_params *p = &config.p;
 	struct io_rings_layout *rl = &config.layout;
@@ -612,7 +615,8 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 			src_mask = (ctx->sq_entries << 1) - 1;
 			dst_mask = (p->sq_entries << 1) - 1;
 		}
-		memcpy(&n.sq_sqes[index & dst_mask], &o.sq_sqes[index & src_mask], sq_size);
+		memcpy(&n.sq_sqes[index & dst_mask],
+		       &o.sq_sqes[index & src_mask], sq_size);
 	}
 	WRITE_ONCE(n.rings->sq.head, old_head);
 	WRITE_ONCE(n.rings->sq.tail, tail);
@@ -642,7 +646,8 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 			src_mask = (ctx->cq_entries << 1) - 1;
 			dst_mask = (p->cq_entries << 1) - 1;
 		}
-		memcpy(&n.rings->cqes[index & dst_mask], &o.rings->cqes[index & src_mask], cq_size);
+		memcpy(&n.rings->cqes[index & dst_mask],
+		       &o.rings->cqes[index & src_mask], cq_size);
 	}
 	WRITE_ONCE(n.rings->cq.head, old_head);
 	WRITE_ONCE(n.rings->cq.tail, tail);
@@ -666,7 +671,8 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	 * should act on unconditionally. Worst case it'll be an extra
 	 * syscall.
 	 */
-	atomic_or(IORING_SQ_TASKRUN | IORING_SQ_NEED_WAKEUP, &n.rings->sq_flags);
+	atomic_or(IORING_SQ_TASKRUN | IORING_SQ_NEED_WAKEUP,
+		  &n.rings->sq_flags);
 	ctx->rings = n.rings;
 	rcu_assign_pointer(ctx->rings_rcu, n.rings);
 
@@ -738,8 +744,7 @@ static int io_register_mem_region(struct io_ring_ctx *ctx, void __user *uarg)
 
 static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			       void __user *arg, unsigned nr_args)
-	__releases(ctx->uring_lock)
-	__acquires(ctx->uring_lock)
+	__releases(ctx->uring_lock) __acquires(ctx->uring_lock)
 {
 	int ret;
 
@@ -753,7 +758,8 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 	if (ctx->submitter_task && ctx->submitter_task != current)
 		return -EEXIST;
 
-	if ((ctx->int_flags & IO_RING_F_REG_RESTRICTED) && !(ctx->flags & IORING_SETUP_R_DISABLED)) {
+	if ((ctx->int_flags & IO_RING_F_REG_RESTRICTED) &&
+	    !(ctx->flags & IORING_SETUP_R_DISABLED)) {
 		opcode = array_index_nospec(opcode, IORING_REGISTER_LAST);
 		if (!test_bit(opcode, ctx->restrictions.register_op))
 			return -EACCES;
@@ -924,6 +930,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_register_clone_buffers(ctx, arg);
 		break;
+	case IORING_REGISTER_CLONE_FILES:
+		ret = -EINVAL;
+		if (!arg || nr_args != 1)
+			break;
+		ret = io_register_clone_files(ctx, arg);
+		break;
 	case IORING_REGISTER_ZCRX_IFQ:
 		ret = -EINVAL;
 		if (!arg || nr_args != 1)
@@ -966,7 +978,8 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 	return ret;
 }
 
-static int io_uring_register_send_msg_ring(void __user *arg, unsigned int nr_args)
+static int io_uring_register_send_msg_ring(void __user *arg,
+					   unsigned int nr_args)
 {
 	struct io_uring_sqe sqe;
 
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 650303626be6..b7afb2a05f4a 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -21,20 +21,21 @@
 #include "register.h"
 
 struct io_rsrc_update {
-	struct file			*file;
-	u64				arg;
-	u32				nr_args;
-	u32				offset;
+	struct file *file;
+	u64 arg;
+	u32 nr_args;
+	u32 offset;
 };
 
 static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
-			struct iovec *iov, struct page **last_hpage);
+						   struct iovec *iov,
+						   struct page **last_hpage);
 
 /* only define max */
-#define IORING_MAX_FIXED_FILES	(1U << 20)
-#define IORING_MAX_REG_BUFFERS	(1U << 14)
+#define IORING_MAX_FIXED_FILES (1U << 20)
+#define IORING_MAX_REG_BUFFERS (1U << 14)
 
-#define IO_CACHED_BVECS_SEGS	32
+#define IO_CACHED_BVECS_SEGS 32
 
 int __io_account_mem(struct user_struct *user, unsigned long nr_pages)
 {
@@ -51,8 +52,8 @@ int __io_account_mem(struct user_struct *user, unsigned long nr_pages)
 		new_pages = cur_pages + nr_pages;
 		if (new_pages > page_limit)
 			return -ENOMEM;
-	} while (!atomic_long_try_cmpxchg(&user->locked_vm,
-					  &cur_pages, new_pages));
+	} while (!atomic_long_try_cmpxchg(&user->locked_vm, &cur_pages,
+					  new_pages));
 	return 0;
 }
 
@@ -485,8 +486,8 @@ int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
 		ret = io_files_update_with_index_alloc(req, issue_flags);
 	} else {
 		io_ring_submit_lock(ctx, issue_flags);
-		ret = __io_register_rsrc_update(ctx, IORING_RSRC_FILE,
-						&up2, up->nr_args);
+		ret = __io_register_rsrc_update(ctx, IORING_RSRC_FILE, &up2,
+						up->nr_args);
 		io_ring_submit_unlock(ctx, issue_flags);
 	}
 
@@ -529,7 +530,7 @@ int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 			  unsigned nr_args, u64 __user *tags)
 {
-	__s32 __user *fds = (__s32 __user *) arg;
+	__s32 __user *fds = (__s32 __user *)arg;
 	struct file *file;
 	int fd, ret;
 	unsigned i;
@@ -678,7 +679,7 @@ static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
 }
 
 static bool io_coalesce_buffer(struct page ***pages, int *nr_pages,
-				struct io_imu_folio_data *data)
+			       struct io_imu_folio_data *data)
 {
 	struct page **page_array = *pages, **new_array = NULL;
 	unsigned nr_pages_left = *nr_pages;
@@ -732,14 +733,14 @@ bool io_check_coalesce_buffer(struct page **page_array, int nr_pages,
 	 */
 	for (i = 1; i < nr_pages; i++) {
 		if (page_folio(page_array[i]) == folio &&
-			page_array[i] == page_array[i-1] + 1) {
+		    page_array[i] == page_array[i - 1] + 1) {
 			count++;
 			continue;
 		}
 
 		if (nr_folios == 1) {
-			if (folio_page_idx(folio, page_array[i-1]) !=
-				data->nr_pages_mid - 1)
+			if (folio_page_idx(folio, page_array[i - 1]) !=
+			    data->nr_pages_mid - 1)
 				return false;
 
 			data->nr_pages_head = count;
@@ -749,7 +750,7 @@ bool io_check_coalesce_buffer(struct page **page_array, int nr_pages,
 
 		folio = page_folio(page_array[i]);
 		if (folio_size(folio) != (1UL << data->folio_shift) ||
-			folio_page_idx(folio, page_array[i]) != 0)
+		    folio_page_idx(folio, page_array[i]) != 0)
 			return false;
 
 		count = 1;
@@ -792,8 +793,8 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 		return ERR_PTR(-ENOMEM);
 
 	ret = -ENOMEM;
-	pages = io_pin_pages((unsigned long) iov->iov_base, iov->iov_len,
-				&nr_pages);
+	pages = io_pin_pages((unsigned long)iov->iov_base, iov->iov_len,
+			     &nr_pages);
 	if (IS_ERR(pages)) {
 		ret = PTR_ERR(pages);
 		pages = NULL;
@@ -803,7 +804,8 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 	/* If it's huge page(s), try to coalesce them into fewer bvec entries */
 	if (nr_pages > 1 && io_check_coalesce_buffer(pages, nr_pages, &data)) {
 		if (data.nr_pages_mid != 1)
-			coalesced = io_coalesce_buffer(&pages, &nr_pages, &data);
+			coalesced =
+				io_coalesce_buffer(&pages, &nr_pages, &data);
 	}
 
 	imu = io_alloc_imu(ctx, nr_pages);
@@ -817,7 +819,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 
 	size = iov->iov_len;
 	/* store original address for later verification */
-	imu->ubuf = (unsigned long) iov->iov_base;
+	imu->ubuf = (unsigned long)iov->iov_base;
 	imu->len = iov->iov_len;
 	imu->folio_shift = PAGE_SHIFT;
 	imu->release = io_release_ubuf;
@@ -885,8 +887,9 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 		u64 tag = 0;
 
 		if (arg) {
-			uvec = (struct iovec __user *) arg;
-			iov = iovec_from_user(uvec, 1, 1, &fast_iov, io_is_compat(ctx));
+			uvec = (struct iovec __user *)arg;
+			iov = iovec_from_user(uvec, 1, 1, &fast_iov,
+					      io_is_compat(ctx));
 			if (IS_ERR(iov)) {
 				ret = PTR_ERR(iov);
 				break;
@@ -1050,8 +1053,7 @@ static int io_import_kbuf(int ddir, struct iov_iter *iter,
 }
 
 static int io_import_fixed(int ddir, struct iov_iter *iter,
-			   struct io_mapped_ubuf *imu,
-			   u64 buf_addr, size_t len)
+			   struct io_mapped_ubuf *imu, u64 buf_addr, size_t len)
 {
 	const struct bio_vec *bvec;
 	size_t folio_mask;
@@ -1095,7 +1097,8 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
 		bvec += seg_skip;
 		offset &= folio_mask;
 	}
-	nr_segs = (offset + len + bvec->bv_offset + folio_mask) >> imu->folio_shift;
+	nr_segs = (offset + len + bvec->bv_offset + folio_mask) >>
+		  imu->folio_shift;
 	iov_iter_bvec(iter, ddir, bvec, nr_segs, len);
 	iter->iov_offset = offset;
 	return 0;
@@ -1124,9 +1127,8 @@ inline struct io_rsrc_node *io_find_buf_node(struct io_kiocb *req,
 	return NULL;
 }
 
-int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
-			u64 buf_addr, size_t len, int ddir,
-			unsigned issue_flags)
+int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter, u64 buf_addr,
+		      size_t len, int ddir, unsigned int issue_flags)
 {
 	struct io_rsrc_node *node;
 
@@ -1146,7 +1148,8 @@ static void lock_two_rings(struct io_ring_ctx *ctx1, struct io_ring_ctx *ctx2)
 }
 
 /* Both rings are locked by the caller. */
-static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx,
+static int io_clone_buffers(struct io_ring_ctx *ctx,
+			    struct io_ring_ctx *src_ctx,
 			    struct io_uring_clone_buffers *arg)
 {
 	struct io_rsrc_data data;
@@ -1160,7 +1163,8 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 	 * Accounting state is shared between the two rings; that only works if
 	 * both rings are accounted towards the same counters.
 	 */
-	if (ctx->user != src_ctx->user || ctx->mm_account != src_ctx->mm_account)
+	if (ctx->user != src_ctx->user ||
+	    ctx->mm_account != src_ctx->mm_account)
 		return -EINVAL;
 
 	/* if offsets are given, must have nr specified too */
@@ -1268,7 +1272,8 @@ int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg)
 
 	if (copy_from_user(&buf, arg, sizeof(buf)))
 		return -EFAULT;
-	if (buf.flags & ~(IORING_REGISTER_SRC_REGISTERED|IORING_REGISTER_DST_REPLACE))
+	if (buf.flags &
+	    ~(IORING_REGISTER_SRC_REGISTERED | IORING_REGISTER_DST_REPLACE))
 		return -EINVAL;
 	if (!(buf.flags & IORING_REGISTER_DST_REPLACE) && ctx->buf_table.nr)
 		return -EBUSY;
@@ -1303,6 +1308,165 @@ int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg)
 	return ret;
 }
 
+static int io_clone_files(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx,
+			  struct io_uring_clone_files *arg)
+{
+	struct io_file_table new_file_table;
+	int i, off, nr;
+	unsigned int src_nr;
+
+	lockdep_assert_held(&ctx->uring_lock);
+	lockdep_assert_held(&src_ctx->uring_lock);
+
+	/* if offsets are given, must have nr specified too */
+	if (!arg->nr && (arg->dst_off || arg->src_off))
+		return -EINVAL;
+	/* not allowed unless REPLACE is set */
+	if (ctx->file_table.data.nr &&
+	    !(arg->flags & IORING_REGISTER_DST_REPLACE))
+		return -EBUSY;
+
+	src_nr = src_ctx->file_table.data.nr;
+	if (!src_nr)
+		return -ENXIO;
+	if (!arg->nr)
+		arg->nr = src_nr;
+	else if (arg->nr > src_nr)
+		return -EINVAL;
+	else if (arg->nr > IORING_MAX_FIXED_FILES)
+		return -EINVAL;
+	if (check_add_overflow(arg->nr, arg->src_off, &off) || off > src_nr)
+		return -EOVERFLOW;
+	if (check_add_overflow(arg->nr, arg->dst_off, &src_nr))
+		return -EOVERFLOW;
+	if (src_nr > IORING_MAX_FIXED_FILES)
+		return -EINVAL;
+	/* Allocate file tables memory {data + bitmap} into new_file_table */
+	memset(&new_file_table, 0, sizeof(new_file_table));
+	if (!io_alloc_file_tables(ctx, &new_file_table,
+				  max(src_nr, ctx->file_table.data.nr)))
+		return -ENOMEM;
+
+	/* Copy original dst nodes from before the cloned range */
+	for (i = 0; i < min(arg->dst_off, ctx->file_table.data.nr); i++) {
+		struct io_rsrc_node *node = ctx->file_table.data.nodes[i];
+
+		if (node) {
+			new_file_table.data.nodes[i] = node;
+			node->refs++;
+			io_file_bitmap_set(&new_file_table, i);
+		}
+	}
+
+	off = arg->dst_off;
+	i = arg->src_off;
+	nr = arg->nr;
+	while (nr--) {
+		struct io_rsrc_node *dst_node, *src_node;
+
+		src_node = io_rsrc_node_lookup(&src_ctx->file_table.data, i);
+		if (!src_node) {
+			dst_node = NULL;
+		} else {
+			dst_node = io_rsrc_node_alloc(ctx, IORING_RSRC_FILE);
+			if (!dst_node) {
+				io_free_file_tables(ctx, &new_file_table);
+				return -ENOMEM;
+			}
+
+			struct file *file = io_slot_file(src_node);
+
+			get_file(file);
+			io_fixed_file_set(dst_node, file);
+		}
+		new_file_table.data.nodes[off] = dst_node;
+		if (dst_node)
+			io_file_bitmap_set(&new_file_table, off);
+
+		i++;
+		off++;
+	}
+
+	/* Copy original dst nodes from after the cloned range */
+	for (i = src_nr; i < ctx->file_table.data.nr; i++) {
+		struct io_rsrc_node *node = ctx->file_table.data.nodes[i];
+
+		if (node) {
+			new_file_table.data.nodes[i] = node;
+			node->refs++;
+			io_file_bitmap_set(&new_file_table, i);
+		}
+	}
+
+	/*
+	 * If asked for replace, put the old table. new_file_table.data->nodes[] holds both
+	 * old and new nodes at this point.
+	 */
+	if (arg->flags & IORING_REGISTER_DST_REPLACE)
+		io_free_file_tables(ctx, &ctx->file_table);
+
+	/*
+	 * ctx->file_table must be empty now - either the contents are being
+	 * replaced and we just freed the table, or the contents are being
+	 * copied to a ring that does not have buffers yet (checked at function
+	 * entry).
+	 */
+	WARN_ON_ONCE(ctx->file_table.data.nr);
+	ctx->file_table = new_file_table;
+	io_file_table_set_alloc_range(ctx, 0, ctx->file_table.data.nr);
+	return 0;
+}
+
+int io_register_clone_files(struct io_ring_ctx *ctx, void __user *arg)
+{
+	struct io_uring_clone_files clone_arg;
+	struct io_ring_ctx *src_ctx;
+	bool registered_src;
+	struct file *file;
+	int ret;
+
+	if (copy_from_user(&clone_arg, arg, sizeof(clone_arg)))
+		return -EFAULT;
+	if (clone_arg.flags &
+	    ~(IORING_REGISTER_SRC_REGISTERED | IORING_REGISTER_DST_REPLACE))
+		return -EINVAL;
+	/* not allowed unless REPLACE is set */
+	if (!(clone_arg.flags & IORING_REGISTER_DST_REPLACE) &&
+	    ctx->file_table.data.nr)
+		return -EBUSY;
+	if (memchr_inv(clone_arg.pad, 0, sizeof(clone_arg.pad)))
+		return -EINVAL;
+
+	registered_src = (clone_arg.flags & IORING_REGISTER_SRC_REGISTERED) !=
+			 0;
+	file = io_uring_ctx_get_file(clone_arg.src_fd, registered_src);
+	if (IS_ERR(file))
+		return PTR_ERR(file);
+
+	src_ctx = file->private_data;
+	if (src_ctx != ctx) {
+		mutex_unlock(&ctx->uring_lock);
+		lock_two_rings(ctx, src_ctx);
+
+		/* Prevent cross-process hijacking */
+		if (src_ctx->submitter_task &&
+		    src_ctx->submitter_task != current) {
+			ret = -EEXIST;
+			goto out;
+		}
+	}
+
+	ret = io_clone_files(ctx, src_ctx, &clone_arg);
+
+out:
+	if (src_ctx != ctx)
+		mutex_unlock(&src_ctx->uring_lock);
+
+	if (!registered_src)
+		fput(file);
+	return ret;
+}
+
 void io_vec_free(struct iou_vec *iv)
 {
 	if (!iv->iovec)
@@ -1328,9 +1492,8 @@ int io_vec_realloc(struct iou_vec *iv, unsigned nr_entries)
 }
 
 static int io_vec_fill_bvec(int ddir, struct iov_iter *iter,
-				struct io_mapped_ubuf *imu,
-				struct iovec *iovec, unsigned nr_iovs,
-				struct iou_vec *vec)
+			    struct io_mapped_ubuf *imu, struct iovec *iovec,
+			    unsigned int nr_iovs, struct iou_vec *vec)
 {
 	unsigned long folio_size = 1 << imu->folio_shift;
 	unsigned long folio_mask = folio_size - 1;
@@ -1352,7 +1515,8 @@ static int io_vec_fill_bvec(int ddir, struct iov_iter *iter,
 
 		if (unlikely(!iov_len))
 			return -EFAULT;
-		if (unlikely(check_add_overflow(total_len, iov_len, &total_len)))
+		if (unlikely(
+			    check_add_overflow(total_len, iov_len, &total_len)))
 			return -EOVERFLOW;
 
 		offset = buf_addr - imu->ubuf;
@@ -1366,11 +1530,11 @@ static int io_vec_fill_bvec(int ddir, struct iov_iter *iter,
 		offset &= folio_mask;
 
 		for (; iov_len; offset = 0, bvec_idx++, src_bvec++) {
-			size_t seg_size = min_t(size_t, iov_len,
-						folio_size - offset);
+			size_t seg_size =
+				min_t(size_t, iov_len, folio_size - offset);
 
-			bvec_set_page(&res_bvec[bvec_idx],
-				      src_bvec->bv_page, seg_size, offset);
+			bvec_set_page(&res_bvec[bvec_idx], src_bvec->bv_page,
+				      seg_size, offset);
 			iov_len -= seg_size;
 		}
 	}
@@ -1411,7 +1575,7 @@ static int io_vec_fill_kern_bvec(int ddir, struct iov_iter *iter,
 		size_t offset = (size_t)(uintptr_t)iovec[iov_idx].iov_base;
 		size_t iov_len = iovec[iov_idx].iov_len;
 		struct bvec_iter bi = {
-			.bi_size        = offset + iov_len,
+			.bi_size = offset + iov_len,
 		};
 		struct bio_vec bv;
 
@@ -1439,7 +1603,7 @@ static int iov_kern_bvec_size(const struct iovec *iov,
 		return ret;
 
 	for (i = 0; off < offset + iov->iov_len && i < imu->nr_bvecs;
-			off += bvec[i].bv_len, i++) {
+	     off += bvec[i].bv_len, i++) {
 		if (offset >= off && offset < off + bvec[i].bv_len)
 			start = i;
 	}
@@ -1472,9 +1636,9 @@ static int io_kern_bvec_size(struct iovec *iov, unsigned nr_iovs,
 	return 0;
 }
 
-int io_import_reg_vec(int ddir, struct iov_iter *iter,
-			struct io_kiocb *req, struct iou_vec *vec,
-			unsigned nr_iovs, unsigned issue_flags)
+int io_import_reg_vec(int ddir, struct iov_iter *iter, struct io_kiocb *req,
+		      struct iou_vec *vec, unsigned int nr_iovs,
+		      unsigned int issue_flags)
 {
 	struct io_rsrc_node *node;
 	struct io_mapped_ubuf *imu;
@@ -1531,7 +1695,8 @@ int io_import_reg_vec(int ddir, struct iov_iter *iter,
 	}
 
 	if (imu->flags & IO_REGBUF_F_KBUF)
-		return io_vec_fill_kern_bvec(ddir, iter, imu, iov, nr_iovs, vec);
+		return io_vec_fill_kern_bvec(ddir, iter, imu, iov, nr_iovs,
+					     vec);
 
 	return io_vec_fill_bvec(ddir, iter, imu, iov, nr_iovs, vec);
 }
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 44e3386f7c1c..670345be036f 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -5,16 +5,16 @@
 #include <linux/io_uring_types.h>
 #include <linux/lockdep.h>
 
-#define IO_VEC_CACHE_SOFT_CAP		256
+#define IO_VEC_CACHE_SOFT_CAP 256
 
 enum {
-	IORING_RSRC_FILE		= 0,
-	IORING_RSRC_BUFFER		= 1,
+	IORING_RSRC_FILE = 0,
+	IORING_RSRC_BUFFER = 1,
 };
 
 struct io_rsrc_node {
-	unsigned char			type;
-	int				refs;
+	unsigned char type;
+	int refs;
 
 	u64 tag;
 	union {
@@ -24,36 +24,36 @@ struct io_rsrc_node {
 };
 
 enum {
-	IO_IMU_DEST	= 1 << ITER_DEST,
-	IO_IMU_SOURCE	= 1 << ITER_SOURCE,
+	IO_IMU_DEST = 1 << ITER_DEST,
+	IO_IMU_SOURCE = 1 << ITER_SOURCE,
 };
 
 enum {
-	IO_REGBUF_F_KBUF		= 1,
+	IO_REGBUF_F_KBUF = 1,
 };
 
 struct io_mapped_ubuf {
-	u64		ubuf;
-	unsigned int	len;
-	unsigned int	nr_bvecs;
-	unsigned int    folio_shift;
-	refcount_t	refs;
-	unsigned long	acct_pages;
-	void		(*release)(void *);
-	void		*priv;
-	u8		flags;
-	u8		dir;
-	struct bio_vec	bvec[] __counted_by(nr_bvecs);
+	u64 ubuf;
+	unsigned int len;
+	unsigned int nr_bvecs;
+	unsigned int folio_shift;
+	refcount_t refs;
+	unsigned long acct_pages;
+	void (*release)(void *data);
+	void *priv;
+	u8 flags;
+	u8 dir;
+	struct bio_vec bvec[] __counted_by(nr_bvecs);
 };
 
 struct io_imu_folio_data {
 	/* Head folio can be partially included in the fixed buf */
-	unsigned int	nr_pages_head;
+	unsigned int nr_pages_head;
 	/* For non-head/tail folios, has to be fully included */
-	unsigned int	nr_pages_mid;
-	unsigned int	folio_shift;
-	unsigned int	nr_folios;
-	unsigned long	first_folio_page_idx;
+	unsigned int nr_pages_mid;
+	unsigned int folio_shift;
+	unsigned int nr_folios;
+	unsigned long first_folio_page_idx;
 };
 
 bool io_rsrc_cache_init(struct io_ring_ctx *ctx);
@@ -65,16 +65,16 @@ int io_rsrc_data_alloc(struct io_rsrc_data *data, unsigned nr);
 
 struct io_rsrc_node *io_find_buf_node(struct io_kiocb *req,
 				      unsigned issue_flags);
-int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
-			u64 buf_addr, size_t len, int ddir,
-			unsigned issue_flags);
-int io_import_reg_vec(int ddir, struct iov_iter *iter,
-			struct io_kiocb *req, struct iou_vec *vec,
-			unsigned nr_iovs, unsigned issue_flags);
+int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter, u64 buf_addr,
+		      size_t len, int ddir, unsigned int issue_flags);
+int io_import_reg_vec(int ddir, struct iov_iter *iter, struct io_kiocb *req,
+		      struct iou_vec *vec, unsigned int nr_iovs,
+		      unsigned int issue_flags);
 int io_prep_reg_iovec(struct io_kiocb *req, struct iou_vec *iv,
-			const struct iovec __user *uvec, size_t uvec_segs);
+		      const struct iovec __user *uvec, size_t uvec_segs);
 
 int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg);
+int io_register_clone_files(struct io_ring_ctx *ctx, void __user *arg);
 int io_sqe_buffers_unregister(struct io_ring_ctx *ctx);
 int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 			    unsigned int nr_args, u64 __user *tags);
@@ -87,21 +87,22 @@ int io_register_files_update(struct io_ring_ctx *ctx, void __user *arg,
 int io_register_rsrc_update(struct io_ring_ctx *ctx, void __user *arg,
 			    unsigned size, unsigned type);
 int io_register_rsrc(struct io_ring_ctx *ctx, void __user *arg,
-			unsigned int size, unsigned int type);
+		     unsigned int size, unsigned int type);
 int io_validate_user_buf_range(u64 uaddr, u64 ulen);
 
 bool io_check_coalesce_buffer(struct page **page_array, int nr_pages,
 			      struct io_imu_folio_data *data);
 
-static inline struct io_rsrc_node *io_rsrc_node_lookup(struct io_rsrc_data *data,
-						       unsigned int index)
+static inline struct io_rsrc_node *
+io_rsrc_node_lookup(struct io_rsrc_data *data, unsigned int index)
 {
 	if (index < data->nr)
 		return data->nodes[array_index_nospec(index, data->nr)];
 	return NULL;
 }
 
-static inline void io_put_rsrc_node(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
+static inline void io_put_rsrc_node(struct io_ring_ctx *ctx,
+				    struct io_rsrc_node *node)
 {
 	lockdep_assert_held(&ctx->uring_lock);
 	if (!--node->refs)
@@ -143,8 +144,8 @@ static inline void __io_unaccount_mem(struct user_struct *user,
 void io_vec_free(struct iou_vec *iv);
 int io_vec_realloc(struct iou_vec *iv, unsigned nr_entries);
 
-static inline void io_vec_reset_iovec(struct iou_vec *iv,
-				      struct iovec *iovec, unsigned nr)
+static inline void io_vec_reset_iovec(struct iou_vec *iv, struct iovec *iovec,
+				      unsigned int nr)
 {
 	io_vec_free(iv);
 	iv->iovec = iovec;
-- 
2.54.0


