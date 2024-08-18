Return-Path: <io-uring+bounces-2824-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B9C7C955E9A
	for <lists+io-uring@lfdr.de>; Sun, 18 Aug 2024 20:55:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2F795B20DC3
	for <lists+io-uring@lfdr.de>; Sun, 18 Aug 2024 18:55:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 604FC14EC44;
	Sun, 18 Aug 2024 18:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TyYOGSnW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4FB145A07
	for <io-uring@vger.kernel.org>; Sun, 18 Aug 2024 18:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724007330; cv=none; b=tg/dBlme4m4DcjzLGARBiQrY5qIW1rfNY5ysye3ZkNxoFtqof1hKmep8O/zheH6/s0wiRJ+kmYChQKWoVSnK2eNCOVnZM82KpCrgAsYzTNhyMi86oMb2GXYAR7ndTRdPZec1BYFyzDhEG4J6xPTogPPfGRqUVJnxS7Qds8TV/Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724007330; c=relaxed/simple;
	bh=vDKYFSd6WIDGzxYRQAgA8Y6OXbyH3BGxmEHucEII6/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mPTyqFi22PvYJOXrq0I8HCKj0StxRg7s1o/7P9Fn1NJS9UC90dxoEiOFkYjbQEqm9DnU1ndyekoHXCjcWPuTt67OvXiqCuPGB0exfqKStUvKgnfgLtc/D9UPKhUjRp9cJwGGcLXHWV6I2mNvjg0mzrfjPMEVRAM0clOXsg6mC8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TyYOGSnW; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5bd1a9bdce4so4490456a12.3
        for <io-uring@vger.kernel.org>; Sun, 18 Aug 2024 11:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724007326; x=1724612126; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VFiiYnDLsEJ9nMUfwvkt3h/S99VDnPvziXfLLXPYz7s=;
        b=TyYOGSnWzAglIJSumDgj9qChn9R/Y7noePXepOYW7UvDaiWGZ5Y1YmIwFjikg3bi6L
         buvHRW4y7hPJ+pviK7J/MucT49spBgh8SEur+/OxDF11tkRCBiTxqAxJs6y838L2It9S
         1OTs7l6S+1wYkmLNsD51Acqeeg9IrNZtbMypIuYsfslo1RWD9N9AKEpQEEQWmQ8ysNMb
         Gbx3d9/zCz4GxF8q7wbwqGNLDnumutuclIDpwAX2OFmKmizJ4CbPrSkp45Xrh2duN0+t
         FNNevUG0C2vw4ESJbmDjz0uwdAvaHRW+xxfUECULO7nQb1Uc5/Rf6NXjRpbmaeW4FnoV
         OahA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724007326; x=1724612126;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VFiiYnDLsEJ9nMUfwvkt3h/S99VDnPvziXfLLXPYz7s=;
        b=G/M24eLEUb/FWW1g7ob3wQhiho1qpF8/6Bx+GYpam/L6y1sD3CvP3v+r4sqGZA8ada
         XgjVDHCUWS/rREd7JFUvX4y+H5VPBr8/6ot2DZeXWWmZDQbj0yAU+ywEUb3BLu+jOwkc
         z1ig533+EOZ/Ci6SpVKDCb74OgOtogVrnqS8qUVqUVO+f8OPzZWD90c36CiUoKvYXVnl
         KwatUGEq0kO6VsAr3g/BwivBMxD0pBHT4KjURlXmDoFmn92XgMP2PXTE0OCKUUd9TVKo
         N3gTxG1el0oJ6eCKRD9eDYp86ecpqFs+ZwqkAmR2mLBMTnYcjLOg8gU+Pyh9E/nBaPYn
         VFrQ==
X-Gm-Message-State: AOJu0YzNDen7nstlo6cn0GEvhxN77AWyUOYxRk1E+jJlQooEl0aDwiOP
	05gu5jefKT58UCAYxxbsrhdbG73mQBN9Q3AYrhKDtkQpOGzF9obMmTny2Q==
X-Google-Smtp-Source: AGHT+IE6uv5fpilHFJKHnzQ6vumTwk3lM8Yz9w2D7wejQpQ4lyuc9dB5clrWzGbGfu2W5MXGDo3DSg==
X-Received: by 2002:a50:8dc7:0:b0:5a4:622f:63c6 with SMTP id 4fb4d7f45d1cf-5beca56264emr4394177a12.13.1724007326038;
        Sun, 18 Aug 2024 11:55:26 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.74])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5bebbbe274asm4867959a12.8.2024.08.18.11.55.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Aug 2024 11:55:25 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH liburing 1/4] Sync kernel headers
Date: Sun, 18 Aug 2024 19:55:41 +0100
Message-ID: <4a613f7a38b4c9df7e1e7679a6e7e9cecc581ecc.1724007045.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1724007045.git.asml.silence@gmail.com>
References: <cover.1724007045.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Synchronise io_uring.h with kernel, pull IORING_REGISTER_CLOCK and all
other changes.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/include/liburing/io_uring.h | 67 ++++++++++++++++++++-------------
 1 file changed, 40 insertions(+), 27 deletions(-)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 01c36a8..48c440e 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -116,7 +116,7 @@ struct io_uring_sqe {
  */
 #define IORING_FILE_INDEX_ALLOC		(~0U)
 
-enum {
+enum io_uring_sqe_flags_bit {
 	IOSQE_FIXED_FILE_BIT,
 	IOSQE_IO_DRAIN_BIT,
 	IOSQE_IO_LINK_BIT,
@@ -184,7 +184,7 @@ enum {
 #define IORING_SETUP_DEFER_TASKRUN	(1U << 13)
 
 /*
- * Application provides ring memory
+ * Application provides the memory for the rings
  */
 #define IORING_SETUP_NO_MMAP		(1U << 14)
 
@@ -265,11 +265,12 @@ enum io_uring_op {
 };
 
 /*
- * sqe->uring_cmd_flags
+ * sqe->uring_cmd_flags		top 8bits aren't available for userspace
  * IORING_URING_CMD_FIXED	use registered buffer; pass this flag
  *				along with setting sqe->buf_index.
  */
 #define IORING_URING_CMD_FIXED	(1U << 0)
+#define IORING_URING_CMD_MASK	IORING_URING_CMD_FIXED
 
 
 /*
@@ -317,15 +318,19 @@ enum io_uring_op {
  * ASYNC_CANCEL flags.
  *
  * IORING_ASYNC_CANCEL_ALL	Cancel all requests that match the given key
- * IORING_ASYNC_CANCEL_FD	  Key off 'fd' for cancelation rather than the
+ * IORING_ASYNC_CANCEL_FD	Key off 'fd' for cancelation rather than the
  *				request 'user_data'
  * IORING_ASYNC_CANCEL_ANY	Match any request
  * IORING_ASYNC_CANCEL_FD_FIXED	'fd' passed in is a fixed descriptor
+ * IORING_ASYNC_CANCEL_USERDATA	Match on user_data, default for no other key
+ * IORING_ASYNC_CANCEL_OP	Match request based on opcode
  */
 #define IORING_ASYNC_CANCEL_ALL	(1U << 0)
 #define IORING_ASYNC_CANCEL_FD	(1U << 1)
 #define IORING_ASYNC_CANCEL_ANY	(1U << 2)
 #define IORING_ASYNC_CANCEL_FD_FIXED	(1U << 3)
+#define IORING_ASYNC_CANCEL_USERDATA	(1U << 4)
+#define IORING_ASYNC_CANCEL_OP	(1U << 5)
 
 /*
  * send/sendmsg and recv/recvmsg flags (sqe->ioprio)
@@ -350,13 +355,13 @@ enum io_uring_op {
  *				IORING_NOTIF_USAGE_ZC_COPIED if data was copied
  *				(at least partially).
  *
- * IORING_RECVSEND_BUNDLE	Used with IOSQE_BUFFER_SELECT. If set, send wil
- *				grab as many buffers from the buffer group ID
- *				given and send them all. The completion result
- *				will be the number of buffers send, with the
- *				starting buffer ID in cqe->flags as per usual
- *				for provided buffer usage. The buffers will be
- *				contigious from the starting buffer ID.
+ * IORING_RECVSEND_BUNDLE	Used with IOSQE_BUFFER_SELECT. If set, send or
+ *				recv will grab as many buffers from the buffer
+ *				group ID given and send them all. The completion
+ *				result 	will be the number of buffers send, with
+ *				the starting buffer ID in cqe->flags as per
+ *				usual for provided buffer usage. The buffers
+ *				will be	contigious from the starting buffer ID.
  */
 #define IORING_RECVSEND_POLL_FIRST	(1U << 0)
 #define IORING_RECV_MULTISHOT		(1U << 1)
@@ -383,7 +388,7 @@ enum io_uring_op {
 /*
  * IORING_OP_MSG_RING command types, stored in sqe->addr
  */
-enum {
+enum io_uring_msg_ring_flags {
 	IORING_MSG_DATA,	/* pass sqe->len as 'res' and off as user_data */
 	IORING_MSG_SEND_FD,	/* send a registered fd to another ring */
 };
@@ -416,7 +421,7 @@ enum {
  * IO completion data structure (Completion Queue Entry)
  */
 struct io_uring_cqe {
-	__u64	user_data;	/* sqe->user_data value passed back */
+	__u64	user_data;	/* sqe->data submission passed back */
 	__s32	res;		/* result code for this event */
 	__u32	flags;
 
@@ -441,9 +446,7 @@ struct io_uring_cqe {
 #define IORING_CQE_F_SOCK_NONEMPTY	(1U << 2)
 #define IORING_CQE_F_NOTIF		(1U << 3)
 
-enum {
-	IORING_CQE_BUFFER_SHIFT		= 16,
-};
+#define IORING_CQE_BUFFER_SHIFT		16
 
 /*
  * Magic offsets for the application to mmap the data it needs
@@ -504,6 +507,7 @@ struct io_cqring_offsets {
 #define IORING_ENTER_SQ_WAIT		(1U << 2)
 #define IORING_ENTER_EXT_ARG		(1U << 3)
 #define IORING_ENTER_REGISTERED_RING	(1U << 4)
+#define IORING_ENTER_ABS_TIMER		(1U << 5)
 
 /*
  * Passed in for io_uring_setup(2). Copied back with updated info on success
@@ -543,7 +547,7 @@ struct io_uring_params {
 /*
  * io_uring_register(2) opcodes and arguments
  */
-enum {
+enum io_uring_register_op {
 	IORING_REGISTER_BUFFERS			= 0,
 	IORING_UNREGISTER_BUFFERS		= 1,
 	IORING_REGISTER_FILES			= 2,
@@ -592,6 +596,8 @@ enum {
 	IORING_REGISTER_NAPI			= 27,
 	IORING_UNREGISTER_NAPI			= 28,
 
+	IORING_REGISTER_CLOCK			= 29,
+
 	/* this goes last */
 	IORING_REGISTER_LAST,
 
@@ -600,7 +606,7 @@ enum {
 };
 
 /* io-wq worker categories */
-enum {
+enum io_wq_type {
 	IO_WQ_BOUND,
 	IO_WQ_UNBOUND,
 };
@@ -672,6 +678,11 @@ struct io_uring_restriction {
 	__u32 resv2[3];
 };
 
+struct io_uring_clock_register {
+	__u32	clockid;
+	__u32	__resv[3];
+};
+
 struct io_uring_buf {
 	__u64	addr;
 	__u32	len;
@@ -691,7 +702,7 @@ struct io_uring_buf_ring {
 			__u16	resv3;
 			__u16	tail;
 		};
-		struct io_uring_buf	bufs[0];
+		__DECLARE_FLEX_ARRAY(struct io_uring_buf, bufs);
 	};
 };
 
@@ -705,7 +716,7 @@ struct io_uring_buf_ring {
  *			IORING_OFF_PBUF_RING | (bgid << IORING_OFF_PBUF_SHIFT)
  *			to get a virtual mapping for the ring.
  */
-enum {
+enum io_uring_register_pbuf_ring_flags {
 	IOU_PBUF_RING_MMAP	= 1,
 };
 
@@ -727,16 +738,16 @@ struct io_uring_buf_status {
 
 /* argument for IORING_(UN)REGISTER_NAPI */
 struct io_uring_napi {
-	__u32   busy_poll_to;
-	__u8    prefer_busy_poll;
-	__u8    pad[3];
-	__u64   resv;
+	__u32	busy_poll_to;
+	__u8	prefer_busy_poll;
+	__u8	pad[3];
+	__u64	resv;
 };
 
 /*
  * io_uring_restriction->opcode values
  */
-enum {
+enum io_uring_register_restriction_op {
 	/* Allow an io_uring_register(2) opcode */
 	IORING_RESTRICTION_REGISTER_OP		= 0,
 
@@ -767,7 +778,9 @@ struct io_uring_sync_cancel_reg {
 	__s32				fd;
 	__u32				flags;
 	struct __kernel_timespec	timeout;
-	__u64				pad[4];
+	__u8				opcode;
+	__u8				pad[7];
+	__u64				pad2[3];
 };
 
 /*
@@ -790,7 +803,7 @@ struct io_uring_recvmsg_out {
 /*
  * Argument for IORING_OP_URING_CMD when file is a socket
  */
-enum {
+enum io_uring_socket_op {
 	SOCKET_URING_OP_SIOCINQ		= 0,
 	SOCKET_URING_OP_SIOCOUTQ,
 	SOCKET_URING_OP_GETSOCKOPT,
-- 
2.45.2


