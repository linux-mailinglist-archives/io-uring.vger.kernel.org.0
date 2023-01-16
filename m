Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1AB166C298
	for <lists+io-uring@lfdr.de>; Mon, 16 Jan 2023 15:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbjAPOrO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Jan 2023 09:47:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231654AbjAPOq5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Jan 2023 09:46:57 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27824298E0
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 06:28:46 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.184])
        by gnuweeb.org (Postfix) with ESMTPSA id 6CDA48188B;
        Mon, 16 Jan 2023 14:28:43 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1673879325;
        bh=0R7FRm9ecJbddmJR9NjQzQH//2BtgJnlBHZ0qOROLYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PGP+d/DR429hq+wH6Per84T5x34AOU0Loh1Roh5vEK8m+KLzw14Htq9wNyWO5xoNX
         goAXe8ICIKJ+hxLnEKMg4ikMsRxuuB5cjPZt8Yl551SJf1YMwNWZnhivzF6Ejh++8H
         qMFA9IYYwHgyjODRGD3YqLadXI5G33GGDSBJS0sGFqIhZFvLv/PiALJGaLgBnUzIAY
         9Hc58ZyjRGUr0BpjqGsE9fIzZ08NRhQvTuY3TUezWt+Tzw1rbBi0DOlm489SjlxC42
         B5mqeO5X6z+DQssayl6H3lurPl5BGE/a//cd+betO/uw2jZeEkv1f499EF7p0UaYfj
         aWNFr8qZrUOug==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christian Mazakas <christian.mazakas@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        VNLX Kernel Department <kernel@vnlx.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [RFC PATCH liburing v2 1/2] README: Explain how to build liburing
Date:   Mon, 16 Jan 2023 21:28:21 +0700
Message-Id: <20230116142822.717320-2-ammar.faizi@intel.com>
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

Tell people how to build liburing.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 README | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/README b/README
index 80d2b3dc5d5eaf76..4dd59f67fcbfbc5e 100644
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

