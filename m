Return-Path: <io-uring+bounces-9952-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 43447BCA0D4
	for <lists+io-uring@lfdr.de>; Thu, 09 Oct 2025 18:13:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 89B2C4FDF94
	for <lists+io-uring@lfdr.de>; Thu,  9 Oct 2025 16:07:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D7252264DC;
	Thu,  9 Oct 2025 16:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YwiNNFDf"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448AD2F3C13;
	Thu,  9 Oct 2025 16:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025603; cv=none; b=U6FyoRarh/fWburJ9krS9onh6KpoE1Ooh+2u41zbcnvv5nLjYJtFbQvDDKh6iOLyhlaHClgwZ3YqAxon3IuejfxjN+2IGl/tkaUQUKk4UAMDhGieao1py/v8pK0vAdC8USUpiqz1XFhQt605lkOgM8i7JfskJS6iqhYrmpmHMO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025603; c=relaxed/simple;
	bh=Uw2zzNDBC9Vexn3nS2g+O2Ta5jH8YxIB7tM2uwsQn/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iLW4mRgZ1Qf2H7HUnfvIUaCBJgykuMVrp3veRCBPn3mkl66k0BWdZoQBw3p8T5TukT/Lk2L3wYp4Ew7RCEb0jA1pOrYRR16GsFxMNj84Cg2SsFMJ13DVw7TeuXIOLo7nz9ncIqjuUerG3991VZ7Th5AvGGF9ODT1EMcIQSOkrXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YwiNNFDf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2020DC4CEF8;
	Thu,  9 Oct 2025 16:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025600;
	bh=Uw2zzNDBC9Vexn3nS2g+O2Ta5jH8YxIB7tM2uwsQn/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YwiNNFDfIUtPxSPPXuP9uh1YnYL+5JeacnN1rC64P1JF6/8MGRkhdQxlVaDTmz+Gh
	 vqsdB+NiptPDXY2M7zMXuWNWxRKCvc+QZVkgPieZyhd0O1JsE6oltyLGxPppaZ0nTF
	 ASrgDE43trDOgQcfQAEAiHgqzmvr6VLMqaW5vCIcyxSzuUTjGCriGsd/Avc5toha/D
	 +ZzUL9vBfOxwoY2L/HibXlrIM7ZdZUhPe8jqha1vQzTl427rL7DlraCJgoXsu6Oe9j
	 ZQaLDzxjjZHUJTtgRPxxorG5BKczveyMFAaTPG/3WISIthcNhbWncdR1vgkPXOvBCq
	 /t/HWJs82MrlA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.16] io_uring/rsrc: respect submitter_task in io_register_clone_buffers()
Date: Thu,  9 Oct 2025 11:55:34 -0400
Message-ID: <20251009155752.773732-68-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251009155752.773732-1-sashal@kernel.org>
References: <20251009155752.773732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Caleb Sander Mateos <csander@purestorage.com>

[ Upstream commit 2f076a453f75de691a081c89bce31b530153d53b ]

io_ring_ctx's enabled with IORING_SETUP_SINGLE_ISSUER are only allowed
a single task submitting to the ctx. Although the documentation only
mentions this restriction applying to io_uring_enter() syscalls,
commit d7cce96c449e ("io_uring: limit registration w/ SINGLE_ISSUER")
extends it to io_uring_register(). Ensuring only one task interacts
with the io_ring_ctx will be important to allow this task to avoid
taking the uring_lock.
There is, however, one gap in these checks: io_register_clone_buffers()
may take the uring_lock on a second (source) io_ring_ctx, but
__io_uring_register() only checks the current thread against the
*destination* io_ring_ctx's submitter_task. Fail the
IORING_REGISTER_CLONE_BUFFERS with -EEXIST if the source io_ring_ctx has
a registered submitter_task other than the current task.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
**Why Backport**
- `io_uring/register.c:646` already enforces
  `IORING_SETUP_SINGLE_ISSUER` by rejecting registrations issued by any
  task other than `ctx->submitter_task`, but
  `io_register_clone_buffers()` still grabs `src_ctx->uring_lock`
  without checking `src_ctx->submitter_task` (see current flow in
  `io_uring/rsrc.c:1296-1305`). This lets a non-owner thread interact
  with the source ring, breaking the SINGLE_ISSUER contract introduced
  by d7cce96c449e.
- The patch plugs that only gap by validating `src_ctx->submitter_task
  == current` immediately after `lock_two_rings(ctx, src_ctx)` in
  `io_uring/rsrc.c`, and returning `-EEXIST` when another task tries to
  clone buffers. That keeps all rings with SINGLE_ISSUER consistent with
  the locking and lockdep assumptions documented in
  `io_uring/io_uring.h:136-144`.

**Impact Without Fix**
- A second task can still take `src_ctx->uring_lock` through cloning,
  undermining the guarantee that only the designated submitter ever
  touches that ring. Upcoming optimizations that skip `uring_lock` for
  the submitter rely on this guarantee; leaving the hole risks future
  functional regressions or lockdep splats once those changes land.
- Even today, the gap lets another thread stall a SINGLE_ISSUER ring by
  holding its lock via `IORING_REGISTER_CLONE_BUFFERS`, which
  contradicts users’ expectations after enabling SINGLE_ISSUER.

**Risk & Scope**
- Change is tiny and self-contained (one extra guard plus an early exit)
  with no data structure churn or ABI impact. Rings that are not flagged
  SINGLE_ISSUER have `submitter_task == NULL`, so behaviour is
  unchanged; legitimate same-thread clones still succeed.

**Backport Notes**
- Needs to go only into trees that already contain the clone-buffer
  support (`7cc2a6eadcd7` / `636119af94f2f`) and the SINGLE_ISSUER
  registration gating (`d7cce96c449e`). No further prerequisites
  identified.

 io_uring/rsrc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index f75f5e43fa4aa..e1e5f0fb0f56d 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1299,10 +1299,17 @@ int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg)
 	if (src_ctx != ctx) {
 		mutex_unlock(&ctx->uring_lock);
 		lock_two_rings(ctx, src_ctx);
+
+		if (src_ctx->submitter_task &&
+		    src_ctx->submitter_task != current) {
+			ret = -EEXIST;
+			goto out;
+		}
 	}
 
 	ret = io_clone_buffers(ctx, src_ctx, &buf);
 
+out:
 	if (src_ctx != ctx)
 		mutex_unlock(&src_ctx->uring_lock);
 
-- 
2.51.0


