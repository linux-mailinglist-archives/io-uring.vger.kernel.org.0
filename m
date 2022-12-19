Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19C0F650F4F
	for <lists+io-uring@lfdr.de>; Mon, 19 Dec 2022 16:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbiLSPxf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Dec 2022 10:53:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232601AbiLSPxF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Dec 2022 10:53:05 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEC9D13D64
        for <io-uring@vger.kernel.org>; Mon, 19 Dec 2022 07:50:33 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.89])
        by gnuweeb.org (Postfix) with ESMTPSA id B799D81917;
        Mon, 19 Dec 2022 15:50:30 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1671465033;
        bh=wDhwh6SEWRdoxqFmz3sjSJiYXWiBiIzzspUZzIfk2m8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JxYDMf+5Ukbm1YFub2R2W3QPxRbSRJroyVmUV8vJMgITFKYcXwuXrh2juFyjDAw0d
         HySBipw/QOFwtLOz9t91rcwVuWUyD0ewGKyJnTqNOXsppHqf21RrI2tANt0n5yTktU
         CrtW8T7Xg92xZFOknI1jn9b+kWti+Oav+IuIimR2aWwyl3MxsohqfHsSV3lozrhgJY
         mw6/czzvmlCm2f6XYacC3bM/T9h5+7PRrv/9N83gCYJqSPppWW3ey7NRGAjdvigS7I
         XpGIYVzdLX8BRPIrUkbSnZeGeizcg+wGAjCXmTESrX2N4wxxCLjLbgCw3N7uvw0l7t
         EPA2XZdu2grUQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        VNLX Kernel Department <kernel@vnlx.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Christian Hergert <chergert@redhat.com>
Subject: [PATCH liburing v1 2/8] Makefile: Add a '+' char to silence a Makefile warning
Date:   Mon, 19 Dec 2022 22:49:54 +0700
Message-Id: <20221219155000.2412524-3-ammar.faizi@intel.com>
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

When building with `make -jN` where `N` is greater than 1, it shows:

  make[1]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.
  make[1]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.

This happens because since commit 0d55ea19ccf2 ("version: generate
io_uring_version.h from Makefile.common"), the configure file executes
make command.

Add a '+' char in front of the configure command to silence this
warning.

Cc: Christian Hergert <chergert@redhat.com>
Fixes: 0d55ea19ccf2f34c5dd74f80846f9e5f133746ff ("version: generate io_uring_version.h from Makefile.common")
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 686be4f..4bd7e24 100644
--- a/Makefile
+++ b/Makefile
@@ -18,21 +18,21 @@ partcheck: all
 	@echo "make partcheck => TODO add tests with out kernel support"
 
 runtests: all
 	@$(MAKE) -C test runtests
 runtests-loop: all
 	@$(MAKE) -C test runtests-loop
 runtests-parallel: all
 	@$(MAKE) -C test runtests-parallel
 
 config-host.mak: configure
-	@if [ ! -e "$@" ]; then					\
+	+@if [ ! -e "$@" ]; then				\
 	  echo "Running configure ...";				\
 	  ./configure;						\
 	else							\
 	  echo "$@ is out-of-date, running configure";		\
 	  sed -n "/.*Configured with/s/[^:]*: //p" "$@" | sh;	\
 	fi
 
 ifneq ($(MAKECMDGOALS),clean)
 include config-host.mak
 endif
-- 
Ammar Faizi

