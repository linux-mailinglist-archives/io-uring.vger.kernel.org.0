Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8760B4B7069
	for <lists+io-uring@lfdr.de>; Tue, 15 Feb 2022 17:39:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237963AbiBOPmq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Feb 2022 10:42:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242435AbiBOPm3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Feb 2022 10:42:29 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38800D108B
        for <io-uring@vger.kernel.org>; Tue, 15 Feb 2022 07:37:30 -0800 (PST)
Received: from integral2.. (unknown [36.68.63.145])
        by gnuweeb.org (Postfix) with ESMTPSA id E8D4C7E29B;
        Tue, 15 Feb 2022 15:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1644939435;
        bh=d+tBsCCqAz1GQeXa7OcP8/LjbQ6AqEf2Q80Mc7KOBZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MhWaFbflf4VycfsBth9epBgByByJet2tKIV51h7uoBVKYKN5HIYssfX0G9buc3HkJ
         Hg0bQVzjbGeEVKD3Y9Lg7RuYv3aRvXgjFhSb8wTMMRqxlTsBXtbU8O4GmLHihDHoog
         eDxJC/J2JR9YKCoxLKMMtdiJMoM1/m5gYfzduj+4BBxSqpZeTvj7+iEga6U7aX3eB9
         zZTq5JWGLgcwy9oXzZrfDY9YJavFjcV1HQXQlYOQh5zR9668yU686OnyRrdowt0S8W
         aHuf5h8PYT6nSm1PsfoSWa1t3ppmurUVkaxVAtmEwqjuLawS7GETenigcYXFerDk6j
         8Nn3ooBFb8sNA==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Tea Inside Mailing List <timl@vger.teainside.org>,
        Nugra <richiisei@gmail.com>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH liburing v1 1/2] configure: Support busybox mktemp
Date:   Tue, 15 Feb 2022 22:36:50 +0700
Message-Id: <20220215153651.181319-2-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220215153651.181319-1-ammarfaizi2@gnuweeb.org>
References: <20220215153651.181319-1-ammarfaizi2@gnuweeb.org>
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

From: Nugra <richiisei@gmail.com>

Busybox mktemp does not support `--tmpdir`, it says:
    mktemp: unrecognized option: tmpdir

It can be fixed with:
1. Create a temporary directory.
2. Use touch to create the temporary files inside the directory.
3. Clean up by deleting the temporary directory.

Signed-off-by: Nugra <richiisei@gmail.com>
Link: https://t.me/GNUWeeb/530154
[ammarfaizi2: Rephrase the commit message and add touch command]
[ammarfaizi2: s/fio/liburing/]
Co-authored-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 configure | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/configure b/configure
index 805a671..1f7f1c3 100755
--- a/configure
+++ b/configure
@@ -78,14 +78,17 @@ EOF
 exit 0
 fi
 
-TMPC="$(mktemp --tmpdir fio-conf-XXXXXXXXXX.c)"
-TMPC2="$(mktemp --tmpdir fio-conf-XXXXXXXXXX-2.c)"
-TMPO="$(mktemp --tmpdir fio-conf-XXXXXXXXXX.o)"
-TMPE="$(mktemp --tmpdir fio-conf-XXXXXXXXXX.exe)"
+TMP_DIRECTORY="$(mktemp -d)"
+TMPC="$TMP_DIRECTORY/liburing-conf.c"
+TMPC2="$TMP_DIRECTORY/liburing-conf-2.c"
+TMPO="$TMP_DIRECTORY/liburing-conf.o"
+TMPE="$TMP_DIRECTORY/liburing-conf.exe"
+
+touch $TMPC $TMPC2 $TMPO $TMPE
 
 # NB: do not call "exit" in the trap handler; this is buggy with some shells;
 # see <1285349658-3122-1-git-send-email-loic.minier@linaro.org>
-trap "rm -f $TMPC $TMPC2 $TMPO $TMPE" EXIT INT QUIT TERM
+trap "rm -rf $TMP_DIRECTORY" EXIT INT QUIT TERM
 
 rm -rf config.log
 
-- 
2.32.0

