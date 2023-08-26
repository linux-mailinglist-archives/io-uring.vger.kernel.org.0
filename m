Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABEDE789744
	for <lists+io-uring@lfdr.de>; Sat, 26 Aug 2023 16:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231328AbjHZOSV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 26 Aug 2023 10:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232336AbjHZOSD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 26 Aug 2023 10:18:03 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F71A211B;
        Sat, 26 Aug 2023 07:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1693059477;
        bh=2ci3/TzUgZ042ylTcPOiTHqsCu2NGYka3bxTTS6mPrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=MSCSrMfhxCXcIL8WiZzyKUIpisnRkMpoPVlr6np5PqpnaMapPzQTWdmi7pJ+2hIIn
         upDqD31reoKkw+aysJVs6S15tJx1hSyUWZtzfSUD+gLFC9lwpBDGnK78i3UKlsPG8f
         dFXglA140W/fy3NTr+e4EkjvqlFn6jFjeL5H2kMQWJl+Jkg1uRQ99JtJ+yeVLk2dMd
         4DeiG/1848Ga0a9U5mcwvoY0vseHPsisG3YEIi3SUzbpP1FZCS/B0xpKQ1PT/8Y+Fg
         FO/IOfEUF9NPrlhK3v48L6ybYsMz6mU/aG4VU0Mq9wcUxcSiyPFaEVnNYdWALnLiJO
         fPG3XehRRxiZA==
Received: from localhost.localdomain (unknown [182.253.126.208])
        by gnuweeb.org (Postfix) with ESMTPSA id 4BB7624B1CB;
        Sat, 26 Aug 2023 21:17:53 +0700 (WIB)
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Nicholas Rosenberg <inori@vnlx.org>,
        Michael William Jonathan <moe@gnuweeb.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Breno Leitao <leitao@debian.org>
Subject: [PATCH liburing v1 2/2] liburing-ffi.map: Move `io_uring_prep_sock_cmd()` to v2.5
Date:   Sat, 26 Aug 2023 21:17:34 +0700
Message-Id: <20230826141734.1488852-3-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230826141734.1488852-1-ammarfaizi2@gnuweeb.org>
References: <20230826141734.1488852-1-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_uring_prep_sock_cmd() comes after v2.4 is released, so it should go
to v2.5.

Cc: Breno Leitao <leitao@debian.org>
Fixes: 2459fef094113fc0e4928d9190315852bda3c03a ("io_uring_prep_cmd: Create a new helper for command ops")
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/liburing-ffi.map | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/liburing-ffi.map b/src/liburing-ffi.map
index 7021227d0829335c..69488bf8a7087db8 100644
--- a/src/liburing-ffi.map
+++ b/src/liburing-ffi.map
@@ -160,24 +160,24 @@ LIBURING_2.4 {
 		io_uring_recvmsg_cmsg_nexthdr;
 		io_uring_recvmsg_validate;
 		io_uring_prep_rw;
 		io_uring_prep_timeout;
 		io_uring_prep_linkat;
 		io_uring_prep_write_fixed;
 		io_uring_prep_poll_add;
 		io_uring_buf_ring_mask;
 		io_uring_register_restrictions;
 		io_uring_prep_write;
 		io_uring_prep_recv;
 		io_uring_prep_msg_ring_cqe_flags;
 		io_uring_prep_msg_ring_fd;
 		io_uring_prep_msg_ring_fd_alloc;
 		io_uring_prep_sendto;
-		io_uring_prep_sock_cmd;
 	local:
 		*;
 };
 
 LIBURING_2.5 {
 	global:
 		io_uring_queue_init_mem;
+		io_uring_prep_sock_cmd;
 } LIBURING_2.4;
-- 
Ammar Faizi

