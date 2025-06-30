Return-Path: <io-uring+bounces-8543-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F205DAEE85C
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 22:37:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F230E189E5B4
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 20:37:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87F7C224896;
	Mon, 30 Jun 2025 20:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b="FW2kyEmk"
X-Original-To: io-uring@vger.kernel.org
Received: from server-vie001.gnuweeb.org (server-vie001.gnuweeb.org [89.58.62.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67CC19994F;
	Mon, 30 Jun 2025 20:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.62.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751315818; cv=none; b=ugMIR0Aa3XC/J1kNU1urgd3CcYIW9SG5dl/vAxnSRsv58X2PhApAS+RuHj53rSz2hpkjsGFajIYK4cRIv2x07/ZIBWIvfsfJi0kv0XzamJ6z5TKrwWak8wp1BfaSorVM8fUluvqb4E0KWMH4JNEbIawRIXkOV+vEIK7s644cQ04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751315818; c=relaxed/simple;
	bh=xJYX+//5oV9dbrN8BNhaG+fyKZzrOYQDh7HMTywYW2M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DSQpjF0uclZSopQW3vQQmZe17qqSHbMkBcmBxi+rWr/g/oPeGmdR9ZpGKyvhghCfI7tw2/dU4pFc7KVpOx9Ud3aNR7h4Y0MI8runhCELPAA1J1OLjKjoLYtkWSISXPXr/pEGUnY0rIrmuYZXVPPizvkfvBRAOwtp/mYNOmuodOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org; spf=pass smtp.mailfrom=gnuweeb.org; dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b=FW2kyEmk; arc=none smtp.client-ip=89.58.62.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnuweeb.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=default; t=1751315808;
	bh=xJYX+//5oV9dbrN8BNhaG+fyKZzrOYQDh7HMTywYW2M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:
	 Content-Transfer-Encoding:Message-ID:Date:From:Reply-To:Subject:To:
	 Cc:In-Reply-To:References:Resent-Date:Resent-From:Resent-To:
	 Resent-Cc:User-Agent:Content-Type:Content-Transfer-Encoding;
	b=FW2kyEmkiGkRhcg6Ul7JzICq4iWJjClpXNZQiWh74OIKu3AlnIDa9UhhDgZhQljBf
	 crsTyAlvu6uTQ/5ChNNflEqDaYddQjhuTm202HgiUPCeNVp7J/QZBuKyUczGAAqYTv
	 XNhzIzkWxQZZYT1ZPftmP8pbncIvpuX/ZKo+owU9CMiji1WCaM6wxxuRWGaX65DzXU
	 lV2/DRYwRvhXsi1sTu0/DFglo4nHQTrcqjWct/XNt38Muw9Kik3R00FTHtXkQUcjrr
	 2muQ84MrX2UFZMtICHj2ROGhblUN0gXmag8y+OB1mEqziysq1cuKm/60cHm9Q76emY
	 0vqfQg6etfUaw==
Received: from integral2.. (unknown [182.253.126.254])
	by server-vie001.gnuweeb.org (Postfix) with ESMTPSA id 3153E2109A7C;
	Mon, 30 Jun 2025 20:36:47 +0000 (UTC)
From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ammar Faizi <ammarfaizi2@gnuweeb.org>,
	io-uring Mailing List <io-uring@vger.kernel.org>,
	GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Christian Mazakas <christian.mazakas@gmail.com>,
	Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Subject: [PATCH liburing] liburing.h: Only use `IOURINGINLINE` macro for FFI functions
X-Gw-Bpl: wU/cy49Bu1yAPm0bW2qiliFUIEVf+EkEatAboK6pk2H2LSy2bfWlPAiP3YIeQ5aElNkQEhTV9Q==
Date: Tue,  1 Jul 2025 03:36:40 +0700
Message-Id: <20250630203641.1217131-1-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

These 3 inline functions are for liburing internal use, it does not
make much sense to export them:

  uring_ptr_to_u64
  io_uring_cqe_iter_init
  io_uring_cqe_iter_next

Don't use IOURINGINLINE on them. Also, add a comment on the
IOURINGINLINE macro definition explaining when to use IOURINGINLINE
and remind the reader to add the exported function to liburing-ffi.map
if they introduce a function marked with IOURINGINLINE.

Cc: Christian Mazakas <christian.mazakas@gmail.com>
Cc: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/include/liburing.h | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 35d2b271b546..3948a5a6ed47 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -28,6 +28,13 @@
 #define uring_likely(cond)	__builtin_expect(!!(cond), 1)
 #endif
 
+/*
+ * NOTE: Only use IOURINGINLINE macro for 'static inline' functions
+ *       that are expected to be available in the FFI bindings.
+ *
+ *       Functions that are marked as IOURINGINLINE should be
+ *       included in the liburing-ffi.map file.
+ */
 #ifndef IOURINGINLINE
 #define IOURINGINLINE static inline
 #endif
@@ -146,7 +153,7 @@ struct io_uring_zcrx_rq {
  * Library interface
  */
 
-IOURINGINLINE __u64 uring_ptr_to_u64(const void *ptr)
+static inline __u64 uring_ptr_to_u64(const void *ptr)
 {
 	return (__u64) (unsigned long) ptr;
 }
@@ -360,7 +367,7 @@ struct io_uring_cqe_iter {
 	unsigned tail;
 };
 
-IOURINGINLINE struct io_uring_cqe_iter
+static inline struct io_uring_cqe_iter
 io_uring_cqe_iter_init(const struct io_uring *ring)
 {
 	return (struct io_uring_cqe_iter) {
@@ -373,7 +380,7 @@ io_uring_cqe_iter_init(const struct io_uring *ring)
 	};
 }
 
-IOURINGINLINE bool io_uring_cqe_iter_next(struct io_uring_cqe_iter *iter,
+static inline bool io_uring_cqe_iter_next(struct io_uring_cqe_iter *iter,
 					  struct io_uring_cqe **cqe)
 {
 	if (iter->head == iter->tail)
-- 
Ammar Faizi


