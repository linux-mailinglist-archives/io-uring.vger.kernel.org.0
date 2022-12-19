Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2484A650F4E
	for <lists+io-uring@lfdr.de>; Mon, 19 Dec 2022 16:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232698AbiLSPxf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Dec 2022 10:53:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232589AbiLSPxC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Dec 2022 10:53:02 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B8E313D57
        for <io-uring@vger.kernel.org>; Mon, 19 Dec 2022 07:50:30 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.89])
        by gnuweeb.org (Postfix) with ESMTPSA id 72BED81925;
        Mon, 19 Dec 2022 15:50:27 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1671465030;
        bh=Cw0C5upr2XllD76XKiRZusMKjtEuaaLqf5cZUW3MSU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DTPQOFYPYsMvLELUtf29q2EYkentO0uh/gzrdHFJroZ7yQ/ImjsOG7ShlxoWRgchF
         EzNdOFRiO1FZ4lwO6Hnu3WnE89VwwuglFZ1CfgRqhUVWzUGO2sMachxVC5OBfIQrTK
         eEO+Kw9MUei3JQBtPO/qIwPXjNZ8rSeq2xJWy+Uy3TIhfMxyMVmb1NdKm+vTTX0bKH
         G1Z0RbC9JsJHw68mJHfGj7OLyTayKTaw9Hmw3ROil6QJEm2g9/N9KogpC70usx5vo/
         OLwhyM4Ks7GkVl2OnyMadxuhrb3haG7kby0YeQbKNy34gyLn/JrLzz2gRCa6yRg7s2
         rlAAaAwWKzcRw==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        VNLX Kernel Department <kernel@vnlx.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Christian Mazakas <christian.mazakas@gmail.com>
Subject: [PATCH liburing v1 1/8] ffi: Add SPDX-License-Idetifier
Date:   Mon, 19 Dec 2022 22:49:53 +0700
Message-Id: <20221219155000.2412524-2-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221219155000.2412524-1-ammar.faizi@intel.com>
References: <20221219155000.2412524-1-ammar.faizi@intel.com>
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

Commit 9e2890d35e96 ("build: add liburing-ffi") didn't add
"SPDX-LIcense-Identifier" in src/ffi.c. Add it.

Cc: Christian Mazakas <christian.mazakas@gmail.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/ffi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/ffi.c b/src/ffi.c
index fbca2a4..03e382e 100644
--- a/src/ffi.c
+++ b/src/ffi.c
@@ -1,10 +1,11 @@
+/* SPDX-License-Identifier: MIT */
 #define IOURINGINLINE
 
 #ifdef __clang__
 // clang doesn't seem to particularly like that we're including a header that
 // deliberately contains function definitions so we explicitly silence it
 #pragma clang diagnostic push
 #pragma clang diagnostic ignored "-Wmissing-prototypes"
 #endif
 
 #include "liburing.h"
-- 
Ammar Faizi

