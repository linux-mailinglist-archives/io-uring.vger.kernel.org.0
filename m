Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBE5E4F0BB8
	for <lists+io-uring@lfdr.de>; Sun,  3 Apr 2022 20:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240468AbiDCSYa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Apr 2022 14:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239569AbiDCSY3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Apr 2022 14:24:29 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58090344D1
        for <io-uring@vger.kernel.org>; Sun,  3 Apr 2022 11:22:35 -0700 (PDT)
Received: from integral2.. (unknown [182.2.43.220])
        by gnuweeb.org (Postfix) with ESMTPSA id 04A307E30F;
        Sun,  3 Apr 2022 18:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1649010155;
        bh=x4yhWR1UtrL32lirT86h0VV4Xcp+4Aog5wzMfsYs8XI=;
        h=From:To:Cc:Subject:Date:From;
        b=n1DvWk/4+IWfi59up0CZlPaBOfi/7PNcUvuUn9oL65teIdgoY+zOaHQpLbwPleCkK
         xFp3dzxoF0TRStUWtsac6kHr3EWELoTn7gOG5I377eSoj59Z5O1mybJe3F3qVRXya3
         3bWzGpjO1xYg0+3oowumu90a0ebfSmNh+mmkZT+o4D0h4QoH07WEj+qvIdffYw/sYP
         Zm5FTWp0KujWmxA3N8ewHJxpicE2hqhszUjImvLLrWKFtxCYgXZD8RjCbfLRAjIgSS
         bMDeSbFnzl7d/tLZPtHWZCRdECmLJj6UY7Lyg7l1tgIJRgrEX0vC5DOAI0Dc0dqsQm
         7vx5Y6A1tjpIw==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v2 0/3] Simplify build for tests and gitignore cleanup
Date:   Mon,  4 Apr 2022 01:21:57 +0700
Message-Id: <20220403182200.259937-1-ammarfaizi2@gnuweeb.org>
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

This is the v2, there are 3 patches in this series:

  - Rename `[0-9a-f]-test.c` to `[0-9a-f].c`.

  - Append -lpthread for all tests and remove the LDFLAGS override
    for tests that use pthread.

  - Append `.t` to the test binary filename for gitignore simplification.


## Changelog

v2:
  - Rename `[0-9a-f]-test.c` to `[0-9a-f].c`.
  - Append `.t` instead of `.test`.

Link v1: https://lore.kernel.org/io-uring/20220403153849.176502-1-ammarfaizi2@gnuweeb.org


Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

Ammar Faizi (3):
  test: Rename `[0-9a-f]-test.c` to `[0-9a-f].c`
  test/Makefile: Append -lpthread for all tests
  test/Makefile: Append `.t` to the test binary

 .gitignore                                   | 131 +------------------
 test/{232c93d07b74-test.c => 232c93d07b74.c} |   0
 test/{35fa71a030ca-test.c => 35fa71a030ca.c} |   0
 test/{500f9fbadef8-test.c => 500f9fbadef8.c} |   0
 test/{7ad0e4b2f83c-test.c => 7ad0e4b2f83c.c} |   0
 test/{8a9973408177-test.c => 8a9973408177.c} |   0
 test/{917257daa0fe-test.c => 917257daa0fe.c} |   0
 test/Makefile                                |  62 +++------
 test/{a0908ae19763-test.c => a0908ae19763.c} |   0
 test/{a4c0b3decb33-test.c => a4c0b3decb33.c} |   0
 test/{b19062a56726-test.c => b19062a56726.c} |   0
 test/{b5837bd5311d-test.c => b5837bd5311d.c} |   0
 test/{ce593a6c480a-test.c => ce593a6c480a.c} |   0
 test/{d4ae271dfaae-test.c => d4ae271dfaae.c} |   0
 test/{d77a67ed5f27-test.c => d77a67ed5f27.c} |   0
 test/{eeed8b54e0df-test.c => eeed8b54e0df.c} |   0
 test/{fc2a85cb02ef-test.c => fc2a85cb02ef.c} |   0
 17 files changed, 22 insertions(+), 171 deletions(-)
 rename test/{232c93d07b74-test.c => 232c93d07b74.c} (100%)
 rename test/{35fa71a030ca-test.c => 35fa71a030ca.c} (100%)
 rename test/{500f9fbadef8-test.c => 500f9fbadef8.c} (100%)
 rename test/{7ad0e4b2f83c-test.c => 7ad0e4b2f83c.c} (100%)
 rename test/{8a9973408177-test.c => 8a9973408177.c} (100%)
 rename test/{917257daa0fe-test.c => 917257daa0fe.c} (100%)
 rename test/{a0908ae19763-test.c => a0908ae19763.c} (100%)
 rename test/{a4c0b3decb33-test.c => a4c0b3decb33.c} (100%)
 rename test/{b19062a56726-test.c => b19062a56726.c} (100%)
 rename test/{b5837bd5311d-test.c => b5837bd5311d.c} (100%)
 rename test/{ce593a6c480a-test.c => ce593a6c480a.c} (100%)
 rename test/{d4ae271dfaae-test.c => d4ae271dfaae.c} (100%)
 rename test/{d77a67ed5f27-test.c => d77a67ed5f27.c} (100%)
 rename test/{eeed8b54e0df-test.c => eeed8b54e0df.c} (100%)
 rename test/{fc2a85cb02ef-test.c => fc2a85cb02ef.c} (100%)


base-commit: 314dd7ba2aa9d0ba5bb9a6ab28b7204dd319e386
-- 
Ammar Faizi

