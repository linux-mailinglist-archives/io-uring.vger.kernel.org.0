Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD182650F51
	for <lists+io-uring@lfdr.de>; Mon, 19 Dec 2022 16:53:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232699AbiLSPxh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Dec 2022 10:53:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232641AbiLSPxH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Dec 2022 10:53:07 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C307C1B4
        for <io-uring@vger.kernel.org>; Mon, 19 Dec 2022 07:50:39 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.89])
        by gnuweeb.org (Postfix) with ESMTPSA id 12FD08191F;
        Mon, 19 Dec 2022 15:50:36 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1671465039;
        bh=FcFldO2XkCyGQk/T9GzZXEhIxtSmKQMGCrurrZHkRCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mTLapAOBsnSvsIS0Cg9gLq4rO6KJqyL2m0ep2mHMfm9jYtNiVtxizCBtVH6zx+kgQ
         NTk4P1P3bym5JvnSo6Ur0LXh+Hg6ZdOujOzIE9njldWgfhIXSzQn7WrQcb7UT3xky1
         dk53iA75hnPuJYrYzwKfjj7XPifjEgGni8A7olMq+IlQ0MRJ/gFNXna8h8FFqNIHqK
         JRb51LtvZ/rv8H+ntoSMbs9OqTDbk7M45HzzoHI8IpA9hrZVcqaymdyAUXUU5ZZB/5
         H70URctkZnBsbQl7Mgu2r5QbvTWzWFQYBiTZUl+YGDzrXj+ComED+oX6PBPJf+Cfv+
         rDLhDMRk01ZYg==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        VNLX Kernel Department <kernel@vnlx.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Subject: [PATCH liburing v1 4/8] test/ring-leak: Remove a "break" statement in a "for loop"
Date:   Mon, 19 Dec 2022 22:49:56 +0700
Message-Id: <20221219155000.2412524-5-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221219155000.2412524-1-ammar.faizi@intel.com>
References: <20221219155000.2412524-1-ammar.faizi@intel.com>
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

Clang says:

  ring-leak.c:235:21: warning: loop will run at most once \
  (loop increment never executed) [-Wunreachable-code-loop-increment]
          for (i = 0; i < 2; i++) {
                             ^~~

This "break" statement makes the "for loop" meaningless. Remove it. We
are supposed to run the test function with 2 different arguments using
this "for loop".

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 test/ring-leak.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/test/ring-leak.c b/test/ring-leak.c
index f2ba74f..97b5a3f 100644
--- a/test/ring-leak.c
+++ b/test/ring-leak.c
@@ -234,21 +234,20 @@ int main(int argc, char *argv[])
 
 	for (i = 0; i < 2; i++) {
 		bool update = !!(i & 1);
 
 		ret = test_scm_cycles(update);
 		if (ret) {
 			fprintf(stderr, "test_scm_cycles() failed %i\n",
 				update);
 			return 1;
 		}
-		break;
 	}
 
 	if (socketpair(AF_UNIX, SOCK_DGRAM, 0, sp) != 0) {
 		perror("Failed to create Unix-domain socket pair\n");
 		return 1;
 	}
 
 	ring_fd = get_ring_fd();
 	if (ring_fd < 0)
 		return 1;
-- 
Ammar Faizi

