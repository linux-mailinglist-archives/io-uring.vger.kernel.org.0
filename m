Return-Path: <io-uring+bounces-10422-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EDFC1C3CBB1
	for <lists+io-uring@lfdr.de>; Thu, 06 Nov 2025 18:10:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC01F626D5C
	for <lists+io-uring@lfdr.de>; Thu,  6 Nov 2025 17:02:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B444034D927;
	Thu,  6 Nov 2025 17:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mUHQVlZT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B923A34DB41
	for <io-uring@vger.kernel.org>; Thu,  6 Nov 2025 17:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762448537; cv=none; b=ZA5Ixzhre7XlfWVDlTzTfbPYB3QtUpGG6IbAFFtvOsG/vF4GFvuyqFRS8hjtKrseEhfa4tLh3x2psBkoZlRTJlpHzbXyaw2PNKj3rn9BE4lqEt0G4GfbSc0dcBg0kEDRfmT3ETVa6v2zanCpzV7AWa2VtJ003b0892qyq/YlSt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762448537; c=relaxed/simple;
	bh=DyBjFE8Opoiwxed+MnP7jqT3R28Yj82uM0UkZ+vFiVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uV3ZLeIRiCVrp+fcPhnUy9+ARdQWDQiRImSoorv/tuKNk+slVbxO1LdtnVCy4vXS/YOJWdNz+1WfvUn8euROwXPAR9V9ePn5RCE4VoUd5xm9vXyoTZ8BN+GlpzRzh4CbbLl3OaspeLnatfDMRfIE6SYfoNBPerlS6CcTGQ5MPi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mUHQVlZT; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-429bf011e6cso1240877f8f.1
        for <io-uring@vger.kernel.org>; Thu, 06 Nov 2025 09:02:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762448534; x=1763053334; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zTKMRGmCxxQI7T2UhOe2F1/KbwqSJNfcLscpNjgKPr0=;
        b=mUHQVlZT7ztPTgDixj23rpL63WAZZ9K/I8bm+mdRgXRDM8YfI0WdV1SBjygioCP8DE
         z4O6EJLUxO2686VBdNP353rdY4MeRRwcTd1BTSg90dg8eUgSQau6KiFYmTj3CMMiloCe
         356dtx0hrSAfhqKbktDYgloNJVt48MgR+7oC6+uRWG9JMcNzIMdR8AayaQPi/yUWNwnk
         IHZ8jWtCjGiGMhRL/8RsQI69QAZp5E6G4rurrI4YSNKPt7gLup9fbEkguGhvP6lE0qUV
         2XAZNEV6sU/z9nVGSZFcb8zU3GebLu86bM5SU5wbFwWkHLAxiQlm/7Ov1OFAqmPjGoj4
         4TpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762448534; x=1763053334;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zTKMRGmCxxQI7T2UhOe2F1/KbwqSJNfcLscpNjgKPr0=;
        b=rVTtX9Cm3Pq2++v7GkOqwS6eavKX10Sm51jGignz/DD57mYGx9xKRDsxflE+DE6Xay
         ef0wFDV0rQxA0lKSaJVw7lKiQsk+qdl7pIFFj2Q6Qk5pypzkZjELVPR/KDcO/kfc1ozC
         q1Pa/bHuaHWpMCXYaln2BgtI5ZdeEEn5O0WTuw1G6m8AQFRC3Ln0HHIXG9cq68iTrN7s
         d+6Zsz6hOK/EQ/8QQzTHcz6tvQuCkMVcF6lEDLdPdImAFFaWbisV+lSkpdlOx/98T1zf
         enavIO7BtNoHABpbZ/C2iiP/i7n9KWXcxXy84UYTIcNvmA37c1dDSn9vuO1D6E3EKKju
         odyA==
X-Gm-Message-State: AOJu0YxB7ENKcHwpTd0FYQ7l6Ns6WyKRTX0JwHOjqYSwsmtQ+ixFMNNN
	XfQK2Xcx7YwJuerPXyOqPoay/hZzCk9p8VhO+y8J5bmQeB69LJnMqz4BieoEkA==
X-Gm-Gg: ASbGnct8Frdh1QADe0XkHFuotP+8Cg5FzLQZa8eJ4TJpUZSMtzG9G9HP4bdodq3E2+X
	qzMaYIUMYcOhFWqgP3PZKgja6F45kv5J4NT033HJOdl2qw+KoXjNlmw7iP7ubhMTUgaiyVWUzrn
	Erxm8FT/eZGXrgT8KnEZgZr9qGY4IyfaWJlCxRjYHXTfWSFv63aH+3E+0zThYBtLDxq59ACvxE+
	7AYQ73Hv6J2fot3t3qSwpfF3CkGoZ0dZ9OY6cFoBcyHGNXHmepAjHUxJ7IP/FWph3iJ7AvJ1bTC
	ZS0OCGmGgr/qK6AGdAyxsdSlCR9O5j9Ji5WmMgBViQryTyx7W/s8lGWXdAqKvYLF1IR2MzOqEXc
	ORfEOSn8SpSVjMsztZIwGijzvtpqmS/wUqrtvW8rUhcHXsI+b/XZx+I1IMBfV6PiapxTUBc+aHi
	F3b3M=
X-Google-Smtp-Source: AGHT+IFR1uuYcUm4Nw4OtTcOzqUUeAtFTHEsbIaMpkK4tttVKEl71ZDpUeXIE8ev91wObo0raL8Y6Q==
X-Received: by 2002:a05:6000:4282:b0:429:c0f1:fd38 with SMTP id ffacd0b85a97d-429e33333b2mr6589672f8f.59.1762448533543;
        Thu, 06 Nov 2025 09:02:13 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42ac675caecsm124567f8f.30.2025.11.06.09.02.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 09:02:13 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [RFC 14/16] io_uring: extract io_create_mem_region
Date: Thu,  6 Nov 2025 17:01:53 +0000
Message-ID: <587665fd1a5ec94914edec3e7b049afbe1f7898e.1762447538.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1762447538.git.asml.silence@gmail.com>
References: <cover.1762447538.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Extract a helper function for creating a memory region but that can be
used at setup and not only in io_uring_register(). Specifically, it
doesn't check IORING_SETUP_R_DISABLED.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.h |  3 +++
 io_uring/register.c | 43 +++++++++++++++++++++++++------------------
 2 files changed, 28 insertions(+), 18 deletions(-)

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index ed57ab4161db..20f6ca4696c1 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -200,6 +200,9 @@ void io_queue_next(struct io_kiocb *req);
 void io_task_refs_refill(struct io_uring_task *tctx);
 bool __io_alloc_req_refill(struct io_ring_ctx *ctx);
 
+int io_create_mem_region(struct io_ring_ctx *ctx,
+			 struct io_uring_mem_region_reg *reg);
+
 void io_activate_pollwq(struct io_ring_ctx *ctx);
 
 static inline void io_lockdep_assert_cq_locked(struct io_ring_ctx *ctx)
diff --git a/io_uring/register.c b/io_uring/register.c
index b43a121e2974..425529a30dd9 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -572,10 +572,9 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	return ret;
 }
 
-static int io_register_mem_region(struct io_ring_ctx *ctx, void __user *uarg)
+int io_create_mem_region(struct io_ring_ctx *ctx,
+			 struct io_uring_mem_region_reg *reg)
 {
-	struct io_uring_mem_region_reg __user *reg_uptr = uarg;
-	struct io_uring_mem_region_reg reg;
 	struct io_uring_region_desc __user *rd_uptr;
 	struct io_uring_region_desc rd;
 	struct io_mapped_region region = {};
@@ -583,23 +582,12 @@ static int io_register_mem_region(struct io_ring_ctx *ctx, void __user *uarg)
 
 	if (io_region_is_set(&ctx->param_region))
 		return -EBUSY;
-	if (copy_from_user(&reg, reg_uptr, sizeof(reg)))
-		return -EFAULT;
-	rd_uptr = u64_to_user_ptr(reg.region_uptr);
+	rd_uptr = u64_to_user_ptr(reg->region_uptr);
 	if (copy_from_user(&rd, rd_uptr, sizeof(rd)))
 		return -EFAULT;
-	if (memchr_inv(&reg.__resv, 0, sizeof(reg.__resv)))
+	if (memchr_inv(&reg->__resv, 0, sizeof(reg->__resv)))
 		return -EINVAL;
-	if (reg.flags & ~IORING_MEM_REGION_REG_WAIT_ARG)
-		return -EINVAL;
-
-	/*
-	 * This ensures there are no waiters. Waiters are unlocked and it's
-	 * hard to synchronise with them, especially if we need to initialise
-	 * the region.
-	 */
-	if ((reg.flags & IORING_MEM_REGION_REG_WAIT_ARG) &&
-	    !(ctx->flags & IORING_SETUP_R_DISABLED))
+	if (reg->flags & ~IORING_MEM_REGION_REG_WAIT_ARG)
 		return -EINVAL;
 
 	ret = io_create_region(ctx, &region, &rd, IORING_MAP_OFF_PARAM_REGION);
@@ -610,7 +598,7 @@ static int io_register_mem_region(struct io_ring_ctx *ctx, void __user *uarg)
 		return -EFAULT;
 	}
 
-	if (reg.flags & IORING_MEM_REGION_REG_WAIT_ARG) {
+	if (reg->flags & IORING_MEM_REGION_REG_WAIT_ARG) {
 		ctx->cq_wait_arg = io_region_get_ptr(&region);
 		ctx->cq_wait_size = rd.size;
 	}
@@ -619,6 +607,25 @@ static int io_register_mem_region(struct io_ring_ctx *ctx, void __user *uarg)
 	return 0;
 }
 
+static int io_register_mem_region(struct io_ring_ctx *ctx, void __user *uarg)
+{
+	struct io_uring_mem_region_reg __user *reg_uptr = uarg;
+	struct io_uring_mem_region_reg reg;
+
+	if (copy_from_user(&reg, reg_uptr, sizeof(reg)))
+		return -EFAULT;
+	/*
+	 * This ensures there are no waiters. Waiters are unlocked and it's
+	 * hard to synchronise with them, especially if we need to initialise
+	 * the region.
+	 */
+	if ((reg.flags & IORING_MEM_REGION_REG_WAIT_ARG) &&
+	    !(ctx->flags & IORING_SETUP_R_DISABLED))
+		return -EINVAL;
+
+	return io_create_mem_region(ctx, &reg);
+}
+
 static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			       void __user *arg, unsigned nr_args)
 	__releases(ctx->uring_lock)
-- 
2.49.0


