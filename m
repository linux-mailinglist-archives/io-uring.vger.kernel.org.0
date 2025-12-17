Return-Path: <io-uring+bounces-11144-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id D9183CC63E8
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 07:27:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E3A8E300FA43
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 06:27:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CB5C2E62A6;
	Wed, 17 Dec 2025 06:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=deepseek.com header.i=@deepseek.com header.b="BebRzdm9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-m49219.qiye.163.com (mail-m49219.qiye.163.com [45.254.49.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615102E7166;
	Wed, 17 Dec 2025 06:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765952822; cv=none; b=pGiN4sWWK5Byve32NqqfzWrMnwGTtDJXlUmUZXCUzoRWaC+0pHCYqRGZr+gTBUPNFu+9lVl1SBPskx4A+DMvC9DL0Alv6HFr3yNTGq+kD3fX66/nK61Ap/ZnO+5CqNabKGtQxVESndnb54YailLOkOAcwv9h6CHSO0MP6LHgLy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765952822; c=relaxed/simple;
	bh=7BxlaxfER2x2pFe5eavxUlLUsqLl2xFS1HVu6XX+P98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=scMICqOwzNPFEM1Pi7Tm+CTIXKuuVkNJ9WfEnqRBw3Jnx6yhv+y/DTQyG9hlaNVRF9qsBzV/UEMreE+7UM5XA7MsWzyuNA4f26SDNDlk+GwFhKoSMJetB5kpS8JUrHTRwTK1IVvBDc6oWR+DmPYpxwNtyRboNnO7atZkGGrAa58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deepseek.com; spf=pass smtp.mailfrom=deepseek.com; dkim=pass (1024-bit key) header.d=deepseek.com header.i=@deepseek.com header.b=BebRzdm9; arc=none smtp.client-ip=45.254.49.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deepseek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=deepseek.com
Received: from localhost.localdomain (unknown [166.108.226.185])
	by smtp.qiye.163.com (Hmail) with ESMTP id 2d8a364d5;
	Wed, 17 Dec 2025 14:26:53 +0800 (GMT+08:00)
From: huang-jl <huang-jl@deepseek.com>
To: csander@purestorage.com
Cc: axboe@kernel.dk,
	huang-jl@deepseek.com,
	io-uring@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ming.lei@redhat.com
Subject: [PATCH v2] io_uring: fix nr_segs calculation in io_import_kbuf
Date: Wed, 17 Dec 2025 14:26:32 +0800
Message-ID: <20251217062632.113983-1-huang-jl@deepseek.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <CADUfDZo4Kbkodz3w-BRsSOEwTGeEQeb-yppmMNY5-ipG33B2qg@mail.gmail.com>
References: <CADUfDZo4Kbkodz3w-BRsSOEwTGeEQeb-yppmMNY5-ipG33B2qg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9b2afd76a809d9kunm7763a7da5bff75
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVkZH0tOVkNDGRlKQkJCSEhMSFYVFAkWGhdVEwETFh
	oSFyQUDg9ZV1kYEgtZQVlKTU1VSktDVUlJTVVKQ05ZV1kWGg8SFR0UWUFZS1VLVUtVS1kG
DKIM-Signature: a=rsa-sha256;
	b=BebRzdm949lKFG8EnAZSqbGzCyYBIhhq6jqON4c/kG0vSIckHACe3sUV4E0QXXXotgmuelZdOBPgEROYqmoYKbRvWLJHxlLwBsPSjJpirtY8olInYvLeYhitVzLVaHojqYntbtEVacxnYkNB891XBL1WszCm5adm6YXqbKccScE=; c=relaxed/relaxed; s=default; d=deepseek.com; v=1;
	bh=YoEcSZ03rmcNHwq1IcA+cJrOspaCwqjoETaIC7FIqgQ=;
	h=date:mime-version:subject:message-id:from;

io_import_kbuf() calculates nr_segs incorrectly when iov_offset is
non-zero after iov_iter_advance(). It doesn't account for the partial
consumption of the first bvec.

The problem comes when meet the following conditions:
1. Use UBLK_F_AUTO_BUF_REG feature of ublk.
2. The kernel will help to register the buffer, into the io uring.
3. Later, the ublk server try to send IO request using the registered
   buffer in the io uring, to read/write to fuse-based filesystem, with
O_DIRECT.

From a userspace perspective, the ublk server thread is blocked in the
kernel, and will see "soft lockup" in the kernel dmesg.

When ublk registers a buffer with mixed-size bvecs like [4K]*6 + [12K]
and a request partially consumes a bvec, the next request's nr_segs
calculation uses bvec->bv_len instead of (bv_len - iov_offset).

This causes fuse_get_user_pages() to loop forever because nr_segs
indicates fewer pages than actually needed.

Specifically, the infinite loop happens at:
fuse_get_user_pages()
  -> iov_iter_extract_pages()
    -> iov_iter_extract_bvec_pages()
Since the nr_segs is miscalculated, the iov_iter_extract_bvec_pages
returns when finding that i->nr_segs is zero. Then
iov_iter_extract_pages returns zero. However, fuse_get_user_pages does
still not get enough data/pages, causing infinite loop.

Example:
  - Bvecs: [4K, 4K, 4K, 4K, 4K, 4K, 12K, ...]
  - Request 1: 32K at offset 0, uses 6*4K + 8K of the 12K bvec
  - Request 2: 32K at offset 32K
    - iov_offset = 8K (8K already consumed from 12K bvec)
    - Bug: calculates using 12K, not (12K - 8K) = 4K
    - Result: nr_segs too small, infinite loop in fuse_get_user_pages.

Fix by accounting for iov_offset when calculating the first segment's
available length.

Fixes: b419bed4f0a6 ("io_uring/rsrc: ensure segments counts are correct on kbuf buffers")
Signed-off-by: huang-jl <huang-jl@deepseek.com>
---
 v2: Optimize the logic to handle the iov_offset and add Fixes tag.

 > Please add a Fixes tag
 
 Thanks for your notice, this is my first time to send patch to linux. I
 have add the Fixes tag, but not sure if I am doing it correctly.

 > Would a simpler fix be just to add a len += iter->iov_offset before the loop?
 
 Great suggestion! I have tried it, and also fix the bug correctly.

 io_uring/rsrc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index a63474b331bf..41c89f5c616d 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1059,6 +1059,7 @@ static int io_import_kbuf(int ddir, struct iov_iter *iter,
 	if (count < imu->len) {
 		const struct bio_vec *bvec = iter->bvec;
 
+		len += iter->iov_offset;
 		while (len > bvec->bv_len) {
 			len -= bvec->bv_len;
 			bvec++;
-- 
2.43.0


