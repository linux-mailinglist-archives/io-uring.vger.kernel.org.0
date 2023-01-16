Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13DAE66C299
	for <lists+io-uring@lfdr.de>; Mon, 16 Jan 2023 15:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbjAPOrO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Jan 2023 09:47:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231683AbjAPOq5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Jan 2023 09:46:57 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D94923115
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 06:28:49 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.184])
        by gnuweeb.org (Postfix) with ESMTPSA id 74D5981875;
        Mon, 16 Jan 2023 14:28:46 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1673879328;
        bh=uSwXcHjhVg5EFT9l3WjS0uSkZdDSM8perMQ03nudsWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LiMUaFCDPPLoaM6vPdc/DcDfJBbN5gExkueK7Um5ICrbAxgJFbE2uRMwzVaIXdEWp
         wd1XhV3HU+F1Nker9zsM/w9AUc/xfW6L0rXD9DshTWtXPneDYacHbNOB+JNpFemOk6
         Of5F1e6rjc6ApY7lJiLjT8X638S8DxjSaGXgKbR5DCCQdxDEXabhngg1tscxMufCsz
         3GMroQrqLwdp7jpsSVq94LRoDJIqPv43iCFn9LErI/m7K1/Ucjt4t54uuGx+pNr2KN
         AID09HBmfq0t8kQUZRXrKYOaRDRwwVVMOZhIP/mVgjP3zhY9FKraT22VKe9Q2L2eYz
         D3pXNNWC0ipZg==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christian Mazakas <christian.mazakas@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        VNLX Kernel Department <kernel@vnlx.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [RFC PATCH liburing v2 2/2] README: Explain about FFI support
Date:   Mon, 16 Jan 2023 21:28:22 +0700
Message-Id: <20230116142822.717320-3-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230116142822.717320-1-ammar.faizi@intel.com>
References: <20230116142822.717320-1-ammar.faizi@intel.com>
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

Languages and applications that can't use 'static inline' functions in
liburing.h should use the FFI variants.

Co-authored-by: Christian Mazakas <christian.mazakas@gmail.com>
Signed-off-by: Christian Mazakas <christian.mazakas@gmail.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 README | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/README b/README
index 4dd59f67fcbfbc5e..9c881ae75787795c 100644
--- a/README
+++ b/README
@@ -71,6 +71,30 @@ Building liburing
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
+Languages and applications that can't use 'static inline' functions in
+liburing.h should use the FFI variants.
+
+liburing's main public interface lives in liburing.h as 'static inline'
+functions. Users wishing to consume liburing purely as a binary dependency
+should link against liburing-ffi. It contains definitions for every 'static
+inline' function.
+
+
 License
 -------
 
-- 
Ammar Faizi

