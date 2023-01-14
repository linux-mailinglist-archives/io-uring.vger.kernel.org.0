Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A09A66AACB
	for <lists+io-uring@lfdr.de>; Sat, 14 Jan 2023 10:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbjANJ4J (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 14 Jan 2023 04:56:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbjANJ4H (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 14 Jan 2023 04:56:07 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0952D7686
        for <io-uring@vger.kernel.org>; Sat, 14 Jan 2023 01:56:03 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.184])
        by gnuweeb.org (Postfix) with ESMTPSA id 49F0E7E7B8;
        Sat, 14 Jan 2023 09:56:00 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1673690162;
        bh=JBGTKQWhtc2dTDwON2iUSuzr3M9sqfmCkJxXeSeA+pA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k04U7pw3xJexkOPKeIV7doQNShuauHEzoSgEK8Z6pbjSNMKqUDVZYUY5e3jUkTwOy
         t6yDB2X+VaxGPoWuC0rql8FAhaQBd8G3J0yGHoooCbJELBSqviDp0lfQ+isHS6sl//
         Bds4E7ZoNMiv2Dq0WeHUT/WQ96Ew4TmkCTWIDpJdIF2FW5TDJTAMj16dt3Zjk+SWeT
         F4lcui3I81RpWuqcIuwaquSkJdNPC4RZTe5MOclTg5NBrzCVZsw3br79zM1nOWTVXF
         4VYLbrn+Du4P94pXJNIYcdMl9HoJA8WYBKzV3S2kQ3BGyHAb8EGVb8elHwnQ4VLTKO
         LWYY6cwDdaFOQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christian Mazakas <christian.mazakas@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        VNLX Kernel Department <kernel@vnlx.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [RFC PATCH v1 liburing 1/2] README: Explain how to build liburing
Date:   Sat, 14 Jan 2023 16:55:22 +0700
Message-Id: <20230114095523.460879-2-ammar.faizi@intel.com>
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

Tell people how to build liburing.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 README | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/README b/README
index 80d2b3d..4dd59f6 100644
--- a/README
+++ b/README
@@ -47,6 +47,30 @@ the kernel io_uring support. Please note that this suite isn't expected to
 pass on older kernels, and may even crash or hang older kernels!
 
 
+Building liburing
+-----------------
+
+    #
+    # Prepare build config (optional).
+    #
+    #  --cc  specifies the C   compiler.
+    #  --cxx speficies the C++ compiler.
+    #
+    ./configure --cc=gcc --cxx=g++;
+
+    #
+    # Build liburing.
+    #
+    make -j$(nproc);
+
+    #
+    # Install liburing (headers, shared/static libs, and manpage).
+    #
+    sudo make install;
+
+See './configure --help' for more information about build config options.
+
+
 License
 -------
 
-- 
Ammar Faizi

