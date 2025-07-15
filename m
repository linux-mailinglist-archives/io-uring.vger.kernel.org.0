Return-Path: <io-uring+bounces-8675-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 33121B05093
	for <lists+io-uring@lfdr.de>; Tue, 15 Jul 2025 07:06:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 617D73B2030
	for <lists+io-uring@lfdr.de>; Tue, 15 Jul 2025 05:06:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6F17281368;
	Tue, 15 Jul 2025 05:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b="VwPXuDtp"
X-Original-To: io-uring@vger.kernel.org
Received: from server-vie001.gnuweeb.org (server-vie001.gnuweeb.org [89.58.62.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB5A258CF2;
	Tue, 15 Jul 2025 05:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.62.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752556005; cv=none; b=Q4Onn8a4KtkTQ7DJTClBz12pkCtQM4DDTRHOvU07AjeDj1RVF9i9RBvNUB2tWvq5OhhSo43kSpHNskm99aEi1H9c1ERQwoYXcQyXcEmF4kBUnB/aKvMwphMheASZStToO5Nt/sRWFmVC38anrwqOZ7NRKuGkQa2fJwZXDjJ/aNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752556005; c=relaxed/simple;
	bh=soufQIX6TYMmC/348jS3xW4pvirGNiNwAJl7GhmX8LY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n3SR/hvHN5Tq20cAXokwtLAY2HOrMIs8P8YrqAuv3LKK/hrw+dfMsuvNPSznCpWJ3LzgoIP/7McmVsgXTXPMMLxx9XFTlKD2/fPuYSoHLO0Ni2VbQjbkMF5T5gdHUZRcxNupgCEL3Vhdt2F7wsohixllJ5f6Pg5/LTXiHzr06qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org; spf=pass smtp.mailfrom=gnuweeb.org; dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b=VwPXuDtp; arc=none smtp.client-ip=89.58.62.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnuweeb.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=default; t=1752555996;
	bh=soufQIX6TYMmC/348jS3xW4pvirGNiNwAJl7GhmX8LY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Message-ID:Date:From:
	 Reply-To:Subject:To:Cc:In-Reply-To:References:Resent-Date:
	 Resent-From:Resent-To:Resent-Cc:User-Agent:Content-Type:
	 Content-Transfer-Encoding;
	b=VwPXuDtp0zGuGgujQQNYxkzW6Z55i4yLmNobzT1hpwnIJLeU99Vm+JJOzmXBV6clL
	 gTDlykdvM0dahSdZol+9NMFLK4oznNOEk/YKWyBJ46v0xJQJM5y7785YYqajOPquIu
	 FMX+WNod3MSJGwfTtZeLaqtWmN74vo+zpOKUdkUSjik5K8VyI3QbOJf2SU72N/2caE
	 30Oj9MV13eECqJVATyXnk1K0fDnvesHFP4b3rhJQugVqAPLyxTvgzPBMmxfZ6PSBZG
	 SP/79UhSKkcDYJwC+WSJIKVVD/VRg0HgPV+VSkAJ8FALlVyffQGQKMJ2W3V/JwBN60
	 A3T73aUQZqA8w==
Received: from server-vie001.gnuweeb.org (unknown [192.168.57.1])
	by server-vie001.gnuweeb.org (Postfix) with ESMTPSA id 6D31D2109A3B;
	Tue, 15 Jul 2025 05:06:36 +0000 (UTC)
From: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	io-uring Mailing List <io-uring@vger.kernel.org>,
	GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
	Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH liburing 3/3] examples: Add `memfd_create()` helper
X-Gw-Bpl: wU/cy49Bu1yAPm0bW2qiliFUIEVf+EkEatAboK6pk2H2LSy2bfWlPAiP3YIeQ5aElNkQEhTV9Q==
Date: Tue, 15 Jul 2025 12:06:29 +0700
Message-Id: <20250715050629.1513826-4-alviro.iskandar@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250715050629.1513826-1-alviro.iskandar@gnuweeb.org>
References: <20250715050629.1513826-1-alviro.iskandar@gnuweeb.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add `memfd_create()` helper to handle missing defintion on an environment
where `CONFIG_HAVE_MEMFD_CREATE` is not defined.

Co-authored-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
---
 examples/helpers.c | 8 ++++++++
 examples/helpers.h | 5 +++++
 2 files changed, 13 insertions(+)

diff --git a/examples/helpers.c b/examples/helpers.c
index 483ddee..8c112f1 100644
--- a/examples/helpers.c
+++ b/examples/helpers.c
@@ -13,6 +13,14 @@
 
 #include "helpers.h"
 
+#ifndef CONFIG_HAVE_MEMFD_CREATE
+#include <sys/syscall.h>
+int memfd_create(const char *name, unsigned int flags)
+{
+	return (int)syscall(SYS_memfd_create, name, flags);
+}
+#endif
+
 int setup_listening_socket(int port, int ipv6)
 {
 	struct sockaddr_in srv_addr = { };
diff --git a/examples/helpers.h b/examples/helpers.h
index 44543e1..0b6f15f 100644
--- a/examples/helpers.h
+++ b/examples/helpers.h
@@ -17,4 +17,9 @@ void *t_aligned_alloc(size_t alignment, size_t size);
 
 void t_error(int status, int errnum, const char *format, ...);
 
+#ifndef CONFIG_HAVE_MEMFD_CREATE
+#include <linux/memfd.h>
+#endif
+int memfd_create(const char *name, unsigned int flags);
+
 #endif
-- 
Alviro Iskandar Setiawan


