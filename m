Return-Path: <io-uring+bounces-8699-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 62505B07882
	for <lists+io-uring@lfdr.de>; Wed, 16 Jul 2025 16:48:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BFFC11C22470
	for <lists+io-uring@lfdr.de>; Wed, 16 Jul 2025 14:48:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B00E52F4304;
	Wed, 16 Jul 2025 14:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b="GG78rQB3"
X-Original-To: io-uring@vger.kernel.org
Received: from server-vie001.gnuweeb.org (server-vie001.gnuweeb.org [89.58.62.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6FEE2673A5;
	Wed, 16 Jul 2025 14:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.62.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752677179; cv=none; b=WcWdngG373cf+wDwhsjLxnp2lOqcQ4IgPQFtDhX6eOSiaLWRaT8Fk8qytWHqN7elLpXmkJtlUd4rnpgpI9IjdjumejA4lU5aiQztUaYb3wwSvTHYiHG0NeOD5erQqvUT/3OqUCqkoYhcJQDjG5X5GmAaFopJLBzmANBYtKoAF/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752677179; c=relaxed/simple;
	bh=90oUzGeS1sxmgNEXlih3PNWaFw37jnsYtrSwVVPyoEc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=WHLv0CWwu+3rt+lopH7B0Lf6aOF2ld8qvNACC72IHYo2+ej5KNJvT2rilfq06F1FCnga0y+/LgN7aePqSfsDoUiUs8zoGgvHsc6vr6+YzhmntaCLFB67ROcG18hKn8i8eyvP/Mzjlv50klNQaM7lNN/BvmuPLRvIrKdM4msz+Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org; spf=pass smtp.mailfrom=gnuweeb.org; dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b=GG78rQB3; arc=none smtp.client-ip=89.58.62.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnuweeb.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=default; t=1752677176;
	bh=90oUzGeS1sxmgNEXlih3PNWaFw37jnsYtrSwVVPyoEc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:
	 Content-Transfer-Encoding:Message-ID:Date:From:Reply-To:Subject:To:
	 Cc:In-Reply-To:References:Resent-Date:Resent-From:Resent-To:
	 Resent-Cc:User-Agent:Content-Type:Content-Transfer-Encoding;
	b=GG78rQB3mnsDPQMFvOXFkdx6/qvPt0al0ctjGh/1FtRY8nYyxqIn9GD4TiC6iTRZ7
	 BxBRAW7C8sV2pYIkgKzzFgxaDg5tia5yPJAhhrVtRMY54JTyt3vTbvNzZeFwH2VAVR
	 BE22OjJPU+vJ3QF4T50P5pb/iHzz5NGEaeym/mgO02K1BNMh8bA/sLMxRNFQaOIZnM
	 KDsCGguNbopUW3/b7b+wn23wEpIWiHEj7nHyXutSSe5w33VCNQLYHTrAXe2izgwOzQ
	 +Ic0YU63t+287iVSu+1Twc3I2i7/yiKQuvjPhEjBxrsRKP1mTFWoOsygnRZmS2Yvun
	 ZTrIMSotiMABA==
Received: from localhost.localdomain (unknown [68.183.184.174])
	by server-vie001.gnuweeb.org (Postfix) with ESMTPSA id 82E4E2109A94;
	Wed, 16 Jul 2025 14:46:14 +0000 (UTC)
From: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
	Ammar Faizi <ammarfaizi2@gnuweeb.org>,
	GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	io-uring Mailing List <io-uring@vger.kernel.org>
Subject: [PATCH liburing v3] Bring back `CONFIG_HAVE_MEMFD_CREATE` to fix Android build error
X-Gw-Bpl: wU/cy49Bu1yAPm0bW2qiliFUIEVf+EkEatAboK6pk2H2LSy2bfWlPAiP3YIeQ5aElNkQEhTV9Q==
Date: Wed, 16 Jul 2025 21:46:10 +0700
Message-Id: <20250716144610.3938579-1-alviro.iskandar@gnuweeb.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 732bf609b670 ("test/io_uring_register: kill old memfd test")
removed the `CONFIG_HAVE_MEMFD_CREATE`, which was previously used to
conditionally provide `memfd_create()` for an old test in
`test/io_uring_register.c`.

Reintroduce `CONFIG_HAVE_MEMFD_CREATE` to resolve Android build error
caused by commit:

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
Then, provide memfd_create() in examples/ if `CONFIG_HAVE_MEMFD_CREATE`
is not set to fix the build error.

v2 -> v3:
  - Don't bother touching the test/ dir.
    Link: https://lore.kernel.org/io-uring/3b28fddb-2171-4f2f-9729-0c0ed14d20cc@kernel.dk

v1 -> v2:
  - Omit the old memfd test because it's not needed anymore.
    Link: https://lore.kernel.org/io-uring/4bc75566-9cb5-42ec-a6b7-16e04062e0c6@kernel.dk

Co-authored-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
---
 configure          | 19 +++++++++++++++++++
 examples/helpers.c |  8 ++++++++
 examples/helpers.h |  5 +++++
 3 files changed, 32 insertions(+)

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

base-commit: aa9a6b701aa65b575412476d35e813e48119fe23
-- 
Alviro Iskandar Setiawan


