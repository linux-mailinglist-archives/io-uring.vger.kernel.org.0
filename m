Return-Path: <io-uring+bounces-290-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 151098186B4
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 12:54:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BE9331F221EC
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 11:54:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D355319472;
	Tue, 19 Dec 2023 11:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b="HWkkh4vr"
X-Original-To: io-uring@vger.kernel.org
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083BB1945A;
	Tue, 19 Dec 2023 11:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnuweeb.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=default; t=1702986884;
	bh=j+wxOJKysLJtxssC5f5pcx0mS7BYxK5ouYe5Yr9Td0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HWkkh4vr6JXf2pljVT8oEgbxkj9gNAtQaTg4pys1+oly4EaCKWPO8dtJT5v9VHhK4
	 8MkGSXHeJIJS8XkGeT89x+Cb1QorrPIi4rdfFYmoY5rV9R8VPgiisPMyM06cJVWbTO
	 UHOmAK0au79HIoL9a4bdtivRFLF5C6hye3T73rcuq6zxZxeOVBNwxLPbZumm8XXmO1
	 PdFhm1S19U2UDWT1WqRDpGoX8Cp1aqdA11ZMHTUX0Jj+/Cv95g5of+nBvMoA6gV5cR
	 zmScKje6OBBaPYTFj8Wjy12yKxzb6/e5rPJA3i/jYkZW2hSJ2nmIU9zGW28tV9MJa5
	 4jnTn5mavuR1Q==
Received: from localhost.localdomain (unknown [182.253.230.19])
	by gnuweeb.org (Postfix) with ESMTPSA id 9EE6B24BCE9;
	Tue, 19 Dec 2023 18:54:41 +0700 (WIB)
From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ammar Faizi <ammarfaizi2@gnuweeb.org>,
	Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
	Michael William Jonathan <moe@gnuweeb.org>,
	io-uring Mailing List <io-uring@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v1 2/2] t/no-mmap-inval: Replace `valloc()` with `t_posix_memalign()`
Date: Tue, 19 Dec 2023 18:54:23 +0700
Message-Id: <20231219115423.222134-3-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231219115423.222134-1-ammarfaizi2@gnuweeb.org>
References: <20231219115423.222134-1-ammarfaizi2@gnuweeb.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Address the limitations of valloc(). This function, which is primarily
used for allocating page-aligned memory, is not only absent in some
systems but is also marked as obsolete according to the `man 3 valloc`.

Replace valloc() with t_posix_memalign() to fix the following build
error:

  no-mmap-inval.c:28:56: warning: call to undeclared function 'valloc'; ISO C99 and \
  later do not support implicit function declarations [-Wimplicit-function-declaration]
          p.cq_off.user_addr = (unsigned long long) (uintptr_t) valloc(8192);
                                                                ^
  1 warning generated.

  ld.lld: error: undefined symbol: valloc
  >>> referenced by no-mmap-inval.c:28
  >>>               /tmp/no-mmap-inval-ea16a2.o:(main)
  >>> did you mean: calloc
  >>> defined in: /system/lib64/libc.so
  clang-15: error: linker command failed with exit code 1 (use -v to see invocation)
  make[1]: *** [Makefile:239: no-mmap-inval.t] Error 1

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 test/no-mmap-inval.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/test/no-mmap-inval.c b/test/no-mmap-inval.c
index 9571fee0035ac5ce..244d4eb645115a44 100644
--- a/test/no-mmap-inval.c
+++ b/test/no-mmap-inval.c
@@ -20,12 +20,14 @@ int main(int argc, char *argv[])
 		.flags		= IORING_SETUP_NO_MMAP,
 	};
 	struct io_uring ring;
+	void *addr;
 	int ret;
 
 	if (argc > 1)
 		return T_EXIT_SKIP;
 
-	p.cq_off.user_addr = (unsigned long long) (uintptr_t) valloc(8192);
+	t_posix_memalign(&addr, sysconf(_SC_PAGESIZE), 8192);
+	p.cq_off.user_addr = (unsigned long long) (uintptr_t) addr;
 
 	ret = io_uring_queue_init_params(2, &ring, &p);
 	if (ret == -EINVAL) {
-- 
Ammar Faizi


