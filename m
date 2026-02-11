Return-Path: <io-uring+bounces-12149-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UK70DIp3jGktpAAAu9opvQ
	(envelope-from <io-uring+bounces-12149-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 13:35:22 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A88012458F
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 13:35:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C250E308E520
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 12:32:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 430261C84BD;
	Wed, 11 Feb 2026 12:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n57PjagU"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7D7194AD7;
	Wed, 11 Feb 2026 12:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770813144; cv=none; b=Ly/8Jjww/yF6hgiTFAioP0VdlNt3Rz1yR5kNJ7XAmP6Zal6955v8m+7R7FQbL7eEQUuQDeGj57kluZNyMsTmnIFeWDB1+iPouKwchna3XEquB1kF0U31SQrZUTKwqUg70x8HGAKTCsIFFKjIh37isRxgwXLpfQ5sIigGTI0zHj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770813144; c=relaxed/simple;
	bh=2pLNJ7tM2TgzQRNRP4gXAgPg3AnoeBzDt59KZShkz4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dfuq6KlZAjd61HruLca7bw01TlOr3ZV2Y2uYxh9Yz4WW8HovbPZXbCnXme690QwkwWVefHQ3qHH6GcVoeRSiLUowf0rCa5tWSPD+uG97588nBrmsjGPrt+Z5w8Gqc4ZN5+tqSIPWCJV8qOhiMIA8GhfkIVdBKV6XF2M2pqDJ/UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n57PjagU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53581C19421;
	Wed, 11 Feb 2026 12:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770813144;
	bh=2pLNJ7tM2TgzQRNRP4gXAgPg3AnoeBzDt59KZShkz4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n57PjagUiR6YaovKaD4+uWxIUqeySoxHzCi5q09GrfKX/+1Rmx5HxWqIuVWz44Fsh
	 bml6cUneqfF69tbQpZFyFq7lhu1t/F2JqNJDonLHdU30nP/pRY6YesdXybfJN1l9s7
	 PI7TbpRnCp22mW7/e3T6xNadSUNvDelReSKYfZtocqRI1m7voZeTSdsmQrv/B/YPBW
	 ixbVEjmWrc6wB5j+Tntt90n5fjuPafiC67iC+I0Z6axIGlyuufte9+AZbdBVLoW4VX
	 +zHdXnNdM1eJMrddvcjfbSO8RaUvwBV4DWHSkbAYUHcSzHULYyun5RQVPw/NgnP/iz
	 743DFBZWgE16Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	syzbot+6c48db7d94402407301e@syzkaller.appspotmail.com,
	Sasha Levin <sashal@kernel.org>,
	io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] io_uring/timeout: annotate data race in io_flush_timeouts()
Date: Wed, 11 Feb 2026 07:30:45 -0500
Message-ID: <20260211123112.1330287-35-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260211123112.1330287-1-sashal@kernel.org>
References: <20260211123112.1330287-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-12149-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashal@kernel.org,io-uring@vger.kernel.org];
	RCPT_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[io-uring,6c48db7d94402407301e];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:email,appspotmail.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7A88012458F
X-Rspamd-Action: no action

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 42b12cb5fd4554679bac06bbdd05dc8b643bcc42 ]

syzbot correctly reports this as a KCSAN race, as ctx->cached_cq_tail
should be read under ->uring_lock. This isn't immediately feasible in
io_flush_timeouts(), but as long as we read a stable value, that should
be good enough. If two io-wq threads compete on this value, then they
will both end up calling io_flush_timeouts() and at least one of them
will see the correct value.

Reported-by: syzbot+6c48db7d94402407301e@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Good - the commit `42b12cb5fd455` does contain the fix. The working tree
shows the pre-fix state because HEAD (v6.19) doesn't contain this commit
yet (it's likely in the io_uring for-next tree pending merge).

Now I have all the information needed for a comprehensive analysis.

---

## Comprehensive Analysis

### 1. COMMIT MESSAGE ANALYSIS

The commit subject explicitly says "**annotate** data race" — this is
about addressing a KCSAN-reported data race on `ctx->cached_cq_tail` in
`io_flush_timeouts()`. The author (Jens Axboe, io_uring maintainer)
acknowledges:

- syzbot correctly identifies this as a KCSAN race
- `ctx->cached_cq_tail` should be read under `->uring_lock`, which isn't
  feasible here
- The fix uses `READ_ONCE()` to ensure a stable single load
- The race is **benign**: if two io-wq threads compete, both will call
  `io_flush_timeouts()` and at least one will see the correct value

Key tags: `Reported-by: syzbot` (automated fuzzer), authored by `Jens
Axboe` (io_uring maintainer).

### 2. CODE CHANGE ANALYSIS

The change is a single-line modification in `io_flush_timeouts()`:

**Before:**
```c
seq = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
```

**After:**
```c
seq = READ_ONCE(ctx->cached_cq_tail) - atomic_read(&ctx->cq_timeouts);
```

**The race mechanism:**
- `cached_cq_tail` is an `unsigned int` in `struct io_ring_ctx`, in a
  `____cacheline_aligned_in_smp` section
- It is incremented in `io_get_cqe_overflow()` (io_uring.h:256,262) and
  `io_skip_cqe()` (io_uring.c:756), normally under `->completion_lock`
  or `->uring_lock`
- `io_flush_timeouts()` is called from `__io_commit_cqring_flush()` →
  `io_commit_cqring_flush()`, which runs from `__io_cq_unlock_post()`
  and `io_cq_unlock_post()` — both call it **after** releasing
  `completion_lock`
- Without `READ_ONCE()`, the compiler could theoretically generate
  multiple loads of `cached_cq_tail`, or cache a stale value, or
  experience torn reads (though 32-bit aligned reads are atomic on most
  architectures)

**What `READ_ONCE()` provides:**
1. **Compiler barrier**: Prevents the compiler from optimizing away the
   load, generating multiple loads, or reordering it
2. **KCSAN annotation**: Tells KCSAN that this is an intentional racy
   read, suppressing the warning
3. **Single stable load guarantee**: Ensures exactly one load
   instruction is generated

**Interesting precedent**: The same field is accessed in `io_timeout()`
at line 615 using `data_race()` instead:
```c
tail = data_race(ctx->cached_cq_tail) - atomic_read(&ctx->cq_timeouts);
```
This was added in commit `5498bf28d8f2b` (May 2023) for the same reason.
The choice of `READ_ONCE()` over `data_race()` is slightly stronger —
`READ_ONCE()` guarantees a stable volatile load, while `data_race()`
only suppresses the KCSAN warning without changing code generation.

### 3. CLASSIFICATION

This is a **data race fix** (KCSAN-detected), category "race condition".
While the commit message calls it an "annotation," it does address a
real C-language-level data race:
- Without `READ_ONCE()`, the code has undefined behavior per C11 memory
  model (concurrent unsynchronized read/write of the same variable)
- `READ_ONCE()` eliminates compiler-induced issues from this UB

However, the author is clear that the **observable impact is benign** —
the worst case is one thread seeing a slightly stale `cached_cq_tail`,
which just means some timeouts aren't flushed in this pass but will be
flushed in the next.

### 4. SCOPE AND RISK ASSESSMENT

- **Lines changed**: 1 (minimal)
- **Files touched**: 1 (`io_uring/timeout.c`)
- **Complexity**: Trivially low — just wrapping a read with
  `READ_ONCE()`
- **Risk of regression**: Essentially zero. `READ_ONCE()` only adds a
  volatile qualifier to the load; it cannot change functional behavior
- **Subsystem**: io_uring (widely used on modern systems)

### 5. USER IMPACT

- **Who is affected**: Any io_uring user with timeout operations running
  on multi-CPU systems
- **Severity of the bug**: Very low. The race is acknowledged as benign.
  No crash, no corruption, no security issue
- **Observable symptoms**: KCSAN noise in kernel logs when running with
  CONFIG_KCSAN. No user-visible functional issue
- **Without the fix**: Users running KCSAN-enabled kernels see a data
  race report. Theoretically, the compiler could generate suboptimal
  code, though this is unlikely in practice for a single `unsigned int`
  read

### 6. STABILITY INDICATORS

- Written by Jens Axboe (io_uring maintainer and subsystem creator)
- The pattern is well-established — the same fix was done for
  `io_timeout()` in 2023
- The code path is cold (`__cold` attribute on `io_flush_timeouts`)

### 7. DEPENDENCY CHECK

The patch context shows `raw_spin_lock_irq(&ctx->timeout_lock)`, but
stable trees (v6.12, v6.6, v6.1) use `spin_lock_irq(&ctx->timeout_lock)`
because the `raw_spinlock` conversion (`020b40f356249`) hasn't been
backported. The patch will need a trivial context adjustment (the
surrounding `spin_lock_irq` vs `raw_spin_lock_irq` line), but the actual
change (`READ_ONCE()` addition) has no dependencies.

The affected code exists in v6.12, v6.6, and v6.1 stable trees with the
same bug (bare `ctx->cached_cq_tail` read without annotation).

### 8. VERDICT REASONING

**Arguments FOR backporting:**
- Syzbot-reported KCSAN data race — these are real bugs per the C memory
  model
- Fix is trivially small (one line) with zero regression risk
- Fixes undefined behavior (concurrent unsynchronized access)
- `READ_ONCE()` ensures compiler cannot generate problematic code
- Precedent: The same annotation was done for `io_timeout()` in 2023
- io_uring is widely used; this is a commonly exercised path for timeout
  users
- Written by subsystem maintainer

**Arguments AGAINST backporting:**
- The commit message explicitly says the race is benign ("as long as we
  read a stable value, that should be good enough")
- No crash, corruption, security issue, or user-visible problem
- This is fundamentally a KCSAN annotation — it silences a sanitizer
  warning
- The `unsigned int` field is naturally atomic on all supported
  architectures (no tearing)
- The value is read once into a local variable, so compiler optimization
  concerns are minimal

**Assessment:**
While this is a legitimate data race fix and KCSAN reports should be
taken seriously, the commit author explicitly acknowledges this is a
benign race with no user-visible consequences. The fix is purely about
C-language correctness and KCSAN suppression. Stable kernels prioritize
fixes for bugs that affect real users. This data race does not cause
crashes, corruption, or any functional issue. The risk is zero, but the
benefit is also minimal — mainly cleaner KCSAN output for kernel
developers testing stable trees.

This falls in the "nice to have but not necessary" category for stable.
It's an annotation for correctness rather than a fix for a user-facing
bug.

**YES**

 io_uring/timeout.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index d8fbbaf31cf35..84dda24f3eb24 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -130,7 +130,7 @@ __cold void io_flush_timeouts(struct io_ring_ctx *ctx)
 	u32 seq;
 
 	raw_spin_lock_irq(&ctx->timeout_lock);
-	seq = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
+	seq = READ_ONCE(ctx->cached_cq_tail) - atomic_read(&ctx->cq_timeouts);
 
 	list_for_each_entry_safe(timeout, tmp, &ctx->timeout_list, list) {
 		struct io_kiocb *req = cmd_to_io_kiocb(timeout);
-- 
2.51.0


