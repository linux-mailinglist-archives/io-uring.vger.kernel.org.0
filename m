Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8C36E32A8
	for <lists+io-uring@lfdr.de>; Sat, 15 Apr 2023 18:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbjDOQ7a (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Apr 2023 12:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbjDOQ73 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Apr 2023 12:59:29 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 949874687;
        Sat, 15 Apr 2023 09:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1681577961;
        bh=x9aEcwLXXFbA5oEs9XXulDcubT9b5lxVpZJrOB80OIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=E1S9V12Ki287O1DLY0Y2FnblJbzb2Jlh5E1O0R7aGriIBDxR4G9NzL03mUxOQstOa
         j9KSdK3kJW54L4yz7nyKagtnwU15NdVZQl8BJp9jILlhUGMe3F0A14PobebnqqX+6F
         zov6InZv7xd0N1nvmGiYXk/hVPgx32cxDWiXhryEydQCeMZRzjg1T9CLVlQIaCg6Hj
         ga1/DgtbgJMTPPJVnCbnU2uVzkDNeD8y+M1x54vPNofvgsxqcoJifBPLBWpKY894SE
         bhDi5G1d+Kgo2+/vO0tCLGQe1R61zsvfchkOi+HG6FC6u71KBPnLKpZUL40N6uqJC2
         0JjK0zmH6znaA==
Received: from localhost.localdomain (unknown [182.253.88.211])
        by gnuweeb.org (Postfix) with ESMTPSA id 22C6824552E;
        Sat, 15 Apr 2023 23:59:17 +0700 (WIB)
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Linux Parisc Mailing List <linux-parisc@vger.kernel.org>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH liburing 2/3] github: Add hppa cross compiler
Date:   Sat, 15 Apr 2023 23:59:03 +0700
Message-Id: <20230415165904.791841-3-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230415165904.791841-1-ammarfaizi2@gnuweeb.org>
References: <20230415165904.791841-1-ammarfaizi2@gnuweeb.org>
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

From: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>

Since commit 9c6689848ebf ("Default to mmap'ed provided buffers for
hppa"), the core library has hppa specific code. Add hppa cross compiler
on the GitHub bot CI to catch build breakage for this arch.

Cc: Linux Parisc Mailing List <linux-parisc@vger.kernel.org>
Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Co-authored-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 .github/workflows/build.yml | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/.github/workflows/build.yml b/.github/workflows/build.yml
index fed5b38c3a507336..8dd22dfd125692de 100644
--- a/.github/workflows/build.yml
+++ b/.github/workflows/build.yml
@@ -85,6 +85,13 @@ jobs:
             cc: mips-linux-gnu-gcc
             cxx: mips-linux-gnu-g++
 
+          # hppa
+          - arch: hppa
+            cc_pkg: gcc-hppa-linux-gnu
+            cxx_pkg: g++-hppa-linux-gnu
+            cc: hppa-linux-gnu-gcc
+            cxx: hppa-linux-gnu-g++
+
     env:
       FLAGS: -g -O3 -Wall -Wextra -Werror -Wno-sign-compare ${{matrix.extra_flags}}
 
-- 
Ammar Faizi

