Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7565704A5
	for <lists+io-uring@lfdr.de>; Mon, 11 Jul 2022 15:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbiGKNu7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Jul 2022 09:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiGKNu7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Jul 2022 09:50:59 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FEDC61B17
        for <io-uring@vger.kernel.org>; Mon, 11 Jul 2022 06:50:57 -0700 (PDT)
Received: from [192.168.88.254] (unknown [36.81.65.188])
        by gnuweeb.org (Postfix) with ESMTPSA id 96A6D7E312;
        Mon, 11 Jul 2022 13:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1657547457;
        bh=AzN+pngMrVvgNxYkRHcQF75/ubIjp8solRNTLfNspoA=;
        h=Date:To:Cc:From:Subject:From;
        b=NFwTOezPGJs1mgj1hHAcfSM8xZHa5nK9TZN7KYu80W/VRuLEtEtrjVt7u5qETs1J/
         lkjFigI3fwQPTXLQiholVQ562YSH8b8kZh1VSg/poDvZiduM6BUyodgvy17Afk9qDd
         VTcA15zJ89ZxjTIehGgD1cwEZtu2Q5hT2/oC0mDAF12fzZ97Qo+xl+boEN/Pw+0zAs
         YujCjKJa7c9fFdNdyLIxX5jowhYSBQD9HY0YyglOnX1DYpeFOsYRmOEk/7tww/fhWZ
         twXa+F/UDbB6yBkFZmZbZsszX8/39j/RbM70Kd6EZM8qgkFDR3UjLzm+zSRhAPqKmm
         QyiKu8vQ/xIhg==
Message-ID: <3b337606-9141-59cd-a9f5-936942f0ccc0@gnuweeb.org>
Date:   Mon, 11 Jul 2022 20:50:50 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [GIT PULL liburing] GitHub bot updates 2022-07-11
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Hello Jens,

GitHub bot updates for liburing:

   - Upgrade GitHub bot to Ubuntu 22.04 and gcc-11 (default gcc version on
     Ubuntu 22.04).

   - Use -O3 optimization.

Please pull!


The following changes since commit 696f28fa0c7eec22bdfade663d31b0f5c6385c77:

   Correct mistakes on send/recv* flags (2022-07-09 10:01:32 -0600)

are available in the Git repository at:

   https://github.com/ammarfaizi2/liburing.git tags/github-bot-2022-07-11

for you to fetch changes up to bc5868374f371ad3c6b2257ca48ef9e260613c0a:

   .github: Use `-O3` flag for GitHub bot (2022-07-11 20:10:58 +0700)

----------------------------------------------------------------
GitHub bot updates for liburing:

   - Upgrade GitHub bot to Ubuntu 22.04 and gcc-11.

   - Use -O3 optimization.

----------------------------------------------------------------
Ammar Faizi (2):
       .github: Upgrade GitHub bot to Ubuntu 22.04 and gcc-11
       .github: Use `-O3` flag for GitHub bot

  .github/workflows/build.yml | 4 ++--
  1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/.github/workflows/build.yml b/.github/workflows/build.yml
index fc119cb..333929c 100644
--- a/.github/workflows/build.yml
+++ b/.github/workflows/build.yml
@@ -7,7 +7,7 @@ on:
  
  jobs:
    build:
-    runs-on: ubuntu-latest
+    runs-on: ubuntu-22.04
  
      strategy:
        fail-fast: false
@@ -84,7 +84,7 @@ jobs:
              cxx: mips-linux-gnu-g++
  
      env:
-      FLAGS: -g -O2 -Wall -Wextra -Werror
+      FLAGS: -g -O3 -Wall -Wextra -Werror
  
      steps:
      - name: Checkout source

-- 
Ammar Faizi
