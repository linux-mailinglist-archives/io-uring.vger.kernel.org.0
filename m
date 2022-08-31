Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 300285A72EB
	for <lists+io-uring@lfdr.de>; Wed, 31 Aug 2022 02:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbiHaAsq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Aug 2022 20:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiHaAsp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Aug 2022 20:48:45 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A814E601;
        Tue, 30 Aug 2022 17:48:41 -0700 (PDT)
Received: from localhost.localdomain (unknown [182.2.75.186])
        by gnuweeb.org (Postfix) with ESMTPSA id 151D380909;
        Wed, 31 Aug 2022 00:48:37 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1661906920;
        bh=sILKrGLY87wqKpnCOwOekdL95a9T80Bo/Ge85ruxnQ8=;
        h=From:To:Cc:Subject:Date:From;
        b=EeelT5ehl/23HRwf0YCAVGvVDjI58b5JZ0CQuO7giI98NU8sNmW0q7zSyLdtVB308
         hRWpLiW6Ce4eXgcMqHFRh+x0lwGi2DPpdvv1ChXnBTmh9MYjqh03Jhcfg2x0an7ySz
         GVS1sVotWVPAblLzo4lLxEruZfNVlaWTt/mtDhXSSsmHH2UBNJWWEqGBgnLmh1llub
         VIVsA5/K222oeokVgLUpmjFAEoL29bm06mlUxa5msl6VvfzcYdD7aBGCmyvPwHnuw/
         AyfHFibBya611TkVO8oBTn8VLGTzvD0HD2Qg9L4OAXogLBp65O8UGSFUvWQmR0J5KX
         Jf7JHrrEdgcTA==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        Kanna Scarlet <knscarlet@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v1 0/3] liburing updates
Date:   Wed, 31 Aug 2022 07:48:14 +0700
Message-Id: <20220831004449.2619220-1-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
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

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Hi Jens,

Just small liburing updates this time.

1) github bot: Upgrade clang version to 16.

   clang-16 is now available, use it.

2) CHANGELOG update.

3) Small cleanup, remove unnecessary goto and label in queue.c.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

Ammar Faizi (3):
  github bot: Upgrade clang version to 16
  CHANGELOG: Note about `io_uring_{enter,enter2,register,setup}`
  queue: Remove unnecessary goto and label

 .github/workflows/build.yml | 6 +++---
 CHANGELOG                   | 1 +
 src/queue.c                 | 3 +--
 3 files changed, 5 insertions(+), 5 deletions(-)


base-commit: 1ef00fc157cd0fa96d4da355ee86c977b6e4169e
-- 
Ammar Faizi

