Return-Path: <io-uring+bounces-9950-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id BA56CBC9EEF
	for <lists+io-uring@lfdr.de>; Thu, 09 Oct 2025 18:04:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 7CE65354613
	for <lists+io-uring@lfdr.de>; Thu,  9 Oct 2025 16:04:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94ED422156B;
	Thu,  9 Oct 2025 15:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J4VNjWut"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691B82EE268;
	Thu,  9 Oct 2025 15:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025502; cv=none; b=qUuhJWw0nAcKHOy89gUL1y58eIvOD47FI6mQDXxvMrM6JBSa6ApJvWOxEElDBQETd24kGl/mUISHqPlTMz7BL3kpxaCzjltsZiiNTOH3XI7wiH31LxGqIcVuuGZP7wQDXaAiCUt26AT5xXoYnjvKl4vTtGX6uydmQ2j805JF5Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025502; c=relaxed/simple;
	bh=T/TurCfU7HrCKYwaC22oBvp+MF8aLTYkfccFjFy4EOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k8fFtFfLcCzzON/xWt3AlQIakWQQHWNBK4i/TqYohODhEcelQi12ILMuoo8e9FeKsVbzlOG5FEXw0yjDTMxJUCoC/7++hveweGRvRxcHyzCNGKoSTalbqtRWW8JTIeiGjeUIgkxd1XRw6yCsmJ/sWV+IsngNEw2soONiWhYUun0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J4VNjWut; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91CADC4CEE7;
	Thu,  9 Oct 2025 15:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025502;
	bh=T/TurCfU7HrCKYwaC22oBvp+MF8aLTYkfccFjFy4EOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J4VNjWut/qzdbHPYc8Lnz2xY8tC/KOMtFTnRvBIjwYbnZs6o0naSxdCLQLkgmWjEd
	 pnKcypTDzHTs/xecN8mTguPtaXtber4k63LsyWn+6eEDuXegmgRBkh5hY6JmL/AOI8
	 dWvZVsFBl6LFQ/BQeTkt/dF18u34ZfcJK5MyQjv3JTAEHODV98nxPUEqrlCTl5DqwK
	 aE6Z1vDJ6lu/wnHHKSoE320BNc9wQgT0VCF4bzyHbTeWp0ox2FzszYIv/VMQrUD0Tf
	 +d/1qNRPrVVgdMBLMhmqdtKtHWnutKpEe6bGdJ66LrD+GXQLn5947ucXbDoC7cf5pl
	 O2QSyK0++x0Jg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17] io_uring/zcrx: check all niovs filled with dma addresses
Date: Thu,  9 Oct 2025 11:54:47 -0400
Message-ID: <20251009155752.773732-21-sashal@kernel.org>
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

[ Upstream commit d7ae46b454eb05e3df0d46c2ac9c61416a4d9057 ]

Add a warning if io_populate_area_dma() can't fill in all net_iovs, it
should never happen.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it changes
  - Adds a post-loop invariant check in `io_populate_area_dma()` to
    ensure every `net_iov` in the area got a valid DMA address. If not,
    it emits a one-time warning and fails the mapping with `-EFAULT`:
    - New logic: “if not all niovs filled → WARN_ON_ONCE + return
      -EFAULT”
    - Before: the function always returned 0 even if it didn’t populate
      all niovs.
  - This is a small, localized change to `io_uring/zcrx.c` that does not
    alter APIs or structures and only affects the zcrx receive path.

- Why it matters (bug/risk being fixed)
  - Today, `io_populate_area_dma()` returns success unconditionally
    after walking the SG table, even if fewer DMA addresses were written
    than `area->nia.num_niovs`. See unconditional return in
    `io_uring/zcrx.c:78`.
  - On success, `io_zcrx_map_area()` marks the area as mapped (sets
    `area->is_mapped = true`), which enables the page_pool memory
    provider to start using these entries, assuming per-`net_iov` DMA
    addresses are valid:
    - `io_uring/zcrx.c:277` and `io_uring/zcrx.c:290-293`
    - DMA addresses are later consumed in sync paths (e.g.,
      `io_zcrx_sync_for_device()`), which fetches them via
      `page_pool_get_dma_addr_netmem()`: `io_uring/zcrx.c:304-306`.
  - If some `net_iov`s remained uninitialized (DMA address 0 or stale),
    the NIC could be programmed with an invalid DMA address. That is a
    correctness and potential security issue (device DMA to the wrong
    address). The new check prevents entering that state by failing
    early instead of silently accepting a partially-initialized mapping.

- Context and call sites
  - `io_populate_area_dma()` is used by both umem and dmabuf mappings:
    - dmabuf mapping calls into `io_populate_area_dma()` at
      `io_uring/zcrx.c:159-161`. Upstream already validates the SG total
      size matches the area length (`io_uring/zcrx.c:139-146`), but the
      new invariant check still hardens against any mismatch in the
      subsequent per-page DMA population loop.
    - umem mapping path invokes it after `dma_map_sgtable()`:
      `io_uring/zcrx.c:270-275`.
  - On error, both paths propagate the error, and `io_zcrx_map_area()`
    will not set `area->is_mapped = true` (`io_uring/zcrx.c:290-293`),
    preventing the page_pool consumer from using invalid entries. This
    aligns with other existing error checks in the function (e.g.,
    `net_mp_niov_set_dma_addr()` failure returns `-EFAULT` already at
    `io_uring/zcrx.c:71-72`).

- Stable backport criteria assessment
  - Fixes a real bug class (silent partial initialization of DMA
    addresses) that can lead to invalid device DMA targets. Even if the
    author says it “should never happen,” enforcing the invariant
    eliminates a dangerous failure mode rather than allowing undefined
    behavior.
  - Change is small and tightly scoped to zcrx; it adds one WARN_ON_ONCE
    and a conditional `-EFAULT` return. No interface, ABI, or
    architectural changes.
  - Callers already handle negative returns and will abort mapping
    cleanly, so regression risk is minimal and clearly bounded to
    failing early when an invariant is violated.
  - No new features; pure correctness/hardening.
  - Touches io_uring zcrx, not core scheduling or memory subsystems;
    impact is contained.

- Additional code references supporting the assessment
  - Unconditional success today: `io_uring/zcrx.c:52-79` (function body,
    unconditional `return 0` at `io_uring/zcrx.c:78`).
  - Caller sets `is_mapped` only on success: `io_uring/zcrx.c:277-293`.
  - DMA address is used later for device sync:
    `io_uring/zcrx.c:304-306`.
  - dmabuf SG size checked already: `io_uring/zcrx.c:139-146`.

Conclusion: This is a low-risk, correctness hardening that prevents a
silent and potentially serious failure mode. It satisfies stable rules
for a minimal, contained bugfix. Backport to stable trees that include
`io_uring/zcrx` and `io_populate_area_dma()` is advisable.

 io_uring/zcrx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index e5ff49f3425e0..39d1ef52a57b1 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -75,6 +75,9 @@ static int io_populate_area_dma(struct io_zcrx_ifq *ifq,
 			niov_idx++;
 		}
 	}
+
+	if (WARN_ON_ONCE(niov_idx != area->nia.num_niovs))
+		return -EFAULT;
 	return 0;
 }
 
-- 
2.51.0


