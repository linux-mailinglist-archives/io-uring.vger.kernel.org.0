Return-Path: <io-uring+bounces-9551-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B9820B412E4
	for <lists+io-uring@lfdr.de>; Wed,  3 Sep 2025 05:27:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 757695E6256
	for <lists+io-uring@lfdr.de>; Wed,  3 Sep 2025 03:27:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C4602D060D;
	Wed,  3 Sep 2025 03:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="PsnShx/C"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f99.google.com (mail-qv1-f99.google.com [209.85.219.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395E32C324D
	for <io-uring@vger.kernel.org>; Wed,  3 Sep 2025 03:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756870023; cv=none; b=oVvLRhO3yNd26UvYxF6oSPjD7RdkpQu4HqEc7KOvWLoCVFGTXw/ntZLVDcu6pW1RNbUmcXo+eKS9VoInsflDor/yVorcSk5OeshhsiPH6fr5kEDmG6mpGtGO7hzmCGVZ3byKa1rnpvScsx92ARcci0Nwe2im4KJ9WBwziggfmbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756870023; c=relaxed/simple;
	bh=ImgJ+08fKEjfMojQOkHQFAmBOTeJebqjPQWHFiTfvp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pmblC+8T/CA3YfhmOWfapJMWX/gWVmiSoygkLNTK5zJ2IFTVg0CX3WHiLptZNZxXaglHWWPEAdYDLhC9uz8Y05kP9lIZxGSyk4sYCmkzk4hzLHG8peW3hiInGlulCsemPGFqS7bm+KRTCdf0+MUKgRQbZ6brD7Voyd8nrxtBrmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=PsnShx/C; arc=none smtp.client-ip=209.85.219.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-qv1-f99.google.com with SMTP id 6a1803df08f44-70df87f7beeso3053626d6.1
        for <io-uring@vger.kernel.org>; Tue, 02 Sep 2025 20:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1756870020; x=1757474820; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KAonx/bmXDCVaViB1VqlrTFlzUKjezpOhMXA1F7pd6Y=;
        b=PsnShx/CTYW2GVay6yo6Ynz/rz7VRSpbqWfkQHdXMW3RKPN6rhrIAMs+GOAWAM/zIr
         OwiW410Ee1gEXMEPrKhXf068TUSvwowp/1qaftSehLkAxoRDLPLN/DdpwEErKGpWFBgv
         KLmFwv/i6DKBgMKHVOoebH5wbUYYU/YxuxmVIDQ4HswVJB9HeNkGCjnkKlrL+CbkWUhw
         gnfUbREo4gPpRB5XozB+lh8rESK31QJhyAJ4XGrg5YrlKHYCf/ITMuM93/W6tO8Airbg
         8h1z0yjdzXyvFkEhqqxIpZ8+CZ0xEdoZG9EVRSvfJHvWZT7zg4hA/UlNntfO8G64ZqmM
         WOYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756870020; x=1757474820;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KAonx/bmXDCVaViB1VqlrTFlzUKjezpOhMXA1F7pd6Y=;
        b=vPDjrBAsZXP9waAQCHfwegXHURraU23wJzXPPemYLWPDVVLicPcP5EoMNS0TIaQ9De
         32bO9OSwH7C7z1fQlLGWZj4QO7xuAkgFx50cYuuZPN83kKu4/LMeRN1USFOX8a/bN/68
         G7Jw+uo6Gbb9hOzkW6gFWFCrRuQG39dS8YO2HvV7odcnRTBeTOFsmbz/2Rbh6fB2wxor
         VQ9zt9GunWDCE1rI3BCx8eRcWNQPAyQWcRd6fFFrttQnqTbRmkUG4Vowr3JoNgOU8NJQ
         oDzy+pUyPQNxk5hJYqHE8ffUFUZ/MfYvAIQhP0F3C/iiBqXI4i99v6Rwq/ZAD+zXGDPc
         EN2g==
X-Gm-Message-State: AOJu0YwOVxhvVhUVg23fpwB0Dnuq24AuvLklv8HeZIuEMQLY//s8fnXx
	2OVX37Ivl0W5Jg55iAuUBFrlNzrr7tGGZDkapEVR7uTyY0Muy3IltdKvD2l4yhhaoxhTHjrZVnk
	YAlO41XZLY7pEnZtRQBCW6zzzBUDWwEJHrecu
X-Gm-Gg: ASbGncsyBAeVwad6sKBGPw7rg1XYfxK4CVv6Lj6AgzwlK3Y1uoVHIgjDpe+JeOMnE/Y
	uPzEcnQP5RfbMbQ082XI/gTgVG+EUYZ8N/Ns567T6WPplOAMPYaiFFkIa53KS7s80d+WP95jCA9
	S4iFjdFG8fxu8sFfD7lQ9q6V5rRO5KigxfHx+tw98yUSCQ6gyASXlRt3g8fLZmYJwg8H6PK4hzW
	5xcdH8uTn/AZw0JxOaqAu7IC4XNW9ghXqLWKsXu0LT1nWCqdw177Uc1Bk7YkrBZy60AOyI13H4L
	bhLH6dt+7WpxbfwEZ9dJ4eeEO3WlBCkN7mnSzwpddDkAH16WUbYrSnwRRmCJsJFULhrSkcpW
X-Google-Smtp-Source: AGHT+IG4HTg3TQ8eCdCiuungKWZdyTjI6dzWCVcFbYKIm0C/iu3B1cWQBq2QkDd1mxDz5E33rWXupNCuUCCi
X-Received: by 2002:a0c:f11c:0:b0:722:c5aa:3c75 with SMTP id 6a1803df08f44-722c5aa4a96mr11310576d6.2.1756870020190;
        Tue, 02 Sep 2025 20:27:00 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.129])
        by smtp-relay.gmail.com with ESMTPS id 6a1803df08f44-720b4c2bcbdsm2295146d6.34.2025.09.02.20.26.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 20:27:00 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (unknown [IPv6:2620:125:9007:640:ffff::1199])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 88655340344;
	Tue,  2 Sep 2025 21:26:59 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 866C3E41964; Tue,  2 Sep 2025 21:26:59 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH 4/4] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
Date: Tue,  2 Sep 2025 21:26:56 -0600
Message-ID: <20250903032656.2012337-5-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250903032656.2012337-1-csander@purestorage.com>
References: <20250903032656.2012337-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_ring_ctx's mutex uring_lock can be quite expensive in high-IOPS
workloads. Even when only one thread pinned to a single CPU is accessing
the io_ring_ctx, the atomic CAS required to lock and unlock the mutex is
a very hot instruction. The mutex's primary purpose is to prevent
concurrent io_uring system calls on the same io_ring_ctx. However, there
is already a flag IORING_SETUP_SINGLE_ISSUER that promises only one
task will make io_uring_enter() and io_uring_register() system calls on
the io_ring_ctx once it's enabled.
So if the io_ring_ctx is setup with IORING_SETUP_SINGLE_ISSUER, skip the
uring_lock mutex_lock() and mutex_unlock() for the io_uring_enter()
submission as well as for io_handle_tw_list(). io_uring_enter()
submission calls __io_uring_add_tctx_node_from_submit() to verify the
current task matches submitter_task for IORING_SETUP_SINGLE_ISSUER. And
task work can only be scheduled on tasks that submit io_uring requests,
so io_handle_tw_list() will also only be called on submitter_task.
There is a goto from the io_uring_enter() submission to the middle of
the IOPOLL block which assumed the uring_lock would already be held.
This is no longer the case for IORING_SETUP_SINGLE_ISSUER, so goto the
preceding mutex_lock() in that case.
It may be possible to avoid taking uring_lock in other places too for
IORING_SETUP_SINGLE_ISSUER, but these two cover the primary hot paths.
The uring_lock in io_uring_register() is necessary at least before the
io_uring is enabled because submitter_task isn't set yet. uring_lock is
also used to synchronize IOPOLL on submitting tasks with io_uring worker
tasks, so it's still needed there. But in principle, it should be
possible to remove the mutex entirely for IORING_SETUP_SINGLE_ISSUER by
running any code needing exclusive access to the io_ring_ctx in task
work context on submitter_task.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/io_uring.c |  6 +++++-
 io_uring/io_uring.h | 14 ++++++++++++++
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 7f19b6da5d3d..5793f6122159 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3534,12 +3534,15 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		if (ret != to_submit) {
 			io_ring_ctx_unlock(ctx);
 			goto out;
 		}
 		if (flags & IORING_ENTER_GETEVENTS) {
-			if (ctx->syscall_iopoll)
+			if (ctx->syscall_iopoll) {
+				if (ctx->flags & IORING_SETUP_SINGLE_ISSUER)
+					goto iopoll;
 				goto iopoll_locked;
+			}
 			/*
 			 * Ignore errors, we'll soon call io_cqring_wait() and
 			 * it should handle ownership problems if any.
 			 */
 			if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
@@ -3556,10 +3559,11 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 			 * We disallow the app entering submit/complete with
 			 * polling, but we still need to lock the ring to
 			 * prevent racing with polled issue that got punted to
 			 * a workqueue.
 			 */
+iopoll:
 			mutex_lock(&ctx->uring_lock);
 iopoll_locked:
 			ret2 = io_validate_ext_arg(ctx, flags, argp, argsz);
 			if (likely(!ret2))
 				ret2 = io_iopoll_check(ctx, min_complete);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index a0580a1bf6b5..7296b12b0897 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -121,20 +121,34 @@ bool io_match_task_safe(struct io_kiocb *head, struct io_uring_task *tctx,
 
 void io_activate_pollwq(struct io_ring_ctx *ctx);
 
 static inline void io_ring_ctx_lock(struct io_ring_ctx *ctx)
 {
+	if (ctx->flags & IORING_SETUP_SINGLE_ISSUER) {
+		WARN_ON_ONCE(current != ctx->submitter_task);
+		return;
+	}
+
 	mutex_lock(&ctx->uring_lock);
 }
 
 static inline void io_ring_ctx_unlock(struct io_ring_ctx *ctx)
 {
+	if (ctx->flags & IORING_SETUP_SINGLE_ISSUER) {
+		WARN_ON_ONCE(current != ctx->submitter_task);
+		return;
+	}
+
 	mutex_unlock(&ctx->uring_lock);
 }
 
 static inline void io_ring_ctx_assert_locked(const struct io_ring_ctx *ctx)
 {
+	if (ctx->flags & IORING_SETUP_SINGLE_ISSUER &&
+	    current == ctx->submitter_task)
+		return;
+
 	lockdep_assert_held(&ctx->uring_lock);
 }
 
 static inline void io_lockdep_assert_cq_locked(struct io_ring_ctx *ctx)
 {
-- 
2.45.2


