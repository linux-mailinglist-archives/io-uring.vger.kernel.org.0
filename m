Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9667659E51C
	for <lists+io-uring@lfdr.de>; Tue, 23 Aug 2022 16:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241264AbiHWObf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Aug 2022 10:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242150AbiHWObO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Aug 2022 10:31:14 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C6D32AAD47;
        Tue, 23 Aug 2022 04:46:55 -0700 (PDT)
Received: from localhost.localdomain (unknown [125.160.110.187])
        by gnuweeb.org (Postfix) with ESMTPSA id BB87A80A73;
        Tue, 23 Aug 2022 11:46:12 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1661255175;
        bh=pGX4zsckZwOQDvfSpRX0gdS/uZ+Tg3WOPnrOcP57hxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uDy5c5XLGAw+LVwg1HTeXn9+XvfRJSQahgt84S30RZu+l+6QJzVPPP8BKSd97hlHc
         Fe1ThsesfAIkQam0uvA2iXZh9k8ZQnv37pBKG6pdqYuRmCr37YRF86w0TLt30HqNJw
         E8cXiViBT0VZ/+oX7+/+32MHkN7LHYcKL8vK4m7yWVpBZBgeMKvtfZV4dF2Pw12cjl
         Q1NEhxnASE8DvjkeJSnZFjJS/cEQ3JBClIckUoek7WaMCkzn3wzEGHEbg8tgwJ56yC
         kGPhQC2I362o2ACY84xu35iVfJmK2mvAy8Y3EXmDaNEwzK6/+NGB9AXIezbaaIZ8Jh
         k9Z52qxnd5J4Q==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Dylan Yudaken <dylany@fb.com>,
        Facebook Kernel Team <kernel-team@fb.com>,
        Kanna Scarlet <knscarlet@gnuweeb.org>
Subject: [PATCH 2/2] io_uring: uapi: Add `extern "C"` in io_uring.h for liburing
Date:   Tue, 23 Aug 2022 18:45:49 +0700
Message-Id: <20220823114337.2858669-3-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220823114337.2858669-1-ammar.faizi@intel.com>
References: <20220823114337.2858669-1-ammar.faizi@intel.com>
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

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Make it easy for liburing to integrate uapi header with the kernel.
Previously, when this header changes, the liburing side can't directly
copy this header file due to some small differences. Sync them.

Link: https://lore.kernel.org/io-uring/f1feef16-6ea2-0653-238f-4aaee35060b6@kernel.dk
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Dylan Yudaken <dylany@fb.com>
Cc: Facebook Kernel Team <kernel-team@fb.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 include/uapi/linux/io_uring.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 1463cfecb56b..9e0b5c8d92ce 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -12,6 +12,10 @@
 #include <linux/types.h>
 #include <linux/time_types.h>
 
+#ifdef __cplusplus
+extern "C" {
+#endif
+
 /*
  * IO submission data structure (Submission Queue Entry)
  */
@@ -661,4 +665,8 @@ struct io_uring_recvmsg_out {
 	__u32 flags;
 };
 
+#ifdef __cplusplus
+}
+#endif
+
 #endif
-- 
Ammar Faizi

