Return-Path: <io-uring+bounces-11574-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9451FD0BF82
	for <lists+io-uring@lfdr.de>; Fri, 09 Jan 2026 19:54:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E1DE9302F921
	for <lists+io-uring@lfdr.de>; Fri,  9 Jan 2026 18:52:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC4B4271456;
	Fri,  9 Jan 2026 18:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="z+khOxDZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4931487F6
	for <io-uring@vger.kernel.org>; Fri,  9 Jan 2026 18:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767984725; cv=none; b=TvftOLIKYT2WrvRLYzuewWcTuayBLYQz5RlM9sy0Hf48h50+NaxSnkKHZz2X/3hhrJg1sT0r6zVGZrOKsoKneHbUzW6CHU0bI4xtv4IKaGwZ5XEunRH+0SVRxtHXzPG4MDf9o7NdVEyQZwO1V9f5pBOFmUFnS9inlThJ9c3qljk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767984725; c=relaxed/simple;
	bh=FFOLvsCBnv9jOu9OJyxQ3/4b8z/X3tUytwmF5fgjQDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uPlSSeRHJqI8nI03lyR6d4tGXGNlQWfp518fm2UpSDfmHoSUA8fjIU7N+RtsU6QB8Lb+pcj+WhHd1UAQyxTH4sYLS9x3HiLPQ9b6BnB7EXtJeD7ft5Fat5DE8MDJlVmFtefZuaYAeyMbI9X4UBUezxuIBruHEMFIIseizLQjq2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=z+khOxDZ; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-45a84c6746cso614419b6e.1
        for <io-uring@vger.kernel.org>; Fri, 09 Jan 2026 10:52:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1767984722; x=1768589522; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a7lH1WbjPy/JBO3nsNhjmGwMuJ/BaJT/6MC/Hr9gvEw=;
        b=z+khOxDZ14BlVSDvwxtAdqRvOPoUm86+jlDRlDJFngOE9dAWryMyZAYgHjreNcwsvt
         WKiAn7ZcASAX+mK/4WtZWJJTz8Q4f2IBCnVqpJC4MmFF8JC1opMxwHvZiQC4q24vOLYL
         +IBArqlLurGinffA8BJZZUiBFEy/JdjX7Y5RdnCzM0j+pIKWA2oEG1wZ0vR3+EgJjHB1
         XxAzhM4wnxOnUDf5vOHoKWzQ24+4JigH0A8+W4l/EjEhlAa5csQSR9B2faHYvLq9Wdle
         YJ02vgwSCBr0D20o2una3Yf/tglsl9onO9I7RGiGEFXy2rZJspr17j/nWd8imGWaU4GL
         flMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767984722; x=1768589522;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=a7lH1WbjPy/JBO3nsNhjmGwMuJ/BaJT/6MC/Hr9gvEw=;
        b=Nr5KCtXDWySG+RNIWxlmcAdJkKgS4W4uG32DDZ/kG6gQBuCsawkACnBv2WG05ios0R
         DoiuWnONuMN8KnYlD+P152eXv2tMKGXOXHuN0xw6LPjHh12ScpDM/A8vh8j24q3IJXTx
         a8n8tHgla5d5tlLQgpxSIpYF5toPptGxGrgmRHqssylZNzMxVmRtsPXt+L2wBQyGnzTY
         +j3anY6ItwFVYQWjiJNE4XlMccRbbeawWtWyrezvYK9iYAtaDveFAdH9eE2qQIkrtRFJ
         PhrwosdPiC9mXPwbCRuh1IzgdDPdpcpiDvqeocJKUq/ZzgPppm0eOskRSWQc747DtySz
         /bBw==
X-Gm-Message-State: AOJu0YyLGVm5wiXS1qT1iJizf/07HaurEmyiOQuoYx3g45jyjE0R62ue
	3PmASKaY1JQoREqz/tUjfhzZV526NJGX+R1tywHRUxddiQT87zZjXV4j4TlBlD7cc16Eb+fSgG+
	8XH1K
X-Gm-Gg: AY/fxX7GUkPdYR0O6xlFQL6zDOqB5Bz5+MstNgHSSITvHzOW9UJC0uxUQNEuJCUpgTC
	COo6Zl026yDuk8NKB/xjkumKj1og7qDkXKkjXUrulEKkFhi/23SIkmdNbQM8Mlp3EPFue/J62hu
	GXqAegtKaWjyA5lNC2JBzBolavP0+GAmoaoY36nlEe1lMRVpuCZSheXm1fVmJ3X4iIRYwKnOpPZ
	3U2zX+YLpgOtslirfCmxVixADX+lxfUkzCCqDL09yL+VyXcUcDNtmNQlbqOy5J28qG82PCVAuS7
	JJP3l2oswLZXvWHV1HuJ8JIa60NPNLGn8IpslGZRq9BtZ1B5RxjAT5SaJtu3sWTBCb/CxPd7qmN
	dnR0bZFYjrlFQz1bouhb/LgXcQ0CrtUrZwfBt44UGTyRR3aSMGJ0mt/kr0Fvsq26FYJqQ8A==
X-Google-Smtp-Source: AGHT+IE9GyHfjROsCmIpfvHazY3V40Lux0etDmnIvHJbqWUUhN3fMaqJcC3oGnNcqahZipUEo4fW+g==
X-Received: by 2002:a05:6808:c238:b0:450:c9c3:a249 with SMTP id 5614622812f47-45a6bf119b4mr5767049b6e.45.1767984721899;
        Fri, 09 Jan 2026 10:52:01 -0800 (PST)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45a5e288bc7sm5371868b6e.12.2026.01.09.10.52.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 10:52:01 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: krisman@suse.de,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring/register: allow original task restrictions owner to unregister
Date: Fri,  9 Jan 2026 11:48:27 -0700
Message-ID: <20260109185155.88150-4-axboe@kernel.dk>
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

Currently any attempt to register a set of task restrictions if an
existing set exists will fail with -EPERM. But it is feasible to let the
original creator/owner performance this operation. Either to remove
restrictions entirely, or to replace them with a new set.

If an existing set exists and NULL is passed for the new set, the
current set is unregistered. If an existing set exists and a new set is
supplied, the old set is dropped and replaced with the new one.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  1 +
 io_uring/register.c            | 45 ++++++++++++++++++++++++++++------
 2 files changed, 38 insertions(+), 8 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 196f41ec6d60..1ff7817b3535 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -222,6 +222,7 @@ struct io_rings {
 struct io_restriction {
 	DECLARE_BITMAP(register_op, IORING_REGISTER_LAST);
 	DECLARE_BITMAP(sqe_op, IORING_OP_LAST);
+	pid_t pid;
 	refcount_t refs;
 	u8 sqe_flags_allowed;
 	u8 sqe_flags_required;
diff --git a/io_uring/register.c b/io_uring/register.c
index 552b22f6b2dc..c8b8a9edbc65 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -189,12 +189,19 @@ static int io_register_restrictions_task(void __user *arg, unsigned int nr_args)
 {
 	struct io_uring_task_restriction __user *ures = arg;
 	struct io_uring_task_restriction tres;
-	struct io_restriction *res;
+	struct io_restriction *old_res, *res;
 	int ret;
 
 	if (nr_args != 1)
 		return -EINVAL;
 
+	res = current->io_uring_restrict;
+	if (!ures) {
+		if (!res)
+			return -EFAULT;
+		goto drop_set;
+	}
+
 	if (copy_from_user(&tres, arg, sizeof(tres)))
 		return -EFAULT;
 
@@ -207,13 +214,27 @@ static int io_register_restrictions_task(void __user *arg, unsigned int nr_args)
 	 * Disallow if task already has registered restrictions, and we're
 	 * not passing in further restrictions to add to an existing set.
 	 */
-	if (current->io_uring_restrict &&
-	    !(tres.flags & IORING_REG_RESTRICTIONS_MASK))
-		return -EPERM;
+	old_res = NULL;
+	if (res && !(tres.flags & IORING_REG_RESTRICTIONS_MASK)) {
+		/* Not owner, may only append further restrictions */
+drop_set:
+		if (res->pid != current->pid)
+			return -EPERM;
+		/* Old set to be put later if we succeed */
+		old_res = res;
+		/* No new mask supplied, we're done */
+		if (!ures) {
+			ret = 0;
+			current->io_uring_restrict = NULL;
+			goto out;
+		}
+	}
 
 	res = kzalloc(sizeof(*res), GFP_KERNEL);
-	if (!res)
-		return -ENOMEM;
+	if (!res) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	/*
 	 * Can only be set if we're MASK'ing in more restrictions. If so,
@@ -226,14 +247,22 @@ static int io_register_restrictions_task(void __user *arg, unsigned int nr_args)
 				    tres.flags & IORING_REG_RESTRICTIONS_MASK);
 	if (ret) {
 		kfree(res);
-		return ret;
+		goto out;
 	}
 	if (current->io_uring_restrict &&
 	    refcount_dec_and_test(&current->io_uring_restrict->refs))
 		kfree(current->io_uring_restrict);
+	res->pid = current->pid;
 	refcount_set(&res->refs, 1);
 	current->io_uring_restrict = res;
-	return 0;
+	ret = 0;
+out:
+	if (ret) {
+		if (old_res)
+			current->io_uring_restrict = old_res;
+	} else if (old_res && refcount_dec_and_test(&old_res->refs))
+		kfree(old_res);
+	return ret;
 }
 
 static int io_register_enable_rings(struct io_ring_ctx *ctx)
-- 
2.51.0


