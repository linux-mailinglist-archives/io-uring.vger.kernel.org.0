Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 700C76FE085
	for <lists+io-uring@lfdr.de>; Wed, 10 May 2023 16:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237528AbjEJOkV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 May 2023 10:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237486AbjEJOkQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 May 2023 10:40:16 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EACEEAD27;
        Wed, 10 May 2023 07:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1683729610;
        bh=6R/GOaUO5DOD37ZaNkx3J3tRaIamM2Esvxxoksqfu6I=;
        h=From:To:Cc:Subject:Date;
        b=WHei+S+Lfmkf9bfkpsuV8oEqW2JkMXQ6HbFnNGe5FvnUI+gGZ9NfxwJ2wMMvYo/Ri
         2T7KHmK98Y47VGFZOf7ctun6hCiNeTaB2Hwobwlh3o28vrluOZydEbo09OFabljR4F
         EQZPzfqiN6lvcx4Xleod/NGkKisg5KthaKTlyZQr0HRLET8sa9LGIs9wY7O2H+Vynv
         JZRV3ShqfuTTARkl8anYGpdK+Sr3au5JhhG1P9tYmu4RivCa1DQ0fPPcO7dV1daQKN
         ob7+pkebBvGsZFPFuI/ANdGiAjNXDKkwcr8o/XPHLTTLIib186l0h65E7rdvPEVo/S
         6fZjEk+6v1zvA==
Received: from integral2.. (unknown [101.128.114.135])
        by gnuweeb.org (Postfix) with ESMTPSA id DAC1D245CF0;
        Wed, 10 May 2023 21:40:07 +0700 (WIB)
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        =?UTF-8?q?Barnab=C3=A1s=20P=C5=91cze?= <pobrn@protonmail.com>,
        Michael William Jonathan <moe@gnuweeb.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v1 0/2] 2 fixes for recv-msgall.c
Date:   Wed, 10 May 2023 21:39:25 +0700
Message-Id: <20230510143927.123170-1-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

This is the follow up patchset for the recent issue found in
recv-msgall.c. There are two patches in this series.

1. Fix undefined behavior in `recv_prep()`.
The lifetime of `struct msghdr msg;` must be long enough until the CQE
is generated because the recvmsg operation will write to that storage. I
found this test segfault when compiling with -O0 optimization. This is
undefined behavior and may behave randomly. Fix this by making the
lifetime of `struct msghdr msg;` long enough.

2. Fix invalid mutex usage.
Calling pthread_mutex_lock() twice with the same mutex in the same
thread without unlocking it first is invalid. The intention behind this
pattern was to wait for the recv_fn() thread to be ready. Use the
pthread barrier instead. It is more straightforward and correct.

Please apply!

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
--- 

Ammar Faizi (2):
  recv-msgall: Fix undefined behavior in `recv_prep()`
  recv-msgall: Fix invalid mutex usage

 test/recv-msgall.c | 44 +++++++++++++++++++++-----------------------
 1 file changed, 21 insertions(+), 23 deletions(-)


base-commit: 4961ac480052089a94978e9f771d513551aff61b
-- 
Ammar Faizi

