Return-Path: <io-uring+bounces-7975-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 88755AB6542
	for <lists+io-uring@lfdr.de>; Wed, 14 May 2025 10:06:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CF3641895D92
	for <lists+io-uring@lfdr.de>; Wed, 14 May 2025 08:06:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14DBE21B9C9;
	Wed, 14 May 2025 08:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fTtABfTn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E28821ADA7
	for <io-uring@vger.kernel.org>; Wed, 14 May 2025 08:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747209985; cv=none; b=PrwaQJc5CsNLcj2fDuTdMZ1rIQnyE4KEoTKSXfofmSshZyAfUD+G2QUrWujuYHSaMNjqjXYhxF/YyoI8eqN2owLHZxuoOOSnjLLpZIiVO4dEZwX0andvve0NN84Bf+UWY3hdp8hA1kYvxg8ohsfvfuUVfA8s6HEmKISZNta4dvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747209985; c=relaxed/simple;
	bh=e6M+fJBzr+iA2Eys0IyxDkz2iH9E/BzRZozeP2dLWCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jU7H7tJLjhN61iF0VNik6DnmwvY4YcjlPw52WDaK+Rnh9S/YEHkUDbSgRnW/H1ZYz3/4F0EHJ900EziU+9uaRzvqRwKcWi1AdiYZDEIFiVw9VzkxbcjyiCKgpZtih/XrcaUYzKg47w3ykOdwvfZKrIpMYp+zevamOFtNfqVnC9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fTtABfTn; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5fbe7a65609so10464163a12.0
        for <io-uring@vger.kernel.org>; Wed, 14 May 2025 01:06:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747209981; x=1747814781; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iQbj47FH476f9EVKFuk8pibEIX4bZ68fkFbbzBAB/Jc=;
        b=fTtABfTnIebGTqBPISpwvZyZ7ytvBfarWm/yQxy31ArBqXq50znJ3qVvIq6wiEkKra
         ElwRsO3LEbPbZAPDxXLk2qq8qixXe4ZycBMiL5HiZqpwTPdvZ/WAdLpoGDhYHpS9vifa
         W7zFcCPsYO0NnCsETVVYnhGMreDMdgJqeOS8/jLwNcKQWNsPo0C4mO0zx/MHHPES4LV4
         7e75vqxCRg2ahPQSv7A4Y+dJhokyd5GKwfzTIZlaBTgQGjXzgMth/GXpZV6JWRAAG4L2
         avZStNaP8LSk5CMrYU7WtWXfp/GrIJN5/BUUBcBaGQoQW+z5Nj3OIN33s0uvXLG6cy1T
         B3FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747209981; x=1747814781;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iQbj47FH476f9EVKFuk8pibEIX4bZ68fkFbbzBAB/Jc=;
        b=JGl4pv5Wyx8aQatwPXQ7CAi804iN99pHqjw0obkfTgDERGz2mEQ0pnmEEYMDFjyPc1
         6SlETf8m7U7jrwZxrtc/aIfCTmPsRY/oYR30hQ203dMN9Cls/uHUskNd0V8gkNEuCW1w
         Uc+sUnApLJOQ7ffB3gQGGdPOxVzVy99wi5/69qqGzTuO0iFRR2tAqdoNxNxhr24AjVRT
         /BiyHBrJpqyELxUCblHrIZOJWMmM0keXKqK7Sia/BUGrZfoNsPLsUiXmpa1VPe7MIKMl
         68gTodEwxXHTuua8iEyZRRKT03luxQBf+otfqEey7LE6zLzaBOnW2T21nUPcVzv2yDtn
         J5Mw==
X-Gm-Message-State: AOJu0YxOy0WQEzdr8ZXLdrhsbLSnjG1T/p7+44liutXsA86koNcelBOk
	uENxMcORaUjCX9AMrfnaSZFtpEt4IalAY/Egwl38DbVwpAyv0ssO/GNXeA==
X-Gm-Gg: ASbGncsJTHbFPviiB3MHwqzVcEr7TdUEIuw4tFfErwmhlxwql+lzCvD4WrBNv/4VGT2
	sXbYAx0IXm72OvL7nhqpPxtd6Ah7Nn/ScTlM2UPqGKN7LTreg4affNMVvp6yMODKxccdgri2g6K
	kaTmeL/5eQwOvRBR3eox7j66GE/YeO033ZCesJ7han3mBR4gY6MBdsqJWDJ9pluxoPe6QJN9Qg2
	fEHpOaxgYuqGHX4qyrof6PYvLbsnVpKbr6CwqqSuCydRv7TsVzrfbeG+lIpjaVx/UZE/Tr6o+o1
	sR60Ek4NbJke7/UAJv9K2H5cdOQj5aCJt+2QjWBIIzHNHw==
X-Google-Smtp-Source: AGHT+IHb9PGphKKi/LAsBdwInXvWd8+6hWW6rJiEsYzuH5bam+l38KbAZkZORgL3bfpjvgb1wvs58A==
X-Received: by 2002:a05:6402:d0d:b0:5fb:afca:dd58 with SMTP id 4fb4d7f45d1cf-5ff988df132mr1763796a12.32.1747209981039;
        Wed, 14 May 2025 01:06:21 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:ee61])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5fd29adb7absm4969579a12.32.2025.05.14.01.06.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 May 2025 01:06:20 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 3/4] io_uring: alloc overflow entry before locking
Date: Wed, 14 May 2025 09:07:22 +0100
Message-ID: <c4c60109016469be4c4a3ccb3631377789784a86.1747209332.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1747209332.git.asml.silence@gmail.com>
References: <cover.1747209332.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allocate and populate struct io_overflow_cqe before taking the lock. It
simplifies __io_cqring_event_overflow(), and that allows to avoid
GFP_ATOMIC for DEFER_TASKRUN rings.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 49 ++++++++++++++++++++++++---------------------
 1 file changed, 26 insertions(+), 23 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 5b253e2b6c49..927d8e45dbdb 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -719,20 +719,10 @@ static __cold void io_uring_drop_tctx_refs(struct task_struct *task)
 }
 
 static bool __io_cqring_event_overflow(struct io_ring_ctx *ctx,
-				       u64 user_data, s32 res, u32 cflags,
-				       u64 extra1, u64 extra2)
+					struct io_overflow_cqe *ocqe)
 {
-	struct io_overflow_cqe *ocqe;
-	size_t ocq_size = sizeof(struct io_overflow_cqe);
-	bool is_cqe32 = (ctx->flags & IORING_SETUP_CQE32);
-
 	lockdep_assert_held(&ctx->completion_lock);
 
-	if (is_cqe32)
-		ocq_size += sizeof(struct io_uring_cqe);
-
-	ocqe = kmalloc(ocq_size, GFP_ATOMIC | __GFP_ACCOUNT);
-	trace_io_uring_cqe_overflow(ctx, user_data, res, cflags, ocqe);
 	if (!ocqe) {
 		struct io_rings *r = ctx->rings;
 
@@ -745,17 +735,10 @@ static bool __io_cqring_event_overflow(struct io_ring_ctx *ctx,
 		set_bit(IO_CHECK_CQ_DROPPED_BIT, &ctx->check_cq);
 		return false;
 	}
+
 	if (list_empty(&ctx->cq_overflow_list)) {
 		set_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq);
 		atomic_or(IORING_SQ_CQ_OVERFLOW, &ctx->rings->sq_flags);
-
-	}
-	ocqe->cqe.user_data = user_data;
-	ocqe->cqe.res = res;
-	ocqe->cqe.flags = cflags;
-	if (is_cqe32) {
-		ocqe->cqe.big_cqe[0] = extra1;
-		ocqe->cqe.big_cqe[1] = extra2;
 	}
 	list_add_tail(&ocqe->list, &ctx->cq_overflow_list);
 	return true;
@@ -765,15 +748,35 @@ static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, bool locked,
 				     u64 user_data, s32 res, u32 cflags,
 				     u64 extra1, u64 extra2)
 {
+	struct io_overflow_cqe *ocqe;
+	size_t ocq_size = sizeof(struct io_overflow_cqe);
+	bool is_cqe32 = (ctx->flags & IORING_SETUP_CQE32);
+	gfp_t gfp = GFP_KERNEL_ACCOUNT;
 	bool queued;
 
+	if (is_cqe32)
+		ocq_size += sizeof(struct io_uring_cqe);
+	if (locked)
+		gfp = GFP_ATOMIC | __GFP_ACCOUNT;
+
+	ocqe = kmalloc(ocq_size, gfp);
+	trace_io_uring_cqe_overflow(ctx, user_data, res, cflags, ocqe);
+
+	if (ocqe) {
+		ocqe->cqe.user_data = user_data;
+		ocqe->cqe.res = res;
+		ocqe->cqe.flags = cflags;
+		if (is_cqe32) {
+			ocqe->cqe.big_cqe[0] = extra1;
+			ocqe->cqe.big_cqe[1] = extra2;
+		}
+	}
+
 	if (locked) {
-		queued = __io_cqring_event_overflow(ctx, user_data, res, cflags,
-						    extra1, extra2);
+		queued = __io_cqring_event_overflow(ctx, ocqe);
 	} else {
 		spin_lock(&ctx->completion_lock);
-		queued = __io_cqring_event_overflow(ctx, user_data, res, cflags,
-						    extra1, extra2);
+		queued = __io_cqring_event_overflow(ctx, ocqe);
 		spin_unlock(&ctx->completion_lock);
 	}
 	return queued;
-- 
2.49.0


