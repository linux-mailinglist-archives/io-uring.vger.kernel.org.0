Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9650A58E414
	for <lists+io-uring@lfdr.de>; Wed, 10 Aug 2022 02:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbiHJAc3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Aug 2022 20:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiHJAc2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Aug 2022 20:32:28 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBDB87170C
        for <io-uring@vger.kernel.org>; Tue,  9 Aug 2022 17:32:27 -0700 (PDT)
Received: from integral2.. (unknown [180.246.144.41])
        by gnuweeb.org (Postfix) with ESMTPSA id 9B43E80866;
        Wed, 10 Aug 2022 00:32:23 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1660091546;
        bh=wlaVVEiSuvW0dciSRkjkgO3E9S5zVmDzXzKRMwusc4I=;
        h=From:To:Cc:Subject:Date:From;
        b=HdqoYAmrOaVVl0Fcpo47T3jD3M/2GYeGzVQ/xequ/OR+QgDDNjXkI6sqoy0inGnXF
         FLQkNdP6mVirARiVPfCuHnLN1mxQ5fkvSdC9hgIM7CVq3KV1qVG7JdDriSxOVZO+TE
         fcpX6Y5Xnk6bQG5kIGRMrGVkUm3TZqPgjPh9z9QO6DsRTNT0o6hBgcne6zh7+zLS2f
         PtffKRxhczAU85HJvE99W9xip8Zi1pjcHjhV9djrRICldUYMWNpKRO7E9zV8v9FKy0
         ggAla5VPWpj68zMfUms/VEPfLc6adh6Ow73kst4tmzW8+ctDIzTSsYMC7eh8BjZVae
         0oE8zZVrnSpdQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Vitaly Chikunov <vt@altlinux.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Kanna Scarlet <knscarlet@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v1 00/10] liburing test fixes
Date:   Wed, 10 Aug 2022 07:31:49 +0700
Message-Id: <20220810002735.2260172-1-ammar.faizi@intel.com>
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

All test fixes of "reading uninitialized memory" bug. Mostly just a
one liner change.

Reported-by: Vitaly Chikunov <vt@altlinux.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

Ammar Faizi (10):
  test/cq-overflow: Don't call `io_uring_queue_exit()` if the ring is not initialized
  test/eeed8b54e0df: Initialize the `malloc()`ed buffer before `write()`
  test/file-verify: Fix reading from uninitialized buffer
  test/fixed-reuse: Fix reading from uninitialized array
  test/fpos: Fix reading from uninitialized buffer
  test/statx: Fix reading from uninitialized buffer
  test/submit-link-fail: Initialize the buffer before `write()`
  test/232c93d07b74: Fix reading from uninitialized buffer
  test/eventfd-disable: Fix reading uninitialized variable
  test/file-register: Fix reading from uninitialized buffer

 test/232c93d07b74.c     | 2 +-
 test/cq-overflow.c      | 5 +++--
 test/eeed8b54e0df.c     | 1 +
 test/eventfd-disable.c  | 2 +-
 test/file-register.c    | 2 +-
 test/file-verify.c      | 5 ++++-
 test/fixed-reuse.c      | 2 +-
 test/fpos.c             | 3 +++
 test/statx.c            | 2 +-
 test/submit-link-fail.c | 2 +-
 10 files changed, 17 insertions(+), 9 deletions(-)


base-commit: 2757d61fa222739f77b014810894b9ccea79d7f3
-- 
Ammar Faizi

