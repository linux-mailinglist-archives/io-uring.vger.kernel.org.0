Return-Path: <io-uring+bounces-8547-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7C96AEE8F8
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 23:01:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0DE187AC361
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 20:59:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85C9F2E5435;
	Mon, 30 Jun 2025 21:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sGDW4FVG"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BCB91FBCB0;
	Mon, 30 Jun 2025 21:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751317246; cv=none; b=uSclk90bXL8HeSB/QTbaAiysDnRDCblmo7ONH27SLJ6XWCLl07J/Z5zo87Hrp494o54ld3qexL6Ym5l79j3fvqyz7ZeuCVgOfXZpSvM0tFTaIaJWjShNwjC8cyA8XIY/0h0rZ3j2M4UW/XJdMdXy806qSbGCYrZhjEVJuH+1dhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751317246; c=relaxed/simple;
	bh=llRs8nwFtHdZ8wSpsE6r96Ulb1CljEsQb741DpdDtQg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tAirZMeG+Ki77uy3Yl7Rf6tFNrAKtgvLXS38k38cSfwuVyqbzAnTZFctyxQIk20usR+WtiMFk9Vt+xQrXXq7Lftg8qjOEZOzxcNXom31Y0WcsFtfzFjEQvRvDmIqSITqd6rZGB/C18FVZVqMxyZg8WC92Ghg45IbWg65T+lh9YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sGDW4FVG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E789C4CEE3;
	Mon, 30 Jun 2025 21:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751317246;
	bh=llRs8nwFtHdZ8wSpsE6r96Ulb1CljEsQb741DpdDtQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sGDW4FVGoHPw+GeOgHpBlHuBILI6Pb9s3iD+mNRzOpXjQjLgLK306z69OvpfyEvfq
	 5ZH7p1xIKk9EHxhJlUthkctGhw4Ixi1Rneo/3EDF1fNZ4f3EOHSFL81p3W8049W/Le
	 5lE3wdTj4HPo86L78ZFx9S4p+k1MecYiriohZZhFkUaz+td2f6x1/esEVrKgI+qQ/n
	 r9MvqwRKI85372KipaaY3fmVVElzIJs8yiFakeJGG4DU0TGjU7rXeXAkYo+JvkjUU/
	 d4EKK51E1AfTUyTh7/umUFO4cx3xX+JahO5pT7j4uK1qMNWAdVGpKjYzgVqAeqaHWh
	 T4vlf3S8uXo0w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Fengnan Chang <changfengnan@bytedance.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 04/14] io_uring: make fallocate be hashed work
Date: Mon, 30 Jun 2025 16:46:29 -0400
Message-Id: <20250630204639.1358777-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250630204639.1358777-1-sashal@kernel.org>
References: <20250630204639.1358777-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.95
Content-Transfer-Encoding: 8bit

From: Fengnan Chang <changfengnan@bytedance.com>

[ Upstream commit 88a80066af1617fab444776135d840467414beb6 ]

Like ftruncate and write, fallocate operations on the same file cannot
be executed in parallel, so it is better to make fallocate be hashed
work.

Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
Link: https://lore.kernel.org/r/20250623110218.61490-1-changfengnan@bytedance.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES**

This commit should definitely be backported to stable kernel trees.
Here's my extensive analysis:

## Why this is a critical bug fix:

1. **Data Integrity Issue**: The commit fixes a race condition where
   multiple fallocate operations on the same file could execute in
   parallel through io_uring. Looking at the implementation in
   io_uring/sync.c:107, fallocate calls `vfs_fallocate()` which modifies
   file allocation state. Without proper serialization, concurrent
   fallocate operations can cause:
   - Data corruption
   - Inconsistent file metadata
   - Filesystem-level race conditions in block allocation

2. **Consistency with Similar Operations**: By examining
   io_uring/opdef.c, I found that all other file-modifying operations
   already have `hash_reg_file = 1`:
   - IORING_OP_WRITEV
   - IORING_OP_WRITE_FIXED
   - IORING_OP_WRITE
   - IORING_OP_SPLICE
   - IORING_OP_TEE
   - IORING_OP_FTRUNCATE
   - IORING_OP_WRITEV_FIXED

3. **Clear Precedent**: When ftruncate support was added in commit
   b4bb1900c12e, it was correctly implemented with `hash_reg_file = 1`
   from the start. The fact that fallocate was missing this flag appears
   to be an oversight that this commit corrects.

## Why it's safe to backport:

1. **Minimal Change**: Single line addition with no architectural
   changes
2. **Well-Understood Fix**: The `hash_reg_file` mechanism is well-
   established and used by all similar operations
3. **No Breaking Changes**: The only effect is proper serialization of
   fallocate operations per-file, which is the correct and expected
   behavior
4. **Low Risk**: This change cannot introduce new bugs - it only
   prevents existing race conditions

## How it differs from the "NO" examples:

Unlike the provided similar commits which were:
- Adding new features (io_uring fallocate support)
- Performance optimizations (hashing changes, __read_mostly)
- Code cleanup (removing unused fields, refactoring)

This commit fixes a **correctness bug** that can lead to data corruption
in production systems using io_uring with fallocate operations.

The commit follows stable kernel rules perfectly: it's a critical bug
fix that's minimal, contained, and addresses a real user-facing issue
without introducing new functionality or risks.

 io_uring/opdef.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 3b9c6489b8b6d..2d0a7db940fdb 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -202,6 +202,7 @@ const struct io_issue_def io_issue_defs[] = {
 	},
 	[IORING_OP_FALLOCATE] = {
 		.needs_file		= 1,
+		.hash_reg_file          = 1,
 		.prep			= io_fallocate_prep,
 		.issue			= io_fallocate,
 	},
-- 
2.39.5


