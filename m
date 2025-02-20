Return-Path: <io-uring+bounces-6581-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 69E7AA3DD15
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2025 15:40:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 97394189F4DF
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2025 14:39:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96BDA1FCFDA;
	Thu, 20 Feb 2025 14:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b="rl6CRDA9"
X-Original-To: io-uring@vger.kernel.org
Received: from server-vie001.gnuweeb.org (server-vie001.gnuweeb.org [89.58.62.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9F51FC7F1;
	Thu, 20 Feb 2025 14:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.62.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740062374; cv=none; b=QNKrfZj3id0YyJBU0PryTeBoKseigipqwkQbES4B9pXV2+mTvkRSRieLbfW880Un7ojG1y0rP5j0CCZ67xeHwl51JQLAx4ABQO6+BKHnIsB45pz2PGONckR2LZkAQXImKghBdv3ISJLMzc0LRmJKQ7to73gDU3VD/BjbfeoSB1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740062374; c=relaxed/simple;
	bh=NXzmlJbcyvCFApkcvBVHzM26nc8bwg9PTyW6PRPeox4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=F4CUAKc1aZPgV6vRNkbBSVhzAdaatng3ASJc+0uJBAKxSGrMARoUmbn9x7zM0OPitE4XEfutO2vZs08YxC6E2N0nJkj0CprkcLeXz1hmlZ6K8wXlzY9qushvzKOfXFOBSjhhByquuu9AjB/WjiHVLrJ9p1Ut+j2k9270JqygMs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org; spf=pass smtp.mailfrom=gnuweeb.org; dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b=rl6CRDA9; arc=none smtp.client-ip=89.58.62.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnuweeb.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=default; t=1740062095;
	bh=NXzmlJbcyvCFApkcvBVHzM26nc8bwg9PTyW6PRPeox4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Message-ID:Date:From:
	 Reply-To:Subject:To:Cc:In-Reply-To:References:Resent-Date:
	 Resent-From:Resent-To:Resent-Cc:User-Agent:Content-Type:
	 Content-Transfer-Encoding;
	b=rl6CRDA9zzbIVO5XlJXKxJ9ifgO0vgYJmlRFNbINzNSaIK6Nwi3wawzFZ6cuRiqCs
	 ToclivVe6TTC0Oqfu+TTQe1BUPH8kB6SymxNgc+osWFh1ktrMYyX7JQjfzBHw1pmcW
	 zb8wuelI130vzcbeDuQVFRfTBcCRawrSPnNax5YlOPy6JdRHKXYZ0zDo7Dl5/ISwOu
	 jonfT+8200Zw5Eopq5ztwSWKkHqESFUIPK43gnJ0IcOg2JVKovAhJwBfJIPzeDZlVS
	 i959gG2ORFC1JfzBnFA9Zj5GYfugmmAlX/8aP299O9se8/W973vRDAZH34QL2FrTyW
	 OrMViV/d0EmtA==
Received: from integral2.. (unknown [182.253.126.96])
	by server-vie001.gnuweeb.org (Postfix) with ESMTPSA id F1D3720744A4;
	Thu, 20 Feb 2025 14:34:53 +0000 (UTC)
From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ammar Faizi <ammarfaizi2@gnuweeb.org>,
	Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
	io-uring Mailing List <io-uring@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v1 1/3] liburing.h: Remove redundant double negation
X-Gw-Bpl: wU/cy49Bu1yAPm0bW2qiliFUIEVf+EkEatAboK6pk2H2LSy2bfWlPAiP3YIeQ5aElNkQEhTV9Q==
Date: Thu, 20 Feb 2025 21:34:20 +0700
Message-Id: <20250220143422.3597245-2-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250220143422.3597245-1-ammarfaizi2@gnuweeb.org>
References: <20250220143422.3597245-1-ammarfaizi2@gnuweeb.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The `enabled` variable is already a boolean, so applying the negation
operator twice has no effect. Remove it to improves clarity and
simplicity.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/include/liburing.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 6393599cb3bf..b2d76f3224e2 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -1410,25 +1410,25 @@ IOURINGINLINE bool io_uring_cq_eventfd_enabled(const struct io_uring *ring)
 	return !(*ring->cq.kflags & IORING_CQ_EVENTFD_DISABLED);
 }
 
 /*
  * Toggle eventfd notification on or off, if an eventfd is registered with
  * the ring.
  */
 IOURINGINLINE int io_uring_cq_eventfd_toggle(struct io_uring *ring,
 					     bool enabled)
 {
 	uint32_t flags;
 
-	if (!!enabled == io_uring_cq_eventfd_enabled(ring))
+	if (enabled == io_uring_cq_eventfd_enabled(ring))
 		return 0;
 
 	if (!ring->cq.kflags)
 		return -EOPNOTSUPP;
 
 	flags = *ring->cq.kflags;
 
 	if (enabled)
 		flags &= ~IORING_CQ_EVENTFD_DISABLED;
 	else
 		flags |= IORING_CQ_EVENTFD_DISABLED;
 
-- 
Ammar Faizi


