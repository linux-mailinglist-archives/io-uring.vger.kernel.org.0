Return-Path: <io-uring+bounces-3674-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6866799D893
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 22:54:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C3AB6B21A59
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 20:54:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00AED1D1739;
	Mon, 14 Oct 2024 20:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="W++ycGZ/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED8AD1D14EE
	for <io-uring@vger.kernel.org>; Mon, 14 Oct 2024 20:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728939266; cv=none; b=dtBfJ6M8iLpA+KPnQtP+/5axfXI50j7z1GX6DDWCM4kV7tyLEgilC+DcPYiM+jfSbkr9ImUI74P69kR11DGQ0DTdoWJgIx3TdOInSB66K1b/GA8ArXtgGT7Icqb3UiGXXZiycn9tk/kqPNLMpt4XIJCpbSUynBZhX+/8Jj4YBG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728939266; c=relaxed/simple;
	bh=yiv1mUHkC+sXc2a72PzGwHO43QZ7YSGFs7GvNRT8g0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qA55lEXvC72xrtGTNILGS6DpT3dSQF6DukGDcn4OdAxEIG+hyWbliBHjaRkbA5WNJ8V5MkGs74WqGV2orUXgdBnTSjpVz1s9+Yy2KOfldvdd14djbQCf7GOUaSQcwoyUHS2boHklHc8ptxBmzW69elZuyDRJ+0DFU8zF+WaSTLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=W++ycGZ/; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-8354b8df4c9so167338939f.1
        for <io-uring@vger.kernel.org>; Mon, 14 Oct 2024 13:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1728939263; x=1729544063; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5slwh/hrSipEcpmMDPFHvZDFXrV7QCLK/2Ol7f9mbnQ=;
        b=W++ycGZ/uxRR9BQdTLlBOyoiICMRXTxcGPw6IJeOnISIjqBuyJKvwHxLXP6Ib/RS6j
         TbP2PGk9qU00KvogTPC3EDPSzyFQylW6da6vr1FTgKYcXsy2NS6xP46BZdLeL4B/Y1UQ
         4pAKzcLQOAb+c3q1ITOjjpuFB6EdPpk4WIwxB2ROW1tpZpO90NxWFJobS8EAIuCnAkEf
         AlizcQ3ZK2ZaFQJPHdSWvXZGUsfIy7seoCO5neqtaPy6cgrThI9Hk1QZ6PKq2m5TE5IP
         AF59wyrQ9evblGysH5TNn/ZqwURDx0WNMLtgDfg8opZt/rxsoAsbCH6cpVs8EfAKAYaw
         i3Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728939263; x=1729544063;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5slwh/hrSipEcpmMDPFHvZDFXrV7QCLK/2Ol7f9mbnQ=;
        b=UTx8yjD+j9/kcMKX+IA0KI0MYSIJJTj4w0ikYVGiSaIcJ6hj3rwD+1/M4itSdTOqbC
         DKvMGcUMD1e5EnreMQNZyxx7M4K1n6Nxvg+fkAXK1tRaKcm3N7wZkX9KFT9ftw3J54mi
         zGaKWfPPcfHVhw56n+ywRGencH/DM10DftxAbulInxu3QMlOZ7gjC4yF3ZDm1ub63xnY
         TdW+vu14UixrER+ZHYU46zc8VLqd5qWvTRtMJV1nAKHk5DNBt5ioe0XX/VL05HijW0gH
         g+7ELX0nk80Yyp7GZUaXJ3n4tTDgN4KnzHizqldK8NnKpqI58gWQs+5ckv7+hcDKbn56
         6uIQ==
X-Gm-Message-State: AOJu0Yy8qwCDDQf2lxTdyl+tOpVBUgGsmuVMjxhW3cMsvrXoziwv9a01
	I/GAc/PvMAfvtuTAlU942WdZ9cCsXITj4gfsVcWYUM9yxjJFW0lSS2vL2xQdYdqwDM/7spwLUl8
	F
X-Google-Smtp-Source: AGHT+IFSuc7YQf3Aa0fzWX5GyVIUgLw3a7mAA3Ta0OWWuFdkcoYUhMW4t12Q/zL2113qDt9hGtf1/w==
X-Received: by 2002:a05:6e02:19cb:b0:3a2:463f:fd9e with SMTP id e9e14a558f8ab-3a3bcdbb642mr73411195ab.6.1728939262395;
        Mon, 14 Oct 2024 13:54:22 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a3afdb3629sm62644895ab.21.2024.10.14.13.54.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2024 13:54:21 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring: add support for ignoring inline completions for waits
Date: Mon, 14 Oct 2024 14:49:46 -0600
Message-ID: <20241014205416.456078-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241014205416.456078-1-axboe@kernel.dk>
References: <20241014205416.456078-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_uring treats all completions the same - they post a completion event,
or more, and anyone waiting on event completions will see each event as
it gets posted.

However, some events may be more interesting that others. For a request
and response type model, it's not uncommon to have send/write events
that are submitted with a recv/read type of request. While the app does
want to see a successful send/write completion eventually, it need not
handle it upfront as it would want to do with a recv/read, as it isn't
time sensitive. Generally, a send/write completion will just mean that
a buffer can get recycled/reused, whereas a recv/read completion needs
acting upon (and a response sent).

This can be somewhat tricky to handle if many requests and responses
are being handled, and the app generally needs to track the number of
pending sends/writes to be able to sanely wait on just new incoming
recv/read requests. And even with that, an application would still
like to see a completion for a short/failed send/write immediately.

Add infrastructure to account inline completions, such that they can
be deducted from the 'wait_nr' being passed in via a submit_and_wait()
type of situation. Inline completions are ones that complete directly
inline from submission, such as a send to a socket where there's
enough space to accomodate the data being sent.

No functional changes in this patch, as no opcode supports setting
REQ_F_IGNORE_INLINE just yet.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  4 ++++
 include/uapi/linux/io_uring.h  |  1 +
 io_uring/io_uring.c            | 12 +++++++++---
 io_uring/io_uring.h            |  2 ++
 4 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 9c7e1d3f06e5..6eb8b739ea0d 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -206,6 +206,7 @@ struct io_submit_state {
 	bool			need_plug;
 	bool			cq_flush;
 	unsigned short		submit_nr;
+	unsigned short		inline_completions;
 	struct blk_plug		plug;
 };
 
@@ -465,6 +466,7 @@ enum {
 	REQ_F_BL_EMPTY_BIT,
 	REQ_F_BL_NO_RECYCLE_BIT,
 	REQ_F_BUFFERS_COMMIT_BIT,
+	REQ_F_IGNORE_INLINE_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -541,6 +543,8 @@ enum {
 	REQ_F_BL_NO_RECYCLE	= IO_REQ_FLAG(REQ_F_BL_NO_RECYCLE_BIT),
 	/* buffer ring head needs incrementing on put */
 	REQ_F_BUFFERS_COMMIT	= IO_REQ_FLAG(REQ_F_BUFFERS_COMMIT_BIT),
+	/* if set, ignore these completions for when waiting on events */
+	REQ_F_IGNORE_INLINE	= IO_REQ_FLAG(REQ_F_IGNORE_INLINE_BIT),
 };
 
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state *ts);
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 86cb385fe0b5..1967f5ab2317 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -554,6 +554,7 @@ struct io_uring_params {
 #define IORING_FEAT_REG_REG_RING	(1U << 13)
 #define IORING_FEAT_RECVSEND_BUNDLE	(1U << 14)
 #define IORING_FEAT_MIN_TIMEOUT		(1U << 15)
+#define IORING_FEAT_IGNORE_INLINE	(1U << 16)
 
 /*
  * io_uring_register(2) opcodes and arguments
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index d7ad4ea5f40b..706822db7447 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2239,6 +2239,7 @@ static void io_submit_state_start(struct io_submit_state *state,
 	state->plug_started = false;
 	state->need_plug = max_ios > 2;
 	state->submit_nr = max_ios;
+	state->inline_completions = 0;
 	/* set only head, no need to init link_last in advance */
 	state->link.head = NULL;
 }
@@ -3285,6 +3286,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		size_t, argsz)
 {
 	struct io_ring_ctx *ctx;
+	int inline_complete = 0;
 	struct file *file;
 	long ret;
 
@@ -3349,6 +3351,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 			mutex_unlock(&ctx->uring_lock);
 			goto out;
 		}
+		inline_complete = ctx->submit_state.inline_completions;
 		if (flags & IORING_ENTER_GETEVENTS) {
 			if (ctx->syscall_iopoll)
 				goto iopoll_locked;
@@ -3386,8 +3389,10 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 
 			ret2 = io_get_ext_arg(flags, argp, &ext_arg);
 			if (likely(!ret2)) {
-				min_complete = min(min_complete,
-						   ctx->cq_entries);
+				if (min_complete > ctx->cq_entries)
+					min_complete = ctx->cq_entries;
+				else
+					min_complete += inline_complete;
 				ret2 = io_cqring_wait(ctx, min_complete, flags,
 						      &ext_arg);
 			}
@@ -3674,7 +3679,8 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 			IORING_FEAT_EXT_ARG | IORING_FEAT_NATIVE_WORKERS |
 			IORING_FEAT_RSRC_TAGS | IORING_FEAT_CQE_SKIP |
 			IORING_FEAT_LINKED_FILE | IORING_FEAT_REG_REG_RING |
-			IORING_FEAT_RECVSEND_BUNDLE | IORING_FEAT_MIN_TIMEOUT;
+			IORING_FEAT_RECVSEND_BUNDLE | IORING_FEAT_MIN_TIMEOUT |
+			IORING_FEAT_IGNORE_INLINE;
 
 	if (copy_to_user(params, p, sizeof(*p))) {
 		ret = -EFAULT;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 9d70b2cf7b1e..bd1d4b6e46f0 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -357,6 +357,8 @@ static inline void io_req_complete_defer(struct io_kiocb *req)
 	lockdep_assert_held(&req->ctx->uring_lock);
 
 	wq_list_add_tail(&req->comp_list, &state->compl_reqs);
+	if (req->flags & REQ_F_IGNORE_INLINE)
+		state->inline_completions++;
 }
 
 static inline void io_commit_cqring_flush(struct io_ring_ctx *ctx)
-- 
2.45.2


