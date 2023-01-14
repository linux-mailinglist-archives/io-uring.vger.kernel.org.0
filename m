Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF0A66AACC
	for <lists+io-uring@lfdr.de>; Sat, 14 Jan 2023 10:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbjANJ4L (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 14 Jan 2023 04:56:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbjANJ4K (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 14 Jan 2023 04:56:10 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14E5B44AF
        for <io-uring@vger.kernel.org>; Sat, 14 Jan 2023 01:56:06 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.184])
        by gnuweeb.org (Postfix) with ESMTPSA id 5811F7E79B;
        Sat, 14 Jan 2023 09:56:03 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1673690165;
        bh=5kyulY7GexKHkOTPwRkKp/KyQxLOQ9Ay4VoKnidx66E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ohRoCgDIlzLWQGXTcsdrcAJOucGl4GAnUo8WHLAT5jKr0zwH+dlDHus0xmhCtdHEk
         kcgNG0ih8dvvNVISD9Xgs93G8mSJqhfLxLn0PJa47x/4nEFrfCHTi/OIs6vrKiLmG/
         2mZR/WyLzJBgfSD0h+FExnuCRNIkswAommpDpCuwV7cvFjXRY9COPjX8g8RQ9Gp/rq
         /WU8rZsagOQASyao3Ot4IdjG1EUKniP8/lCa6y0CYvydnUO8VfCrP9Vfs/Wq7RAtJ2
         fRJAn2/qcwIznnYLRauxlFGNyV6F7PNlorxQphmc3Ap4ruwINT7pbrS+j9tPj6AVEh
         s+I+LmSVGSxzQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christian Mazakas <christian.mazakas@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        VNLX Kernel Department <kernel@vnlx.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [RFC PATCH v1 liburing 2/2] README: Explain about FFI support
Date:   Sat, 14 Jan 2023 16:55:23 +0700
Message-Id: <20230114095523.460879-3-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230114095523.460879-1-ammar.faizi@intel.com>
References: <20230114095523.460879-1-ammar.faizi@intel.com>
MIME-Version: 1.0
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

Tell people that they should use the FFI variants when they can't use
'static inline' functions defined in liburing.h.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 README | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/README b/README
index 4dd59f6..7babb3b 100644
--- a/README
+++ b/README
@@ -71,6 +71,25 @@ Building liburing
 See './configure --help' for more information about build config options.
 
 
+FFI support
+-----------
+
+By default, the build results in 4 lib files:
+
+    2 shared libs:
+
+        liburing.so
+        liburing-ffi.so
+
+    2 static libs:
+
+        liburing.a
+        liburing-ffi.a
+
+For languages and applications that can't use 'static inline' functions in
+liburing.h should use the FFI variants.
+
+
 License
 -------
 
-- 
Ammar Faizi

