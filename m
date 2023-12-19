Return-Path: <io-uring+bounces-291-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A0DA8186DB
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 13:01:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C5414B2385A
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 12:01:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C320618E18;
	Tue, 19 Dec 2023 12:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b="pD+ybuFa"
X-Original-To: io-uring@vger.kernel.org
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5294618E15;
	Tue, 19 Dec 2023 12:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnuweeb.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=default; t=1702986877;
	bh=6y7QcMNqdf/KzxtBMRwl6JBNpcXBvZAGKI4OW6AiOww=;
	h=From:To:Cc:Subject:Date;
	b=pD+ybuFaLCHla+Xm8wAgMyEK5gI/x5SO96VdrCCQ/4lOTx/nw8I/t1HxZ5pk9CXuT
	 YVz1SR6nR9AImqcJWVILoePxd3wsaW36909Cgh8fkpmMs6dqa75fHKccbXrsASRCoU
	 5MV6dbpPUQ0FUOrKwFD0bBCYjM/14C8w2wQlYJH3vQDkJxK5V7Kp5VSUHz3iQfQv/P
	 EsRS9w18Xb/Ype+DNYcctNnE+lkPWHSDqF57feR3Kul4GcGFD6iZ2BvHUPbDrF6aJL
	 zu6eZR1heA06QblvA3ElBTaHvI9ZbtGx5Atn9zGIF3BMpURulPF3MVlcNy37I6x+AZ
	 z5HG1iLqpA4cw==
Received: from localhost.localdomain (unknown [182.253.230.19])
	by gnuweeb.org (Postfix) with ESMTPSA id 1D1C724C190;
	Tue, 19 Dec 2023 18:54:33 +0700 (WIB)
From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ammar Faizi <ammarfaizi2@gnuweeb.org>,
	Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
	Michael William Jonathan <moe@gnuweeb.org>,
	io-uring Mailing List <io-uring@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v1 0/2] Makefile and t/no-mmap-inval updates
Date: Tue, 19 Dec 2023 18:54:21 +0700
Message-Id: <20231219115423.222134-1-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Jens,

There are two patches in this series:

1. Makefile: Remove the `partcheck` target.

Remove the `partcheck` target because it has remained unused for nearly
four years, and the associated TODO comment has not been actioned since
its introduction in commit:

  b57dbc2d308a849 ("configure/Makefile: introduce libdevdir defaults to $(libdir)")


2. t/no-mmap-inval: Replace `valloc()` with `t_posix_memalign()`.

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
Ammar Faizi (2):
  Makefile: Remove the `partcheck` target
  t/no-mmap-inval: Replace `valloc()` with `t_posix_memalign()`

 Makefile             | 3 ---
 test/no-mmap-inval.c | 4 +++-
 2 files changed, 3 insertions(+), 4 deletions(-)


base-commit: bbd27495d302856b1f28d64b346d3ad80be3a86f
-- 
Ammar Faizi


