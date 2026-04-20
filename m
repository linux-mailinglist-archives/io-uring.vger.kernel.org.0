Return-Path: <io-uring+bounces-13069-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gMUsKfBH5mkPuQEAu9opvQ
	(envelope-from <io-uring+bounces-13069-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 20 Apr 2026 17:36:16 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 14BC842E615
	for <lists+io-uring@lfdr.de>; Mon, 20 Apr 2026 17:36:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id F230B30E75E1
	for <lists+io-uring@lfdr.de>; Mon, 20 Apr 2026 14:39:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 439F74DBD91;
	Mon, 20 Apr 2026 13:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YzldhYrO"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 200664DBD8E;
	Mon, 20 Apr 2026 13:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776692028; cv=none; b=WK1EU2t19Q2hmKX8CaMW0frQ1n35o3TGv7xfq/pdUvwBiN6y+xjetKLhJTrnk4Xsre6dQS5r887izd+29p+5OOTu5miLON5IKKr3nlsGQaNqh+WVZdVmYkRRkUVh0aEwV/+J8ARsgWwY1WkZzjv7LcQMjX2OyBilxnovnqqdLqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776692028; c=relaxed/simple;
	bh=qslmiTzZOBj/SolG5cNMhI4bQRpwy/2XAYcuaJXcV4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o/JlSdvmGxR391Q6Yl559g+8RuIuTfYW/bCYKNOxAA+rnBw03Y+j3VQ2wR3nR/qWCLdZL/qeiD8K37XVCWwvsb/HvFEXDG1vDoebYjMZaN04+3BcS47cMXqRNk/eoQ8OCL2HrSZzTi9SrhG2N1TkYoaHMvcmYMUq9VAnkvwHX/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YzldhYrO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6538C2BCB4;
	Mon, 20 Apr 2026 13:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776692028;
	bh=qslmiTzZOBj/SolG5cNMhI4bQRpwy/2XAYcuaJXcV4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YzldhYrOcTb4A7uifVMJPcw0tOXwcJxcxjrtKuo8qusw6PtwOqRRSw+ilCsKR+Rli
	 eDwASStbl4+I3KPde1CIY1B+CNPpDv38thPx2rMecnpnjDeey4U1F8tKqB97UtrsBJ
	 342USxY+km12dFhZuMX8PbAJkqANrneSBPa/jIt+04b1ttSES87aeOcYR3XD5DCRK4
	 sUX5/osnXaUyZ72Lz82KPFipHO/15htAJk+CHHs56Bd9PGX1C8+nHhq7fMRkz9x1ld
	 l7U/ezkWFMeop90lCjGP36Q4/V3FbkwwwIL59LLRHCo06pS28MHMvaD0MfVfkMmvMG
	 44GOHReTAjplg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Amir Mohammad Jahangirzad <a.jahangirzad@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.1] io_uring/cancel: validate opcode for IORING_ASYNC_CANCEL_OP
Date: Mon, 20 Apr 2026 09:22:06 -0400
Message-ID: <20260420132314.1023554-332-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [0.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk,kernel.org,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13069-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashal@kernel.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[msgid.link:url,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 14BC842E615
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: Amir Mohammad Jahangirzad <a.jahangirzad@gmail.com>

[ Upstream commit 85a58309c0d5b5f5a4b65658312ceaf2c34c9bbf ]

io_async_cancel_prep() reads the opcode selector from sqe->len and
stores it in cancel->opcode, which is an 8-bit field. Since sqe->len
is a 32-bit value, values larger than U8_MAX are implicitly truncated.

This can cause unintended opcode matches when the truncated value
corresponds to a valid io_uring opcode. For example, submitting a value
such as 0x10b will be truncated to 0x0b (IORING_OP_TIMEOUT), allowing a
cancel request to match operations it did not intend to target.
Validate the opcode value before assigning it to the 8-bit field and
reject values outside the valid io_uring opcode range.

Signed-off-by: Amir Mohammad Jahangirzad <a.jahangirzad@gmail.com>
Link: https://patch.msgid.link/20260331232113.615972-1-a.jahangirzad@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a complete analysis. Let me
compile the findings.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem**: io_uring/cancel
- **Action verb**: "validate" — this implies adding a missing validation
  check, strongly indicating a bug fix
- **Summary**: Validates the opcode value before storing it in a
  narrower type field to prevent silent truncation

### Step 1.2: Tags
- **Signed-off-by**: Amir Mohammad Jahangirzad (author), Jens Axboe
  (io_uring maintainer accepted it)
- **Link**: `https://patch.msgid.link/20260331232113.615972-1-
  a.jahangirzad@gmail.com`
- No Fixes: tag, no Reported-by, no Cc: stable — all expected for
  autosel review

### Step 1.3: Commit Body Analysis
The commit body clearly explains:
- **Bug mechanism**: `sqe->len` is `__u32` (32-bit), `cancel->opcode` is
  `u8` (8-bit). Without validation, values >255 are silently truncated.
- **Symptom**: Passing 0x10b is truncated to 0x0b (IORING_OP_TIMEOUT),
  causing a cancel request to match timeout operations the user never
  intended to cancel.
- **Root cause**: Missing input validation before narrowing type
  conversion.

### Step 1.4: Hidden Bug Fix Detection
This is an explicit input validation bug fix. The word "validate" makes
it clear, and the commit directly prevents incorrect behavior caused by
integer truncation.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **Files changed**: 1 (`io_uring/cancel.c`)
- **Lines**: +7/-1 (net +6 lines, but only 4 meaningful lines added)
- **Function modified**: `io_async_cancel_prep()`
- **Scope**: Single-file surgical fix in a single function

### Step 2.2: Code Flow Change
Before: `cancel->opcode = READ_ONCE(sqe->len);` — directly assigns
32-bit value to 8-bit field, implicit truncation.

After:
```c
u32 op;
op = READ_ONCE(sqe->len);
if (op >= IORING_OP_LAST)
    return -EINVAL;
cancel->opcode = op;
```
Now validates the value is within the valid opcode range before
assigning.

### Step 2.3: Bug Mechanism
This is a **type/correctness bug** — narrowing conversion without bounds
checking. Category: input validation / logic correctness fix.

### Step 2.4: Fix Quality
- **Obviously correct**: Yes — validates `op >= IORING_OP_LAST` before
  narrowing to u8
- **Minimal/surgical**: Yes — 4 effective lines, single function
- **Regression risk**: Extremely low — the only new behavior is
  rejecting previously-accepted invalid values (which would have caused
  incorrect matching). Existing valid uses are unaffected since all
  valid opcodes are < IORING_OP_LAST and < 256.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
The buggy line `cancel->opcode = READ_ONCE(sqe->len);` was introduced in
commit `d7b8b079a8f6bc` by Jens Axboe (2023-06-23), "io_uring/cancel:
support opcode based lookup and cancelation".

### Step 3.2: Fixes Target
No Fixes: tag, but the bug was clearly introduced by `d7b8b079a8f6bc`.
That commit added the `IORING_ASYNC_CANCEL_OP` feature and the opcode
field but neglected to validate the input value.

`d7b8b079a8f6bc` was first released in v6.6-rc1 (verified: not in v6.5,
present in v6.6).

### Step 3.3: Related Changes
Between the buggy commit and HEAD, `io_uring/cancel.c` had ~20 non-merge
changes, mostly structural reorganization (moving code to cancel.c from
io_uring.c). None fix this specific truncation issue.

### Step 3.4: Author
The author (Amir Mohammad Jahangirzad) is not the subsystem maintainer
but has submitted other kernel fixes. The patch was accepted and signed
by Jens Axboe, the io_uring subsystem maintainer.

### Step 3.5: Dependencies
None. This is a standalone, self-contained fix. The `IORING_OP_LAST`
sentinel has existed since the io_uring opdef array was created and is
present in all relevant stable trees.

---

## PHASE 4: MAILING LIST RESEARCH

### Step 4.1: Original Patch
Lore.kernel.org is behind an anti-bot wall; b4 dig could not find the
commit by message-id (commit too recent for the local index). The Link
tag in the commit confirms the patch was submitted and reviewed on the
mailing list.

### Step 4.2: Reviewer
Jens Axboe (io_uring maintainer) signed off and merged the patch, which
is strong validation.

### Step 4.3–4.5
No bug report references found. No explicit stable nomination found. The
bug was apparently discovered by code inspection rather than a runtime
report.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Modified Function
`io_async_cancel_prep()` — the SQE preparation function for
`IORING_OP_ASYNC_CANCEL`.

### Step 5.2: Callers
`io_async_cancel_prep` is called from the opdef table
(`io_uring/opdef.c` line 196) as the `.prep` handler for
`IORING_OP_ASYNC_CANCEL`. This is triggered every time a user submits an
async cancel request through the io_uring interface.

### Step 5.3: Impact Path
The opcode stored here flows into `io_cancel_data.opcode`, which is
compared against `req->opcode` in `io_cancel_req_match()`. A truncated
opcode would match the wrong operations.

### Step 5.4: Reachability
This is directly reachable from userspace via `io_uring_enter()` → SQE
processing → `io_async_cancel_prep()`. Any unprivileged user with access
to io_uring can trigger this.

### Step 5.5: io_sync_cancel path
The `io_sync_cancel` path reads from `struct io_uring_sync_cancel_reg`
where `opcode` is already `__u8`, so truncation cannot occur there.
However, that path also lacks a `>= IORING_OP_LAST` check, which is a
separate (less critical) issue since values 0-255 that exceed
IORING_OP_LAST would simply not match any operation.

---

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Affected Stable Trees
The buggy code (`d7b8b079a8f6bc`) was introduced in v6.6-rc1 (confirmed:
present in v6.6, not in v6.5). All stable trees from 6.6.y onward
contain the bug: 6.6.y, 6.12.y.

### Step 6.2: Backport Complications
The fix modifies a simple code block that has not changed since the
original introduction. It should apply cleanly to any stable tree that
has the IORING_ASYNC_CANCEL_OP feature (6.6+). `IORING_OP_LAST` exists
in all these trees.

### Step 6.3: No prior fix
No other fix for this same issue was found in the commit history.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem
**io_uring** — a high-performance async I/O interface. Criticality:
**IMPORTANT**. Widely used in modern Linux applications, database
systems, and high-performance servers.

### Step 7.2: Activity
io_uring is very actively developed with frequent changes. Jens Axboe is
the sole maintainer.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Affected Users
All users of io_uring who use the `IORING_ASYNC_CANCEL_OP` feature
(cancel by opcode). This includes both applications and libraries like
liburing.

### Step 8.2: Trigger
- A user submits an `IORING_OP_ASYNC_CANCEL` SQE with
  `IORING_ASYNC_CANCEL_OP` flag and `sqe->len` value > 255
- The value silently truncates, potentially matching a valid opcode
- Example: 0x10b → 0x0b (IORING_OP_TIMEOUT)
- **Unprivileged users can trigger this**

### Step 8.3: Severity
- **Failure mode**: Wrong operations get cancelled unexpectedly
- **Impact**: Application-level data loss or incorrect behavior (e.g.,
  timeouts cancelled that shouldn't be, leading to stuck operations or
  missed deadlines)
- **Severity**: MEDIUM — not a kernel crash, but causes incorrect
  kernel-userspace contract behavior

### Step 8.4: Risk-Benefit
- **Benefit**: Prevents incorrect operation cancellation due to integer
  truncation. Clear correctness fix.
- **Risk**: Very low — the only behavioral change is rejecting invalid
  opcodes (>= IORING_OP_LAST) that previously caused silent truncation.
  Valid applications are completely unaffected.
- **Ratio**: High benefit / very low risk

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence
**FOR backporting:**
- Fixes a real input validation bug (u32→u8 truncation without bounds
  check)
- Can cause incorrect operation matching (wrong cancellations)
- Reachable from unprivileged userspace
- Fix is minimal (4 effective lines), obviously correct, zero regression
  risk
- Accepted by io_uring maintainer Jens Axboe
- Bug present in active stable trees (6.6.y, 6.12.y)
- Standalone fix, no dependencies

**AGAINST backporting:**
- Not a crash, security vulnerability, or data corruption at the kernel
  level
- Requires passing an invalid opcode value (>255) to trigger
- No user reports of this bug being hit in practice

### Step 9.2: Stable Rules Checklist
1. **Obviously correct and tested?** YES — trivial bounds check
2. **Fixes a real bug?** YES — integer truncation causes wrong operation
   matching
3. **Important issue?** MEDIUM — incorrect io_uring behavior, not a
   crash
4. **Small and contained?** YES — 4 lines in one function
5. **No new features/APIs?** CORRECT — only adds validation
6. **Can apply to stable?** YES — clean apply expected for 6.6+

### Step 9.3: Exception Categories
Not an exception category; standard bug fix.

### Step 9.4: Decision
This is a clear input validation bug with a trivial, risk-free fix.
While not a crash-level severity, it causes the kernel to violate the
io_uring API contract — an opcode value of 0x10b should either be
rejected or never match opcode 0x0b. Silently doing the wrong thing is a
real bug. The fix is obviously correct, tiny, and cannot regress
anything.

---

## Verification

- [Phase 1] Parsed subject: "validate opcode for IORING_ASYNC_CANCEL_OP"
  — clear input validation fix
- [Phase 1] Tags: Signed-off-by Jens Axboe (maintainer), Link to lore
- [Phase 2] Diff: +7/-1 in io_async_cancel_prep(), adds u32 temp + range
  check before u8 assignment
- [Phase 2] Verified sqe->len is `__u32` (include/uapi/linux/io_uring.h
  line 51), cancel->opcode is `u8` (cancel.c line 29)
- [Phase 3] git blame: buggy line introduced by d7b8b079a8f6bc (Jens
  Axboe, 2023-06-23)
- [Phase 3] git merge-base: d7b8b079a8f6bc is in v6.6 but NOT in v6.5
  (confirmed with --is-ancestor)
- [Phase 3] git describe: first in v6.6-rc1~152^2~40
- [Phase 4] b4 dig on d7b8b079a8f6bc: original series at
  lore.kernel.org/all/20230623164804.610910-8-axboe@kernel.dk/
- [Phase 4] Lore anti-bot blocked direct web access
- [Phase 5] io_async_cancel_prep called from opdef.c line 196, reachable
  from userspace io_uring_enter
- [Phase 5] Verified io_sync_cancel uses __u8 opcode in struct
  io_uring_sync_cancel_reg — no truncation there
- [Phase 5] Verified IORING_OP_LAST exists in
  include/uapi/linux/io_uring.h line 321
- [Phase 6] Buggy code present in 6.6.y+ stable trees (verified)
- [Phase 6] No conflicting changes found — clean apply expected
- [Phase 8] Unprivileged userspace trigger confirmed — io_uring
  accessible without privileges
- UNVERIFIED: Could not access lore discussion for the specific fix
  commit due to anti-bot protection

**YES**

 io_uring/cancel.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index 65e04063e343b..5e5eb9cfc7cd6 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -156,9 +156,16 @@ int io_async_cancel_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		cancel->fd = READ_ONCE(sqe->fd);
 	}
 	if (cancel->flags & IORING_ASYNC_CANCEL_OP) {
+		u32 op;
+
 		if (cancel->flags & IORING_ASYNC_CANCEL_ANY)
 			return -EINVAL;
-		cancel->opcode = READ_ONCE(sqe->len);
+
+		op = READ_ONCE(sqe->len);
+		if (op >= IORING_OP_LAST)
+			return -EINVAL;
+
+		cancel->opcode = op;
 	}
 
 	return 0;
-- 
2.53.0


