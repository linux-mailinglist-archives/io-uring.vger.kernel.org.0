Return-Path: <io-uring+bounces-11573-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E90BAD0BF7F
	for <lists+io-uring@lfdr.de>; Fri, 09 Jan 2026 19:54:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7A987300C35F
	for <lists+io-uring@lfdr.de>; Fri,  9 Jan 2026 18:52:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44F87274FF5;
	Fri,  9 Jan 2026 18:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="0vrhvgo3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5522DA760
	for <io-uring@vger.kernel.org>; Fri,  9 Jan 2026 18:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767984725; cv=none; b=d/jPq0o/OE9i9yUrI+fZCaY8UxDBvjMxq0gF3+qdHDvbHjqYoqXPPDXZ7/rdrguMK80AfupCZ42MzUG3Nbn9mOGParIV9mAtcV0tjM+QOh4pmaw7McfceOTEMEzstzmhKpEj3OYC10iTMJ4ssSUo1kKF1T2OVUeuOUpkoBXb8lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767984725; c=relaxed/simple;
	bh=jWzG2PnjZSmGhtm2hEt1YsdQHLdz6WKgiD+9bX20Mds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dw+NbYmdUCS4aciGkC9PYI92qfGXnbeSuAuAK8rzdIfsafTrUCPTQEkapPYFtqTLvx3oLRP9US6SFGHKtNgzs5K4sdjDVaRxOjeL1lPS8PoZVAw1nZUsD4VgyBxdAc5J14DL7AcTs9V92y+GnVLNHhoAhHTEUFzQ7hklU8rIfeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=0vrhvgo3; arc=none smtp.client-ip=209.85.167.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-45330fe6e1bso2715580b6e.2
        for <io-uring@vger.kernel.org>; Fri, 09 Jan 2026 10:52:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1767984721; x=1768589521; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BNhmqnytGIF52SjuaVrl8L6+44MF3pWiVA/F6rXwztE=;
        b=0vrhvgo3rdvMtZeMvLhEEfmv7Ok4qO4OftVRdPXOr82wdLltXrKOilxc7CE/dmzdCC
         noYnLzNM5g4RaOt2V+ZXAzAMaN0glAXkbd67iJbgNWgRrJBjhz0/TqgdTT28ZO9coSX8
         egY34QCDzabUvMtburE+eUVvpNsiXiwVIK0gJnxXcQ+cTUa5VVP2oPfxao5OvHqE/fmc
         HPdK4yst2hsfSFjiJhPXdn/4th5xycKEnjRvYzPjtqXJ5jkDqSsWHVujiCAuGd2+ivqS
         IAJtOoO6S5m1BavIoExZwRzD0boE9ElZY+iVwIkqNGjnco97/pGCA/BCxUTNuzJm75gh
         udDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767984721; x=1768589521;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BNhmqnytGIF52SjuaVrl8L6+44MF3pWiVA/F6rXwztE=;
        b=UnD/3LnrkP+goy4LNMR7cA/FTDUxP4nq6nyfyH12BVIl6chk95qV7Q68GzfYn6yHfD
         BSb1FAxXgLn6Zbbi4EJlhijMDdqE1DrBTYzXQIButKJjMVmesPtd3C7oXrGXgWwClANO
         UR2uOZkrRRTJkDVpFYRAFtTANfyaN1fkhO8wBEbxdEMhRBr1y8j+5nxhpdmcnP1drdyk
         ufRcvH4pMBFS54NaqQTj1Bruz+r8X6+YSfZiPNn4sxvF7rBC5SPP0/ZUAldIzkFWcIwZ
         cM220xzAr+5dJqCXp8dLoUkGJCqUv9rQpr6dCZXhuImbxX2aViz9cRMD8PYKCyYG4Y1l
         mQbw==
X-Gm-Message-State: AOJu0YzLQmjJN4HWHVp0lcOqj+D5ZmDEN1oqdnlF/M2oRyy4M9FO45Pd
	uMpfrpDtBjy9pFhfMcAGVR3xWLO6sNYBoJsMuRMylhA2zETlwB3RsjWG5qLfNWaxGRzE+hdFEAi
	uqfTr
X-Gm-Gg: AY/fxX6NRCnpN9KdkztMe/2FKmsnx7+nK7xct07SBRPQo826foTagprh50hWUchTCpA
	McKdOOQsjU60SBG8EsYU8J9TVBH3Oa8wnEo1Y+MmYI6tbd5xQrZF8rXo9Relp3hLrUrmpE/Q+fD
	MmfeRK4VSEHWE3B5DKoKRcKKy1XeoqJxelTUzcLaCNO7klznFUpwfA7XWq1Xd8am1+LKISVve3m
	yAPp7wAS82HMvUxdYSaZfZspFUsgANBai+HmpqddgDJWICfc0M1nnDnwCBSO+cDuI5qM9msw1p6
	uEooqGuMTEkIXXekCgbf++5vMBUnMVp0syMyXkQv3+FJfsyRVnpSW/kl74Ohkwh5CGOj9CFteFi
	0JuQKOE6M4c/FGyokTnXz+W4sdeX8mFeyYMzgF59ANlgri4efFEgynRHqqE77swBpn/h3Dw==
X-Google-Smtp-Source: AGHT+IG9uNJUKVJ1ms1bQvD2Ob7JmWY14uQ/Dt5yoHr6QHePx0RFca5YIQTMFLqAy8c6KSCkhV+Fcw==
X-Received: by 2002:a05:6808:4284:b0:45a:6cf0:68c1 with SMTP id 5614622812f47-45a6cf076a6mr4949176b6e.58.1767984720811;
        Fri, 09 Jan 2026 10:52:00 -0800 (PST)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45a5e288bc7sm5371868b6e.12.2026.01.09.10.51.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 10:52:00 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: krisman@suse.de,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring/register: add MASK support for task filter set
Date: Fri,  9 Jan 2026 11:48:26 -0700
Message-ID: <20260109185155.88150-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260109185155.88150-1-axboe@kernel.dk>
References: <20260109185155.88150-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If IORING_REG_RESTRICTIONS_MASK is set in the flags for an
IORING_REGISTER_RESTRICTIONS_TASK operation, then further restrictions
can be added to the current set. No restrictions may be relaxed this
way. If a current set exists, the passed in set is added to the current
set. If no current set exists, the new set applied will as the current
task io_uring restriction filter.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring.h |  9 ++++++
 io_uring/register.c           | 54 ++++++++++++++++++++++++++---------
 2 files changed, 49 insertions(+), 14 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 3ecf9c1bfa2d..e39da481f14c 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -807,6 +807,15 @@ struct io_uring_restriction {
 	__u32 resv2[3];
 };
 
+enum {
+	/*
+	 * MASK operation to further restrict a filter set. Can clear opcodes
+	 * allowed for SQEs or register operations, clear allowed SQE flags,
+	 * and set further required SQE flags.
+	 */
+	IORING_REG_RESTRICTIONS_MASK	= (1U << 0),
+};
+
 struct io_uring_task_restriction {
 	__u16 flags;
 	__u16 nr_res;
diff --git a/io_uring/register.c b/io_uring/register.c
index 89254d0fbe79..552b22f6b2dc 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -104,7 +104,8 @@ static int io_register_personality(struct io_ring_ctx *ctx)
 }
 
 static __cold int io_parse_restrictions(void __user *arg, unsigned int nr_args,
-					struct io_restriction *restrictions)
+					struct io_restriction *restrictions,
+					bool mask_it)
 {
 	struct io_uring_restriction *res;
 	size_t size;
@@ -122,32 +123,41 @@ static __cold int io_parse_restrictions(void __user *arg, unsigned int nr_args,
 		return PTR_ERR(res);
 
 	ret = -EINVAL;
-
 	for (i = 0; i < nr_args; i++) {
 		switch (res[i].opcode) {
 		case IORING_RESTRICTION_REGISTER_OP:
 			if (res[i].register_op >= IORING_REGISTER_LAST)
 				goto err;
-			__set_bit(res[i].register_op, restrictions->register_op);
+			if (mask_it)
+				__clear_bit(res[i].register_op, restrictions->register_op);
+			else
+				__set_bit(res[i].register_op, restrictions->register_op);
 			break;
 		case IORING_RESTRICTION_SQE_OP:
 			if (res[i].sqe_op >= IORING_OP_LAST)
 				goto err;
-			__set_bit(res[i].sqe_op, restrictions->sqe_op);
+			if (mask_it)
+				__clear_bit(res[i].sqe_op, restrictions->sqe_op);
+			else
+				__set_bit(res[i].sqe_op, restrictions->sqe_op);
 			break;
 		case IORING_RESTRICTION_SQE_FLAGS_ALLOWED:
-			restrictions->sqe_flags_allowed = res[i].sqe_flags;
+			if (mask_it)
+				restrictions->sqe_flags_allowed &= res[i].sqe_flags;
+			else
+				restrictions->sqe_flags_allowed = res[i].sqe_flags;
 			break;
 		case IORING_RESTRICTION_SQE_FLAGS_REQUIRED:
-			restrictions->sqe_flags_required = res[i].sqe_flags;
+			if (mask_it)
+				restrictions->sqe_flags_required |= res[i].sqe_flags;
+			else
+				restrictions->sqe_flags_required = res[i].sqe_flags;
 			break;
 		default:
 			goto err;
 		}
 	}
-
 	ret = 0;
-
 err:
 	kfree(res);
 	return ret;
@@ -166,7 +176,7 @@ static __cold int io_register_restrictions(struct io_ring_ctx *ctx,
 	if (ctx->restrictions.registered)
 		return -EBUSY;
 
-	ret = io_parse_restrictions(arg, nr_args, &ctx->restrictions);
+	ret = io_parse_restrictions(arg, nr_args, &ctx->restrictions, false);
 	/* Reset all restrictions if an error happened */
 	if (ret != 0)
 		memset(&ctx->restrictions, 0, sizeof(ctx->restrictions));
@@ -182,29 +192,45 @@ static int io_register_restrictions_task(void __user *arg, unsigned int nr_args)
 	struct io_restriction *res;
 	int ret;
 
-	/* Disallow if task already has registered restrictions */
-	if (current->io_uring_restrict)
-		return -EPERM;
 	if (nr_args != 1)
 		return -EINVAL;
 
 	if (copy_from_user(&tres, arg, sizeof(tres)))
 		return -EFAULT;
 
-	if (tres.flags)
+	if (tres.flags & ~IORING_REG_RESTRICTIONS_MASK)
 		return -EINVAL;
 	if (!mem_is_zero(tres.resv, sizeof(tres.resv)))
 		return -EINVAL;
 
+	/*
+	 * Disallow if task already has registered restrictions, and we're
+	 * not passing in further restrictions to add to an existing set.
+	 */
+	if (current->io_uring_restrict &&
+	    !(tres.flags & IORING_REG_RESTRICTIONS_MASK))
+		return -EPERM;
+
 	res = kzalloc(sizeof(*res), GFP_KERNEL);
 	if (!res)
 		return -ENOMEM;
 
-	ret = io_parse_restrictions(ures->restrictions, tres.nr_res, res);
+	/*
+	 * Can only be set if we're MASK'ing in more restrictions. If so,
+	 * copy existing filters.
+	 */
+	if (current->io_uring_restrict)
+		memcpy(res, current->io_uring_restrict, sizeof(*res));
+
+	ret = io_parse_restrictions(ures->restrictions, tres.nr_res, res,
+				    tres.flags & IORING_REG_RESTRICTIONS_MASK);
 	if (ret) {
 		kfree(res);
 		return ret;
 	}
+	if (current->io_uring_restrict &&
+	    refcount_dec_and_test(&current->io_uring_restrict->refs))
+		kfree(current->io_uring_restrict);
 	refcount_set(&res->refs, 1);
 	current->io_uring_restrict = res;
 	return 0;
-- 
2.51.0


