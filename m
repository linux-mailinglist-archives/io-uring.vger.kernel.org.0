Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50A245F4302
	for <lists+io-uring@lfdr.de>; Tue,  4 Oct 2022 14:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbiJDMjS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Oct 2022 08:39:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiJDMjR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Oct 2022 08:39:17 -0400
Received: from michel.telenet-ops.be (michel.telenet-ops.be [IPv6:2a02:1800:110:4::f00:18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C681FD15
        for <io-uring@vger.kernel.org>; Tue,  4 Oct 2022 05:39:15 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed50:e15b:43db:96f7:952f])
        by michel.telenet-ops.be with bizsmtp
        id TofC2800T2GKRF306ofCfo; Tue, 04 Oct 2022 14:39:13 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1ofhCa-000g4l-1i; Tue, 04 Oct 2022 14:39:12 +0200
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1ofhCZ-007mx5-FO; Tue, 04 Oct 2022 14:39:11 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Anuj Gupta <anuj20.g@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH -next] io_uring: Add missing inline to io_uring_cmd_import_fixed() dummy
Date:   Tue,  4 Oct 2022 14:39:10 +0200
Message-Id: <7404b4a696f64e33e5ef3c5bd3754d4f26d13e50.1664887093.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If CONFIG_IO_URING is not set:

    include/linux/io_uring.h:65:12: error: ‘io_uring_cmd_import_fixed’ defined but not used [-Werror=unused-function]
       65 | static int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
	  |            ^~~~~~~~~~~~~~~~~~~~~~~~~

Fix this by adding the missing "inline" keyword.

Fixes: a9216fac3ed8819c ("io_uring: add io_uring_cmd_import_fixed")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 include/linux/io_uring.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index e10c5cc810827ab8..43bc8a2edccf5aa3 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -62,7 +62,7 @@ static inline void io_uring_free(struct task_struct *tsk)
 		__io_uring_free(tsk);
 }
 #else
-static int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
+static inline int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 			      struct iov_iter *iter, void *ioucmd)
 {
 	return -EOPNOTSUPP;
-- 
2.25.1

