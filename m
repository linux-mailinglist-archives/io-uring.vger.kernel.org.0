Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA25C4D44B4
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 11:32:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241294AbiCJKdp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Mar 2022 05:33:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241433AbiCJKde (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Mar 2022 05:33:34 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE441145
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 02:32:32 -0800 (PST)
Received: from localhost.localdomain (unknown [138.197.159.143])
        by gnuweeb.org (Postfix) with ESMTPSA id 133717E2E4;
        Thu, 10 Mar 2022 10:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1646908351;
        bh=fY4q6lGnj3OamfZVejrbTHNDiPr3EM8Yt0ZMFUXi+Ss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GCxFdJrP5cc8EuTQcq4RKoJV5WFwO0Rh9VC8ytbS/J1Y1s+yI5dxEXmgh3KLTWbi2
         xHVY8RLc9n1sfZNKTnE43zTeYVw5XPlVHmdgEEGUqekmW06rH+0HDwL2IDX+KmRqqK
         9QpIKqU5e4FTWIw/wpTtwnd5WsDOdRDRP83SO37pDVoxsM3JQs5/ljUnvbaT9d8fMd
         Cc0IAWa4BhnD4M/eyIB8E8Ll5B3Ez1wObHZ1M0ZoEmvxpLwutVEX4AA6D5NuGDjjxH
         7tSFBztDeAFxDXQDq8dBi5YHbToHkXghejB3eYvnPbPl1BKj3ZYznKUlFXDqreWy2J
         RGWR3P1QkhhXg==
From:   Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>,
        io-uring <io-uring@vger.kernel.org>, gwml <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v2 4/4] examples/Makefile: Add liburing.a as a dependency
Date:   Thu, 10 Mar 2022 10:32:24 +0000
Message-Id: <20220310103224.1675123-5-alviro.iskandar@gnuweeb.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220310103224.1675123-1-alviro.iskandar@gnuweeb.org>
References: <20220310103224.1675123-1-alviro.iskandar@gnuweeb.org>
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

