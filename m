Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC64D4D246A
	for <lists+io-uring@lfdr.de>; Tue,  8 Mar 2022 23:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350766AbiCHWlZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Mar 2022 17:41:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238847AbiCHWlY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Mar 2022 17:41:24 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ACCD31927
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 14:40:26 -0800 (PST)
Received: from localhost.localdomain (unknown [138.197.159.143])
        by gnuweeb.org (Postfix) with ESMTPSA id C981C7E6B9;
        Tue,  8 Mar 2022 22:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1646779225;
        bh=pHc/wN3tvohEG+iwRpApKyw1KnqQApGVOi0RFbms7LI=;
        h=From:To:Cc:Subject:Date:From;
        b=YjQollxhx7Qc6O/Etl/SPTzECgypOPu03KxJNLTTQ1UjZ+sCNmSYI6dIVvst75Bgw
         /cRXC1HEMYqU5Aec/2nlKfXWMsEgM8Z2D10G4f8gCr8RRK/uET9WO0Q4nkRPep0n0l
         aED4FTSqJr1Zx+/iHu7cKPQQ9bbnz3wxrYGDXArb6p6y+mO03nbZct3PWHn3JJRLAu
         /FJu3rJU50cifDJSpn2Xt9PYGCYc7kWYJC6O3ocIetBLEfTorbQbA6llNaGKiCNJQI
         ciGGjmvmMeKYpOWfGbG5pvF7hBobzbhTZHjEpYhvktaW24Ywe66CKuu4zyf+ubLH0b
         ifLHOgFTH0eyQ==
From:   Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>,
        io-uring@vger.kernel.org, gwml@vger.gnuweeb.org
Subject: [PATCH liburing 0/2] Changes for src/Makefile
Date:   Tue,  8 Mar 2022 22:40:00 +0000
Message-Id: <20220308224002.3814225-1-alviro.iskandar@gnuweeb.org>
X-Mailer: git-send-email 2.27.0
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

Hello sir,

This patchset changes src/Makefile. 2 patches here:

1. Remove -fomit-frame-pointer flag, because it's already covered
   by the -O2 optimization flag.

2. Add file dependencies for the object files. When the header
   files are modified, the compiled object are not going to be
   recompiled because the header files are not marked as dependency
   for the objects. Add those header files as dependency so it is
   safe not to do "make clean" after changing those files.

please review,
thx

Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
---
Alviro Iskandar Setiawan (2):
  src/Makefile: Remove `-fomit-frame-pointer` from default build
  src/Makefile: Add header files as dependency

 src/Makefile | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)


base-commit: 6231f56da7881bde6fb011e1b54d672f8fe5a224
-- 
2.32.0

