Return-Path: <io-uring+bounces-12098-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aD6sAWbUiWmFCAAAu9opvQ
	(envelope-from <io-uring+bounces-12098-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 09 Feb 2026 13:34:46 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4944810EADB
	for <lists+io-uring@lfdr.de>; Mon, 09 Feb 2026 13:34:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 19E58300C273
	for <lists+io-uring@lfdr.de>; Mon,  9 Feb 2026 12:27:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D099E374727;
	Mon,  9 Feb 2026 12:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LgnGedJE"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADBF13019CB;
	Mon,  9 Feb 2026 12:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770640038; cv=none; b=EHMF7bypyB9K4DZtVogMaM7M7c1TQ8jWixCFxIhueIc3KLUYF6LsaD0IINzsKN1azWMCAkgltmCS58nAVVPJCtG5tylFdV6N8+1CaUpzmhULHmO2OkbecxCBZM1wwX6i0sltWWwjG9qkuyObhXwWrkBxor80zm1DqCGCIhI7ZG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770640038; c=relaxed/simple;
	bh=R0XvhfAKYcHs6dgpGEsQSG2TtxcA5rekL46uOWLHTDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kIIxCC0yldXbukdm801vLTb1smJsU7+Ib/fzQEhUrl4ZrLva5M2MnGYdqM/57Xbb7Ix3pyg6fiGNhrEu31//dzoLmzxkRWx3nAw0CiN33kkbSEN8ILhjq/seLEXsy48S/NVCjpHYtOtlk7kKhxpd6cG+ceLs4fV//3HfXTWw9X4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LgnGedJE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD7AAC19423;
	Mon,  9 Feb 2026 12:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770640038;
	bh=R0XvhfAKYcHs6dgpGEsQSG2TtxcA5rekL46uOWLHTDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LgnGedJEzrhkCRPt+1A6nopaMstDnvhF4qPHZyy8BEYeiK1oi5gkemiDXb5Scv09E
	 kSGKv+0pYcJVNoMvqVhQ1+V7IuOnzlLX0xxIUwJB1u3DNiM8IjwWBKNraHFCOFbYrR
	 ZVz95E2ASGJ1Ipwwovct2eQ+g4VjuYJ0PVVOJQ1oaWFdsEa7VyvkVDnpfLYtXdChy4
	 tNoKVH3hs9rd+MUUKLcMNjX2vRYwpiOCBLnz4UyQCViMOh40nxdVcLSjVpCI0QwE8q
	 jGb35pMSaA+vwa3TFMxXnMbe5xCtzTEE6yxU8NRZw6rcp586+mPcjfn6stT6GJu+W4
	 oo+AaxKjd04XA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	=?UTF-8?q?=E6=98=AF=E5=8F=82=E5=B7=AE?= <shicenci@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] io_uring/fdinfo: be a bit nicer when looping a lot of SQEs/CQEs
Date: Mon,  9 Feb 2026 07:26:41 -0500
Message-ID: <20260209122714.1037915-2-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260209122714.1037915-1-sashal@kernel.org>
References: <20260209122714.1037915-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.9
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12098-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[kernel.dk,gmail.com,kernel.org,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashal@kernel.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel.dk:email]
X-Rspamd-Queue-Id: 4944810EADB
X-Rspamd-Action: no action

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 38cfdd9dd279473a73814df9fd7e6e716951d361 ]

Add cond_resched() in those dump loops, just in case a lot of entries
are being dumped. And detect invalid CQ ring head/tail entries, to avoid
iterating more than what is necessary. Generally not an issue, but can be
if things like KASAN or other debugging metrics are enabled.

Reported-by: 是参差 <shicenci@gmail.com>
Link: https://lore.kernel.org/all/PS1PPF7E1D7501FE5631002D242DD89403FAB9BA@PS1PPF7E1D7501F.apcprd02.prod.outlook.com/
Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of io_uring/fdinfo: cond_resched() and CQ bounds fix

### Commit Message Analysis

The commit addresses two issues in `io_uring/fdinfo.c`:

1. **Adding `cond_resched()` calls** in SQE/CQE dump loops to avoid
   holding the CPU for too long when dumping many entries, particularly
   with debugging tools like KASAN enabled.
2. **Detecting invalid CQ ring head/tail entries** to avoid iterating
   more than necessary — this bounds the CQE loop to `ctx->cq_entries`
   maximum iterations.

There's a `Reported-by:` tag indicating a real user hit this issue, and
a `Link:` to the mailing list discussion. The patch is `Reviewed-by:
Keith Busch` and authored by `Jens Axboe` (io_uring maintainer).

### Code Change Analysis

Let me examine the changes in detail:

**Change 1: `cond_resched()` in SQE loop** (line after `seq_printf(m,
"\n")` in the SQE loop)
- This is a straightforward addition to yield the CPU during potentially
  long loops. The SQE loop already had bounded iteration (`sq_entries`
  was calculated earlier), but with KASAN or heavy debugging, each
  iteration can be slow. This prevents soft lockups.

**Change 2: Bounded CQE loop**
- Old code: `while (cq_head < cq_tail)` — this depends on userspace-
  controlled `cq_head` and `cq_tail` values (read with `READ_ONCE`). If
  these values are corrupted or malicious, `cq_tail - cq_head` could be
  enormous (up to `UINT_MAX`), causing an extremely long loop.
- New code: `cq_entries = min(cq_tail - cq_head, ctx->cq_entries)` and
  `for (i = 0; i < cq_entries; i++)` — this bounds the iteration to at
  most `ctx->cq_entries`, which is the actual ring size. This is a
  defensive bounds check.
- Also adds `cond_resched()` in the CQE loop.

**Change 3: CQE32 accounting fix**
- When CQE32 is detected (`cqe32 = true`), both `cq_head` and `i` are
  incremented, properly accounting for the double-sized CQE entry in the
  bounded loop.

### Bug Classification

This fixes two real problems:

1. **Soft lockup / scheduling latency issue**: Without `cond_resched()`,
   dumping many SQEs/CQEs (especially with KASAN) can cause the kernel
   to not schedule for a long time, triggering soft lockup warnings or
   causing system unresponsiveness. This is a **real bug** — reported by
   a user.

2. **Unbounded loop from userspace-controlled values**: The original CQE
   loop was bounded only by `cq_tail - cq_head`, which are userspace-
   written values. While in the normal case these are reasonable,
   corrupted or malicious values could cause an extremely long
   (potentially billions of iterations) loop in kernel context. This is
   both a **robustness fix** and a **potential DoS vector** (any process
   can read `/proc/<pid>/fdinfo/<fd>` for its own io_uring fds,
   triggering this loop).

### Scope and Risk Assessment

- **Size**: Very small — ~10 lines changed in a single file
- **Subsystem**: io_uring fdinfo (diagnostic/debug path, not hot path)
- **Risk**: Extremely low
  - `cond_resched()` is a standard kernel practice in long loops — zero
    regression risk
  - Bounding the CQE loop to `ctx->cq_entries` is obviously correct —
    the ring can't have more entries than its size
  - The CQE32 `i++` accounting is straightforward
- **Dependencies**: None apparent — this is a self-contained change to a
  single function

### User Impact

- **Who is affected**: Anyone using io_uring who reads fdinfo
  (monitoring tools, debuggers, diagnostic scripts)
- **Severity**: Soft lockups and system unresponsiveness — moderate to
  high severity
- **Reproducibility**: Reported by a real user with a concrete scenario
  (KASAN-enabled kernel with many ring entries)

### Stability Indicators

- Written by Jens Axboe (io_uring maintainer)
- Reviewed by Keith Busch (known kernel developer)
- Small, obviously correct change
- Fixes a user-reported issue

### Conclusion

This commit fixes:
1. A real soft lockup / scheduling latency bug (cond_resched in loops)
2. A potential unbounded loop from userspace-controlled values (CQE
   bounds check)

Both are genuine bugs that affect real users. The fix is small,
obviously correct, self-contained, and carries virtually zero regression
risk. It meets all stable kernel criteria: it fixes a real bug, is small
and contained, is obviously correct, and doesn't introduce new features.

**YES**

 io_uring/fdinfo.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index 294c75a8a3bdb..3585ad8308504 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -65,7 +65,7 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 	unsigned int cq_head = READ_ONCE(r->cq.head);
 	unsigned int cq_tail = READ_ONCE(r->cq.tail);
 	unsigned int sq_shift = 0;
-	unsigned int sq_entries;
+	unsigned int cq_entries, sq_entries;
 	int sq_pid = -1, sq_cpu = -1;
 	u64 sq_total_time = 0, sq_work_time = 0;
 	unsigned int i;
@@ -119,9 +119,11 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 			}
 		}
 		seq_printf(m, "\n");
+		cond_resched();
 	}
 	seq_printf(m, "CQEs:\t%u\n", cq_tail - cq_head);
-	while (cq_head < cq_tail) {
+	cq_entries = min(cq_tail - cq_head, ctx->cq_entries);
+	for (i = 0; i < cq_entries; i++) {
 		struct io_uring_cqe *cqe;
 		bool cqe32 = false;
 
@@ -136,8 +138,11 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 					cqe->big_cqe[0], cqe->big_cqe[1]);
 		seq_printf(m, "\n");
 		cq_head++;
-		if (cqe32)
+		if (cqe32) {
 			cq_head++;
+			i++;
+		}
+		cond_resched();
 	}
 
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
-- 
2.51.0


