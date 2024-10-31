Return-Path: <io-uring+bounces-4285-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 51F0E9B8534
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 22:22:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 917FEB20E01
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 21:22:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38AAE1BB6B5;
	Thu, 31 Oct 2024 21:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Dj2ZIDJP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412CE1CCB36
	for <io-uring@vger.kernel.org>; Thu, 31 Oct 2024 21:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730409751; cv=none; b=Ayroz16CI7uy2FLS8hejKClM9UQqgsym684gNmfD9klQFz26HxX4kteOLb/ooTxKxLHEkVt3sgcvFgGaDVhHoPkBps93NSRIzd0MT/HO+bDzQkspCoxMbGQkyOnXVwjMI2AElqZLiOoa6axCTWYtMqC1ZGT2LPSSg/TBrFXfbUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730409751; c=relaxed/simple;
	bh=NmQ3w1C9gDlAiSnZ4/aCN1riWjwU0i9ohYSPRwof9tk=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=EitbAHwmdwYOISZepcIvKwQwX4d2vhiQCOrL1bOCetWU975KgoSd4mCiKAGlcxbGRC5y8o16Bh8qdajfpCeCjQPXqDuZW1J/NuxVogMZ+qeLMoCzS3k0i0hpW2Vy3oTVpG7WGaoJDTr0VyV94pjiTTN9MUTIQsGiAz6t8AEgpV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Dj2ZIDJP; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-7ea12e0dc7aso960214a12.3
        for <io-uring@vger.kernel.org>; Thu, 31 Oct 2024 14:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730409740; x=1731014540; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jbBqtqOWDZuGi35NiFMLhW1ZLss7CzMedglYfe+eWdA=;
        b=Dj2ZIDJPlaXFmyoSqcm3SFfriIJ1SUUM4VmBZSUmBCN99Y9/LXqXrdP3zCqCMuzzMR
         K0Cm5CGKtFaxozp+ec2VVGrmEvi5KB+/KTcgLIlC6ABNJSy8O48qR1oQjIERR+yuoR+t
         w/7E6fqdvsaK3VaHvZJGv9TXxRoY+ACYrGC/p/IjM5jzjnzUAAcq8yS10VBiQk28+3Z+
         AA6dG7NV70zr2XVDHudX6VRHWZUrRyFYs+sadmAwg5AOFSJdSXlsJDbdMTukYB3cYY89
         Vl9plEgKYDYi7nJDrRk/1yRcIlgj+ndali7sOQKeWts+kEiKDxz9vD0Nnc5ru/EovDSE
         AkWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730409740; x=1731014540;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jbBqtqOWDZuGi35NiFMLhW1ZLss7CzMedglYfe+eWdA=;
        b=J4uIeDivrExSyis6IInloU8iuTZOCHhWWobYNA/dWD3wLtkslIrWe+qGI5B7pVUngD
         9fhlYmDyEMvIwASsFOxMnNzAKCKRcEOX2YF/5fw8f9A5xCQz0Zu6qAzrO9ys/mtUgWji
         +UtwOnkrJV4EA76+6m2qs3d8z/1VoTF70cMVrVVF6Vas1gXUwErlFDLojFqxErew3uVi
         hUsTGmSH01j2B201iRI6g4X71opDL3ZaUbTwtBXHUpg3w+9dc7mkWqErMV8jEGFWIlnV
         pI8Lf7v4r67V6/DdzPpCuhMo1NucJwLP7sg20rzctxxTWd+zV9XtPNggkcvvgFNFsvv8
         UAfw==
X-Gm-Message-State: AOJu0Yx3uVN4HBOUyvg+5vexoDKM0ohYz1f/1YQ+P8iR491Ei8PPtp+9
	IGDU4JcC3XGsgCCT4HoVjA+2Bg+xi+sgBXVrrtXShU8t65JJXgLh4SGA0y3YNCn6/sX+JJSMnOR
	B/Dg=
X-Google-Smtp-Source: AGHT+IE2nwznm9PjHypVCx2DXziUrKShAb3IEGrIr9ZocPX3Ud9nE7mThWO6pN0yB1Ik4M4F3zfBQg==
X-Received: by 2002:a17:90b:2e43:b0:2e0:a77e:8305 with SMTP id 98e67ed59e1d1-2e94c533088mr1721501a91.39.1730409740411;
        Thu, 31 Oct 2024 14:22:20 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e93dac02b8sm1629955a91.28.2024.10.31.14.22.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Oct 2024 14:22:19 -0700 (PDT)
Message-ID: <e60a3dd3-3a74-4181-8430-90c106a202f6@kernel.dk>
Date: Thu, 31 Oct 2024 15:22:18 -0600
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
Subject: [PATCH RFC] io_uring: extend io_uring_sqe flags bits
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

Was toying with this idea to allow for some more flags, I just don't
like grabbing the last flag and punting the problem both to the future
and to "somebody elses problem". Here's one way we could do it, without
rewriting the entire sqe into a v2. Which does need to happen at some
point, but preferably without pressing issues around.

I don't _hate_ it, there's really not a great way to do this. And I
do think personality is the least used of all the things, and probably
will never get used with uring_cmd. But if it had to work for that,
then there are certainly ways to pass in that info. Not that we
ever would...

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 77fd508d043a..8a45bf6a68ca 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -433,6 +433,7 @@ struct io_tw_state {
 };
 
 enum {
+	/* 8 bits of sqe->flags */
 	REQ_F_FIXED_FILE_BIT	= IOSQE_FIXED_FILE_BIT,
 	REQ_F_IO_DRAIN_BIT	= IOSQE_IO_DRAIN_BIT,
 	REQ_F_LINK_BIT		= IOSQE_IO_LINK_BIT,
@@ -440,9 +441,13 @@ enum {
 	REQ_F_FORCE_ASYNC_BIT	= IOSQE_ASYNC_BIT,
 	REQ_F_BUFFER_SELECT_BIT	= IOSQE_BUFFER_SELECT_BIT,
 	REQ_F_CQE_SKIP_BIT	= IOSQE_CQE_SKIP_SUCCESS_BIT,
+	REQ_F_FLAGS2_BIT	= IOSQE_FLAGS2_BIT,
 
-	/* first byte is taken by user flags, shift it to not overlap */
-	REQ_F_FAIL_BIT		= 8,
+	/* 16 bits of sqe->flags2 */
+	REQ_F_PERSONALITY_BIT	= IOSQE2_PERSONALITY_BIT + 8,
+
+	/* first byte taken by sqe->flags, next 2 by sqe->flags2 */
+	REQ_F_FAIL_BIT		= 24,
 	REQ_F_INFLIGHT_BIT,
 	REQ_F_CUR_POS_BIT,
 	REQ_F_NOWAIT_BIT,
@@ -492,6 +497,10 @@ enum {
 	REQ_F_BUFFER_SELECT	= IO_REQ_FLAG(REQ_F_BUFFER_SELECT_BIT),
 	/* IOSQE_CQE_SKIP_SUCCESS */
 	REQ_F_CQE_SKIP		= IO_REQ_FLAG(REQ_F_CQE_SKIP_BIT),
+	/* ->flags2 is valid */
+	REQ_F_FLAGS2		= IO_REQ_FLAG(REQ_F_FLAGS2_BIT),
+
+	REQ_F_PERSONALITY	= IO_REQ_FLAG(REQ_F_PERSONALITY_BIT),
 
 	/* fail rest of links */
 	REQ_F_FAIL		= IO_REQ_FLAG(REQ_F_FAIL_BIT),
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index ce58c4590de6..c7c3ba69ffdd 100644
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
@@ -99,11 +103,17 @@ struct io_uring_sqe {
 			__u64	__pad2[1];
 		};
 		__u64	optval;
-		/*
-		 * If the ring is initialized with IORING_SETUP_SQE128, then
-		 * this field is used for 80 bytes of arbitrary command data
-		 */
-		__u8	cmd[0];
+		struct {
+			/*
+			 * If the ring is initialized with IORING_SETUP_SQE128,
+			 * then this field is used for 80 bytes of arbitrary
+			 * command data
+			 */
+			__u8	cmd[0];
+
+			/* personality to use, if IOSQE2_PERSONALITY set */
+			__u16	personality2;
+		};
 	};
 };
 
@@ -124,6 +134,11 @@ enum io_uring_sqe_flags_bit {
 	IOSQE_ASYNC_BIT,
 	IOSQE_BUFFER_SELECT_BIT,
 	IOSQE_CQE_SKIP_SUCCESS_BIT,
+	IOSQE_FLAGS2_BIT,
+};
+
+enum io_uring_sqe_flags2_bit {
+	IOSQE2_PERSONALITY_BIT,
 };
 
 /*
@@ -143,6 +158,14 @@ enum io_uring_sqe_flags_bit {
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
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 1149fba20503..c2bbadd5640d 100644
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
@@ -2032,6 +2033,8 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	req->opcode = opcode = READ_ONCE(sqe->opcode);
 	/* same numerical values with corresponding REQ_F_*, safe to copy */
 	sqe_flags = READ_ONCE(sqe->flags);
+	if (sqe_flags & REQ_F_FLAGS2)
+		sqe_flags |= (__u32) READ_ONCE(sqe->flags2) << 8;
 	req->flags = (__force io_req_flags_t) sqe_flags;
 	req->cqe.user_data = READ_ONCE(sqe->user_data);
 	req->file = NULL;
@@ -2095,8 +2098,12 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
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
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 535909a38e76..ee04e0c48672 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -200,7 +200,7 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
 
-	if (sqe->__pad1)
+	if (sqe->__pad1 || req->flags & REQ_F_PERSONALITY)
 		return -EINVAL;
 
 	ioucmd->flags = READ_ONCE(sqe->uring_cmd_flags);

-- 
Jens Axboe


