Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A503255F264
	for <lists+io-uring@lfdr.de>; Wed, 29 Jun 2022 02:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbiF2A2d (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jun 2022 20:28:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbiF2A2d (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jun 2022 20:28:33 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D97728729
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 17:28:32 -0700 (PDT)
Received: from integral2.. (unknown [180.245.197.13])
        by gnuweeb.org (Postfix) with ESMTPSA id 1EA177FCFC;
        Wed, 29 Jun 2022 00:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656462511;
        bh=2o+3Pwm0EoDG+Gn7IfnDamtvJm71dPYhZr1d3qufT5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Klfv/yrMuRedEyq97H5FTYS50WuWsIyIG95FNlA1xZAAFJ3Rn6Tdu4eUjlc9cY30C
         czv/pisNljtmzK0X9//hFAsGkid/KJQ9M+L7RxHDzAQwU0yVNFmsd1ApSU9Q88i2Ne
         1TAImoIZvPsUV8ZGBDowmc4bm8sG4FPXB84rY5tZcp4RvVs/PT+sGFmhNoiEv0cdVr
         N3TTp87oODXNvrXwviJYTxlsl9a/KcztO83BiuIZ1rU2yz5SRc7knpbGpIW9ESQpIo
         lwydx6IsCTUteQWaFnOVeFUq6VRlX0El7IAOtcktjKe2nacSmkFVH5nM2VmhybT94l
         b4bgEjxMheRMg==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <howeyxu@tencent.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@gnuweeb.org>
Subject: [PATCH liburing v1 5/9] arch/arm64: Rename aarch64 directory to arm64
Date:   Wed, 29 Jun 2022 07:27:49 +0700
Message-Id: <20220629002028.1232579-6-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220629002028.1232579-1-ammar.faizi@intel.com>
References: <20220629002028.1232579-1-ammar.faizi@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

In the Linux kernel tree, we use `arm64` instead of `aarch64` to name
the directory that saves this arch specific code. Follow this naming
in liburing too.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/arch/{aarch64 => arm64}/syscall.h | 6 +++---
 src/syscall.h                         | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)
 rename src/arch/{aarch64 => arm64}/syscall.h (95%)

diff --git a/src/arch/aarch64/syscall.h b/src/arch/arm64/syscall.h
similarity index 95%
rename from src/arch/aarch64/syscall.h
rename to src/arch/arm64/syscall.h
index 5e26714..732ada0 100644
--- a/src/arch/aarch64/syscall.h
+++ b/src/arch/arm64/syscall.h
@@ -4,8 +4,8 @@
 	#error "This file should be included from src/syscall.h (liburing)"
 #endif
 
-#ifndef LIBURING_ARCH_AARCH64_SYSCALL_H
-#define LIBURING_ARCH_AARCH64_SYSCALL_H
+#ifndef LIBURING_ARCH_ARM64_SYSCALL_H
+#define LIBURING_ARCH_ARM64_SYSCALL_H
 
 #if defined(__aarch64__)
 
@@ -96,4 +96,4 @@
 
 #endif /* #if defined(__aarch64__) */
 
-#endif /* #ifndef LIBURING_ARCH_AARCH64_SYSCALL_H */
+#endif /* #ifndef LIBURING_ARCH_ARM64_SYSCALL_H */
diff --git a/src/syscall.h b/src/syscall.h
index 214789d..9e72e6f 100644
--- a/src/syscall.h
+++ b/src/syscall.h
@@ -74,7 +74,7 @@ static inline bool IS_ERR(const void *ptr)
 #if defined(__x86_64__) || defined(__i386__)
 #include "arch/x86/syscall.h"
 #elif defined(__aarch64__)
-#include "arch/aarch64/syscall.h"
+#include "arch/arm64/syscall.h"
 #else
 /*
  * We don't have native syscall wrappers
-- 
Ammar Faizi

