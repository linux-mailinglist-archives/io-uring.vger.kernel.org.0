Return-Path: <io-uring+bounces-10255-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C9246C12386
	for <lists+io-uring@lfdr.de>; Tue, 28 Oct 2025 01:43:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D6F88581B08
	for <lists+io-uring@lfdr.de>; Tue, 28 Oct 2025 00:40:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFF7820E03F;
	Tue, 28 Oct 2025 00:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DjiEPEuc"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C650D1FFC48;
	Tue, 28 Oct 2025 00:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761612009; cv=none; b=qjRRvwqL7USjpHo9WRgbvXPbd1nW4/Azss2nK4pMjG+uzPSQtCCz9TW1moOO73ldvIuGvIou6KK9FuW9XveITyxCScX6+Osl0ulJLjwCa5zFxeN4GaFrOaVVIM++WsQVLstPsGlHBPbDXo4ypZG7oSdoyp4WOHA4jPvPfwQMof0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761612009; c=relaxed/simple;
	bh=edUwAFdSyOAfW4FvJV/A4OL3kdaGpdecyDHhbeApj6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PZqrIL3j6ZTtbUQHrXSOOKwx7S61sQ8FIg2aJMBvhJAzYmeLfxJA0GMjg+61JXIoYF0ZNmaQbv2EWs3KwJyn2C0kt/vjZTAumLBg59h+c/fXMYSokjp7ibiZ5+e2vO+G/CmCd/QtGALjF+OAONBkbQSqb9JLGy00lxnmtTByeWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DjiEPEuc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECEA1C4CEF1;
	Tue, 28 Oct 2025 00:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761612009;
	bh=edUwAFdSyOAfW4FvJV/A4OL3kdaGpdecyDHhbeApj6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DjiEPEucq1PKsNb3Ndya6c7KxbGdoc4yyCA1R9G/UCE/2Eg4UG3vDNWAD/qOPpz0S
	 iFIHVpC8s8hMfb1EYkgYoycm6X2Owa68knXx7k9tdpfR30sHIAQnJVn8GuAqKI/O1M
	 XihI6NmbajC5UtShvsNPnNLpPRAI6kFvpJsckI781Euj/R5X5oq/g/EUjKkNxnuYH5
	 P3Xof/+xGMD2jA0uyBjJQhWYyf74qDNcCyiW7d5UcUJHYfkXsX3dbbe4bXGwZukuD0
	 t/+sgO8+LXbwoPLP5UlnfLF+vNjxCuwzp43f/ZbCzuD6czr2Epl4sDtMZyhFbCwKbM
	 L0BHz6WtGg7hg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17] io_uring: fix unexpected placement on same size resizing
Date: Mon, 27 Oct 2025 20:38:57 -0400
Message-ID: <20251028003940.884625-13-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251028003940.884625-1-sashal@kernel.org>
References: <20251028003940.884625-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 437c23357d897f5b5b7d297c477da44b56654d46 ]

There might be many reasons why a user is resizing a ring, e.g. moving
to huge pages or for some memory compaction using IORING_SETUP_NO_MMAP.
Don't bypass resizing, the user will definitely be surprised seeing 0
while the rings weren't actually moved to a new place.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## BACKPORT RECOMMENDATION: **YES**

### DETAILED ANALYSIS

#### 1. Semantic Code Analysis Performed

**Tools Used:**
- `mcp__semcode__find_function`: Located `io_register_resize_rings`
  function definition in `io_uring/register.c:401-585`
- `mcp__semcode__find_callers`: Identified that the function is called
  by `__io_uring_register`
- Git analysis: Traced the syscall path from user-space →
  `sys_io_uring_register` → `__io_uring_register` →
  `io_register_resize_rings`
- Historical analysis: Determined the resize feature was introduced in
  kernel v6.13 (October 2024)

**Call Graph Analysis:**
```
user-space (io_uring_register syscall with IORING_REGISTER_RESIZE_RINGS
opcode)
  └→ sys_io_uring_register (SYSCALL_DEFINE4)
      └→ __io_uring_register
          └→ io_register_resize_rings  [BUG HERE]
```

#### 2. Nature of the Bug

**What Changed:**
The commit removes 7 lines of code (io_uring/register.c:421-427) that
implemented an optimization:
```c
/* nothing to do, but copy params back */
if (p.sq_entries == ctx->sq_entries && p.cq_entries == ctx->cq_entries)
{
    if (copy_to_user(arg, &p, sizeof(p)))
        return -EFAULT;
    return 0;  // Returns success WITHOUT actually resizing
}
```

**Why It's a Bug:**
This optimization incorrectly assumes that if the ring size parameters
match, there's nothing to do. However, users have legitimate reasons to
resize with the same dimensions:

1. **Memory relocation to huge pages**: Using `IORING_SETUP_NO_MMAP`
   flag to move rings to huge page-backed memory for better TLB
   performance
2. **Memory compaction**: Consolidating memory allocations
3. **Memory region changes**: Moving rings to different physical memory
   locations

The kernel returns success (0) but silently doesn't perform the
requested operation, breaking the user-space API contract.

#### 3. Impact Assessment

**Severity: Medium**

**Who is affected:**
- Applications using `IORING_REGISTER_RESIZE_RINGS` (added in v6.13)
- Specific scenario: Resizing to same dimensions for memory management
  purposes
- Use cases: Performance-critical applications optimizing memory layout
  via huge pages

**User-space exposure:**
- **Directly exposed via syscall**: Yes, through `io_uring_register(fd,
  IORING_REGISTER_RESIZE_RINGS, ...)`
- **Exploitability**: Not a security issue, but causes silent functional
  failure
- **Data corruption risk**: None, but causes application logic bugs when
  applications expect memory to be reallocated

#### 4. Backport Suitability Analysis

**Positive Indicators:**
1. ✅ **Bug fix, not a feature**: Removes broken optimization
2. ✅ **Small, contained change**: Only 7 lines removed, no new code
   added
3. ✅ **No architectural changes**: Doesn't modify data structures or
   APIs
4. ✅ **Low regression risk**: Removes code rather than adding complex
   logic
5. ✅ **Clear functional issue**: Kernel claims success but doesn't
   perform requested operation
6. ✅ **Affects real use cases**: Huge page optimization is documented in
   commit message as legitimate use case

**Context:**
- Feature introduced: v6.13 (October 2024)
- Bug exists: v6.13 through v6.17
- Fix landed: v6.18-rc2
- No explicit `Fixes:` or `Cc: stable` tags in the commit (oversight by
  author)

**Stable Tree Compliance:**
- Bug fixes: ✅ YES
- New features: ✅ NO
- Security fixes: ✅ NO (but functional correctness issue)
- Performance optimizations: ⚠️ Removes a broken optimization
- Architectural changes: ✅ NO

#### 5. Dependencies and Prerequisites

The fix requires:
- `IORING_REGISTER_RESIZE_RINGS` support (present in v6.13+)
- No other dependencies identified

**Version compatibility:** This should be backported to stable kernels
v6.13+

#### 6. Risk Assessment

**Regression risk: VERY LOW**

The change **removes** code rather than adding it:
- The removed code was an optimization that caused incorrect behavior
- Removing it makes the function always perform the full resize
  operation
- All existing code paths after the removed check remain unchanged
- The function already handles the case where source and destination
  sizes match (it copies entries correctly)

**Testing considerations:**
- Test case: Call `IORING_REGISTER_RESIZE_RINGS` with same size +
  `IORING_SETUP_NO_MMAP` flag
- Expected: Memory should be reallocated to new location
- Current broken behavior: Returns 0 but doesn't reallocate

### CONCLUSION

**BACKPORT: YES to stable v6.13+ kernels**

This is a clear functional bug in a newly added feature. While it lacks
explicit stable tree tags, it meets all criteria for backporting:
- Fixes incorrect behavior exposed to user-space
- Small, contained, low-risk change
- Affects legitimate use cases (huge page optimization)
- No dependencies or architectural complexity
- Removes broken code rather than adding risky new logic

The absence of `Fixes:` or `Cc: stable` tags appears to be an oversight,
not an indication that backporting is inappropriate. The commit message
explicitly describes the bug and its user-space impact, making this a
suitable candidate for stable tree inclusion.

 io_uring/register.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/io_uring/register.c b/io_uring/register.c
index b1772a470bf6e..dacbe8596b5c2 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -426,13 +426,6 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	if (unlikely(ret))
 		return ret;
 
-	/* nothing to do, but copy params back */
-	if (p.sq_entries == ctx->sq_entries && p.cq_entries == ctx->cq_entries) {
-		if (copy_to_user(arg, &p, sizeof(p)))
-			return -EFAULT;
-		return 0;
-	}
-
 	size = rings_size(p.flags, p.sq_entries, p.cq_entries,
 				&sq_array_offset);
 	if (size == SIZE_MAX)
-- 
2.51.0


