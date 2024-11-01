Return-Path: <io-uring+bounces-4310-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B3F7F9B9423
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 16:15:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 704A02828AE
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 15:15:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8958E1C303A;
	Fri,  1 Nov 2024 15:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="0kH0a2Fc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5DA13D244
	for <io-uring@vger.kernel.org>; Fri,  1 Nov 2024 15:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730474136; cv=none; b=tSeZvXot01cDXY0sVPI2sS5qU8J2nMOJJV9Cw+wWvDcX89VAoiPLAYglHc3wly0BV0R/kzzonawbxa0z/8jOJFSwjaaqb+IXy9xx8arMJYJk3zULgdMnr5AVcXXA50nIY0DTKhOQix6JpfZ3aCNwWpBUjQgU4KfS99WEvTZEJdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730474136; c=relaxed/simple;
	bh=G19/r1v/1+EeuHLRlpl4tlWtSgtbP/YiYwDdar4HPIs=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=BFIehPzCVs5YYGyj41zaiTwmGRpXRV9XOCqH2fnJVlh4Pth2ru8TSH6JFiSyieO6+gKjU3vQ2Wyv51xt3bVN+ZSa33Lt7juxKiRMBgdTp4Yx5QuqrtYJXWueTs1YUiHqqVkWJmaQJnLpTrrXUjZVMNQRQXhgEIOTMu85lZrweNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=0kH0a2Fc; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-71e49ad46b1so1752410b3a.1
        for <io-uring@vger.kernel.org>; Fri, 01 Nov 2024 08:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730474130; x=1731078930; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LrwHmOQ6nuJVf75W8pUc0goTMrLz/yz1Utt8eWCUPtQ=;
        b=0kH0a2Fc5DKH21CySF/jcbav1PHYn+5ockGEiTjidvtC1qcoIjzuwj9EF1nqHjZ8JC
         4rTLpOtCtS4+GSgvgM8PteAxs9JSoPqOlZgKD1naAipQiLHtgYo9zZhSxLbvUlniQVpU
         v2JCF+nxTVFlVrb6CdBsnb9WLJoaYRI7WGd9NPhESoNMTgKPudhoIhQuCdrMzN1JSImS
         6hKrDNkgRrAru+RXcN6tyE1w8nF+RUvmjdfmG29dxHS/bS85BruAr4PYKNbVpbPEZQ+I
         Udjc0Q13OkP0mCnoNPPWKkeU3hMpOZjL5N32cunMitquAPtXdkmTlDysSOEEKLX5yofB
         5rsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730474130; x=1731078930;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LrwHmOQ6nuJVf75W8pUc0goTMrLz/yz1Utt8eWCUPtQ=;
        b=G4GpqH+yQOZvG1a6uP/Sy7A8rDeTFioxcUtnzS0zmE1Fon61bgUKHyr9Z79wR3THnn
         OuL+3y/qC7I/Szj9eKiuaBCOANc93QuzkA8i7glc9y0aWsYYUWHaOXiD5A6IGRIB5gTI
         f52INv3iWgnkW8vxPO4o3EH3GkD+qPBKNdH1d7daZ9rEld73P2vD3Q/RHGxKEmvBRL3p
         7KlWhCxUt00Fz9ITGayCBvVDU2jPLU51uMHjDaJEXGobpTYoDvSUj/PQ7L3lsxi3BD/w
         18ApA70LhfAdKweQb+cP/6QOKwyQWhbMKy2SqOXANcvpFfXfPTI3JP0eDbu3aB3spK3O
         c4ZA==
X-Gm-Message-State: AOJu0YzNEDbMu0X7bcEKKgUNokByOQjcgfkLU4XC1g18b0SfdiZJRsAa
	84vEjSAJzMrdV8mJRqS0VRGs63HIUe+QKp/vtUVPb/NOTGQt5jOHQxrS47L1Aaqvlj7JAELCLVg
	xGIY=
X-Google-Smtp-Source: AGHT+IFrWz07aYP8GGXpEBmh/rIFamWXFa4XZUZa+sfnFcwl7uhau36/xhIuUxELSoN9jTBs+C7I/A==
X-Received: by 2002:a05:6a00:ccf:b0:71e:7745:85b8 with SMTP id d2e1a72fcca58-72062f4e66cmr30200837b3a.1.1730474130124;
        Fri, 01 Nov 2024 08:15:30 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-720bc1eac2fsm2730532b3a.72.2024.11.01.08.15.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Nov 2024 08:15:29 -0700 (PDT)
Message-ID: <d86e060f-be37-4efe-8d58-95cf8a22d37e@kernel.dk>
Date: Fri, 1 Nov 2024 09:15:28 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
Cc: Ming Lei <ming.lei@redhat.com>, Pavel Begunkov <asml.silence@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2] io_uring: extend io_uring_sqe flags bits
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

In hindsight everything is clearer, but it probably should've been known
that 8 bits of ->flags would run out sooner than later. Rather than
gobble up the last bit for a random use case, add a bit that controls
whether or not ->personality is used as a flags2 argument. If that is
the case, then there's a new IOSQE2_PERSONALITY flag that tells io_uring
which personality field to read.

While this isn't the prettiest, it does allow extending with 15 extra
flags, and retains being able to use personality with any kind of
command. The exception is uring cmd, where personality2 will overlap
with the space set aside for SQE128. If they really need that, then that
would have to be done via a uring cmd flag.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

V2:
- Fix shift of fixed file flags
- Add a few comments
- Update trace event
- Nicer numbering
- Overlap flags2 with uring cmd, and leave addr3 free to be used with
  flags2

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index d52fec533c51..7b04d34aa8bb 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -438,6 +438,7 @@ struct io_tw_state {
 };
 
 enum {
+	/* 8 bits of sqe->flags */
 	REQ_F_FIXED_FILE_BIT	= IOSQE_FIXED_FILE_BIT,
 	REQ_F_IO_DRAIN_BIT	= IOSQE_IO_DRAIN_BIT,
 	REQ_F_LINK_BIT		= IOSQE_IO_LINK_BIT,
@@ -445,9 +446,16 @@ enum {
 	REQ_F_FORCE_ASYNC_BIT	= IOSQE_ASYNC_BIT,
 	REQ_F_BUFFER_SELECT_BIT	= IOSQE_BUFFER_SELECT_BIT,
 	REQ_F_CQE_SKIP_BIT	= IOSQE_CQE_SKIP_SUCCESS_BIT,
+	REQ_F_FLAGS2_BIT	= IOSQE_FLAGS2_BIT,
 
-	/* first byte is taken by user flags, shift it to not overlap */
-	REQ_F_FAIL_BIT		= 8,
+	/* 16 bits of sqe->flags2 */
+	REQ_F_PERSONALITY_BIT	= IOSQE2_PERSONALITY_BIT,
+
+	/* first byte taken by sqe->flags, next 2 by sqe->flags2 */
+	REQ_F_FAIL_BIT		= 24,
+	/* keep async read/write and isreg together and in order */
+	REQ_F_SUPPORT_NOWAIT_BIT,
+	REQ_F_ISREG_BIT,
 	REQ_F_INFLIGHT_BIT,
 	REQ_F_CUR_POS_BIT,
 	REQ_F_NOWAIT_BIT,
@@ -467,9 +475,6 @@ enum {
 	REQ_F_DOUBLE_POLL_BIT,
 	REQ_F_APOLL_MULTISHOT_BIT,
 	REQ_F_CLEAR_POLLIN_BIT,
-	/* keep async read/write and isreg together and in order */
-	REQ_F_SUPPORT_NOWAIT_BIT,
-	REQ_F_ISREG_BIT,
 	REQ_F_POLL_NO_LAZY_BIT,
 	REQ_F_CAN_POLL_BIT,
 	REQ_F_BL_EMPTY_BIT,
@@ -498,6 +503,10 @@ enum {
 	REQ_F_BUFFER_SELECT	= IO_REQ_FLAG(REQ_F_BUFFER_SELECT_BIT),
 	/* IOSQE_CQE_SKIP_SUCCESS */
 	REQ_F_CQE_SKIP		= IO_REQ_FLAG(REQ_F_CQE_SKIP_BIT),
+	/* ->flags2 is valid */
+	REQ_F_FLAGS2		= IO_REQ_FLAG(REQ_F_FLAGS2_BIT),
+
+	REQ_F_PERSONALITY	= IO_REQ_FLAG(REQ_F_PERSONALITY_BIT),
 
 	/* fail rest of links */
 	REQ_F_FAIL		= IO_REQ_FLAG(REQ_F_FAIL_BIT),
diff --git a/include/trace/events/io_uring.h b/include/trace/events/io_uring.h
index fb81c533b310..07c3c0d80a7d 100644
--- a/include/trace/events/io_uring.h
+++ b/include/trace/events/io_uring.h
@@ -538,8 +538,8 @@ TRACE_EVENT(io_uring_req_failed,
 	TP_printk("ring %p, req %p, user_data 0x%llx, "
 		  "opcode %s, flags 0x%x, prio=%d, off=%llu, addr=%llu, "
 		  "len=%u, rw_flags=0x%x, buf_index=%d, "
-		  "personality=%d, file_index=%d, pad=0x%llx, addr3=%llx, "
-		  "error=%d",
+		  "personality/flags2=0x%x, file_index=%d, pad=0x%llx, "
+		  "addr3=%llx, error=%d",
 		  __entry->ctx, __entry->req, __entry->user_data,
 		  __get_str(op_str),
 		  __entry->flags, __entry->ioprio,
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 47977a5c65f5..d4cb2a90e94d 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -82,8 +82,12 @@ struct io_uring_sqe {
 		/* for grouped buffer selection */
 		__u16	buf_group;
 	} __attribute__((packed));
-	/* personality to use, if used */
-	__u16	personality;
+	union {
+		/* personality to use, if used */
+		__u16	personality;
+		/* 2nd set of flags, can't be used with personality */
+		__u16	flags2;
+	};
 	union {
 		__s32	splice_fd_in;
 		__u32	file_index;
@@ -96,7 +100,9 @@ struct io_uring_sqe {
 	union {
 		struct {
 			__u64	addr3;
-			__u64	__pad2[1];
+			/* personality to use, if IOSQE2_PERSONALITY set */
+			__u16	personality2;
+			__u16	__pad2[3];
 		};
 		__u64	optval;
 		/*
@@ -124,6 +130,11 @@ enum io_uring_sqe_flags_bit {
 	IOSQE_ASYNC_BIT,
 	IOSQE_BUFFER_SELECT_BIT,
 	IOSQE_CQE_SKIP_SUCCESS_BIT,
+	IOSQE_FLAGS2_BIT,
+};
+
+enum io_uring_sqe_flags2_bit {
+	IOSQE2_PERSONALITY_BIT	= IOSQE_FLAGS2_BIT + 1,
 };
 
 /*
@@ -143,6 +154,14 @@ enum io_uring_sqe_flags_bit {
 #define IOSQE_BUFFER_SELECT	(1U << IOSQE_BUFFER_SELECT_BIT)
 /* don't post CQE if request succeeded */
 #define IOSQE_CQE_SKIP_SUCCESS	(1U << IOSQE_CQE_SKIP_SUCCESS_BIT)
+/* ->flags2 is valid */
+#define IOSQE_FLAGS2		(1U << IOSQE_FLAGS2_BIT)
+
+/*
+ * sqe->flags2
+ */
+ /* if set, sqe->personality2 contains personality */
+#define IOSQE2_PERSONALITY	(1U << IOSQE2_PERSONALITY_BIT)
 
 /*
  * io_uring_setup() flags
diff --git a/io_uring/filetable.h b/io_uring/filetable.h
index bfacadb8d089..2cf344c389c3 100644
--- a/io_uring/filetable.h
+++ b/io_uring/filetable.h
@@ -52,7 +52,7 @@ static inline struct file *io_slot_file(struct io_rsrc_node *node)
 static inline void io_fixed_file_set(struct io_rsrc_node *node,
 				     struct file *file)
 {
-	node->file_ptr = (unsigned long)file |
+	node->file_ptr = (__u64)file |
 		(io_file_get_flags(file) >> REQ_F_SUPPORT_NOWAIT_BIT);
 }
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 7a7a9b9718ec..729fe0a86c19 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -109,7 +109,8 @@
 			  IOSQE_IO_HARDLINK | IOSQE_ASYNC)
 
 #define SQE_VALID_FLAGS	(SQE_COMMON_FLAGS | IOSQE_BUFFER_SELECT | \
-			IOSQE_IO_DRAIN | IOSQE_CQE_SKIP_SUCCESS)
+			IOSQE_IO_DRAIN | IOSQE_CQE_SKIP_SUCCESS | \
+			IOSQE_FLAGS2 | IOSQE2_PERSONALITY)
 
 #define IO_REQ_CLEAN_FLAGS (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP | \
 				REQ_F_POLLED | REQ_F_INFLIGHT | REQ_F_CREDS | \
@@ -2033,6 +2034,8 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	req->opcode = opcode = READ_ONCE(sqe->opcode);
 	/* same numerical values with corresponding REQ_F_*, safe to copy */
 	sqe_flags = READ_ONCE(sqe->flags);
+	if (sqe_flags & REQ_F_FLAGS2)
+		sqe_flags |= (__u32) READ_ONCE(sqe->flags2) << 8;
 	req->flags = (__force io_req_flags_t) sqe_flags;
 	req->cqe.user_data = READ_ONCE(sqe->user_data);
 	req->file = NULL;
@@ -2096,8 +2099,12 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		}
 	}
 
-	personality = READ_ONCE(sqe->personality);
-	if (personality) {
+	personality = 0;
+	if (req->flags & REQ_F_PERSONALITY)
+		personality = READ_ONCE(sqe->personality2);
+	else if (!(req->flags & REQ_F_FLAGS2))
+		personality = READ_ONCE(sqe->personality);
+	if (unlikely(personality)) {
 		int ret;
 
 		req->creds = xa_load(&ctx->personalities, personality);
@@ -3913,7 +3920,7 @@ static int __init io_uring_init(void)
 	BUILD_BUG_SQE_ELEM(46, __u16,  __pad3[0]);
 	BUILD_BUG_SQE_ELEM(48, __u64,  addr3);
 	BUILD_BUG_SQE_ELEM_SIZE(48, 0, cmd);
-	BUILD_BUG_SQE_ELEM(56, __u64,  __pad2);
+	BUILD_BUG_SQE_ELEM(58, __u16,  __pad2[0]);
 
 	BUILD_BUG_ON(sizeof(struct io_uring_files_update) !=
 		     sizeof(struct io_uring_rsrc_update));
@@ -3925,9 +3932,6 @@ static int __init io_uring_init(void)
 	BUILD_BUG_ON(offsetof(struct io_uring_buf, resv) !=
 		     offsetof(struct io_uring_buf_ring, tail));
 
-	/* should fit into one byte */
-	BUILD_BUG_ON(SQE_VALID_FLAGS >= (1 << 8));
-	BUILD_BUG_ON(SQE_COMMON_FLAGS >= (1 << 8));
 	BUILD_BUG_ON((SQE_VALID_FLAGS | SQE_COMMON_FLAGS) != SQE_VALID_FLAGS);
 
 	BUILD_BUG_ON(__REQ_F_LAST_BIT > 8 * sizeof_field(struct io_kiocb, flags));
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 535909a38e76..e86dea1173f3 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -200,7 +200,8 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
 
-	if (sqe->__pad1)
+	/* uring cmd doesn't support setting a personality */
+	if (sqe->__pad1 || req->flags & REQ_F_PERSONALITY)
 		return -EINVAL;
 
 	ioucmd->flags = READ_ONCE(sqe->uring_cmd_flags);

-- 
Jens Axboe


