Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3CBD50C127
	for <lists+io-uring@lfdr.de>; Fri, 22 Apr 2022 23:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbiDVViY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Apr 2022 17:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbiDVViP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Apr 2022 17:38:15 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF4AF2BBD6A
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 13:42:40 -0700 (PDT)
Received: from integral2.. (unknown [36.72.214.135])
        by gnuweeb.org (Postfix) with ESMTPSA id 46EA17E76E;
        Fri, 22 Apr 2022 20:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1650659773;
        bh=lERoqgXcjDg3R4RAQs+1pYXo8w5XdqiDCx5ILKzxSB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UE+8AUtXRqZo+gzLdPGeXUIeyfdaXS4nh4yVpJezg9jluDFmXKya3uzQ5Q0Zt3kkM
         ddI4Cp7+GhSnMA2h4KE0YYqCZCm28n3XH9FJjbG862XwCswjurekaWZrWN0jJiHKLF
         RS03pM+sJ/Ao4+PXm7alE4+AkXWorn6hmO45Q1zOpkdsUFfzKfjoB2NwUL5ImbHRR+
         hsYCt3nz+b1WgI0iZyCGNrm6Rj+VkeMD9NXGD9dL+nUSogYZYpj3jumURpvJq9nGw8
         Ur+5aQdqCYaKqZYsdby/2q9oPHQblSZwY9nznqneGyhPwYM8iqoumC1R3eH+EocoWq
         J6LEcZbMnLDyw==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v1 5/6] .github/workflows: Run the nolibc build for x86 32-bit
Date:   Sat, 23 Apr 2022 03:35:41 +0700
Message-Id: <20220422203340.682723-6-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220422203340.682723-1-ammar.faizi@intel.com>
References: <20220422203340.682723-1-ammar.faizi@intel.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1040; h=from:subject:message-id; bh=q+hHV+PlIejcPGIS1pfwYhNuUehaV935p88l6h+XjdA=; b=owEBbQGS/pANAwAKATZPujT/FwpLAcsmYgBiYxFsoSJ6k1KL9eCojTA5rn3rlDE94GE3kaiZLNny 0mad5s2JATMEAAEKAB0WIQTok3JtyOTA3juiAQc2T7o0/xcKSwUCYmMRbAAKCRA2T7o0/xcKS/eeCA DpNCpSi/7l87BVjkelOm/AGjthvkHGlG2y36ivpSD+13QnVlIXHQnVB3mzwEDJYHnYp69hlIN5QLjr wa/3n4Bztbb60Z1Ae015Lmn+8mj+xP3/+BbHIPHDiMwpLv3chMnoIWTcOEZo4LJrO4HpeOxE7zd9yu QRE6FKIwBSxHYc1UioVQCCn1RKzu52ho9fMwOEKbTNRYupOPSmrplz/Gq/8s8T97210oeTq4s6NCza gafWab4hop828QiAo0Q+tYMSHvO3CqHYyiYvbg2lvnvqSJPA2zeqv9ug4DpgM6JIs7IANheDpDW+Zj AEliCJpfKv4syShnRY0/a60zaG5B5Q
X-Developer-Key: i=ammarfaizi2@gnuweeb.org; a=openpgp; fpr=E893726DC8E4C0DE3BA20107364FBA34FF170A4B
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Since commit:

  b7d8dd8bbf5b ("arch/x86/syscall: Add x86 32-bit native syscall support")

liburing supports nolibc build for x86 32-bit. Run the nolibc build for
this arch on the GitHub bot too.

Currently, liburing nolibc is only available for:
 - x86-64.
 - x86 (32-bit).

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 .github/workflows/build.yml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/.github/workflows/build.yml b/.github/workflows/build.yml
index 30a2fc7..39f4314 100644
--- a/.github/workflows/build.yml
+++ b/.github/workflows/build.yml
@@ -72,7 +72,7 @@ jobs:
 
     - name: Build nolibc
       run: |
-        if [[ "${{matrix.arch}}" == "x86_64" ]]; then \
+        if [[ "${{matrix.arch}}" == "x86_64" || "${{matrix.arch}}" == "i686" ]]; then \
             make clean; \
             ./configure --cc=${{matrix.cc}} --cxx=${{matrix.cxx}} --nolibc; \
             make -j$(nproc) V=1 CPPFLAGS="-Werror" CFLAGS="$FLAGS" CXXFLAGS="$FLAGS"; \
-- 
Ammar Faizi

