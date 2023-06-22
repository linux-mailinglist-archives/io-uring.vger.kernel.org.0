Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D50873A717
	for <lists+io-uring@lfdr.de>; Thu, 22 Jun 2023 19:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbjFVRUr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Jun 2023 13:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbjFVRUq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Jun 2023 13:20:46 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AEBB1FF6;
        Thu, 22 Jun 2023 10:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1687454439;
        bh=+/aNz4y+AbrUpY8/J4QV4+dsn+DjkqAo9OG0y4IXBZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=YripPpPCn2et5Ls8aO59zAzUGY3GNlUgfimz8udbjwCD+bP9BKvW7LSjfuGyXpiSw
         1czeUWM5O79iYygjEJ4Hg/qAw4g99tsohoPaynvTODErOK6FqzY92qXUNGq7XjBOEP
         dcU36S1cpctrpKY6ILFmO0DyWHW+4VM6awvPb+KXkiqOhBw/Q3l+9fiv85WT19efyY
         0zfm5lgJe5HFnO/0LgR537lEEs6ZGYT8t1qgaE+9h9cIPxHibVpKwxLh7mxqJO0AAf
         SmVGH/Py0J/WBtKTzdg1i/B9xXLpTrFtMvKT3PCBArm7/9+33K29rKmvWuYT4Zsz3T
         6WG9226yCfK0w==
Received: from integral2.. (unknown [68.183.184.174])
        by gnuweeb.org (Postfix) with ESMTPSA id DA9DC249D78;
        Fri, 23 Jun 2023 00:20:36 +0700 (WIB)
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
Subject: [RFC PATCH liburing v1 1/3] configure: Remove --nolibc option
Date:   Fri, 23 Jun 2023 00:20:27 +0700
Message-Id: <20230622172029.726710-2-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230622172029.726710-1-ammarfaizi2@gnuweeb.org>
References: <20230622172029.726710-1-ammarfaizi2@gnuweeb.org>
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

This option was deprecated and planned to be removed. Now remove it.

Co-authored-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 configure | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/configure b/configure
index 28f3eb0aee24f9ea..a16ffca83d678364 100755
--- a/configure
+++ b/configure
@@ -5,22 +5,6 @@ set -e
 cc=${CC:-gcc}
 cxx=${CXX:-g++}
 
-#
-# TODO(ammarfaizi2): Remove this notice and `--nolibc` option.
-#
-nolibc_deprecated() {
-  echo "";
-  echo "=================================================================";
-  echo "";
-  echo "  --nolibc option is deprecated and has no effect.";
-  echo "  It will be removed in a future liburing release.";
-  echo "";
-  echo "  liburing on x86-64, x86 (32-bit) and aarch64 always use CONFIG_NOLIBC.";
-  echo "";
-  echo "=================================================================";
-  echo "";
-}
-
 for opt do
   optarg=$(expr "x$opt" : 'x[^=]*=\(.*\)' || true)
   case "$opt" in
@@ -42,8 +26,6 @@ for opt do
   ;;
   --cxx=*) cxx="$optarg"
   ;;
-  --nolibc) nolibc_deprecated
-  ;;
   *)
     echo "ERROR: unknown option $opt"
     echo "Try '$0 --help' for more information"
@@ -91,7 +73,6 @@ Options: [defaults in brackets after descriptions]
   --datadir=PATH           install shared data in PATH [$datadir]
   --cc=CMD                 use CMD as the C compiler
   --cxx=CMD                use CMD as the C++ compiler
-  --nolibc                 build liburing without libc
 EOF
 exit 0
 fi
-- 
Ammar Faizi

