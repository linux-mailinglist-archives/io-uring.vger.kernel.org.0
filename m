Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8266E32A4
	for <lists+io-uring@lfdr.de>; Sat, 15 Apr 2023 18:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbjDOQ72 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Apr 2023 12:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbjDOQ71 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Apr 2023 12:59:27 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AA3B4685;
        Sat, 15 Apr 2023 09:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1681577954;
        bh=HVup6Nwi3vb9vRTlnVPxuqqQMSwEiPn9C+mF4ZjeNjI=;
        h=From:To:Cc:Subject:Date;
        b=rXkDBOPaP1kTlMYfClfz4dmROqTlur89vnhnh4fA24V4gBEoESSVGJvVTdXx3FY3H
         DHEpDnwTfnw3rlXG33EKHXB6ky1yTFAxD8Bv4YEIRk8OsHayOwYEkauvl4h9Z8ZxTe
         hGOOLoBliUW1VIUE4LU3q5Y2xtQfxm2Vy4E6Bb3qnpa/oGB1epaohmUNPIZipXiv5D
         y/W131RKowWG+Tu9hbYjeRNhBBKwKTQCddBQUnuEisRU9Oki6qG/H5lmExVl7u5iAm
         qJX74YTLWCFr2PTTa9CPy/phMwwdouK7VwhKJAkQ9bxhIrEUUXIT629nRRzHefjVLm
         KE7iGBMEcsGtQ==
Received: from localhost.localdomain (unknown [182.253.88.211])
        by gnuweeb.org (Postfix) with ESMTPSA id 472B92450ED;
        Sat, 15 Apr 2023 23:59:10 +0700 (WIB)
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing 0/3] io_uring-udp fix, manpage fix, and hppa cross-compiler
Date:   Sat, 15 Apr 2023 23:59:01 +0700
Message-Id: <20230415165904.791841-1-ammarfaizi2@gnuweeb.org>
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

Hi Jens,

There are three patches in this series:

1. Fix the wrong IPv6 address in io_uring-udp (me).

Before:

    port bound to 49567
    received 4 bytes 28 from ::2400:6180:0:d1:0:0:47048
    received 4 bytes 28 from ::2400:6180:0:d1:0:0:54755
    received 4 bytes 28 from ::2400:6180:0:d1:0:0:57968

(the IPv6 address is wrong)

After:

    port bound to 48033
    received 4 bytes 28 from [2400:6180:0:d1::6a4:a00f]:40456
    received 4 bytes 28 from [2400:6180:0:d1::6a4:a00f]:50306
    received 4 bytes 28 from [2400:6180:0:d1::6a4:a00f]:52291

2. io_uring_cqe_get_data() manpage fix (me).

The return value of io_uring_cqe_get_data() will be undefined if the
user_data is not set from the SQE side.

3. Add hppa cross-compiler to the CI (Alviro).

Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

Alviro Iskandar Setiawan (1):
  github: Add hppa cross compiler

Ammar Faizi (2):
  io_uring-udp: Fix the wrong IPv6 binary to string conversion
  man/io_uring_cqe_get_data.3: Fix a misleading return value

 .github/workflows/build.yml |  7 +++++++
 examples/io_uring-udp.c     | 14 +++++++++++---
 man/io_uring_cqe_get_data.3 |  2 +-
 3 files changed, 19 insertions(+), 4 deletions(-)


base-commit: 4fed79510a189cc7997f6d04855ebf7fb66cc323
-- 
Ammar Faizi

