Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7882B62A424
	for <lists+io-uring@lfdr.de>; Tue, 15 Nov 2022 22:31:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238760AbiKOVay (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Nov 2022 16:30:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238744AbiKOVar (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Nov 2022 16:30:47 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A733225CD;
        Tue, 15 Nov 2022 13:30:46 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.117])
        by gnuweeb.org (Postfix) with ESMTPSA id 7DA30815D2;
        Tue, 15 Nov 2022 21:30:43 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1668547846;
        bh=26iFCX8cR32AVALAdkE5K60JTO8wkkvkeG+T6XtVZcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O5OIZror9lxmQ7YS0bjnNs3GN98mD/owZAWYxhcSH+pLXileUTQEdPJv8b09xSyNH
         qhg7GWQyDjJ5YdM4Bq8CXLsV/Ud0mXPOCG5sFLc8WjVIqiDjxX7StphFkfbo6sDqgy
         iEmJVC5vFOMIjGErHbTTCMaBWFFxZ5XyLrVRDyESlSdutijRl1lPpzAlVyYdLfkGHq
         30WxwY2B9DSZHnSzjdh/TWKzCvg5YD3S6/BHQn0XGCeuQlQEW6s6mo658SMk/nHCva
         ZKrVCf930bEg8sko6YtSeZC0+7naGRB0Kj3ENe9mLvH31ciPdwh3RhznanGN8rdBmq
         wUo59XC2yCPXQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Metzmacher <metze@samba.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH v1 2/2] io_uring: uapi: Don't use a zero-size array
Date:   Wed, 16 Nov 2022 04:29:53 +0700
Message-Id: <20221115212614.1308132-3-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221115212614.1308132-1-ammar.faizi@intel.com>
References: <20221115212614.1308132-1-ammar.faizi@intel.com>
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

Don't use a zero-size array because it doesn't allow the user to
compile an app that uses liburing with the `-pedantic-errors` flag:

  io_uring.h:611:28: error: zero size arrays are an extension [-Werror,-Wzero-length-array]

Replace the array size from 0 to 1.

  - No functional change is intended.
  - No struct/union size change.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 include/uapi/linux/io_uring.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 77027cbaf786..0890784fcc9e 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -85,25 +85,25 @@ struct io_uring_sqe {
 			__u16	__pad3[1];
 		};
 	};
 	union {
 		struct {
 			__u64	addr3;
 			__u64	__pad2[1];
 		};
 		/*
 		 * If the ring is initialized with IORING_SETUP_SQE128, then
 		 * this field is used for 80 bytes of arbitrary command data
 		 */
-		__u8	cmd[0];
+		__u8	cmd[1];
 	};
 };
 
 /*
  * If sqe->file_index is set to this for opcodes that instantiate a new
  * direct descriptor (like openat/openat2/accept), then io_uring will allocate
  * an available direct descriptor instead of having the application pass one
  * in. The picked direct descriptor will be returned in cqe->res, or -ENFILE
  * if the space is full.
  */
 #define IORING_FILE_INDEX_ALLOC		(~0U)
 
@@ -599,25 +599,25 @@ struct io_uring_buf {
 struct io_uring_buf_ring {
 	union {
 		/*
 		 * To avoid spilling into more pages than we need to, the
 		 * ring tail is overlaid with the io_uring_buf->resv field.
 		 */
 		struct {
 			__u64	resv1;
 			__u32	resv2;
 			__u16	resv3;
 			__u16	tail;
 		};
-		struct io_uring_buf	bufs[0];
+		struct io_uring_buf	bufs[1];
 	};
 };
 
 /* argument for IORING_(UN)REGISTER_PBUF_RING */
 struct io_uring_buf_reg {
 	__u64	ring_addr;
 	__u32	ring_entries;
 	__u16	bgid;
 	__u16	pad;
 	__u64	resv[3];
 };
 
-- 
Ammar Faizi

