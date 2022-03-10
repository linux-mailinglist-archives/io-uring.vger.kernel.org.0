Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8D44D456B
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 12:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241486AbiCJLOM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Mar 2022 06:14:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241505AbiCJLOL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Mar 2022 06:14:11 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45890BE1EB
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 03:13:11 -0800 (PST)
Received: from localhost.localdomain (unknown [138.197.159.143])
        by gnuweeb.org (Postfix) with ESMTPSA id 44E5C7E2A8;
        Thu, 10 Mar 2022 11:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1646910790;
        bh=fY4q6lGnj3OamfZVejrbTHNDiPr3EM8Yt0ZMFUXi+Ss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UNcgGpGyiSMdOygzQsdY0Foji2SIc7trS3j6HX/vWkJ1JWsD2ppIltR0xl0DrirtB
         tF5SmfsmWBv5Y56x+rK83flvXMhTNURkKpcTYMXfuDETK6WL3vZF82zU10A6qpzoam
         4PQv8PyVYfJOGaW5CdnH34MYNwVDcglCC9w2zwxDwC7vZldd84d4jPScl6fmo0myFO
         ClZ0iFtLyt44Mp3d2fgesWRsfohM9FzoDG59c2hj8ivpDfqadWQcjWFpZAlvLgrBGJ
         9WGaVZLs1oTyJAbu8nH7VaU89j4DNwRepna+ZMx/8MG+EnwMhuA+wZ1jwhhXseplbm
         96QGDJ+1j8QDQ==
From:   Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>,
        io-uring <io-uring@vger.kernel.org>, gwml <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v3 4/4] examples/Makefile: Add liburing.a as a dependency
Date:   Thu, 10 Mar 2022 11:12:31 +0000
Message-Id: <20220310111231.1713588-5-alviro.iskandar@gnuweeb.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220310111231.1713588-1-alviro.iskandar@gnuweeb.org>
References: <20220310111231.1713588-1-alviro.iskandar@gnuweeb.org>
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

The example binaries statically link liburing using liburing.a file.
When liburing.a is recompiled, make sure the example binaries are also
recompiled to ensure changes are applied to the binaries. It makes
"make clean" command optional when making changes.

Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
---
 examples/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/examples/Makefile b/examples/Makefile
index f966f94..95a45f9 100644
--- a/examples/Makefile
+++ b/examples/Makefile
@@ -29,7 +29,7 @@ all_targets += $(example_targets)
 
 all: $(example_targets)
 
-%: %.c
+%: %.c ../src/liburing.a
 	$(QUIET_CC)$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ $< $(LDFLAGS)
 
 clean:
-- 
2.25.1

