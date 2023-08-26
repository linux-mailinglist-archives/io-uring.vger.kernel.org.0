Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC923789741
	for <lists+io-uring@lfdr.de>; Sat, 26 Aug 2023 16:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232824AbjHZOST (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 26 Aug 2023 10:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbjHZORw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 26 Aug 2023 10:17:52 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C600B1FC7;
        Sat, 26 Aug 2023 07:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1693059469;
        bh=9mjh17Bbsueww6CP6SxHFHpg4WQGxKVP/+XaRmEx/Vg=;
        h=From:To:Cc:Subject:Date;
        b=ij5/g50uC9jHNam5jzz5OkcheMtsBH1BkTISjvimiaeHvXdoXF0ZiOUlzzcTrX+6u
         PnIERlQDI4dh32aM/X4BejfWDHRW7ApXX9XG1e64L+G0qGtUosacFefbwuLWmfgvpe
         v/39IQ1seNOtEp92q3gZUzus78bkmUDXNvL6wlXC0LmwYcx5hG+K8WlPtWimLQUtRt
         hUD1P0kie38S0Tv6zkok9x6i+BcYLns9ph0GcFJjRThpy2/5bt26Pwb3Sb9cnzFh5q
         KKGmEVhA81bWPu0I6OeJNvGqWtZC/qGRwHTEwa/l6l/GEkQ+WOPswlT/5lVUnk4B2e
         sNM1Lgb+tQaGA==
Received: from localhost.localdomain (unknown [182.253.126.208])
        by gnuweeb.org (Postfix) with ESMTPSA id 2EC3724B159;
        Sat, 26 Aug 2023 21:17:45 +0700 (WIB)
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Nicholas Rosenberg <inori@vnlx.org>,
        Michael William Jonathan <moe@gnuweeb.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH liburing v1 0/2] Two small fixes for the map file
Date:   Sat, 26 Aug 2023 21:17:32 +0700
Message-Id: <20230826141734.1488852-1-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

Two small fixes for the map file.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

Ammar Faizi (2):
  liburing.map: Remove `io_uring_queue_init_mem()` from v2.4
  liburing-ffi.map: Move `io_uring_prep_sock_cmd()` to v2.5

 src/liburing-ffi.map | 3 +--
 src/liburing.map     | 1 -
 2 files changed, 1 insertion(+), 3 deletions(-)


base-commit: 545829c013a26709e78a13c49bbf3a60ef9bdeee
-- 
Ammar Faizi

