Return-Path: <io-uring+bounces-8790-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DA9DB12384
	for <lists+io-uring@lfdr.de>; Fri, 25 Jul 2025 20:06:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 527E816B574
	for <lists+io-uring@lfdr.de>; Fri, 25 Jul 2025 18:06:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 109092EF9B7;
	Fri, 25 Jul 2025 18:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b="FcPBDz27"
X-Original-To: io-uring@vger.kernel.org
Received: from server-vie001.gnuweeb.org (server-vie001.gnuweeb.org [89.58.62.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2567323D2A8;
	Fri, 25 Jul 2025 18:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.62.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753466750; cv=none; b=dJsdPN7lfAE+kq9asdBf4zPWvfDckdf8wnogVZvHDPaNRUTme5M8fXkPflAUgotYXnyLGENcF9+sLs6JuxZ9mOjmIqPJKCv+vwJNpXWPDR+Lh6vDAaoG58/A7m3VktQf5xftozbpxfgp4DGNoTOVfQdeoFDCJcGX2I1AXMrWBLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753466750; c=relaxed/simple;
	bh=RbaHXKOumQvn00PCmVrWI0kuNbT0c/19c0zosGE1V1s=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=E2/Fj8Au46fhOlMx+1pykxHhZZymxD2ch8XAeJtFyKbFAid1ZhSNQDkjka/I61kduTWwWyasiPhqhvGHULmUwkPwnMC0evPd7c63AP3hFBZuvE/0SV07DFOj1WT2UaJZ42icyM0FF9EEKtet5tqxRPW/fIxYjPLGZccG4RZhpyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org; spf=pass smtp.mailfrom=gnuweeb.org; dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b=FcPBDz27; arc=none smtp.client-ip=89.58.62.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnuweeb.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=new2025; t=1753466362;
	bh=RbaHXKOumQvn00PCmVrWI0kuNbT0c/19c0zosGE1V1s=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:
	 Content-Transfer-Encoding:Message-ID:Date:From:Reply-To:Subject:To:
	 Cc:In-Reply-To:References:Resent-Date:Resent-From:Resent-To:
	 Resent-Cc:User-Agent:Content-Type:Content-Transfer-Encoding;
	b=FcPBDz27zuUqwmeqgjFeFBnsW2niRJGJObJ6Xb8N/3wXw16SCBmITsJK0LbeKZ5Vy
	 +JJBKFl7EelWwM5rhDNGa8HuMATxNPo4X+Wuk9BRuINkLwjrWPxJsfotjbbd3y6DxU
	 K3U/GKxiCdZXHs4EMIFZ9Xh/hGHBS0koVIN4J6RZ0TSY4YPLiWiODnRFSfBJ281Yl2
	 GpilVm04eU46vZH8wx2IevOlStR6uORz+4buMamXHErdpGstpg6rdcpahTkwd/Zn1E
	 t+sT45uKZ/XBSiOgm3WgEC15EL8b/A7XFj4CV3E855z0nltjc1y6Mqg4K7tx1L88mF
	 8lu5qJLHe2Ekg==
Received: from integral2.. (unknown [182.253.126.144])
	by server-vie001.gnuweeb.org (Postfix) with ESMTPSA id 12BE32109AB5;
	Fri, 25 Jul 2025 17:59:19 +0000 (UTC)
From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ammar Faizi <ammarfaizi2@gnuweeb.org>,
	Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
	Christian Mazakas <christian.mazakas@gmail.com>,
	Michael de Lang <michael@volt-software.nl>,
	io-uring Mailing List <io-uring@vger.kernel.org>,
	GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH liburing 0/2] liburing fixes
X-Gw-Bpl: wU/cy49Bu1yAPm0bW2qiliFUIEVf+EkEatAboK6pk2H2LSy2bfWlPAiP3YIeQ5aElNkQEhTV9Q==
Date: Sat, 26 Jul 2025 00:59:11 +0700
Message-Id: <20250725175913.2598891-1-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Jens,

Hopefully, not too late for 2.12. Two small final fixes here:

  - Fix build error when using address sanitizer due to missing
    `IORING_OP_PIPE` in `sanitize.c`.

  - Don't use `IOURINGINLINE` on `__io_uring_prep_poll_mask` as it
    is not a function that should be exported in the FFI API.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

Ammar Faizi (2):
  sanitize: Fix missing `IORING_OP_PIPE`
  liburing: Don't use `IOURINGINLINE` on `__io_uring_prep_poll_mask`

 src/include/liburing.h | 2 +-
 src/sanitize.c         | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)


base-commit: ec856cecab2ed4bcbdba2b06a8c7cb5a52083c28
-- 
Ammar Faizi


