Return-Path: <io-uring+bounces-8789-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EB250B12381
	for <lists+io-uring@lfdr.de>; Fri, 25 Jul 2025 20:05:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0BE66189C37E
	for <lists+io-uring@lfdr.de>; Fri, 25 Jul 2025 18:06:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBDFE285C9A;
	Fri, 25 Jul 2025 18:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b="DOmHRdy/"
X-Original-To: io-uring@vger.kernel.org
Received: from server-vie001.gnuweeb.org (server-vie001.gnuweeb.org [89.58.62.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2573224291A;
	Fri, 25 Jul 2025 18:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.62.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753466748; cv=none; b=r/Dr8FmYI6LDbuBlOxAwyjUMKBz9cK/eHabp03ata7TYrUZQRb14Z56NlHBQ/WbnVRoZ/JZvfdqaurwdD7mUA4qhlDWuNULs/ofQG3Fog8DkjwyyuSm1qNeKBF8yYsN3NV66Mppi9vi3qVC9bcEiULu7bCGUuLE3O38T2f846ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753466748; c=relaxed/simple;
	bh=RpJ1Zs5vjB8aZmRdFkcw2q7ddh7cK/kvpEz43t8mZ+4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KgsTN7M6L0HQQbLYQc7y/IhaQQZoIhvatMWaXHvZHYzNXISZ1UlHf1U+SHiTtBMpBtqSN6D1wmfd5y+e5pJSEvQ7Trhijcsxhyg5+FdacjwzH4uc/01kcAoJyaFUaywmbTnDi7PichAxtAGr2XJ6wJgejOsni9N8NayfOT3QOjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org; spf=pass smtp.mailfrom=gnuweeb.org; dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b=DOmHRdy/; arc=none smtp.client-ip=89.58.62.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnuweeb.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=new2025; t=1753466364;
	bh=RpJ1Zs5vjB8aZmRdFkcw2q7ddh7cK/kvpEz43t8mZ+4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Message-ID:Date:From:
	 Reply-To:Subject:To:Cc:In-Reply-To:References:Resent-Date:
	 Resent-From:Resent-To:Resent-Cc:User-Agent:Content-Type:
	 Content-Transfer-Encoding;
	b=DOmHRdy/6oW42ly2+dMiJ5CK42QUvc+/udeT10Kjw9Ag4KXj8hZwAWt/MqM9J89jC
	 1Sbrmq5bVxvkH038KrZUQM9g1j/8KrUIZ3whplnIxMzaSWCvUwxn5N0517lrdV/bDC
	 mqWuQKPefYyLdt6bYzS1XXiLoaJGz9vjtHzCBB5Vk3EhH4pj3Nt0lZFqaWBdYkdlfd
	 6rEdlPrBFe+ZFJmQN4sT9QNL82Ul3YWLyFN5z2nHlqFeF0Qb3+szYmd7EQHB1clXPx
	 fQLlHjGx/KRMv/z5nCE5L4M6P3iL7C7RU7a5oKXVumeeHQMpw9xuJc856f7YxiTN7p
	 IowXEv+8O+kNg==
Received: from integral2.. (unknown [182.253.126.144])
	by server-vie001.gnuweeb.org (Postfix) with ESMTPSA id 83CD52109AB7;
	Fri, 25 Jul 2025 17:59:22 +0000 (UTC)
From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ammar Faizi <ammarfaizi2@gnuweeb.org>,
	Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
	Christian Mazakas <christian.mazakas@gmail.com>,
	Michael de Lang <michael@volt-software.nl>,
	io-uring Mailing List <io-uring@vger.kernel.org>,
	GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH liburing 1/2] sanitize: Fix missing `IORING_OP_PIPE`
X-Gw-Bpl: wU/cy49Bu1yAPm0bW2qiliFUIEVf+EkEatAboK6pk2H2LSy2bfWlPAiP3YIeQ5aElNkQEhTV9Q==
Date: Sat, 26 Jul 2025 00:59:12 +0700
Message-Id: <20250725175913.2598891-2-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250725175913.2598891-1-ammarfaizi2@gnuweeb.org>
References: <20250725175913.2598891-1-ammarfaizi2@gnuweeb.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix build error due to missing `IORING_OP_PIPE`.

```
 sanitize.c:122:17: error: static assertion failed due to requirement \
 'IORING_OP_WRITEV_FIXED + 1 == IORING_OP_LAST': Need an implementation \
 for all IORING_OP_* codes
  122 |         _Static_assert(IORING_OP_WRITEV_FIXED + 1 == IORING_OP_LAST,\
                               "Need an implementation for all IORING_OP_* codes");
      |                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
```

Fixes: eca641e0ea37 ("Add support for IORING_OP_PIPE")
Cc: Michael de Lang <michael@volt-software.nl>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/sanitize.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/sanitize.c b/src/sanitize.c
index 48f794545999..383b7d64bbf2 100644
--- a/src/sanitize.c
+++ b/src/sanitize.c
@@ -119,7 +119,8 @@ static inline void initialize_sanitize_handlers()
 	sanitize_handlers[IORING_OP_EPOLL_WAIT] = sanitize_sqe_addr;
 	sanitize_handlers[IORING_OP_READV_FIXED] = sanitize_sqe_addr;
 	sanitize_handlers[IORING_OP_WRITEV_FIXED] = sanitize_sqe_addr;
-	_Static_assert(IORING_OP_WRITEV_FIXED + 1 == IORING_OP_LAST, "Need an implementation for all IORING_OP_* codes");
+	sanitize_handlers[IORING_OP_PIPE] = sanitize_sqe_addr;
+	_Static_assert(IORING_OP_PIPE + 1 == IORING_OP_LAST, "Need an implementation for all IORING_OP_* codes");
 	sanitize_handlers_initialized = true;
 }
 
-- 
Ammar Faizi


