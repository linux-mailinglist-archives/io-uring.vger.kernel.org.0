Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4353C649F11
	for <lists+io-uring@lfdr.de>; Mon, 12 Dec 2022 13:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbiLLMtU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Dec 2022 07:49:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231462AbiLLMtU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Dec 2022 07:49:20 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 785ECCC2
        for <io-uring@vger.kernel.org>; Mon, 12 Dec 2022 04:49:19 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.130])
        by gnuweeb.org (Postfix) with ESMTPSA id E350C8060C;
        Mon, 12 Dec 2022 12:49:16 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1670849358;
        bh=L4DAuy9QEuLloxUWvI4Fq15R5BWulmfOXVpjFL7WRhw=;
        h=From:To:Cc:Subject:Date:From;
        b=P91aL1VhrSTjaaI5UOOmbggW5jJPVL+AT06DueEF1WwIlitskrq9zVc+NH9wBDgUh
         ClwHwECxeT+wl8t914kk84i8IVsFrDRreCJTN+NjMTcq/pubZTCplJ8lnSxc341OMe
         WsERtM5SVzzVyHYvNDHX6SUlscSLkmdpy5ATzkpfOxKQSpx169g4VR4P5bAdTHGlhC
         Z6mqBafFoESqsuMtMkKKENmjR5F+b3LZSWRd0UnvOLgXygpMzgSDG4//P+/e4OYO3r
         Vaqs9z6GPPHMN8AcGVyHHqfRT9d3AojJXdICxi443dmoQJnBADOFEzQ6goPUbJqsKy
         9cV6jjKohzvnA==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Nicolai Stange <nstange@suse.de>,
        Yuriy Chernyshov <georgthegreat@gmail.com>
Subject: [PATCH] test/sendmsg_fs_cve: Fix the wrong SPDX-License-Identifier
Date:   Mon, 12 Dec 2022 19:48:57 +0700
Message-Id: <20221124162633.3856761-1-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
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

This test program's license is GPL-2.0-or-later, but I put the wrong
SPDX-License-Identifier in commit:

   d36db0b72b9 ("test: Add missing SPDX-License-Identifier")

Fix it.

Cc: Nicolai Stange <nstange@suse.de>
Reported-by: Yuriy Chernyshov <georgthegreat@gmail.com>
Fixes: https://github.com/axboe/liburing/issues/753
Fixes: d36db0b72b9399623dee12b61069845d8e1bfa05 ("test: Add missing SPDX-License-Identifier")
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 test/sendmsg_fs_cve.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/sendmsg_fs_cve.c b/test/sendmsg_fs_cve.c
index 2ce3114..9e444d7 100644
--- a/test/sendmsg_fs_cve.c
+++ b/test/sendmsg_fs_cve.c
@@ -1,11 +1,11 @@
-/* SPDX-License-Identifier: MIT */
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * repro-CVE-2020-29373 -- Reproducer for CVE-2020-29373.
  *
  * Copyright (c) 2021 SUSE
  * Author: Nicolai Stange <nstange@suse.de>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * as published by the Free Software Foundation; either version 2
  * of the License, or (at your option) any later version.

base-commit: 5f0cf68fc2cd28617a86976fc906447f737086d5
-- 
Ammar Faizi

