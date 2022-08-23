Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD97B59E536
	for <lists+io-uring@lfdr.de>; Tue, 23 Aug 2022 16:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbiHWOhZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Aug 2022 10:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242963AbiHWOga (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Aug 2022 10:36:30 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51D6A2BCECD;
        Tue, 23 Aug 2022 04:53:50 -0700 (PDT)
Received: from localhost.localdomain (unknown [125.160.110.187])
        by gnuweeb.org (Postfix) with ESMTPSA id 5065B8061E;
        Tue, 23 Aug 2022 11:52:49 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1661255572;
        bh=xeK/grg+kOqd4rx4Lqkzew3o9a07RqdooWZuXwMipMo=;
        h=From:To:Cc:Subject:Date:From;
        b=sLl8fFmTdpSfF2oGMjw7fHcKnmshSeADhQNA6AxK+Ju1bSVObTBz6KM7P3AJ8Yc1A
         H9w7fHSmuzTJZP+k4vA9QAVsVdMLraRX2Wk0Rt3MkmBMJlgro9WX+CPukVqhEkxO1p
         cGGhzQG9fw94ThpATIDCJzSu0YbyzCkhmggHwglvoZ/Q9xJ7ewMrSwkRYYcB3PBjgR
         5nKfFSP0GShFlZ7PQANv8WmjSFu2dGo/xe4Af8pP5U4uuQjehzvC6dMKmnQ0rDhIER
         cFP6toy1BHdA6atBfcgxgwFA33RVFnFiSpSHzKcRg+6MbkKWlekdSnER6OGDQQDkYz
         K428mETEVs9LQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Dylan Yudaken <dylany@fb.com>,
        Facebook Kernel Team <kernel-team@fb.com>,
        Kanna Scarlet <knscarlet@gnuweeb.org>
Subject: [PATCH liburing 0/2] liburing uapi and manpage update
Date:   Tue, 23 Aug 2022 18:52:42 +0700
Message-Id: <20220823114813.2865890-1-ammar.faizi@intel.com>
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

There are two patches in this series.

1) Sync the argument data type with `man 2 renameat`.

2) On top of io_uring series I just sent, copy uapi io_uring.h to
   liburing. Sync with the kernel.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

Ammar Faizi (2):
  liburing: Change the type of `flags` in `io_uring_prep_renameat()` to `unsigned int`
  io_uring: uapi: Sync with the kernel

 man/io_uring_prep_renameat.3    |  4 +-
 src/include/liburing.h          |  2 +-
 src/include/liburing/io_uring.h | 66 ++++++++++++++++++++++++---------
 3 files changed, 51 insertions(+), 21 deletions(-)


base-commit: bf3fedba890e66d644692910964fe1d8cbf4fb1b
-- 
Ammar Faizi

