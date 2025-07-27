Return-Path: <io-uring+bounces-8800-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E048B12D4F
	for <lists+io-uring@lfdr.de>; Sun, 27 Jul 2025 03:03:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7443118A0362
	for <lists+io-uring@lfdr.de>; Sun, 27 Jul 2025 01:03:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07C6017C21C;
	Sun, 27 Jul 2025 01:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b="GjW/qhjl"
X-Original-To: io-uring@vger.kernel.org
Received: from server-vie001.gnuweeb.org (server-vie001.gnuweeb.org [89.58.62.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768E815ECCC;
	Sun, 27 Jul 2025 01:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.62.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753578184; cv=none; b=U2Bu98MYCEuSFDvK6+fjykESjhleTCqgJITjtXvs+wZL4m5xYdd/H34NxuIajb19S0rnGcrAmDiFeyPUbC9KcO+pwa2BjDVLGFCIl6oLuhg2N0lbhYJT+q6OUagjT150FSeoaX9jJZ8u1yzc9vHgAHFleB4EOnvlWOJM7+NzR5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753578184; c=relaxed/simple;
	bh=Sja6bm5jphgdqcm6dDbnQou5peLTye/IGOEKghR68xI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=T5ym6GkmsbvBUArbDC9sFtltQufjKGe1HFelhMpona6Tr3666DDvPk7JgkfZZEgcSnMtVhAfwRUxpQEHzFCJK9/6JC8aDnmFWwipm3VjCZQtrTKj7Kof6vQCs3kAfe7DC71Et3b7UdKIVXFYNjn8aEaqpvdDEZbsdMQbdnDbMXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org; spf=pass smtp.mailfrom=gnuweeb.org; dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b=GjW/qhjl; arc=none smtp.client-ip=89.58.62.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnuweeb.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=new2025; t=1753578181;
	bh=Sja6bm5jphgdqcm6dDbnQou5peLTye/IGOEKghR68xI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Message-ID:Date:From:
	 Reply-To:Subject:To:Cc:In-Reply-To:References:Resent-Date:
	 Resent-From:Resent-To:Resent-Cc:User-Agent:Content-Type:
	 Content-Transfer-Encoding;
	b=GjW/qhjl20ELgS/FjllHRq7j6VeMex8nNTKte5vlzet2WDWpjq+4rTq+w/j2Vnvoj
	 iv/lepNtIUmyBXPisK9v1RN2oryhzCPkWmeDBVfQZNPlQ5PiPQHQanIJFNNnrBgqJo
	 lw9TZyAAzqjbI3azadK59xUcfZJhXDkUUl/702Xst0cCtyrfO9UDUYPvZDQ5kLu55M
	 NNZQaiu0snEjc1kKPR1Lz9beMgxZUFdmELjoblx6JH8O/I8ANPe3iFJQiKbMjmEVj/
	 D1mxIHyak6QQfrknqDE8mFAClHZCu2WLBh/afPSTmDB9YEWyeGEdNsJBqrtO3cNMVe
	 E9bGzxpUx45mA==
Received: from integral2.. (unknown [182.253.126.144])
	by server-vie001.gnuweeb.org (Postfix) with ESMTPSA id 1B66C3126E04;
	Sun, 27 Jul 2025 01:02:59 +0000 (UTC)
From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
To: 
Cc: Ammar Faizi <ammarfaizi2@gnuweeb.org>,
	Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
	GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
	Christian Mazakas <christian.mazakas@gmail.com>,
	io-uring Mailing List <io-uring@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH liburing v2 3/3] liburing: Don't use `IOURINGINLINE` on private helpers
X-Gw-Bpl: wU/cy49Bu1yAPm0bW2qiliFUIEVf+EkEatAboK6pk2H2LSy2bfWlPAiP3YIeQ5aElNkQEhTV9Q==
Date: Sun, 27 Jul 2025 08:02:51 +0700
Message-Id: <20250727010251.3363627-4-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250727010251.3363627-1-ammarfaizi2@gnuweeb.org>
References: <20250727010251.3363627-1-ammarfaizi2@gnuweeb.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These functions:

  __io_uring_set_target_fixed_file
  __io_uring_peek_cqe

are not exported for FFI. Don't use `IOURINGINLINE` on them.

Cc: Christian Mazakas <christian.mazakas@gmail.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/include/liburing.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 83434f6eca65..e3f394eab860 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -522,7 +522,7 @@ IOURINGINLINE void io_uring_sqe_set_buf_group(struct io_uring_sqe *sqe,
 	sqe->buf_group = (__u16) bgid;
 }
 
-IOURINGINLINE void __io_uring_set_target_fixed_file(struct io_uring_sqe *sqe,
+static inline void __io_uring_set_target_fixed_file(struct io_uring_sqe *sqe,
 						    unsigned int file_index)
 	LIBURING_NOEXCEPT
 {
@@ -1742,7 +1742,7 @@ IOURINGINLINE int io_uring_wait_cqe_nr(struct io_uring *ring,
  * "official" versions of this, io_uring_peek_cqe(), io_uring_wait_cqe(),
  * or io_uring_wait_cqes*().
  */
-IOURINGINLINE int __io_uring_peek_cqe(struct io_uring *ring,
+static inline int __io_uring_peek_cqe(struct io_uring *ring,
 				      struct io_uring_cqe **cqe_ptr,
 				      unsigned *nr_available)
 	LIBURING_NOEXCEPT
-- 
Ammar Faizi


