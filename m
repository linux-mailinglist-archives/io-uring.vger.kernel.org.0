Return-Path: <io-uring+bounces-11331-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B8A19CEA86E
	for <lists+io-uring@lfdr.de>; Tue, 30 Dec 2025 20:09:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9CA323012DC7
	for <lists+io-uring@lfdr.de>; Tue, 30 Dec 2025 19:09:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 000D62571C5;
	Tue, 30 Dec 2025 19:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=negrel.dev header.i=@negrel.dev header.b="sZVUDE0Q"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-43170.protonmail.ch (mail-43170.protonmail.ch [185.70.43.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FCB6251795
	for <io-uring@vger.kernel.org>; Tue, 30 Dec 2025 19:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767121771; cv=none; b=NKH5au8fvwl8J57+7AAHS7shouonYlyNvyaX9Bx0rc/US2qQG3xEQu13FYgvO0mnPqARFNHjtF+DHJ86NZsidMVNOr0+5SzdOAVwTD11JgkV1dpQa8yejniYnZ9llaCyZcRG5tm2Zv8KrgWCN/hIW2G5sU5i9nsYzJXi5kG7Soo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767121771; c=relaxed/simple;
	bh=pWkEjd4hMv/fHafqF4xTd3Kc0gtTkmxazpyQfrtR1rw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=icNR0eCO6MJpKxq+A+gxUxrl3aU8WzInxp/8KAkaP1e15ErZOc1+27vUrM2B5jmYbn1yT7zhJavnD15+bLptM6BxfsTT04MvxS+cgt1yvCsQBkv0dH7sLglIpvvreACPHT7LAfHZe8AGQI68T2V154lkA4BTu2giu81iDTEV3jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=negrel.dev; spf=pass smtp.mailfrom=negrel.dev; dkim=pass (2048-bit key) header.d=negrel.dev header.i=@negrel.dev header.b=sZVUDE0Q; arc=none smtp.client-ip=185.70.43.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=negrel.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=negrel.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=negrel.dev;
	s=protonmail3; t=1767121764; x=1767380964;
	bh=pZWKjWAe65pI5LtNsDuI7lxtSjKpyVfINRRefbhTB1k=;
	h=From:To:Cc:Subject:Date:Message-ID:From:To:Cc:Date:Subject:
	 Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=sZVUDE0QrjaVOXVO8Xg/OGMEBzIGfXe5gwTKlKIgQ2Y914+g1tH3zmbsuI4j/X5fz
	 TL0NK4CY5hULHjL27PzRRd8J/nh4AgYZISSS/OhGZY3BIe+n7628kxcai71ZS42tNq
	 PAzvigMk+TxTZVGNrdM/jzRaawOJxUXutAwNscVIXoFba9KfBhpIcuRczdeJ5W6n/C
	 qOVnFT0FmYMEFXyd6uDARz92UtU78p2Zj7G63wrj7A3ADlhavNmVyxPcSoXB+eSJcn
	 X4hWi3XX+NwtVQffNKFDlw/wmJRpXVqhawD9ia3vFOL4FkQ5NhrBBmTy1B0fFeSohD
	 Sl/djmdNOHgMw==
X-Pm-Submission-Id: 4dgjLp5kBkz2Scqd
From: Alexandre Negrel <alexandre@negrel.dev>
To: axboe@kernel.dk,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Alexandre Negrel <alexandre@negrel.dev>
Subject: [PATCH v2] io_uring: drop overflowing CQE instead of exceeding memory limits
Date: Tue, 30 Dec 2025 19:57:28 +0100
Message-ID: <20251230190909.557152-1-alexandre@negrel.dev>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allocate the overflowing CQE with GFP_NOWAIT instead of GFP_ATOMIC. This
changes causes allocations to fail in out-of-memory situations,
resulting in CQE being dropped. Using GFP_ATOMIC allows a process to
exceed memory limits.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220794
Signed-off-by: Alexandre Negrel <alexandre@negrel.dev>
---
 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 6cb24cdf8e68..709943fedaf4 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -864,7 +864,7 @@ static __cold bool io_cqe_overflow_locked(struct io_ring_ctx *ctx,
 {
 	struct io_overflow_cqe *ocqe;
 
-	ocqe = io_alloc_ocqe(ctx, cqe, big_cqe, GFP_ATOMIC);
+	ocqe = io_alloc_ocqe(ctx, cqe, big_cqe, GFP_NOWAIT);
 	return io_cqring_add_overflow(ctx, ocqe);
 }
 
-- 
2.51.0


