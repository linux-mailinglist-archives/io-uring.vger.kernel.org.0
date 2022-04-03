Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86D194F0AB2
	for <lists+io-uring@lfdr.de>; Sun,  3 Apr 2022 17:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352131AbiDCPk6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Apr 2022 11:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238668AbiDCPk6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Apr 2022 11:40:58 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E23ED26E3
        for <io-uring@vger.kernel.org>; Sun,  3 Apr 2022 08:39:03 -0700 (PDT)
Received: from integral2.. (unknown [182.2.43.220])
        by gnuweeb.org (Postfix) with ESMTPSA id EF0087E312;
        Sun,  3 Apr 2022 15:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1649000343;
        bh=w7etDYpHXi1TnSZ6a6YDJCc98+hV1o+dQclDCUwVaqg=;
        h=From:To:Cc:Subject:Date:From;
        b=EcqAVnV2aBINIb4pZHU3wocGskFjE4tPhg65zCiujVIy7kf39w5wpQS+1Y66UvlvF
         xnCnRBPkcMJfC+WfB1pq+BS6WIUzC45fS/MOfo9kNrAj7qv+UihQXYxFo1U1kr/axE
         mbfIhdUDAHY+XMpTEUGVUGtojxhn7UOsEqJtb8dlUnJJbpMGWqB02z2YePgJ/VD5KB
         gglNmOUO3JbYBQy2BbTwPE70pOtrErPaqiEQY1/6WlqQYssJNHG7mkYwcr8VGIWA9d
         fkTAbw+g6pxOW/roZOQLDQikxfaRzYeoDV/pwrwHMP1aSkWMWoaUtpczXksC2tYfbi
         v3vByOLKBHjAA==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing 0/2] Simplify build for tests and a gitignore cleanup
Date:   Sun,  3 Apr 2022 22:38:47 +0700
Message-Id: <20220403153849.176502-1-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
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

Hi Jens,

Two patches in this series:

  - Append -lpthread for all tests and remove the LDFLAGS override
    for tests that use pthread.

  - Another patch to append `.test` to the test binary filename for
    gitignore simplification after my first try at [1].

[1]: https://lore.kernel.org/io-uring/20220403095602.133862-1-ammarfaizi2@gnuweeb.org

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

Ammar Faizi (2):
  test/Makefile: Append -lpthread for all tests
  test/Makefile: Append `.test` to the test binary filename

 .gitignore    | 132 +-------------------------------------------------
 test/Makefile |  33 +++----------
 2 files changed, 7 insertions(+), 158 deletions(-)


base-commit: c0a2850e7192edbf3679265db20e2fb2a828e830
-- 
Ammar Faizi

