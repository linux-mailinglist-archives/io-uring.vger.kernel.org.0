Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E643667A4B
	for <lists+io-uring@lfdr.de>; Thu, 12 Jan 2023 17:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbjALQGT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Jan 2023 11:06:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233471AbjALQFz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Jan 2023 11:05:55 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F8E45AC4E;
        Thu, 12 Jan 2023 07:57:19 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.184])
        by gnuweeb.org (Postfix) with ESMTPSA id DDA3D7E73F;
        Thu, 12 Jan 2023 15:57:14 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1673539038;
        bh=L3owUwAQTcGDFP+VbIiTwKgrDGKNNsJz9xcK8cYS6xk=;
        h=From:To:Cc:Subject:Date:From;
        b=ZPXdzdWGIbG5sr3cMAID6mHcsXJpyKv8ebgll7uwY+fuN330P2TVrO6jFHwOtSoe+
         dOlqRYX0gKPG0vi4py7QCS5Ry1K7z2Tg2HB2BxO1slb/FN62Xz9JGusTL31j0pU1pG
         WN6MRbvrqFLHSUiJBpmi8JgtJN25mCzAlTv7uQtIysql8TSlMlXA3EPXbs2VntBLb1
         pHSwDAwvw7V6oFg4lmuVkDZmQW09SSdEnrePIVOnAwd/vkxl00yOJ3kLmypkA4+S+v
         6veUTG7RqiSUCtOp3pLFLN5OSXcWR+f7hz3/ayl2i+AhpbH3X6NPCCKKeqeReoS1Ek
         I8Rzu/KqsuypQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Breno Leitao <leitao@debian.org>,
        Christian Mazakas <christian.mazakas@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        VNLX Kernel Department <kernel@vnlx.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v1 0/4] liburing updates for 2.4
Date:   Thu, 12 Jan 2023 22:57:05 +0700
Message-Id: <20230112155709.303615-1-ammar.faizi@intel.com>
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

I have found two people confused about the io_uring_prep_splice()
function, especially on the offset part. The current manpage for
io_uring_prep_splice() doesn't tell about the rules of the offset
arguments.

Despite these rules are already noted in "man 2 io_uring_enter",
people who want to know about this prep function will prefer to read
"man 3 io_uring_prep_splice". Let's explain it there.

Additionally, this series also contains:

  - Fix a typo: 's/is adjust/is adjusted/' and indentation in
    liburing.h.

  - Add io_uring_prep_msg_ring_cqe_flags() to liburing-ffi.map.
    Commit 27180d7be059 ("Add io_uring_prep_msg_ring_cqe_flags
    function") adds a new inline function in liburing.h, but it doesn't
    update the liburing-ffi.map file. Update it.

  - Note about --nolibc configure option deprecation in the CHANGELOG.
    Since commit bfb432f4cce5 ("configure: Always enable `CONFIG_NOLIBC`
    if the arch is supported"), the --nolibc configure option is
    deprecated and has no effect. Plus, building liburing on x86-64,
    x86, and aarch64 always enables CONFIG_NOLIBC. Note these changes
    in the CHANGELOG file.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

Ammar Faizi (4):
  liburing-ffi.map: Add io_uring_prep_msg_ring_cqe_flags() function
  CHANGELOG: Note about --nolibc configure option deprecation
  liburing.h: 's/is adjust/is adjusted/' and fix indentation
  man/io_uring_prep_splice.3: Explain more about io_uring_prep_splice()

 CHANGELOG                  |  2 ++
 man/io_uring_prep_splice.3 | 38 ++++++++++++++++++++++++++++++++++++++
 src/include/liburing.h     |  4 ++--
 src/liburing-ffi.map       |  1 +
 4 files changed, 43 insertions(+), 2 deletions(-)

base-commit: 47679a9019e48bf4293a4f55adade9eae715f9e4
-- 
Ammar Faizi

