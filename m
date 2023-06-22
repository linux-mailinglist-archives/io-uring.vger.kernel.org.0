Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2553373A716
	for <lists+io-uring@lfdr.de>; Thu, 22 Jun 2023 19:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbjFVRUq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Jun 2023 13:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbjFVRUi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Jun 2023 13:20:38 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 555FF19A9;
        Thu, 22 Jun 2023 10:20:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1687454436;
        bh=kqY+PXK/BHeCUujDvP0OTwyGNYeTRsgl8KnpZQ6sEx0=;
        h=From:To:Cc:Subject:Date;
        b=nRRA0/7QC0abjoTuDRJ3wJvKcqpQqPpJLhfTPZyGR93TzsXFmQgRB8+H/IEiwlYGa
         nGjWIpSoAnvynqkwqNO0ZrlXPYQb+TSBftuBGQlYe/dCKev8yv8uV/CWzWeNlKen89
         22JbFidcg7W/z0lBZGKFlPv0t9gl+6eg5U/dQmgoEKaQWwg9OK+ZrtNLvDVZa05e6l
         vIgIck4ZXGjLHTTAUXFEb0Mm8gVzqG40dyYvk2BgwU0F04aw4ep+Gg0jg/GQu9OjKH
         GheqIu4tYckPUphce4DHErsP6rthZW5NS0pSouXZSP+RKgZen/g7iqhAWyXj34CIVL
         wvPGt1o0j4R4w==
Received: from integral2.. (unknown [68.183.184.174])
        by gnuweeb.org (Postfix) with ESMTPSA id 44E9C249D74;
        Fri, 23 Jun 2023 00:20:33 +0700 (WIB)
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Guillem Jover <guillem@hadrons.org>,
        Jeff Moyer <jmoyer@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Michael William Jonathan <moe@gnuweeb.org>,
        Matthew Patrick <ThePhoenix576@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [RFC PATCH liburing v1 0/3] Introduce '--use-libc' option
Date:   Fri, 23 Jun 2023 00:20:26 +0700
Message-Id: <20230622172029.726710-1-ammarfaizi2@gnuweeb.org>
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

Hi Jens,
Hi Stefan and Guillem,

This is an RFC patch series to introduce the '--use-libc' option to the
configure script.

Currently, when compiling liburing on x86, x86-64, and aarch64
architectures, the resulting binary lacks the linkage with the standard
C library (libc).

To address the concerns raised by Linux distribution package maintainers
regarding security, it is necessary to enable the linkage of libc to
liburing. Especially right now, when the security of io_uring is being
scrutinized. By incorporating the '--use-libc' option, developers can
now enhance the overall hardening of liburing by utilizing compiler
features such as the stack protector and address sanitizer.

See the following links for viewing the discussion:
Link: https://security.googleblog.com/2023/06/learnings-from-kctf-vrps-42-linux.html
Link: https://lore.kernel.org/io-uring/20230621100447.GD2667602@fedora
Link: https://lore.kernel.org/io-uring/ZJLkXC7QffsoCnpu@thunder.hadrons.org

There are three patches in this series.

  - The first patch removes the '--nolibc' option from the configure
    script as it is no longer needed. The default build on x86, x86-64,
    and aarch64 architectures is still not using libc.

  - The second patch introduces the '--use-libc' option to the configure
    script. This option enables the linkage of libc to liburing.

  - The third patch allows the use of the stack protector when building
    liburing with libc.

Please review. Thank you.

Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

Ammar Faizi (3):
  configure: Remove --nolibc option
  configure: Introduce '--use-libc' option
  src/Makefile: Allow using stack protector with libc

 configure    | 40 +++++++++++++++-------------------------
 src/Makefile |  7 +++----
 2 files changed, 18 insertions(+), 29 deletions(-)


base-commit: 49fa118c58422bad38cb96fea0f10af60691baa9
-- 
Ammar Faizi

