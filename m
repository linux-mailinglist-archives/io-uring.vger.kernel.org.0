Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 292E4667A4C
	for <lists+io-uring@lfdr.de>; Thu, 12 Jan 2023 17:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234146AbjALQGV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Jan 2023 11:06:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231540AbjALQF4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Jan 2023 11:05:56 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 757435B140;
        Thu, 12 Jan 2023 07:57:22 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.184])
        by gnuweeb.org (Postfix) with ESMTPSA id 19B917E74F;
        Thu, 12 Jan 2023 15:57:18 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1673539042;
        bh=UYpDXwZvwHbe48e65mtN6pHUviQzgszbG46MFmI56ik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sNngbj7Vdp6MBFjnWAeXEGwcIs1rDlPB02I2Nmlf6lxcXURCo/d7XOBNMJokkV6iG
         b70hBUw6pFXQygPxdsYIsSd7rTvaO2+dI/jkg5o9ushlJyngq8y/1QKTiG6ms+fLj/
         GYW9a7y75EIecS/Wd7xtYsR/mbCovhcPnMWsoUmQplnQvLXvpl6Fc55AIOcuiPVKJ/
         PtVlxlDUIHwWn4Md4B4EZ0FRsVtpm0U/ZhWH8BL8Db6ZvzC+ZATTJrQWWtynjlEXke
         tEs6FWse9GSIU7ULrgE9rAA8eJeAwD1WZY99gaeCjJZs6ezOZHDGlJvbvtrzZs2mbo
         SnRw74do9Cy5g==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Breno Leitao <leitao@debian.org>,
        Christian Mazakas <christian.mazakas@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        VNLX Kernel Department <kernel@vnlx.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v1 1/4] liburing-ffi.map: Add io_uring_prep_msg_ring_cqe_flags() function
Date:   Thu, 12 Jan 2023 22:57:06 +0700
Message-Id: <20230112155709.303615-2-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230112155709.303615-1-ammar.faizi@intel.com>
References: <20230112155709.303615-1-ammar.faizi@intel.com>
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

Commit 27180d7be059 ("Add io_uring_prep_msg_ring_cqe_flags function")
adds a new inline function in liburing.h, but it doesn't update the
liburing-ffi.map file. Update it.

Cc: Breno Leitao <leitao@debian.org>
Cc: Christian Mazakas <christian.mazakas@gmail.com>
Fixes: 27180d7be059 ("Add io_uring_prep_msg_ring_cqe_flags function")
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/liburing-ffi.map | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/liburing-ffi.map b/src/liburing-ffi.map
index 8dd4641..1a6df50 100644
--- a/src/liburing-ffi.map
+++ b/src/liburing-ffi.map
@@ -164,6 +164,7 @@ LIBURING_2.4 {
 		io_uring_register_restrictions;
 		io_uring_prep_write;
 		io_uring_prep_recv;
+		io_uring_prep_msg_ring_cqe_flags;
 	local:
 		*;
 };
-- 
Ammar Faizi

