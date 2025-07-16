Return-Path: <io-uring+bounces-8690-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 75F07B06AAE
	for <lists+io-uring@lfdr.de>; Wed, 16 Jul 2025 02:44:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EC928189E989
	for <lists+io-uring@lfdr.de>; Wed, 16 Jul 2025 00:44:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39BC314A09C;
	Wed, 16 Jul 2025 00:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b="RjED+O0s"
X-Original-To: io-uring@vger.kernel.org
Received: from server-vie001.gnuweeb.org (server-vie001.gnuweeb.org [89.58.62.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807C9136358;
	Wed, 16 Jul 2025 00:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.62.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752626653; cv=none; b=hiliZNIq4TjmoDg2Y87IKLUDb2CfCe2TQWQzoGeuwyFq3lCOqDTHbEAoCe2Q4oD5XJ3nE8w4av7G6o/LETUvD/HmTqgrMVdZB2srLxlFN82Jk1+pmWni8OmVSvj5PhTuwvekErmLeVAIZK+BdVjizs65azNuNnTydGh2NtP/edI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752626653; c=relaxed/simple;
	bh=qXPJQIFiRfArJHI2hJxIyZic9JZJqME6xG9/pMC8ThU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=L6J0nljL8sCrVutdDQXv7fgV2wsCgtldDcIn7kdjeq3i2GV8C00peQj3NoVeH8Xp7z4MnV5nlquAPRFqwDkHe1ySex73IIWOPEga7Kkc0AqfEmYHiiqZFOhc+xnxMVITaPC9k4BMbAYUboD9aqe1P58a7UJg3a5qqs4dvio607w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org; spf=pass smtp.mailfrom=gnuweeb.org; dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b=RjED+O0s; arc=none smtp.client-ip=89.58.62.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnuweeb.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=default; t=1752626649;
	bh=qXPJQIFiRfArJHI2hJxIyZic9JZJqME6xG9/pMC8ThU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Message-ID:Date:From:
	 Reply-To:Subject:To:Cc:In-Reply-To:References:Resent-Date:
	 Resent-From:Resent-To:Resent-Cc:User-Agent:Content-Type:
	 Content-Transfer-Encoding;
	b=RjED+O0siu7WCt2PBzBZ1GMardXfqmI+Vts0SpGVckygqHgOMzalWSTkk9IE+C65r
	 TmZvfq3M9ydn5jRskQ3PzY3rNNsCZQnpLHaVJLxbKmF3UVZz+BazoXDXhn5lNlHjJr
	 4GWQRGhxAwrga6FDxv+y1ThDoU1oGoGCDs5nHnOk7g9X+I8zlcTSI/S6VdvS+30zs/
	 eAcRagUNVu1ywPkgdlO/G/fh9z3+MLQPssUuIayyc8eM1CSS2Yw+fGjWCT0UUs6ecx
	 GKvKcOBn42dk3QHAjSGYQvM3dH+vUQAyVv4BBle2iI//ghdbbLwID2F6dgIg2AKbP1
	 1opDovSSIz9Mw==
Received: from localhost.localdomain (unknown [68.183.184.174])
	by server-vie001.gnuweeb.org (Postfix) with ESMTPSA id 24DA02109A7C;
	Wed, 16 Jul 2025 00:44:07 +0000 (UTC)
From: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
	Ammar Faizi <ammarfaizi2@gnuweeb.org>,
	GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	io-uring Mailing List <io-uring@vger.kernel.org>
Subject: [PATCH liburing v2 1/3] Bring back `CONFIG_HAVE_MEMFD_CREATE` to fix Android build error
X-Gw-Bpl: wU/cy49Bu1yAPm0bW2qiliFUIEVf+EkEatAboK6pk2H2LSy2bfWlPAiP3YIeQ5aElNkQEhTV9Q==
Date: Wed, 16 Jul 2025 07:44:00 +0700
Message-Id: <20250716004402.3902648-2-alviro.iskandar@gnuweeb.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250716004402.3902648-1-alviro.iskandar@gnuweeb.org>
References: <20250716004402.3902648-1-alviro.iskandar@gnuweeb.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This partially reverts commit:

  732bf609b670 ("test/io_uring_register: kill old memfd test")

Bring back `CONFIG_HAVE_MEMFD_CREATE` to resolve Android build failures
caused by:

  93d3a7a70b4a ("examples/zcrx: udmabuf backed areas")

It added a call to `memfd_create()`, which is unavailable on some
Android toolchains, leading to the following build error:

```
  zcrx.c:111:10: error: call to undeclared function 'memfd_create'; ISO C99 and \
  later do not support implicit function declarations \
  [-Wimplicit-function-declaration]
    111 |         memfd = memfd_create("udmabuf-test", MFD_ALLOW_SEALING);
        |                 ^
```

This reversion is a preparation patch for a proper fix by ensuring
`memfd_create()` usage is guarded and portable. It's only a partial
revert because the test itself is not restored.

v1 -> v2:
  - Omit the old memfd test because it's not needed anymore.
    Link: https://lore.kernel.org/io-uring/4bc75566-9cb5-42ec-a6b7-16e04062e0c6@kernel.dk

Co-authored-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
---
 configure                | 19 +++++++++++++++++++
 test/io_uring_register.c | 11 +++++++++++
 2 files changed, 30 insertions(+)

diff --git a/configure b/configure
index 552f8ae..3c95214 100755
--- a/configure
+++ b/configure
@@ -379,6 +379,22 @@ if compile_prog "" "" "has_ucontext"; then
 fi
 print_config "has_ucontext" "$has_ucontext"
 
+##########################################
+# check for memfd_create(2)
+has_memfd_create="no"
+cat > $TMPC << EOF
+#include <sys/mman.h>
+int main(int argc, char **argv)
+{
+  int memfd = memfd_create("test", 0);
+  return 0;
+}
+EOF
+if compile_prog "-Werror=implicit-function-declaration" "" "has_memfd_create"; then
+  has_memfd_create="yes"
+fi
+print_config "has_memfd_create" "$has_memfd_create"
+
 ##########################################
 # Check NVME_URING_CMD support
 nvme_uring_cmd="no"
@@ -539,6 +555,9 @@ fi
 if test "$array_bounds" = "yes"; then
   output_sym "CONFIG_HAVE_ARRAY_BOUNDS"
 fi
+if test "$has_memfd_create" = "yes"; then
+  output_sym "CONFIG_HAVE_MEMFD_CREATE"
+fi
 if test "$nvme_uring_cmd" = "yes"; then
   output_sym "CONFIG_HAVE_NVME_URING"
 fi
diff --git a/test/io_uring_register.c b/test/io_uring_register.c
index b53a67d..405a812 100644
--- a/test/io_uring_register.c
+++ b/test/io_uring_register.c
@@ -32,6 +32,17 @@ static int pagesize;
 static rlim_t mlock_limit;
 static int devnull;
 
+#if !defined(CONFIG_HAVE_MEMFD_CREATE)
+#include <sys/syscall.h>
+#include <linux/memfd.h>
+
+int memfd_create(const char *name, unsigned int flags)
+{
+	return (int)syscall(SYS_memfd_create, name, flags);
+}
+#endif
+
+
 static int expect_fail(int fd, unsigned int opcode, void *arg,
 		       unsigned int nr_args, int error, int error2)
 {
-- 
Alviro Iskandar Setiawan


