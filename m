Return-Path: <io-uring+bounces-11438-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 70E23CFFCC1
	for <lists+io-uring@lfdr.de>; Wed, 07 Jan 2026 20:41:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 64144309A7D4
	for <lists+io-uring@lfdr.de>; Wed,  7 Jan 2026 19:37:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EBF43A97E5;
	Wed,  7 Jan 2026 15:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SAJZ2nA8"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B5A39C657;
	Wed,  7 Jan 2026 15:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767801214; cv=none; b=qVuWuvbvRNf22ZzCNQ2jlM4tUUjYNHicqlfNwzNY4SubdK2NvvwuZ8N0GvMuedyB6lgPReLVG2DBzMJhloGmfB6H1MqTPYeKOPSsL7C1Jv4NAIdAhmNtSff8WxKjOO1VKE8RwDW6TFfsowZ8cqqiTQ/YqfERtWU4rCylhf3Muhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767801214; c=relaxed/simple;
	bh=1l8gtyiVh89SnrAAKIoGglB35M8j8jbonFhl8c4Gh40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L8cBEuTMuLslgGz771D6QAh5ZEX+mdMBt8QLAfG/mJsaluZxrOcad4TGsZgj0pj9IODRVZ50ykhVaU6USZL35zL2BWqkB7/6ORKGMrgR1yKuZeYv3/G4dl0Ckd4p9vkXnGEqiLko7N1dhcXcjE3eTqZxxXk7eaiuCH9/8CYLGdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SAJZ2nA8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31618C19422;
	Wed,  7 Jan 2026 15:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767801212;
	bh=1l8gtyiVh89SnrAAKIoGglB35M8j8jbonFhl8c4Gh40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SAJZ2nA8+w/T0cOLmRCYqOAYrDWeqoXUD+dqoDvMBAY1N9cSSUrxylOLn8mL8XGm/
	 8EX1mAiA0+2Udxoug70GGvFuAyirph8wko39dCjnQj4s5n01Q9hEQ7tZce4Mj80Xwd
	 jYSp4EeU9FBHlOMQCsCF4gQstibDzKAI/vsTmeN+nlQuxWTWT+Az/VSLts4B2EmnXC
	 RFU8w4aPgDAlmOzQ7fTzXH+1YjUucC6/NqC1L5ICTCK8oHbrqpYtVHnkCQzu+9cxOv
	 9Zr1KeD9ALy3VCl6x+UuLBL+gfOOWT4S2TDBHgeDi/UPmtSfftz/nw+DXoFGTOnwCJ
	 1wSfEa8dI6JSQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alexandre Negrel <alexandre@negrel.dev>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] io_uring: use GFP_NOWAIT for overflow CQEs on legacy rings
Date: Wed,  7 Jan 2026 10:53:04 -0500
Message-ID: <20260107155329.4063936-2-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260107155329.4063936-1-sashal@kernel.org>
References: <20260107155329.4063936-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexandre Negrel <alexandre@negrel.dev>

[ Upstream commit fc5ff2500976cd2710a7acecffd12d95ee4f98fc ]

Allocate the overflowing CQE with GFP_NOWAIT instead of GFP_ATOMIC. This
changes causes allocations to fail earlier in out-of-memory situations,
rather than being deferred. Using GFP_ATOMIC allows a process to exceed
memory limits.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220794
Signed-off-by: Alexandre Negrel <alexandre@negrel.dev>
Link: https://lore.kernel.org/io-uring/20251229201933.515797-1-alexandre@negrel.dev/
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of io_uring GFP_NOWAIT Commit

### 1. COMMIT MESSAGE ANALYSIS

The commit message is clear and well-structured:
- **Problem**: Using `GFP_ATOMIC` for overflow CQE allocations allows
  processes to exceed memory limits
- **Solution**: Change to `GFP_NOWAIT` which fails earlier in OOM
  situations
- **Bug Reference**: Links to kernel bugzilla (bug 220794) - indicates a
  real user-reported issue
- **Proper sign-offs**: Author and maintainer (Jens Axboe) signatures
  present

The key insight is that `GFP_ATOMIC` can dip into emergency memory
reserves, allowing allocations to succeed even when a process should be
constrained by memory limits. This is a resource exhaustion / memory
limit bypass issue.

### 2. CODE CHANGE ANALYSIS

The change is minimal - a single line:
```c
- ocqe = io_alloc_ocqe(ctx, cqe, big_cqe, GFP_ATOMIC);
+       ocqe = io_alloc_ocqe(ctx, cqe, big_cqe, GFP_NOWAIT);
```

**Technical mechanism of the bug:**
- `io_cqe_overflow_locked()` is called when the completion queue is full
  and entries must overflow
- This function runs with `completion_lock` held, so it cannot sleep
  (ruling out `GFP_KERNEL`)
- `GFP_ATOMIC` can access emergency memory reserves, bypassing memory
  limits
- `GFP_NOWAIT` is also non-sleeping but respects memory limits by
  failing instead of dipping into reserves

**Why the fix works:**
- Both flags are appropriate for the atomic context (holding spinlock)
- `GFP_NOWAIT` is semantically correct: the allocation should fail
  gracefully under memory pressure rather than bypass system memory
  constraints

### 3. CLASSIFICATION

- **Bug fix**: Yes - fixes memory limit bypass
- **Feature**: No - no new functionality added
- **Security-relevant**: Yes - this could be exploited for resource
  exhaustion/DoS, particularly in containerized or multi-tenant
  environments with memory cgroups

### 4. SCOPE AND RISK ASSESSMENT

- **Lines changed**: 1
- **Files touched**: 1 (io_uring/io_uring.c)
- **Complexity**: Trivial
- **Function context**: `__cold` path - not in hot path, used only
  during overflow conditions

**Risk analysis:**
- Allocation may fail more readily under memory pressure - but that's
  the *intended* behavior
- If overflow allocation fails, the CQE won't be recorded - applications
  relying on completion notifications might be affected, but this is
  correct behavior when memory is exhausted
- Very low risk of regression since this is the semantically correct
  change

### 5. USER IMPACT

- **Who is affected**: Users running io_uring workloads (databases,
  high-performance I/O applications)
- **Severity of bug**: Medium-High - allows memory limit bypass which is
  particularly problematic in:
  - Container environments (Docker, Kubernetes)
  - Systems with memory cgroups
  - Multi-tenant systems
- **Reported by users**: Yes - bugzilla link indicates real-world issue

### 6. STABILITY INDICATORS

- Accepted by Jens Axboe (io_uring maintainer)
- Has proper Link: to mailing list discussion
- Referenced bug report demonstrates real user impact
- Simple, well-understood change

### 7. DEPENDENCY CHECK

- No dependencies on other commits
- `io_alloc_ocqe()` and `io_cqe_overflow_locked()` exist in stable
  kernels
- io_uring has been present since kernel 5.1

### CONCLUSION

**Meets stable criteria:**
- ✅ Obviously correct - semantically appropriate GFP flag
- ✅ Fixes a real bug - memory limit bypass (resource exhaustion)
- ✅ Small and contained - single line change
- ✅ No new features or APIs
- ✅ Tested in mainline
- ✅ Referenced bug report shows real user impact

**Risk vs Benefit:**
- Risk: Minimal - well-understood change to allocation flags
- Benefit: Fixes a memory limit bypass that could be used for DoS

This is an ideal stable backport candidate: a tiny, surgical fix
addressing a real security-relevant bug (memory limit bypass) with
minimal risk of regression.

**YES**

 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 60adab71ad2d..93b203205a16 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -897,7 +897,7 @@ static __cold bool io_cqe_overflow_locked(struct io_ring_ctx *ctx,
 {
 	struct io_overflow_cqe *ocqe;
 
-	ocqe = io_alloc_ocqe(ctx, cqe, big_cqe, GFP_ATOMIC);
+	ocqe = io_alloc_ocqe(ctx, cqe, big_cqe, GFP_NOWAIT);
 	return io_cqring_add_overflow(ctx, ocqe);
 }
 
-- 
2.51.0


