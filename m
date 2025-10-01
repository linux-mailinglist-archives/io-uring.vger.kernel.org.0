Return-Path: <io-uring+bounces-9887-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 48CE3BB007C
	for <lists+io-uring@lfdr.de>; Wed, 01 Oct 2025 12:38:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9AD1A19403A6
	for <lists+io-uring@lfdr.de>; Wed,  1 Oct 2025 10:39:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF59029BDBF;
	Wed,  1 Oct 2025 10:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b="V3z8i8o3"
X-Original-To: io-uring@vger.kernel.org
Received: from server-vie001.gnuweeb.org (server-vie001.gnuweeb.org [89.58.62.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1590824A051;
	Wed,  1 Oct 2025 10:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.62.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759315115; cv=none; b=sZ4+OkpJnXZofeMGAQyI2Bq/WelEquSJpmiEpDe/+oVipygDjypbtOY3d81nIFGl3oU8fjfLIvZY6udR20S/7lmM5EmjKsLB0x6TddIXTj1W9VBGSqpCOAg1Bt2UCIOoo8zuMhFbfrTUCW+bezzm5Lkn3+CuR9jIOl41zPZtVig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759315115; c=relaxed/simple;
	bh=poJwsjldxPN02UpyCS99Meg7MHiIEXO5cTadWf7egdM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jWI72ddkV6ccz0aCH4272RlPZTGMJBvijkH5IkEfzjzRMmadmHBxUmlfnSMdDUUp9ZiI56CNAh/oPLHuI+t/JBTs2e5YlXOsK9gYEuAjuEhe+5CYdZOBix72yyf3rBG45a+nvoVjoVX/vMAtjATkJ5x0+F9JKu+3wIcdxuYXG38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org; spf=pass smtp.mailfrom=gnuweeb.org; dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b=V3z8i8o3; arc=none smtp.client-ip=89.58.62.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnuweeb.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=new2025; t=1759315106;
	bh=poJwsjldxPN02UpyCS99Meg7MHiIEXO5cTadWf7egdM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:
	 Content-Transfer-Encoding:Message-ID:Date:From:Reply-To:Subject:To:
	 Cc:In-Reply-To:References:Resent-Date:Resent-From:Resent-To:
	 Resent-Cc:User-Agent:Content-Type:Content-Transfer-Encoding;
	b=V3z8i8o3GuNfdAV8ip7PjU5udbRYSfauaNV/LUpTg8Z+qB7Db64QjVP3sppsWwzGC
	 8sky4xBoaP3qzrRm5U553Zjr7JfAeRCXqylcB+6q+q8Uutd/qaDMtl9bxb01W+54VW
	 oRSd1nlzMaOQPQvcioU5smcIhr+8OLQu8yA1J1eFf+zqEbSO9ky4OpKVm/UYDKuNKB
	 8EwwZb1Cs8rL+WPVgRGzaFUwspdF7nxzA5CGmtqhJ0WQMPu/sRfqdzYUVdbFTHDnMq
	 gQEvb+QiuyKPh63m/7uf1Lv4FLhFavvjqWe0OaU1QD07I18iaRcHihUToDkXGwfA+N
	 TJPQ+1Qten0Sg==
Received: from integral2.. (unknown [182.253.126.153])
	by server-vie001.gnuweeb.org (Postfix) with ESMTPSA id 77DBE312793F;
	Wed,  1 Oct 2025 10:38:23 +0000 (UTC)
From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ammar Faizi <ammarfaizi2@gnuweeb.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	io-uring Mailing List <io-uring@vger.kernel.org>,
	Romain Pereira <rpereira@anl.gov>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Christian Mazakas <christian.mazakas@gmail.com>
Subject: [PATCH liburing] github: Test build against the installed liburing
X-Gw-Bpl: wU/cy49Bu1yAPm0bW2qiliFUIEVf+EkEatAboK6pk2H2LSy2bfWlPAiP3YIeQ5aElNkQEhTV9Q==
Date: Wed,  1 Oct 2025 17:38:03 +0700
Message-Id: <20251001103803.1423513-1-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When adding a new header file, the author might forget to add it to the
installation path in the Makefile.

For example, commit 7e565c0116ba ("tests: test the query interface"),
introduced an include to the query.h file via liburing.h, but the
query.h file was not added to the installation entry, which resulted
in the following error:

  In file included from a.c:1:
  /usr/include/liburing.h:19:10: fatal error: liburing/io_uring/query.h: No such file or directory
     19 | #include "liburing/io_uring/query.h"
        |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~
  compilation terminated.

This kind of breakage is only caught by the liburing that's installed
in the system. Make sure the GitHub CI covers it so we can catch the
breakage earlier before a new release is tagged and distributed.

Thanks to Romain Pereira for reporting the issue on GitHub!

Link: https://github.com/axboe/liburing/issues/1470
Cc: Romain Pereira <rpereira@anl.gov>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: Christian Mazakas <christian.mazakas@gmail.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 .github/workflows/ci.yml       | 18 ++++++++++++++++++
 .github/workflows/test_build.c |  9 +++++++++
 2 files changed, 27 insertions(+)
 create mode 100644 .github/workflows/test_build.c

diff --git a/.github/workflows/ci.yml b/.github/workflows/ci.yml
index 3c9a10d4e147..1056bdf41985 100644
--- a/.github/workflows/ci.yml
+++ b/.github/workflows/ci.yml
@@ -196,6 +196,17 @@ jobs:
         run: |
           sudo make install;
 
+      - name: Test build against the installed liburing
+        run: |
+          export TEST_FILE=".github/workflows/test_build.c";
+          if [ "$SANITIZE" -eq "1" ]; then
+            export SANITIZE_FLAGS="-fsanitize=address,undefined";
+          else
+            export SANITIZE_FLAGS="";
+          fi;
+          ${{matrix.build_args.cc}} -x c -o a.out $TEST_FILE -luring $SANITIZE_FLAGS;
+          ${{matrix.build_args.cxx}} -x c++ -o a.out $TEST_FILE -luring $SANITIZE_FLAGS;
+
 
   alpine-musl-build:
     needs: get_commit_list
@@ -239,6 +250,13 @@ jobs:
         run: |
           make install;
 
+      - name: Test build against the installed liburing
+        shell: alpine.sh {0}
+        run: |
+          export TEST_FILE=".github/workflows/test_build.c";
+          gcc -x c -o a.out $TEST_FILE -luring;
+          g++ -x c++ -o a.out $TEST_FILE -luring;
+
 
   codespell:
     needs: get_commit_list
diff --git a/.github/workflows/test_build.c b/.github/workflows/test_build.c
new file mode 100644
index 000000000000..a94fcdceef22
--- /dev/null
+++ b/.github/workflows/test_build.c
@@ -0,0 +1,9 @@
+#include <liburing.h>
+
+int main(void)
+{
+	struct io_uring ring;
+	io_uring_queue_init(8, &ring, 0);
+	io_uring_queue_exit(&ring);
+	return 0;
+}
-- 
Ammar Faizi


