Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65CDF29D5B4
	for <lists+io-uring@lfdr.de>; Wed, 28 Oct 2020 23:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730220AbgJ1WIJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Oct 2020 18:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730197AbgJ1WIG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Oct 2020 18:08:06 -0400
X-Greylist: delayed 1135 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 28 Oct 2020 15:08:06 PDT
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72567C0613CF
        for <io-uring@vger.kernel.org>; Wed, 28 Oct 2020 15:08:06 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bl4ckb0ne.ca;
        s=default; t=1603852327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=qa9OmO1zHhA3QVBqXMzbDyR15+9T0jPYgyajqAc6iSc=;
        b=b5hRcu8eSPKXz+Cn2t0KJVgpswOOuQa0AurvQQmus9dz3Xc63PI5CAM++i+dYNrCYnCuZA
        bij7hDYU4uun6vFcQe821MlmQ9Vs9Yv3OofZvtnyVY6JBKqMh5ETmm29CulohvQ+4elbmu
        vZ0ZP62mlaSwH686FaINilgoQyJpDIk=
From:   Simon Zeni <simon@bl4ckb0ne.ca>
To:     io-uring@vger.kernel.org
Cc:     Simon Zeni <simon@bl4ckb0ne.ca>
Subject: [PATCH] examples: disable ucontext-cp if ucontext.h is not available
Date:   Tue, 27 Oct 2020 22:31:21 -0400
Message-Id: <20201028023120.24509-1-simon@bl4ckb0ne.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: 0.00
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The header file `ucontext.h` is not available on musl based distros. The
example `ucontext-cp` is not built if `configure` fails to locate the
header.

Signed-off-by: Simon Zeni <simon@bl4ckb0ne.ca>
---

See [this mail][1] from the musl mailing list about why those functions
are not implemented

I also noticed that `make runtests` fails on alpinelinux (5.4.72-0-lts
with musl-1.2.1)

```
Tests failed:  <accept-reuse> <across-fork> <defer> <double-poll-crash>
<file-register> <file-update> <io_uring_enter> <io_uring_register> <lfs-openat>
<lfs-openat-write> <link-timeout> <link_drain> <open-close> <openat2>
<pipe-eof> <poll-cancel> <poll-cancel-ton> <poll-link> <read-write>
<sigfd-deadlock> <sq-poll-dup> <sq-poll-share> <sq-space_left> <timeout>
<statx>
```

I can post a full trace if needed.

Simon

[1]: https://www.openwall.com/lists/musl/2016/02/04/4

 configure         | 21 +++++++++++++++++++++
 examples/Makefile |  6 +++++-
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/configure b/configure
index c911f59..3b96cde 100755
--- a/configure
+++ b/configure
@@ -287,6 +287,24 @@ if compile_prog_cxx "" "" "C++"; then
 fi
 print_config "C++" "$has_cxx"

+##########################################
+# check for ucontext support
+has_ucontext="no"
+cat > $TMPC << EOF
+#include <ucontext.h>
+int main(int argc, char **argv)
+{
+  ucontext_t ctx;
+  getcontext(&ctx);
+  return 0;
+}
+EOF
+if compile_prog "" "" "has_ucontext"; then
+  has_ucontext="yes"
+fi
+print_config "has_ucontext" "$has_ucontext"
+
+
 #############################################################################

 if test "$__kernel_rwf_t" = "yes"; then
@@ -304,6 +322,9 @@ fi
 if test "$has_cxx" = "yes"; then
   output_sym "CONFIG_HAVE_CXX"
 fi
+if test "$has_ucontext" = "yes"; then
+  output_sym "CONFIG_HAVE_UCONTEXT"
+fi

 echo "CC=$cc" >> $config_host_mak
 print_config "CC" "$cc"
diff --git a/examples/Makefile b/examples/Makefile
index 0eec627..60c1b71 100644
--- a/examples/Makefile
+++ b/examples/Makefile
@@ -10,7 +10,11 @@ ifneq ($(MAKECMDGOALS),clean)
 include ../config-host.mak
 endif

-all_targets += io_uring-test io_uring-cp link-cp ucontext-cp
+all_targets += io_uring-test io_uring-cp link-cp
+
+ifdef CONFIG_HAVE_UCONTEXT
+all_targets += ucontext-cp
+endif

 all: $(all_targets)

--
2.29.1

