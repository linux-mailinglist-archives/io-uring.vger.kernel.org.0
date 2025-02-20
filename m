Return-Path: <io-uring+bounces-6582-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D552A3DD31
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2025 15:46:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 244418600D9
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2025 14:39:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFAB81FDA99;
	Thu, 20 Feb 2025 14:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b="LPtvd8tl"
X-Original-To: io-uring@vger.kernel.org
Received: from server-vie001.gnuweeb.org (server-vie001.gnuweeb.org [89.58.62.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9231FC0E4;
	Thu, 20 Feb 2025 14:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.62.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740062374; cv=none; b=bzzw8UBV02+snS5JLuSP9tZr73+pr0Amcj6X1XZEWyucrVckzTrCYSlShPeVbO5NLZljtpTk3khjfMKFF6YT93agVE8MTw5rKBwbhOxHqGYO8vP7uFl6uYVWzYXhLsumll3dTJTIbmdOis9rgGvPwMZiHa4KF6ZM6itSZNi6Q2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740062374; c=relaxed/simple;
	bh=LbQkwTDIu9g+6v+t8LjVmjJshSoNf7WjKV5AFx6vUuE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ClWqQsU5BTXRHMaV0PHg6b7XuxdSQD8R3HaocMsCYZDr/B4NKBUQCj9M/EXRqTdZlID2eKjewZa1GnNQJusTjvrmKTnqi5dkP5elzXUiWtvnZ4//yaLTroX1qYFmr/lHRHaen/0oYL7r4+TDKfm+5ui4AT8JjYkLM38ogi+wVLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org; spf=pass smtp.mailfrom=gnuweeb.org; dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b=LPtvd8tl; arc=none smtp.client-ip=89.58.62.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnuweeb.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=default; t=1740062098;
	bh=LbQkwTDIu9g+6v+t8LjVmjJshSoNf7WjKV5AFx6vUuE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Message-ID:Date:From:
	 Reply-To:Subject:To:Cc:In-Reply-To:References:Resent-Date:
	 Resent-From:Resent-To:Resent-Cc:User-Agent:Content-Type:
	 Content-Transfer-Encoding;
	b=LPtvd8tlVb2viqcehzfDj2Z5F19wvvm861uzy2+3IEa644XN3neHmVWYcCH5+pIOg
	 ByT7QcKSE90hNTDJIivsuiXH+vL1TrdazRsLrf7+7P8H2D645yb0/JNkA2lDdzJ1XV
	 OMPzyhOuojCRByx6+0TlCQMg0u6pI5O0HFtReDFHzdC4oZYS4mPRklwWJwuSAB71v7
	 nhmd5mvwOuFpITeGmkJzAp6ie2DtUkkyQPoQZ7A/yyCemKSX27Rs76hQfnQqIMm4cD
	 M1odogMBwWoEYIA9XQZ5MVdutgt/XqENO4kaehxRfusxpmxxRNmsl+q+MgS5/wCb+8
	 yJAUK5QkE8OPg==
Received: from integral2.. (unknown [182.253.126.96])
	by server-vie001.gnuweeb.org (Postfix) with ESMTPSA id DF02A20744A5;
	Thu, 20 Feb 2025 14:34:56 +0000 (UTC)
From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ammar Faizi <ammarfaizi2@gnuweeb.org>,
	Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
	io-uring Mailing List <io-uring@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v1 2/3] liburing.h: Explain the history of `io_uring_get_sqe()`
X-Gw-Bpl: wU/cy49Bu1yAPm0bW2qiliFUIEVf+EkEatAboK6pk2H2LSy2bfWlPAiP3YIeQ5aElNkQEhTV9Q==
Date: Thu, 20 Feb 2025 21:34:21 +0700
Message-Id: <20250220143422.3597245-3-ammarfaizi2@gnuweeb.org>
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

Add a comment for `io_uring_get_sqe()` to provide historical context
and prevent misunderstandings, as seen in Pull Request 1336.

Link: https://github.com/axboe/liburing/pull/1336
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/include/liburing.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index b2d76f3224e2..98419e378f72 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -1622,24 +1622,43 @@ IOURINGINLINE int io_uring_buf_ring_available(struct io_uring *ring,
 					      unsigned short bgid)
 {
 	uint16_t head;
 	int ret;
 
 	ret = io_uring_buf_ring_head(ring, bgid, &head);
 	if (ret)
 		return ret;
 
 	return (uint16_t) (br->tail - head);
 }
 
+/*
+ * As of liburing-2.2, io_uring_get_sqe() has been converted into a
+ * "static inline" function. However, this change breaks seamless
+ * updates of liburing.so, as applications would need to be recompiled.
+ * To ensure backward compatibility, liburing keeps the original
+ * io_uring_get_sqe() symbol available in the shared library.
+ *
+ * To accomplish this, io_uring_get_sqe() is defined as a non-static
+ * inline function when LIBURING_INTERNAL is set, which only applies
+ * during liburing.so builds.
+ *
+ * This strategy ensures new users adopt the "static inline" version
+ * while preserving compatibility for old applications linked against
+ * the shared library.
+ *
+ * Relevant commits:
+ * 8be8af4afcb4 ("queue: provide io_uring_get_sqe() symbol again")
+ * 52dcdbba35c8 ("src/queue: protect io_uring_get_sqe() with LIBURING_INTERNAL")
+ */
 #ifndef LIBURING_INTERNAL
 IOURINGINLINE struct io_uring_sqe *io_uring_get_sqe(struct io_uring *ring)
 {
 	return _io_uring_get_sqe(ring);
 }
 #else
 struct io_uring_sqe *io_uring_get_sqe(struct io_uring *ring);
 #endif
 
 ssize_t io_uring_mlock_size(unsigned entries, unsigned flags);
 ssize_t io_uring_mlock_size_params(unsigned entries, struct io_uring_params *p);
 
-- 
Ammar Faizi


