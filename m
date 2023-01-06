Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 781586603B6
	for <lists+io-uring@lfdr.de>; Fri,  6 Jan 2023 16:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbjAFPwW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 Jan 2023 10:52:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234693AbjAFPwS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 Jan 2023 10:52:18 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A42D11A27
        for <io-uring@vger.kernel.org>; Fri,  6 Jan 2023 07:52:16 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.184])
        by gnuweeb.org (Postfix) with ESMTPSA id 848447E509;
        Fri,  6 Jan 2023 15:52:13 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1673020336;
        bh=vMr/dqwnZoaMfjWMuhaE7Kb5PPHdL3rS1WAeVIsUgUI=;
        h=From:To:Cc:Subject:Date:From;
        b=FBU8BT1q9StBTlOUhS4PNEzGIczFqgMS0czxJfOED2X+2SaQr/gLWP3E7wKljmXNs
         h5+dgrnfjX/y81yc5o5TgOs34LVc+netbr/gH5A7G280ttvHsVHLAKrBZlcGbzXQro
         dVkLLsKPcaFq+6GKtW7PvnLefvD09vhEKfpEvQzN01moIOSwZQ2BR15Ud1BoMA9Lys
         0+50y8DHgX6pnUG/t41qN/xD2db4CMdkHlNoCsZrG8ooJ20M0HxuaoK2XJAGk4fpED
         Jgcm43ed//zemoeDFxwjcYbaJZQvaQ+DfcH2jgQ1+DNykHP44ixK4a+fQntrCyPxDr
         93xpwjRYFFN7A==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        VNLX Kernel Department <kernel@vnlx.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Subject: [RFC PATCH liburing v1 0/2] Always enable CONFIG_NOLIBC if supported and deprecate --nolibc option
Date:   Fri,  6 Jan 2023 22:52:00 +0700
Message-Id: <20230106155202.558533-1-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLACK autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Hi Jens,

This is an RFC patchset. It's already build-tested.

Currently, the default liburing compilation uses libc as its dependency.
liburing doesn't depend on libc when it's compiled on x86-64, x86
(32-bit), and aarch64. There is no benefit to having libc.so linked to
liburing.so on those architectures.

Always enable CONFIG_NOLBIC if the arch is supported. If the
architecture is not supported, fallback to libc.

There are 2 patches in this series:

   - A preparation patch, remove --nolibc from the GitHub CI.

   - Always enable CONFIG_NOLIBC if supported and deprecate --nolibc.

After this series, --nolibc option is deprecated and has no effect.
I plan to remove this option in a future liburing release.

Comments welcome...

Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

Alviro Iskandar Setiawan (1):
  configure: Always enable `CONFIG_NOLIBC` if the arch is supported

Ammar Faizi (1):
  github: Remove nolibc build on the GitHub CI bot

 .github/workflows/build.yml | 10 ----------
 configure                   | 40 ++++++++++++++++++++++++++++++++-----
 2 files changed, 35 insertions(+), 15 deletions(-)


base-commit: c76d392035fd271980faa297334268f2cd77d774
-- 
Ammar Faizi

