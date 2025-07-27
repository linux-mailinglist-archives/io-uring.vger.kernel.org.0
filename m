Return-Path: <io-uring+bounces-8793-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E12ACB12D37
	for <lists+io-uring@lfdr.de>; Sun, 27 Jul 2025 02:43:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9839B17AD75
	for <lists+io-uring@lfdr.de>; Sun, 27 Jul 2025 00:43:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4F104086A;
	Sun, 27 Jul 2025 00:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b="wjMlhRzB"
X-Original-To: io-uring@vger.kernel.org
Received: from server-vie001.gnuweeb.org (server-vie001.gnuweeb.org [89.58.62.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142EC29D0E;
	Sun, 27 Jul 2025 00:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.62.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753577025; cv=none; b=c2VpSXe9yz7hBoGtRFxzCUO6AgBiuZxtAxN9Q6AeEvptV4xMHXn6Dps+382ONRGQkmYgONc7X9yIqB5spjEUCYx68O2tkIlJNt4U58e7vmUH0zrkuVO+qAuVG2UDjeJEge0xIoxh6ntbBjgxnTbc7ccszpW0Oo/fqnYa7ENyUV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753577025; c=relaxed/simple;
	bh=fQEtNqEHIesEawF/VNyCeFOve8UBkyQyLxZfH6rKsLk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RRNKZujFvHXifx/q2+Ejt0YVuwT43gNV1XKR4bNguj3kz31tuAiIQuKUSqugwknZ/ZUOuqTHgtmHhVhpT8jfth0I9P4HPxh6HJjskP0USi0l+fPa25fxEPn9+2G2n7UAaKsuEhaO3cz4DSnyKn/zR/XzTXyKZU6uSuLYIt4JtPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org; spf=pass smtp.mailfrom=gnuweeb.org; dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b=wjMlhRzB; arc=none smtp.client-ip=89.58.62.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnuweeb.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=new2025; t=1753577020;
	bh=fQEtNqEHIesEawF/VNyCeFOve8UBkyQyLxZfH6rKsLk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Message-ID:Date:From:
	 Reply-To:Subject:To:Cc:In-Reply-To:References:Resent-Date:
	 Resent-From:Resent-To:Resent-Cc:User-Agent:Content-Type:
	 Content-Transfer-Encoding;
	b=wjMlhRzB9eW1Z89Q2581hW5ILdNvkg17kvWs1d2/wfKvelLa7NWCCrBYSyiQZUXp2
	 fT9SxIpNsR+rNwIP7xLuresMAscopL58KAOvc+br3S0Q2FybvNnNxbgTAkgpS2sgRI
	 bxeDbW9PJvYd5TTehonM1mrMOoiPRn0dg9AuJN23nKDTyLgJjTJn6oPJQF5PWnYYRp
	 w3jxzS8SMdiN4452Ae5Db7LePeaOsl0r4zljOgXFzY5vC/07YvjytWs/JopqM3kxL4
	 cQzv1pPKhiGENEgL8m3IvmQZ640uF4AkyYSw/N1iSSbH7HKfbHZGVknx5hHaxN1snk
	 MTFfoq4BAuHaA==
Received: from integral2.. (unknown [182.253.126.144])
	by server-vie001.gnuweeb.org (Postfix) with ESMTPSA id 926863126E07;
	Sun, 27 Jul 2025 00:43:38 +0000 (UTC)
From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ammar Faizi <ammarfaizi2@gnuweeb.org>,
	Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
	GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
	Christian Mazakas <christian.mazakas@gmail.com>,
	io-uring Mailing List <io-uring@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH liburing 3/3] liburing: Don't use `IOURINGINLINE` on private helpers
X-Gw-Bpl: wU/cy49Bu1yAPm0bW2qiliFUIEVf+EkEatAboK6pk2H2LSy2bfWlPAiP3YIeQ5aElNkQEhTV9Q==
Date: Sun, 27 Jul 2025 07:43:16 +0700
Message-Id: <20250727004316.3351033-4-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250727004316.3351033-1-ammarfaizi2@gnuweeb.org>
References: <20250727004316.3351033-1-ammarfaizi2@gnuweeb.org>
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
  __io_uring_buf_ring_cq_advance

are not exported for FFI. Don't use `IOURINGINLINE` on them.

Cc: Christian Mazakas <christian.mazakas@gmail.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/include/liburing.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 83434f6eca65..6f415c12c38b 100644
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
@@ -1883,7 +1883,7 @@ IOURINGINLINE void io_uring_buf_ring_advance(struct io_uring_buf_ring *br,
 	io_uring_smp_store_release(&br->tail, new_tail);
 }
 
-IOURINGINLINE void __io_uring_buf_ring_cq_advance(struct io_uring *ring,
+static inline void __io_uring_buf_ring_cq_advance(struct io_uring *ring,
 						  struct io_uring_buf_ring *br,
 						  int cq_count, int buf_count)
 	LIBURING_NOEXCEPT
-- 
Ammar Faizi


