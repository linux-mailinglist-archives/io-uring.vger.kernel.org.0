Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A11766039E
	for <lists+io-uring@lfdr.de>; Fri,  6 Jan 2023 16:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbjAFPnO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 Jan 2023 10:43:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbjAFPnN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 Jan 2023 10:43:13 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F016341648
        for <io-uring@vger.kernel.org>; Fri,  6 Jan 2023 07:43:12 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.184])
        by gnuweeb.org (Postfix) with ESMTPSA id 1A16C7E3C7;
        Fri,  6 Jan 2023 15:43:09 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1673019792;
        bh=yYZgSYnmlWmkpfH1MkyInsgHg0JmCJR27glBHkpEXpo=;
        h=From:To:Cc:Subject:Date:From;
        b=qr4qiL6oknxGyAc/jBfcpirJv4Na/6nJSbU71DiAMDNSr0/90DiGewgne2JVa+I++
         r9M9Ps2etz8nDHbP39LpSzDNyizC3UyOTFbcB/QyDZU3pw4qLggSAnukfn0TM/Fbv0
         ++tuuGa5GTrjl1hhKPSJr0eCvA0A2glCroTnvV1pQVzVhC3vTVtgzh35DGjxDijQ+R
         cvlojrk7ukth0ECiN0gPtdDPn2WSwaCD2d84nI30lu56KSMcMkvKJhj/z70QfNGvD8
         J3fyitz+7PCE9rSh4d1MW9Ug7ff5e40XpmxRNJDc2gep7jcVPxBem8pzoVTmzlija5
         2bITycApSld1Q==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        VNLX Kernel Department <kernel@vnlx.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Subject: [PATCH liburing v1 0/2] liburing micro-optimzation
Date:   Fri,  6 Jan 2023 22:42:57 +0700
Message-Id: <20230106154259.556542-1-ammar.faizi@intel.com>
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

Hi Jens,

This series contains liburing micro-optimzation. There are two patches
in this series:

## Patch 1
- Fix bloated memset due to unexpected vectorization.
  Clang and GCC generate an insane vectorized memset() in nolibc.c.
  liburing doesn't need such a powerful memset(). Add an empty inline ASM
  to prevent the compilers from over-optimizing the memset().

## Patch 2
- Simplify `io_uring_register_file_alloc_range()` function.
  Use a struct initializer instead of memset(). It simplifies the C code
  plus effectively reduces the code size.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
Ammar Faizi (2):
  nolibc: Fix bloated memset due to unexpected vectorization
  register: Simplify `io_uring_register_file_alloc_range()` function

 src/nolibc.c   | 9 ++++++++-
 src/register.c | 9 ++++-----
 2 files changed, 12 insertions(+), 6 deletions(-)


base-commit: c76d392035fd271980faa297334268f2cd77d774
-- 
Ammar Faizi

