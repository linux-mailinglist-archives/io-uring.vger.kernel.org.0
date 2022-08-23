Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35EEC59E6E3
	for <lists+io-uring@lfdr.de>; Tue, 23 Aug 2022 18:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244207AbiHWQUu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Aug 2022 12:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244422AbiHWQUM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Aug 2022 12:20:12 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3727026F4FD;
        Tue, 23 Aug 2022 05:40:16 -0700 (PDT)
Received: from localhost.localdomain (unknown [125.160.110.187])
        by gnuweeb.org (Postfix) with ESMTPSA id 93C1480A10;
        Tue, 23 Aug 2022 11:46:09 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1661255172;
        bh=qy+DFTSTdukUMNnpchY37kQHjw0XQENf6FETT6MluSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YYPuCMcjprM5xY2JCnMmyayDfoCVN9OB+Zx0Y557+4Iol/M/d88mXxLSm7QQsk+Pt
         yPJzoaKqC+/8PcbzNq8YFLQGVqlhG2aU9MK5ImwVzEMakLCX/5ZwkcPzgXQMq/sl/F
         r+xTEeOnEnedOauDwlNE7U5jeSSBVeA8yTdko8b1iBatN5q9YrjgaomtRhBAAp3+Vj
         hPjd8cpWYgWMUd/jGpydqy4a17f/VNl/XueL46XsJimApGtDrSxqewFjlBBElUy9UP
         YLt418a38JrcOY8l4nKCBj2kWzR//xl6nAKQc2AKlDh7+R+AiCk0l5daCIrJrmy57A
         BuTuJR+VfMFSA==
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
Subject: [PATCH 1/2] MAINTAINERS: Add `include/linux/io_uring_types.h`
Date:   Tue, 23 Aug 2022 18:45:48 +0700
Message-Id: <20220823114337.2858669-2-ammar.faizi@intel.com>
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

File include/linux/io_uring_types.h doesn't have a maintainer, add it
to the io_uring section.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8a5012ba6ff9..6dc55be41420 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10657,6 +10657,7 @@ T:	git git://git.kernel.dk/linux-block
 T:	git git://git.kernel.dk/liburing
 F:	io_uring/
 F:	include/linux/io_uring.h
+F:	include/linux/io_uring_types.h
 F:	include/uapi/linux/io_uring.h
 F:	tools/io_uring/
 
-- 
Ammar Faizi

