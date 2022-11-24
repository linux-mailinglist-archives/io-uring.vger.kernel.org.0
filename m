Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA44637340
	for <lists+io-uring@lfdr.de>; Thu, 24 Nov 2022 09:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbiKXIB3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Nov 2022 03:01:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiKXIB2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Nov 2022 03:01:28 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38ED8C6234
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 00:01:28 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.240])
        by gnuweeb.org (Postfix) with ESMTPSA id 9BDE581712;
        Thu, 24 Nov 2022 08:01:24 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1669276888;
        bh=/UbXrvHQTICdm47XpD4CYl+mOolYdxyIGwcPMlD4uQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aWY3iAujm39Y04NEbU9X9BPAjqaQ9dQ0+EuS5d5UuXtO3ABggVI6SCJx7JuDFVp/j
         UDEKtjSqNeyle5uhNJXbj+6V+tbQYZcdvvE+BCxCF8K0HfJpsY1jnAq+0EktsgFACH
         +4TakGUpKlyfWshfo0Pf6r/E3D5ev0M7qrTCfQFWVOXFgWmBB571Nqp2OJd9UOr1P2
         67WW2iuB39ta2vldR5HOHWiaBijx+WxqHg7faEfHCztlO4ZsL3Lhiy4u1QX6CV63Yr
         Z/zwpXYhfkPBNgvVfWPLFzkuWg8CIQfWF1S3x6PcMSeHY7taq7767U8xLYTW+12YpY
         murQWK/JNxsHw==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        VNLX Kernel Department <kernel@vnlx.org>
Subject: [PATCH liburing v1 1/7] liburing.h: Export `__io_uring_flush_sq()` function
Date:   Thu, 24 Nov 2022 15:00:56 +0700
Message-Id: <20221124075846.3784701-2-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221124075846.3784701-1-ammar.faizi@intel.com>
References: <20221124075846.3784701-1-ammar.faizi@intel.com>
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

clang says:

  queue.c:204:10: error: no previous prototype for function \
  '__io_uring_flush_sq' [-Werror,-Wmissing-prototypes] \
  unsigned __io_uring_flush_sq(struct io_uring *ring)
           ^
  queue.c:204:1: note: declare 'static' if the function is not intended \
  to be used outside of this translation unit \
  unsigned __io_uring_flush_sq(struct io_uring *ring)

This function is used by test/iopoll.c, therefore, it can't be static.
Export it.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/include/liburing.h | 1 +
 src/liburing.map       | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 12a703f..c1d8edb 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -237,6 +237,7 @@ int io_uring_register_file_alloc_range(struct io_uring *ring,
 
 int io_uring_get_events(struct io_uring *ring);
 int io_uring_submit_and_get_events(struct io_uring *ring);
+unsigned __io_uring_flush_sq(struct io_uring *ring);
 
 /*
  * io_uring syscalls.
diff --git a/src/liburing.map b/src/liburing.map
index 06c64f8..6b2f4b2 100644
--- a/src/liburing.map
+++ b/src/liburing.map
@@ -67,3 +67,8 @@ LIBURING_2.3 {
 		io_uring_get_events;
 		io_uring_submit_and_get_events;
 } LIBURING_2.2;
+
+LIBURING_2.4 {
+	global:
+		__io_uring_flush_sq;
+} LIBURING_2.3;
-- 
Ammar Faizi

