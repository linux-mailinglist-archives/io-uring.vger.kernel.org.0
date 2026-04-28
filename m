Return-Path: <io-uring+bounces-13156-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kKmyGBGV8GnnVAEAu9opvQ
	(envelope-from <io-uring+bounces-13156-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2026 13:08:01 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5690A48351E
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2026 13:08:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 3ADF1306821F
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2026 10:54:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30EFA428482;
	Tue, 28 Apr 2026 10:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ohZJuErC"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD573F7AAD;
	Tue, 28 Apr 2026 10:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372999; cv=none; b=c7guop2LIAghQZQBFSnfuR6TdrBE7FMIxIX76iLUKct4fl2Voe7fDblnfelnKmAt7B18IbeL/wvvAXqGUQ8K5+vVAnS2+0/H30AC5UJIVzHeEIhxYy5tE13IWghi6KunDRO/XRHf9enjiq9rMdQbO3UBHla2zT+0H/63boIW57w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372999; c=relaxed/simple;
	bh=QzYB4IcFIQ/MbIQp2AivCXb6FL5UEyxUBaMoqLaujrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hi3pya/n5Y0tBJbJpytdD9jlBd9/DeVVlVcqumVQfn1uA5DL05IdNAx2LFSP68evyWjANlj5C/y2Q4EaRxmB0yU2aRWu2HNjF40n+Azv/keMqOvLq8/UoZsbT4fQnhAfBradbAWbqZkEx6DKF6q5hpwSFkcFRUEOAXEbP/pNFpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ohZJuErC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB4F8C2BCB8;
	Tue, 28 Apr 2026 10:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372998;
	bh=QzYB4IcFIQ/MbIQp2AivCXb6FL5UEyxUBaMoqLaujrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ohZJuErCgaVIP/9pIAghWtDgiQxsayJFghfdiuXV68ASzVAO6TIe5umkw8uvTMTlF
	 LAKl2WfyzOBeI9yuMKQvHf81aFM/FOH0EHA8KFXQ38GrSNfAdYbAOrQY3qL+TtiKW2
	 Hr1XiY6dnMWpMN+erUY/7C1v+YXiM29FdKCMLMMQ1cM5qh9GS7Cx6nvAboM3Yy6UHl
	 /TT+0UJgLW8scokIurcRBcAxu8emJUkSwiCxNzvxI3YHoe+CqlgrgiMAaSbn73WMJX
	 sUP+7fvVszzX/OL9cadD3p1bwRI3zxxnjdMNwtx58EfjUrIlAsDCxTmitp49ukSdpl
	 Oosds50koxrjg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.12] io_uring: take page references for NOMMU pbuf_ring mmaps
Date: Tue, 28 Apr 2026 06:41:24 -0400
Message-ID: <20260428104133.2858589-73-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428104133.2858589-1-sashal@kernel.org>
References: <20260428104133.2858589-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5690A48351E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13156-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashal@kernel.org,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linuxfoundation.org:email,msgid.link:url,run-poc.sh:url,kernel.dk:email,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit d0be8884f56b0b800cd8966e37ce23417cd5044e ]

Under !CONFIG_MMU, io_uring_get_unmapped_area() returns the kernel
virtual address of the io_mapped_region's backing pages directly;
the user's VMA aliases the kernel allocation. io_uring_mmap() then
just returns 0 -- it takes no page references.

The CONFIG_MMU path uses vm_insert_pages(), which takes a reference on
each inserted page.  Those references are released when the VMA is torn
down (zap_pte_range -> put_page). io_free_region() -> release_pages()
drops the io_uring-side references, but the pages survive until munmap
drops the VMA-side references.

Under NOMMU there are no VMA-side references. io_unregister_pbuf_ring ->
io_put_bl -> io_free_region -> release_pages drops the only references
and the pages return to the buddy allocator while the user's VMA still
has vm_start pointing into them.  The user can then write into whatever
the allocator hands out next.

Mirror the MMU lifetime: take get_page references in io_uring_mmap() and
release them via vm_ops->close.  NOMMU's delete_vma() calls vma_close()
which runs ->close on munmap.

This also incidentally addresses the duplicate-vm_start case: two mmaps
of SQ_RING and CQ_RING resolve to the same ctx->ring_region pointer.
With page refs taken per mmap, the second mmap takes its own refs and
the pages survive until both mmaps are closed.  The nommu rb-tree BUG_ON
on duplicate vm_start is a separate mm/nommu.c concern (it should share
the existing region rather than BUG), but the page lifetime is now
correct.

Cc: Jens Axboe <axboe@kernel.dk>
Reported-by: Anthropic
Assisted-by: gkh_clanker_t1000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/2026042115-body-attention-d15b@gregkh
[axboe: get rid of region lookup, just iterate pages in vma]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Analysis: io_uring NOMMU pbuf_ring page UAF fix

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 - Subject line:**
Record: subsystem `io_uring`, action verb `take`, summary: "take page
references for NOMMU pbuf_ring mmaps" — wraps a fix for a page lifetime
/ use-after-free issue under `!CONFIG_MMU`.

**Step 1.2 - Tags:**
Record:
- `Cc: Jens Axboe <axboe@kernel.dk>`
- `Reported-by: Anthropic` (AI bug report)
- `Assisted-by: gkh_clanker_t1000` (an unusual tag — verified this is
  identical to upstream commit `d0be8884f56b0`, not pipeline-injected)
- `Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>`
  (author SOB, kernel veteran)
- `Link: https://patch.msgid.link/2026042115-body-attention-d15b@gregkh`
- `[axboe: get rid of region lookup, just iterate pages in vma]`
  (maintainer-folded change)
- `Signed-off-by: Jens Axboe <axboe@kernel.dk>` (subsystem maintainer)
No `Cc: stable` or `Fixes:` — expected.

**Step 1.3 - Body text:**
Record: Author explains a use-after-free root cause precisely:
- NOMMU `io_uring_get_unmapped_area()` returns a kernel virtual address;
  user VMA aliases the kernel pages.
- `io_uring_mmap()` returns 0 without taking page references.
- `io_unregister_pbuf_ring -> io_put_bl -> io_free_region ->
  release_pages` drops the only reference; pages return to the buddy
  allocator while the user's VMA still maps them.
- "The user can then write into whatever the allocator hands out next."
  — this is a write-after-free.
- Fix mirrors MMU lifetime by `get_page` per page in `mmap()` and
  `put_page` via `vm_ops->close`.
- Also addresses the duplicate-vm_start case for SQ/CQ.

**Step 1.4 - Hidden bug fix?**
Record: Not hidden — the commit body explicitly describes a use-after-
free / write-after-free of pages handed to userspace, which is a serious
memory-safety / security bug.

## PHASE 2: DIFF ANALYSIS

**Step 2.1 - Inventory:**
Record: 1 file changed (`io_uring/memmap.c`); +44 lines, -1 line. Adds
`io_uring_nommu_vm_close()`, `io_uring_nommu_vm_ops`, expands
`io_uring_mmap()` (`!CONFIG_MMU` branch). Single-file, surgical NOMMU-
only change.

**Step 2.2 - Code flow change:**
Before: `io_uring_mmap()` for NOMMU only validated flags; returned 0
with no page references taken.
After: validates flags, looks up the region under `ctx->mmap_lock`,
validates region is set and the VMA size matches `region->nr_pages`,
takes a `get_page()` per backing page, and installs `vm_ops->close` to
drop those references at unmap.

**Step 2.3 - Bug mechanism:**
Record: Use-after-free / write-after-free of kernel pages still mapped
in userspace. Category: memory safety + reference counting (missing
`get_page` on the mmap path that aliases kernel allocations). The fix
balances the lifetime by adding `get_page()` on map and `put_page()` on
close.

**Step 2.4 - Fix quality:**
Record: Small, contained. Logic is straightforward: per-page `get_page`
on map, mirrored `put_page` on close. The validation that `vma->vm_end -
vma->vm_start == region->nr_pages << PAGE_SHIFT` guards the close-time
`virt_to_page` walk over the VMA address range. Risk that
`vma->vm_start` no longer points to those pages is addressed by holding
the page references — the kernel virtual address remains valid as long
as the page is alive. Fix is obviously correct for the NOMMU case
described.

## PHASE 3: GIT HISTORY

**Step 3.1 - Blame:**
Record: The vulnerable line `return
is_nommu_shared_mapping(vma->vm_flags) ? 0 : -EINVAL;` has been present
in NOMMU `io_uring_mmap()` since `f15ed8b4d0ce2 io_uring: move
mapping/allocation helpers to a separate file` (v6.10) and earlier in
`io_uring/io_uring.c` going back to v6.0 era when io_uring moved into
its own subdirectory (`ed29b0b4fd835`, v6.0).

**Step 3.2 - Fixes: tag:**
Record: No Fixes: tag. The specific UAF via the `pbuf_ring`
`release_pages` path requires the region API on the pbuf side, which
arrived with `ef62de3c4ad58 io_uring/kbuf: use region api for pbuf
rings` and the sibling memmap commits, all in v6.14-rc1.

**Step 3.3 - Related changes:**
Record: Relevant series: `7cd7b9575270e io_uring/memmap: unify io_uring
mmap'ing code`, `ef62de3c4ad58 io_uring/kbuf: use region api for pbuf
rings`, `90175f3f50321 io_uring/kbuf: remove pbuf ring refcounting` (all
v6.14-rc1). These restructured pbuf_ring mmap to share the region
machinery — the same machinery whose `release_pages` now drops the only
reference under NOMMU.

**Step 3.4 - Author:**
Record: Author is Greg Kroah-Hartman (LTS maintainer). Folded by Jens
Axboe (io_uring maintainer). Both highly authoritative.

**Step 3.5 - Dependencies:**
Record: The fix uses `io_mmap_get_region()`, `io_region_is_set()`,
`region->pages`, `region->nr_pages`, `ctx->mmap_lock` — all introduced
in v6.14. For v6.14+ stable trees, this should apply standalone. For
older trees (≤v6.12), the patch will not apply as-is.

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1 - Original submission:**
Record: `b4 dig -c d0be8884f56b0` returned thread
`https://lore.kernel.org/all/2026042115-body-attention-d15b@gregkh/`.
The series went through one revision — Jens folded a simplification
("get rid of region lookup, just iterate pages in vma") with size
validation before applying.

**Step 4.2 - Reviewers:**
Record: To `io-uring@vger.kernel.org`, Cc: Jens Axboe (subsystem
maintainer). Maintainer folded changes and pushed.

**Step 4.3 - Bug report:**
Record: Greg's email confirms this was an AI-generated report.
**However**, Greg explicitly built a PoC (poc.c + run-poc.sh attached to
the thread) which:
- Builds a riscv64 NOMMU kernel and boots in QEMU with `init_on_free=1`
- As init, registers a pbuf_ring with `IOU_PBUF_RING_MMAP`, mmaps a
  page, writes a 0x55 canary, unregisters the pbuf_ring, then re-reads
- On unfixed: canary becomes 0x00 (page freed and zeroed), then re-
  registering reuses the same page demonstrating write-after-free
- On fixed: canary is intact
- Greg replied `Tested-by: Greg Kroah-Hartman
  <gregkh@linuxfoundation.org>` after Jens's folded version

The CVE-style identifiers `ANT-2026-02884` (the UAF) and
`ANT-2026-02650` (related duplicate vm_start) are referenced in the PoC.

**Step 4.4 - Series context:**
Record: Single patch (no series). Greg also has an alternative patch
that disables io_uring on `!MMU` entirely, which Jens did not accept in
favor of this fix.

**Step 4.5 - Stable discussion:**
Record: No explicit `Cc: stable` mention in the thread, and no
`stable@vger.kernel.org` in the discussion. However, this is a confirmed
UAF reachable from unprivileged userspace with a working exploit
reproducer — clearly stable material.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 - Modified functions:**
Record: `io_uring_mmap()` (NOMMU branch), new
`io_uring_nommu_vm_close()`, new `io_uring_nommu_vm_ops`.

**Step 5.2 - Callers:**
Record: `io_uring_mmap` is the file_operations `.mmap` for the io_uring
fd; reachable from any userspace `mmap()` on an io_uring fd.
`io_uring_nommu_vm_close` is invoked by `delete_vma()` in `mm/nommu.c`
on `munmap`/exit. The bug path: `io_unregister_pbuf_ring()` →
`io_put_bl()` (`io_uring/kbuf.c:445`) → `io_free_region()`
(`io_uring/memmap.c:91`) → `release_pages()` — confirmed by `git grep`.

**Step 5.3 - Callees:**
Record: `get_page()`, `put_page()`, `is_nommu_shared_mapping()`,
`io_mmap_get_region()`, `io_region_is_set()`, `virt_to_page()`. All
standard kernel APIs.

**Step 5.4 - Reachability:**
Record: io_uring `register`/`unregister` and `mmap` are unprivileged
syscalls (no `CAP_SYS_ADMIN` for these paths — verified by grep across
`io_uring/`). The PoC demonstrates a full unprivileged trigger.

**Step 5.5 - Similar patterns:**
Record: The MMU path uses `vm_insert_pages()` (which does its own
`get_page` per inserted page, released on VMA teardown via
`zap_pte_range -> put_page`). The fix gives NOMMU equivalent symmetry.
Searching for other `is_nommu_shared_mapping` users (`fc4f4be9b5271`) —
io_uring is the only file_ops user adding such page lifetime semantics
manually.

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1 - Bug presence in stable:**
Record: Verified `git show v6.18:io_uring/memmap.c` and `git show
v7.0:io_uring/memmap.c` — both contain the unfixed `return
is_nommu_shared_mapping(vma->vm_flags) ? 0 : -EINVAL;`. The pbuf_ring
region API (the trigger surface for this exact UAF) exists from v6.14
onward. Affected trees with this exact bug: v6.14, v6.15, v6.16, v6.17,
**v6.18 LTS**, v6.19, **v7.0** (this branch).

**Step 6.2 - Backport complications:**
Record: For v6.14 → v7.0, all helpers (`io_mmap_get_region`,
`io_region_is_set`, `ctx->mmap_lock`, `region->pages/nr_pages`,
`guard(mutex)`) exist; the patch should apply cleanly or with trivial
adjustment. For v6.12 LTS and older, `io_mmap_get_region()` does not
exist (region API absent in pbuf path) — the same conceptual UAF may
exist via different code, but the fix as-presented does not apply. v6.6
LTS — same story.

**Step 6.3 - Related fixes already in stable:**
Record: No prior fix found. This is a new, recently-discovered class of
bug.

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1 - Subsystem and criticality:**
Record: `io_uring` — IMPORTANT (heavily used subsystem; security-
relevant; reachable from unprivileged userspace). Criticality of this
specific config (NOMMU): PERIPHERAL (only `!CONFIG_MMU` builds, mostly
RISC-V/embedded). Net assessment: IMPORTANT-but-PERIPHERAL —
unprivileged UAF in a security-sensitive subsystem, on a small but real
config.

**Step 7.2 - Subsystem activity:**
Record: io_uring is one of the most actively developed kernel
subsystems; the affected code (region API) is recent (v6.14) and well
maintained.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1 - Affected users:**
Record: Users of `!CONFIG_MMU` kernels (RISC-V nommu, ARM nommu,
Blackfin successors, some MicroBlaze configs, embedded NOMMU systems
with io_uring enabled). Small population, but real and the bug is
unconditional on those builds when pbuf_ring mmap is used.

**Step 8.2 - Trigger:**
Record: Trivial — unprivileged process calls `io_uring_setup`,
`io_uring_register(IORING_REGISTER_PBUF_RING, ..., IOU_PBUF_RING_MMAP)`,
`mmap(IORING_OFF_PBUF_RING)`, then
`io_uring_register(IORING_UNREGISTER_PBUF_RING, ...)`. PoC demonstrates
this path. Same pattern for SQ/CQ rings.

**Step 8.3 - Failure mode:**
Record: Use-after-free → write-after-free of kernel pages from
userspace. With the page returned to the buddy allocator and reused
(kernel-side allocation hands the same page back), the user can
read/write whatever the kernel later places there — heap-spray-friendly,
security-CRITICAL. PoC ends with sysrq-c kernel panic for proof.

**Step 8.4 - Risk-benefit:**
Record:
- Benefit: prevents an unprivileged user-triggered UAF / write-after-
  free on NOMMU systems — exactly the stable mandate.
- Risk: minimal — change is confined to the `!CONFIG_MMU` branch of
  `io_uring/memmap.c` (44 lines), so it cannot affect any MMU build.
  Even on NOMMU, the fix only adds `get_page`/`put_page` symmetry to
  mirror the MMU path. Tested-by Greg Kroah-Hartman with explicit PoC +
  boot test.
Ratio: very high benefit / very low risk.

## PHASE 9: FINAL SYNTHESIS

**Step 9.1 - Evidence:**
- FOR: confirmed unprivileged-reachable UAF/WAF on NOMMU; PoC exists and
  panics unfixed kernels; small, surgical, single-file fix; tested by
  Greg KH; written by LTS maintainer; folded by io_uring maintainer;
  merged upstream in `d0be8884f56b0`; only touches NOMMU branch; depends
  on helpers all present in v6.14+.
- AGAINST: NOMMU is uncommon; the bug was AI-discovered and Greg
  initially expressed low confidence in the fix details; pre-v6.14
  stable trees would need a different patch.

**Step 9.2 - Stable rules:**
1. Obviously correct and tested? YES — PoC + Tested-by from LTS
   maintainer.
2. Fixes a real bug affecting users? YES — UAF reachable by any
   unprivileged process on NOMMU.
3. Important issue? YES — security-critical (write-after-free of
   arbitrary kernel pages).
4. Small and contained? YES — 1 file, ~44 lines, NOMMU-only branch.
5. No new features/APIs? YES — internal fix only.
6. Applies to stable? YES for v6.14+ (cleanly to v6.18, v6.19, v7.0);
   needs adaptation for older trees.

**Step 9.3 - Exceptions:** Not applicable — this is a normal bug fix,
not a quirk/device-id/DT update. Stands on its merits.

**Step 9.4 - Decision:** Backport. This is a confirmed unprivileged-
reachable use-after-free with a working PoC. The fix is small, surgical,
and isolated to the NOMMU code path so it cannot regress MMU builds. It
applies cleanly to v6.14+ stable trees including the v7.0.y autosel
target (HEAD here).

## Verification

- [Phase 1] Read full upstream commit `d0be8884f56b0` via `git show`;
  confirmed `Reported-by: Anthropic` and `Assisted-by:
  gkh_clanker_t1000` are part of the upstream commit, not pipeline-
  injected.
- [Phase 2] Diff inspection confirms +44/-1 lines in `io_uring/memmap.c`
  only, all in the `!CONFIG_MMU` branch.
- [Phase 3] `git log --oneline -- io_uring/memmap.c` and `git describe
  --contains` confirm region API arrived in v6.14-rc1 (`ef62de3c4ad58`,
  `7cd7b9575270e`); pre-v6.14 NOMMU mmap was already vulnerable in
  spirit but used different (refcounted) pbuf paths.
- [Phase 3] `git show v6.6:io_uring/io_uring.c`,
  `v6.12:io_uring/memmap.c`, `v6.18:io_uring/memmap.c`,
  `v7.0:io_uring/memmap.c` confirm the unfixed `return
  is_nommu_shared_mapping(vma->vm_flags) ? 0 : -EINVAL;` is present from
  v6.6 through v7.0.
- [Phase 4] `b4 dig -c d0be8884f56b0` returned thread
  `https://lore.kernel.org/all/2026042115-body-attention-d15b@gregkh/`.
- [Phase 4] `b4 dig -c d0be8884f56b0 -a` showed v1 only; Jens folded an
  inline simplification when applying.
- [Phase 4] `b4 dig -c d0be8884f56b0 -m /tmp/io_uring_thread.mbox` saved
  the thread; read confirms PoC (poc.c, run-poc.sh) tests vulnerable vs.
  fixed kernels with `init_on_free=1`, and `Tested-by: Greg Kroah-
  Hartman` on Jens's folded version.
- [Phase 4] PoC references CVE-style identifiers `ANT-2026-02884` (this
  UAF) and `ANT-2026-02650` (related duplicate vm_start case).
- [Phase 5] `grep` in `io_uring/kbuf.c` confirmed
  `io_unregister_pbuf_ring -> io_put_bl -> io_free_region` call chain at
  lines 445, 698, 719.
- [Phase 5] `grep` for `capable\|CAP_` in `io_uring/io_uring.c, kbuf.c,
  register.c` confirms IORING_REGISTER_PBUF_RING and io_uring_mmap are
  unprivileged.
- [Phase 6] Verified `io_mmap_get_region` and `io_region_is_set` exist
  in v6.18, v7.0; do not exist in v6.12.
- [Phase 8] Failure mode: confirmed UAF + WAF + observable from
  userspace via PoC. Severity: CRITICAL (security).
- UNVERIFIED: Did not attempt to actually run the PoC under QEMU in this
  session; relied on Greg KH's `Tested-by` and PoC source code
  inspection.
- UNVERIFIED: Did not check whether stable maintainers (separate from
  the discussion thread) have already queued or rejected this for
  stable.

The fix addresses a confirmed unprivileged-reachable use-after-free /
write-after-free in io_uring under `!CONFIG_MMU`, is small and contained
to the NOMMU branch only, was tested-by the LTS maintainer with a
working PoC, and applies cleanly to v6.14+ stable trees (including the
v7.0.y target this branch represents). It meets every stable rule.

**YES**

 io_uring/memmap.c | 46 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 45 insertions(+), 1 deletion(-)

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index e6958968975a8..4f9b439319c46 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -366,9 +366,53 @@ unsigned long io_uring_get_unmapped_area(struct file *filp, unsigned long addr,
 
 #else /* !CONFIG_MMU */
 
+/*
+ * Drop the pages that were initially referenced and added in
+ * io_uring_mmap(). We cannot have had a mremap() as that isn't supported,
+ * hence the vma should be identical to the one we initially referenced and
+ * mapped, and partial unmaps and splitting isn't possible on a file backed
+ * mapping.
+ */
+static void io_uring_nommu_vm_close(struct vm_area_struct *vma)
+{
+	unsigned long index;
+
+	for (index = vma->vm_start; index < vma->vm_end; index += PAGE_SIZE)
+		put_page(virt_to_page((void *) index));
+}
+
+static const struct vm_operations_struct io_uring_nommu_vm_ops = {
+	.close = io_uring_nommu_vm_close,
+};
+
 int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	return is_nommu_shared_mapping(vma->vm_flags) ? 0 : -EINVAL;
+	struct io_ring_ctx *ctx = file->private_data;
+	struct io_mapped_region *region;
+	unsigned long i;
+
+	if (!is_nommu_shared_mapping(vma->vm_flags))
+		return -EINVAL;
+
+	guard(mutex)(&ctx->mmap_lock);
+	region = io_mmap_get_region(ctx, vma->vm_pgoff);
+	if (!region || !io_region_is_set(region))
+		return -EINVAL;
+
+	if ((vma->vm_end - vma->vm_start) !=
+	    (unsigned long) region->nr_pages << PAGE_SHIFT)
+		return -EINVAL;
+
+	/*
+	 * Pin the pages so io_free_region()'s release_pages() does not
+	 * drop the last reference while this VMA exists. delete_vma()
+	 * in mm/nommu.c calls vma_close() which runs ->close above.
+	 */
+	for (i = 0; i < region->nr_pages; i++)
+		get_page(region->pages[i]);
+
+	vma->vm_ops = &io_uring_nommu_vm_ops;
+	return 0;
 }
 
 unsigned int io_uring_nommu_mmap_capabilities(struct file *file)
-- 
2.53.0


