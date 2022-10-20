Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2955160617B
	for <lists+io-uring@lfdr.de>; Thu, 20 Oct 2022 15:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbiJTNXa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Oct 2022 09:23:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230387AbiJTNX1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Oct 2022 09:23:27 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5454519ABD5
        for <io-uring@vger.kernel.org>; Thu, 20 Oct 2022 06:23:07 -0700 (PDT)
Received: from localhost.localdomain (unknown [182.253.183.172])
        by gnuweeb.org (Postfix) with ESMTPSA id BECB5811F2;
        Thu, 20 Oct 2022 13:15:18 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1666271721;
        bh=Kw3TWBpSLDyh78RGCaDMQme+RaSGD02sE1fAlWYUS6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fj6+WEH8Oc84sRLXS0DNFx7JfRE8xW3zVDtwXxw0V3Mz+jZNCoMYcyC4SWL7do4Gd
         vAlegCenjlFkjl3VKWrx+/0Ewubzl5CokgWgnLTncktlRRQ95iJx+XzejqsTvp/ula
         wvSgNekLP9t0iRsaXpPSg7rwHFeNZ3QiUayekTDhkrDQHvciye+9znzdmeQlg1omxG
         +fUCY/6USM0DzGqMSNI4d7oZvuHGDXwxjD7y4TiYycQFsT0nrkMSvkcjS/USS/y8A8
         zVxUsQdTyn1yVUJdCtzXlrC8u6xpO4f3eNPHm1Pfm5EdMsyjKZ7Fx5Uij1vSY00v/B
         xlONFD9HgPuSg==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Dylan Yudaken <dylany@meta.com>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Facebook Kernel Team <kernel-team@fb.com>
Subject: [PATCH liburing v2 3/3] github: Append `-Wshorten-64-to-32` flag for clang build
Date:   Thu, 20 Oct 2022 20:14:55 +0700
Message-Id: <20221020131118.13828-4-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221020131118.13828-1-ammar.faizi@intel.com>
References: <20221020131118.13828-1-ammar.faizi@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

liburing has a couple of int shortening issues found by clang. A
previous commit has cleaned them up. Integrate -Wshorten-64-to-32
flag to the GitHub bot to spot the same issue in the future.

This flag is clang-specific, it currently doesn't exist in GCC.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 .github/workflows/build.yml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/.github/workflows/build.yml b/.github/workflows/build.yml
index 2608644..b0e669d 100644
--- a/.github/workflows/build.yml
+++ b/.github/workflows/build.yml
@@ -26,6 +26,7 @@ jobs:
             cxx_pkg: clang
             cc: clang
             cxx: clang++
+            extra_flags: -Wshorten-64-to-32
 
           # x86 (32-bit) gcc
           - arch: i686
@@ -86,6 +87,9 @@ jobs:
     env:
       FLAGS: -g -O3 -Wall -Wextra -Werror
 
+      # Flags for building sources in src/ dir only.
+      LIBURING_CFLAGS: ${{matrix.extra_flags}}
+
     steps:
     - name: Checkout source
       uses: actions/checkout@v2
-- 
Ammar Faizi

