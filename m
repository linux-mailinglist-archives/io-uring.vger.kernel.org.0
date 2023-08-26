Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6E9789742
	for <lists+io-uring@lfdr.de>; Sat, 26 Aug 2023 16:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232836AbjHZOSU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 26 Aug 2023 10:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231702AbjHZOR4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 26 Aug 2023 10:17:56 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB7E1BF1;
        Sat, 26 Aug 2023 07:17:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1693059473;
        bh=p9wxPzkBX/U9hsgDc1RfCKBF9rGMqciKdIe84iThn1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=of6eLqFOytrGL0ucnveCNrA8TbPRjZMIUar0YkVazreoEaBO8/5FIeDUfHz/LwHIB
         yJVa/w57CDkp08R2nk5ATk82sdSMDBaeLim6/ZJknGH1BE2BCi+PrQYIKw+mqbvJxW
         ZvAXQFwCXMULcCqyOEVyeoaXAzUVFZqZXf+SpkoPkdh8hViIFTBnaOrnFsoAa5asnX
         9T5ci1k+cXntpnGLtyiFkNvM+XSsNnpTz1xYQ/wqybNnZRL7KvEWhdpMTS00nR9RqF
         JQRlOy5ac8WGmk//ixXOoIWhxDhBEqQ/YqSOFqc5Vgqkdn67sqzw9gcmjYpqUtNHvZ
         J+LHMcTQTj6iA==
Received: from localhost.localdomain (unknown [182.253.126.208])
        by gnuweeb.org (Postfix) with ESMTPSA id 4263124B1C7;
        Sat, 26 Aug 2023 21:17:49 +0700 (WIB)
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Nicholas Rosenberg <inori@vnlx.org>,
        Michael William Jonathan <moe@gnuweeb.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH liburing v1 1/2] liburing.map: Remove `io_uring_queue_init_mem()` from v2.4
Date:   Sat, 26 Aug 2023 21:17:33 +0700
Message-Id: <20230826141734.1488852-2-ammarfaizi2@gnuweeb.org>
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

io_uring_queue_init_mem() comes after 2.4 is released, so it should go
to 2.5, not 2.4.

Fixes: 7449faaf94ddfb5c25a8b6648c22016d880937ff ("setup: add support for io_uring_queue_init_mem()")
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/liburing-ffi.map | 1 -
 src/liburing.map     | 1 -
 2 files changed, 2 deletions(-)

diff --git a/src/liburing-ffi.map b/src/liburing-ffi.map
index debeccde924714fc..7021227d0829335c 100644
--- a/src/liburing-ffi.map
+++ b/src/liburing-ffi.map
@@ -160,25 +160,24 @@ LIBURING_2.4 {
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
-		io_uring_queue_init_mem;
 		io_uring_prep_sock_cmd;
 	local:
 		*;
 };
 
 LIBURING_2.5 {
 	global:
 		io_uring_queue_init_mem;
 } LIBURING_2.4;
diff --git a/src/liburing.map b/src/liburing.map
index 248980ea99eb05f9..8dfd5ea39378c4ae 100644
--- a/src/liburing.map
+++ b/src/liburing.map
@@ -67,22 +67,21 @@ LIBURING_2.3 {
 		io_uring_get_events;
 		io_uring_submit_and_get_events;
 } LIBURING_2.2;
 
 LIBURING_2.4 {
 	global:
 		io_uring_major_version;
 		io_uring_minor_version;
 		io_uring_check_version;
 
 		io_uring_close_ring_fd;
 		io_uring_enable_rings;
 		io_uring_register_restrictions;
 		io_uring_setup_buf_ring;
 		io_uring_free_buf_ring;
-		io_uring_queue_init_mem;
 } LIBURING_2.3;
 
 LIBURING_2.5 {
 	global:
 		io_uring_queue_init_mem;
 } LIBURING_2.4;
-- 
Ammar Faizi

