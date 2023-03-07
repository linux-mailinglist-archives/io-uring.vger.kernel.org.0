Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 311226AF6D0
	for <lists+io-uring@lfdr.de>; Tue,  7 Mar 2023 21:39:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbjCGUjM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Mar 2023 15:39:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbjCGUjK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Mar 2023 15:39:10 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 834369E313;
        Tue,  7 Mar 2023 12:39:09 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.169])
        by gnuweeb.org (Postfix) with ESMTPSA id 299A57E3B6;
        Tue,  7 Mar 2023 20:39:06 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1678221549;
        bh=IMx6ex/rLOT7NC83zfmminX+0WNHq9zZx2/kJgKw2Tg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QVtjiYbraMVInnsXLwgoKvRSu7RfnslcwMXXpOVDqm/ejLHCNPNL+peOOANIdNzJW
         ie4r93BrZij+zgb+gpoksSRINt7xLjldGvM60J6YsIoMZRHog5ZhTuG2hzr33gyuBX
         B7IVtJU7Bjpb6hI9O4mxJvGoHcz9XMi15G9MOD8Q9LPg3nEQbXO5uno8q8/4Zq0kqY
         SlzrOHbLlQ87iKxi8xA/LtZlVXsJOA2akeffdWi7RATpAR7lndHGVXyoOFD29ahI2H
         qmX4K0AqsfSnaOKyWB6Te3qfCbsVYoziw6LBYrtcDPaExrGTbQjvAGb9DastU1obPw
         VDQzActboGFAg==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH liburing v1 2/3] github: Append `-Wno-sign-compare` to the GitHub build bot CFLAGS
Date:   Wed,  8 Mar 2023 03:38:29 +0700
Message-Id: <20230307203830.612939-3-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230307203830.612939-1-ammarfaizi2@gnuweeb.org>
References: <20230307203830.612939-1-ammarfaizi2@gnuweeb.org>
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

Kill the sign-compare warning on the GitHub build bot because Jens
doesn't like it. See commit 4c79857b9354 ("examples/send-zerocopy:
cleanups").

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 .github/workflows/build.yml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/.github/workflows/build.yml b/.github/workflows/build.yml
index 29b80bfec1d208c0..fed5b38c3a507336 100644
--- a/.github/workflows/build.yml
+++ b/.github/workflows/build.yml
@@ -86,7 +86,7 @@ jobs:
             cxx: mips-linux-gnu-g++
 
     env:
-      FLAGS: -g -O3 -Wall -Wextra -Werror ${{matrix.extra_flags}}
+      FLAGS: -g -O3 -Wall -Wextra -Werror -Wno-sign-compare ${{matrix.extra_flags}}
 
       # Flags for building sources in src/ dir only.
       LIBURING_CFLAGS: ${{matrix.liburing_extra_flags}}
-- 
Ammar Faizi

