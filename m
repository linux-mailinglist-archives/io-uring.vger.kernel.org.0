Return-Path: <io-uring+bounces-11131-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0788ECC5F05
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 05:02:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B588C300B984
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 04:02:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29A6E17B506;
	Wed, 17 Dec 2025 04:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=deepseek.com header.i=@deepseek.com header.b="Rvdlxv5u"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-m32108.qiye.163.com (mail-m32108.qiye.163.com [220.197.32.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2013A1E7D;
	Wed, 17 Dec 2025 04:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.32.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765944153; cv=none; b=CwrY8RMv3CjnpPQufuFyQOUrAbTQkTazEPsDU2QnqwQQVp4NpOpCvlLrHHw2wp58Bw9mJwoQ/LA2nNC1G2/Vbx9Ej53hsr+XIUlFWqCbcA9yRwVF8oB5WHAC/Kpn3mqzgC5qhTeYgc6MJOMVVUQ0ExpYf427vHQBRVHru0KFAAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765944153; c=relaxed/simple;
	bh=vzre6JxHrRIZk+8E8PU833QzBmMhEHDifh0h15w2tzc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FB4akrIA5d1w9nKXfIqBAAmhPbwi6a5kH8pavd3sRpt47CpOi9Lg0agPLDPAO0l9KOyCcMV8W+1BNjfO80eBtTm7pekc/VJce+Im4gHg+ii3VRBIFY2Mz4f9ZyyOLZOWUaicPlqjQg3MGRNy/Oc8DRLq/cM+4qTgvuuOqBr/xGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deepseek.com; spf=pass smtp.mailfrom=deepseek.com; dkim=pass (1024-bit key) header.d=deepseek.com header.i=@deepseek.com header.b=Rvdlxv5u; arc=none smtp.client-ip=220.197.32.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deepseek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=deepseek.com
Received: from localhost.localdomain (unknown [124.243.134.172])
	by smtp.qiye.163.com (Hmail) with ESMTP id 2d83fae2e;
	Wed, 17 Dec 2025 11:26:55 +0800 (GMT+08:00)
From: huang-jl <huang-jl@deepseek.com>
To: io-uring@vger.kernel.org
Cc: axboe@kernel.dk,
	ming.lei@redhat.com,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	huang-jl <huang-jl@deepseek.com>
Subject: [PATCH 01/01] io_uring: fix nr_segs calculation in io_import_kbuf
Date: Wed, 17 Dec 2025 11:26:17 +0800
Message-ID: <20251217032617.162914-1-huang-jl@deepseek.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9b2a58b54309d9kunm0e3fd72959e20d
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlDTE9CVk5DGUMdSUlDSkxMSVYVFAkWGhdVEwETFh
	oSFyQUDg9ZV1kYEgtZQVlKSU9VSU9IVUpIT1VKTElZV1kWGg8SFR0UWUFZT0tIVUpLSUJDQ0xVSk
	tLVUtZBg++
DKIM-Signature: a=rsa-sha256;
	b=Rvdlxv5uQJiVRy0yM15u0Gim5iZasNYI+QBwuC4Hx5vtcHcGd/CBFmGjDVSFbBSba11mkHx4lb2jG07d8i6NGfMD4aQeGMVbdwg9OeFJXQ7yNsxR6RfNtPW0cbaqWfls5hAVzJI6QVRSWONkbQGxH/ma5TR2vmi3frZUaMIuPgQ=; c=relaxed/relaxed; s=default; d=deepseek.com; v=1;
	bh=mhuq6ZuOdqSFVwozXZKr09+qLPZqF/hpqG6Or+TyGwE=;
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

Signed-off-by: huang-jl <huang-jl@deepseek.com>
---
 io_uring/rsrc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index a63474b33..4eca0c18c 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1058,6 +1058,14 @@ static int io_import_kbuf(int ddir, struct iov_iter *iter,
 
 	if (count < imu->len) {
 		const struct bio_vec *bvec = iter->bvec;
+		size_t first_seg_len = bvec->bv_len - iter->iov_offset;
+
+		if (len <= first_seg_len) {
+			iter->nr_segs = 1;
+			return 0;
+		}
+		len -= first_seg_len;
+		bvec++;
 
 		while (len > bvec->bv_len) {
 			len -= bvec->bv_len;
-- 
2.43.0


