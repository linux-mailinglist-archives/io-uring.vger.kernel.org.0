Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D76256AF6CE
	for <lists+io-uring@lfdr.de>; Tue,  7 Mar 2023 21:39:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjCGUjF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Mar 2023 15:39:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjCGUjE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Mar 2023 15:39:04 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C13D92F3B;
        Tue,  7 Mar 2023 12:39:03 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.169])
        by gnuweeb.org (Postfix) with ESMTPSA id 34B667E3B6;
        Tue,  7 Mar 2023 20:39:00 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1678221543;
        bh=HuOXsRa6OOAdvmzzWqWh41PN9s754FgA8d/ossCWLuc=;
        h=From:To:Cc:Subject:Date:From;
        b=N9+GPfhV6BAnvN4mKn9EliZXLR5LiGiD4stsTL1seNVhVMpyXw2H0gKTnKtjhofKY
         csKTEZAc6kVAJrUULYW+BfiwvCOb180UgtOOpKIlVtYOiudUu/oJrSw0fmdDExGNvg
         bLnLKu5dMCK2CbOlGRcu5gT2AZWycglE6UVVe5J4KblN2Ue2nBtUlUFWOn+BaLGizt
         1yffJm5Vhf+N7X0HF98I1B3nHQJz1Im9FTzwjZ8RDEuexwaQ8WzSmCze2pEqOnT+0c
         LVg2bFYmuhQYO2wVobZ0SZHsDHLe/aIc9RfB7T77LSmSfWu7AYFgv06sJ7iVAE4tvG
         tHJ9kC/jsHb9w==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH liburing v1 0/3] Small fixes and CI update
Date:   Wed,  8 Mar 2023 03:38:27 +0700
Message-Id: <20230307203830.612939-1-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Just a boring patchset.

- Address the recent io_uring-udp bug report on GitHub.
- No more sign-compare warnings on the GitHub build bot.
- Kill trailing whitespaces (manpage).

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

Ammar Faizi (3):
  io_uring-udp: Fix the wrong `inet_ntop()` argument
  github: Append `-Wno-sign-compare` to the GitHub build bot CFLAGS
  man/io_uring_register_{buffers,files}: Kill trailing whitespaces

 .github/workflows/build.yml     |  2 +-
 examples/io_uring-udp.c         |  2 +-
 man/io_uring_register_buffers.3 | 10 +++++-----
 man/io_uring_register_files.3   | 22 +++++++++++-----------
 4 files changed, 18 insertions(+), 18 deletions(-)


base-commit: 0dd82f0c63d468c5b3d9510af642968ce6e8ee21
-- 
Ammar Faizi

