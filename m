Return-Path: <io-uring+bounces-9953-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 91F57BCA116
	for <lists+io-uring@lfdr.de>; Thu, 09 Oct 2025 18:14:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id AED365407A7
	for <lists+io-uring@lfdr.de>; Thu,  9 Oct 2025 16:08:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D15E1231A32;
	Thu,  9 Oct 2025 16:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NIdBIz28"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA9323182D;
	Thu,  9 Oct 2025 16:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025626; cv=none; b=VnnhTstTY3tSP3vq0KQZS3kP54nwPh8w3IBHCmSG9B3FsJwyeL7XurDC2qMfVCsGRCtRc4j1AliDURirmtEA+efFRgedQhFiTUiZ6TJMY0ZtUwRG+EjNt3VCrW7djl29hC3lYIUL3GhbEnA2NP+yrJ1Q+LV2kK6cahLT10kJERM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025626; c=relaxed/simple;
	bh=tol1Lzpu1ynH/9sB3f0X+WEeyE8inhNzGB9PhAsD4F8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ulv8+nOCP5w/uKXIRrtrH/2pvgj3ugbBGbGhzfnJf1jjy/K84RFQBYbmRGgdb3cbElXarFYl6uAMBc0Q3qKa07G7GvYIxlCHPBJNaM8sbE6VDTdzbfEbAwVYDcmSVw3Zg0Mn/N18qKiutrqZ3u+K1qqfddUxjlIqqrdWMOF/+ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NIdBIz28; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F1AC4CEF8;
	Thu,  9 Oct 2025 16:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025626;
	bh=tol1Lzpu1ynH/9sB3f0X+WEeyE8inhNzGB9PhAsD4F8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NIdBIz288E2bSfcO9o9OStd4kW+PQ/COSb9I8VbO+wD8njfglCZJqEMaA8XaKtDYb
	 2yDaNqaNRMjOZ30v6Qam9Me8cqG0LKpUHXCyTkTnJIKFXDIKw9gb4T9L7+4XljvyE9
	 4ziwqgbBIa1wddoqVjetWSrDbFTXLqHgs/Jo3Tb28LzdY+20dAp0beElhX3EsNpzk3
	 5QGB/zBDS9O2s8EwIcIu2f+QNv4oat71+EfrgJJInxpKuSQMpL4kwKd+nqAoSBvfFJ
	 0EcXKxieQwqawyKM/8W/hbETkEA5jChlkEROvYrdb3z9+Wh1awiKuK2u6+MgnM4yJr
	 brYQ4Q5wbwFOA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.16] io_uring/zcrx: account niov arrays to cgroup
Date: Thu,  9 Oct 2025 11:55:47 -0400
Message-ID: <20251009155752.773732-81-sashal@kernel.org>
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

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 31bf77dcc3810e08bcc7d15470e92cdfffb7f7f1 ]

net_iov / freelist / etc. arrays can be quite long, make sure they're
accounted.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it does: Switches three kvmalloc_array() allocations used by
  io_uring zcrx areas from GFP_KERNEL to GFP_KERNEL_ACCOUNT so their
  memory is charged to the creating task’s memcg. Specifically:
  - `area->nia.niovs` allocation: io_uring/zcrx.c:425
  - `area->freelist` allocation: io_uring/zcrx.c:430
  - `area->user_refs` allocation: io_uring/zcrx.c:435

Why it matters
- Fixes unaccounted kernel memory: These arrays can be very large (one
  entry per page of the registered area). Without GFP_KERNEL_ACCOUNT, a
  cgroup can allocate significant kernel memory that is not charged to
  its memcg, breaking containment and potentially causing host memory
  pressure. The commit explicitly addresses this: “arrays can be quite
  long, make sure they're accounted.”
- Brings consistency with existing accounting in the same path: The user
  memory backing the area is already accounted to memcg via
  `sg_alloc_table_from_pages(..., GFP_KERNEL_ACCOUNT)`
  (io_uring/zcrx.c:196) and to the io_uring context via
  `io_account_mem()` (io_uring/zcrx.c:205). Accounting these control
  arrays aligns with that design and closes a loophole where only the
  big page backing was charged but the (potentially multi‑MiB) array
  metadata was not.
- Scope is tiny and contained: The change is three flag substitutions
  within `io_zcrx_create_area()` and has no API/ABI or behavioral
  changes beyond proper memcg charging. No architectural changes; hot
  paths are unaffected (this is registration-time allocation).

Risk assessment
- Low regression risk: Uses a long-standing flag (`GFP_KERNEL_ACCOUNT`)
  already used in this file for the data path (io_uring/zcrx.c:196). The
  only behavioral change is that allocations will now fail earlier with
  `-ENOMEM` if a cgroup’s limits would be exceeded—this is the desired
  and correct behavior for accounting fixes.
- No ordering dependencies: The patch doesn’t rely on recent refactors;
  the affected allocations exist in v6.15–v6.17 and are currently done
  with `GFP_KERNEL`. The change applies cleanly to those stable series
  where `io_uring/zcrx.c` is present.

Stable tree fit
- Fixes a real bug affecting users: memcg under-accounting in a new but
  shipped subsystem (zcrx is present since v6.15).
- Minimal, localized, and low risk: Three flag changes in one function.
- No feature additions or architectural changes: Pure accounting fix.
- Consistent with stable policy: Similar accounting fixes are regularly
  accepted; related earlier work in this area explicitly targeted stable
  (e.g., “io_uring/zcrx: account area memory” carries a `Cc:
  stable@vger.kernel.org`, complementing this change).

Conclusion
- Backporting will prevent unaccounted kernel memory growth from zcrx
  area metadata, aligning with memcg expectations and improving
  containment with negligible risk.

 io_uring/zcrx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 39d1ef52a57b1..5928544cd1687 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -426,17 +426,17 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 
 	ret = -ENOMEM;
 	area->nia.niovs = kvmalloc_array(nr_iovs, sizeof(area->nia.niovs[0]),
-					 GFP_KERNEL | __GFP_ZERO);
+					 GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 	if (!area->nia.niovs)
 		goto err;
 
 	area->freelist = kvmalloc_array(nr_iovs, sizeof(area->freelist[0]),
-					GFP_KERNEL | __GFP_ZERO);
+					GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 	if (!area->freelist)
 		goto err;
 
 	area->user_refs = kvmalloc_array(nr_iovs, sizeof(area->user_refs[0]),
-					GFP_KERNEL | __GFP_ZERO);
+					GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 	if (!area->user_refs)
 		goto err;
 
-- 
2.51.0


