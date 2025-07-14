Return-Path: <io-uring+bounces-8659-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D6161B0352F
	for <lists+io-uring@lfdr.de>; Mon, 14 Jul 2025 06:31:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 19B4D18967F7
	for <lists+io-uring@lfdr.de>; Mon, 14 Jul 2025 04:32:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CD0522083;
	Mon, 14 Jul 2025 04:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b="tfCLxowt"
X-Original-To: io-uring@vger.kernel.org
Received: from server-vie001.gnuweeb.org (server-vie001.gnuweeb.org [89.58.62.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37FB3FE7;
	Mon, 14 Jul 2025 04:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.62.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752467511; cv=none; b=GW+15bQaIUkawRDYXqayisKkTTYmVEgvLKnDLoTptD0rEiaxYnkxMH1vNY+87QFd8vwxyebkaODY4UhxTPU1m1Y2uT0En3aLspVcXjwIMm2RuxpQpqg6TPuqRtPJMkjLewh86BfnBxGio1Xu0+tT1gseb31tVrPpVDAWRc83EiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752467511; c=relaxed/simple;
	bh=iscfFbr2KnVMJefjdMlgyEKCL8IpwCFez8S+OTWzQ20=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ty1WP1IDxDSJ9A9DPFppznMnh0nE1UpZaZOcuvZ0kQktphYCbwSoSIRwCVBIijkdgqoU4msQ7KBYc6EDpD4NZRYCOQxGjsjtnIQOXPGiZNq6wn2FHda2LAfcO86cez2EOps9UvWqy7Ezs8y73o/NBh7JekI+RFf7cr58xwL1xuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org; spf=pass smtp.mailfrom=gnuweeb.org; dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b=tfCLxowt; arc=none smtp.client-ip=89.58.62.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnuweeb.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=default; t=1752467098;
	bh=iscfFbr2KnVMJefjdMlgyEKCL8IpwCFez8S+OTWzQ20=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:
	 Content-Transfer-Encoding:Message-ID:Date:From:Reply-To:Subject:To:
	 Cc:In-Reply-To:References:Resent-Date:Resent-From:Resent-To:
	 Resent-Cc:User-Agent:Content-Type:Content-Transfer-Encoding;
	b=tfCLxowtkEV1JtMy8g/Z+gV2CR6DQ470AoOvSxbmFnYCz1ValMixaHyToKc0+70wM
	 Vqi4BFH3zok/or2aLI3O5gi7h3AnS/wc9S25vgLoiGhcDoXn4rjzj69YHTfFMwx5qr
	 KT+gctBNS7qf3Ig4lQO4cIYBxero8VM0RVjepePgU/H8nStzMOTUNnYL9VXEPfmQz/
	 PRJ3Xaq9q+AGEpfa/mZTTEq4fNnWEefd48mVX/mgBH7NL77gw1vAOM3mDRa+t52+f4
	 lmXd7j6qAmGq1DReL4Fh3jt1xLB21afz2/DW3ZMWsU7cE6zFNkhq7JEsJX9AZaeAEN
	 VQQ6ZGfRdMb7g==
Received: from integral2.. (unknown [182.253.126.146])
	by server-vie001.gnuweeb.org (Postfix) with ESMTPSA id E64BF2109A89;
	Mon, 14 Jul 2025 04:24:56 +0000 (UTC)
From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ammar Faizi <ammarfaizi2@gnuweeb.org>,
	io-uring Mailing List <io-uring@vger.kernel.org>,
	GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Khem Raj <raj.khem@gmail.com>,
	Christian Mazakas <christian.mazakas@gmail.com>,
	Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Subject: [GIT PULL liburing] Add musl build-test for GitHub Action Bot
X-Gw-Bpl: wU/cy49Bu1yAPm0bW2qiliFUIEVf+EkEatAboK6pk2H2LSy2bfWlPAiP3YIeQ5aElNkQEhTV9Q==
Date: Mon, 14 Jul 2025 11:24:39 +0700
Message-Id: <20250714042439.3155247-1-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Jens,

Please pull this musl build-test for GitHub action.

Several build issues have been reported by musl libc users when
compiling liburing. These are not isolated incidents, common
problems include:

  1) Missing system headers like <error.h>:
```
    timestamp.c:2:10: fatal error: error.h: No such file or directory
        2 | #include <error.h>
          |          ^~~~~~~~~
    compilation terminated.
```

  2) Undefined types like `cpu_set_t` and `loff_t`, which are available
     under glibc but missing without proper feature macros on musl:
```
    error: unknown type name 'cpu_set_t'
    error: unknown type name 'loff_t'; did you mean 'off_t'
```

These issues are musl-specific and have already led to numerous
commits fixing them, for example:

  e83246aca576 ("t/timestamp: Remove `#include <error.h>` and move `#include <time.h>` to the top")
  afffc0964a90 ("examples/zcrx: remove error.h")
  40cd129ec72c ("ooo-file-unreg.c: Include poll.h instead of sys/poll.h")
  ff0bc26d3220 ("test: Drop including error.h header")
  9485c21f8f36 ("liburing.pc.in: add -D_GNU_SOuRCE to Cflags")
  0fbcc44fe1fb ("examples,test: Remove unused linux/errqueue.h")
  0a9e2268e2a8 ("examples: Use t_error instead of glibc's error.")
  3b0b4976d7da ("test: Use t_error instead of glibc's error.")
  11dc64a71558 ("Add custom error function for tests.")
  45969ce39dc7 ("configure: fix compile-checks for statx")
  c34070e08199 ("liburing.h: define GNU_SOURCE for cpu_set_t")
  43b7ec8d1788 ("build: add -D_GNU_SOURCE to all CPPFLAGS/CFLAGS.")
  1cf969dfcba7 ("examples: disable ucontext-cp if ucontext.h is not available")
  bbf591c6c2d7 ("fix missing '#include <sys/stat.h>' in 'src/include/liburing.h")
  8171778c835b ("fix build on musl libc")

Despite these fixes, the CI pipeline currently only tests against
glibc-based environments. To catch musl regressions early and ensure
broader compatibility, add Alpine Linux (musl libc) build-test to
the CI.

The following changes since commit 9a0461dc82e894aca53246e589b7d6cb880de103:

  test/send_recv: properly return T_EXIT_SKIP (2025-07-11 15:30:27 -0600)

are available in the Git repository at:

  https://github.com/ammarfaizi2/liburing.git tags/gh-bot-musl-build-2025-07-14

for you to fetch changes up to 427dde341dc8c90b6288107325c7fd92353bb0ba:

  github: ci: Add alpine musl build (2025-07-14 11:08:21 +0700)

----------------------------------------------------------------
Pull musl build-test for GitHub Action Bot from Ammar Faizi:

  - Fix test/timestamp.c build error on musl libc env.

  - Add musl build-test for GitHub Action Bot.

----------------------------------------------------------------
Ammar Faizi (2):
      t/timestamp: Remove `#include <error.h>` and move `#include <time.h>` to the top
      github: ci: Add alpine musl build

 .github/workflows/ci.yml | 43 ++++++++++++++++++++++++++++++++++++++++
 test/timestamp.c         | 18 ++++++++---------
 2 files changed, 51 insertions(+), 10 deletions(-)

-- 
Ammar Faizi

