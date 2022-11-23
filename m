Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4BE635F0F
	for <lists+io-uring@lfdr.de>; Wed, 23 Nov 2022 14:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237211AbiKWNMY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Nov 2022 08:12:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238776AbiKWNMF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Nov 2022 08:12:05 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3B75F2C27
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 04:54:19 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.240])
        by gnuweeb.org (Postfix) with ESMTPSA id A587D816CA;
        Wed, 23 Nov 2022 12:53:55 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1669208039;
        bh=h0e0JzXCZRXQNtV2/YRT81wAEB+a4lz+1Ph/YPS2pZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rjRDnsUyqje1XFruGHaLkm/SnEOS2Di0qBxqxC8b4hYcvYjR3XBpOhB5ZZzxCloyj
         Y3ezRHNBcBTE9tRr8NYmUEc39bf7sEN/wmula3BPkzy1YRMCrTzbt79IYtIlbDTmX/
         LJt+PAv6QqDqnZCbJg+LvWgj9r/G62Nn25k4TcggifJmrsScFWQO7ZNM1MnqIG40Vf
         TIDClmtDowHQ/Y25V63jkqJR90oDh7217w9+2WpDi2P7/b0ElonoPxtnm3vtE+eChV
         797GmKT/h2w+k6nRDG6erpodGni4Mbu8ooMIM9cN6R+Olh0AemSAMLwrruiHAXtoeQ
         9aEPfWF3XMFwQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Gilang Fachrezy <gilang4321@gmail.com>, kernel@vnlx.org,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH liburing v1 1/5] register: Remove useless branches in {un,}register eventfd
Date:   Wed, 23 Nov 2022 19:53:13 +0700
Message-Id: <20221123124922.3612798-2-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221123124922.3612798-1-ammar.faizi@intel.com>
References: <20221123124922.3612798-1-ammar.faizi@intel.com>
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

IORING_{UN,}REGISTER_EVENTFD and IORING_REGISTER_EVENTFD_ASYNC don't
return a positive value. These branches are useless. Remove them.

[1]: io_eventfd_register
[2]: io_eventfd_unregister

Kernel-code-ref: https://github.com/torvalds/linux/blob/v6.1-rc6/io_uring/io_uring.c#L2511-L2547 [1]
Kernel-code-ref: https://github.com/torvalds/linux/blob/v6.1-rc6/io_uring/io_uring.c#L2549-L2564 [2]
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/register.c | 23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/src/register.c b/src/register.c
index e849825..6cd607e 100644
--- a/src/register.c
+++ b/src/register.c
@@ -208,30 +208,21 @@ int io_uring_unregister_files(struct io_uring *ring)
 
 int io_uring_register_eventfd(struct io_uring *ring, int event_fd)
 {
-	int ret;
-
-	ret = __sys_io_uring_register(ring->ring_fd, IORING_REGISTER_EVENTFD,
-				      &event_fd, 1);
-	return (ret < 0) ? ret : 0;
+	return __sys_io_uring_register(ring->ring_fd, IORING_REGISTER_EVENTFD,
+				       &event_fd, 1);
 }
 
 int io_uring_unregister_eventfd(struct io_uring *ring)
 {
-	int ret;
-
-	ret = __sys_io_uring_register(ring->ring_fd, IORING_UNREGISTER_EVENTFD,
-				      NULL, 0);
-	return (ret < 0) ? ret : 0;
+	return __sys_io_uring_register(ring->ring_fd, IORING_UNREGISTER_EVENTFD,
+				       NULL, 0);
 }
 
 int io_uring_register_eventfd_async(struct io_uring *ring, int event_fd)
 {
-	int ret;
-
-	ret = __sys_io_uring_register(ring->ring_fd,
-				      IORING_REGISTER_EVENTFD_ASYNC, &event_fd,
-				      1);
-	return (ret < 0) ? ret : 0;
+	return __sys_io_uring_register(ring->ring_fd,
+				       IORING_REGISTER_EVENTFD_ASYNC, &event_fd,
+				       1);
 }
 
 int io_uring_register_probe(struct io_uring *ring, struct io_uring_probe *p,
-- 
Ammar Faizi

